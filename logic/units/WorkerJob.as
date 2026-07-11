package logic.units
{
   import engine.display.Animation;
   import engine.signal.Signal;
   import engine.units.Build;
   import engine.units.Unit;
   import engine.units.Worker;
   import proto.model.PBtype;
   import utils.CommonUtils;
   
   public class WorkerJob extends AbstractJob
   {
      
      public var skipStartMove:Boolean;
      
      private const signal:Signal = new Signal();
      
      private var worker:Worker;
      
      private var targetUnit:Unit;
      
      private var homeBuild:Build;
      
      public function WorkerJob()
      {
         super();
      }
      
      override public function assignTarget(param1:Unit) : void
      {
         this.worker = param1 as Worker;
      }
      
      override public function start() : void
      {
         var _loc1_:Animation = null;
         this.targetUnit = Facade.userProxy.constructionHash[this.worker.targetId] as Unit;
         if(this.skipStartMove)
         {
            this.homeToTarget(false);
         }
         else
         {
            if(!this.worker.alreadyBoard)
            {
               this.homeBuild = this.getRandomWorkerBuild();
               if(this.homeBuild)
               {
                  this.worker.setGeometry(this.homeBuild.t_x,this.homeBuild.t_y,true);
                  _loc1_ = this.homeBuild.getAnimation("level" + this.homeBuild.level + "_ex",false);
                  if(_loc1_)
                  {
                     this.worker.display.visible = false;
                     this.homeBuild.animClip.play(_loc1_);
                     this.signal.handler = this.onOpenDoor;
                     this.signal.duration = _loc1_.duration / 2;
                     this.signal.delayCall(this.signal.duration,true);
                     return;
                  }
               }
               else
               {
                  this.homeToTarget(false);
               }
            }
            else
            {
               this.worker.alreadyBoard = false;
            }
            this.homeToTarget();
         }
         this.worker.display.visible = true;
         this.homeBuild = null;
      }
      
      private function homeToTarget(param1:Boolean = true) : void
      {
         this.signal.handler = this.step2;
         if(param1)
         {
            this.worker.startWalkPath(this.targetUnit.b_x,this.targetUnit.b_y,this.step1);
         }
         else
         {
            this.worker.setGeometry(this.targetUnit.b_x,this.targetUnit.b_y,true);
            this.step1();
         }
      }
      
      private function onOpenDoor() : void
      {
         this.worker.stand();
         this.worker.display.visible = true;
         this.signal.handler = this.homeToTarget;
         this.signal.delayCall(this.signal.duration + 1,true);
      }
      
      override public function stop() : void
      {
         this.signal.stop();
      }
      
      private function step1() : void
      {
         this.worker.calcDirection(this.targetUnit.z_x,this.targetUnit.z_y);
         this.worker.playAnim("build",true);
         this.signal.delayCall(3);
      }
      
      private function step2() : void
      {
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
         this.worker.startWalkPath(_loc1_,_loc2_,this.step1);
      }
      
      public function goHome() : void
      {
         this.signal.stop();
         this.worker.isFree = true;
         this.homeBuild = this.getRandomWorkerBuild();
         if(this.homeBuild)
         {
            this.worker.startWalkPath(this.homeBuild.t_x,this.homeBuild.t_y,this.onHome);
         }
         else
         {
            this.onHome();
         }
      }
      
      private function getRandomWorkerBuild() : Build
      {
         var _loc1_:Vector.<Build> = new Vector.<Build>();
         Facade.userProxy.getBuild(PBtype.WORKER,true,0,_loc1_);
         Facade.userProxy.getBuild(PBtype.HERO,true,0,_loc1_);
         return _loc1_.length > 0 ? _loc1_[CommonUtils.getRangeRandom(0,_loc1_.length - 1)] : null;
      }
      
      private function onHome() : void
      {
         var _loc1_:Animation = null;
         if(this.homeBuild)
         {
            this.signal.handler = this.onEnterHome;
            _loc1_ = this.homeBuild.getAnimation("level" + this.homeBuild.level + "_ex",false);
            if(_loc1_)
            {
               this.homeBuild.animClip.play(_loc1_);
               this.signal.delayCall(_loc1_.duration / 2,true);
            }
            else
            {
               this.signal.delayCall(1,true);
            }
         }
         else
         {
            this.onEnterHome();
         }
      }
      
      private function onEnterHome() : void
      {
         Facade.boardMediator.removeObject(this.worker);
         Facade.userProxy.workerList.remove(this.worker);
      }
   }
}

