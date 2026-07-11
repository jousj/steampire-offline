package logic.sim
{
   import flash.geom.Point;
   import proto.model.PShopSpell;
   import proto.model.spell.PCall;
   import proto.model.spell.PCure;
   import proto.model.spell.PEffect;
   import proto.model.spell.PFireball;
   import proto.model.spell.PFog;
   import proto.model.spell.PLowDamage;
   import proto.model.spell.PMultifireball;
   import proto.model.spell.PRage;
   import proto.model.spell.PShock;
   
   public class LSpells
   {
      
      private var pq:PriorityQueue;
      
      private var simFun:SimFun;
      
      private var logicUnits:LUnits;
      
      public var simRun:SimRun;
      
      public function LSpells(param1:LUnits, param2:PriorityQueue, param3:SimFun, param4:SimRun)
      {
         super();
         this.pq = param2;
         this.logicUnits = param1;
         this.simFun = param3;
         this.simRun = param4;
      }
      
      private function applySpellDamageSimple(param1:int, param2:SimBoardObj, param3:Number, param4:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:SimCannonT = null;
         var _loc10_:SimBuildingT = null;
         var _loc11_:SimFenceT = null;
         var _loc12_:SimUnitT = null;
         if(this.logicUnits.targetExists(param2))
         {
            _loc7_ = param2.id;
            _loc8_ = 1;
            switch(param2.kind)
            {
               case SimBoardObj.CANNON:
                  _loc9_ = this.simFun.cannonById(_loc7_);
                  param1 = this.simFun.calcDamage(param1,param3,_loc9_.armor,_loc8_,_loc9_.stamina,_loc9_.max_stamina,param4);
                  _loc6_ = _loc9_.stamina;
                  this.simFun.cannonDecStamina(param1,_loc9_);
                  _loc5_ = _loc9_.stamina;
                  param1 = _loc6_ - _loc9_.stamina;
                  if(_loc9_.stamina <= 0)
                  {
                     this.simFun.removeCannon(_loc9_,this.simRun);
                     this.logicUnits.checkFinishFight(param4);
                  }
                  break;
               case SimBoardObj.BUILDING:
                  _loc10_ = this.simFun.buildingById(_loc7_);
                  param1 = this.simFun.calcDamage(param1,param3,_loc10_.armor,_loc8_,_loc10_.stamina,_loc10_.max_stamina,param4);
                  _loc6_ = _loc10_.stamina;
                  this.simFun.buildingDecStamina(param1,_loc10_);
                  _loc5_ = _loc10_.stamina;
                  param1 = _loc6_ - _loc5_;
                  if(_loc10_.stamina <= 0)
                  {
                     this.simFun.removeBuilding(_loc10_,this.simRun);
                     this.logicUnits.checkFinishFight(param4);
                  }
                  break;
               case SimBoardObj.FENCE:
                  _loc11_ = this.simFun.fenceById(_loc7_);
                  param1 = this.simFun.calcDamage(param1,param3,_loc11_.armor,_loc8_,_loc11_.stamina,_loc11_.max_stamina,param4);
                  this.simFun.fenceDecStamina(param1,_loc11_);
                  _loc5_ = _loc11_.stamina;
                  if(_loc11_.stamina <= 0)
                  {
                     this.simFun.removeFence(_loc11_);
                     this.simFun.notifyFenceWish(_loc7_);
                  }
                  break;
               case SimBoardObj.UNIT:
                  _loc12_ = this.simFun.unitById(_loc7_);
                  param1 = this.simFun.calcDamage(param1,param3,_loc12_.armor,_loc8_,_loc12_.stamina,_loc12_.max_stamina,param4);
                  this.simFun.unitDecStamina(param1,_loc12_);
                  _loc5_ = _loc12_.stamina;
                  if(_loc12_.stamina <= 0)
                  {
                     this.logicUnits.removeUnit(_loc12_);
                     this.logicUnits.checkFinishFight(param4);
                     break;
                  }
                  this.simFun.notifyHealers(_loc12_,param4);
            }
            this.simRun.applyDamage(param2,_loc5_,param4);
         }
      }
      
      public function applyFireball(param1:Point, param2:int, param3:int, param4:Number, param5:Boolean, param6:int) : void
      {
         var elt:SimBoardElt = null;
         var op:Point = null;
         var id:int = 0;
         var tu:SimUnitT = null;
         var o:SimBoardObj = null;
         var p:Point = param1;
         var r:int = param2;
         var d:int = param3;
         var penetration:Number = param4;
         var is_attacker:Boolean = param5;
         var etime:int = param6;
         var rhombs:Vector.<Point> = this.simFun.data.board.rhombsInCircle(p,r,new Point(1,1));
         var objects_ids:Vector.<int> = new Vector.<int>(0);
         var units_ids:Vector.<int> = new Vector.<int>(0);
         var objects:Vector.<SimBoardObj> = new Vector.<SimBoardObj>(0);
         for each(op in rhombs)
         {
            elt = this.simFun.data.board.getElt(op.x,op.y);
            if(elt)
            {
               if(is_attacker)
               {
                  if(Boolean(elt.obj) && (Boolean(elt.obj.kind == SimBoardObj.BUILDING || elt.obj.kind == SimBoardObj.CANNON || elt.obj.kind == SimBoardObj.FENCE)) && objects_ids.indexOf(elt.obj.id) < 0)
                  {
                     objects_ids.push(elt.obj.id);
                     objects.push(elt.obj);
                  }
                  for each(id in elt.units)
                  {
                     if(this.simFun.unitExists(id) && units_ids.indexOf(id) < 0)
                     {
                        tu = this.simFun.unitById(id);
                        if(!tu.is_attacker && tu.is_active)
                        {
                           units_ids.push(id);
                           objects.push(tu.boardObj());
                        }
                     }
                  }
               }
               else
               {
                  for each(id in elt.units)
                  {
                     if(this.simFun.unitExists(id) && units_ids.indexOf(id) < 0)
                     {
                        tu = this.simFun.unitById(id);
                        if(tu.is_attacker && tu.is_active)
                        {
                           units_ids.push(id);
                           objects.push(tu.boardObj());
                        }
                     }
                  }
               }
            }
         }
         objects = objects.sort(function(param1:SimBoardObj, param2:SimBoardObj):Number
         {
            return logicUnits.boardObjectMore(param1,param2) ? 1 : -1;
         });
         for each(o in objects)
         {
            this.applySpellDamageSimple(d,o,penetration,etime);
         }
      }
      
      public function applyMultifireball(param1:Point, param2:int, param3:int, param4:int, param5:Number, param6:int, param7:Boolean, param8:int) : void
      {
         this.applyFireball(param1,param3,param4,param5,param7,param8);
         if(param6 > 1)
         {
            this.pq.add(param8 + param2,SimFun.createSpellMultifireball(param1,param2,param3,param4,param5,param6 - 1,param7));
         }
      }
      
      public function applyFog(param1:Point, param2:int, param3:int, param4:int) : void
      {
         var _loc6_:Point = null;
         var _loc7_:SimBoardElt = null;
         var _loc5_:Vector.<Point> = this.simFun.data.board.rhombsInCircle(param1,param3,new Point(1,1));
         for each(_loc6_ in _loc5_)
         {
            _loc7_ = this.simFun.data.board.getElt(_loc6_.x,_loc6_.y);
            if(_loc7_)
            {
               _loc7_.addModif(SimModif.INVISIBLE,param4 + param2,1);
            }
         }
      }
      
      public function applyRage(param1:Point, param2:int, param3:int, param4:Number, param5:Number, param6:int) : void
      {
         var _loc8_:Point = null;
         var _loc9_:SimBoardElt = null;
         var _loc7_:Vector.<Point> = this.simFun.data.board.rhombsInCircle(param1,param3,new Point(1,1));
         for each(_loc8_ in _loc7_)
         {
            _loc9_ = this.simFun.data.board.getElt(_loc8_.x,_loc8_.y);
            if(_loc9_)
            {
               _loc9_.addModif(SimModif.MOVE_K,param6 + param2,param4);
               _loc9_.addModif(SimModif.ATTACK_K,param6 + param2,param5);
            }
         }
      }
      
      public function applyLowDamage(param1:Point, param2:int, param3:int, param4:Number, param5:int) : void
      {
         var _loc7_:Point = null;
         var _loc8_:SimBoardElt = null;
         var _loc6_:Vector.<Point> = this.simFun.data.board.rhombsInCircle(param1,param3,new Point(1,1));
         for each(_loc7_ in _loc6_)
         {
            _loc8_ = this.simFun.data.board.getElt(_loc7_.x,_loc7_.y);
            if(_loc8_)
            {
               _loc8_.addModif(SimModif.DAMAGE_K,param5 + param2,param4);
            }
         }
      }
      
      public function applyCure(param1:Point, param2:int, param3:int, param4:int, param5:int, param6:Boolean, param7:int) : void
      {
         var elt:SimBoardElt = null;
         var op:Point = null;
         var id:int = 0;
         var tu:SimUnitT = null;
         var target_id:SimBoardObj = null;
         var cure_ost:int = 0;
         var inc:int = 0;
         var p:Point = param1;
         var dt:int = param2;
         var damage:int = param3;
         var r:int = param4;
         var count:int = param5;
         var is_attacker:Boolean = param6;
         var etime:int = param7;
         var rhombs:Vector.<Point> = this.simFun.data.board.rhombsInCircle(p,r,new Point(1,1));
         var units_ids:Vector.<int> = new Vector.<int>(0);
         var objects:Vector.<SimBoardObj> = new Vector.<SimBoardObj>(0);
         for each(op in rhombs)
         {
            elt = this.simFun.data.board.getElt(op.x,op.y);
            if(elt)
            {
               for each(id in elt.units)
               {
                  if(this.simFun.unitExists(id) && units_ids.indexOf(id) < 0)
                  {
                     tu = this.simFun.unitById(id);
                     if(tu.is_attacker && tu.is_active)
                     {
                        units_ids.push(id);
                        objects.push(tu.boardObj());
                     }
                  }
               }
            }
         }
         objects = objects.sort(function(param1:SimBoardObj, param2:SimBoardObj):Number
         {
            return logicUnits.boardObjectMore(param1,param2) ? 1 : -1;
         });
         for each(target_id in objects)
         {
            if(this.logicUnits.targetExists(target_id))
            {
               id = target_id.id;
               tu = this.simFun.unitById(id);
               cure_ost = tu.max_cure_stamina - tu.cure_count;
               inc = damage;
               if(cure_ost > 0 && damage > cure_ost)
               {
                  inc = cure_ost;
               }
               else if(cure_ost <= 0)
               {
                  inc = 0;
               }
               this.simFun.unitIncStamina(inc,tu);
               this.simRun.applyDamage(target_id,tu.stamina,etime);
            }
         }
         if(count > 1)
         {
            this.pq.add(etime + dt,SimFun.createSpellCure(p,dt,damage,r,count - 1,is_attacker));
         }
      }
      
      public function applyWorker(param1:Point, param2:int, param3:int, param4:int, param5:int, param6:Boolean, param7:int) : void
      {
         var elt:SimBoardElt = null;
         var op:Point = null;
         var target_id:SimBoardObj = null;
         var b:SimBuildingT = null;
         var v:int = 0;
         var c:SimCannonT = null;
         var f:SimFenceT = null;
         var p:Point = param1;
         var dt:int = param2;
         var damage:int = param3;
         var r:int = param4;
         var count:int = param5;
         var is_attacker:Boolean = param6;
         var etime:int = param7;
         var rhombs:Vector.<Point> = this.simFun.data.board.rhombsInCircle(p,r,new Point(1,1));
         var objects:Vector.<SimBoardObj> = new Vector.<SimBoardObj>(0);
         for each(op in rhombs)
         {
            elt = this.simFun.data.board.getElt(op.x,op.y);
            if(Boolean(elt) && Boolean(elt.obj))
            {
               if(elt.obj.kind == SimBoardObj.BUILDING || elt.obj.kind == SimBoardObj.CANNON || elt.obj.kind == SimBoardObj.FENCE)
               {
                  if(objects.indexOf(elt.obj) < 0)
                  {
                     objects.push(elt.obj);
                  }
               }
            }
         }
         objects = objects.sort(function(param1:SimBoardObj, param2:SimBoardObj):Number
         {
            return logicUnits.boardObjectMore(param1,param2) ? 1 : -1;
         });
         for each(target_id in objects)
         {
            switch(target_id.kind)
            {
               case SimBoardObj.BUILDING:
                  b = this.simFun.buildingById(target_id.id);
                  v = b.stamina;
                  this.simFun.buildingIncStamina(damage,b);
                  if(v != b.stamina)
                  {
                     this.simRun.applyDamage(target_id,b.stamina,etime);
                  }
                  break;
               case SimBoardObj.CANNON:
                  c = this.simFun.cannonById(target_id.id);
                  v = c.stamina;
                  this.simFun.cannonIncStamina(damage,c);
                  if(v != c.stamina)
                  {
                     this.simRun.applyDamage(target_id,c.stamina,etime);
                  }
                  break;
               case SimBoardObj.FENCE:
                  f = this.simFun.fenceById(target_id.id);
                  v = f.stamina;
                  this.simFun.fenceIncStamina(damage,f);
                  if(v != f.stamina)
                  {
                     this.simRun.applyDamage(target_id,f.stamina,etime);
                  }
            }
         }
         if(count > 1)
         {
            this.pq.add(etime + dt,SimFun.createSpellWorker(p,dt,damage,r,count - 1,is_attacker));
         }
      }
      
      public function applyShock(param1:Point, param2:int, param3:int, param4:int, param5:Boolean, param6:Boolean) : void
      {
         var count:uint;
         var op:Point = null;
         var target_id:SimBoardObj = null;
         var elt:SimBoardElt = null;
         var c:SimCannonT = null;
         var p:Point = param1;
         var dt:int = param2;
         var r:int = param3;
         var etime:int = param4;
         var start:Boolean = param5;
         var is_attacker:Boolean = param6;
         var objects:Vector.<SimBoardObj> = new Vector.<SimBoardObj>(0);
         for each(op in this.simFun.data.board.rhombsInCircle(p,r,new Point(1,1)))
         {
            elt = this.simFun.data.board.getElt(op.x,op.y);
            if(Boolean(elt) && Boolean(elt.obj))
            {
               if(elt.obj.kind == SimBoardObj.CANNON)
               {
                  if(objects.indexOf(elt.obj) < 0)
                  {
                     objects.push(elt.obj);
                  }
               }
            }
         }
         if(start)
         {
            objects = objects.sort(function(param1:SimBoardObj, param2:SimBoardObj):Number
            {
               return logicUnits.boardObjectMore(param1,param2) ? 1 : -1;
            });
            dt += etime;
         }
         count = 0;
         for each(target_id in objects)
         {
            if(target_id.kind == SimBoardObj.CANNON)
            {
               c = this.simFun.cannonById(target_id.id);
               if(start)
               {
                  if(c.disabled_time < dt)
                  {
                     if(c.disabled_time == 0)
                     {
                        this.simRun.cannonDisable(c.id,true);
                     }
                     c.disabled_time = dt;
                     count++;
                  }
               }
               else if(c.disabled_time != 0 && etime >= c.disabled_time)
               {
                  c.disabled_time = 0;
                  this.simRun.cannonDisable(c.id,false);
               }
            }
         }
         if(count > 0)
         {
            this.pq.add(dt,SimFun.createSpellShock(p,0,r,false,is_attacker));
         }
      }
      
      public function applyCall(param1:Point, param2:int, param3:int, param4:int) : void
      {
         var pos:Point = param1;
         var duration:int = param2;
         var user_num:int = param3;
         var etime:int = param4;
         this.simFun.data.units.iter(function(param1:int, param2:SimUnitT):void
         {
            logicUnits.applyCall(param2,pos,duration,user_num,etime);
         });
      }
      
      public function activate(param1:PShopSpell, param2:Point, param3:int, param4:Boolean, param5:int) : void
      {
         var _loc6_:PFireball = null;
         var _loc7_:PCure = null;
         var _loc8_:PShock = null;
         var _loc9_:PMultifireball = null;
         var _loc10_:PFog = null;
         var _loc11_:PRage = null;
         var _loc12_:PLowDamage = null;
         this.simRun.activateSpell(param1,param2,param5);
         switch(param1.ssp_effect.variance)
         {
            case PEffect.FIREBALL:
               _loc6_ = param1.ssp_effect.value as PFireball;
               this.pq.add(param5 + param1.ssp_attack_time,SimFun.createSpellFireball(param2,_loc6_.fireball_radius,_loc6_.fireball_damage,param4));
               break;
            case PEffect.CURE:
               _loc7_ = param1.ssp_effect.value as PCure;
               this.pq.add(param5 + param1.ssp_attack_time,SimFun.createSpellCure(param2,_loc7_.cure_duration,_loc7_.cure_stamina,_loc7_.cure_radius,_loc7_.cure_count,param4));
               break;
            case PEffect.CALL:
               this.pq.add(param5 + param1.ssp_attack_time,SimFun.createSpellCall(param2,(param1.ssp_effect.value as PCall).call_duration,param3,param4));
               break;
            case PEffect.WORKER:
               _loc7_ = param1.ssp_effect.value as PCure;
               this.pq.add(param5 + param1.ssp_attack_time,SimFun.createSpellWorker(param2,_loc7_.cure_duration,_loc7_.cure_stamina,_loc7_.cure_radius,_loc7_.cure_count,param4));
               break;
            case PEffect.SHOCK:
               _loc8_ = param1.ssp_effect.value as PShock;
               this.pq.add(param5 + param1.ssp_attack_time,SimFun.createSpellShock(param2,_loc8_.shock_duration,_loc8_.shock_radius,true,param4));
               break;
            case PEffect.MULTIFIREBALL:
               _loc9_ = param1.ssp_effect.value as PMultifireball;
               this.pq.add(param5 + param1.ssp_attack_time,SimFun.createSpellMultifireball(param2,_loc9_.mf_period,_loc9_.mf_radius,_loc9_.mf_damage,_loc9_.mf_penetration,_loc9_.mf_count,param4));
               break;
            case PEffect.FOG:
               _loc10_ = param1.ssp_effect.value as PFog;
               this.pq.add(param5 + param1.ssp_attack_time,SimFun.createSpellFog(param2,_loc10_.fog_duration,_loc10_.fog_radius,param4));
               break;
            case PEffect.RAGE:
               _loc11_ = param1.ssp_effect.value as PRage;
               this.pq.add(param5 + param1.ssp_attack_time,SimFun.createSpellRage(param2,_loc11_.rage_move_k,_loc11_.rage_attack_k,_loc11_.rage_duration,_loc11_.rage_radius,param4));
               break;
            case PEffect.LOW_DAMAGE:
               _loc12_ = param1.ssp_effect.value as PLowDamage;
               this.pq.add(param5 + param1.ssp_attack_time,SimFun.createSpellLowDamage(param2,_loc12_.low_damage_duration,_loc12_.low_damage_radius,_loc12_.low_damage_k,param4));
         }
      }
   }
}

