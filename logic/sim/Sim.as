package logic.sim
{
   import engine.Position;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import proto.model.PHero;
   import proto.model.PReferences;
   import proto.model.PShopSpell;
   import proto.model.PShopUnit;
   
   public class Sim
   {
      
      public static const SE_ACTIVATE_UNIT:int = 1;
      
      public static const SE_INIT_UNIT:int = 2;
      
      public static const SE_UNIT_GO_TO:int = 3;
      
      public static const SE_UNIT_ATTACK:int = 4;
      
      public static const SE_UNIT_FIRE_ATTACK:int = 5;
      
      public static const SE_CANNON_ATTACK_UNIT:int = 6;
      
      public static const SE_CANNON_FIRE:int = 7;
      
      public static const SE_CANNON_FIND_TARGET:int = 8;
      
      public static const SE_FINISH:int = 9;
      
      public static const SE_ACTIVATE_SPELL:int = 10;
      
      public static const SE_SPELL_FIREBALL:int = 11;
      
      public static const SE_SPELL_CURE:int = 12;
      
      public static const SE_SPELL_CALL:int = 13;
      
      public static const SE_SPELL_WORKER:int = 14;
      
      public static const SE_SPELL_SHOCK:int = 15;
      
      public static const SE_SPELL_MULTIFIREBALL:int = 16;
      
      public static const SE_SPELL_FOG:int = 17;
      
      public static const SE_SPELL_RAGE:int = 18;
      
      public static const SE_SPELL_LOW_DAMAGE:int = 19;
      
      public var data:SimData;
      
      private const pq:PriorityQueue = new PriorityQueue();
      
      private var logicCannons:LCannons;
      
      private var logicUnits:LUnits;
      
      private var logicSpells:LSpells;
      
      private var simRun:SimRun;
      
      public function Sim(param1:int, param2:int, param3:PReferences, param4:SimRun = null)
      {
         super();
         this.data = new SimData(new SimBoard(param1,param2),param3);
         var _loc5_:SimFun = new SimFun(this.data,this.pq);
         if(!param4)
         {
            param4 = new SimRun();
         }
         this.simRun = param4;
         this.logicCannons = new LCannons(this.pq,_loc5_,param4);
         this.logicUnits = new LUnits(this.logicCannons,this.pq,_loc5_,param4);
         this.logicSpells = new LSpells(this.logicUnits,this.pq,_loc5_,param4);
         this.logicCannons.logicUnits = this.logicUnits;
      }
      
      public function processQueueToTime(param1:int, param2:Boolean = false) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc3_:Boolean = false;
         if(param2)
         {
            _loc4_ = getTimer();
         }
         while(!_loc3_)
         {
            if(this.pq.isEmpty())
            {
               if(param2)
               {
                  _loc3_ = true;
               }
               break;
            }
            _loc5_ = this.pq.getTopPriority();
            _loc6_ = this.pq.getTop();
            if(_loc5_ > param1)
            {
               if(param2)
               {
                  _loc3_ = true;
               }
               break;
            }
            this.pq.removeTop();
            _loc7_ = int(_loc6_.kind);
            switch(_loc7_)
            {
               case SE_ACTIVATE_UNIT:
                  this.logicUnits.activateUnit(_loc6_.id,_loc5_);
                  break;
               case SE_INIT_UNIT:
                  this.logicUnits.init(_loc6_.id,_loc5_);
                  break;
               case SE_UNIT_GO_TO:
                  this.logicUnits.goTo(_loc6_.id,_loc6_.is_init,_loc5_);
                  break;
               case SE_UNIT_ATTACK:
                  this.logicUnits.attack(_loc6_.is_init,_loc6_.id,_loc6_.target_id,_loc5_);
                  break;
               case SE_UNIT_FIRE_ATTACK:
                  this.logicUnits.applyDamage(_loc6_.u,_loc6_.target_id,_loc6_.pos,_loc5_,true);
                  break;
               case SE_CANNON_ATTACK_UNIT:
                  this.logicCannons.attack(_loc6_.is_init,_loc6_.id,_loc6_.unit_id,_loc6_.pos,_loc5_);
                  break;
               case SE_CANNON_FIRE:
                  this.logicCannons.applyDamage(_loc6_.c,_loc6_.unit_id,_loc6_.pos,_loc5_);
                  break;
               case SE_CANNON_FIND_TARGET:
                  this.logicCannons.findTarget(_loc6_.id,_loc5_);
                  break;
               case SE_ACTIVATE_SPELL:
                  this.logicSpells.activate(_loc6_.shop,_loc6_.pos,_loc6_.user_num,_loc6_.is_attacker,_loc5_);
                  break;
               case SE_SPELL_FIREBALL:
                  this.logicSpells.applyFireball(_loc6_.pos,_loc6_.radius,_loc6_.damage,1,_loc6_.is_attacker,_loc5_);
                  break;
               case SE_SPELL_CURE:
                  this.logicSpells.applyCure(_loc6_.pos,_loc6_.duration,_loc6_.stamina,_loc6_.radius,_loc6_.count,_loc6_.is_attacker,_loc5_);
                  break;
               case SE_SPELL_CALL:
                  this.logicSpells.applyCall(_loc6_.pos,_loc6_.duration,_loc6_.user_num,_loc5_);
                  break;
               case SE_SPELL_WORKER:
                  this.logicSpells.applyWorker(_loc6_.pos,_loc6_.duration,_loc6_.stamina,_loc6_.radius,_loc6_.count,_loc6_.is_attacker,_loc5_);
                  break;
               case SE_SPELL_SHOCK:
                  this.logicSpells.applyShock(_loc6_.pos,_loc6_.duration,_loc6_.radius,_loc5_,_loc6_.start,_loc6_.is_attacker);
                  break;
               case SE_SPELL_MULTIFIREBALL:
                  this.logicSpells.applyMultifireball(_loc6_.pos,_loc6_.period,_loc6_.radius,_loc6_.damage,_loc6_.penetration,_loc6_.count,_loc6_.is_attacker,_loc5_);
                  break;
               case SE_SPELL_FOG:
                  this.logicSpells.applyFog(_loc6_.pos,_loc6_.duration,_loc6_.radius,_loc5_);
                  break;
               case SE_SPELL_RAGE:
                  this.logicSpells.applyRage(_loc6_.pos,_loc6_.duration,_loc6_.radius,_loc6_.move_k,_loc6_.attack_k,_loc5_);
                  break;
               case SE_SPELL_LOW_DAMAGE:
                  this.logicSpells.applyLowDamage(_loc6_.pos,_loc6_.duration,_loc6_.radius,_loc6_.damage_k,_loc5_);
                  break;
               case SE_FINISH:
                  _loc3_ = true;
                  break;
               default:
                  throw new Error("bad sim kind=" + _loc6_.kind);
            }
            if(param2)
            {
               if(getTimer() - _loc4_ > 40)
               {
                  break;
               }
            }
         }
         return _loc3_;
      }
      
      public function addUnitEvent(param1:PShopUnit, param2:PHero, param3:uint, param4:Position, param5:Position, param6:int, param7:uint = 0) : void
      {
         var _loc8_:int = this.data.addUnits(param1,param2,param3,param4,param5,param7);
         if(_loc8_ < 0)
         {
            return;
         }
         _loc8_ -= param3 - 1;
         var _loc9_:int = this.data.references.units_landing_period;
         while(param3 > 0)
         {
            this.pq.add(param6,SimFun.createActivateUnit(_loc8_),true);
            _loc8_++;
            param6 += _loc9_;
            param3--;
         }
      }
      
      public function addDefenderEvent(param1:PShopUnit, param2:int, param3:Position, param4:int) : void
      {
         this.data.addDefenderUnit(param1,param2,param3);
         this.pq.add(param4,SimFun.createActivateUnit(param2),true);
      }
      
      public function changeSimRun(param1:SimRun) : void
      {
         this.simRun = this.logicSpells.simRun = this.logicCannons.simRun = this.logicUnits.simRun = param1;
      }
      
      public function getSimRun() : SimRun
      {
         return this.simRun;
      }
      
      public function addSpellEvent(param1:int, param2:Position, param3:PShopSpell, param4:int, param5:Boolean) : void
      {
         this.pq.add(param1,SimFun.createActivateSpell(new Point(param2.x,param2.y),param3,param4,param5),true);
      }
      
      public function changePower(param1:int) : void
      {
         this.data.power += param1;
         this.simRun.changePower(this.data.power,param1);
      }
      
      public function getDamage() : uint
      {
         var _loc2_:SimBuildingT = null;
         var _loc3_:SimCannonT = null;
         var _loc1_:int = this.data.all_stamina;
         for each(_loc2_ in this.data.buildings)
         {
            _loc1_ -= _loc2_.stamina;
         }
         for each(_loc3_ in this.data.cannons)
         {
            _loc1_ -= _loc3_.stamina;
         }
         return Math.floor(_loc1_ / this.data.all_stamina * 100);
      }
   }
}

