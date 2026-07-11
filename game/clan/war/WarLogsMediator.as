package game.clan.war
{
   import game.common.DialogMediator;
   import model.ManualProxy;
   import proto.BinaryBuffer;
   import proto.game.family_0060.Packet_0060_29;
   import proto.game.family_0060.Packet_0060_2A;
   import proto.model.PShopUnit;
   import proto.model.PUserClan;
   import proto.model.PWarTop;
   import proto.model.clan.PWar;
   import proto.model.clan.PWarLog;
   import proto.model.clan.PWarLogKind;
   import proto.tuples.str_i;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   
   public class WarLogsMediator extends DialogMediator
   {
      
      public const dialog:WarLogsDialog = new WarLogsDialog();
      
      private var isAttacker:Boolean;
      
      private var item:PWarTop;
      
      private var clan:PUserClan;
      
      private var war:PWar;
      
      public function WarLogsMediator(param1:Boolean, param2:PWarTop = null)
      {
         super();
         this.isAttacker = param1;
         this.item = param2;
      }
      
      override public function onAdd() : BaseDialog
      {
         if(this.item)
         {
            ClanWarPanel.addVs(this.dialog.panel,this.item.wt_attacker.wti_name,this.item.wt_attacker.wti_icon,null,this.item.wt_target.wti_name,this.item.wt_target.wti_icon,null,0);
         }
         else
         {
            this.clan = Facade.userProxy.clan;
            this.war = Facade.userProxy.clanData.war;
            ClanWarPanel.addVs(this.dialog.panel,this.clan.uc_name,this.clan.uc_icon,null,this.war.war_enemy_name,this.war.war_enemy_icon,null,this.war.war_start_time);
         }
         this.dialog.init();
         this.dialog.addListener(VEvent.VARIANCE,this.load);
         this.load(null);
         return this.dialog;
      }
      
      private function load(param1:VEvent) : void
      {
         var _loc2_:String = null;
         if(param1)
         {
            this.isAttacker = !this.isAttacker;
         }
         if(this.item)
         {
            if(this.isAttacker)
            {
               this.dialog.setClanType(true,this.item.wt_attacker.wti_name,[this.item,false]);
               _loc2_ = this.item.wt_attacker.wti_id;
            }
            else
            {
               this.dialog.setClanType(false,this.item.wt_target.wti_name,[this.item,true]);
               _loc2_ = this.item.wt_target.wti_id;
            }
         }
         else if(this.isAttacker)
         {
            this.dialog.setClanType(true,this.clan.uc_name);
            _loc2_ = this.clan.uc_clan_id;
         }
         else
         {
            this.dialog.setClanType(false,this.war.war_enemy_name);
            _loc2_ = this.war.war_enemy;
         }
         this.dialog.assign("load_title");
         Facade.protoProxy.request(new Packet_0060_29(_loc2_),this.resultWarLogDp,96,42,[this.isAttacker]);
      }
      
      private function resultWarLogDp(param1:BinaryBuffer, param2:uint) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:PWarLog = null;
         var _loc6_:uint = 0;
         if(Boolean(this.dialog.parent) && param2 == this.isAttacker)
         {
            _loc3_ = new Packet_0060_2A(param1).value;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               _loc6_ = _loc5_.wl_kind.variance;
               if(_loc6_ == PWarLogKind.USE_UNIT || _loc6_ == PWarLogKind.USE_SPELL)
               {
                  _loc5_.wl_kind.value = this.aggregateStormAttack(_loc3_,_loc4_,_loc5_);
               }
               else if(_loc6_ == PWarLogKind.USE_WORKER)
               {
                  _loc5_.wl_kind.value = this.aggregateStormDefence(_loc3_,_loc4_,_loc5_);
               }
               _loc4_++;
            }
            if(_loc3_.length == 0)
            {
               this.dialog.assign("war_logs_empty");
            }
            else
            {
               this.dialog.assign(null,_loc3_);
            }
         }
      }
      
      private function aggregateStormAttack(param1:Array, param2:int, param3:PWarLog) : Array
      {
         var _loc9_:PWarLog = null;
         var _loc10_:uint = 0;
         var _loc11_:str_i = null;
         var _loc12_:PShopUnit = null;
         var _loc4_:ManualProxy = Facade.manualProxy;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = int(param1.length - 1);
         for(; _loc8_ >= param2; _loc8_--)
         {
            _loc9_ = param1[_loc8_];
            if(param3.wl_time == _loc9_.wl_time && param3.wl_user_id == _loc9_.wl_user_id)
            {
               _loc10_ = _loc9_.wl_kind.variance;
               if(_loc10_ == PWarLogKind.USE_UNIT)
               {
                  _loc11_ = _loc9_.wl_kind.value;
                  _loc12_ = _loc4_.getSoldierShop(_loc11_.field_0,1);
                  _loc11_.field_1 *= _loc12_.su_hspace;
                  if(_loc12_.su_is_clan)
                  {
                     _loc6_ += _loc11_.field_1;
                  }
                  else
                  {
                     _loc5_ += _loc11_.field_1;
                  }
               }
               else
               {
                  if(_loc10_ != PWarLogKind.USE_SPELL)
                  {
                     continue;
                  }
                  _loc7_ += (_loc9_.wl_kind.value as str_i).field_1;
               }
               if(_loc8_ != param2)
               {
                  param1.splice(_loc8_,1);
               }
            }
         }
         return [_loc5_,_loc6_,_loc7_];
      }
      
      private function aggregateStormDefence(param1:Array, param2:int, param3:PWarLog) : Array
      {
         var _loc6_:PWarLog = null;
         var _loc4_:Array = [];
         var _loc5_:* = int(param1.length - 1);
         while(_loc5_ >= param2)
         {
            _loc6_ = param1[_loc5_];
            if(param3.wl_time == _loc6_.wl_time && param3.wl_user_id == _loc6_.wl_user_id)
            {
               if(_loc6_.wl_kind.variance == PWarLogKind.USE_WORKER)
               {
                  _loc4_.push(_loc6_.wl_kind.value);
                  if(_loc5_ != param2)
                  {
                     param1.splice(_loc5_,1);
                  }
               }
            }
            _loc5_--;
         }
         return _loc4_;
      }
   }
}

