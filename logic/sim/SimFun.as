package logic.sim
{
   import engine.Position;
   import flash.geom.Point;
   import proto.model.PBtype;
   import proto.model.PCannonTargetType;
   import proto.model.PShopSpell;
   
   public class SimFun
   {
      
      public static var UNITS_LANDING_PERIOD:int;
      
      public static var LANDING_ANIM_TIME:int;
      
      public var data:SimData;
      
      public var pq:PriorityQueue;
      
      private var quad:Quadrants;
      
      private var ahealers:Vector.<int> = new Vector.<int>();
      
      private var thealers:Vector.<int> = new Vector.<int>();
      
      private var fences_wish:Hashtbl = new Hashtbl();
      
      public function SimFun(param1:SimData, param2:PriorityQueue)
      {
         super();
         this.data = param1;
         this.pq = param2;
         this.quad = new Quadrants(param1.board.w,param1.board.h);
         UNITS_LANDING_PERIOD = param1.references.units_landing_period;
         LANDING_ANIM_TIME = param1.references.landing_anim_time;
      }
      
      public static function createCannonFindTarget(param1:int) : Object
      {
         var _loc2_:Object = {};
         _loc2_.kind = Sim.SE_CANNON_FIND_TARGET;
         _loc2_.id = param1;
         return _loc2_;
      }
      
      public static function createCannonAttackUnit(param1:int, param2:int, param3:Boolean, param4:Point) : Object
      {
         var _loc5_:Object = {};
         _loc5_.kind = Sim.SE_CANNON_ATTACK_UNIT;
         _loc5_.id = param1;
         _loc5_.unit_id = param2;
         _loc5_.is_init = param3;
         _loc5_.pos = param4;
         return _loc5_;
      }
      
      public static function createCannonFire(param1:SimCannonT, param2:int, param3:Point) : Object
      {
         var _loc4_:Object = {};
         _loc4_.kind = Sim.SE_CANNON_FIRE;
         _loc4_.c = param1;
         _loc4_.unit_id = param2;
         _loc4_.pos = param3;
         return _loc4_;
      }
      
      public static function createFinish() : Object
      {
         var _loc1_:Object = {};
         _loc1_.kind = Sim.SE_FINISH;
         return _loc1_;
      }
      
      public static function createUnitGoTo(param1:int, param2:Boolean) : Object
      {
         var _loc3_:Object = {};
         _loc3_.kind = Sim.SE_UNIT_GO_TO;
         _loc3_.id = param1;
         _loc3_.is_init = param2;
         return _loc3_;
      }
      
      public static function createInitUnit(param1:int) : Object
      {
         var _loc2_:Object = {};
         _loc2_.kind = Sim.SE_INIT_UNIT;
         _loc2_.id = param1;
         return _loc2_;
      }
      
      public static function createActivateUnit(param1:int) : Object
      {
         var _loc2_:Object = {};
         _loc2_.kind = Sim.SE_ACTIVATE_UNIT;
         _loc2_.id = param1;
         return _loc2_;
      }
      
      public static function createUnitAttack(param1:int, param2:SimBoardObj, param3:Boolean) : Object
      {
         var _loc4_:Object = {};
         _loc4_.kind = Sim.SE_UNIT_ATTACK;
         _loc4_.id = param1;
         _loc4_.is_init = param3;
         _loc4_.target_id = param2;
         return _loc4_;
      }
      
      public static function createUnitFireAttack(param1:SimUnitT, param2:SimBoardObj, param3:Point) : Object
      {
         var _loc4_:Object = {};
         _loc4_.kind = Sim.SE_UNIT_FIRE_ATTACK;
         _loc4_.u = param1;
         _loc4_.pos = param3;
         _loc4_.target_id = param2;
         return _loc4_;
      }
      
      public static function createActivateSpell(param1:Point, param2:PShopSpell, param3:int, param4:Boolean) : Object
      {
         var _loc5_:Object = {};
         _loc5_.kind = Sim.SE_ACTIVATE_SPELL;
         _loc5_.pos = param1;
         _loc5_.shop = param2;
         _loc5_.user_num = param3;
         _loc5_.is_attacker = param4;
         return _loc5_;
      }
      
      public static function createSpellFireball(param1:Point, param2:int, param3:int, param4:Boolean) : Object
      {
         var _loc5_:Object = {};
         _loc5_.kind = Sim.SE_SPELL_FIREBALL;
         _loc5_.pos = param1;
         _loc5_.radius = param2;
         _loc5_.damage = param3;
         _loc5_.is_attacker = param4;
         return _loc5_;
      }
      
      public static function createSpellCure(param1:Point, param2:int, param3:int, param4:int, param5:int, param6:Boolean) : Object
      {
         var _loc7_:Object = {};
         _loc7_.kind = Sim.SE_SPELL_CURE;
         _loc7_.pos = param1;
         _loc7_.duration = param2;
         _loc7_.stamina = param3;
         _loc7_.radius = param4;
         _loc7_.count = param5;
         _loc7_.is_attacker = param6;
         return _loc7_;
      }
      
      public static function createSpellWorker(param1:Point, param2:int, param3:int, param4:int, param5:int, param6:Boolean) : Object
      {
         var _loc7_:Object = {};
         _loc7_.kind = Sim.SE_SPELL_WORKER;
         _loc7_.pos = param1;
         _loc7_.duration = param2;
         _loc7_.stamina = param3;
         _loc7_.radius = param4;
         _loc7_.count = param5;
         _loc7_.is_attacker = param6;
         return _loc7_;
      }
      
      public static function createSpellShock(param1:Point, param2:int, param3:int, param4:Boolean, param5:Boolean) : Object
      {
         var _loc6_:Object = {};
         _loc6_.kind = Sim.SE_SPELL_SHOCK;
         _loc6_.pos = param1;
         _loc6_.duration = param2;
         _loc6_.radius = param3;
         _loc6_.start = param4;
         _loc6_.is_attacker = param5;
         return _loc6_;
      }
      
      public static function createSpellMultifireball(param1:Point, param2:int, param3:int, param4:int, param5:Number, param6:int, param7:Boolean) : Object
      {
         var _loc8_:Object = {};
         _loc8_.kind = Sim.SE_SPELL_MULTIFIREBALL;
         _loc8_.pos = param1;
         _loc8_.period = param2;
         _loc8_.radius = param3;
         _loc8_.damage = param4;
         _loc8_.penetration = param5;
         _loc8_.count = param6;
         _loc8_.is_attacker = param7;
         return _loc8_;
      }
      
      public static function createSpellFog(param1:Point, param2:int, param3:int, param4:Boolean) : Object
      {
         var _loc5_:Object = {};
         _loc5_.kind = Sim.SE_SPELL_FOG;
         _loc5_.pos = param1;
         _loc5_.duration = param2;
         _loc5_.radius = param3;
         _loc5_.is_attacker = param4;
         return _loc5_;
      }
      
      public static function createSpellRage(param1:Point, param2:Number, param3:Number, param4:int, param5:int, param6:Boolean) : Object
      {
         var _loc7_:Object = {};
         _loc7_.kind = Sim.SE_SPELL_RAGE;
         _loc7_.pos = param1;
         _loc7_.move_k = param2;
         _loc7_.attack_k = param3;
         _loc7_.duration = param4;
         _loc7_.radius = param5;
         _loc7_.is_attacker = param6;
         return _loc7_;
      }
      
      public static function createSpellLowDamage(param1:Point, param2:int, param3:int, param4:Number, param5:Boolean) : Object
      {
         var _loc6_:Object = {};
         _loc6_.kind = Sim.SE_SPELL_LOW_DAMAGE;
         _loc6_.pos = param1;
         _loc6_.damage_k = param4;
         _loc6_.duration = param2;
         _loc6_.radius = param3;
         _loc6_.is_attacker = param5;
         return _loc6_;
      }
      
      public static function createSpellCall(param1:Point, param2:int, param3:int, param4:Boolean) : Object
      {
         var _loc5_:Object = {};
         _loc5_.kind = Sim.SE_SPELL_CALL;
         _loc5_.pos = param1;
         _loc5_.duration = param2;
         _loc5_.user_num = param3;
         _loc5_.is_attacker = param4;
         return _loc5_;
      }
      
      public static function pointExistsInVector(param1:Vector.<Point>, param2:Point) : Boolean
      {
         var _loc4_:* = 0;
         var _loc3_:Boolean = false;
         if(param1.length > 0)
         {
            _loc4_ = int(param1.length - 1);
            while(_loc4_ >= 0)
            {
               if(param2.equals(param1[_loc4_]))
               {
                  _loc3_ = true;
               }
               _loc4_--;
            }
         }
         return _loc3_;
      }
      
      public static function existsInVector(param1:Vector.<Point>, param2:Function) : Boolean
      {
         var _loc4_:* = 0;
         var _loc3_:Boolean = false;
         if(param1.length > 0)
         {
            _loc4_ = int(param1.length - 1);
            while(_loc4_ >= 0)
            {
               if(param2(param1[_loc4_]))
               {
                  _loc3_ = true;
               }
               _loc4_--;
            }
         }
         return _loc3_;
      }
      
      public static function vectorPointToProtoPath(param1:Vector.<Point>) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(Position.create(param1[_loc3_].x,param1[_loc3_].y));
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function pointToPosition(param1:Point) : Position
      {
         return Position.create(param1.x,param1.y);
      }
      
      public static function equalVectors(param1:Vector.<Point>, param2:Vector.<Point>) : Boolean
      {
         var _loc4_:* = 0;
         var _loc3_:Boolean = Boolean(param1) && Boolean(param2) && param1.length == param2.length;
         if(_loc3_ && param1.length > 0)
         {
            _loc4_ = int(param1.length - 1);
            while(_loc4_ >= 0)
            {
               if(!param2[_loc4_] || Boolean(param2[_loc4_]) && Boolean(!param2[_loc4_].equals(param1[_loc4_])))
               {
                  _loc3_ = false;
               }
               _loc4_--;
            }
         }
         return _loc3_;
      }
      
      public static function Point2Int(param1:int, param2:int) : int
      {
         return param1 << 6 | param2;
      }
      
      public static function Int2Point(param1:int) : Point
      {
         return new Point(param1 >> 6,param1 & 0x3F);
      }
      
      public function calcDamage(param1:int, param2:Number, param3:int, param4:Number, param5:int, param6:int, param7:int) : int
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(param5 <= param6 - param3)
         {
            _loc8_ = Math.floor(param1 * param4);
         }
         else
         {
            _loc9_ = param5 - (param6 - param3);
            _loc10_ = Math.floor(param1 * param2 * param4);
            if(_loc10_ <= _loc9_)
            {
               _loc8_ = _loc10_;
            }
            else
            {
               _loc8_ = Math.floor((_loc10_ - _loc9_) / param2);
               _loc8_ = _loc8_ + _loc9_;
            }
         }
         return _loc8_;
      }
      
      public function cannonDecStamina(param1:int, param2:SimCannonT) : void
      {
         if(param2.stamina - param1 < 0)
         {
            param2.stamina = 0;
         }
         else
         {
            param2.stamina -= param1;
         }
      }
      
      public function buildingDecStamina(param1:int, param2:SimBuildingT) : void
      {
         if(param2.stamina - param1 < 0)
         {
            param2.stamina = 0;
         }
         else
         {
            param2.stamina -= param1;
         }
      }
      
      public function fenceDecStamina(param1:int, param2:SimFenceT) : void
      {
         if(param2.stamina - param1 < 0)
         {
            param2.stamina = 0;
         }
         else
         {
            param2.stamina -= param1;
         }
      }
      
      public function unitDecStamina(param1:int, param2:SimUnitT) : void
      {
         if(param2.stamina - param1 < 0)
         {
            param2.stamina = 0;
         }
         else
         {
            param2.stamina -= param1;
         }
      }
      
      public function unitIncStamina(param1:int, param2:SimUnitT) : void
      {
         var _loc3_:int = 0;
         if(param2.stamina < param2.max_stamina)
         {
            _loc3_ = param1;
            if(param2.stamina + param1 > param2.max_stamina)
            {
               _loc3_ = param2.max_stamina - param2.stamina;
            }
            param2.stamina += _loc3_;
            param2.cure_count += _loc3_;
         }
      }
      
      public function buildingIncStamina(param1:int, param2:SimBuildingT) : void
      {
         if(param2.stamina < param2.max_stamina && param2.stamina > 0)
         {
            if(param2.stamina + param1 > param2.max_stamina)
            {
               param2.stamina = param2.max_stamina;
            }
            else
            {
               param2.stamina += param1;
            }
         }
      }
      
      public function cannonIncStamina(param1:int, param2:SimCannonT) : void
      {
         if(param2.stamina < param2.max_stamina && param2.stamina > 0)
         {
            if(param2.stamina + param1 > param2.max_stamina)
            {
               param2.stamina = param2.max_stamina;
            }
            else
            {
               param2.stamina += param1;
            }
         }
      }
      
      public function fenceIncStamina(param1:int, param2:SimFenceT) : void
      {
         if(param2.stamina < param2.max_stamina && param2.stamina > 0)
         {
            if(param2.stamina + param1 > param2.max_stamina)
            {
               param2.stamina = param2.max_stamina;
            }
            else
            {
               param2.stamina += param1;
            }
         }
      }
      
      public function cannonExists(param1:int) : Boolean
      {
         return this.data.cannons.mem(param1);
      }
      
      public function unitExists(param1:int) : Boolean
      {
         return this.data.units.mem(param1);
      }
      
      public function buildingExists(param1:int) : Boolean
      {
         return this.data.buildings.mem(param1);
      }
      
      public function fenceExists(param1:int) : Boolean
      {
         return this.data.fences.mem(param1);
      }
      
      public function fenceById(param1:int) : SimFenceT
      {
         return this.data.fences.find(param1);
      }
      
      public function cannonById(param1:int) : SimCannonT
      {
         return this.data.cannons.find(param1);
      }
      
      public function buildingById(param1:int) : SimBuildingT
      {
         return this.data.buildings.find(param1);
      }
      
      public function unitById(param1:int) : SimUnitT
      {
         return this.data.units.find(param1);
      }
      
      public function moveUnit(param1:Point, param2:SimUnitT) : void
      {
         this.data.board.removeUnit(param2.id,param2.pos);
         this.data.board.addUnit(param2.id,param1);
         this.quad.move(param2.pos,param1,param2.is_attacker,param2.id);
         param2.prev_pos = param2.pos;
         param2.pos = param1;
      }
      
      public function activateUnit(param1:SimUnitT) : void
      {
         this.data.board.addUnit(param1.id,param1.pos);
         this.quad.add(param1.is_attacker,param1.pos,param1.id);
      }
      
      public function deactivateUnit(param1:SimUnitT) : void
      {
         this.resetRegPos(param1);
         this.data.board.removeUnit(param1.id,param1.pos);
         this.quad.remove(param1.is_attacker,param1.pos,param1.id);
      }
      
      private function incPower(param1:int, param2:SimRun, param3:int) : void
      {
         if(this.data.powerK > 0)
         {
            this.data.power += param1;
            param2.changePower(this.data.power,param1,param3,this.data.isBoss);
         }
      }
      
      public function removeUnit(param1:SimUnitT, param2:SimRun) : void
      {
         if(param1.is_attacker && (param1.user_num <= 1 || this.data.isBoss))
         {
            this.incPower(param1.shop.su_power_points,param2,param1.id);
         }
         this.resetRegPos(param1);
         this.data.board.removeUnit(param1.id,param1.pos);
         this.quad.remove(param1.is_attacker,param1.pos,param1.id);
         this.data.units.remove(param1.id);
         param2.unitDeath(param1);
      }
      
      public function resetRegPos(param1:SimUnitT) : void
      {
         if(param1.reg_pos)
         {
            this.data.board.removeReg(param1.id,param1.reg_pos);
            param1.reg_pos = null;
         }
      }
      
      public function setRegPos(param1:Point, param2:SimUnitT) : void
      {
         this.resetRegPos(param2);
         this.data.board.addReg(param2.id,param1);
         param2.reg_pos = param1;
      }
      
      public function removeCannon(param1:SimCannonT, param2:SimRun) : void
      {
         this.data.board.removeObject(new SimBoardObj(SimBoardObj.CANNON,param1.id),param1.pos,param1.size);
         this.data.board.unregisterCannon(param1.id,SimBoard.findCenter(param1.pos,param1.size),param1.size,param1.radius);
         this.data.cannons.remove(param1.id);
         ++this.data.rmCannonCount;
      }
      
      public function removeBuilding(param1:SimBuildingT, param2:SimRun) : void
      {
         var b:SimBuildingT = param1;
         var simRun:SimRun = param2;
         this.data.board.removeObject(new SimBoardObj(SimBoardObj.BUILDING,b.id),b.pos,b.size);
         if(b.type == PBtype.GUARD)
         {
            this.data.board.unregisterGuard(b.id,SimBoard.findCenter(b.pos,b.size),b.size,b.guard_radius);
         }
         else if(b.type == PBtype.PYLON)
         {
            this.data.cannons.iter(function(param1:int, param2:SimCannonT):void
            {
               param2.removePylon(b.id);
            });
         }
         this.data.buildings.remove(b.id);
         ++this.data.rmBuildCount;
      }
      
      public function removeFence(param1:SimFenceT) : void
      {
         this.data.board.removeObject(new SimBoardObj(SimBoardObj.FENCE,param1.id),param1.pos,param1.size);
         this.data.fences.remove(param1.id);
      }
      
      public function checkUnitType(param1:SimUnitT, param2:SimUnitT) : Boolean
      {
         var _loc3_:Boolean = true;
         if(param1.target_type == PCannonTargetType.GROUND && param2.is_air || param1.target_type == PCannonTargetType.AIR && !param2.is_air)
         {
            _loc3_ = false;
         }
         return _loc3_;
      }
      
      public function findAnyUnit(param1:SimUnitT, param2:int) : SimUnitT
      {
         var res:SimUnitT = null;
         var d:int = 0;
         var iterator:Function = null;
         var for_u:SimUnitT = param1;
         var etime:int = param2;
         iterator = function(param1:int, param2:SimUnitT):void
         {
            var _loc3_:int = SimBoard.distance2(param2.pos,for_u.pos);
            if(checkUnitType(for_u,param2) && param2.is_attacker != for_u.is_attacker && param2.is_active && param2.stamina > 0 && (_loc3_ < d || _loc3_ == d && param2.id < res.id))
            {
               res = param2;
               d = _loc3_;
            }
         };
         res = null;
         d = int.MAX_VALUE;
         this.data.units.iter(iterator);
         return res;
      }
      
      public function findEnemy(param1:Function, param2:SimUnitT, param3:int) : SimUnitT
      {
         var d:int = 0;
         var i:int = 0;
         var id:int = 0;
         var u:SimUnitT = null;
         var distance:int = 0;
         var f:Function = param1;
         var for_u:SimUnitT = param2;
         var etime:int = param3;
         var res:SimUnitT = null;
         var hs:Vector.<int> = this.quad.findNeigbours(for_u.is_attacker,for_u.pos);
         if(hs)
         {
            hs = hs.sort(function(param1:int, param2:int):Number
            {
               return param2 - param1;
            });
            d = int.MAX_VALUE;
            if(hs.length > 0)
            {
               i = hs.length - 1;
               while(i >= 0)
               {
                  id = hs[i];
                  if(this.unitExists(id))
                  {
                     u = this.unitById(id);
                     f(u);
                     distance = SimBoard.distance2(u.pos,for_u.pos);
                     if(this.checkUnitType(for_u,u) && distance < d || distance == d && u.id < res.id)
                     {
                        res = u;
                        d = distance;
                     }
                  }
                  i--;
               }
            }
         }
         return res;
      }
      
      public function attackersOnPos(param1:Point) : Vector.<int>
      {
         return this.quad.attackersOnPos(param1);
      }
      
      public function defendersInQuad(param1:Point) : Vector.<int>
      {
         var pos:Point = param1;
         var res:Vector.<int> = this.quad.findNeigbours(true,pos);
         return res.sort(function(param1:int, param2:int):Number
         {
            return param2 - param1;
         });
      }
      
      public function resetFenceWish(param1:SimUnitT) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         for each(_loc2_ in param1.fences_wish)
         {
            if(this.fences_wish.mem(_loc2_))
            {
               _loc3_ = this.fences_wish.find(_loc2_);
               if(_loc3_.indexOf(param1.id) >= 0)
               {
                  _loc3_.splice(_loc3_.indexOf(param1.id),1);
               }
            }
         }
         param1.fences_wish = new Vector.<int>();
      }
      
      public function regFenceWish(param1:int, param2:SimUnitT) : void
      {
         var _loc5_:Point = null;
         var _loc6_:SimBoardElt = null;
         this.resetFenceWish(param2);
         var _loc3_:SimFenceT = this.fenceById(param1);
         var _loc4_:Vector.<Point> = this.data.board.rhombs(new Point(_loc3_.pos.x + 3,_loc3_.pos.y + 3),new Point(7,7));
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = this.data.board.getElt(_loc5_.x,_loc5_.y);
            if((Boolean(_loc6_)) && Boolean(_loc6_.obj) && _loc6_.obj.kind == SimBoardObj.FENCE)
            {
               if(this.fences_wish.mem(_loc6_.obj.id))
               {
                  this.fences_wish.find(_loc6_.obj.id).push(param2.id);
               }
               else
               {
                  this.fences_wish.add(_loc6_.obj.id,new <int>[param2.id]);
               }
               param2.fences_wish.push(_loc6_.obj.id);
            }
         }
      }
      
      public function notifyFenceWish(param1:int) : void
      {
         var _loc2_:int = 0;
         if(this.fences_wish.mem(param1))
         {
            for each(_loc2_ in this.fences_wish.find(param1))
            {
               if(this.unitExists(_loc2_))
               {
                  this.unitById(_loc2_).recalc_path = true;
               }
            }
         }
      }
      
      public function unitApplyEffects(param1:SimCannonT, param2:SimUnitT, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         if(param1.slowdown > 0)
         {
            _loc4_ = param3 + param1.slowdown_time;
            _loc5_ = false;
            for each(_loc6_ in param2.effects)
            {
               if(_loc6_.kind == SimUnitT.EFFECT_SLOWDOWN)
               {
                  _loc6_.value = param1.slowdown;
                  _loc6_.end_time = _loc4_;
                  _loc5_ = true;
               }
            }
            if(!_loc5_)
            {
               _loc7_ = {};
               _loc7_.kind = SimUnitT.EFFECT_SLOWDOWN;
               _loc7_.value = param1.slowdown;
               _loc7_.end_time = _loc4_;
               param2.addEffect(_loc7_);
            }
         }
      }
      
      public function addToHealers(param1:SimUnitT) : void
      {
         if(param1.is_healer && param1.is_attacker && this.ahealers.indexOf(param1.id) < 0)
         {
            this.ahealers.unshift(param1.id);
         }
         else if(param1.is_healer && !param1.is_attacker && this.thealers.indexOf(param1.id) < 0)
         {
            this.thealers.unshift(param1.id);
         }
      }
      
      public function notifyHealers(param1:SimUnitT, param2:int) : void
      {
         var _loc3_:Number = NaN;
         if(param1.is_attacker && this.ahealers.length > 0)
         {
            _loc3_ = this.ahealers[0];
            this.ahealers.splice(0,1);
         }
         else if(!param1.is_attacker && this.thealers.length > 0)
         {
            _loc3_ = this.thealers[0];
            this.thealers.splice(0,1);
         }
         if(!isNaN(_loc3_) && this.unitExists(_loc3_))
         {
            this.unitById(_loc3_).setInitState();
            this.pq.add(param2,SimFun.createInitUnit(_loc3_));
         }
      }
      
      public function unitSpeedMove(param1:SimUnitT, param2:int, param3:int) : int
      {
         var _loc6_:Number = NaN;
         var _loc4_:int = param1.speed(param2,param3);
         var _loc5_:SimBoardElt = this.data.board.getElt(param1.pos.x,param1.pos.y);
         if(_loc5_)
         {
            _loc6_ = _loc5_.get_modif(SimModif.MOVE_K,param3);
            if(!isNaN(_loc6_))
            {
               _loc4_ = int(_loc4_ * _loc6_);
            }
         }
         return _loc4_;
      }
      
      public function unitSpeedAttack(param1:SimUnitT, param2:int, param3:int) : int
      {
         var _loc6_:Number = NaN;
         var _loc4_:int = param1.speed(param2,param3);
         var _loc5_:SimBoardElt = this.data.board.getElt(param1.pos.x,param1.pos.y);
         if(_loc5_)
         {
            _loc6_ = _loc5_.get_modif(SimModif.ATTACK_K,param3);
            if(!isNaN(_loc6_))
            {
               _loc4_ = int(_loc4_ * _loc6_);
            }
         }
         return _loc4_;
      }
      
      public function defenderExist() : Boolean
      {
         var res:Boolean = false;
         var iterator:Function = null;
         iterator = function(param1:int, param2:SimUnitT):void
         {
            res = !param2.is_attacker && param2.stamina > 0 && param2.is_active || res;
         };
         res = false;
         this.data.units.iter(iterator);
         return res;
      }
   }
}

