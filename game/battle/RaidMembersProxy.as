package game.battle
{
   import logic.ErrorLogic;
   import model.ManualProxy;
   import model.ui.VOBattleItem;
   import model.vo.VORaidMember;
   import proto.model.PGroupUnitsInfo;
   import proto.model.PKindCount;
   import proto.model.PUnitsLevel;
   import proto.model.PUserBase;
   
   public class RaidMembersProxy
   {
      
      public const list:Array = [];
      
      public function RaidMembersProxy()
      {
         super();
      }
      
      public function get length() : uint
      {
         return this.list.length;
      }
      
      private function syncUnitLevels(param1:Array, param2:Array) : void
      {
         var _loc3_:PUserBase = null;
         var _loc4_:PGroupUnitsInfo = null;
         for each(_loc3_ in param1)
         {
            for each(_loc4_ in param2)
            {
               if(_loc4_.gui_user_id == _loc3_.user_id)
               {
                  _loc3_.units_levels = _loc4_.gui_units_levels;
                  _loc3_.heroes = _loc4_.giu_heroes;
                  _loc3_.units.length = 0;
                  _loc3_.exp = -1;
                  break;
               }
            }
         }
      }
      
      public function assignUserBaseList(param1:Array, param2:Array = null, param3:Boolean = false) : void
      {
         var _loc6_:VORaidMember = null;
         if(Boolean(param2) && param2.length > 0)
         {
            this.syncUnitLevels(param1,param2);
         }
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = this.create(param1[_loc5_],0,param3);
            if(_loc6_.id == Preloader.uid)
            {
               this.list.unshift(_loc6_);
               _loc4_ = true;
            }
            else
            {
               this.list.push(_loc6_);
            }
            _loc5_++;
         }
         _loc5_ = _loc4_ ? 1 : 2;
         for each(_loc6_ in this.list)
         {
            _loc6_.num = _loc5_;
            _loc5_++;
         }
      }
      
      private function create(param1:PUserBase, param2:uint = 0, param3:Boolean = false) : VORaidMember
      {
         var _loc4_:VORaidMember = null;
         var _loc5_:PUnitsLevel = null;
         var _loc6_:ManualProxy = null;
         var _loc7_:PKindCount = null;
         var _loc8_:VOBattleItem = null;
         _loc4_ = new VORaidMember();
         _loc4_.assign(param1,param2);
         for each(_loc5_ in param1.units_levels)
         {
            _loc4_.soldierLevelHash[_loc5_.ul_kind] = _loc5_.ul_level;
         }
         _loc6_ = Facade.manualProxy;
         for each(_loc7_ in param1.units)
         {
            if(_loc7_.count != 0)
            {
               _loc8_ = new VOBattleItem();
               if(_loc7_.kind.indexOf("sp_") == 0)
               {
                  _loc8_.spellShop = _loc6_.getSpellShop(_loc7_.kind,_loc4_.soldierLevelHash[_loc7_.kind]);
                  _loc4_.spellCount += _loc7_.count;
               }
               else
               {
                  if(param3 && _loc7_.kind != "un_hero")
                  {
                     continue;
                  }
                  _loc8_.shop = _loc6_.getSoldierShop(_loc7_.kind,_loc4_.soldierLevelHash[_loc7_.kind]);
                  _loc4_.soldierCount += _loc7_.count;
               }
               _loc8_.count = _loc7_.count;
               _loc4_.soldierDp.push(_loc8_);
            }
         }
         _loc4_.soldierDp.sort(VOBattleItem.sort);
         _loc4_.heroList = param1.heroes;
         _loc4_.maxCapacity = _loc4_.capacity;
         return _loc4_;
      }
      
      public function add(param1:PUserBase, param2:uint = 0, param3:Boolean = false, param4:Boolean = false) : void
      {
         this.list.splice(param3 ? 0 : this.list.length,0,this.create(param1,param2,param4));
      }
      
      public function remove(param1:String) : Boolean
      {
         var _loc2_:* = int(this.length - 1);
         while(_loc2_ >= 0)
         {
            if((this.list[_loc2_] as VORaidMember).id == param1)
            {
               this.list.splice(_loc2_,1);
               return true;
            }
            _loc2_--;
         }
         return false;
      }
      
      public function getById(param1:String) : VORaidMember
      {
         var _loc2_:VORaidMember = null;
         for each(_loc2_ in this.list)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function resultSort(param1:VORaidMember, param2:VORaidMember) : Number
      {
         return param1.losing == param2.losing ? param2.dropCapacity - param1.dropCapacity : (param1.losing ? 1 : -1);
      }
      
      public function get isOneOrAllBots() : Boolean
      {
         var _loc1_:* = int(this.list.length - 1);
         while(_loc1_ >= 1)
         {
            if(!(this.list[_loc1_] as VORaidMember).isBot)
            {
               return false;
            }
            _loc1_--;
         }
         return true;
      }
      
      public function removeSoldier(param1:uint, param2:Boolean) : Boolean
      {
         var _loc4_:VORaidMember = null;
         var _loc3_:Boolean = false;
         for each(_loc4_ in this.list)
         {
            if(_loc4_.num == param1)
            {
               --_loc4_.soldierBattleCount;
            }
            if(!_loc3_)
            {
               if(_loc4_.soldierBattleCount > 0 || param2 && _loc4_.soldierCount > 0)
               {
                  _loc3_ = true;
               }
            }
         }
         return _loc3_;
      }
      
      public function sendLog(param1:String, param2:int, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:VORaidMember = null;
         param1 += " list:";
         for each(_loc5_ in this.list)
         {
            param1 += _loc5_.id + ", ";
         }
         param1 += " lastSimTime=" + param2 + " isStorm=" + param3 + " isTerritoryStorm=" + param4;
         ErrorLogic.sendError(param1);
      }
   }
}

