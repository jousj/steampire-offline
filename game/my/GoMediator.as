package game.my
{
   import engine.units.Build;
   import flash.events.MouseEvent;
   import game.common.DialogMediator;
   import game.feature.FeatureMediator;
   import game.quest.NewStoryDialog;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import logic.UnitFactory;
   import model.ui.VOBattleItem;
   import proto.model.PBtype;
   import proto.model.PCurrentAdventure;
   import proto.model.PExtMission;
   import proto.model.PJainaEvent;
   import proto.model.PJainaEventInfo;
   import proto.model.PRaidCooldown;
   import proto.model.PShopRaidCooldown;
   import proto.model.i_PJainaEvent;
   import ui.Style;
   import ui.common.BaseDialog;
   import ui.common.MessageDialog;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VEvent;
   import utils.StringHelper;
   
   public class GoMediator extends DialogMediator
   {
      
      public var dialog:GoDialog;
      
      private var isShowArmy:Boolean;
      
      private var armyDp:Array;
      
      private var armyCapacity:uint = 4294967295;
      
      public function GoMediator(param1:Boolean = true)
      {
         super();
         this.isShowArmy = param1;
         this.dialog = new GoDialog(Facade.references.enter_pvp_price,Facade.userProxy.getCustomData("boss_raid"));
      }
      
      public static function getActiveAdventure(param1:Boolean = true) : *
      {
         var _loc4_:PJainaEventInfo = null;
         var _loc5_:Number = NaN;
         var _loc6_:i_PJainaEvent = null;
         var _loc2_:Number = CoreLogic.serverTime;
         var _loc3_:PCurrentAdventure = Facade.userProxy.currentAdventure;
         if(_loc3_)
         {
            if(_loc2_ < _loc3_.start_time + Facade.references.adventure_duration)
            {
               return param1 ? [_loc3_.start_time + Facade.references.adventure_duration - _loc2_,Facade.manualProxy.getJainaEventInfo(_loc3_.event_id),PJainaEvent.create(_loc3_.mission_num,false,isNaN(_loc3_.alive_objs) ? Facade.manualProxy.getMissionInfoFromJaina(_loc3_.event_id,_loc3_.mission_num).mi_init_obj_cnt : int(_loc3_.alive_objs),1)] : _loc3_.event_id;
            }
            Facade.userProxy.currentAdventure = null;
         }
         var _loc7_:int = 0;
         var _loc8_:* = Facade.manualProxy.jainaEventList;
         while(true)
         {
            for each(_loc4_ in _loc8_)
            {
               if(_loc2_ >= _loc4_.jei_date_start && _loc2_ < _loc4_.jei_date_finish)
               {
                  _loc5_ = _loc4_.jei_date_finish - _loc2_;
                  if(_loc5_ > 0)
                  {
                     for each(_loc6_ in Facade.userProxy.jainaEventList)
                     {
                        if(_loc6_.field_0 == _loc4_.jei_id)
                        {
                           if(_loc6_.field_1.je_mission_finished && _loc6_.field_1.je_mission >= _loc4_.jei_missions_number)
                           {
                              _loc5_ = 0;
                           }
                           break;
                        }
                        _loc6_ = null;
                     }
                     if(_loc5_ > 0)
                     {
                        break;
                     }
                  }
               }
            }
            return param1 ? [0,null,null] : 0;
         }
         return param1 ? [_loc5_,_loc4_,_loc6_ ? _loc6_.field_1 : null] : _loc4_.jei_id;
      }
      
      public static function checkRaidArmy() : Boolean
      {
         var _loc1_:int = Math.ceil(Facade.references.raid_units_min_perc / 100 * Facade.userProxy.soldierCapacityMax) - Facade.userProxy.soldierCapacityCur;
         if(_loc1_ > 0)
         {
            showNoArmyDialog(Lang.getPatternString("raid_no_army","__VALUE__",StringHelper.getTLFImage("lib,ArmyCapacityIcon",22) + "<span" + Style.redColor + ">" + _loc1_ + "</span>"));
            return false;
         }
         return true;
      }
      
      public static function showNoArmyDialog(param1:String) : void
      {
         var _loc2_:MessageDialog = new MessageDialog(param1);
         var _loc3_:Build = Facade.userProxy.getBuild(PBtype.BARRACK,false);
         if(_loc3_)
         {
            _loc2_.addDelegateButton(RectButton.createIconAndTitle(SkinManager.getEmbed("BarrackIcon"),Lang.getString("barrackBt")),UnitFactory.buildLogic.goInsideBuild,[_loc3_]);
         }
         Facade.mainMediator.showDialog(_loc2_);
      }
      
      public static function showJainaProgressDialog() : void
      {
         var _loc3_:uint = 0;
         var _loc1_:Array = getActiveAdventure();
         var _loc2_:PJainaEvent = _loc1_[2] as PJainaEvent;
         if(Boolean(_loc2_) && Boolean(_loc2_.je_mission <= 3) && !_loc2_.je_mission_finished)
         {
            _loc3_ = uint(Facade.manualProxy.getMissionInfoFromJaina((_loc1_[1] as PJainaEventInfo).jei_id,_loc2_.je_mission).mi_init_obj_cnt);
            _loc3_ = (_loc3_ - _loc2_.je_alive_objs) / _loc3_ * 100;
            if(_loc3_ > 0)
            {
               DialogLogic.open(new NewStoryDialog("un_hero1",Lang.getPatternString("jaina_progress_story","__DAMAGE__",_loc3_.toString())));
            }
         }
      }
      
      public static function showAdventureLevelComplete(param1:int, param2:uint) : void
      {
         DialogLogic.open(new NewStoryDialog("un_hero1",Lang.getReplaceString("adventure_next_level",{
            "__TITLE__":"<span" + Style.darkKhakiColor + ">" + Lang.getString("adventure" + param1) + "</span>",
            "__LEVEL__":StringHelper.getRomanFromArab(param2)
         }),false));
      }
      
      override public function onAdd() : BaseDialog
      {
         this.dialog.missionBt.addClickListener(this.onPvE);
         this.dialog.pvpBt.addClickListener(this.onPvP);
         this.dialog.raidBt.addClickListener(this.onRaid);
         this.dialog.barrackBt.addClickListener(this.onArmy);
         if(up.getBuild(PBtype.LIBRARY,false))
         {
            this.dialog.addLibraryButton(this.onArmy);
         }
         if(this.isShowArmy)
         {
            this.onSyncArmy();
            this.dialog.visibleCallback = this.onSyncArmy;
         }
         this.syncData(null);
         this.dialog.addListener(VEvent.CHANGE,this.syncData);
         return this.dialog;
      }
      
      private function onPvE(param1:MouseEvent) : void
      {
         DialogLogic.toMissionMap();
      }
      
      private function onPvP(param1:MouseEvent) : void
      {
         Facade.myMediator.startSearchPvP();
      }
      
      private function onRaid(param1:MouseEvent) : void
      {
         Facade.myMediator.toPortal();
      }
      
      private function onArmy(param1:MouseEvent) : void
      {
         UnitFactory.buildLogic.goInsideBuild(up.getBuild(param1.currentTarget == this.dialog.barrackBt ? PBtype.BARRACK : PBtype.LIBRARY,false));
      }
      
      private function syncData(param1:VEvent) : void
      {
         var _loc7_:PShopRaidCooldown = null;
         var _loc8_:PExtMission = null;
         var _loc9_:Boolean = false;
         var _loc10_:Array = null;
         var _loc11_:Number = NaN;
         var _loc12_:PRaidCooldown = null;
         if(param1)
         {
            Facade.myMediator.syncAdventureButton();
         }
         var _loc2_:Number = CoreLogic.serverTime;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Number = Number.MAX_VALUE;
         var _loc6_:Number = -1;
         for each(_loc7_ in mp.raidShopList)
         {
            if(_loc7_.src_kind == "rd_bosses")
            {
               _loc6_ = 0;
               for each(_loc12_ in up.raidMissionList)
               {
                  if(_loc12_.rc_raid_kind == _loc7_.src_kind)
                  {
                     if(_loc12_.rc_end_time > _loc2_)
                     {
                        _loc6_ = _loc12_.rc_end_time;
                     }
                     break;
                  }
               }
               break;
            }
            if(_loc7_.src_kind != "rd_walls")
            {
               _loc4_++;
               _loc11_ = -1;
               for each(_loc12_ in up.raidMissionList)
               {
                  if(_loc12_.rc_raid_kind == _loc7_.src_kind)
                  {
                     if(_loc12_.rc_end_time > _loc2_)
                     {
                        _loc11_ = _loc12_.rc_end_time;
                     }
                     break;
                  }
               }
               if(_loc11_ > 0)
               {
                  if(_loc11_ < _loc5_)
                  {
                     _loc5_ = _loc11_;
                  }
               }
               else
               {
                  _loc3_++;
               }
            }
         }
         if(_loc6_ >= 0)
         {
            this.dialog.setRaidHeroData(_loc6_);
         }
         else if(_loc3_ > 0)
         {
            this.dialog.setRaidData(_loc3_,_loc4_);
         }
         else
         {
            this.dialog.setRaidData(_loc5_ - _loc2_,0);
         }
         _loc3_ = 0;
         _loc5_ = Number.MAX_VALUE;
         for each(_loc8_ in up.extMissionList)
         {
            _loc11_ = _loc8_.em_last_time + Facade.manualProxy.getMissionInfo(_loc8_.em_kind).mi_cooldown;
            if(_loc2_ >= _loc11_)
            {
               _loc3_++;
            }
            else if(_loc11_ < _loc5_)
            {
               _loc5_ = _loc11_;
            }
         }
         _loc9_ = _loc3_ > 0 || _loc5_ == Number.MAX_VALUE;
         _loc10_ = getActiveAdventure();
         this.dialog.setMissionData(_loc9_ ? _loc3_ : _loc5_ - _loc2_,!_loc9_,_loc10_[0],Boolean(_loc10_[2]) && (_loc10_[2] as PJainaEvent).je_mission == 1 && !(_loc10_[2] as PJainaEvent).je_mission_finished,Facade.myMediator.onAdventure,_loc10_[1] ? uint((_loc10_[1] as PJainaEventInfo).jei_id) : 1,Boolean(up.currentAdventure));
      }
      
      private function onSyncArmy() : void
      {
         var _loc3_:VOBattleItem = null;
         var _loc1_:Boolean = this.armyCapacity != up.soldierCapacityCur;
         var _loc2_:uint = 0;
         if(!_loc1_ && Boolean(this.armyDp))
         {
            for each(_loc3_ in this.armyDp)
            {
               if(_loc3_.shop)
               {
                  if(_loc3_.count != up.soldierCountHash[_loc3_.shop.su_kind])
                  {
                     _loc1_ = true;
                     break;
                  }
               }
               else
               {
                  _loc2_++;
                  if(up.spellList.indexOf(_loc3_.spellShop.ssp_kind) < 0)
                  {
                     _loc1_ = true;
                     break;
                  }
               }
            }
         }
         if(!_loc1_ && _loc2_ != up.spellList.length)
         {
            _loc1_ = true;
         }
         if(_loc1_)
         {
            this.armyDp = FeatureMediator.getMySoldierDp(true);
            this.armyCapacity = up.soldierCapacityCur;
            if(this.armyDp)
            {
               this.dialog.showArmy(this.armyDp,this.armyCapacity + "/" + up.soldierCapacityMax);
            }
            else
            {
               this.dialog.showEmptyArmy();
            }
         }
      }
   }
}

