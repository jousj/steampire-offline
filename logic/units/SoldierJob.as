package logic.units
{
   import engine.Map;
   import engine.Position;
   import engine.data.MapCell;
   import engine.signal.Signal;
   import engine.units.Build;
   import engine.units.Soldier;
   import engine.units.Unit;
   import utils.CommonUtils;
   
   public class SoldierJob extends AbstractJob
   {
      
      private static const ROTATE_CHANCE:Number = 0.4;
      
      private static const WAIT_MIN_TIME:Number = 12;
      
      private static const WAIT_MAX_TIME:Number = 36;
      
      private static const SPIRAL_AREA:uint = 6;
      
      private var soldier:Soldier;
      
      private var build:Build;
      
      private const signal:Signal = new Signal();
      
      public function SoldierJob(param1:Build = null)
      {
         super();
         this.signal.delay = 4;
         this.build = param1;
      }
      
      override public function assignTarget(param1:Unit) : void
      {
         this.soldier = param1 as Soldier;
         this.soldier.useWalkPath();
         this.soldier.display.setInactive(true);
         if(!this.build)
         {
            this.soldier.direction = 1 << CommonUtils.getRangeRandom(0,7);
         }
      }
      
      override public function start() : void
      {
         var _loc1_:MapCell = null;
         if(this.build)
         {
            _loc1_ = Facade.map.getMapCell(Math.random() > 0.5 ? this.build.b_x : int(this.build.b_x - 1),this.build.b_y);
         }
         else
         {
            _loc1_ = this.getFreeCell();
         }
         this.soldier.correctInnerPos(_loc1_);
         this.soldier.setGeometry(_loc1_.x,_loc1_.y,true);
         if(this.build)
         {
            this.signal.handler = this.onShow;
            this.signal.delayCall(2 + Math.random() * 30,true);
         }
         else
         {
            this.onShow(Math.random() > 0.66);
         }
      }
      
      override public function stop() : void
      {
         this.soldier.stopWalk();
         this.signal.stop();
         this.signal.handler = null;
         this.build = null;
      }
      
      public function set pause(param1:Boolean) : void
      {
         if(param1 != (this.signal.handler == null))
         {
            this.soldier.display.pauseAll(param1);
            if(param1)
            {
               this.stop();
               Facade.boardMediator.removeObject(this.soldier);
            }
            else
            {
               this.start();
            }
         }
      }
      
      private function getFreeCell() : MapCell
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc1_:Position = new Position(CommonUtils.getRangeRandom(0,Facade.map_sx - 1),CommonUtils.getRangeRandom(0,Facade.map_sy - 1));
         var _loc2_:Map = Facade.map;
         var _loc3_:MapCell = _loc2_.getMapCell(_loc1_.x,_loc1_.y);
         if(_loc3_.walkFactor > 0 && _loc3_.walkFactor <= 3)
         {
            return _loc3_;
         }
         var _loc4_:uint = 2;
         var _loc5_:uint = SPIRAL_AREA;
         while(_loc5_ > 0)
         {
            ++_loc1_.x;
            --_loc1_.y;
            _loc6_ = 0;
            while(_loc6_ < 4)
            {
               _loc7_ = 0;
               while(_loc7_ < _loc4_)
               {
                  if(_loc6_ == 0)
                  {
                     ++_loc1_.y;
                  }
                  else if(_loc6_ == 1)
                  {
                     --_loc1_.x;
                  }
                  else if(_loc6_ == 2)
                  {
                     --_loc1_.y;
                  }
                  else
                  {
                     ++_loc1_.x;
                  }
                  _loc3_ = _loc2_.getSafeMapCell(_loc1_.x,_loc1_.y);
                  if(Boolean(_loc3_) && Boolean(_loc3_.walkFactor > 0) && _loc3_.walkFactor <= 3)
                  {
                     return _loc3_;
                  }
                  _loc7_++;
               }
               _loc6_++;
            }
            _loc4_ += 2;
            _loc5_--;
         }
         return this.getFreeCell();
      }
      
      private function wait() : void
      {
         this.soldier.stand();
         this.signal.run(WAIT_MIN_TIME + Math.random() * (WAIT_MAX_TIME - WAIT_MIN_TIME),0,false,true);
      }
      
      private function onSignal() : void
      {
         var _loc1_:uint = 0;
         if(this.signal.tail == 0)
         {
            this.walking();
         }
         else if(Math.random() <= ROTATE_CHANCE)
         {
            do
            {
               _loc1_ = uint(1 << CommonUtils.getRangeRandom(0,7));
            }
            while(_loc1_ == this.soldier.direction);
            this.soldier.direction = _loc1_;
            this.soldier.stand();
         }
      }
      
      private function walking() : void
      {
         var _loc1_:MapCell = this.getFreeCell();
         this.soldier.startWalkPath(_loc1_.x,_loc1_.y,this.wait);
      }
      
      private function onShow(param1:Boolean = true) : void
      {
         if(!this.soldier.display.parent)
         {
            Facade.boardMediator.addObject(this.soldier,this.soldier.shop.su_is_air,false);
         }
         this.signal.handler = this.onSignal;
         if(param1)
         {
            this.walking();
         }
         else
         {
            this.wait();
         }
      }
   }
}

