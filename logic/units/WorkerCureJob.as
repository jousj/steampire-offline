package logic.units
{
   import engine.Position;
   import engine.data.MapCell;
   import engine.signal.Signal;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Unit;
   import engine.units.Worker;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import logic.BoardLogic;
   import utils.CommonUtils;
   
   public class WorkerCureJob extends AbstractJob
   {
      
      private static var filter:GlowFilter;
      
      private var worker:Worker;
      
      private var pos:Position;
      
      private var targetUnit:Unit;
      
      private var targetIndex:uint;
      
      private var radius:uint;
      
      private var duration:Number;
      
      private const signal:Signal;
      
      private const r_signal:Signal;
      
      public const list:Vector.<Unit>;
      
      public function WorkerCureJob(param1:Point, param2:uint, param3:Number)
      {
         var _loc4_:MapCell = null;
         var _loc5_:Unit = null;
         this.signal = new Signal();
         this.r_signal = new Signal(this.clear);
         this.list = new Vector.<Unit>();
         super();
         this.radius = param2;
         this.duration = param3;
         this.pos = new Position(param1.x,param1.y);
         for each(_loc4_ in BoardLogic.getRadiusPositionList(this.pos.x,this.pos.y,1,param2))
         {
            _loc5_ = _loc4_.unit;
            if((Boolean(_loc5_)) && (Boolean(_loc5_ is Build || _loc5_ is Cannon)) && this.list.indexOf(_loc5_) < 0)
            {
               this.list.push(_loc5_);
               if(this.checkUnitUnique(_loc5_))
               {
                  if(!filter)
                  {
                     filter = new GlowFilter(65280,1,4,4,4);
                  }
                  _loc5_.display.addFilter(filter);
               }
            }
         }
      }
      
      private function checkUnitUnique(param1:Unit) : Boolean
      {
         var _loc2_:Worker = Facade.userProxy.workerList.head as Worker;
         while(_loc2_)
         {
            if(_loc2_.job is WorkerCureJob)
            {
               if((_loc2_.job as WorkerCureJob).list.indexOf(param1) >= 0)
               {
                  return false;
               }
            }
            _loc2_ = _loc2_.link_next as Worker;
         }
         return true;
      }
      
      override public function assignTarget(param1:Unit) : void
      {
         this.worker = param1 as Worker;
         Facade.userProxy.workerList.push(this.worker);
      }
      
      override public function start() : void
      {
         this.targetIndex = this.list.length;
         if(this.targetIndex > 0)
         {
            this.targetUnit = this.list[0];
            this.pos.x = this.targetUnit.b_x;
            this.pos.y = this.targetUnit.b_y;
            this.signal.handler = this.repairStep1;
         }
         else
         {
            this.signal.handler = this.relaxStep1;
         }
         this.worker.correctInnerPos(Facade.map.getMapCell(this.pos.x,this.pos.y));
         this.worker.setGeometry(this.pos.x,this.pos.y,false);
         Facade.boardMediator.addObject(this.worker,true,false);
         if(this.targetIndex > 0)
         {
            this.repairStep2();
         }
         else
         {
            this.relaxStep2();
         }
         this.r_signal.delayCall(this.duration,true);
      }
      
      override public function stop() : void
      {
         this.signal.stop();
         this.r_signal.stop();
      }
      
      private function repairStep1() : void
      {
         if(this.list.length > 1)
         {
            ++this.targetIndex;
            if(this.targetIndex >= this.list.length)
            {
               this.targetIndex = 0;
            }
            this.targetUnit = this.list[this.targetIndex];
         }
         var _loc1_:int = this.targetUnit.b_x;
         var _loc2_:int = this.targetUnit.b_y;
         var _loc3_:int = int(CommonUtils.getRangeRandom(0,this.targetUnit.size - 1));
         if(CommonUtils.getRangeRandom(0,1) == 0)
         {
            _loc1_ -= _loc3_;
         }
         else
         {
            _loc2_ -= _loc3_;
         }
         this.worker.startWalkPath(_loc1_,_loc2_,this.repairStep2);
      }
      
      private function repairStep2() : void
      {
         this.worker.calcDirection(this.targetUnit.z_x,this.targetUnit.z_y);
         this.worker.playAnim("build",true);
         this.signal.delayCall(3);
      }
      
      private function relaxStep1() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:uint = 2 * this.radius;
         do
         {
            _loc2_ = this.pos.x + CommonUtils.getRangeRandom(0,_loc1_) - this.radius;
            _loc3_ = this.pos.y + CommonUtils.getRangeRandom(0,_loc1_) - this.radius;
         }
         while(this.worker.b_x == _loc2_ && this.worker.b_y == _loc3_);
         this.worker.startWalkPath(_loc2_,_loc3_,this.relaxStep2);
      }
      
      private function relaxStep2() : void
      {
         this.worker.stand();
         this.signal.delayCall(3);
      }
      
      private function clear() : void
      {
         var _loc1_:Unit = null;
         Facade.userProxy.workerList.remove(this.worker);
         Facade.boardMediator.removeObject(this.worker);
         for each(_loc1_ in this.list)
         {
            if(this.checkUnitUnique(_loc1_))
            {
               _loc1_.display.removeFilter(filter);
            }
         }
         this.worker.dispose();
      }
   }
}

