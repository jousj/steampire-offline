package logic.sim
{
   import flash.geom.Point;
   import proto.model.PCannonTargetType;
   
   public class LCannons
   {
      
      private var pq:PriorityQueue;
      
      private var simFun:SimFun;
      
      public var logicUnits:LUnits;
      
      public var simRun:SimRun;
      
      public function LCannons(param1:PriorityQueue, param2:SimFun, param3:SimRun)
      {
         super();
         this.pq = param1;
         this.simFun = param2;
         this.simRun = param3;
      }
      
      private function checkUtype(param1:SimCannonT, param2:SimUnitT, param3:int) : Boolean
      {
         return param1.target_type == PCannonTargetType.ANY || param2.attacked_by.indexOf(param1.target_type) >= 0;
      }
      
      private function applyDamageSimple(param1:SimCannonT, param2:int, param3:int) : void
      {
         var _loc4_:SimUnitT = null;
         var _loc5_:int = 0;
         var _loc6_:SimBoardElt = null;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         if(this.simFun.unitExists(param2))
         {
            _loc4_ = this.simFun.unitById(param2);
            if(this.checkUtype(param1,_loc4_,param3))
            {
               _loc5_ = param1.damage;
               if(param1.favorite_units.indexOf(_loc4_.kind) >= 0)
               {
                  _loc5_ = int(_loc5_ * param1.favorite_dmg_koef);
               }
               _loc6_ = this.simFun.data.board.getElt(_loc4_.pos.x,_loc4_.pos.y);
               if(_loc6_)
               {
                  _loc8_ = _loc6_.get_modif(SimModif.DAMAGE_K,param3);
                  if(!isNaN(_loc8_))
                  {
                     _loc5_ = int(_loc5_ * _loc8_);
                  }
               }
               _loc7_ = this.simFun.calcDamage(_loc5_,param1.penetration,_loc4_.armor,1,_loc4_.stamina,_loc4_.max_stamina,param3);
               this.simFun.unitDecStamina(_loc7_,_loc4_);
               this.simFun.unitApplyEffects(param1,_loc4_,param3);
               if(_loc4_.stamina == 0)
               {
                  this.simFun.removeUnit(_loc4_,this.simRun);
               }
               else
               {
                  this.simFun.notifyHealers(_loc4_,param3);
               }
               this.simRun.applyDamage(new SimBoardObj(SimBoardObj.UNIT,param2),_loc4_.stamina,param3);
            }
         }
      }
      
      public function applyDamage(param1:SimCannonT, param2:int, param3:Point, param4:int) : void
      {
         var r:int = 0;
         var min_x:int = 0;
         var max_x:int = 0;
         var min_y:int = 0;
         var max_y:int = 0;
         var units_ids:Vector.<int> = null;
         var sorted_units_ids:Vector.<int> = null;
         var i:int = 0;
         var tu:SimUnitT = null;
         var c:SimCannonT = param1;
         var unit_id:int = param2;
         var p:Point = param3;
         var etime:int = param4;
         if(c.aoe_radius > 0)
         {
            if(c.shop.sc_kind == "cn_dwarf_tower" || c.shop.sc_kind == "cn_magnetic_tower")
            {
               p = SimBoard.findCenter(c.pos,c.size);
            }
            r = c.aoe_radius - 1;
            min_x = p.x - r;
            max_x = p.x + r;
            min_y = p.y - r;
            max_y = p.y + r;
            units_ids = new Vector.<int>();
            this.simFun.data.units.iter(function(param1:int, param2:SimUnitT):void
            {
               if(param2.pos.x >= min_x && param2.pos.x <= max_x && param2.pos.y >= min_y && param2.pos.y <= max_y && param2.is_attacker && param2.is_active)
               {
                  units_ids.push(param1);
               }
            });
            if(units_ids.length > 0)
            {
               sorted_units_ids = units_ids.sort(function(param1:int, param2:int):Number
               {
                  return param2 - param1;
               });
               i = sorted_units_ids.length - 1;
               while(i >= 0)
               {
                  if(c.shop.sc_kind == "cn_magnetic_tower")
                  {
                     tu = this.simFun.unitById(sorted_units_ids[i]);
                     this.logicUnits.applyCall(tu,p,c.slowdown_time,NaN,etime);
                  }
                  else
                  {
                     this.applyDamageSimple(c,sorted_units_ids[i],etime);
                  }
                  i--;
               }
            }
         }
         else
         {
            this.applyDamageSimple(c,unit_id,etime);
         }
      }
      
      private function canAttackUnit(param1:SimCannonT, param2:SimUnitT, param3:int) : Boolean
      {
         var _loc4_:int = SimBoard.radius(param1.radius);
         var _loc5_:int = SimBoard.radius(param1.blind_radius);
         var _loc6_:Point = SimBoard.findCenter(param1.pos,param1.size);
         var _loc7_:int = SimBoard.distance2(_loc6_,param2.pos);
         var _loc8_:Boolean = true;
         var _loc9_:SimBoardElt = this.simFun.data.board.getElt(param2.pos.x,param2.pos.y);
         if(_loc9_)
         {
            _loc8_ = isNaN(_loc9_.get_modif(SimModif.INVISIBLE,param3));
         }
         return param2.is_attacker && param2.is_active && this.checkUtype(param1,param2,param3) && param2.stamina > 0 && param1.canFire(param3) && _loc4_ >= _loc7_ && _loc7_ > _loc5_ && _loc8_;
      }
      
      public function targetInArea(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:SimCannonT = null;
         var _loc5_:SimUnitT = null;
         if(this.simFun.cannonExists(param1) && this.simFun.unitExists(param2))
         {
            _loc4_ = this.simFun.cannonById(param1);
            if(_loc4_.stamina > 0)
            {
               _loc5_ = this.simFun.unitById(param2);
               if(_loc4_.state == SimCannonT.INIT && this.canAttackUnit(_loc4_,_loc5_,param3))
               {
                  if(_loc4_.is_no_target)
                  {
                     _loc4_.is_no_target = false;
                     this.simRun.attention(param1);
                  }
                  this.attack(true,param1,param2,_loc5_.pos,param3);
               }
            }
         }
      }
      
      public function attack(param1:Boolean, param2:int, param3:int, param4:Point, param5:int) : void
      {
         var makeInit:Function;
         var c:SimCannonT = null;
         var center_pos:Point = null;
         var distance:Number = NaN;
         var bullet_dt:Number = NaN;
         var bullet_time:int = 0;
         var time:int = 0;
         var u:SimUnitT = null;
         var atime:int = 0;
         var is_init:Boolean = param1;
         var id:int = param2;
         var unit_id:int = param3;
         var pos:Point = param4;
         var etime:int = param5;
         if(this.simFun.cannonExists(id))
         {
            makeInit = function():void
            {
               if(is_init)
               {
                  findTarget(id,etime);
               }
               else
               {
                  pq.add(etime + c.attack_delay,SimFun.createCannonFindTarget(id));
               }
            };
            c = this.simFun.cannonById(id);
            center_pos = SimBoard.findCenter(c.pos,c.size);
            if(this.simFun.unitExists(unit_id))
            {
               u = this.simFun.unitById(unit_id);
               if(is_init && this.canAttackUnit(c,u,etime))
               {
                  c.state = SimCannonT.ATTACK;
                  atime = etime + c.attack_time;
                  this.pq.add(atime,SimFun.createCannonAttackUnit(id,unit_id,false,u.pos));
                  this.simRun.cannonPrepareAttack(c.id,u.pos,atime,unit_id);
               }
               else if(!is_init && c.aoe_radius > 0 && c.canFire(etime))
               {
                  distance = SimBoard.distancef(pos,center_pos);
                  bullet_dt = Math.floor(c.bullet_speed * distance);
                  bullet_time = etime + bullet_dt;
                  time = etime + c.attack_delay;
                  c.state = SimCannonT.ATTACK;
                  this.pq.add(bullet_time,SimFun.createCannonFire(c,unit_id,pos));
                  this.simRun.cannonFireAttack(id,pos,bullet_time,unit_id);
                  if(this.canAttackUnit(c,u,etime))
                  {
                     this.pq.add(time,SimFun.createCannonAttackUnit(id,unit_id,!is_init,pos));
                  }
                  else
                  {
                     this.pq.add(time,SimFun.createCannonFindTarget(id));
                  }
               }
               else if(!is_init && this.simFun.unitExists(unit_id) && this.canAttackUnit(c,u,etime))
               {
                  u = this.simFun.unitById(unit_id);
                  distance = SimBoard.distancef(u.pos,center_pos);
                  bullet_dt = Math.floor(c.bullet_speed * distance);
                  bullet_time = etime + bullet_dt;
                  time = etime + c.attack_delay;
                  c.state = SimCannonT.ATTACK;
                  this.pq.add(bullet_time,SimFun.createCannonFire(c,unit_id,u.pos));
                  this.simRun.cannonFireAttack(id,u.pos,bullet_time,unit_id);
                  this.pq.add(time,SimFun.createCannonAttackUnit(id,unit_id,!is_init,u.pos));
               }
               else
               {
                  makeInit();
               }
            }
            else
            {
               makeInit();
            }
         }
      }
      
      public function findTarget(param1:int, param2:int) : void
      {
         var c:SimCannonT = null;
         var center_pos:Point = null;
         var target_id:int = 0;
         var d:int = 0;
         var s:int = 0;
         var id:int = param1;
         var etime:int = param2;
         if(this.simFun.cannonExists(id))
         {
            c = this.simFun.cannonById(id);
            if(c.canFire(etime))
            {
               c.state = SimCannonT.INIT;
               center_pos = SimBoard.findCenter(c.pos,c.size);
               target_id = 0;
               if(c.sort_by_distance)
               {
                  this.simFun.data.units.iter(function(param1:int, param2:SimUnitT):void
                  {
                     var _loc3_:int = 0;
                     if(canAttackUnit(c,param2,etime))
                     {
                        _loc3_ = SimBoard.distance2(center_pos,param2.pos);
                        if(!(Boolean(d) && Boolean(d < _loc3_) || Boolean(d && d == _loc3_) && Boolean(target_id < param2.id)))
                        {
                           d = _loc3_;
                           target_id = param2.id;
                        }
                     }
                  });
               }
               else
               {
                  this.simFun.data.units.iter(function(param1:int, param2:SimUnitT):void
                  {
                     var _loc3_:int = 0;
                     if(canAttackUnit(c,param2,etime))
                     {
                        _loc3_ = param2.stamina;
                        if(!(Boolean(s) && Boolean(s > _loc3_) || Boolean(s && s == _loc3_) && Boolean(target_id < param2.id)))
                        {
                           s = _loc3_;
                           target_id = param2.id;
                        }
                     }
                  });
               }
               if(target_id > 0)
               {
                  this.targetInArea(id,target_id,etime);
               }
               else
               {
                  c.is_no_target = true;
               }
            }
            else
            {
               c.state = SimCannonT.INIT;
               c.is_no_target = true;
            }
         }
      }
   }
}

