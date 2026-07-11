package game.portal
{
   import engine.units.Build;
   import game.common.DialogMediator;
   import game.my.GoMediator;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.MainLogic;
   import logic.ShopLogic;
   import model.ui.VOPortalItem;
   import model.vo.MapAction;
   import proto.game.family_0010.PCreateRaid;
   import proto.game.family_0010.PFightKind;
   import proto.game.family_0010.PUserAction;
   import proto.model.PBtype;
   import proto.model.PCost;
   import proto.model.PRaidCooldown;
   import proto.model.PShopHero;
   import proto.model.PShopRaidCooldown;
   import ui.common.BaseDialog;
   import ui.vbase.SkinManager;
   import ui.vbase.VEvent;
   
   public class PortalMediator extends DialogMediator
   {
      
      public var dialog:PortalDialog;
      
      public function PortalMediator()
      {
         super();
      }
      
      public static function getRaidReward(param1:String, param2:Object, param3:Number = 1) : Array
      {
         var _loc4_:PShopRaidCooldown = null;
         var _loc5_:uint = 0;
         for each(_loc4_ in Facade.manualProxy.raidShopList)
         {
            if(_loc4_.src_kind == param1)
            {
               break;
            }
         }
         _loc5_ = uint(param2["un_hero"]);
         if(_loc5_ == 0)
         {
            _loc5_ = 1;
         }
         return getPortalReward(Facade.manualProxy.getHeroShop("un_hero",_loc5_,true),_loc4_,param3);
      }
      
      public static function getPortalReward(param1:PShopHero, param2:PShopRaidCooldown, param3:Number = 1) : Array
      {
         var _loc5_:PCost = null;
         var _loc6_:Number = NaN;
         var _loc4_:Array = [];
         if(!param1)
         {
            return _loc4_;
         }
         for each(_loc5_ in param1.sh_raid_reward)
         {
            _loc5_ = PCost.create(_loc5_.variance,_loc5_.value);
            switch(_loc5_.variance)
            {
               case PCost.GREEN_ORE:
                  _loc6_ = param2.src_greenore_k;
                  break;
               case PCost.H_GLORY:
                  _loc6_ = param2.src_hglory_k;
                  break;
               default:
                  _loc6_ = 1;
            }
            _loc5_.value = Math.round(_loc5_.value * _loc6_ * param3);
            _loc4_.push(_loc5_);
         }
         _loc4_.push(PCost.create(PCost.CLAN_POINTS,param2.src_kind == "rd_bosses" ? Facade.references.hero_raid_win : Facade.references.raid_win));
         return _loc4_;
      }
      
      override public function onAdd() : BaseDialog
      {
         var _loc6_:PShopRaidCooldown = null;
         var _loc7_:Number = NaN;
         var _loc8_:PRaidCooldown = null;
         var _loc9_:VOPortalItem = null;
         var _loc1_:Array = [];
         var _loc2_:Number = CoreLogic.serverTime;
         var _loc3_:Boolean = up.radarEnabled;
         var _loc4_:uint = uint(up.soldierLevelHash["un_hero"]);
         if(_loc4_ == 0)
         {
            _loc4_ = 1;
         }
         var _loc5_:PShopHero = mp.getHeroShop("un_hero",_loc4_,true);
         for each(_loc6_ in mp.raidShopList)
         {
            if(!(_loc6_.src_kind == "rd_walls" && !up.getBuild(PBtype.RAID,true,2) || _loc6_.src_kind == "rd_camp"))
            {
               _loc7_ = -1;
               for each(_loc8_ in up.raidMissionList)
               {
                  if(_loc8_.rc_raid_kind == _loc6_.src_kind)
                  {
                     if(_loc8_.rc_end_time > _loc2_)
                     {
                        _loc7_ = _loc8_.rc_end_time;
                     }
                     break;
                  }
               }
               _loc9_ = new VOPortalItem(_loc6_.src_kind,_loc3_ ? Math.ceil(_loc6_.src_time / 2) : _loc6_.src_time,getPortalReward(_loc5_,_loc6_),up.radarEnabled,_loc7_,_loc6_.src_kind == "rd_bosses" && !up.getCustomData("boss_raid"));
               if(_loc9_.kind == "rd_bosses")
               {
                  _loc9_.prize.unshift(PCost.create(PCost.BLUE_PRINT,1));
                  _loc9_.prize.push(PCost.create(PCost.UNKNOWN,"hero_raid_reward_hint"));
               }
               _loc1_.push(_loc9_);
            }
         }
         _loc1_.sort(this.sort);
         this.dialog = new PortalDialog(_loc1_);
         this.dialog.gloryPanel.useTrack();
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         return this.dialog;
      }
      
      private function sort(param1:VOPortalItem, param2:VOPortalItem) : Number
      {
         if(param1.endTime == param2.endTime)
         {
            return param2.kind == "rd_bosses" ? 1 : (param1.kind == "rd_bosses" ? -1 : param1.duration - param2.duration);
         }
         return param1.endTime - param2.endTime;
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:VOPortalItem = null;
         var _loc3_:Number = NaN;
         var _loc4_:Build = null;
         var _loc5_:MapAction = null;
         _loc2_ = param1.data as VOPortalItem;
         switch(param1.variance)
         {
            case 0:
               if(_loc2_.kind == "rd_bosses")
               {
                  _loc4_ = up.getBuildEx("bl_hero_workshop",false);
                  if(_loc4_)
                  {
                     _loc5_ = CoreLogic.getAction(ActionLogic.RECOVERY_HERO,_loc4_.id);
                     if(_loc5_)
                     {
                        ShopLogic.showActionSpeedupDialog(_loc4_,ActionLogic.RECOVERY_HERO,Lang.getString("hero_raid_speedup_title"),MainLogic.getRivalMap,[PFightKind.create(PFightKind.RAID,PCreateRaid.create(_loc2_.kind,this.dialog.friendsCb.checked))]);
                        break;
                     }
                     MainLogic.getRivalMap(PFightKind.create(PFightKind.RAID,PCreateRaid.create(_loc2_.kind,this.dialog.friendsCb.checked)));
                  }
                  break;
               }
               if(GoMediator.checkRaidArmy())
               {
                  if(Facade.checkUserStage("buildPortal_get_reward"))
                  {
                     Facade.changeUserStage("tryRaid1_group_search");
                  }
                  MainLogic.getRivalMap(PFightKind.create(PFightKind.RAID,PCreateRaid.create(_loc2_.kind,this.dialog.friendsCb.checked)));
               }
               break;
            case 1:
               _loc3_ = _loc2_.endTime - CoreLogic.serverTime;
               ShopLogic.showSpeedupDialog(Lang.getPatternString("raid_speedup_prompt","__TITLE__",_loc2_.kind,true),_loc3_,this.confirmSpeedup,[_loc2_],SkinManager.getEmbed("PortalIcon"),1);
               break;
            case 100:
               this.dialog.grid.getDataProvider().sort(this.sort);
               this.dialog.grid.sync();
         }
      }
      
      private function confirmSpeedup(param1:VOPortalItem) : void
      {
         var _loc2_:PCost = ShopLogic.getSpeedupCost(param1.endTime - CoreLogic.serverTime,1);
         if(ShopLogic.checkPrice(_loc2_))
         {
            ShopLogic.applyCost(_loc2_,true);
            param1.endTime = -1;
            this.dialog.grid.sync();
            ActionLogic.request(PUserAction.SPEED_UP_RAID,param1.kind);
         }
      }
   }
}

