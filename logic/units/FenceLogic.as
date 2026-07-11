package logic.units
{
   import engine.Isometric;
   import engine.Position;
   import engine.data.MapCell;
   import engine.units.Fence;
   import engine.units.Unit;
   import game.board.UnitAreaBox;
   import game.board.UnitMenuButton;
   import game.my.MyMediator;
   import logic.ActionLogic;
   import logic.BoardLogic;
   import logic.ShopLogic;
   import logic.UnitFactory;
   import proto.game.family_0010.PUserAction;
   import proto.model.PBoardObj;
   import proto.model.PCost;
   import proto.model.PMove;
   import proto.model.PObjType;
   import proto.model.PShopFence;
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class FenceLogic extends AbstractLogic
   {
      
      private static const connectTable:Vector.<uint> = new <uint>[16,18,144,146,48,50,176,178,24,26,152,154,56,58,184,186];
      
      private static const aroundPosList:Vector.<int> = new <int>[-1,0,1,0,0,1,0,-1];
      
      private var posList:Vector.<int>;
      
      public var rowList:Vector.<Fence>;
      
      public var isMultipleBuy:Boolean;
      
      public function FenceLogic()
      {
         super();
      }
      
      public static function finishUpdate(param1:Fence, param2:PShopFence = null) : void
      {
         param1.assignShop(param2 ? param2 : manualProxy.getFenceShop(param1.kind,param1.level + 1));
         param1.stand();
      }
      
      public static function aroundConnect(param1:int, param2:int) : void
      {
         var _loc4_:Fence = null;
         var _loc3_:int = aroundPosList.length - 2;
         while(_loc3_ >= 0)
         {
            _loc4_ = BoardLogic.getBind(param1 + aroundPosList[_loc3_],param2 + aroundPosList[_loc3_ + 1]) as Fence;
            if(_loc4_)
            {
               connect(_loc4_);
            }
            _loc3_ -= 2;
         }
      }
      
      public static function connect(param1:Fence) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = aroundPosList.length - 2;
         while(_loc4_ >= 0)
         {
            if(BoardLogic.getBind(param1.b_x + aroundPosList[_loc4_],param1.b_y + aroundPosList[_loc4_ + 1]) as Fence)
            {
               _loc3_ |= 1 << _loc2_;
            }
            _loc2_++;
            _loc4_ -= 2;
         }
         map.getMapCell(param1.b_x,param1.b_y).walkType = connectTable[_loc3_];
         param1.setConnectIndex(_loc3_);
      }
      
      override public function getMenu(param1:Unit, param2:Vector.<VComponent>) : void
      {
         var _loc5_:UnitMenuButton = null;
         var _loc6_:MapCell = null;
         var _loc3_:PShopFence = manualProxy.getFenceShop(param1.kind,param1.level + 1,true);
         if(Boolean(_loc3_) && (Boolean(_loc3_.sf_can_buy || isMissionEditor)) && !boardMediator.isEditorMode)
         {
            _loc5_ = MyMediator.updateBt;
            _loc5_.applyPrice(_loc3_.sf_price);
            _loc5_.handler = BuildLogic.onUpdate;
            param2.push(_loc5_);
         }
         var _loc4_:int = aroundPosList.length - 2;
         while(_loc4_ >= 0)
         {
            _loc6_ = map.getSafeMapCell(param1.c_x + aroundPosList[_loc4_],param1.c_y + aroundPosList[_loc4_ + 1]);
            if((Boolean(_loc6_)) && _loc6_.unit is Fence)
            {
               _loc5_ = MyMediator.commonBt;
               _loc5_.change("FenceRowIcon",true,Lang.getString("fenceRowBt"),this.onRowSelect);
               param2.push(_loc5_);
               break;
            }
            _loc4_ -= 2;
         }
      }
      
      override public function changeSelect(param1:Unit, param2:Boolean) : void
      {
         if(!param2 && Boolean(this.rowList))
         {
            this.changeRowFilter(false);
            this.rowList = null;
            this.posList = null;
         }
      }
      
      override public function changeMove(param1:Unit, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:Fence = null;
         var _loc5_:UnitAreaBox = null;
         var _loc6_:Position = null;
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:* = 0;
         var _loc13_:Array = null;
         if(this.isMultipleBuy)
         {
            if(!param2)
            {
               this.resetMultipleBuy();
            }
         }
         else if(this.posList)
         {
            if(param2)
            {
               for each(_loc4_ in this.rowList)
               {
                  _loc4_.setConnectIndex(this.posList[0] == 0 ? 3 : 12);
                  aroundConnect(_loc4_.b_x,_loc4_.b_y);
               }
            }
            else
            {
               _loc5_ = boardMediator.unitAreaBox;
               if(_loc5_)
               {
                  _loc5_.x = _loc5_.y = 0;
               }
               _loc6_ = boardMediator.savePos;
               _loc7_ = this.posList[this.posList.length - 1] == 1;
               param2 = !param3 && (_loc7_ || _loc6_.x != param1.b_x || _loc6_.y != param1.b_y);
               if(param2)
               {
                  _loc9_ = [];
               }
               _loc8_ = 0;
               for each(_loc4_ in this.rowList)
               {
                  if(_loc4_ != param1)
                  {
                     if(_loc7_ && !param2)
                     {
                        _loc10_ = this.posList[_loc8_ + 1];
                        _loc11_ = this.posList[_loc8_];
                     }
                     else
                     {
                        _loc10_ = this.posList[_loc8_];
                        _loc11_ = this.posList[_loc8_ + 1];
                     }
                     _loc4_.setGeometry(param1.b_x + _loc10_,param1.b_y + _loc11_,false);
                     boardMediator.applyMoved(_loc4_,false);
                  }
                  if(param2)
                  {
                     if(_loc7_)
                     {
                        _loc10_ = this.posList[_loc8_ + 1];
                        _loc11_ = this.posList[_loc8_];
                     }
                     else
                     {
                        _loc10_ = this.posList[_loc8_];
                        _loc11_ = this.posList[_loc8_ + 1];
                     }
                     _loc9_.push(_loc6_.x + _loc10_,_loc6_.y + _loc11_);
                  }
                  _loc8_ += 2;
               }
               for each(_loc4_ in this.rowList)
               {
                  aroundConnect(_loc4_.b_x,_loc4_.b_y);
               }
               if(param2 && !boardMediator.isEditorMode)
               {
                  _loc12_ = int(this.rowList.length - 1);
                  _loc8_ = _loc12_ * 2;
                  while(_loc12_ >= 0)
                  {
                     _loc4_ = this.rowList[_loc12_];
                     if(_loc4_.b_x == _loc9_[_loc8_] && _loc4_.b_y == _loc9_[_loc8_ + 1])
                     {
                        this.rowList.splice(_loc12_,1);
                        this.posList.splice(_loc8_,2);
                     }
                     else
                     {
                        _loc8_ -= 2;
                     }
                     _loc12_--;
                  }
                  _loc6_.x = param1.b_x;
                  _loc6_.y = param1.b_y;
                  _loc13_ = [];
                  while(this.rowList.length > 0)
                  {
                     _loc8_ = 0;
                     while(_loc8_ < this.rowList.length)
                     {
                        _loc4_ = this.rowList[_loc8_];
                        param2 = true;
                        _loc12_ = int(_loc9_.length - 2);
                        while(_loc12_ >= 0)
                        {
                           if(_loc9_[_loc12_] == _loc4_.b_x && _loc9_[_loc12_ + 1] == _loc4_.b_y)
                           {
                              param2 = false;
                              break;
                           }
                           _loc12_ -= 2;
                        }
                        if(param2)
                        {
                           _loc9_.splice(_loc8_ * 2,2);
                           this.rowList.splice(_loc8_,1);
                           _loc13_.push(PUserAction.MOVE,PMove.create(UnitFactory.getServerObjectId(_loc4_),new Position(_loc4_.b_x,_loc4_.b_y)));
                           break;
                        }
                        _loc8_++;
                     }
                  }
                  ActionLogic.groupRequest(_loc13_);
               }
               this.posList = null;
               this.rowList = null;
            }
         }
         else
         {
            if(param2)
            {
               (param1 as Fence).setConnectIndex(0);
               if(this.rowList)
               {
                  this.changeRowFilter(false);
                  this.rowList = null;
               }
            }
            else
            {
               connect(param1 as Fence);
               boardMediator.syncSelected(param1);
            }
            aroundConnect(param1.b_x,param1.b_y);
         }
      }
      
      override public function onMove(param1:Unit) : void
      {
         if(this.isMultipleBuy)
         {
            this.onMultipleMove(param1);
         }
         else if(this.posList)
         {
            this.onRowMove(param1);
         }
      }
      
      private function onRowMove(param1:Unit) : void
      {
         var _loc3_:Fence = null;
         var _loc2_:uint = 0;
         for each(_loc3_ in this.rowList)
         {
            _loc3_.setGeometry(param1.b_x + this.posList[_loc2_],param1.b_y + this.posList[_loc2_ + 1],true);
            _loc2_ += 2;
         }
      }
      
      private function changeRowFilter(param1:Boolean) : void
      {
         var _loc2_:Fence = null;
         for each(_loc2_ in this.rowList)
         {
            if(param1)
            {
               _loc2_.display.removeFilter(Style.CHOICE_OUT_FILTER);
               _loc2_.display.addFilter(Style.CHOICE_FILTER,true);
            }
            else
            {
               _loc2_.display.removeFilter(Style.CHOICE_FILTER);
               _loc2_.display.removeFilter(Style.CHOICE_OUT_FILTER);
            }
         }
      }
      
      private function onRowSelect(param1:Fence) : void
      {
         var _loc8_:MapCell = null;
         var _loc2_:* = param1.c_x;
         do
         {
            _loc2_--;
         }
         while(_loc8_ = map.getSafeMapCell(_loc2_,param1.c_y), (Boolean(_loc8_)) && _loc8_.unit is Fence);
         _loc2_++;
         var _loc3_:* = param1.c_x;
         do
         {
            _loc3_++;
         }
         while(_loc8_ = map.getSafeMapCell(_loc3_,param1.c_y), (Boolean(_loc8_)) && _loc8_.unit is Fence);
         _loc3_--;
         var _loc4_:* = param1.c_y;
         do
         {
            _loc4_--;
         }
         while(_loc8_ = map.getSafeMapCell(param1.c_x,_loc4_), (Boolean(_loc8_)) && _loc8_.unit is Fence);
         _loc4_++;
         var _loc5_:* = param1.c_y;
         do
         {
            _loc5_++;
         }
         while(_loc8_ = map.getSafeMapCell(param1.c_x,_loc5_), (Boolean(_loc8_)) && _loc8_.unit is Fence);
         _loc5_--;
         this.rowList = new Vector.<Fence>();
         if(_loc5_ - _loc4_ > _loc3_ - _loc2_)
         {
            while(_loc4_ <= _loc5_)
            {
               this.rowList.push(map.getMapCell(param1.c_x,_loc4_).unit as Fence);
               _loc4_++;
            }
         }
         else
         {
            while(_loc2_ <= _loc3_)
            {
               this.rowList.push(map.getMapCell(_loc2_,param1.c_y).unit as Fence);
               _loc2_++;
            }
         }
         this.changeRowFilter(true);
         var _loc6_:VBox = boardMediator.getMenuBox();
         var _loc7_:UnitMenuButton = MyMediator.commonBt;
         _loc7_.argList[0] = param1;
         _loc7_.change("FenceMoveIcon",true,Lang.getString("unit_move"),this.onRowAction);
         _loc6_.add(_loc7_);
         _loc7_ = MyMediator.common2Bt;
         _loc7_.argList[0] = param1;
         _loc7_.change("FenceRotateIcon",true,Lang.getString("unit_rotate"),this.onRowAction,[true]);
         _loc6_.add(_loc7_);
         if(boardMediator.isEditorMode)
         {
            _loc7_ = boardMediator.getEraseBt();
            _loc7_.argList.push(this.rowList);
            _loc6_.add(_loc7_);
         }
         else
         {
            this.syncRowUpdateButton();
         }
         if(Facade.isMissionEditor)
         {
            _loc7_ = new UnitMenuButton(false);
            _loc7_.argList[0] = param1;
            _loc7_.change("CancelIcon",true,Lang.getString("erase_all"),boardMediator.massRemove);
            _loc6_.add(_loc7_);
            _loc7_.argList.push(this.rowList);
         }
         boardMediator.useRowFenceTitle();
      }
      
      private function syncRowUpdateButton() : void
      {
         var _loc4_:Fence = null;
         var _loc5_:UnitMenuButton = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:PShopFence = null;
         var _loc9_:PCost = null;
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         if(isMissionEditor)
         {
            _loc6_ = _loc7_ = uint.MAX_VALUE;
         }
         else
         {
            _loc6_ = userProxy.townHallLevel;
            _loc7_ = references.fence_builder_req_lvl;
         }
         for each(_loc4_ in this.rowList)
         {
            _loc8_ = manualProxy.getFenceShop(_loc4_.kind,_loc4_.level + 1,true);
            if((Boolean(_loc8_)) && Boolean(_loc8_.sf_can_buy) && _loc6_ >= _loc8_.sf_townhall_req)
            {
               if(_loc2_ == 0)
               {
                  _loc1_ = _loc8_.sf_price.variance;
               }
               else if(_loc1_ != _loc8_.sf_price.variance)
               {
                  _loc2_ = 0;
                  break;
               }
               _loc2_ += _loc8_.sf_price.value;
               if(!_loc3_ && _loc4_.level + 1 >= _loc7_)
               {
                  _loc3_ = true;
               }
            }
         }
         _loc5_ = MyMediator.updateBt;
         if(_loc2_ > 0)
         {
            _loc9_ = PCost.create(_loc1_,_loc2_);
            _loc5_.applyPrice(_loc9_);
            _loc5_.handler = this.onRowUpdate;
            _loc5_.argList[0] = _loc9_;
            _loc5_.argList[1] = _loc3_;
            if(!_loc5_.parent)
            {
               boardMediator.getMenuBox(false).add(_loc5_);
            }
         }
         else
         {
            _loc5_.deactivation();
            _loc5_.removeFromParent(false);
         }
      }
      
      private function onRowAction(param1:Fence, param2:Boolean = false) : void
      {
         var _loc5_:Fence = null;
         var _loc6_:UnitAreaBox = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:Vector.<Fence> = this.rowList;
         boardMediator.setSelected(null);
         this.rowList = _loc3_;
         this.posList = new Vector.<int>();
         var _loc4_:uint = _loc3_.length;
         param1 = _loc3_[_loc4_ - 1];
         for each(_loc5_ in _loc3_)
         {
            _loc7_ = _loc5_.b_x - param1.b_x;
            _loc8_ = _loc5_.b_y - param1.b_y;
            if(param2)
            {
               this.posList.push(_loc8_,_loc7_);
            }
            else
            {
               this.posList.push(_loc7_,_loc8_);
            }
            if(_loc5_ != param1)
            {
               boardMediator.applyMoved(_loc5_,true);
            }
         }
         boardMediator.useMoveState(param1,null,null,false);
         boardMediator.useRowFenceTitle();
         _loc6_ = boardMediator.unitAreaBox;
         if(this.posList[0] == 0)
         {
            _loc6_.changeSize(1,_loc4_);
            _loc6_.x = -Isometric.POS_HALF_WIDTH * (_loc4_ - 1);
         }
         else
         {
            _loc6_.changeSize(_loc4_,1);
            _loc6_.x = Isometric.POS_HALF_WIDTH * (_loc4_ - 1);
         }
         _loc6_.y = Isometric.POS_HALF_HEIGHT * (_loc4_ - 1);
         _loc3_[0].display.addChildAt(_loc6_,0);
         boardMediator.onMovePlace();
         this.posList.push(int(param2));
      }
      
      private function onRowUpdate(param1:PCost, param2:Boolean) : void
      {
         mainMediator.showYesNoDialog(Lang.getPatternString("row_fence_update","__PRICE__",(param2 ? StringHelper.getTLFImage("lib,WorkerIcon",26,3) : "") + CostHelper.get18StringC(param1)),this.confirmRowUpdate,[param1,param2],Lang.getString("rowFenceTitle"),SkinManager.getEmbed("UpdateIcon"));
      }
      
      private function confirmRowUpdate(param1:PCost, param2:Boolean = false) : void
      {
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:Fence = null;
         var _loc7_:PShopFence = null;
         if(ShopLogic.checkCostAndWorker(param1,this.confirmRowUpdate,arguments,param2))
         {
            ShopLogic.applyCost(param1,true);
            _loc4_ = [];
            _loc5_ = isMissionEditor ? uint.MAX_VALUE : userProxy.townHallLevel;
            for each(_loc6_ in this.rowList)
            {
               _loc7_ = manualProxy.getFenceShop(_loc6_.kind,_loc6_.level + 1,true);
               if((Boolean(_loc7_)) && Boolean(_loc7_.sf_can_buy) && _loc5_ >= _loc7_.sf_townhall_req)
               {
                  _loc4_.push(PUserAction.UPGRADE,UnitFactory.getServerObjectId(_loc6_));
                  finishUpdate(_loc6_,_loc7_);
               }
            }
            ActionLogic.groupRequest(_loc4_);
            this.syncRowUpdateButton();
         }
      }
      
      public function useMultipleBuy(param1:Fence, param2:Object) : void
      {
         var _loc3_:PShopFence = param2 as PShopFence;
         var _loc4_:Unit = new Fence(_loc3_);
         _loc4_.logic = UnitFactory.fenceLogic;
         boardMediator.addNewObject(_loc4_,false,false);
         boardMediator.useMoveState(_loc4_,param2,_loc3_.sf_price,false);
         _loc4_.display.dispose();
         this.isMultipleBuy = true;
         this.rowList = new <Fence>[param1];
         this.posList = new Vector.<int>();
         var _loc5_:VSkin = SkinManager.getEmbed("Fence");
         _loc5_.setGeometrySize(32,32,true);
         mainPanel.applyCursor(_loc5_);
      }
      
      public function resetMultipleBuy() : void
      {
         mainPanel.applyCursor(null);
         this.isMultipleBuy = false;
         var _loc1_:* = int(this.rowList.length - 1);
         while(_loc1_ > 0)
         {
            UnitFactory.removeConstruction(this.rowList[_loc1_]);
            _loc1_--;
         }
         _loc1_ = int(this.rowList.length - 1);
         while(_loc1_ >= 0)
         {
            aroundConnect(this.rowList[_loc1_].b_x,this.rowList[_loc1_].b_y);
            _loc1_--;
         }
         this.rowList = null;
         this.posList = null;
      }
      
      public function buyRow(param1:PShopFence = null, param2:Vector.<int> = null) : void
      {
         var _loc4_:Fence = null;
         var _loc5_:* = 0;
         var _loc8_:Array = null;
         var _loc9_:Vector.<Fence> = null;
         var _loc10_:PObjType = null;
         var _loc11_:Position = null;
         if(!param2)
         {
            _loc5_ = int(this.rowList.length - 1);
            while(_loc5_ > 0)
            {
               _loc4_ = this.rowList[_loc5_];
               if(_loc4_.display.parent)
               {
                  if(!param2)
                  {
                     param2 = new Vector.<int>();
                  }
                  param2.push(_loc4_.b_x,_loc4_.b_y);
               }
               _loc5_--;
            }
            boardMediator.resetMoved();
            if(param2)
            {
               this.buyRow(_loc4_.shop,param2);
            }
            return;
         }
         var _loc6_:uint = uint(param2.length >> 1);
         var _loc7_:PCost = PCost.create(param1.sf_price.variance,param1.sf_price.value * _loc6_);
         if(isMissionEditor)
         {
            _loc7_.value = 0;
         }
         if(ShopLogic.checkPrice(_loc7_,this.buyRow,arguments))
         {
            ShopLogic.applyCost(_loc7_,true);
            userProxy.changeConstructionCount(param1.sf_kind,_loc6_);
            _loc8_ = [];
            _loc9_ = new Vector.<Fence>();
            _loc10_ = PObjType.create(PObjType.FENCE);
            _loc5_ = int(param2.length - 2);
            while(_loc5_ >= 0)
            {
               _loc11_ = new Position(param2[_loc5_],param2[_loc5_ + 1]);
               _loc8_.push(PUserAction.BUY_OBJECT,PBoardObj.create(_loc10_,param1.sf_kind,_loc11_));
               _loc4_ = UnitFactory.createConstruction(param1,userProxy.constructionId++,_loc11_) as Fence;
               boardMediator.addObject(_loc4_,false,false);
               _loc9_.push(_loc4_);
               _loc5_ -= 2;
            }
            for each(_loc4_ in _loc9_)
            {
               connect(_loc4_);
            }
            _loc5_ = int(param2.length - 2);
            while(_loc5_ >= 0)
            {
               aroundConnect(param2[_loc5_],param2[_loc5_ + 1]);
               _loc5_ -= 2;
            }
            ActionLogic.groupRequest(_loc8_);
            if(userProxy.getConstructionCount(param1.sf_kind) < userProxy.getConstructionMax(param1.sf_kind) && (userProxy.isCost(param1.sf_price) || isMissionEditor))
            {
               ShopLogic.buy(param1);
            }
         }
      }
      
      private function onMultipleMove(param1:Unit) : void
      {
         var _loc2_:* = 0;
         var _loc9_:Fence = null;
         var _loc10_:MapCell = null;
         var _loc11_:int = 0;
         this.posList.length = 0;
         _loc2_ = int(this.rowList.length - 1);
         while(_loc2_ >= 1)
         {
            _loc9_ = this.rowList[_loc2_];
            if(_loc9_.display.parent)
            {
               BoardLogic.bind(_loc9_,false);
               this.posList.push(_loc9_.b_x,_loc9_.b_y);
            }
            _loc2_--;
         }
         var _loc3_:Fence = this.rowList[0];
         var _loc4_:int = Math.abs(_loc3_.b_x - param1.b_x);
         var _loc5_:int = Math.abs(_loc3_.b_y - param1.b_y);
         var _loc6_:Boolean = _loc4_ >= _loc5_;
         if(_loc6_)
         {
            _loc4_ = _loc3_.b_x;
            _loc5_ = param1.b_x;
         }
         else
         {
            _loc4_ = _loc3_.b_y;
            _loc5_ = param1.b_y;
         }
         boardMediator.unitAreaBox.update();
         var _loc7_:Boolean = _loc4_ > _loc5_;
         var _loc8_:uint = isMissionEditor ? uint.MAX_VALUE : uint(userProxy.getConstructionMax(param1.kind) - userProxy.getConstructionCount(param1.kind));
         _loc2_ = 1;
         while(_loc7_ && _loc5_ <= _loc4_ || !_loc7_ && _loc4_ <= _loc5_)
         {
            if(_loc2_ == this.rowList.length)
            {
               _loc9_ = new Fence(_loc3_.shop);
               _loc9_.display.alpha = 0.65;
               this.rowList.push(_loc9_);
            }
            else
            {
               _loc9_ = this.rowList[_loc2_];
            }
            if(_loc6_)
            {
               _loc10_ = map.getSafeMapCell(_loc4_,_loc3_.b_y);
            }
            else
            {
               _loc10_ = map.getSafeMapCell(_loc3_.b_x,_loc4_);
            }
            if(Boolean(_loc10_) && Boolean(!_loc10_.occupied) && map.checkBorder(_loc10_.x,_loc10_.y))
            {
               _loc9_.setGeometry(_loc10_.x,_loc10_.y,false);
               if(_loc9_.display.parent)
               {
                  _loc9_.syncPosition();
               }
               else
               {
                  boardMediator.addObject(_loc9_,false,false);
                  userProxy.fenceList.add(_loc9_);
               }
               _loc11_ = this.posList.length - 2;
               while(_loc11_ >= 0)
               {
                  if(this.posList[_loc11_] == _loc10_.x && this.posList[_loc11_ + 1] == _loc10_.y)
                  {
                     _loc11_ = 0;
                     break;
                  }
                  _loc11_ -= 2;
               }
               if(_loc11_ < 0)
               {
                  this.posList.push(_loc10_.x,_loc10_.y);
               }
               BoardLogic.bind(_loc9_,true);
               _loc2_++;
               if(--_loc8_ == 0)
               {
                  break;
               }
            }
            _loc4_ += _loc7_ ? -1 : 1;
         }
         _loc4_ = _loc2_ - 1;
         _loc5_ = _loc3_.shop.sf_price.value * _loc4_;
         boardMediator.movePanel.showBuyInfo(userProxy.getConstructionCount(_loc3_.kind) + _loc4_,userProxy.getConstructionMax(_loc3_.kind),CostHelper.get18String(_loc3_.shop.sf_price.variance,_loc5_),userProxy.checkCost(_loc3_.shop.sf_price.variance,_loc5_) == 0);
         _loc4_ = int(this.rowList.length);
         while(_loc2_ < _loc4_)
         {
            _loc9_ = this.rowList[_loc2_];
            if(_loc9_.display.parent)
            {
               boardMediator.removeObject(_loc9_);
               userProxy.fenceList.remove(_loc9_);
            }
            _loc2_++;
         }
         _loc2_ = int(this.rowList.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this.rowList[_loc2_];
            if(_loc3_.display.parent)
            {
               connect(_loc3_);
            }
            _loc2_--;
         }
         _loc11_ = this.posList.length - 2;
         while(_loc11_ >= 0)
         {
            aroundConnect(this.posList[_loc11_],this.posList[_loc11_ + 1]);
            _loc11_ -= 2;
         }
      }
   }
}

