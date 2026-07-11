package model
{
   import engine.data.LinkedList;
   import engine.units.Build;
   import engine.units.Unit;
   import flash.utils.Dictionary;
   import logic.sim.Hashtbl;
   import logic.sim.SimBuildingT;
   import logic.sim.SimData;
   import logic.sim.SimUnitT;
   import model.ui.VOWinItem;
   import model.vo.VOResourceSpec;
   import model.vo.VOStorageSpec;
   import proto.model.PBtype;
   import proto.model.PBuildState;
   import proto.model.PBuilding;
   import proto.model.PBuildingSpec;
   import proto.model.PCannon;
   import proto.model.PCost;
   import proto.model.PFightType;
   import proto.model.PMissionInfo;
   import proto.model.PMissionWin;
   import proto.model.PReferences;
   import proto.model.PResource;
   import proto.model.PStorm;
   import proto.model.PTargetInfo;
   import proto.model.PUm;
   import proto.tuples.str_Position;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   
   public class BattleProxy
   {
      
      public var allowHSpace:int;
      
      public var raidDropCapacity:uint;
      
      public var thLevel:uint;
      
      public var mission:PMissionInfo;
      
      public var isWin:Boolean;
      
      public var startPower:int;
      
      public var crystal:uint;
      
      public var isHeroDrop:Boolean = false;
      
      public var oil:uint;
      
      public var stealCrystal:uint;
      
      public var stealOil:uint;
      
      public var stormId:String;
      
      public var storm:PStorm;
      
      public const winList:Array = [];
      
      public function BattleProxy()
      {
         super();
      }
      
      public static function getSteal(param1:Hashtbl, param2:PTargetInfo, param3:PCost, param4:PCost) : void
      {
         var _loc13_:uint = 0;
         var _loc14_:Number = NaN;
         var _loc17_:PBuilding = null;
         var _loc18_:int = 0;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:PCost = null;
         var _loc22_:SimBuildingT = null;
         var _loc5_:Boolean = param2.ti_fight_type.variance == PFightType.SINGLE;
         var _loc6_:ManualProxy = Facade.manualProxy;
         var _loc7_:PReferences = Facade.references;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:Array = [];
         var _loc15_:uint = _loc5_ ? uint(param2.ti_crystal * param2.ti_th_diff_k * param2.ti_storage_fight_k) : param2.ti_crystal;
         var _loc16_:uint = _loc5_ ? uint(param2.ti_oil * param2.ti_th_diff_k * param2.ti_storage_fight_k) : param2.ti_oil;
         for each(_loc17_ in param2.ti_um.buildings)
         {
            _loc19_ = _loc17_.building_level;
            if(_loc17_.building_build_state.variance == PBuildState.IN_PROGRESS)
            {
               _loc19_--;
            }
            if(_loc19_ != 0)
            {
               _loc20_ = _loc17_.building_spec.variance;
               if(_loc20_ == PBuildingSpec.STORAGE)
               {
                  _loc21_ = _loc6_.getStorageShop(_loc17_.building_kind,_loc19_).ss_capacity;
                  if(_loc21_.variance == PCost.CRYSTAL)
                  {
                     _loc9_ += _loc21_.value;
                  }
                  else
                  {
                     if(_loc21_.variance != PCost.OIL)
                     {
                        continue;
                     }
                     _loc11_ += _loc21_.value;
                  }
                  _loc12_.push(_loc17_.building_id,_loc21_);
               }
               else if(_loc20_ == PBuildingSpec.RESOURCE)
               {
                  _loc20_ = _loc6_.getResourceShop(_loc17_.building_kind,_loc19_).sr_cost.variance;
                  if(!(_loc20_ != PCost.CRYSTAL && _loc20_ != PCost.OIL))
                  {
                     _loc13_ = (_loc17_.building_spec.value as PResource).done_count * (_loc5_ ? param2.ti_th_diff_k * _loc7_.resource_fight_k : 1);
                     if(_loc13_ > 0)
                     {
                        _loc22_ = param1[_loc17_.building_id] as SimBuildingT;
                        if(_loc22_)
                        {
                           _loc13_ *= (_loc22_.max_stamina - _loc22_.stamina) / _loc22_.max_stamina;
                        }
                        if(_loc13_ > 0)
                        {
                           if(_loc20_ == PCost.CRYSTAL)
                           {
                              _loc8_ += _loc13_;
                           }
                           else
                           {
                              _loc10_ += _loc13_;
                           }
                        }
                     }
                  }
               }
            }
         }
         _loc18_ = _loc12_.length - 2;
         while(_loc18_ >= 0)
         {
            _loc21_ = _loc12_[_loc18_ + 1];
            if(_loc21_.variance == PCost.CRYSTAL)
            {
               _loc14_ = _loc21_.value / _loc9_ * _loc15_;
            }
            else
            {
               _loc14_ = _loc21_.value / _loc11_ * _loc16_;
            }
            if(_loc14_ > 0)
            {
               _loc22_ = param1[_loc12_[_loc18_]] as SimBuildingT;
               if(_loc22_)
               {
                  _loc14_ *= (_loc22_.max_stamina - _loc22_.stamina) / _loc22_.max_stamina;
               }
               _loc13_ = _loc14_;
               if(_loc13_ > 0)
               {
                  if(_loc21_.variance == PCost.CRYSTAL)
                  {
                     _loc8_ += _loc13_;
                  }
                  else
                  {
                     _loc10_ += _loc13_;
                  }
               }
            }
            _loc18_ -= 2;
         }
         param3.value = _loc8_;
         param4.value = _loc10_;
      }
      
      public function clear() : void
      {
         this.mission = null;
         this.winList.length = 0;
         this.isWin = false;
         this.startPower = 0;
         this.oil = this.crystal = this.stealCrystal = this.stealOil = 0;
         this.stormId = null;
         this.storm = null;
      }
      
      public function assignWinList(param1:Array, param2:Dictionary) : void
      {
         var _loc4_:PBuilding = null;
         var _loc5_:Unit = null;
         var _loc6_:PMissionWin = null;
         var _loc7_:* = 0;
         if(this.mission)
         {
            for each(_loc6_ in this.mission.mi_win)
            {
               this.winList.push(new VOWinItem(_loc6_,_loc6_.mw_count));
            }
         }
         var _loc3_:uint = 1;
         for each(_loc4_ in param1)
         {
            if(_loc4_.building_spec.variance == PBuildingSpec.TOWNHALL)
            {
               _loc3_ = _loc4_.building_level;
               if(_loc3_ > 1 && _loc4_.building_build_state.variance == PBuildState.IN_PROGRESS)
               {
                  _loc3_--;
               }
               if(this.winList.length == 0)
               {
                  this.winList.push(new VOWinItem(PMissionWin.create(_loc4_.building_kind,_loc3_,1),1));
               }
               break;
            }
         }
         this.thLevel = _loc3_;
         for each(_loc5_ in param2)
         {
            _loc7_ = int(this.winList.length - 1);
            while(_loc7_ >= 0)
            {
               if(_loc5_.kind == (this.winList[_loc7_] as VOWinItem).info.mw_kind)
               {
                  _loc5_.setStatus(SkinManager.getEmbed("TargetStatus",VSkin.CACHE_AS_BITMAP));
               }
               _loc7_--;
            }
         }
      }
      
      public function checkWinList(param1:PUm, param2:SimData) : Boolean
      {
         var _loc4_:VOWinItem = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:PBuilding = null;
         var _loc8_:PCannon = null;
         var _loc9_:uint = 0;
         var _loc10_:str_Position = null;
         var _loc11_:uint = 0;
         var _loc12_:SimUnitT = null;
         var _loc13_:uint = 0;
         var _loc3_:uint = 0;
         for each(_loc4_ in this.winList)
         {
            _loc4_.count = _loc4_.info.mw_count;
            _loc5_ = true;
            _loc6_ = true;
            for each(_loc7_ in param1.buildings)
            {
               if(_loc7_.building_kind == _loc4_.info.mw_kind)
               {
                  _loc6_ = _loc5_ = false;
                  if(!param2.buildings[_loc7_.building_id])
                  {
                     --_loc4_.count;
                     if(_loc4_.count == 0)
                     {
                        break;
                     }
                  }
               }
            }
            if(_loc6_)
            {
               for each(_loc8_ in param1.cannons)
               {
                  if(_loc8_.cannon_kind == _loc4_.info.mw_kind)
                  {
                     _loc5_ = false;
                     if(!param2.cannons[_loc8_.cannon_id])
                     {
                        --_loc4_.count;
                        if(_loc4_.count == 0)
                        {
                           break;
                        }
                     }
                  }
               }
            }
            if(_loc5_ && (_loc4_.info.mw_kind.indexOf("boss") != -1 || _loc4_.info.mw_kind.indexOf("raid") != -1))
            {
               _loc9_ = 0;
               for each(_loc10_ in this.mission.mi_tunits)
               {
                  if(_loc10_.field_0 == _loc4_.info.mw_kind)
                  {
                     _loc9_++;
                  }
               }
               _loc11_ = 0;
               for each(_loc12_ in param2.units)
               {
                  if(_loc12_.kind == _loc4_.info.mw_kind)
                  {
                     _loc11_++;
                  }
               }
               _loc13_ = _loc9_ - _loc11_;
               _loc4_.count -= _loc13_ > _loc4_.count ? _loc4_.count : _loc13_;
            }
            _loc3_ += _loc4_.count;
         }
         this.isWin = _loc3_ == 0 && this.winList.length > 0;
         return this.isWin;
      }
      
      public function calcSteal(param1:PTargetInfo, param2:LinkedList) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:VOStorageSpec = null;
         var _loc11_:VOResourceSpec = null;
         if(param1.ti_fight_type.variance == PFightType.SINGLE)
         {
            _loc8_ = param1.ti_storage_fight_k * param1.ti_th_diff_k;
            _loc9_ = Facade.references.resource_fight_k * param1.ti_th_diff_k;
         }
         else
         {
            _loc8_ = _loc9_ = 1;
         }
         var _loc3_:uint = param1.ti_crystal * _loc8_;
         var _loc4_:uint = param1.ti_oil * _loc8_;
         this.crystal = _loc3_;
         this.oil = _loc4_;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Build = param2.head as Build;
         while(_loc7_)
         {
            if(_loc7_.type == PBtype.STORAGE)
            {
               _loc10_ = _loc7_.spec;
               if(_loc10_.costVariance == PCost.CRYSTAL)
               {
                  _loc5_ += _loc10_.capacityMax;
               }
               else if(_loc10_.costVariance == PCost.OIL)
               {
                  _loc6_ += _loc10_.capacityMax;
               }
            }
            _loc7_ = _loc7_.link_next as Build;
         }
         _loc7_ = param2.head as Build;
         while(_loc7_)
         {
            if(_loc7_.type == PBtype.STORAGE)
            {
               _loc10_ = _loc7_.spec;
               if(_loc10_.costVariance == PCost.CRYSTAL)
               {
                  _loc10_.capacityCur = _loc10_.capacityMax / _loc5_ * _loc3_;
               }
               else if(_loc10_.costVariance == PCost.OIL)
               {
                  _loc10_.capacityCur = _loc10_.capacityMax / _loc6_ * _loc4_;
               }
               _loc10_.capacityMax *= _loc8_;
            }
            else if(_loc7_.type == PBtype.RESOURCE)
            {
               _loc11_ = _loc7_.spec as VOResourceSpec;
               _loc11_.capacityCur *= _loc9_;
               _loc11_.capacityMax *= _loc9_;
               if(_loc11_.prodVariance == PCost.CRYSTAL)
               {
                  this.crystal += _loc11_.capacityCur;
               }
               else if(_loc11_.prodVariance == PCost.OIL)
               {
                  this.oil += _loc11_.capacityCur;
               }
            }
            _loc7_ = _loc7_.link_next as Build;
         }
      }
   }
}

