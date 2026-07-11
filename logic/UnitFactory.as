package logic
{
   import engine.Position;
   import engine.data.LinkedIterator;
   import engine.data.LinkedList;
   import engine.display.EffectClip;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Decor;
   import engine.units.Fence;
   import engine.units.Garbage;
   import engine.units.Rocket;
   import engine.units.Soldier;
   import engine.units.Unit;
   import engine.units.Worker;
   import game.board.UnitInfoStatus;
   import logic.units.AbstractLogic;
   import logic.units.BuildLogic;
   import logic.units.CannonLogic;
   import logic.units.DecorLogic;
   import logic.units.FenceLogic;
   import logic.units.GarbageLogic;
   import logic.units.SoldierJob;
   import logic.units.WorkerJob;
   import model.CommonEvent;
   import model.ManualProxy;
   import model.UserProxy;
   import model.vo.MapAction;
   import model.vo.VOGuardSpec;
   import model.vo.VOPylonSpec;
   import model.vo.VOResourceSpec;
   import model.vo.VOShieldSpec;
   import model.vo.VOStorageSpec;
   import proto.model.PBtype;
   import proto.model.PObjectId;
   import proto.model.PShopBuilding;
   import proto.model.PShopCannon;
   import proto.model.PShopDecor;
   import proto.model.PShopFence;
   import proto.model.PShopGarbage;
   import proto.model.PShopUnit;
   import ui.game.BubblePanel;
   import ui.game.UnitProgressBar;
   import ui.vbase.VComponent;
   import utils.CommonUtils;
   
   public class UnitFactory
   {
      
      public static const defaultLogic:AbstractLogic = new AbstractLogic();
      
      public static const buildLogic:BuildLogic = new BuildLogic();
      
      public static const cannonLogic:CannonLogic = new CannonLogic();
      
      public static const fenceLogic:FenceLogic = new FenceLogic();
      
      public static const decorLogic:DecorLogic = new DecorLogic();
      
      public static const garbageLogic:GarbageLogic = new GarbageLogic();
      
      public function UnitFactory()
      {
         super();
      }
      
      public static function createConstruction(param1:Object, param2:uint, param3:Position) : Unit
      {
         var _loc4_:UserProxy = null;
         var _loc5_:Unit = null;
         _loc4_ = Facade.userProxy;
         if(param1 is PShopBuilding)
         {
            _loc5_ = newBuild(param1 as PShopBuilding);
            _loc4_.buildList.add(_loc5_);
         }
         else if(param1 is PShopFence)
         {
            _loc5_ = new Fence(param1 as PShopFence);
            _loc5_.logic = fenceLogic;
            _loc4_.fenceList.add(_loc5_);
         }
         else if(param1 is PShopCannon)
         {
            _loc5_ = newCannon(param1 as PShopCannon,param2 == 0);
            _loc4_.cannonList.add(_loc5_);
         }
         else if(param1 is PShopDecor)
         {
            _loc5_ = new Decor(param1 as PShopDecor);
            _loc5_.logic = decorLogic;
            _loc4_.decorList.add(_loc5_);
         }
         else if(param1 is PShopGarbage)
         {
            _loc5_ = new Garbage(param1 as PShopGarbage);
            _loc5_.logic = garbageLogic;
            _loc4_.garbageList.add(_loc5_);
         }
         if(!_loc5_.logic)
         {
            _loc5_.logic = defaultLogic;
         }
         if(param2 > 0)
         {
            _loc5_.id = param2;
            if(param3)
            {
               _loc5_.setGeometry(param3.x,param3.y,false);
            }
            BoardLogic.bind(_loc5_,true);
            _loc4_.constructionHash[param2] = _loc5_;
         }
         return _loc5_;
      }
      
      public static function newBuild(param1:PShopBuilding) : Build
      {
         var _loc2_:Build = new Build(param1,Facade.manualProxy.getBuildMax(param1.sb_kind,param1.sb_level));
         _loc2_.logic = buildLogic;
         var _loc3_:uint = _loc2_.type;
         if(_loc3_ == PBtype.RESOURCE)
         {
            _loc2_.spec = new VOResourceSpec();
         }
         else if(_loc3_ == PBtype.STORAGE)
         {
            _loc2_.spec = new VOStorageSpec();
         }
         else if(_loc3_ == PBtype.PYLON)
         {
            _loc2_.spec = new VOPylonSpec();
         }
         else if(_loc3_ == PBtype.GUARD)
         {
            _loc2_.spec = new VOGuardSpec();
         }
         else if(_loc3_ == PBtype.SHIELD)
         {
            _loc2_.spec = new VOShieldSpec();
         }
         assignBuildShop(_loc2_);
         return _loc2_;
      }
      
      public static function assignBuildShop(param1:Build) : void
      {
         var _loc2_:uint = param1.type;
         var _loc3_:String = param1.kind;
         var _loc4_:uint = param1.level;
         var _loc5_:ManualProxy = Facade.manualProxy;
         if(_loc2_ == PBtype.RESOURCE)
         {
            (param1.spec as VOResourceSpec).assignShop(_loc5_.getResourceShop(_loc3_,_loc4_));
         }
         else if(_loc2_ == PBtype.STORAGE)
         {
            (param1.spec as VOStorageSpec).assignShop(_loc5_.getStorageShop(_loc3_,_loc4_));
         }
         else if(_loc2_ == PBtype.PYLON)
         {
            (param1.spec as VOPylonSpec).assignShop(_loc5_.getPylonShop(_loc3_,_loc4_));
         }
         else if(_loc2_ == PBtype.GUARD)
         {
            (param1.spec as VOGuardSpec).assignShop(_loc5_.getGuardShop(_loc3_,_loc4_));
         }
         else if(_loc2_ == PBtype.SHIELD)
         {
            (param1.spec as VOShieldSpec).assignShop(_loc5_.getShieldShop(_loc3_,_loc4_));
         }
      }
      
      public static function newCannon(param1:PShopCannon, param2:Boolean) : Unit
      {
         var _loc3_:Cannon = new Cannon(param1,Facade.manualProxy.getCannonMax(param1.sc_kind,param1.sc_level));
         if(param2)
         {
            _loc3_.skipPylonAnim = true;
         }
         _loc3_.logic = cannonLogic;
         return _loc3_;
      }
      
      public static function removeConstruction(param1:Unit) : void
      {
         CoreLogic.removeFilterActions(param1.id);
         var _loc2_:UserProxy = Facade.userProxy;
         if(param1.id > 0)
         {
            delete _loc2_.constructionHash[param1.id];
         }
         if(param1 is Build)
         {
            _loc2_.buildList.remove(param1);
         }
         else if(param1 is Fence)
         {
            _loc2_.fenceList.remove(param1);
         }
         else if(param1 is Cannon)
         {
            _loc2_.cannonList.remove(param1);
         }
         else if(param1 is Decor)
         {
            _loc2_.decorList.remove(param1);
         }
         else if(param1 is Garbage)
         {
            _loc2_.garbageList.remove(param1);
         }
         BoardLogic.bind(param1,false);
         Facade.boardMediator.removeObject(param1);
         param1.dispose();
         if(param1 is Build)
         {
            if((param1 as Build).type == PBtype.PYLON)
            {
               CannonLogic.checkPylonCannon();
            }
         }
      }
      
      public static function addProgress(param1:Unit, param2:Number, param3:Number, param4:Boolean = false, param5:String = null) : UnitProgressBar
      {
         var _loc6_:UnitProgressBar = new UnitProgressBar(param5,16,30);
         _loc6_.setTimerValue(param2,param3);
         param1.setProgress(_loc6_,param4);
         return _loc6_;
      }
      
      public static function createSoldier(param1:PShopUnit, param2:uint) : Soldier
      {
         var _loc3_:Soldier = new Soldier(param1);
         _loc3_.logic = defaultLogic;
         if(param2 > 0)
         {
            _loc3_.id = param2;
            Facade.userProxy.soldierHash[param2] = _loc3_;
         }
         else
         {
            Facade.userProxy.soldierList.push(_loc3_);
         }
         _loc3_.setInnerPos((CommonUtils.getRangeRandom(0,2) * 2 + 1) / 6,(CommonUtils.getRangeRandom(0,2) * 2 + 1) / 6);
         return _loc3_;
      }
      
      public static function removeSoldier(param1:Soldier, param2:Boolean = false) : void
      {
         if(param1.id > 0)
         {
            delete Facade.userProxy.soldierHash[param1.id];
         }
         else
         {
            Facade.userProxy.soldierList.remove(param1);
         }
         if(!param2)
         {
            Facade.boardMediator.removeObject(param1);
            param1.dispose();
         }
      }
      
      public static function getServerObjectId(param1:Unit) : PObjectId
      {
         var _loc2_:uint = 0;
         if(param1 is Build)
         {
            _loc2_ = PObjectId.BUILDING;
         }
         else if(param1 is Fence)
         {
            _loc2_ = PObjectId.FENCE;
         }
         else if(param1 is Cannon)
         {
            _loc2_ = PObjectId.CANNON;
         }
         else if(param1 is Decor)
         {
            _loc2_ = PObjectId.DECOR;
         }
         else if(param1 is Garbage)
         {
            _loc2_ = PObjectId.GARBAGE;
         }
         else
         {
            if(!(param1 is Soldier))
            {
               throw new Error("bad server type unit " + param1);
            }
            _loc2_ = PObjectId.UNIT;
         }
         return PObjectId.create(_loc2_,param1.id);
      }
      
      public static function addWorker(param1:MapAction, param2:Boolean = false) : void
      {
         var _loc4_:WorkerJob = null;
         var _loc3_:Worker = Facade.userProxy.workerList.head as Worker;
         while(_loc3_)
         {
            if(_loc3_.isFree)
            {
               break;
            }
            _loc3_ = _loc3_.link_next as Worker;
         }
         if(!_loc3_ || !_loc3_.isFree)
         {
            _loc3_ = new Worker();
            _loc3_.logic = defaultLogic;
            Facade.boardMediator.addObject(_loc3_,true);
            Facade.userProxy.workerList.push(_loc3_);
         }
         else
         {
            _loc3_.isFree = false;
            _loc3_.alreadyBoard = true;
         }
         _loc3_.targetId = param1.objId;
         _loc3_.endTime = param1.time;
         _loc3_.actionVariance = param1.variance;
         if(_loc3_.job is WorkerJob)
         {
            _loc4_ = _loc3_.job as WorkerJob;
            _loc4_.skipStartMove = param2;
            _loc4_.start();
         }
         else
         {
            _loc4_ = new WorkerJob();
            _loc4_.skipStartMove = param2;
            _loc3_.assignJob(_loc4_);
         }
         if(!param2)
         {
            Facade.dispatchCommonEvent(CommonEvent.WORKER);
         }
      }
      
      public static function removeWorker(param1:uint) : void
      {
         var _loc2_:Worker = Facade.userProxy.workerList.head as Worker;
         while(_loc2_)
         {
            if(_loc2_.targetId == param1)
            {
               (_loc2_.job as WorkerJob).goHome();
               Facade.dispatchCommonEvent(CommonEvent.WORKER);
               return;
            }
            _loc2_ = _loc2_.link_next as Worker;
         }
      }
      
      public static function attentionStatus(param1:Unit) : void
      {
         new UnitInfoStatus("AttentionStatus").assign(param1);
      }
      
      public static function useSoldierPatrol() : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:LinkedIterator = null;
         var _loc6_:ManualProxy = null;
         var _loc7_:String = null;
         var _loc8_:Build = null;
         var _loc9_:Soldier = null;
         if(!Facade.isNormalQuality)
         {
            return;
         }
         var _loc1_:Object = Facade.userProxy.soldierCountHash;
         var _loc2_:uint = 0;
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_ > 1000)
            {
               return;
            }
            _loc2_ += _loc3_;
         }
         _loc4_ = 20;
         _loc5_ = new LinkedIterator(Facade.userProxy.soldierList);
         _loc6_ = Facade.manualProxy;
         if(_loc2_ > 0)
         {
            _loc8_ = Facade.userProxy.getBuild(PBtype.CAMP,true);
         }
         for(_loc7_ in _loc1_)
         {
            _loc3_ = uint(_loc1_[_loc7_]);
            if(_loc3_ > 0 && _loc2_ > _loc4_)
            {
               _loc3_ = _loc3_ / _loc2_ * _loc4_;
               if(_loc3_ == 0)
               {
                  _loc3_ = 1;
               }
            }
            _loc5_.toHead();
            while(_loc5_.item)
            {
               _loc9_ = _loc5_.item as Soldier;
               _loc5_.next();
               if(_loc9_.shop.su_kind == _loc7_)
               {
                  if(_loc3_ > 0)
                  {
                     _loc3_--;
                  }
                  else
                  {
                     removeSoldier(_loc9_);
                  }
               }
            }
            while(_loc3_ > 0)
            {
               _loc3_--;
               _loc9_ = createSoldier(_loc6_.getSoldierShop(_loc7_),0);
               _loc9_.assignJob(new SoldierJob(_loc9_.shop.su_is_hero ? Facade.userProxy.getBuild(PBtype.HERO,true) : _loc8_));
            }
         }
         _loc5_.dispose();
      }
      
      public static function clearPatrol() : void
      {
         var _loc1_:LinkedList = Facade.userProxy.soldierList;
         var _loc2_:Soldier = _loc1_.head as Soldier;
         while(_loc2_)
         {
            Facade.boardMediator.removeObject(_loc2_);
            _loc2_.dispose();
            _loc2_ = _loc2_.link_next as Soldier;
         }
         _loc1_.clear();
      }
      
      public static function setPatrolPause(param1:Boolean) : void
      {
         var _loc2_:Soldier = Facade.userProxy.soldierList.head as Soldier;
         while(_loc2_)
         {
            (_loc2_.job as SoldierJob).pause = param1;
            _loc2_ = _loc2_.link_next as Soldier;
         }
      }
      
      public static function clear() : void
      {
         var _loc2_:LinkedList = null;
         var _loc3_:Unit = null;
         var _loc1_:UserProxy = Facade.userProxy;
         for each(_loc2_ in new <LinkedList>[_loc1_.buildList,_loc1_.cannonList,_loc1_.fenceList,_loc1_.garbageList,_loc1_.workerList,_loc1_.soldierList,_loc1_.decorList])
         {
            _loc3_ = _loc2_.head as Unit;
            while(_loc3_)
            {
               if(!_loc3_.display.parent)
               {
                  _loc3_.dispose();
               }
               _loc3_ = _loc3_.link_next as Unit;
            }
         }
         Rocket.clear();
         EffectClip.clear();
         Facade.board.clear();
      }
      
      public static function applyStaminaMultiplier(param1:Number) : void
      {
         var _loc2_:UserProxy = Facade.userProxy;
         var _loc3_:Build = _loc2_.buildList.head as Build;
         while(_loc3_)
         {
            _loc3_.stamina *= param1;
            _loc3_.armor *= param1;
            _loc3_ = _loc3_.link_next as Build;
         }
         var _loc4_:Cannon = _loc2_.cannonList.head as Cannon;
         while(_loc4_)
         {
            _loc4_.stamina *= param1;
            _loc4_.armor *= param1;
            _loc4_ = _loc4_.link_next as Cannon;
         }
         var _loc5_:Fence = _loc2_.fenceList.head as Fence;
         while(_loc5_)
         {
            _loc5_.stamina *= param1;
            _loc5_.armor *= param1;
            _loc5_ = _loc5_.link_next as Fence;
         }
      }
      
      public static function useBubble(param1:Unit, param2:String, param3:Object, param4:uint = 0) : void
      {
         param4 = param4 > 0 ? param4 : BubblePanel.TAIL_LEFT;
         var _loc5_:VComponent = new VComponent();
         _loc5_.setSize(2,2);
         var _loc6_:BubblePanel = new BubblePanel(param2,param4,16,8);
         _loc5_.add(_loc6_,param3);
         param1.setStatus(_loc5_);
      }
   }
}

