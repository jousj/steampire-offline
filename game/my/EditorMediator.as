package game.my
{
   import engine.Isometric;
   import engine.Position;
   import engine.signal.Signal;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Decor;
   import engine.units.Fence;
   import engine.units.Garbage;
   import engine.units.Unit;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import game.board.BoardMediator;
   import game.feature.TownHallRenderer;
   import logic.ActionLogic;
   import logic.BoardLogic;
   import logic.CoreLogic;
   import logic.EventLogic;
   import logic.MainLogic;
   import logic.UnitFactory;
   import logic.training.AbstractTrain;
   import logic.units.BuildLogic;
   import logic.units.CannonLogic;
   import logic.units.FenceLogic;
   import logic.units.SegmentLogic;
   import model.UserProxy;
   import model.ui.VOTownHallItem;
   import model.vo.MapAction;
   import proto.game.family_0010.Packet_0010_0D;
   import proto.model.PBuilding;
   import proto.model.PCannon;
   import proto.model.PDecor;
   import proto.model.PFence;
   import proto.model.PMove;
   import ui.vbase.VButton;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   
   public class EditorMediator
   {
      
      private const bm:BoardMediator = Facade.boardMediator;
      
      private const up:UserProxy = Facade.userProxy;
      
      private const editorPanel:EditorPanel = new EditorPanel();
      
      private const dp:Array = [];
      
      private const dict:Dictionary = new Dictionary();
      
      private const tempPos:Position = new Position();
      
      private var clearMoveState:Function;
      
      private var selectUnit:Unit;
      
      private var fenceLink:Unit;
      
      private var segmentLogic:SegmentLogic;
      
      private var isEdit:Boolean;
      
      public function EditorMediator(param1:Function)
      {
         super();
         this.clearMoveState = param1;
         this.editorPanel.eraseAllBt.addClickListener(this.onEraseAll);
         this.editorPanel.eraseFenceBt.addClickListener(this.onEraseAll,Fence);
         this.editorPanel.saveBt.addClickListener(this.onSave);
         this.editorPanel.exitBt.addClickListener(this.onExit);
         this.editorPanel.grid.setDataProvider(this.dp);
         this.editorPanel.grid.addListener(VEvent.SELECT,this.onSelect);
      }
      
      public function init() : void
      {
         var _loc2_:Unit = null;
         var _loc3_:* = 0;
         Facade.gameStream.clear();
         AbstractTrain.clear();
         Facade.questMediator.clear();
         Facade.myMediator.clear();
         var _loc1_:Vector.<MapAction> = CoreLogic.getActionList(ActionLogic.CLEANUP_GARBAGE);
         CoreLogic.resetActions();
         if(_loc1_)
         {
            _loc3_ = int(_loc1_.length - 1);
            while(_loc3_ >= 0)
            {
               CoreLogic.addAction(_loc1_[_loc3_],_loc1_[_loc3_].time);
               _loc3_--;
            }
         }
         Facade.mainPanel.showCommonPanel(this.editorPanel);
         for each(_loc2_ in this.up.constructionHash)
         {
            _loc2_.setStatus(null,true);
            if(_loc2_ is Garbage)
            {
               if(!Facade.isMissionEditor)
               {
                  _loc2_.display.setInactive(true);
               }
            }
            else
            {
               _loc2_.setProgress(null);
            }
         }
         UnitFactory.buildLogic.stopExAnimation();
         UnitFactory.clearPatrol();
         _loc2_ = this.up.workerList.head as Unit;
         while(_loc2_)
         {
            this.bm.removeObject(_loc2_);
            _loc2_.dispose();
            _loc2_ = _loc2_.link_next as Unit;
         }
         this.up.workerList.clear();
         if(this.up.buyOfferList)
         {
            this.initBuyOfferList(this.up.buyOfferList);
         }
         this.syncEraseBt();
         Signal.createRef(this.editorPanel,EventLogic.sync,0,240,false).run(0,Number.MAX_VALUE);
      }
      
      private function initBuyOfferList(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:TownHallRenderer = null;
         var _loc5_:Unit = null;
         var _loc6_:PBuilding = null;
         var _loc7_:uint = 0;
         var _loc8_:PCannon = null;
         var _loc9_:PFence = null;
         var _loc10_:PDecor = null;
         var _loc2_:Position = new Position(-1,-1);
         for each(_loc3_ in param1)
         {
            if(_loc3_ is PBuilding)
            {
               _loc6_ = _loc3_ as PBuilding;
               _loc3_ = Facade.manualProxy.getBuildShop(_loc6_.building_kind,_loc6_.building_level);
               _loc7_ = _loc6_.building_id;
            }
            else if(_loc3_ is PCannon)
            {
               _loc8_ = _loc3_ as PCannon;
               _loc3_ = Facade.manualProxy.getCannonShop(_loc8_.cannon_kind,_loc8_.cannon_level);
               _loc7_ = _loc8_.cannon_id;
            }
            else if(_loc3_ is PFence)
            {
               _loc9_ = _loc3_ as PFence;
               _loc3_ = Facade.manualProxy.getFenceShop(_loc9_.fence_kind,_loc9_.fence_level);
               _loc7_ = _loc9_.fence_id;
            }
            else
            {
               if(!(_loc3_ is PDecor))
               {
                  continue;
               }
               _loc10_ = _loc3_ as PDecor;
               _loc3_ = Facade.manualProxy.getDecorShop(_loc10_.decor_kind);
               _loc7_ = _loc10_.decor_id;
            }
            _loc5_ = UnitFactory.createConstruction(_loc3_,_loc7_,_loc2_);
            _loc5_.stand();
            this.eraseOne(_loc5_);
         }
         this.editorPanel.grid.sync();
         for each(_loc4_ in this.editorPanel.grid.renderList)
         {
            _loc4_.useNew();
         }
      }
      
      public function clear() : void
      {
         Signal.stopRef(this.editorPanel);
      }
      
      private function syncEraseBt() : void
      {
         this.editorPanel.eraseFenceBt.disabled = !this.up.fenceList.head;
         this.editorPanel.eraseAllBt.disabled = !this.up.fenceList.head && !this.up.buildList.head && !this.up.cannonList.head && !this.up.decorList.head;
      }
      
      public function onErase(param1:Unit, param2:Vector.<Fence> = null) : void
      {
         this.resetSelect();
         this.bm.resetSelected();
         if(param2)
         {
            for each(param1 in param2)
            {
               this.eraseOne(param1);
            }
         }
         else
         {
            this.eraseOne(param1);
         }
         BoardLogic.updateLanding(false);
         this.editorPanel.grid.sync();
         this.syncEraseBt();
      }
      
      private function onEraseAll(param1:MouseEvent) : void
      {
         var _loc4_:Unit = null;
         this.resetSelect();
         this.bm.resetSelected();
         var _loc2_:Class = (param1.currentTarget as VButton).data as Class;
         var _loc3_:uint = 0;
         for each(_loc4_ in this.up.constructionHash)
         {
            if(Boolean(_loc4_.display.parent) && (!_loc2_ || _loc4_ is _loc2_))
            {
               _loc3_++;
            }
         }
         if(_loc3_ > 3)
         {
            Facade.mainMediator.showYesNoDialog(Lang.getPatternString("editor_erase_prompt","__COUNT__",_loc3_.toString()),this.confirmEraseAll,[_loc2_]);
         }
         else
         {
            this.confirmEraseAll(_loc2_);
         }
      }
      
      private function confirmEraseAll(param1:Class) : void
      {
         var _loc2_:Unit = null;
         for each(_loc2_ in this.up.constructionHash)
         {
            if(Boolean(_loc2_.display.parent) && (!param1 || _loc2_ is param1))
            {
               this.eraseOne(_loc2_);
            }
         }
         BoardLogic.updateLanding(false);
         this.editorPanel.grid.sync();
         this.syncEraseBt();
      }
      
      private function addItem(param1:Unit, param2:Boolean = true) : void
      {
         var _loc4_:VOTownHallItem = null;
         var _loc3_:* = int(this.dp.length - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = this.dp[_loc3_];
            if(_loc4_.kind == param1.kind && _loc4_.level == param1.level)
            {
               break;
            }
            _loc3_--;
         }
         if(_loc3_ < 0)
         {
            _loc4_ = new VOTownHallItem();
            _loc4_.kind = param1.kind;
            _loc4_.level = param1.level;
            _loc4_.count = 1;
            this.dict[_loc4_] = new <uint>[param1.id];
            this.dp.push(_loc4_);
         }
         else
         {
            (this.dict[_loc4_] as Vector.<uint>).push(param1.id);
            if(param2)
            {
               ++_loc4_.count;
            }
         }
      }
      
      private function removeFromBoard(param1:Unit, param2:Boolean = true) : void
      {
         if(param1 is Build)
         {
            this.up.buildList.remove(param1);
         }
         else if(param1 is Fence)
         {
            this.up.fenceList.remove(param1);
         }
         else if(param1 is Cannon)
         {
            this.up.cannonList.remove(param1);
         }
         else if(param1 is Decor)
         {
            this.up.decorList.remove(param1);
         }
         this.bm.removeObject(param1);
         BoardLogic.bind(param1,false);
         this.addItem(param1,param2);
      }
      
      private function eraseOne(param1:Unit) : void
      {
         if(param1 is Garbage)
         {
            return;
         }
         param1.display.pauseAll(true);
         this.removeFromBoard(param1);
         if(param1 is Fence)
         {
            FenceLogic.aroundConnect(param1.b_x,param1.b_y);
         }
      }
      
      private function clearSelect() : void
      {
         if(!this.selectUnit)
         {
            return;
         }
         this.clearMoveState(true,this.bm.getSelected() != null);
         if(this.bm.getSelected() != this.selectUnit && (this.selectUnit.logic is BuildLogic || this.selectUnit.logic is CannonLogic))
         {
            this.selectUnit.logic.changeMove(this.selectUnit,false,true);
            this.selectUnit.logic.changeSelect(this.selectUnit,false);
         }
         if(this.selectUnit == this.fenceLink)
         {
            this.segmentLogic.gridItem.count = this.segmentLogic.list.length;
            this.editorPanel.grid.sync();
            this.segmentLogic.reset();
            this.bm.removeObject(this.fenceLink);
         }
         else
         {
            this.removeFromBoard(this.selectUnit,false);
         }
         this.selectUnit = null;
      }
      
      private function onSelect(param1:VEvent = null) : void
      {
         if(param1)
         {
            this.clearSelect();
         }
         var _loc2_:VOTownHallItem = this.editorPanel.grid.getSelectData() as VOTownHallItem;
         if(_loc2_)
         {
            this.bm.resetSelected();
            this.selectUnit = this.up.constructionHash[(this.dict[_loc2_] as Vector.<uint>).pop()];
            Isometric.screenToPos(Facade.board.mouseX,Facade.board.mouseY,this.tempPos);
            this.selectUnit.setGeometry(this.tempPos.x,this.tempPos.y,false);
            this.bm.addObject(this.selectUnit,false,false);
            if(this.selectUnit is Build)
            {
               this.up.buildList.add(this.selectUnit);
            }
            else if(this.selectUnit is Fence)
            {
               this.up.fenceList.add(this.selectUnit);
            }
            else if(this.selectUnit is Cannon)
            {
               this.up.cannonList.add(this.selectUnit);
            }
            else if(this.selectUnit is Decor)
            {
               this.up.decorList.add(this.selectUnit);
            }
            this.bm.useMoveState(this.selectUnit,null,null,true,false);
         }
      }
      
      public function onPlace(param1:Unit, param2:Boolean) : void
      {
         var _loc5_:uint = 0;
         if(!this.selectUnit)
         {
            if(param2)
            {
               this.isEdit = true;
            }
            this.clearMoveState(!param2);
            return;
         }
         var _loc3_:VGrid = this.editorPanel.grid;
         var _loc4_:VOTownHallItem = _loc3_.getSelectData() as VOTownHallItem;
         if(!_loc4_)
         {
            throw new Error("EditorMediator.onPlace: bad grid item");
         }
         if(param2)
         {
            this.isEdit = true;
            if(this.selectUnit == this.fenceLink)
            {
               if(this.segmentLogic.count <= 0)
               {
                  return;
               }
               (this.dict[_loc4_] as Vector.<uint>).splice(0,this.segmentLogic.count);
               param1 = this.segmentLogic.list[this.segmentLogic.count - 1];
               this.segmentLogic.reset(false);
               this.clearMoveState(false);
               this.bm.removeObject(this.fenceLink);
               this.selectUnit = param1;
            }
            else
            {
               this.clearMoveState(false);
               --_loc4_.count;
            }
            if(_loc4_.count == 0)
            {
               delete this.dict[_loc4_];
               this.bm.setSelected(this.selectUnit);
               this.selectUnit = null;
               this.dp.splice(_loc3_.getSelectIndex(),1);
               _loc3_.setSelected();
            }
            else if(_loc4_.count > 1 && this.selectUnit is Fence)
            {
               if(!this.fenceLink)
               {
                  this.createFenceLink();
               }
               for each(_loc5_ in this.dict[_loc4_])
               {
                  this.segmentLogic.list.push(this.up.constructionHash[_loc5_] as Fence);
               }
               this.segmentLogic.link_x = this.selectUnit.c_x;
               this.segmentLogic.link_y = this.selectUnit.c_y;
               this.segmentLogic.gridItem = _loc4_;
               this.fenceLink.kind = this.selectUnit.kind;
               this.fenceLink.level = this.selectUnit.level;
               this.bm.resetSelected();
               this.bm.addObject(this.fenceLink,true,false);
               this.bm.useMoveState(this.fenceLink);
               this.selectUnit = this.fenceLink;
            }
            else
            {
               this.selectUnit.logic.changeSelect(this.selectUnit,false);
               this.onSelect();
            }
            this.syncEraseBt();
         }
         else
         {
            this.resetSelect();
         }
         _loc3_.sync();
      }
      
      private function createFenceLink() : void
      {
         this.fenceLink = new Unit();
         this.fenceLink.display.viewRect = new Rectangle();
         this.fenceLink.configViewRect(false,false);
         this.segmentLogic = new SegmentLogic();
         this.segmentLogic.grid = this.editorPanel.grid;
         this.fenceLink.logic = this.segmentLogic;
      }
      
      private function onSave(param1:MouseEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Unit = null;
         if(this.dp.length > 0)
         {
            Facade.mainMediator.showMessage(Lang.getString("editor_no_save"));
         }
         else
         {
            if(this.isEdit)
            {
               _loc2_ = [];
               for each(_loc3_ in this.up.constructionHash)
               {
                  if(!(_loc3_ is Garbage))
                  {
                     _loc2_.push(PMove.create(UnitFactory.getServerObjectId(_loc3_),new Position(_loc3_.b_x,_loc3_.b_y)));
                  }
               }
               if(_loc2_.length > 0)
               {
                  Facade.protoProxy.request(new Packet_0010_0D(_loc2_));
               }
            }
            MainLogic.getMyMap();
         }
      }
      
      private function onExit(param1:MouseEvent) : void
      {
         if(this.dp.length != 0 || this.isEdit)
         {
            Facade.mainMediator.showYesNoDialog(Lang.getString("editor_exit_prompt"),MainLogic.getMyMap);
         }
         else
         {
            MainLogic.getMyMap();
         }
      }
      
      public function resetSelect() : void
      {
         this.clearSelect();
         this.editorPanel.grid.setSelected();
      }
   }
}

