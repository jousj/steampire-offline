package logic.sim
{
   import engine.Position;
   import engine.display.AnimClip;
   import engine.units.Build;
   import flash.geom.Point;
   import logic.battle.SimBaseVisual;
   import model.ManualProxy;
   import model.ResourceProxy;
   import model.calc.VectorCalc;
   import model.vo.VOResourceSpec;
   import model.vo.VOStorageSpec;
   import proto.model.*;
   
   public class SimData
   {
      
      public var buildings:Hashtbl = new Hashtbl();
      
      public var fences:Hashtbl = new Hashtbl();
      
      public var cannons:Hashtbl = new Hashtbl();
      
      public var garbages:Hashtbl = new Hashtbl();
      
      public var units:Hashtbl = new Hashtbl();
      
      public var units_groups:Hashtbl = new Hashtbl();
      
      public var board:SimBoard;
      
      public var references:PReferences;
      
      public var all_stamina:int;
      
      public var power:int;
      
      public var isBoss:Boolean;
      
      public var powerK:Number = 0;
      
      public var unitId:int;
      
      public var groupNum:int = 10000;
      
      public var rmBuildCount:uint;
      
      public var rmCannonCount:uint;
      
      public function SimData(param1:SimBoard, param2:PReferences)
      {
         super();
         this.board = param1;
         this.references = param2;
      }
      
      public function objectExists(param1:SimBoardObj) : Boolean
      {
         switch(param1.kind)
         {
            case SimBoardObj.BUILDING:
               return this.buildings.mem(param1.id);
            case SimBoardObj.CANNON:
               return this.cannons.mem(param1.id);
            case SimBoardObj.FENCE:
               return this.fences.mem(param1.id);
            case SimBoardObj.GARBAGE:
               return this.garbages.mem(param1.id);
            case SimBoardObj.UNIT:
               return this.units.mem(param1.id);
            default:
               return false;
         }
      }
      
      public function initPower(param1:int, param2:Boolean, param3:Boolean, param4:Boolean) : void
      {
         this.power = param1;
         this.isBoss = param4;
         this.powerK = param4 ? this.references.stamina_per_pp : (param3 ? this.references.clan_hp_per_pp : (param2 ? this.references.raid_hp_per_pp : this.references.hp_per_pp));
      }
      
      private function getStamina(param1:Array, param2:uint) : int
      {
         var _loc3_:Number = Number(param1[param2]);
         return isNaN(_loc3_) ? -1 : int(_loc3_);
      }
      
      public function assignUm(param1:PUm, param2:Array = null, param3:Array = null, param4:Number = 1, param5:Boolean = false) : void
      {
         var _loc10_:int = 0;
         var _loc11_:PCannon = null;
         var _loc12_:PBuilding = null;
         var _loc13_:PDecor = null;
         var _loc14_:PGarbage = null;
         var _loc15_:PFence = null;
         var _loc16_:* = 0;
         var _loc17_:PShopCannon = null;
         var _loc18_:PShopBuilding = null;
         var _loc19_:SimBuildingT = null;
         var _loc6_:ManualProxy = Facade.manualProxy;
         var _loc7_:ResourceProxy = AnimClip.resourceProxy;
         var _loc8_:Boolean = param3 != null;
         var _loc9_:int = -1;
         if(param4 < 1)
         {
            param4 = 1;
         }
         for each(_loc11_ in param1.cannons)
         {
            if(_loc11_.cannon_pos.x >= 0)
            {
               _loc16_ = int(_loc11_.cannon_level);
               if(_loc16_ > 1 && _loc11_.cannon_build_state.variance == PBuildState.IN_PROGRESS)
               {
                  _loc16_--;
               }
               _loc17_ = _loc6_.getCannonShop(_loc11_.cannon_kind,_loc16_);
               this.all_stamina += int(_loc17_.sc_stamina * param4) + int(_loc17_.sc_armor * param4);
               _loc10_ = int(_loc7_.getSize(_loc11_.cannon_kind));
               if(_loc8_)
               {
                  _loc9_ = this.getStamina(param3,_loc11_.cannon_id);
                  if(_loc9_ == 0)
                  {
                     this.board.addLanding(_loc11_.cannon_pos.x,_loc11_.cannon_pos.y,_loc10_,_loc10_,_loc11_.cannon_id);
                     SimBaseVisual.addCustomBroken(true,_loc11_.cannon_kind,_loc16_,_loc11_.cannon_pos.x,_loc11_.cannon_pos.y);
                     continue;
                  }
               }
               this.addCannon(_loc11_.cannon_id,_loc11_.cannon_pos.x,_loc11_.cannon_pos.y,_loc17_,_loc10_,_loc11_.cannon_build_state.variance == PBuildState.FINISHED,_loc9_,param4,param5 ? param4 : 1);
            }
         }
         for each(_loc12_ in param1.buildings.reverse())
         {
            if(_loc12_.building_pos.x >= 0)
            {
               _loc16_ = int(_loc12_.building_level);
               if(_loc16_ > 1 && _loc12_.building_build_state.variance == PBuildState.IN_PROGRESS)
               {
                  _loc16_--;
               }
               _loc18_ = _loc6_.getBuildShop(_loc12_.building_kind,_loc16_);
               this.all_stamina += int(_loc18_.sb_stamina * param4) + int(_loc18_.sb_armor * param4);
               _loc10_ = int(_loc7_.getSize(_loc12_.building_kind));
               if(_loc8_)
               {
                  _loc9_ = this.getStamina(param3,_loc12_.building_id);
                  if(_loc9_ == 0)
                  {
                     this.board.addLanding(_loc12_.building_pos.x,_loc12_.building_pos.y,_loc10_,_loc10_,_loc12_.building_id);
                     SimBaseVisual.addCustomBroken(false,_loc12_.building_kind,_loc16_,_loc12_.building_pos.x,_loc12_.building_pos.y);
                     continue;
                  }
               }
               _loc19_ = this.addBuild(_loc12_.building_id,_loc12_.building_pos.x,_loc12_.building_pos.y,_loc18_,_loc10_,_loc12_.building_build_state.variance == PBuildState.FINISHED,_loc9_,param4);
               if(_loc19_.type == PBtype.RESOURCE || _loc19_.type == PBtype.STORAGE)
               {
                  this.applyResourceCapacity(_loc19_);
               }
               else if(_loc19_.is_finished)
               {
                  if(_loc19_.type == PBtype.GUARD)
                  {
                     if(param2)
                     {
                        this.registerGuard(_loc19_,_loc6_.getGuardShop(_loc12_.building_kind,_loc16_),_loc12_.building_spec.value,param2,_loc6_);
                     }
                  }
                  else if(_loc19_.type == PBtype.PYLON)
                  {
                     this.registerPylon(_loc19_,_loc6_.getPylonShop(_loc12_.building_kind,_loc16_));
                  }
               }
            }
         }
         for each(_loc13_ in param1.decors)
         {
            _loc10_ = int(_loc7_.getSize(_loc13_.decor_kind));
            if(_loc13_.decor_pos.x < 0)
            {
               this.board.addLanding(_loc13_.decor_pos.x,_loc13_.decor_pos.y,_loc10_,_loc10_,_loc13_.decor_id);
            }
            else
            {
               this.addDecor(_loc13_.decor_id,_loc13_.decor_pos.x,_loc13_.decor_pos.y,_loc10_);
            }
         }
         for each(_loc14_ in param1.garbages)
         {
            this.addGarbage(_loc14_.garbage_id,_loc14_.garbage_pos.x,_loc14_.garbage_pos.y,_loc7_.getSize(_loc14_.garbage_kind));
         }
         for each(_loc15_ in param1.fences)
         {
            if(_loc15_.fence_pos.x >= 0)
            {
               if(_loc8_)
               {
                  _loc9_ = this.getStamina(param3,_loc15_.fence_id);
                  if(_loc9_ == 0)
                  {
                     this.board.addLanding(_loc15_.fence_pos.x,_loc15_.fence_pos.y,1,1,_loc15_.fence_id);
                     continue;
                  }
               }
               this.addFence(_loc15_.fence_id,_loc15_.fence_pos.x,_loc15_.fence_pos.y,_loc6_.getFenceShop(_loc15_.fence_kind,_loc15_.fence_level),1,_loc9_,param4);
            }
         }
      }
      
      private function applyResourceCapacity(param1:SimBuildingT) : void
      {
         var _loc2_:Build = Facade.userProxy.constructionHash[param1.id];
         if(Boolean(_loc2_) && _loc2_.type == param1.type)
         {
            if(_loc2_.type == PBtype.RESOURCE)
            {
               param1.capacityCur = (_loc2_.spec as VOResourceSpec).capacityCur;
               param1.capacityMax = (_loc2_.spec as VOResourceSpec).capacityMax;
            }
            else
            {
               param1.capacityCur = (_loc2_.spec as VOStorageSpec).capacityCur;
               param1.capacityMax = (_loc2_.spec as VOStorageSpec).capacityMax;
            }
         }
      }
      
      private function addCannon(param1:uint, param2:int, param3:int, param4:PShopCannon, param5:uint, param6:Boolean, param7:int, param8:Number, param9:Number) : void
      {
         var _loc10_:SimCannonT = new SimCannonT();
         _loc10_.id = param1;
         _loc10_.armor = param4.sc_armor * param8;
         _loc10_.max_stamina = param4.sc_stamina * param8 + _loc10_.armor;
         _loc10_.stamina = param7 < 0 ? _loc10_.max_stamina : param7;
         _loc10_.pos = new Point(param2,param3);
         _loc10_.size = new Point(param5,param5);
         _loc10_.radius = param4.sc_radius;
         _loc10_.blind_radius = param4.sc_blind_radius;
         _loc10_.target_type = param4.sc_target_type.variance;
         _loc10_.damage = param4.sc_damage * param9;
         _loc10_.penetration = param4.sc_penetration;
         _loc10_.aoe_radius = param4.sc_aoe_radius;
         _loc10_.attack_delay = param4.sc_attack_delay;
         _loc10_.attack_time = param4.sc_attack_time;
         _loc10_.bullet_speed = param4.sc_bullet_speed;
         _loc10_.is_finished = param6;
         _loc10_.slowdown = param4.sc_slowdown;
         _loc10_.slowdown_time = param4.sc_slowdown_time;
         _loc10_.favorite_units = param4.sc_favorite_units;
         _loc10_.favorite_dmg_koef = param4.sc_favorite_dmg_koef;
         _loc10_.sort_by_distance = param4.sc_sort_by_distance;
         _loc10_.shop = param4;
         this.cannons.add(_loc10_.id,_loc10_);
         this.board.addObject(_loc10_.boardObj(),_loc10_.pos,_loc10_.size);
         this.board.registerCannon(_loc10_.id,SimBoard.findCenter(_loc10_.pos,_loc10_.size),_loc10_.size,_loc10_.radius);
      }
      
      private function addBuild(param1:uint, param2:int, param3:int, param4:PShopBuilding, param5:uint, param6:Boolean, param7:int, param8:Number) : SimBuildingT
      {
         var _loc9_:SimBuildingT = new SimBuildingT();
         _loc9_.id = param1;
         _loc9_.armor = param4.sb_armor * param8;
         _loc9_.max_stamina = param4.sb_stamina * param8 + _loc9_.armor;
         _loc9_.stamina = param7 < 0 ? _loc9_.max_stamina : param7;
         _loc9_.pos = new Point(param2,param3);
         _loc9_.size = new Point(param5,param5);
         _loc9_.type = param4.sb_btype.variance;
         _loc9_.is_finished = param6;
         _loc9_.shop = param4;
         this.buildings.add(_loc9_.id,_loc9_);
         this.board.addObject(_loc9_.boardObj(),_loc9_.pos,_loc9_.size);
         return _loc9_;
      }
      
      private function registerGuard(param1:SimBuildingT, param2:PShopGuard, param3:PGuard, param4:Array, param5:ManualProxy) : void
      {
         var _loc6_:PKindCount = null;
         var _loc7_:PShopUnit = null;
         var _loc8_:uint = 0;
         var _loc9_:SimUnitT = null;
         param1.guard_radius = param2.sga_radius;
         if(param3.guard_count > 0 && param3.guard_config.length > 0)
         {
            for each(_loc6_ in param3.guard_config)
            {
               _loc7_ = param5.getSoldierShop(_loc6_.kind,param5.getUnitLevel(param4,_loc6_.kind));
               _loc8_ = _loc6_.count;
               while(_loc8_ > 0)
               {
                  _loc9_ = this.createUnitT(_loc7_,null,false,new Point(),false,param1.id);
                  _loc9_.id = ++this.unitId;
                  this.units.add(_loc9_.id,_loc9_);
                  _loc8_--;
               }
            }
         }
         this.board.registerGuard(param1.id,SimBoard.findCenter(param1.pos,param1.size),param1.size,param1.guard_radius);
      }
      
      private function registerPylon(param1:SimBuildingT, param2:PShopPylon) : void
      {
         var r2:int = 0;
         var build:SimBuildingT = param1;
         var info:PShopPylon = param2;
         r2 = SimBoard.radius(info.sp_radius);
         this.cannons.iter(function(param1:int, param2:SimCannonT):void
         {
            var id:int = param1;
            var c:SimCannonT = param2;
            if(SimFun.existsInVector(SimBoard.perimeter(c.pos,c.size),function(param1:Point):Boolean
            {
               return SimBoard.distance2(SimBoard.findCenter_(build.pos,build.size,param1),param1) <= r2;
            }))
            {
               c.pylons.push(build.id);
            }
         });
      }
      
      private function addDecor(param1:uint, param2:int, param3:int, param4:uint) : void
      {
         var _loc5_:SimDecorT = new SimDecorT(param1,new Point(param2,param3),new Point(param4,param4));
         this.garbages.add(_loc5_.id,_loc5_);
         this.board.addObject(_loc5_.boardObj(),_loc5_.pos,_loc5_.size);
      }
      
      private function addGarbage(param1:uint, param2:int, param3:int, param4:uint) : void
      {
         var _loc5_:SimGarbageT = new SimGarbageT(param1,new Point(param2,param3),new Point(param4,param4));
         this.garbages.add(_loc5_.id,_loc5_);
         this.board.addObject(_loc5_.boardObj(),_loc5_.pos,_loc5_.size);
      }
      
      private function addFence(param1:uint, param2:int, param3:int, param4:PShopFence, param5:uint, param6:int, param7:Number) : void
      {
         var _loc8_:SimFenceT = new SimFenceT();
         _loc8_.id = param1;
         _loc8_.armor = param4.sf_armor * param7;
         _loc8_.max_stamina = param4.sf_stamina * param7 + _loc8_.armor;
         _loc8_.stamina = param6 < 0 ? _loc8_.max_stamina : param6;
         _loc8_.pos = new Point(param2,param3);
         _loc8_.size = new Point(param5,param5);
         _loc8_.shop = param4;
         this.fences.add(_loc8_.id,_loc8_);
         this.board.addObject(_loc8_.boardObj(),_loc8_.pos,_loc8_.size);
      }
      
      private function createUnitT(param1:PShopUnit, param2:PHero, param3:Boolean, param4:Point, param5:Boolean, param6:uint = 0, param7:Number = NaN) : SimUnitT
      {
         var _loc9_:PCannonTargetType = null;
         var _loc8_:SimUnitT = new SimUnitT();
         _loc8_.pos = param4;
         _loc8_.is_air = param1.su_is_air;
         _loc8_.penetration = param1.su_penetration;
         _loc8_.is_attacker = param3;
         _loc8_.is_active = param5;
         _loc8_.priority_type = param1.su_priority_type.variance;
         _loc8_.priority_factor = param1.su_priority_factor;
         _loc8_.aoe_radius = param1.su_aoe_radius;
         _loc8_.radius = param1.su_radius;
         _loc8_.move_delay = param1.su_move_delay;
         _loc8_.attack_delay = param1.su_attack_delay;
         _loc8_.attack_time = param1.su_attack_time;
         _loc8_.bullet_speed = param1.su_bullet_speed;
         _loc8_.is_kamikaze = param1.su_is_kamikaze;
         _loc8_.building_id = param6;
         _loc8_.target_type = param1.su_target_type.variance;
         _loc8_.group = param7;
         _loc8_.is_healer = param1.su_is_healer;
         _loc8_.kind = param1.su_kind;
         _loc8_.level = param1.su_level;
         _loc8_.attacked_by = [];
         _loc8_.max_cure_stamina = param1.su_max_cure_stamina;
         _loc8_.shop = param1;
         for each(_loc9_ in param1.su_attacked_by)
         {
            _loc8_.attacked_by.push(_loc9_.variance);
         }
         if(param2)
         {
            this.applyHeroUpdate(_loc8_,param1,param2);
         }
         else
         {
            _loc8_.stamina = param1.su_stamina;
            _loc8_.damage = param1.su_damage;
            _loc8_.armor = param1.su_armor;
         }
         _loc8_.stamina += _loc8_.armor;
         _loc8_.max_stamina = _loc8_.stamina;
         return _loc8_;
      }
      
      private function applyHeroUpdate(param1:SimUnitT, param2:PShopUnit, param3:PHero) : void
      {
         var _loc4_:ManualProxy = Facade.manualProxy;
         param1.stamina = _loc4_.getHeroStat(param2,PHeroUpgradeKind.STAMINA,param3);
         param1.damage = _loc4_.getHeroStat(param2,PHeroUpgradeKind.DAMAGE,param3);
         param1.armor = _loc4_.getHeroStat(param2,PHeroUpgradeKind.ARMOR,param3);
      }
      
      public function addUnits(param1:PShopUnit, param2:PHero, param3:uint, param4:Position, param5:Position, param6:uint = 0) : int
      {
         var _loc11_:Point = null;
         var _loc13_:SimBoardElt = null;
         var _loc14_:int = 0;
         var _loc15_:SimUnitT = null;
         var _loc16_:SimUnitT = null;
         if(param3 == 0)
         {
            return -1;
         }
         var _loc7_:Vector.<Point> = this.board.vertical(Facade.map.getDropLine(param4.x,param4.y,param5.x,param5.y,SimBoard.directionList));
         if(_loc7_.length == 0)
         {
            return -1;
         }
         var _loc8_:* = 0;
         var _loc9_:Vector.<Point> = new VectorCalc().getVectorList(param4,param5);
         var _loc10_:SimGroup = new SimGroup();
         _loc10_.goal_pos = new Point(param5.x,param5.y);
         var _loc12_:Vector.<int> = new Vector.<int>(0);
         _loc10_.priority_type = param1.su_priority_type.variance;
         for each(_loc11_ in _loc9_)
         {
            if(!param1.su_is_healer)
            {
               _loc13_ = this.board.getElt(_loc11_.x,_loc11_.y);
               if(param1.su_priority_type.variance == PUnitProirityType.FENCE)
               {
                  if(Boolean(_loc13_.obj) && Boolean(_loc13_.obj.kind == SimBoardObj.FENCE) && _loc12_.indexOf(_loc13_.obj.id) < 0)
                  {
                     _loc12_.push(_loc13_.obj.id);
                     _loc10_.targets.push(_loc13_.obj.clone());
                  }
               }
               else
               {
                  if(Boolean(_loc13_.obj) && (Boolean(_loc13_.obj.kind == SimBoardObj.BUILDING || _loc13_.obj.kind == SimBoardObj.CANNON)) && _loc12_.indexOf(_loc13_.obj.id) < 0)
                  {
                     _loc12_.push(_loc13_.obj.id);
                     _loc10_.targets.push(_loc13_.obj.clone());
                  }
                  for each(_loc14_ in _loc13_.units)
                  {
                     _loc15_ = this.units.find(_loc14_);
                     if((Boolean(_loc15_)) && !_loc15_.is_attacker)
                     {
                        _loc10_.targets.push(_loc15_.boardObj());
                     }
                  }
               }
            }
            _loc10_.rhombs.push(SimFun.Point2Int(_loc11_.x,_loc11_.y));
         }
         --this.groupNum;
         this.units_groups.add(this.groupNum,_loc10_);
         while(param3 > 0)
         {
            param3--;
            _loc11_ = _loc7_[_loc8_];
            if(++_loc8_ >= _loc7_.length)
            {
               _loc8_ = 0;
            }
            _loc16_ = this.createUnitT(param1,param2,true,_loc11_,false,0,this.groupNum);
            _loc16_.id = ++this.unitId;
            _loc16_.user_num = param6;
            this.units.add(_loc16_.id,_loc16_);
            _loc10_.attackers.push(_loc16_.id);
         }
         return this.unitId;
      }
      
      public function addDefenderUnit(param1:PShopUnit, param2:int, param3:Position) : void
      {
         var _loc4_:SimUnitT = this.createUnitT(param1,null,false,new Point(param3.x,param3.y),false);
         _loc4_.id = param2;
         this.units.add(param2,_loc4_);
      }
   }
}

