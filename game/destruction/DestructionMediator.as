package game.destruction
{
   import engine.display.AnimClip;
   import engine.display.AnimDisplay;
   import engine.signal.Signal;
   import engine.units.AnimObject;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.RadiusUnit;
   import game.board.DamageProgressBar;
   import game.common.DialogMediator;
   import ui.common.BaseDialog;
   import utils.CommonUtils;
   
   public class DestructionMediator extends DialogMediator
   {
      
      private const RANDOM_CONST:Number = 0.7;
      
      private const signalList:Vector.<Signal>;
      
      private const delaySignal:Signal;
      
      private const destructionUnitList:Vector.<RadiusUnit>;
      
      private const destructionRuinsHash:Object;
      
      private var townHall:Build;
      
      private var destructionItem:VODestruction;
      
      private var dialog:DestructionDialog;
      
      public function DestructionMediator(param1:VODestruction)
      {
         var _loc4_:Number = NaN;
         this.signalList = new Vector.<Signal>();
         this.delaySignal = new Signal(this.onRemove);
         this.destructionUnitList = new Vector.<RadiusUnit>();
         this.destructionRuinsHash = {};
         super();
         this.destructionItem = param1;
         var _loc2_:Build = Facade.userProxy.buildList.head as Build;
         while(_loc2_)
         {
            _loc4_ = Math.random();
            if(_loc4_ <= this.RANDOM_CONST && _loc2_.updateLevel == 0)
            {
               if(_loc4_ < this.RANDOM_CONST / 2)
               {
                  this.destructionUnitList.push(_loc2_);
               }
               else
               {
                  this.destructionUnitList.unshift(_loc2_);
               }
               _loc2_.display.animObj.configViewRect(false,false);
               this.addRuins(_loc2_);
            }
            if(_loc2_.kind == "bl_town_hall")
            {
               this.townHall = _loc2_;
               this.townHall.display.setInactive(true);
            }
            _loc2_ = _loc2_.link_next as Build;
         }
         var _loc3_:Cannon = Facade.userProxy.cannonList.head as Cannon;
         while(_loc3_)
         {
            _loc4_ = Math.random();
            if(Math.random() <= this.RANDOM_CONST && _loc3_.updateLevel == 0)
            {
               if(_loc4_ < this.RANDOM_CONST / 2)
               {
                  this.destructionUnitList.push(_loc3_);
               }
               else
               {
                  this.destructionUnitList.unshift(_loc3_);
               }
               _loc3_.display.animObj.configViewRect(false,false);
               this.addRuins(_loc3_);
            }
            _loc3_ = _loc3_.link_next as Cannon;
         }
      }
      
      override public function onAdd() : BaseDialog
      {
         this.dialog = new DestructionDialog(this.destructionItem);
         return this.dialog;
      }
      
      override public function onRemove() : void
      {
         var _loc2_:AnimObject = null;
         var _loc3_:AnimClip = null;
         var _loc4_:DamageProgressBar = null;
         var _loc5_:Signal = null;
         var _loc1_:RadiusUnit = this.destructionUnitList.pop();
         if(_loc1_)
         {
            _loc1_.display.animObj.configViewRect(true,true);
            _loc2_ = this.destructionRuinsHash[_loc1_.id];
            Facade.boardMediator.removeTile(_loc2_);
            _loc3_ = _loc2_.display.getClip("tile");
            if(_loc3_)
            {
               _loc2_.display.remove(_loc3_);
               Facade.board.tilePanel.addChildAt(_loc3_,0);
               _loc1_.display.add(_loc3_,AnimDisplay.OUTSIDE);
            }
            _loc1_.scaffolding(true);
            _loc1_.armor = 0;
            _loc4_ = new DamageProgressBar();
            _loc4_.assign(_loc1_,true);
            _loc5_ = new Signal(this.onFinishRepair,0,true);
            _loc5_.data = _loc1_;
            _loc5_.run(2);
            this.signalList.push(_loc5_);
            this.delaySignal.delayCall(Math.random() * 0.3);
            if(this.destructionUnitList.length == 0)
            {
               Signal.delayCall(2.3,this.dispose);
            }
         }
      }
      
      public function free() : void
      {
         var _loc1_:Signal = null;
         for each(_loc1_ in this.signalList)
         {
            _loc1_.stopWithoutHandler();
         }
         this.delaySignal.stopWithoutHandler();
         this.dispose();
      }
      
      public function dispose() : void
      {
         Facade.endOfDestruction();
         this.townHall.display.setInactive(false);
      }
      
      private function onFinishRepair(param1:Signal) : void
      {
         var _loc2_:RadiusUnit = param1.data;
         var _loc3_:DamageProgressBar = _loc2_.getProgress() as DamageProgressBar;
         if(_loc3_)
         {
            _loc3_.value = param1.passedRate;
         }
         if(param1.tail == 0)
         {
            _loc2_.clearProgress();
            _loc2_.scaffolding(false);
         }
      }
      
      private function addRuins(param1:RadiusUnit) : void
      {
         var _loc3_:String = null;
         var _loc4_:AnimObject = null;
         var _loc5_:AnimClip = null;
         var _loc2_:uint = param1.size;
         if(_loc2_ > 1)
         {
            if(param1 is Cannon)
            {
               _loc3_ = "cn_" + RadiusUnit.getTileName(param1.level,(param1 as Cannon).updateMax,param1.size);
            }
            else if(param1 is Build)
            {
               _loc3_ = "bl_" + RadiusUnit.getTileName(param1.level,(param1 as Build).updateMax,param1.size);
            }
            if(_loc3_)
            {
               _loc4_ = Facade.boardMediator.addTile("broken",_loc3_,param1.b_x,param1.b_y,CommonUtils.getRangeRandom(0,1) == 1);
               this.destructionRuinsHash[param1.id] = _loc4_;
               _loc5_ = param1.display.getClip("tile");
               if(_loc5_)
               {
                  _loc5_.visible = true;
                  param1.display.remove(_loc5_);
                  Facade.board.tilePanel.addChildAt(_loc5_,0);
                  _loc4_.display.add(_loc5_,AnimDisplay.OUTSIDE);
               }
            }
         }
      }
   }
}

