package game.board
{
   import engine.Board;
   import engine.Isometric;
   import engine.Map;
   import engine.Position;
   import engine.data.MapCell;
   import engine.display.AnimDisplay;
   import engine.signal.Signal;
   import engine.units.AnimObject;
   import engine.units.Fence;
   import engine.units.Garbage;
   import engine.units.Unit;
   import engine.units.ZObject;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import game.battle.BattleMediator;
   import game.capital.CapitalMediator;
   import game.my.EditorMediator;
   import game.my.MyMediator;
   import logic.ActionLogic;
   import logic.BoardLogic;
   import logic.CoreLogic;
   import logic.UnitFactory;
   import logic.battle.BattleBoardDrop;
   import model.CommonEvent;
   import model.ui.VOBattleItem;
   import proto.game.family_0010.PUserAction;
   import proto.model.PCost;
   import ui.Style;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VText;
   import utils.CostHelper;
   
   public class BoardMediator
   {
      
      public const battleDrop:BattleBoardDrop = new BattleBoardDrop(Facade.board.getVectorG());
      
      public const savePos:Position = new Position();
      
      private var isMoveState:Boolean;
      
      private var overUnit:Unit;
      
      private var selectedUnit:Unit;
      
      private var isDown:Boolean;
      
      private var isClick:Boolean;
      
      private var moveTime:int;
      
      private var moveEvent:MouseEvent;
      
      private var conflictList:Vector.<Unit>;
      
      private var unitShop:Object;
      
      private var isBattleMode:Boolean;
      
      private var isBattleLanding:Boolean;
      
      private var isBattleMoveLock:Boolean;
      
      private var layerPanel:VComponent;
      
      private var moveSignal:Signal;
      
      private var saveBoardPos:Position;
      
      private var editorMediator:EditorMediator;
      
      private var isBattleOver:Boolean;
      
      private const board:Board = Facade.board;
      
      private const testViewRectList:Vector.<AnimObject> = new Vector.<AnimObject>();
      
      private const curPoint:Point = new Point();
      
      private const startPoint:Point = new Point();
      
      private const movePos:Position = new Position(int.MIN_VALUE,int.MIN_VALUE);
      
      private const offsetBPos:Point = new Point();
      
      private const scalePos:Position = new Position(int.MIN_VALUE,int.MIN_VALUE);
      
      private const scalePoint:Point = new Point();
      
      private const tempPos:Position = new Position();
      
      private const tempPoint:Point = new Point();
      
      private const menuPanel:UnitMenuPanel = new UnitMenuPanel();
      
      public var unitAreaBox:UnitAreaBox;
      
      public var isBattleOutside:Boolean = true;
      
      public var isEditorMode:Boolean;
      
      public var spellRadius:int = -1;
      
      public var allowMoveState:Boolean;
      
      public var movePanel:BoardMovePanel;
      
      public function BoardMediator(param1:Loader, param2:VComponent)
      {
         super();
         param1.mouseChildren = param1.mouseEnabled = false;
         this.board.initBg(param1);
         this.board.bgHash["map_bg_default"] = this.board.addChildAt(param1,0);
         this.layerPanel = param2;
         this.board.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         this.board.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.board.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.board.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.board.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.board.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.board.mouseEnabled = false;
         Facade.stage.addEventListener(Event.MOUSE_LEAVE,this.onLeave);
         Facade.addListener(CommonEvent.SHOW_DIALOG,this.onShowDialog);
         this.menuPanel.geometryPhase();
         Facade.stage.addChildAt(this.board,0);
         this.board.setSize(Facade.stage.stageWidth,Facade.stage.stageHeight);
         this.changeViewPort();
      }
      
      public function init(param1:Boolean, param2:Boolean) : void
      {
         if(this.isBattleMode != param1)
         {
            this.isBattleMode = param1;
            this.board.mouseChildren = !param1;
         }
         this.allowMoveState = param2;
         this.board.mouseEnabled = true;
         if(!param1)
         {
            Unit.changeBoardScale(this.board.scaleX);
         }
         if(param1 || !this.saveBoardPos)
         {
            this.moveBoard(Facade.map_sx >> 1,Facade.map_sy >> 1);
         }
         else
         {
            this.moveBoard(this.saveBoardPos.x,this.saveBoardPos.y);
         }
      }
      
      public function clear() : void
      {
         if(this.moveSignal)
         {
            this.moveSignal.stop();
            this.moveSignal = null;
         }
         this.moveEvent = null;
         if(this.isMoveState)
         {
            this.clearMoveState();
         }
         if(this.selectedUnit)
         {
            this.selectedUnit.display.removeFilter(Style.CHOICE_FILTER);
            this.selectedUnit.display.removeFilter(Style.CHOICE_OUT_FILTER);
            this.selectedUnit.setMenu(null);
            this.selectedUnit = null;
         }
         if(this.overUnit)
         {
            this.overUnit.display.removeFilter(Style.SELECT_FILTER);
            this.overUnit = null;
         }
         this.testViewRectList.length = 0;
         this.layerPanel.mouseChildren = true;
         this.isDown = false;
         this.battleDrop.reset();
         this.board.mouseEnabled = false;
         this.clearUnitMenu();
         if(this.isEditorMode)
         {
            this.isEditorMode = false;
            this.editorMediator.clear();
            this.editorMediator = null;
            if(Facade.commonHash[this])
            {
               (Facade.commonHash[this] as UnitMenuButton).dispose();
               delete Facade.commonHash[this];
            }
         }
         if(Facade.isMissionEditor)
         {
            if(Facade.commonHash[this.menuPanel])
            {
               (Facade.commonHash[this.menuPanel] as UnitMenuButton).dispose();
               delete Facade.commonHash[this.menuPanel];
            }
         }
         if(!Facade.isBattle)
         {
            if(this.saveBoardPos)
            {
               this.getCenterPosition(this.saveBoardPos);
            }
            else
            {
               this.saveBoardPos = new Position(Facade.map_sx >> 1,Facade.map_sy >> 1);
            }
         }
      }
      
      public function changeViewPort() : void
      {
         var _loc1_:Rectangle = AnimObject.viewPort;
         var _loc2_:Number = this.board.scaleX;
         _loc1_.x = -(this.board.x / _loc2_);
         _loc1_.y = -(this.board.y / _loc2_);
         _loc1_.width = this.board.w / _loc2_;
         _loc1_.height = this.board.h / _loc2_;
         var _loc3_:* = int(this.testViewRectList.length - 1);
         while(_loc3_ >= 0)
         {
            this.testViewRectList[_loc3_].testViewRect();
            _loc3_--;
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(this.moveSignal)
         {
            this.moveSignal.stop();
            this.moveSignal = null;
         }
         this.layerPanel.mouseChildren = false;
         this.startPoint.x = this.curPoint.x = param1.stageX;
         this.startPoint.y = this.curPoint.y = param1.stageY;
         this.isDown = true;
         this.isClick = true;
         if(this.isBattleMode)
         {
            this.battleDown(this.curPoint);
         }
      }
      
      public function checkClick() : Boolean
      {
         return this.isClick;
      }
      
      private function battleDown(param1:Point) : void
      {
         var _loc3_:MapCell = null;
         var _loc2_:VOBattleItem = Facade.battleMediator.selectItem;
         if(Boolean(_loc2_) && Boolean(_loc2_.shop))
         {
            param1 = this.board.globalToLocal(param1);
            Isometric.screenToPos(param1.x,param1.y,this.tempPos);
            _loc3_ = Facade.map.getSafeMapCell(this.tempPos.x,this.tempPos.y);
            this.isBattleMoveLock = Boolean(_loc3_) && _loc3_.landing || this.isBattleOutside && !_loc3_;
            this.isBattleLanding = this.isBattleMoveLock && _loc2_.count > 0 && this.battleDrop.down(_loc3_,this.tempPos,this.board);
            if(this.isBattleMoveLock)
            {
               if(_loc2_.count == 0)
               {
                  Facade.mainMediator.flightMessage(Lang.getPatternString("drop_soldier_empty","__KIND__",_loc2_.shop.su_kind,true));
               }
               return;
            }
         }
         else
         {
            this.isBattleLanding = false;
         }
         this.isBattleMoveLock = this.allowMoveState;
      }
      
      public function set battleMoveLock(param1:Boolean) : void
      {
         if(this.isBattleMode)
         {
            this.allowMoveState = param1;
         }
      }
      
      public function useMoveState(param1:Unit, param2:Object = null, param3:Object = null, param4:Boolean = true, param5:Boolean = true) : void
      {
         this.moveEvent = null;
         if(this.isMoveState)
         {
            this.clearMoveState();
         }
         else if(this.overUnit)
         {
            this.onMoveOver();
         }
         this.isMoveState = true;
         if(!this.isEditorMode)
         {
            UnitFactory.setPatrolPause(true);
         }
         this.unitShop = param2;
         var _loc6_:Boolean = param2 != null;
         this.overUnit = param1;
         this.board.mouseChildren = false;
         this.setMoved(true,!_loc6_ && param5);
         this.movePanel = new BoardMovePanel(_loc6_,param1.kind,param1.level,this.onCancel);
         if(_loc6_)
         {
            this.setSelected(param1,true);
            this.movePanel.showBuyInfo(Facade.userProxy.getConstructionCount(param1.kind) + 1,Facade.userProxy.getConstructionMax(param1.kind),param3 is PCost ? CostHelper.get18StringC(param3 as PCost) : CostHelper.get18ListString(param3 as Array));
         }
         else
         {
            if(param1 == this.selectedUnit)
            {
               param1.setMenu(null);
               param1.display.removeFilter(Style.CHOICE_FILTER);
               param1.display.removeFilter(Style.CHOICE_OUT_FILTER);
            }
            this.savePos.x = param1.b_x;
            this.savePos.y = param1.b_y;
         }
         Facade.myMediator.myPanel.setCompactMode(true);
         this.layerPanel.add(this.movePanel,this.isEditorMode ? {
            "right":10,
            "bottom":150
         } : {
            "hCenter":0,
            "bottom":10
         });
         if(!_loc6_ && !this.isEditorMode && !Facade.isCapital)
         {
            this.movePanel.useEditorButton(this.useEditorMode);
         }
         if(param4)
         {
            this.onMovePlace();
         }
      }
      
      private function clearMoveState(param1:Boolean = true, param2:Boolean = true) : void
      {
         if(this.unitShop)
         {
            if(UnitFactory.fenceLogic.isMultipleBuy)
            {
               UnitFactory.fenceLogic.resetMultipleBuy();
            }
            this.setMoved(false,!param1);
            if(param1)
            {
               UnitFactory.removeConstruction(this.overUnit);
            }
            Facade.dispatchCommonEvent(CommonEvent.NEW_UNIT,false);
            this.unitShop = null;
         }
         else
         {
            if(param1)
            {
               this.overUnit.move(this.savePos.x,this.savePos.y);
            }
            this.setMoved(false,param2,param1);
         }
         this.clearConflictList();
         if(this.overUnit == this.selectedUnit)
         {
            this.overUnit.display.addFilter(Style.CHOICE_FILTER);
            if(this.menuPanel.isButtons)
            {
               this.board.addChild(this.menuPanel);
               this.overUnit.setMenu(this.menuPanel);
            }
         }
         this.overUnit = null;
         this.board.mouseChildren = true;
         Facade.myMediator.myPanel.setCompactMode(false);
         this.layerPanel.remove(this.movePanel);
         this.movePanel = null;
         this.isMoveState = false;
         if(!this.isEditorMode)
         {
            UnitFactory.setPatrolPause(false);
         }
      }
      
      private function clearConflictList() : void
      {
         var _loc1_:Unit = null;
         if(this.conflictList)
         {
            for each(_loc1_ in this.conflictList)
            {
               _loc1_.display.removeFilter(Style.CONFLICT_FILTER);
            }
            this.conflictList = null;
         }
      }
      
      private function onRollOut(param1:MouseEvent = null) : void
      {
         if(param1)
         {
            this.moveEvent = null;
            if(this.isDown)
            {
               if(param1.relatedObject)
               {
                  this.resetDown();
               }
               else
               {
                  this.moveTime = int.MAX_VALUE;
               }
            }
         }
         if(this.isMoveState)
         {
            this.movePos.y = this.movePos.x = int.MIN_VALUE;
            this.clearConflictList();
         }
         else if(this.overUnit)
         {
            this.onMoveOver();
         }
      }
      
      private function onLeave(param1:Event) : void
      {
         if(this.isDown)
         {
            this.resetDown();
            this.onRollOut();
         }
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         if(this.isDown)
         {
            if(!param1.buttonDown)
            {
               this.resetDown();
               this.onRollOut();
            }
            else
            {
               if(!this.isBattleMode || !this.isBattleLanding)
               {
                  this.curPoint.x = this.startPoint.x = param1.stageX;
                  this.curPoint.y = this.startPoint.y = param1.stageY;
               }
               this.moveTime = 0;
            }
         }
      }
      
      public function resetDown() : void
      {
         this.moveEvent = null;
         this.moveTime = 0;
         if(this.isDown)
         {
            this.isDown = false;
            if(this.isBattleLanding)
            {
               this.isBattleLanding = false;
               this.battleDrop.clear();
            }
            this.layerPanel.mouseChildren = true;
            if(!this.isBattleMode && !this.isEditorMode)
            {
               CoreLogic.pause = false;
            }
            Facade.dispatchCommonEvent(CommonEvent.BOARD_RESET_DOWN);
         }
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(!this.isDown)
         {
            return;
         }
         if(this.isBattleMode)
         {
            if(this.isBattleLanding)
            {
               this.battleDrop.up(this.board.globalToLocal(this.curPoint));
            }
            else if(this.isClick)
            {
               if(Facade.battleMediator.spellSelected)
               {
                  Facade.battleMediator.dropSpell(this.board.globalToLocal(this.curPoint));
               }
            }
            this.resetDown();
            if(this.isBattleOver && !Facade.battleMediator.selectItem)
            {
               this.onMoveOver(param1);
            }
            return;
         }
         this.resetDown();
         var _loc2_:Boolean = this.isMoveState;
         if(this.isClick && this.isMoveState)
         {
            if(UnitFactory.fenceLogic.isMultipleBuy)
            {
               UnitFactory.fenceLogic.buyRow();
            }
            else if(this.onMovePlace(true))
            {
               if(this.isEditorMode)
               {
                  this.editorMediator.onPlace(this.overUnit,true);
               }
               else
               {
                  this.finishMoveUnit(param1);
               }
            }
            else
            {
               Facade.mainMediator.flightMessage(Lang.getString("not_put"));
               Facade.dispatchCommonEvent(CommonEvent.BOARD_NOT_PUT);
            }
            return;
         }
         if(!this.isMoveState)
         {
            this.onMoveOver(param1);
         }
         if(this.isClick)
         {
            if(param1.target is VButton)
            {
               return;
            }
            if(this.overUnit)
            {
               if(this.selectedUnit != this.overUnit)
               {
                  this.setSelected(this.overUnit);
               }
               else if(!_loc2_ && this.allowMoveState && (!(this.overUnit is Garbage) || Facade.isMissionEditor))
               {
                  this.useMoveState(this.overUnit);
               }
            }
            else if(this.selectedUnit)
            {
               this.setSelected(null);
            }
         }
      }
      
      private function finishMoveUnit(param1:MouseEvent) : void
      {
         var _loc2_:Unit = this.overUnit;
         var _loc3_:Object = this.unitShop;
         this.clearMoveState(false);
         if(Boolean(_loc3_) || Boolean(_loc2_.b_x != this.savePos.x) || _loc2_.b_y != this.savePos.y)
         {
            BoardLogic.move(_loc2_,_loc3_);
         }
         if(_loc2_ == this.selectedUnit && !_loc3_)
         {
            this.setSelected(null);
            this.onMoveOver(param1);
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = getTimer();
         if(_loc2_ >= this.moveTime)
         {
            this.moveTime = _loc2_ + (this.isDown && !this.isBattleMode ? 60 : 100);
            this.moveEvent = null;
            this.applyMouseMove(param1);
         }
         else
         {
            this.moveEvent = param1;
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(this.moveEvent)
         {
            _loc2_ = getTimer();
            if(_loc2_ >= this.moveTime)
            {
               this.moveTime = _loc2_ + (this.isDown && !this.isBattleMode ? 60 : 100);
               this.applyMouseMove(this.moveEvent);
               this.moveEvent = null;
            }
         }
      }
      
      private function applyMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.isDown)
         {
            if(this.isBattleMode)
            {
               if(this.isBattleLanding)
               {
                  this.curPoint.x = param1.stageX;
                  this.curPoint.y = param1.stageY;
                  this.battleDrop.move(this.board.globalToLocal(this.curPoint));
                  return;
               }
               if(this.isBattleMoveLock)
               {
                  return;
               }
            }
            _loc2_ = param1.stageX;
            _loc3_ = param1.stageY;
            if(this.curPoint.x != _loc2_ || this.curPoint.y != _loc3_)
            {
               if(this.isClick)
               {
                  this.isClick = false;
                  if(!this.isBattleMode && !this.isEditorMode)
                  {
                     CoreLogic.pause = true;
                  }
               }
               this.board.move(this.board.x + (_loc2_ - this.curPoint.x) * 2,this.board.y + (_loc3_ - this.curPoint.y) * 2);
               this.curPoint.x = _loc2_;
               this.curPoint.y = _loc3_;
               this.changeViewPort();
               if(!this.isMoveState)
               {
                  if(this.overUnit)
                  {
                     this.onRollOut();
                  }
               }
            }
         }
         if(this.isBattleMode)
         {
            this.battleMouseMove(param1);
         }
         else if(this.isMoveState)
         {
            this.onMovePlace();
         }
         else if(!this.isDown)
         {
            this.onMoveOver(param1);
         }
      }
      
      private function battleMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:BattleMediator = Facade.battleMediator;
         var _loc3_:VOBattleItem = _loc2_.selectItem;
         if(Boolean(_loc3_) && (Boolean(_loc3_.spellShop) || Boolean(!this.isDown)))
         {
            this.tempPoint.x = param1.stageX;
            this.tempPoint.y = param1.stageY;
            if(_loc3_.shop)
            {
               _loc2_.checkLanding(this.board.globalToLocal(this.tempPoint),this.tempPos,this.isBattleOutside);
            }
            else if(this.spellRadius >= 0)
            {
               this.battleDrop.spellMove(this.board.globalToLocal(this.tempPoint),this.spellRadius,_loc3_.spellShop.ssp_effect.variance,_loc2_.isBoss);
            }
         }
         if(this.isBattleOver && !_loc3_ && !this.isDown)
         {
            this.onMoveOver(param1);
         }
      }
      
      private function searchUnit(param1:MouseEvent) : Unit
      {
         var _loc5_:AnimDisplay = null;
         var _loc6_:Unit = null;
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(_loc2_ != this.board)
         {
            _loc5_ = _loc2_.parent as AnimDisplay;
            if(!((Boolean(_loc5_)) && _loc5_.isScene(_loc2_)))
            {
               return null;
            }
            _loc6_ = _loc5_.animObj as Unit;
         }
         this.tempPoint.x = param1.stageX;
         this.tempPoint.y = param1.stageY;
         var _loc3_:Point = this.board.globalToLocal(this.tempPoint);
         Isometric.screenToPos(_loc3_.x,_loc3_.y,this.tempPos);
         var _loc4_:Unit = BoardLogic.getBind(this.tempPos.x,this.tempPos.y);
         if((Boolean(_loc4_)) && _loc4_.display.isActive)
         {
            return _loc4_;
         }
         return Boolean(_loc6_) && _loc6_.checkHit(_loc3_.x - _loc6_.display.x,_loc3_.y - _loc6_.display.y) ? _loc6_ : null;
      }
      
      private function onMoveOver(param1:MouseEvent = null) : void
      {
         var _loc2_:Unit = param1 ? this.searchUnit(param1) : null;
         if(this.overUnit != _loc2_)
         {
            if(this.overUnit)
            {
               if(this.overUnit != this.selectedUnit)
               {
                  this.overUnit.display.removeFilter(Style.SELECT_FILTER);
               }
               else
               {
                  this.overUnit.display.removeFilter(Style.CHOICE_FILTER);
                  this.overUnit.display.addFilter(Style.CHOICE_OUT_FILTER,true);
               }
               this.overUnit.logic.changeOver(this.overUnit,false);
            }
            if(_loc2_)
            {
               this.overUnit = _loc2_;
               if(_loc2_ != this.selectedUnit)
               {
                  _loc2_.display.addFilter(Style.SELECT_FILTER);
               }
               else
               {
                  this.overUnit.display.addFilter(Style.CHOICE_FILTER,true);
                  this.overUnit.display.removeFilter(Style.CHOICE_OUT_FILTER);
               }
               _loc2_.logic.changeOver(_loc2_,true);
            }
            else
            {
               this.overUnit = null;
            }
         }
      }
      
      public function onMovePlace(param1:Boolean = false) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:MapCell = null;
         var _loc15_:Unit = null;
         if(param1)
         {
            _loc2_ = this.overUnit.b_x;
            _loc3_ = this.overUnit.b_y;
         }
         else
         {
            Isometric.screenToPos(this.board.mouseX + this.offsetBPos.x,this.board.mouseY + this.offsetBPos.y,this.tempPos);
            if(this.tempPos.x == this.movePos.x && this.tempPos.y == this.movePos.y)
            {
               return false;
            }
            _loc2_ = this.movePos.x = this.tempPos.x;
            _loc3_ = this.movePos.y = this.tempPos.y;
            this.overUnit.move(_loc2_,_loc3_);
         }
         var _loc4_:int = this.unitAreaBox.sx - 1;
         var _loc5_:int = this.unitAreaBox.sy - 1;
         var _loc6_:Vector.<Unit> = null;
         this.unitAreaBox.resetCheck();
         var _loc7_:Boolean = true;
         var _loc8_:uint = 0;
         var _loc9_:Map = Facade.map;
         var _loc10_:int = 0;
         while(_loc10_ <= _loc5_)
         {
            _loc11_ = _loc3_ - _loc10_;
            _loc12_ = 0;
            while(_loc12_ <= _loc4_)
            {
               _loc13_ = _loc2_ - _loc12_;
               if(!_loc9_.checkBorder(_loc13_,_loc11_))
               {
                  _loc7_ = false;
               }
               else
               {
                  _loc14_ = _loc9_.getMapCell(_loc13_,_loc11_);
                  if(_loc14_.occupied)
                  {
                     _loc7_ = false;
                     if(!param1 && Boolean(_loc14_.unit))
                     {
                        _loc15_ = _loc14_.unit;
                        if(!_loc6_)
                        {
                           _loc6_ = new Vector.<Unit>();
                        }
                        if(_loc6_.indexOf(_loc15_) < 0)
                        {
                           _loc6_.push(_loc15_);
                           _loc13_ = this.conflictList ? int(this.conflictList.indexOf(_loc15_)) : -1;
                           if(_loc13_ >= 0)
                           {
                              this.conflictList[_loc13_] = null;
                           }
                           else
                           {
                              _loc15_.display.addFilter(Style.CONFLICT_FILTER);
                           }
                        }
                     }
                  }
                  else
                  {
                     this.unitAreaBox.checkList[_loc8_] = true;
                  }
               }
               _loc8_++;
               _loc12_++;
            }
            _loc10_++;
         }
         if(!param1)
         {
            for each(_loc15_ in this.conflictList)
            {
               if(_loc15_)
               {
                  _loc15_.display.removeFilter(Style.CONFLICT_FILTER);
               }
            }
            this.conflictList = _loc6_;
            this.unitAreaBox.update();
            this.overUnit.logic.onMove(this.overUnit);
            BoardLogic.updateLanding();
         }
         return _loc7_;
      }
      
      public function changeZoom(param1:Number) : void
      {
         if(this.board.scaleX != param1)
         {
            if(this.scalePoint.x != this.board.x || this.scalePoint.y != this.board.y)
            {
               this.getCenterPosition(this.scalePos);
            }
            this.board.scaleX = param1;
            this.board.scaleY = param1;
            this.board.updateScale(this.scalePos.x,this.scalePos.y);
            this.scalePoint.x = this.board.x;
            this.scalePoint.y = this.board.y;
            this.changeViewPort();
            if(!this.isBattleMode)
            {
               Unit.changeBoardScale(param1);
            }
         }
      }
      
      public function moveBoard(param1:int, param2:int) : void
      {
         if(this.moveSignal)
         {
            this.moveSignal.stop();
            this.moveSignal = null;
         }
         this.board.toPosition(param1,param2);
         this.changeViewPort();
      }
      
      public function getCenterPosition(param1:Position) : void
      {
         Isometric.screenToPos((this.board.w / 2 - this.board.x) / this.board.scaleX,(this.board.h / 2 - this.board.y) / this.board.scaleY,param1);
      }
      
      public function addObject(param1:ZObject, param2:Boolean = false, param3:Boolean = true) : void
      {
         param1.syncPosition();
         this.board.add(param1,param2);
         if(param3)
         {
            param1.stand();
         }
         this.testViewRectList.push(param1);
      }
      
      public function addTile(param1:String, param2:String, param3:int, param4:int, param5:Boolean = false) : AnimObject
      {
         var _loc6_:AnimObject = new AnimObject();
         _loc6_.applyKind(param1,param5 ? AnimObject.RIGHT_DOWN : AnimObject.LEFT_DOWN);
         _loc6_.goAnim(param2);
         this.testViewRectList.push(_loc6_);
         Isometric.posToScreen(param3,param4,this.tempPoint);
         _loc6_.display.setPos(this.tempPoint.x,this.tempPoint.y);
         _loc6_.testViewRect();
         this.board.tilePanel.addChildAt(_loc6_.display,0);
         return _loc6_;
      }
      
      public function removeTile(param1:AnimObject) : void
      {
         var _loc2_:int = 0;
         if(param1.display.parent == this.board.tilePanel)
         {
            _loc2_ = this.testViewRectList.indexOf(param1);
            if(_loc2_ >= 0)
            {
               this.testViewRectList.splice(_loc2_,1);
            }
            this.board.tilePanel.removeChild(param1.display);
         }
      }
      
      public function addNewObject(param1:Unit, param2:Boolean, param3:Boolean = true) : void
      {
         this.addObject(param1,param2,param3);
         Isometric.screenToPos(this.board.mouseX,this.board.mouseY,this.tempPos);
         param1.setGeometry(this.tempPos.x,this.tempPos.y,true);
      }
      
      public function removeObject(param1:Unit) : void
      {
         if(!param1.display.parent)
         {
            return;
         }
         if(param1 == this.overUnit)
         {
            this.onRollOut();
         }
         if(this.moveEvent)
         {
            if((this.moveEvent.target as DisplayObject).parent == param1.display)
            {
               this.moveEvent = null;
            }
         }
         var _loc2_:int = this.testViewRectList.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.testViewRectList.splice(_loc2_,1);
         }
         if(param1 == this.selectedUnit)
         {
            this.setSelected(null);
         }
         this.board.remove(param1);
      }
      
      private function setMoved(param1:Boolean, param2:Boolean = true, param3:Boolean = false) : void
      {
         if(param1)
         {
            if(!this.unitAreaBox)
            {
               this.unitAreaBox = new UnitAreaBox();
            }
            this.unitAreaBox.assign(this.overUnit);
         }
         else if(this.unitAreaBox)
         {
            this.unitAreaBox.assign(null);
         }
         if(param1 || param2)
         {
            this.applyMoved(this.overUnit,param1,param2);
            this.overUnit.logic.changeMove(this.overUnit,param1,param3);
         }
         if(param1)
         {
            BoardLogic.updateLanding();
         }
         else
         {
            this.board.removeLanding();
         }
      }
      
      public function applyMoved(param1:Unit, param2:Boolean, param3:Boolean = true) : void
      {
         if(param3)
         {
            BoardLogic.bind(param1,!param2);
         }
         param1.display.alpha = param2 ? 0.65 : 1;
         param1.configViewRect(!param2);
         param1.display.pauseAll(param2);
         if(param2)
         {
            if(param3 && param1.display.viewRect.contains(param1.display.mouseX,param1.display.mouseY))
            {
               Isometric.posToScreen(param1.b_x,param1.b_y,this.tempPoint);
               this.offsetBPos.x = this.tempPoint.x - this.board.mouseX;
               this.offsetBPos.y = this.tempPoint.y - this.board.mouseY;
            }
            else
            {
               this.offsetBPos.x = this.offsetBPos.y = 0;
            }
            this.board.remove(param1);
            this.board.addChild(param1.display);
         }
         else if(param3)
         {
            this.board.add(param1,false);
            param1.syncPosition();
         }
      }
      
      public function resetMoved() : void
      {
         if(this.isMoveState)
         {
            this.clearMoveState();
         }
      }
      
      public function setSelected(param1:Unit, param2:Boolean = false) : void
      {
         if(param1 == this.selectedUnit)
         {
            return;
         }
         var _loc3_:Unit = this.selectedUnit;
         var _loc4_:Boolean = Facade.isMyMap || Facade.isCapital && CapitalMediator.instance.getAllowEdit();
         this.selectedUnit = param1;
         if(_loc3_)
         {
            _loc3_.display.removeFilter(Style.CHOICE_FILTER);
            _loc3_.display.removeFilter(Style.CHOICE_OUT_FILTER);
            _loc3_.setMenu(null);
            if(_loc4_)
            {
               _loc3_.logic.changeSelect(_loc3_,false);
            }
         }
         if(param1)
         {
            this.menuPanel.text.value = Lang.getString(param1.kind);
            this.menuPanel.level = param1.level;
            if(!param2)
            {
               param1.display.removeFilter(Style.SELECT_FILTER,false);
               param1.display.addFilter(Style.CHOICE_FILTER);
               this.updateUnitMenu(param1);
               if(this.menuPanel.isButtons)
               {
                  this.board.addChild(this.menuPanel);
                  param1.setMenu(this.menuPanel);
                  this.checkSelectedViewRect();
               }
            }
            if(_loc4_)
            {
               param1.logic.changeSelect(param1,true);
            }
         }
      }
      
      private function checkSelectedViewRect() : void
      {
         var _loc1_:Number = 98;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Rectangle = this.menuPanel.getRect(Facade.stage);
         if(_loc4_.x < _loc1_)
         {
            _loc2_ = _loc1_ - _loc4_.x;
         }
         else if(_loc4_.right > this.board.w - _loc1_)
         {
            _loc2_ = this.board.w - _loc1_ - _loc4_.right;
         }
         if(_loc4_.y < _loc1_)
         {
            _loc3_ = _loc1_ - _loc4_.y;
         }
         else
         {
            _loc3_ = this.selectedUnit.display.y * this.board.scaleY + this.board.y;
            if(_loc3_ > this.board.h - _loc1_)
            {
               _loc3_ = this.board.h - _loc1_ - _loc3_;
            }
            else
            {
               _loc3_ = 0;
            }
         }
         if(_loc2_ != 0 || _loc3_ != 0)
         {
            this.startSmoothMoveBoard(this.board.x + _loc2_,this.board.y + _loc3_,0.3,0.05);
         }
      }
      
      public function getSelected() : Unit
      {
         return this.selectedUnit;
      }
      
      public function getMenuBox(param1:Boolean = true) : VBox
      {
         if(param1)
         {
            this.updateUnitMenu(null);
         }
         return this.menuPanel.btBox;
      }
      
      public function syncSelected(param1:Unit = null) : void
      {
         if(this.selectedUnit)
         {
            if(!param1 || param1 == this.selectedUnit)
            {
               this.menuPanel.level = this.selectedUnit.level;
               this.updateUnitMenu(this.selectedUnit);
               if(this.menuPanel.isButtons != Boolean(this.menuPanel.parent))
               {
                  if(this.menuPanel.isButtons)
                  {
                     this.board.addChild(this.menuPanel);
                     this.selectedUnit.setMenu(this.menuPanel);
                  }
                  else
                  {
                     this.selectedUnit.setMenu(null);
                  }
               }
            }
         }
      }
      
      public function resetSelected(param1:Unit = null) : void
      {
         if(this.selectedUnit)
         {
            if(!param1 || param1 == this.selectedUnit)
            {
               this.setSelected(null);
            }
         }
      }
      
      private function onCancel(param1:MouseEvent) : void
      {
         if(this.isEditorMode)
         {
            this.editorMediator.onPlace(this.overUnit,false);
         }
         else
         {
            this.clearMoveState();
         }
      }
      
      private function onShowDialog(param1:CommonEvent) : void
      {
         if(this.isEditorMode)
         {
            this.editorMediator.resetSelect();
         }
         this.resetDown();
         if(this.isMoveState)
         {
            this.clearMoveState();
         }
         else if(this.overUnit)
         {
            this.onMoveOver();
         }
      }
      
      public function smoothMoveBoard(param1:int, param2:int, param3:Number = 0.8, param4:Number = 0.06) : void
      {
         Isometric.posToScreen(param1,param2,this.tempPoint);
         this.startSmoothMoveBoard(-(this.tempPoint.x * this.board.scaleX - this.board.w / 2),-(this.tempPoint.y * this.board.scaleY - this.board.h / 2),param3,param4);
      }
      
      private function startSmoothMoveBoard(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:Vector.<Number> = null;
         if(Math.abs(param1 - this.board.x) < 10 && Math.abs(param2 - this.board.y) < 10)
         {
            if(this.moveSignal)
            {
               this.moveSignal.stop();
               this.moveSignal = null;
            }
            return;
         }
         if(!this.moveSignal)
         {
            this.moveSignal = new Signal(this.onMoveSignal);
            _loc5_ = new Vector.<Number>(4,true);
            this.moveSignal.data = _loc5_;
         }
         else
         {
            _loc5_ = this.moveSignal.data as Vector.<Number>;
         }
         this.moveSignal.delay = param4;
         _loc5_[0] = this.board.x;
         _loc5_[1] = this.board.y;
         _loc5_[2] = param1;
         _loc5_[3] = param2;
         this.moveSignal.run(param3);
      }
      
      private function onMoveSignal() : void
      {
         var _loc1_:Number = this.moveSignal.passedRate;
         var _loc2_:Vector.<Number> = this.moveSignal.data as Vector.<Number>;
         this.board.move(_loc2_[0] + (_loc2_[2] - _loc2_[0]) * _loc1_,_loc2_[1] + (_loc2_[3] - _loc2_[1]) * _loc1_);
         this.changeViewPort();
         if(_loc1_ == 1)
         {
            this.moveSignal = null;
         }
      }
      
      public function useRowFenceTitle() : void
      {
         var _loc1_:String = Lang.getString("rowFenceTitle");
         if(this.menuPanel.parent)
         {
            this.menuPanel.level = 0;
            this.menuPanel.text.value = _loc1_;
         }
         if(this.movePanel)
         {
            if(this.movePanel.titleBox.list.length > 1)
            {
               this.movePanel.titleBox.removeAt(1);
            }
            (this.movePanel.titleBox.list[0] as VText).value = _loc1_;
         }
      }
      
      public function checkNewUnit() : Boolean
      {
         return this.isMoveState && Boolean(this.unitShop);
      }
      
      private function clearUnitMenu() : void
      {
         var _loc1_:UnitMenuButton = null;
         for each(_loc1_ in this.menuPanel.btBox.list)
         {
            if(_loc1_.isWeak)
            {
               _loc1_.dispose();
            }
            else
            {
               _loc1_.deactivation();
            }
         }
         this.menuPanel.btBox.removeAll(false);
      }
      
      private function updateUnitMenu(param1:Unit) : void
      {
         var _loc3_:UnitMenuButton = null;
         this.clearUnitMenu();
         if(!param1)
         {
            return;
         }
         var _loc2_:Vector.<VComponent> = this.menuPanel.btBox.list;
         if(this.allowMoveState && (!this.isEditorMode || param1 is Fence))
         {
            param1.logic.getMenu(param1,_loc2_);
         }
         if(Facade.isMissionEditor)
         {
            _loc3_ = Facade.commonHash[this.menuPanel];
            if(!_loc3_)
            {
               _loc3_ = new UnitMenuButton(false);
               _loc3_.change("NoIcon",true,"Удалить ВСЕ",null);
               Facade.commonHash[this.menuPanel] = _loc3_;
            }
            _loc3_.handler = BoardLogic.onRemove;
            _loc2_.push(_loc3_);
         }
         if(this.isEditorMode)
         {
            _loc2_.push(this.getEraseBt());
         }
         if(_loc2_.length < 4 && param1.stamina > 0 && !this.isEditorMode)
         {
            _loc2_.unshift(MyMediator.infoBt);
            MyMediator.infoBt.handler = BoardLogic.onInfo;
         }
         if(_loc2_.length > 0)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc3_.argList[0] = param1;
            }
            this.menuPanel.btBox.addAll();
         }
      }
      
      public function getEraseBt() : UnitMenuButton
      {
         var _loc1_:UnitMenuButton = Facade.commonHash[this];
         if(!_loc1_)
         {
            _loc1_ = new UnitMenuButton(false);
            _loc1_.change("CancelIcon",true,Lang.getString("erase"),null);
            Facade.commonHash[this] = _loc1_;
         }
         _loc1_.handler = this.editorMediator.onErase;
         return _loc1_;
      }
      
      public function useEditorMode(param1:MouseEvent = null) : void
      {
         this.setSelected(null);
         if(this.isMoveState)
         {
            this.clearMoveState();
         }
         this.isEditorMode = true;
         this.editorMediator = new EditorMediator(this.clearMoveState);
         this.editorMediator.init();
      }
      
      public function setBattleOver(param1:Boolean) : void
      {
         if(param1 != this.isBattleOver)
         {
            this.isBattleOver = param1;
            if(!param1 && Boolean(this.overUnit))
            {
               this.onMoveOver(null);
            }
         }
      }
      
      public function massRemove(param1:Unit, param2:Vector.<Fence> = null) : void
      {
         this.resetSelected();
         if(param2)
         {
            for each(param1 in param2)
            {
               ActionLogic.request(PUserAction.DELETE_OBJECT,UnitFactory.getServerObjectId(param1));
               UnitFactory.removeConstruction(param1);
            }
         }
      }
   }
}

