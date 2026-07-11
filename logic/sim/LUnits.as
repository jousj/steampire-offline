package logic.sim
{
   import flash.geom.Point;
   import proto.model.PBtype;
   import proto.model.PUnitProirityType;
   
   public class LUnits
   {
      
      private var pq:PriorityQueue;
      
      private var logicCannons:LCannons;
      
      public var simFun:SimFun;
      
      public var simRun:SimRun;
      
      public function LUnits(param1:LCannons, param2:PriorityQueue, param3:SimFun, param4:SimRun)
      {
         super();
         this.pq = param2;
         this.logicCannons = param1;
         this.simFun = param3;
         this.simRun = param4;
      }
      
      public function checkFinishFight(param1:int) : void
      {
         if(this.simFun.data.buildings.isEmpty() && this.simFun.data.cannons.isEmpty() && !this.simFun.defenderExist())
         {
            this.pq.add(param1 - 1,SimFun.createFinish());
         }
      }
      
      public function removeUnit(param1:SimUnitT) : void
      {
         var uo_id:SimBoardObj = null;
         var u:SimUnitT = param1;
         if(!u.is_attacker)
         {
            uo_id = u.boardObj();
            this.simFun.data.units_groups.iter(function(param1:int, param2:SimGroup):void
            {
               var _loc3_:Number = NaN;
               var _loc4_:* = int(param2.targets.length - 1);
               while(_loc4_ >= 0)
               {
                  if(uo_id.equal(param2.targets[_loc4_]))
                  {
                     _loc3_ = _loc4_;
                  }
                  _loc4_--;
               }
               if(!isNaN(_loc3_))
               {
                  param2.targets.splice(_loc3_,1);
               }
            });
         }
         this.simFun.removeUnit(u,this.simRun);
      }
      
      private function resetGroupVector(param1:SimUnitT, param2:int) : void
      {
         var ug:SimGroup = null;
         var uid:int = 0;
         var ou:SimUnitT = null;
         var u:SimUnitT = param1;
         var etime:int = param2;
         if(!isNaN(u.group) && this.simFun.data.units_groups.mem(u.group))
         {
            ug = this.simFun.data.units_groups.find(u.group);
            ug.targets = ug.targets.filter(function(param1:SimBoardObj, param2:int, param3:Vector.<SimBoardObj>):Boolean
            {
               return simFun.data.objectExists(param1);
            });
            if(ug.targets.length == 0)
            {
               for each(uid in ug.attackers)
               {
                  if(uid != u.id && this.simFun.data.units.mem(uid))
                  {
                     ou = this.simFun.data.units.find(uid);
                     ou.group = NaN;
                     ou.recalc_path = true;
                  }
               }
               u.group = NaN;
               u.recalc_path = true;
            }
         }
      }
      
      public function resetVector(param1:SimUnitT, param2:int) : void
      {
         if(!isNaN(param1.group))
         {
            param1.group = NaN;
         }
      }
      
      private function isVector(param1:SimUnitT) : Boolean
      {
         return !isNaN(param1.group);
      }
      
      public function targetExists(param1:SimBoardObj) : Boolean
      {
         var _loc3_:SimUnitT = null;
         var _loc2_:Boolean = false;
         if(param1)
         {
            if(param1.kind == SimBoardObj.FENCE && this.simFun.fenceExists(param1.id))
            {
               _loc2_ = true;
            }
            else if(param1.kind == SimBoardObj.BUILDING && this.simFun.buildingExists(param1.id))
            {
               _loc2_ = true;
            }
            else if(param1.kind == SimBoardObj.CANNON && this.simFun.cannonExists(param1.id))
            {
               _loc2_ = true;
            }
            else if(param1.kind == SimBoardObj.UNIT && this.simFun.unitExists(param1.id))
            {
               _loc3_ = this.simFun.unitById(param1.id);
               _loc2_ = _loc3_.is_active;
            }
         }
         return _loc2_;
      }
      
      private function notifyAttackers(param1:Boolean, param2:Point, param3:int) : void
      {
         var _loc4_:Vector.<int> = null;
         var _loc5_:* = 0;
         var _loc6_:SimUnitT = null;
         if(!param1)
         {
            _loc4_ = this.simFun.attackersOnPos(param2);
            _loc5_ = int(_loc4_.length - 1);
            while(_loc5_ >= 0)
            {
               if(this.simFun.unitExists(_loc4_[_loc5_]))
               {
                  _loc6_ = this.simFun.unitById(_loc4_[_loc5_]);
                  if(_loc6_.priority_type != PUnitProirityType.FENCE && (Boolean(!_loc6_.target_id) || Boolean(_loc6_.target_id && _loc6_.target_id.kind != SimBoardObj.UNIT)))
                  {
                     _loc6_.find_unit = true;
                  }
               }
               _loc5_--;
            }
         }
      }
      
      private function applyDamageSimple(param1:SimUnitT, param2:SimBoardObj, param3:int, param4:Boolean) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:SimCannonT = null;
         var _loc11_:SimBuildingT = null;
         var _loc12_:SimFenceT = null;
         var _loc13_:SimUnitT = null;
         var _loc14_:int = 0;
         if(this.targetExists(param2))
         {
            _loc8_ = param2.id;
            _loc9_ = 1;
            switch(param2.kind)
            {
               case SimBoardObj.CANNON:
                  _loc10_ = this.simFun.cannonById(_loc8_);
                  if(param1.priority_type == PUnitProirityType.ANY || param1.priority_type == PUnitProirityType.CANNON)
                  {
                     _loc9_ = param1.priority_factor;
                  }
                  _loc5_ = this.simFun.calcDamage(param1.damage,param1.penetration,_loc10_.armor,_loc9_,_loc10_.stamina,_loc10_.max_stamina,param3);
                  _loc7_ = _loc10_.stamina;
                  this.simFun.cannonDecStamina(_loc5_,_loc10_);
                  _loc6_ = _loc10_.stamina;
                  _loc5_ = _loc7_ - _loc10_.stamina;
                  if(_loc10_.stamina <= 0)
                  {
                     this.simFun.removeCannon(_loc10_,this.simRun);
                     this.resetGroupVector(param1,param3);
                     this.checkFinishFight(param3);
                  }
                  break;
               case SimBoardObj.BUILDING:
                  _loc11_ = this.simFun.buildingById(_loc8_);
                  if(param1.priority_type == PUnitProirityType.ANY || param1.priority_type == PUnitProirityType.BUILDING)
                  {
                     _loc9_ = param1.priority_factor;
                  }
                  else if(param1.priority_type == PUnitProirityType.RESOURCE && (_loc11_.type == PBtype.STORAGE || _loc11_.type == PBtype.RESOURCE))
                  {
                     _loc9_ = param1.priority_factor;
                  }
                  _loc5_ = this.simFun.calcDamage(param1.damage,param1.penetration,_loc11_.armor,_loc9_,_loc11_.stamina,_loc11_.max_stamina,param3);
                  _loc7_ = _loc11_.stamina;
                  this.simFun.buildingDecStamina(_loc5_,_loc11_);
                  _loc6_ = _loc11_.stamina;
                  _loc5_ = _loc7_ - _loc6_;
                  if(_loc11_.stamina <= 0)
                  {
                     this.simFun.removeBuilding(_loc11_,this.simRun);
                     this.resetGroupVector(param1,param3);
                     this.checkFinishFight(param3);
                  }
                  break;
               case SimBoardObj.FENCE:
                  _loc12_ = this.simFun.fenceById(_loc8_);
                  if(param1.priority_type == PUnitProirityType.ANY || param1.priority_type == PUnitProirityType.FENCE)
                  {
                     _loc9_ = param1.priority_factor;
                  }
                  _loc5_ = this.simFun.calcDamage(param1.damage,param1.penetration,_loc12_.armor,_loc9_,_loc12_.stamina,_loc12_.max_stamina,param3);
                  this.simFun.fenceDecStamina(_loc5_,_loc12_);
                  _loc6_ = _loc12_.stamina;
                  if(_loc12_.stamina <= 0)
                  {
                     this.simFun.removeFence(_loc12_);
                     this.simFun.resetFenceWish(param1);
                     this.simFun.notifyFenceWish(_loc8_);
                  }
                  break;
               case SimBoardObj.UNIT:
                  _loc13_ = this.simFun.unitById(_loc8_);
                  if(param1.is_healer)
                  {
                     _loc5_ = param1.damage.valueOf();
                     _loc14_ = _loc13_.max_cure_stamina - _loc13_.cure_count;
                     if(_loc14_ > 0 && _loc5_ > _loc14_)
                     {
                        _loc5_ = _loc14_;
                     }
                     else if(_loc14_ <= 0)
                     {
                        _loc5_ = 0;
                     }
                     this.simFun.unitIncStamina(_loc5_,_loc13_);
                     _loc6_ = _loc13_.stamina;
                     break;
                  }
                  _loc5_ = this.simFun.calcDamage(param1.damage,param1.penetration,_loc13_.armor,_loc9_,_loc13_.stamina,_loc13_.max_stamina,param3);
                  this.simFun.unitDecStamina(_loc5_,_loc13_);
                  _loc6_ = _loc13_.stamina;
                  this.notifyAttackers(param1.is_attacker,_loc13_.pos,param3);
                  if(_loc13_.stamina <= 0)
                  {
                     this.removeUnit(_loc13_);
                     this.checkFinishFight(param3);
                     break;
                  }
                  this.simFun.notifyHealers(_loc13_,param3);
            }
            this.simRun.applyDamage(param2,_loc6_,param3,param1);
         }
      }
      
      public function applyDamage(param1:SimUnitT, param2:SimBoardObj, param3:Point, param4:int, param5:Boolean) : void
      {
         var rhombs:Vector.<Point> = null;
         var objects_ids:Vector.<int> = null;
         var units_ids:Vector.<int> = null;
         var objects:Vector.<SimBoardObj> = null;
         var elt:SimBoardElt = null;
         var op:Point = null;
         var id:int = 0;
         var tu:SimUnitT = null;
         var o:SimBoardObj = null;
         var u:SimUnitT = param1;
         var target_id:SimBoardObj = param2;
         var p:Point = param3;
         var etime:int = param4;
         var is_fire:Boolean = param5;
         if(u.aoe_radius == 0)
         {
            this.applyDamageSimple(u,target_id,etime,is_fire);
         }
         else
         {
            rhombs = this.simFun.data.board.rhombs(new Point(p.x + u.aoe_radius - 1,p.y + u.aoe_radius - 1),new Point(u.aoe_radius * 2 - 1,u.aoe_radius * 2 - 1));
            objects_ids = new Vector.<int>(0);
            units_ids = new Vector.<int>(0);
            objects = new Vector.<SimBoardObj>(0);
            if(u.is_healer)
            {
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
                           if(tu.is_attacker == u.is_attacker && tu.is_active && tu.stamina < tu.max_stamina)
                           {
                              units_ids.push(id);
                              objects.push(tu.boardObj());
                           }
                        }
                     }
                  }
               }
            }
            else
            {
               for each(op in rhombs)
               {
                  elt = this.simFun.data.board.getElt(op.x,op.y);
                  if(elt)
                  {
                     if(Boolean(elt.obj) && (Boolean(elt.obj.kind == SimBoardObj.BUILDING || elt.obj.kind == SimBoardObj.CANNON || elt.obj.kind == SimBoardObj.FENCE && u.is_attacker)) && objects_ids.indexOf(elt.obj.id) < 0)
                     {
                        objects_ids.push(elt.obj.id);
                        objects.push(elt.obj);
                     }
                     for each(id in elt.units)
                     {
                        if(this.simFun.unitExists(id) && units_ids.indexOf(id) < 0)
                        {
                           tu = this.simFun.unitById(id);
                           if(tu.is_attacker != u.is_attacker && tu.is_active)
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
               return boardObjectMore(param1,param2) ? 1 : -1;
            });
            for each(o in objects)
            {
               this.applyDamageSimple(u,o,etime,is_fire);
            }
         }
      }
      
      private function findPath(param1:SimUnitT, param2:SimBoardObj, param3:Point, param4:Point, param5:int, param6:int) : Vector.<Point>
      {
         var _loc7_:Vector.<Point> = null;
         var _loc8_:Vector.<int> = null;
         var _loc9_:SimGroup = null;
         if(!isNaN(param1.group) && this.simFun.data.units_groups.mem(param1.group))
         {
            _loc9_ = this.simFun.data.units_groups.find(param1.group);
            _loc8_ = _loc9_.rhombs;
         }
         else
         {
            _loc8_ = new Vector.<int>();
         }
         if(Boolean(this.fenceInPos(param1.pos) && param1.prev_pos) && Boolean(!param1.is_air) && !param1.is_healer)
         {
            _loc7_ = this.simFun.data.board.findPath(param1.prev_pos,param2,param3,param4,param5,param1.is_air || !param1.is_attacker || param1.is_healer,_loc8_,param6);
            _loc7_.unshift(param1.prev_pos);
         }
         else
         {
            _loc7_ = this.simFun.data.board.findPath(param1.pos,param2,param3,param4,param5,param1.is_air || !param1.is_attacker || param1.is_healer,_loc8_,param6);
         }
         return _loc7_;
      }
      
      private function pathForTarget(param1:SimBoardObj, param2:int, param3:SimUnitT) : Vector.<Point>
      {
         var _loc5_:Point = null;
         var _loc6_:Point = null;
         var _loc8_:SimBuildingT = null;
         var _loc9_:SimCannonT = null;
         var _loc10_:SimFenceT = null;
         var _loc11_:SimUnitT = null;
         var _loc4_:int = param1.id;
         var _loc7_:int = param3.radius;
         switch(param1.kind)
         {
            case SimBoardObj.BUILDING:
               _loc8_ = this.simFun.buildingById(_loc4_);
               _loc5_ = _loc8_.pos.clone();
               _loc6_ = _loc8_.size.clone();
               if(param3.is_attacker)
               {
                  if(!_loc8_.is_finished && param3.radius == 0)
                  {
                     _loc7_ = 1;
                     break;
                  }
                  _loc7_ = param3.radius;
                  break;
               }
               _loc7_ = 0;
               break;
            case SimBoardObj.CANNON:
               _loc9_ = this.simFun.cannonById(_loc4_);
               _loc5_ = _loc9_.pos.clone();
               _loc6_ = _loc9_.size.clone();
               if(param3.is_attacker)
               {
                  if(!_loc9_.is_finished && param3.radius == 0)
                  {
                     _loc7_ = 1;
                     break;
                  }
                  _loc7_ = param3.radius;
                  break;
               }
               _loc7_ = 0;
               break;
            case SimBoardObj.FENCE:
               _loc10_ = this.simFun.fenceById(_loc4_);
               _loc5_ = _loc10_.pos.clone();
               _loc6_ = _loc10_.size.clone();
               break;
            case SimBoardObj.UNIT:
               _loc11_ = this.simFun.unitById(_loc4_);
               _loc5_ = _loc11_.pos.clone();
               _loc6_ = _loc11_.size.clone();
         }
         return this.findPath(param3,param1,_loc5_,_loc6_,_loc7_,param2);
      }
      
      private function fenceInPos(param1:Point) : Number
      {
         var _loc3_:Number = NaN;
         var _loc2_:SimBoardElt = this.simFun.data.board.getElt(param1.x,param1.y);
         if(Boolean(_loc2_.obj) && _loc2_.obj.kind == SimBoardObj.FENCE)
         {
            _loc3_ = _loc2_.obj.id;
         }
         return _loc3_;
      }
      
      private function fenceInPath(param1:Vector.<Point>, param2:SimUnitT) : SimBoardObj
      {
         var _loc7_:Point = null;
         var _loc8_:Number = NaN;
         var _loc3_:SimBoardObj = null;
         var _loc4_:Vector.<Point> = param1.slice();
         var _loc5_:Boolean = param1 && param1.length > 0 && Boolean(param2.prev_pos) && param1[0].equals(param2.prev_pos);
         if(!_loc5_)
         {
            _loc4_.unshift(param2.pos.clone());
         }
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc7_ = _loc4_[_loc6_];
            _loc8_ = this.fenceInPos(_loc7_);
            if(!isNaN(_loc8_) && !_loc3_)
            {
               _loc3_ = new SimBoardObj(SimBoardObj.FENCE,_loc8_);
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      private function calcSpeed(param1:int, param2:Point, param3:Point) : int
      {
         var _loc4_:Number = this.simFun.data.board.speedByDirection(param2,param3);
         return int(Math.floor(param1 * _loc4_));
      }
      
      private function targetNeigbourPos(param1:SimBoardObj, param2:Point, param3:int) : Point
      {
         var _loc4_:Point = null;
         var _loc6_:SimFenceT = null;
         var _loc7_:SimBuildingT = null;
         var _loc8_:SimCannonT = null;
         var _loc9_:SimUnitT = null;
         var _loc5_:int = param1.id;
         if(this.targetExists(param1))
         {
            switch(param1.kind)
            {
               case SimBoardObj.FENCE:
                  _loc6_ = this.simFun.fenceById(_loc5_);
                  _loc4_ = this.simFun.data.board.findNeigbourPoint(_loc6_.pos,_loc6_.size,param2);
                  break;
               case SimBoardObj.BUILDING:
                  _loc7_ = this.simFun.buildingById(_loc5_);
                  _loc4_ = this.simFun.data.board.findNeigbourPoint(_loc7_.pos,_loc7_.size,param2);
                  break;
               case SimBoardObj.CANNON:
                  _loc8_ = this.simFun.cannonById(_loc5_);
                  _loc4_ = this.simFun.data.board.findNeigbourPoint(_loc8_.pos,_loc8_.size,param2);
                  break;
               case SimBoardObj.UNIT:
                  _loc9_ = this.simFun.unitById(_loc5_);
                  _loc4_ = _loc9_.pos.clone();
            }
         }
         return _loc4_;
      }
      
      private function checkNewPath(param1:int, param2:SimUnitT) : Boolean
      {
         var f:Function;
         var path:Vector.<Point> = null;
         var ug:SimGroup = null;
         var path_opt:Vector.<Point> = null;
         var etime:int = param1;
         var u:SimUnitT = param2;
         var res:Boolean = false;
         if(u.recalc_path)
         {
            u.recalc_path = false;
            if(u.state == SimUnitT.GO_TO_TARGET)
            {
               f = function(param1:Vector.<Point>, param2:SimBoardObj):void
               {
                  res = true;
                  u.path = param1.slice();
               };
               if(Boolean(u.target_id) && this.targetExists(u.target_id))
               {
                  path = this.pathForTarget(u.target_id,etime,u);
                  if(path)
                  {
                     f(path,u.target_id);
                  }
               }
               else if(!u.target_id && !isNaN(u.group))
               {
                  ug = this.simFun.data.units_groups.find(u.group);
                  path_opt = this.findPath(u,new SimBoardObj(SimBoardObj.FENCE,0),ug.goal_pos,new Point(1,1),0,etime);
                  if(path_opt)
                  {
                     f(path_opt,null);
                  }
                  else
                  {
                     res = true;
                  }
               }
               else
               {
                  res = true;
               }
            }
         }
         return res;
      }
      
      private function canAttackUnit(param1:Point, param2:SimUnitT, param3:SimUnitT) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc5_:Point = param1 ? param1 : param2.pos;
         if(param2.radius > 0)
         {
            _loc4_ = SimBoard.radius(param2.radius) >= SimBoard.distance2(_loc5_,param3.pos);
         }
         else if(_loc5_.equals(param3.pos))
         {
            _loc4_ = true;
         }
         else if(Math.abs(param3.pos.x - _loc5_.x) <= 1 && Math.abs(param3.pos.y - _loc5_.y) <= 1)
         {
            _loc4_ = Boolean(param3.path) && param3.path.length > 0 && param3.path[0].equals(_loc5_);
         }
         if(param2.is_healer && _loc4_)
         {
            _loc4_ = param3.stamina < param3.max_stamina;
         }
         return _loc4_;
      }
      
      private function canAttackObject(param1:SimBoardObj, param2:SimUnitT, param3:int) : Boolean
      {
         var _loc5_:SimUnitT = null;
         var _loc6_:Point = null;
         var _loc7_:int = 0;
         var _loc8_:SimBuildingT = null;
         var _loc9_:SimCannonT = null;
         var _loc10_:SimBoardElt = null;
         var _loc4_:Boolean = false;
         if(param1.kind == SimBoardObj.UNIT)
         {
            if(this.simFun.unitExists(param1.id))
            {
               _loc5_ = this.simFun.unitById(param1.id);
               _loc4_ = this.canAttackUnit(null,param2,_loc5_);
            }
         }
         else if(!param2.is_healer)
         {
            _loc6_ = this.targetNeigbourPos(param1,param2.pos,param3);
            _loc7_ = param2.radius;
            if(param1.kind == SimBoardObj.BUILDING)
            {
               _loc8_ = this.simFun.buildingById(param1.id);
               if(!_loc8_.is_finished && param2.radius == 0)
               {
                  _loc7_ = 1;
               }
            }
            else if(param1.kind == SimBoardObj.CANNON)
            {
               _loc9_ = this.simFun.cannonById(param1.id);
               if(!_loc9_.is_finished && param2.radius == 0)
               {
                  _loc7_ = 1;
               }
            }
            if(_loc6_)
            {
               _loc10_ = this.simFun.data.board.getElt(param2.pos.x,param2.pos.y);
               _loc4_ = (_loc10_) && _loc10_.obj && _loc10_.obj.equal(param1) || SimBoard.radius(_loc7_) >= SimBoard.distance2(param2.pos,_loc6_);
            }
         }
         return _loc4_;
      }
      
      private function deactivateDefender(param1:SimUnitT, param2:int) : void
      {
         var u:SimUnitT = param1;
         var etime:int = param2;
         if(u.is_active)
         {
            this.simFun.deactivateUnit(u);
            this.simRun.deactivateUnit(u.id);
            this.simFun.data.units_groups.iter(function(param1:int, param2:SimGroup):void
            {
               var _loc4_:Number = NaN;
               var _loc3_:SimBoardObj = u.boardObj();
               var _loc5_:* = int(param2.targets.length - 1);
               while(_loc5_ >= 0)
               {
                  if(_loc3_.equal(param2.targets[_loc5_]))
                  {
                     _loc4_ = _loc5_;
                  }
                  _loc5_--;
               }
               if(!isNaN(_loc4_))
               {
                  param2.targets.splice(_loc4_,1);
               }
            });
            u.is_active = false;
         }
      }
      
      private function activateSimple(param1:SimUnitT, param2:int) : void
      {
         this.simFun.activateUnit(param1);
         param1.is_active = true;
         this.simRun.activateUnit(param1,!isNaN(param1.group) ? this.simFun.data.units_groups[param1.group] : null,param2);
         this.notifyCannonsGuards(param2,param1);
         this.notifyWaiters(param1.is_attacker,param1.pos,param2);
      }
      
      public function activateUnit(param1:int, param2:int) : void
      {
         var _loc3_:SimUnitT = null;
         if(this.simFun.unitExists(param1))
         {
            _loc3_ = this.simFun.unitById(param1);
            this.activateSimple(_loc3_,param2);
            this.pq.add(param2 + SimFun.LANDING_ANIM_TIME,SimFun.createInitUnit(_loc3_.id));
         }
      }
      
      public function init(param1:int, param2:int) : void
      {
         var do_attack:Function;
         var u:SimUnitT = null;
         var o:Object = null;
         var fence_id:SimBoardObj = null;
         var elt:SimBoardElt = null;
         var guard_target_id:SimBoardObj = null;
         var path:Vector.<Point> = null;
         var id:int = param1;
         var etime:int = param2;
         if(this.simFun.unitExists(id))
         {
            u = this.simFun.unitById(id);
            u.setInitState();
            this.simFun.resetRegPos(u);
            this.simFun.resetFenceWish(u);
            o = this.findTarget(u,etime);
            if(!u.is_active && !u.is_attacker)
            {
               this.activateSimple(u,etime);
            }
            if(Boolean(o) && Boolean(o.target_id) && o.path.length == 0)
            {
               do_attack = function():void
               {
                  simFun.setRegPos(u.pos,u);
                  u.state = SimUnitT.GO_TO_TARGET;
                  u.target_id = o.target_id;
                  u.path = o.path;
                  attack(true,id,o.target_id,etime);
               };
               if(u.is_attacker)
               {
                  do_attack();
               }
               else if(o.target_id.kind == SimBoardObj.UNIT)
               {
                  do_attack();
               }
               else
               {
                  this.deactivateDefender(u,etime);
               }
            }
            else if(Boolean(o && !o.target_id && o.path && o.path.length == 0) && Boolean(u.is_attacker) && !isNaN(u.group))
            {
               this.resetVector(u,etime);
               this.resetGroupVector(u,etime);
               this.init(id,etime);
            }
            else if(Boolean(o) && Boolean(o.path))
            {
               u.state = SimUnitT.GO_TO_TARGET;
               u.target_id = o.target_id;
               u.path = o.path;
               this.simFun.setRegPos(u.path[u.path.length - 1],u);
               fence_id = this.fenceInPath(o.path,u);
               if(Boolean(fence_id && !u.is_air && !u.is_healer) && Boolean(u.is_attacker) && this.canAttackObject(fence_id,u,etime))
               {
                  this.attack(true,id,fence_id,etime);
               }
               else if(fence_id)
               {
                  this.simFun.regFenceWish(fence_id.id,u);
                  this.goTo(id,true,etime);
               }
               else
               {
                  this.goTo(id,true,etime);
               }
            }
            else if((Boolean(!o) || Boolean(o && !o.target_id)) && !u.is_attacker)
            {
               if(Boolean(u.building_id) && this.simFun.buildingExists(u.building_id))
               {
                  elt = this.simFun.data.board.getElt(u.pos.x,u.pos.y);
                  if(Boolean(elt.obj) && Boolean(elt.obj.kind == SimBoardObj.BUILDING) && elt.obj.id == u.building_id)
                  {
                     this.deactivateDefender(u,etime);
                  }
                  else
                  {
                     guard_target_id = new SimBoardObj(SimBoardObj.BUILDING,u.building_id);
                     path = this.pathForTarget(guard_target_id,etime,u);
                     if(path)
                     {
                        u.state = SimUnitT.GO_TO_TARGET;
                        u.target_id = guard_target_id;
                        u.path = path;
                        this.goTo(id,true,etime);
                     }
                     else
                     {
                        u.state = SimUnitT.WAIT_ATTACKER;
                        this.simFun.addToHealers(u);
                        this.simRun.stand(u.id);
                     }
                  }
               }
               else
               {
                  u.state = SimUnitT.WAIT_ATTACKER;
                  this.simRun.stand(u.id);
               }
            }
            else if((Boolean(!o || o && !o.target_id)) && Boolean(u.is_attacker) && u.is_healer)
            {
               u.state = SimUnitT.WAIT_ATTACKER;
               this.simFun.addToHealers(u);
               this.simRun.stand(u.id);
            }
         }
      }
      
      private function move(param1:Point, param2:SimUnitT, param3:int) : void
      {
         this.simFun.moveUnit(param1,param2);
         this.notifyCannonsGuards(param3,param2);
         this.notifyWaiters(param2.is_attacker,param2.pos,param3);
      }
      
      private function makeInit(param1:SimUnitT, param2:int) : void
      {
         param1.setInitState();
         this.init(param1.id,param2);
      }
      
      public function goTo(param1:int, param2:Boolean, param3:int) : void
      {
         var goToNext:Function;
         var fence_id:SimBoardObj = null;
         var u:SimUnitT = null;
         var next_pos:Point = null;
         var id:int = param1;
         var is_init:Boolean = param2;
         var etime:int = param3;
         if(this.simFun.unitExists(id))
         {
            u = this.simFun.unitById(id);
            if(Boolean(!is_init && u.state == SimUnitT.GO_TO_TARGET) && Boolean(u.path) && u.path.length > 0)
            {
               this.move(u.path[0],u,etime);
               this.simRun.unitMove(id,u.path[0]);
               u.path = u.path.slice(1);
            }
            if(this.checkNewPath(etime,u) || !is_init && (this.validatePathToEnemy(etime,u) || u.is_healer))
            {
               this.makeInit(u,etime);
            }
            else if(Boolean(u.state == SimUnitT.GO_TO_TARGET && (this.targetExists(u.target_id) || !this.targetExists(u.target_id) && (this.isVector(u) || u.spellCall(etime)))) && Boolean(u.path) && u.path.length > 0)
            {
               goToNext = function():void
               {
                  var _loc1_:int = simFun.unitSpeedMove(u,u.move_delay,etime);
                  var _loc2_:int = calcSpeed(_loc1_,u.pos,next_pos);
                  var _loc3_:int = etime + _loc2_;
                  pq.add(_loc3_,SimFun.createUnitGoTo(id,false));
                  simRun.unitPrepareMove(id,next_pos,_loc3_,u.path.length == 1);
               };
               next_pos = u.path[0];
               fence_id = this.fenceInPath(u.path,u);
               if(Boolean(fence_id && !u.is_air && !u.is_healer) && Boolean(u.is_attacker) && this.canAttackObject(fence_id,u,etime))
               {
                  this.attack(true,id,fence_id,etime);
               }
               else if(Boolean(u.target_id) && !this.targetExists(u.target_id))
               {
                  if(!isNaN(u.group))
                  {
                     u.setInitState();
                     this.init(id,etime);
                  }
                  else
                  {
                     goToNext();
                  }
               }
               else
               {
                  goToNext();
               }
            }
            else if(Boolean(u.state == SimUnitT.GO_TO_TARGET) && (Boolean(!u.path || u.path && u.path.length == 0)) && !u.target_id)
            {
               fence_id = this.fenceInPath(u.path,u);
               if(Boolean(fence_id && !u.is_air && !u.is_healer) && Boolean(u.is_attacker) && this.canAttackObject(fence_id,u,etime))
               {
                  this.attack(true,id,fence_id,etime);
               }
               else
               {
                  this.resetVector(u,etime);
                  this.resetGroupVector(u,etime);
                  u.setInitState();
                  this.init(id,etime);
               }
            }
            else if(u.state == SimUnitT.GO_TO_TARGET && (Boolean(!u.path) || Boolean(u.path && u.path.length == 0)))
            {
               if(Boolean(!u.is_attacker) && Boolean(u.target_id) && u.target_id.kind == SimBoardObj.BUILDING)
               {
                  u.setInitState();
                  this.init(id,etime);
               }
               else
               {
                  this.attack(true,id,u.target_id,etime);
               }
            }
            else
            {
               u.setInitState();
               this.init(id,etime);
            }
         }
      }
      
      public function attack(param1:Boolean, param2:int, param3:SimBoardObj, param4:int) : void
      {
         var doAttack:Function;
         var u:SimUnitT = null;
         var old_target_id:SimBoardObj = null;
         var old_path:Vector.<Point> = null;
         var dt:int = 0;
         var time:int = 0;
         var n_pos:Point = null;
         var distance:Number = NaN;
         var bullet_dt:int = 0;
         var bullet_time:int = 0;
         var is_init:Boolean = param1;
         var id:int = param2;
         var target_id:SimBoardObj = param3;
         var etime:int = param4;
         if(this.simFun.unitExists(id))
         {
            u = this.simFun.unitById(id);
            old_target_id = u.target_id ? u.target_id.clone() : null;
            old_path = u.path ? u.path.slice() : null;
            if(u.state == SimUnitT.GO_TO_TARGET && (Boolean(u.target_id && u.target_id.equal(target_id) || this.targetExists(u.target_id) || !u.target_id && this.isVector(u)) || Boolean(!u.target_id && u.isSpellCallPath(etime))))
            {
               n_pos = this.targetNeigbourPos(target_id,u.pos,etime);
               if(Boolean(n_pos) && is_init)
               {
                  doAttack = function():void
                  {
                     var _loc1_:int = etime + simFun.unitSpeedAttack(u,u.attack_time,etime);
                     pq.add(_loc1_,SimFun.createUnitAttack(id,target_id,false));
                     simRun.unitPrepareAttack(id,target_id,_loc1_);
                     notifyCannonsGuards(etime,u);
                  };
                  if(!this.canAttackObject(target_id,u,etime))
                  {
                     u.setInitState();
                     this.init(id,etime);
                  }
                  else if(u.recalc_path || u.find_unit)
                  {
                     if(this.checkNewPath(etime,u) || this.validatePathToEnemy(etime,u))
                     {
                        this.makeInit(u,etime);
                     }
                     else if(Boolean(old_target_id) && Boolean(old_target_id.equal(u.target_id)) && SimFun.equalVectors(old_path,u.path))
                     {
                        doAttack();
                     }
                     else
                     {
                        this.goTo(id,true,etime);
                     }
                  }
                  else
                  {
                     doAttack();
                  }
               }
               else if(Boolean(n_pos) && u.radius > 1)
               {
                  if(u.recalc_path && is_init)
                  {
                     this.goTo(id,true,etime);
                  }
                  else
                  {
                     distance = SimBoard.distancef(u.pos,n_pos);
                     bullet_dt = Math.floor(u.bullet_speed * distance);
                     bullet_time = etime + bullet_dt;
                     dt = this.simFun.unitSpeedAttack(u,u.attack_delay,etime);
                     time = etime + dt;
                     if(u.is_kamikaze)
                     {
                        this.removeUnit(u);
                     }
                     else
                     {
                        this.pq.add(time,SimFun.createUnitAttack(id,target_id,!is_init));
                     }
                     this.simRun.unitFireAttack(u,n_pos,bullet_time,target_id);
                     if(bullet_dt == 0)
                     {
                        this.applyDamage(u,target_id,n_pos,etime,true);
                     }
                     else
                     {
                        this.pq.add(bullet_time,SimFun.createUnitFireAttack(u,target_id,n_pos));
                     }
                  }
               }
               else if(n_pos)
               {
                  this.applyDamage(u,target_id,n_pos,etime,false);
                  dt = this.simFun.unitSpeedAttack(u,u.attack_delay,etime);
                  time = etime + dt;
                  if(u.is_kamikaze)
                  {
                     this.removeUnit(u);
                  }
                  else if(this.targetExists(target_id))
                  {
                     this.pq.add(time,SimFun.createUnitAttack(id,target_id,!is_init));
                  }
                  else if(target_id.kind == SimBoardObj.FENCE && Boolean(u.target_id))
                  {
                     u.recalc_path = true;
                     this.pq.add(time,SimFun.createUnitGoTo(id,true));
                  }
                  else
                  {
                     u.setInitState();
                     this.pq.add(time,SimFun.createInitUnit(id));
                  }
               }
               else
               {
                  time = etime + this.simFun.unitSpeedAttack(u,u.attack_delay,etime);
                  if(target_id.kind == SimBoardObj.FENCE && is_init && this.targetExists(u.target_id))
                  {
                     this.goTo(id,true,etime);
                  }
                  else if(target_id.kind == SimBoardObj.FENCE && this.targetExists(u.target_id))
                  {
                     this.pq.add(time,SimFun.createUnitGoTo(id,true));
                  }
                  else
                  {
                     u.setInitState();
                     if(is_init)
                     {
                        this.init(id,etime);
                     }
                     else
                     {
                        this.pq.add(time,SimFun.createInitUnit(id));
                     }
                  }
               }
            }
            else if(this.simFun.unitExists(id))
            {
               u = this.simFun.unitById(id);
               u.setInitState();
               if(is_init)
               {
                  this.init(id,etime);
               }
               else
               {
                  this.pq.add(etime + this.simFun.unitSpeedAttack(u,u.attack_delay,etime),SimFun.createInitUnit(id));
               }
            }
         }
      }
      
      private function enableGuard(param1:int, param2:Point, param3:int) : void
      {
         var b:SimBuildingT = null;
         var units:Vector.<int> = null;
         var position:Point = null;
         var t:int = 0;
         var i:int = 0;
         var u:SimUnitT = null;
         var g_id:int = param1;
         var to_pos:Point = param2;
         var etime:int = param3;
         if(this.simFun.buildingExists(g_id))
         {
            b = this.simFun.buildingById(g_id);
            if(b.is_finished)
            {
               units = new Vector.<int>();
               this.simFun.data.units.iter(function(param1:int, param2:SimUnitT):void
               {
                  if(Boolean(param2.building_id && param2.building_id == g_id && !param2.is_active) && Boolean(param2.state != SimUnitT.WAIT_INIT) && !param2.is_healer)
                  {
                     units.push(param1);
                  }
               });
               units = units.sort(function(param1:int, param2:int):Number
               {
                  return param2 - param1;
               });
               if(units.length > 0)
               {
                  this.simRun.attention(g_id);
                  position = this.simFun.data.board.findNeigbourPoint(b.pos,b.size,to_pos);
                  t = etime;
                  i = units.length - 1;
                  while(i >= 0)
                  {
                     u = this.simFun.unitById(units[i]);
                     if(t == etime)
                     {
                        u.pos = position.clone();
                        u.setInitState();
                        this.init(u.id,etime);
                        t += SimFun.UNITS_LANDING_PERIOD;
                     }
                     else
                     {
                        u.pos = position.clone();
                        u.state = SimUnitT.WAIT_INIT;
                        this.pq.add(t,SimFun.createInitUnit(u.id));
                        t += SimFun.UNITS_LANDING_PERIOD;
                     }
                     i--;
                  }
               }
            }
         }
      }
      
      private function notifyCannonsGuards(param1:int, param2:SimUnitT) : void
      {
         var objs:Vector.<SimBoardObj> = null;
         var i:int = 0;
         var intpos:int = 0;
         var uo_id:SimBoardObj = null;
         var etime:int = param1;
         var u:SimUnitT = param2;
         if(u.is_attacker)
         {
            objs = this.simFun.data.board.cannonsGuardsOnPos(u.pos);
            i = 0;
            while(i < objs.length)
            {
               if(objs[i].kind == SimBoardObj.CANNON)
               {
                  this.logicCannons.targetInArea(objs[i].id,u.id,etime);
               }
               else if(objs[i].kind == SimBoardObj.BUILDING)
               {
                  this.enableGuard(objs[i].id,u.pos,etime);
               }
               i++;
            }
         }
         else
         {
            intpos = SimFun.Point2Int(u.pos.x,u.pos.y);
            uo_id = u.boardObj();
            this.simFun.data.units_groups.iter(function(param1:int, param2:SimGroup):void
            {
               var _loc3_:Number = NaN;
               var _loc4_:* = int(param2.targets.length - 1);
               while(_loc4_ >= 0)
               {
                  if(uo_id.equal(param2.targets[_loc4_]))
                  {
                     _loc3_ = _loc4_;
                  }
                  _loc4_--;
               }
               if(!isNaN(_loc3_))
               {
                  param2.targets.splice(_loc3_,1);
               }
               if(param2.priority_type != PUnitProirityType.FENCE && param2.rhombs.indexOf(intpos) >= 0)
               {
                  param2.targets.push(uo_id);
               }
            });
         }
      }
      
      private function notifyDefenders(param1:int, param2:SimUnitT) : void
      {
         if(!param2.is_attacker && param2.state == SimUnitT.WAIT_ATTACKER)
         {
            this.makeInit(param2,param1);
         }
      }
      
      public function boardObjectMore(param1:SimBoardObj, param2:SimBoardObj) : Boolean
      {
         return param1.id == param2.id ? param1.kind != SimBoardObj.UNIT : param1.id >= param2.id;
      }
      
      private function healerTarget(param1:SimUnitT, param2:int) : Object
      {
         var check_distance:Boolean = false;
         var res:Object = null;
         var res_d:Number = NaN;
         var res_u:SimUnitT = null;
         var d2:Number = NaN;
         var path:Vector.<Point> = null;
         var u:SimUnitT = param1;
         var etime:int = param2;
         check_distance = !isNaN(u.group);
         this.simFun.data.units.iter(function(param1:int, param2:SimUnitT):void
         {
            if(param2.is_attacker == u.is_attacker && param2.id != u.id && param2.stamina < param2.max_stamina && !param2.is_healer)
            {
               d2 = SimBoard.distance2(param2.pos,u.pos);
               if(Boolean(res_u) && (Boolean(d2 < res_d || d2 == res_d && param2.id < res_u.id)) && (!check_distance || check_distance && canAttackObject(param2.boardObj(),u,etime)))
               {
                  res_d = d2;
                  res_u = param2;
               }
               else if(!res_u && (!check_distance || check_distance && canAttackObject(param2.boardObj(),u,etime)))
               {
                  res_d = d2;
                  res_u = param2;
               }
            }
         });
         if(Boolean(res_u) && check_distance)
         {
            res = {};
            res.target_id = res_u.boardObj();
            res.path = new Vector.<Point>();
         }
         else if(res_u)
         {
            res = {};
            res.target_id = res_u.boardObj();
            path = this.pathForTarget(res_u.boardObj(),etime,u);
            if(Boolean(path) && path.length > 0)
            {
               res.path = path;
            }
            else
            {
               res.path = new Vector.<Point>();
            }
         }
         return res;
      }
      
      private function findNotUnit(param1:SimUnitT, param2:int) : Object
      {
         var o:Object = null;
         var res:SimBoardObj = null;
         var d:Number = NaN;
         var t_pos:Point = null;
         var ug:SimGroup = null;
         var alived_targets:Vector.<SimBoardObj> = null;
         var t_id:SimBoardObj = null;
         var can_attack:Boolean = false;
         var distance:Number = NaN;
         var tu:SimUnitT = null;
         var path:Vector.<Point> = null;
         var u:SimUnitT = param1;
         var etime:int = param2;
         res = null;
         d = NaN;
         if(!isNaN(u.group))
         {
            if(this.simFun.data.units_groups.mem(u.group))
            {
               ug = this.simFun.data.units_groups.find(u.group);
               if(ug.targets.length > 0)
               {
                  alived_targets = new Vector.<SimBoardObj>();
                  for each(t_id in ug.targets)
                  {
                     t_pos = this.targetNeigbourPos(t_id,u.pos,etime);
                     if(t_pos)
                     {
                        alived_targets.push(t_id);
                        can_attack = true;
                        if(t_id.kind == SimBoardObj.UNIT)
                        {
                           tu = this.simFun.unitById(t_id.id);
                           can_attack = this.simFun.checkUnitType(u,tu);
                        }
                        distance = SimBoard.distance2(u.pos,t_pos);
                        if(can_attack && (isNaN(d) || distance < d || distance == d && this.boardObjectMore(res,t_id)))
                        {
                           res = t_id;
                           d = distance;
                        }
                     }
                  }
                  ug.targets = alived_targets;
               }
            }
         }
         else
         {
            this.simFun.data.buildings.iter(function(param1:int, param2:SimBuildingT):void
            {
               t_pos = simFun.data.board.findNeigbourPoint(param2.pos,param2.size,u.pos);
               var _loc3_:Number = SimBoard.distance2(u.pos,t_pos);
               if(isNaN(d) || _loc3_ < d || _loc3_ == d && boardObjectMore(res,param2.boardObj()))
               {
                  res = param2.boardObj();
                  d = _loc3_;
               }
            });
            this.simFun.data.cannons.iter(function(param1:int, param2:SimCannonT):void
            {
               t_pos = simFun.data.board.findNeigbourPoint(param2.pos,param2.size,u.pos);
               var _loc3_:Number = SimBoard.distance2(u.pos,t_pos);
               if(isNaN(d) || _loc3_ < d || _loc3_ == d && boardObjectMore(res,param2.boardObj()))
               {
                  res = param2.boardObj();
                  d = _loc3_;
               }
            });
         }
         if(res)
         {
            path = this.pathForTarget(res,etime,u);
            if(path)
            {
               o = {
                  "target_id":res,
                  "path":path
               };
            }
         }
         return o;
      }
      
      public function findTarget(param1:SimUnitT, param2:int) : Object
      {
         var spell_call_pos:Point;
         var o:Object = null;
         var path:Vector.<Point> = null;
         var tu:SimUnitT = null;
         var t_id:SimBoardObj = null;
         var elt:SimBoardElt = null;
         var ug:SimGroup = null;
         var path_opt:Vector.<Point> = null;
         var u:SimUnitT = param1;
         var etime:int = param2;
         u.recalc_path = false;
         spell_call_pos = u.spellCall(etime);
         if(spell_call_pos)
         {
            elt = this.simFun.data.board.getElt(spell_call_pos.x,spell_call_pos.y);
            if(Boolean(elt && elt.obj) && (Boolean(elt.obj.kind == SimBoardObj.BUILDING || elt.obj.kind == SimBoardObj.CANNON)) && !u.is_healer)
            {
               path = this.pathForTarget(elt.obj,etime,u);
               o = {
                  "target_id":elt.obj,
                  "path":path
               };
            }
            else
            {
               path = this.findPath(u,new SimBoardObj(SimBoardObj.FENCE,0),spell_call_pos,new Point(1,1),0,etime);
               o = {
                  "target_id":null,
                  "path":path
               };
            }
         }
         else
         {
            if(u.is_healer)
            {
               o = this.healerTarget(u,etime);
            }
            else if(u.is_attacker && u.find_unit || !u.is_attacker)
            {
               tu = this.simFun.findEnemy(function(param1:SimUnitT):void
               {
                  notifyDefenders(etime,param1);
               },u,etime);
               if(Boolean(tu) && tu.pos.equals(u.pos))
               {
                  this.notifyAttackers(u.is_attacker,tu.pos,etime);
                  o = {};
                  o.target_id = new SimBoardObj(SimBoardObj.UNIT,tu.id);
                  o.path = new Vector.<Point>();
               }
               else if(tu)
               {
                  t_id = new SimBoardObj(SimBoardObj.UNIT,tu.id);
                  path = this.pathForTarget(t_id,etime,u);
                  if(path)
                  {
                     this.notifyAttackers(u.is_attacker,tu.pos,etime);
                     o = {
                        "target_id":t_id,
                        "path":path
                     };
                  }
                  else
                  {
                     o = this.findNotUnit(u,etime);
                  }
               }
               else if(u.is_attacker)
               {
                  o = this.findNotUnit(u,etime);
               }
            }
            else
            {
               o = this.findNotUnit(u,etime);
            }
            if(!o && !isNaN(u.group) && this.simFun.data.units_groups.mem(u.group))
            {
               ug = this.simFun.data.units_groups.find(u.group);
               path_opt = this.findPath(u,new SimBoardObj(SimBoardObj.FENCE,0),ug.goal_pos,new Point(1,1),0,etime);
               if(path_opt)
               {
                  o = {
                     "target_id":null,
                     "path":path_opt
                  };
               }
               else
               {
                  this.resetVector(u,etime);
               }
            }
            if(!o && !u.is_healer)
            {
               tu = this.simFun.findAnyUnit(u,etime);
               if(Boolean(tu) && tu.pos.equals(u.pos))
               {
                  o = {};
                  o.target_id = new SimBoardObj(SimBoardObj.UNIT,tu.id);
                  o.path = new Vector.<Point>();
               }
               else if(tu)
               {
                  t_id = new SimBoardObj(SimBoardObj.UNIT,tu.id);
                  path = this.pathForTarget(t_id,etime,u);
                  if(path)
                  {
                     o = {
                        "target_id":t_id,
                        "path":path
                     };
                  }
               }
            }
         }
         u.find_unit = false;
         return o;
      }
      
      private function validatePathToEnemy(param1:int, param2:SimUnitT) : Boolean
      {
         var enemy:SimUnitT = null;
         var path:Vector.<Point> = null;
         var tu:SimUnitT = null;
         var etime:int = param1;
         var u:SimUnitT = param2;
         var res:Boolean = false;
         if(u.state == SimUnitT.GO_TO_TARGET)
         {
            if(Boolean(u.target_id) && u.target_id.kind == SimBoardObj.UNIT)
            {
               if(!this.simFun.unitExists(u.target_id.id))
               {
                  res = true;
               }
               else
               {
                  enemy = this.simFun.unitById(u.target_id.id);
                  if(this.canAttackUnit(u.pos,u,enemy))
                  {
                     u.path = new Vector.<Point>(0);
                  }
                  else if(SimFun.pointExistsInVector(u.path,enemy.pos) || Boolean(u.path && u.path.length > 0) && Boolean(this.canAttackUnit(u.path[u.path.length - 1],u,enemy)))
                  {
                     res = false;
                  }
                  else
                  {
                     path = this.pathForTarget(u.target_id,etime,u);
                     u.path = path;
                  }
               }
            }
            else if(u.is_attacker && u.find_unit || !u.is_attacker)
            {
               tu = this.simFun.findEnemy(function(param1:SimUnitT):void
               {
                  notifyDefenders(etime,param1);
               },u,etime);
               if(tu)
               {
                  res = true;
               }
               else
               {
                  u.find_unit = false;
               }
            }
         }
         return res;
      }
      
      private function notifyWaiters(param1:Boolean, param2:Point, param3:int) : void
      {
         var ids:Vector.<int> = null;
         var id:int = 0;
         var u:SimUnitT = null;
         var is_attacker:Boolean = param1;
         var pos:Point = param2;
         var etime:int = param3;
         if(is_attacker)
         {
            ids = this.simFun.defendersInQuad(pos);
            ids = ids.sort(function(param1:int, param2:int):Number
            {
               return param1 - param2;
            });
            for each(id in ids)
            {
               if(this.simFun.unitExists(id))
               {
                  u = this.simFun.unitById(id);
                  if(u.state == SimUnitT.WAIT_ATTACKER)
                  {
                     this.makeInit(u,etime);
                  }
               }
            }
         }
      }
      
      public function applyCall(param1:SimUnitT, param2:Point, param3:int, param4:Number, param5:int) : void
      {
         if(param1.is_attacker && param1.is_active && (!isNaN(param4) && param1.user_num == param4 || isNaN(param4)))
         {
            this.resetVector(param1,param5);
            param1.setSpellCall(param2,param5 + param3);
         }
      }
   }
}

