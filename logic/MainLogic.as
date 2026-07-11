package logic
{
   import engine.Isometric;
   import engine.display.AnimClip;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Garbage;
   import engine.units.ZObject;
   import flash.display.Loader;
   import game.barrack.BarrackMediator;
   import game.battle.BattleMediator;
   import game.board.BoardMediator;
   import game.capital.CapitalMediator;
   import game.common.MainMediator;
   import game.my.GoMediator;
   import game.my.MyMediator;
   import game.offer.OfferHalloween;
   import game.offer.OfferOk;
   import game.portal.StartRaidMediator;
   import game.quest.QuestMediator;
   import logic.training.AbstractTrain;
   import logic.units.BuildLogic;
   import logic.units.CannonLogic;
   import model.ManualProxy;
   import model.QuestProxy;
   import model.UserProxy;
   import model.vo.VOGuardSpec;
   import model.vo.VOResourceSpec;
   import model.vo.VOShieldSpec;
   import model.vo.VOStorageSpec;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.game.family_0002.Packet_0002_01;
   import proto.game.family_0002.Packet_0002_02;
   import proto.game.family_0005.Packet_0005_01;
   import proto.game.family_0005.Packet_0005_02;
   import proto.game.family_0010.PCreateRaid;
   import proto.game.family_0010.PFightKind;
   import proto.game.family_0010.Packet_0010_03;
   import proto.game.family_0010.Packet_0010_04;
   import proto.game.family_0010.Packet_0010_05;
   import proto.game.family_0010.Packet_0010_06;
   import proto.game.family_0050.PReplay;
   import proto.game.family_0050.Packet_0050_05;
   import proto.game.family_0050.Packet_0050_06;
   import proto.game.family_0060.Packet_0060_19;
   import proto.game.family_0060.Packet_0060_1A;
   import proto.game.family_0060.Packet_0060_1F;
   import proto.model.*;
   import proto.model.clan.PCapital;
   import proto.tuples.i_i;
   import ui.common.BaseDialog;
   import ui.common.MessageDialog;
   import ui.load.StartupLoadPanel;
   import ui.load.WaitAttackPanel;
   import ui.load.WaitSimulationPanel;
   import ui.vbase.VEvent;
   import ui.vbase.VLabel;
   import utils.GameLocalConnection;
   
   public class MainLogic
   {
      
      public function MainLogic()
      {
         super();
      }
      
      public static function run(param1:Loader) : void
      {
         Isometric.init(65,46,Math.PI / 4,Math.PI / 4);
         ZObject.init(Facade.board);
         CoreLogic.init(Facade.board);
         Facade.boardMediator = new BoardMediator(param1,Facade.mainPanel.layerPanel);
         Facade.audioProxy.init();
         Facade.myMediator = new MyMediator();
         Facade.questMediator = new QuestMediator(Facade.myMediator.myPanel.questBtPanel);
         Facade.battleMediator = new BattleMediator();
         Facade.mainMediator = new MainMediator();
         Facade.addJSCallback("syncEvents",EventLogic.sync);
         SocialLogic.init();
         if(Facade.socialnet == Facade.FACEBOOK)
         {
            Facade.addJSCallback("callBackPriceInfo",ShopLogic.callBackPriceInfoFB);
            Facade.addJSCallback("showRequests",Facade.myMediator.showRequests);
            Facade.addJSCallback("showMoneyDialog",Facade.myMediator.onGoldBuy);
         }
         Facade.changeUserStage("t_player_loaded");
         GameLocalConnection.instance.resume();
         var _loc2_:StartupLoadPanel = Facade.mainPanel.loadPanel as StartupLoadPanel;
         if(_loc2_)
         {
            _loc2_.pb.value = 1;
            _loc2_.valueText.value = "8/8: " + Lang.getString("last_step_fload");
         }
         getDict();
      }
      
      public static function getDict() : void
      {
         Facade.protoProxy.request(new Packet_0005_01(),resultDict,5,2,null,"getDict");
      }
      
      private static function resultDict(param1:BinaryBuffer) : void
      {
         var _loc2_:Packet_0005_02 = new Packet_0005_02(param1);
         var _loc3_:PDict = _loc2_.dict;
         var _loc4_:PUser = _loc2_.me;
         var _loc5_:UserProxy = Facade.userProxy;
         _loc5_.base = _loc4_.base;
         _loc5_.oil = _loc4_.oil;
         _loc5_.crystal = _loc4_.crystal;
         _loc5_.customData = _loc4_.client_custom_data;
         _loc5_.winMissionList = _loc4_.win_missions;
         _loc5_.extMissionList = _loc4_.ext_missions;
         Facade.userStage = _loc4_.stage;
         if(!Facade.references)
         {
            Preloader.uid = _loc4_.base.user_id;
            Facade.references = _loc3_.references;
            Preloader.userStageList = _loc3_.stages;
            Facade.manualProxy.assignDict(_loc3_);
            Facade.questProxy.questDict = _loc3_.quests;
            Cannon.init(_loc3_.cannons_info);
            Facade.setNormalQuality(!_loc4_.settings_game.sg_low_quality);
            Facade.myMediator.changeZoom(_loc4_.settings_game.sg_scale / 100);
            if(Facade.socialnet == Facade.FACEBOOK)
            {
               Facade.useHideJS("getPriceInfo");
            }
            Facade.changeUserStage("t_dict_loaded");
            Facade.gameStream.init(Preloader.uid,Facade.stage.loaderInfo.parameters);
         }
         _loc5_.clan = _loc4_.base.clan;
         checkTrainMission();
      }
      
      public static function checkTrainMission() : void
      {
         if(Facade.checkUserStage("m2_win_dialog"))
         {
            getMyMap();
         }
         else if(Facade.checkUserStage("map3_mission2_attack_click"))
         {
            getFriendMap("ms_mission2",true,false,4);
         }
         else if(Facade.checkUserStage("boss_ruby_shop_free"))
         {
            getMyMap();
         }
         else if(Facade.checkUserStage("home1_jaina5_click"))
         {
            getFriendMap(Preloader.uid,false,false,3);
         }
         else if(Facade.checkUserStage("m1_fireball_use1"))
         {
            getMyMap();
         }
         else if(Facade.checkUserStage("map1_ms1_click"))
         {
            getFriendMap(Preloader.uid,false,false,2);
         }
         else
         {
            getFriendMap("ms_mission0",true,false,1);
         }
      }
      
      public static function free(param1:Boolean = true, param2:String = null, param3:Boolean = false) : void
      {
         if(param1)
         {
            Facade.mainPanel.showLoadPanel(param2);
         }
         Facade.gameStream.clear();
         CoreLogic.stop();
         AbstractTrain.clear();
         Facade.audioProxy.clear(param3);
         if(param3)
         {
            Facade.protoProxy.clear();
         }
         Facade.mainMediator.clear();
         Facade.questMediator.clear();
         Facade.myMediator.clear();
         Facade.battleMediator.clear();
         Facade.boardMediator.clear();
         if(Facade.destructionMediator)
         {
            Facade.destructionMediator.free();
         }
         UnitFactory.clear();
         Facade.userProxy.clear();
         Facade.map.reset();
         Facade.manualProxy.clear();
         if(Facade.isCapital)
         {
            Facade.isCapital = false;
            CapitalMediator.clear();
         }
         Facade.isBattle = Facade.isMyMap = false;
      }
      
      public static function getMyMap(param1:Function = null, param2:Array = null) : void
      {
         free();
         if(param1 != null)
         {
            param2 = [param1,param2];
            param1 = resultMyMap;
         }
         else
         {
            param1 = resultMap;
         }
         Facade.protoProxy.request(new Packet_0002_01(Packet_0002_01.GET_LOCATION,null),param1,2,2,param2,"getMyMap");
      }
      
      private static function resultMyMap(param1:BinaryBuffer, param2:Function, param3:Array) : void
      {
         resultMap(param1);
         param2.apply(null,param3);
      }
      
      public static function getFriendMap(param1:String, param2:Boolean = false, param3:Boolean = false, param4:uint = 0) : void
      {
         free();
         Facade.protoProxy.request(new Packet_0010_05(param1,param2),resultMap,16,6,[param4,param3 ? 1 : 0],"getFriendMap " + param1);
      }
      
      public static function getCapitalMap(param1:String = null) : void
      {
         free(true,Lang.getString("clan_base"));
         Facade.protoProxy.request(param1 ? new Packet_0060_1F(param1) : new Packet_0060_19(),resultMap,96,26,null,"getCapital " + param1);
      }
      
      public static function getStorm(param1:Boolean) : void
      {
         free(true,Lang.getString(param1 ? "war_log_storm" : "war_log_worker"));
         Facade.protoProxy.request(new Packet_0002_01(Packet_0002_01.ENTER_STORM,param1),resultMap,2,2,null,"getStorm");
      }
      
      public static function getWatchStorm(param1:String) : void
      {
         free(true,Lang.getString("watch_storm_mobile"));
         Facade.protoProxy.request(new Packet_0002_01(Packet_0002_01.WATCH_STORM,param1),resultMap,2,2,[0,uint.MAX_VALUE],"getWatchStorm");
      }
      
      public static function getTerritoryStorm(param1:String) : void
      {
         free(true,Lang.getString("territory_storm"));
         Facade.protoProxy.request(new Packet_0002_01(Packet_0002_01.TO_TERRITORY_STORM,param1),resultMap,2,2,null,"getTerritoryStorm");
      }
      
      public static function checkArmy() : Boolean
      {
         var _loc1_:uint = 0;
         for each(_loc1_ in Facade.userProxy.soldierCountHash)
         {
            if(_loc1_ > 0)
            {
               return true;
            }
         }
         GoMediator.showNoArmyDialog(Lang.getString("not_army"));
         return false;
      }
      
      public static function getRivalMap(param1:Object, param2:Boolean = true, param3:Function = null) : void
      {
         var _loc4_:PFightKind = null;
         if(param2 && !checkArmy())
         {
            return;
         }
         if(Facade.userProxy.restartTime > 0 && Facade.userProxy.restartTime - CoreLogic.serverTime < 200)
         {
            Facade.mainMediator.showMessage(Lang.getString("restart_lock"));
            return;
         }
         if(param3 == null)
         {
            free(false);
            param3 = resultMap;
         }
         if(param1 is PFightKind)
         {
            _loc4_ = param1 as PFightKind;
            Facade.mainPanel.showLoadPanel(Lang.getString(_loc4_.variance == PFightKind.RAID ? "raid_title" : _loc4_.value));
            Facade.protoProxy.request(new Packet_0010_03(_loc4_),param3,0,0,[0,_loc4_.variance],_loc4_.variance == PFightKind.RAID ? "getRaid " + (_loc4_.value as PCreateRaid).cr_kind : "getMission " + _loc4_.value);
         }
         else
         {
            Facade.mainPanel.showLoadPanel(Lang.getString("search_clan_enemy"));
            Facade.protoProxy.request(new Packet_0002_01(Packet_0002_01.GET_TARGET,param1 as PFightKind2),param3,2,2,[0,(param1 as PFightKind2).variance],"getPvP");
         }
      }
      
      public static function getReplay(param1:String) : void
      {
         free();
         Facade.protoProxy.request(new Packet_0050_05(param1),resultMap,80,6,null,"getReplay " + param1);
      }
      
      public static function applyMapBuffer(param1:BinaryBuffer, param2:uint = 0) : void
      {
         free();
         param1.position = 0;
         resultMap(param1,0,param2);
      }
      
      public static function requestMap(param1:IClientPacket, param2:Array = null) : void
      {
         free();
         Facade.protoProxy.request(param1,resultMap,0,0,param2);
      }
      
      private static function checkPolitic() : void
      {
         var dlg:BaseDialog = null;
         if(Facade.socialnet == Facade.FACEBOOK && Facade.userProxy.getCustomData("facebook_political") != "true")
         {
            if(!Facade.checkUserStage("home4_hero_click"))
            {
               Facade.userProxy.setCustomData("facebook_political","true22");
            }
            else
            {
               dlg = Facade.mainMediator.showMessage(Lang.getString("facebook_political_message"),Lang.getString("attention"),null,MessageDialog.HIDE_CLOSE_BUTTON | MessageDialog.ADD_OK_BUTTON,Lang.getString("accept"));
               (dlg as MessageDialog).box.add(new VLabel("<div><a href=\"http://hospital.redspell.ru/privacy.html\">" + Lang.getString("facebook_political_link") + "</a></div><div></div>",VLabel.MIDDLE | VLabel.LEADING_BOX),null,1);
               dlg.addEventListener(VEvent.CLOSE_DIALOG,function(param1:VEvent):void
               {
                  Facade.userProxy.setCustomData("facebook_political","true");
               });
            }
         }
      }
      
      private static function resultMap(param1:BinaryBuffer, param2:uint = 0, param3:uint = 0) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:PCurrentFight = null;
         var _loc6_:PTargetInfo = null;
         var _loc7_:PUm = null;
         var _loc8_:Object = null;
         var _loc9_:Boolean = false;
         var _loc10_:PUser = null;
         var _loc11_:uint = 0;
         var _loc12_:PLocation = null;
         var _loc13_:String = null;
         var _loc14_:PUserBase = null;
         var _loc15_:PUser = null;
         if(CoreLogic.running)
         {
            ErrorLogic.onUncaughtError("use resultMap when CoreLogic.running\n" + Facade.protoProxy.logs.join("\n"),true);
            return;
         }
         if(param1.family == 2 && param1.subfamily == 2 || param1.family == 16 && param1.subfamily == 4)
         {
            if(param1.family == 2)
            {
               _loc8_ = new Packet_0002_02(param1);
               _loc11_ = (_loc8_ as Packet_0002_02).variance;
               _loc8_ = (_loc8_ as Packet_0002_02).value;
            }
            else
            {
               _loc11_ = Packet_0002_02.FIGHT;
               _loc8_ = new Packet_0010_04(param1).value;
            }
            if(_loc11_ == Packet_0002_02.LOCATION)
            {
               _loc12_ = (_loc8_ as PGetLocationAnswer).location;
               _loc11_ = _loc12_.variance;
               switch(_loc11_)
               {
                  case PLocation.HOME:
                     _loc4_ = true;
                     _loc7_ = (_loc12_.value as PHome).um;
                     break;
                  case PLocation.BOSS:
                     _loc9_ = true;
                     Facade.battleMediator.isBoss = true;
                     _loc10_ = (_loc8_ as PGetLocationAnswer).me;
                     _loc5_ = getBossFight(_loc12_.value as PBossAttack,_loc10_);
                     _loc8_ = _loc12_.value;
                     _loc6_ = _loc5_.target_info;
                     break;
                  case PLocation.BATTLE:
                  case PLocation.STORM:
                     _loc9_ = true;
                     if(_loc12_.variance == PLocation.STORM)
                     {
                        _loc8_ = _loc12_.value;
                        _loc5_ = getStormFight(_loc8_ as PStorm);
                     }
                     else
                     {
                        _loc5_ = _loc12_.value;
                     }
                     _loc6_ = _loc5_.target_info;
                     break;
                  case PLocation.GROUP:
                     startRaid(_loc12_.value);
                     return;
                  case PLocation.ATTACKED:
                     waitUserAttack(_loc12_.value);
                     return;
                  case PLocation.SIMULATION:
                     Facade.mainPanel.hideLoadPanel();
                     CoreLogic.start(0,1000);
                     Facade.mainPanel.addInterLayer(new WaitSimulationPanel());
                     return;
                  default:
                     throw new Error("resultMap: bad location variance");
               }
            }
            else if(_loc11_ == Packet_0002_02.FIGHT)
            {
               _loc9_ = true;
               _loc8_ = (_loc8_ as PFightRequestResult).value;
               if(_loc8_ is PGroupFightInfo)
               {
                  startRaid(_loc8_ as PGroupFightInfo);
                  return;
               }
               _loc6_ = _loc8_ as PTargetInfo;
            }
            else
            {
               if(_loc11_ != Packet_0002_02.STORM)
               {
                  throw new Error("resultMap: bad Packet_0002_02 variance");
               }
               _loc9_ = true;
               _loc5_ = getStormFight(_loc8_ as PStorm);
               _loc6_ = _loc5_.target_info;
            }
         }
         else if(param1.family == 16 && param1.subfamily == 6)
         {
            if(param2 > 0)
            {
               _loc9_ = true;
            }
            _loc6_ = new Packet_0010_06(param1).value;
         }
         else if(param1.family == 80 && param1.subfamily == 6)
         {
            _loc9_ = true;
            _loc5_ = getReplayFight(param1);
            if(_loc5_)
            {
               _loc6_ = _loc5_.target_info;
               if(_loc6_.ti_user_base.user_id.indexOf("boss") >= 0)
               {
                  Facade.battleMediator.isBoss = true;
                  _loc13_ = Facade.userProxy.getBossKind();
                  _loc14_ = _loc6_.ti_user_base;
                  _loc14_.name = _loc13_;
                  _loc14_.ratio = Math.pow((Facade.userProxy.level + 180) / 6,Math.E);
                  _loc14_.clan = PUserClan.create("empire",Lang.getString("empire"),"emblem_empire",80,null,0,0,0,null,0);
                  _loc14_.level = 80;
               }
               param2 = BattleMediator.REPLAY;
            }
         }
         else if(param1.family == 96 && param1.subfamily == 26)
         {
            Facade.isCapital = true;
            _loc8_ = new Packet_0060_1A(param1).value;
            CapitalMediator.instance = new CapitalMediator();
            Facade.manualProxy.useClanMode();
            _loc7_ = (_loc8_ as PCapital).cap_um;
         }
         Facade.isMyMap = _loc4_;
         Facade.isBattle = _loc9_;
         if(!_loc4_ && !Facade.isCapital)
         {
            if(!_loc6_)
            {
               resultMapError(param1.family,param1.subfamily,param3);
               return;
            }
            _loc7_ = _loc6_.ti_um;
            _loc7_.init_time = _loc6_.ti_time_now;
            if(param3 != PFightKind2.USER_WAR_TARGET)
            {
               _loc6_.ti_warpoints = 0;
            }
         }
         CoreLogic.start(_loc7_.init_time,_loc4_ ? 3000 : 1000);
         Facade.boardMediator.init(_loc9_,_loc4_);
         addConstruction(_loc7_,_loc8_ is PStorm ? (_loc8_ as PStorm).storm_obj_stamina : null);
         if(_loc4_)
         {
            Facade.battleMediator.reloadCount = 0;
            _loc15_ = (_loc8_ as PGetLocationAnswer).me;
            Facade.userProxy.assignUser(_loc15_,_loc12_.value);
            addTroops(_loc15_.base);
            BarrackMediator.filterLastArmy();
            BoardLogic.addAllObjects();
            Facade.myMediator.show(_loc12_.value);
            if(_loc15_.shop_unwatched.length > 0)
            {
               Facade.myMediator.syncShopButton(true);
            }
            useActions(_loc7_,_loc15_);
            Facade.questMediator.init(_loc15_);
            UnitFactory.useSoldierPatrol();
            if(_loc15_.base.level > 4)
            {
               if(Facade.manualProxy.newsList.length > 0 && (Facade.manualProxy.newsList[0] as PNewsInfo).news_kind != _loc15_.last_readed_news)
               {
                  DialogLogic.openHistory(true);
               }
            }
            if(Facade.myMapCallback)
            {
               Facade.myMapCallback.apply();
               Facade.myMapCallback = null;
            }
            EventLogic.sync();
            if(Facade.socialnet == Facade.ODNOKLASSNIKI)
            {
               OfferOk.checkRun();
            }
            checkPolitic();
         }
         else
         {
            Facade.myMediator.syncRadarButton();
            if(Facade.isCapital)
            {
               BoardLogic.addAllObjects();
               CapitalMediator.instance.init(_loc8_ as PCapital);
            }
            else
            {
               addTroops(null,_loc6_.ti_attacker_info);
               Facade.battleMediator.visit(_loc6_,_loc8_ as PStorm,param1.family == 16 && param1.subfamily == 6 && param3 == 1);
               if(_loc9_)
               {
                  if(_loc6_.ti_user_base)
                  {
                     Facade.protoProxy.logs.unshift("uid: " + _loc6_.ti_user_base.user_id);
                  }
                  Facade.battleMediator.init(_loc6_,param2,_loc5_,param3,_loc8_ as PStorm);
                  BoardLogic.drawLanding();
               }
               BoardLogic.addAllObjects();
            }
         }
         Facade.myMediator.myPanel.syncLBPanel();
         Facade.audioProxy.startTheme();
         Facade.mainPanel.hideLoadPanel();
      }
      
      private static function resultMapError(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:String = null;
         if(param1 == 2 && param2 == 2)
         {
            switch(param3)
            {
               case PFightKind2.USER:
                  _loc4_ = "no_opponent";
                  break;
               case PFightKind2.USER_WAR_TARGET:
                  getMyMap();
                  Facade.mainMediator.showMessage(Lang.getString("no_war_opponent"));
                  return;
               case PFightKind2.REVENGE:
                  _loc4_ = "no_revenge";
            }
         }
         else if(param1 == 16 && param2 == 4)
         {
            switch(param3)
            {
               case PFightKind.RAID:
                  _loc4_ = "no_raid";
                  break;
               case PFightKind.MISSION:
               case PFightKind.EXT_MISSION:
                  _loc4_ = "no_mission";
            }
         }
         else if(param1 == 80 && param2 == 6)
         {
            _loc4_ = "no_replay";
         }
         ErrorLogic.show(Lang.getString(_loc4_ ? _loc4_ : "opponent_error"),"map");
      }
      
      private static function getReplayFight(param1:BinaryBuffer) : PCurrentFight
      {
         var _loc2_:PReplay = new Packet_0050_06(param1).value;
         if(!_loc2_)
         {
            return null;
         }
         var _loc3_:PCurrentFight = _loc2_.fight;
         var _loc4_:PTargetInfo = _loc3_.target_info;
         var _loc5_:PUserBase = _loc4_.ti_user_base;
         var _loc6_:PUserBase = _loc2_.attacker_base;
         _loc5_.name = _loc6_.name;
         _loc5_.level = _loc6_.level;
         _loc5_.snetwork = _loc6_.snetwork;
         _loc5_.clan = _loc6_.clan;
         _loc5_.avatar = _loc6_.avatar;
         _loc5_.avatar_small = _loc6_.avatar_small;
         _loc5_.avatar_big = _loc6_.avatar_big;
         _loc5_.user_id = _loc6_.user_id;
         _loc4_.ti_attacker_info.ai_units.length = 0;
         return _loc3_;
      }
      
      public static function getBossFight(param1:PBossAttack, param2:PUser) : PCurrentFight
      {
         return PCurrentFight.create(param1.ba_fight_time,param1.ba_fight_commands,createBossTargetInfo(param1,param2));
      }
      
      public static function createBossTargetInfo(param1:PBossAttack, param2:PUser) : PTargetInfo
      {
         var _loc6_:PShopSpell = null;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc3_:Build = Facade.userProxy.getBuild(PBtype.LIBRARY,false);
         var _loc4_:ManualProxy = Facade.manualProxy;
         var _loc5_:Array = [];
         for each(_loc6_ in _loc4_.spellShopList)
         {
            if(_loc6_.ssp_level == 1 && _loc6_.ssp_can_buy)
            {
               _loc9_ = _loc4_.getUnitLevel(Facade.userProxy.base.units_levels,_loc6_.ssp_kind,0);
               if(_loc9_ > 0)
               {
                  _loc5_.push(_loc6_.ssp_kind);
               }
            }
         }
         _loc7_ = [];
         for each(_loc8_ in _loc5_)
         {
            for each(_loc10_ in Facade.references.boss_defend_spells)
            {
               if(_loc8_ == _loc10_)
               {
                  _loc7_.push(_loc8_);
                  break;
               }
            }
         }
         return PTargetInfo.create(param2.base,param1.ba_um,param2.oil,param2.crystal,PFightType.create(PFightType.SINGLE,null),0,0,PAttackerInfo.create([],param1.ba_units_levels,[],0,0,param2.gold,_loc7_,_loc3_ ? int(_loc3_.level) : 1,0,0,param2.ruby),null,param1.ba_th_diff_k,param1.ba_storage_fight_k,param1.ba_time_now,null,0,0,param1.ba_fight_id,NaN,false,false);
      }
      
      public static function getStormFight(param1:PStorm) : PCurrentFight
      {
         var _loc2_:Array = null;
         var _loc3_:i_i = null;
         if(param1.storm_obj_stamina.length > 0)
         {
            _loc2_ = [];
            for each(_loc3_ in param1.storm_obj_stamina)
            {
               _loc2_[_loc3_.field_0] = _loc3_.field_1;
            }
            param1.storm_obj_stamina = _loc2_;
         }
         if(!param1.storm_territory)
         {
            Facade.manualProxy.useClanMode();
         }
         return PCurrentFight.create(param1.storm_fight_time,param1.storm_commands,createStormTargetInfo(param1));
      }
      
      public static function createStormTargetInfo(param1:PStorm) : PTargetInfo
      {
         return PTargetInfo.create(null,param1.storm_um,param1.storm_oil,param1.storm_crystal,PFightType.create(PFightType.STORM,PGroupFightInfo.create(null,null,param1.storm_members,null,0,0,[],[])),0,0,param1.storm_attacker,null,1,1,param1.storm_server_time,null,param1.storm_my_full_hspace,0,param1.storm_fight_id,NaN,false,false);
      }
      
      private static function addConstruction(param1:PUm, param2:Array = null) : void
      {
         var _loc6_:PBuilding = null;
         var _loc7_:PFence = null;
         var _loc8_:PCannon = null;
         var _loc9_:PDecor = null;
         var _loc10_:PGarbage = null;
         var _loc11_:uint = 0;
         var _loc12_:Boolean = false;
         var _loc13_:Build = null;
         var _loc14_:uint = 0;
         var _loc15_:PBuildingSpec = null;
         var _loc16_:VOStorageSpec = null;
         var _loc17_:Cannon = null;
         var _loc3_:ManualProxy = Facade.manualProxy;
         var _loc4_:UserProxy = Facade.userProxy;
         var _loc5_:Boolean = param2 != null;
         if(_loc5_)
         {
            Facade.map.setGlobalLanding(true);
         }
         _loc4_.constructionId = param1.object_id;
         _loc4_.workerMax = Facade.isCapital ? 0 : 1;
         _loc4_.crystalMax = _loc4_.oilMax = 0;
         for each(_loc6_ in param1.buildings)
         {
            if(_loc5_ && param2[_loc6_.building_id] === 0)
            {
               BoardLogic.setUnitLanding(_loc6_.building_pos.x,_loc6_.building_pos.y,AnimClip.resourceProxy.getSize(_loc6_.building_kind));
            }
            else
            {
               _loc4_.changeConstructionCount(_loc6_.building_kind,1);
               if(_loc6_.building_pos.x < 0)
               {
                  _loc6_.building_build_state.variance = PBuildState.FINISHED;
                  _loc4_.addBuyOfferItem(_loc6_);
               }
               else
               {
                  _loc11_ = _loc6_.building_level;
                  _loc12_ = _loc6_.building_build_state.variance == PBuildState.IN_PROGRESS;
                  if(_loc11_ > 1 && _loc12_)
                  {
                     _loc11_--;
                  }
                  _loc13_ = UnitFactory.createConstruction(_loc3_.getBuildShop(_loc6_.building_kind,_loc11_),_loc6_.building_id,_loc6_.building_pos) as Build;
                  if(_loc12_)
                  {
                     _loc13_.setUpdateLevel(_loc6_.building_level);
                  }
                  _loc14_ = _loc13_.type;
                  _loc15_ = _loc6_.building_spec;
                  if(_loc14_ == PBtype.RESOURCE)
                  {
                     (_loc13_.spec as VOResourceSpec).assignData(_loc15_.value);
                  }
                  else if(_loc14_ == PBtype.STORAGE)
                  {
                     if(_loc13_.updateLevel != 1)
                     {
                        _loc16_ = _loc13_.spec as VOStorageSpec;
                        if(_loc16_.capacityMax > 0)
                        {
                           if(_loc16_.costVariance == PCost.CRYSTAL)
                           {
                              _loc4_.crystalMax += _loc16_.capacityMax;
                           }
                           else if(_loc16_.costVariance == PCost.OIL)
                           {
                              _loc4_.oilMax += _loc16_.capacityMax;
                           }
                        }
                     }
                  }
                  else if(_loc14_ == PBtype.CAMP)
                  {
                     _loc4_.soldierCapacityMax = _loc3_.getCampShop(_loc13_.level).sca_capacity;
                  }
                  else if(_loc14_ == PBtype.WORKER)
                  {
                     ++_loc4_.workerMax;
                  }
                  else if(_loc14_ == PBtype.TOWNHALL)
                  {
                     if(Facade.isMyMap || Facade.isCapital)
                     {
                        BuildLogic.changeTownHallLevel(_loc11_);
                     }
                  }
                  else if(_loc14_ == PBtype.GUARD)
                  {
                     (_loc13_.spec as VOGuardSpec).assignData(_loc15_.value);
                  }
                  else if(_loc14_ == PBtype.SHIELD)
                  {
                     (_loc13_.spec as VOShieldSpec).assignData(_loc15_.value,param1.init_time);
                  }
                  else if(_loc14_ == PBtype.CLAN)
                  {
                     Facade.userProxy.clanHallPrize = _loc15_.value;
                  }
               }
            }
         }
         for each(_loc7_ in param1.fences)
         {
            if(_loc5_ && param2[_loc7_.fence_id] === 0)
            {
               BoardLogic.setUnitLanding(_loc7_.fence_pos.x,_loc7_.fence_pos.y,1);
            }
            else
            {
               _loc4_.changeConstructionCount(_loc7_.fence_kind,1);
               if(_loc7_.fence_pos.x < 0)
               {
                  _loc4_.addBuyOfferItem(_loc7_);
               }
               else
               {
                  UnitFactory.createConstruction(_loc3_.getFenceShop(_loc7_.fence_kind,_loc7_.fence_level),_loc7_.fence_id,_loc7_.fence_pos);
               }
            }
         }
         for each(_loc8_ in param1.cannons)
         {
            if(_loc5_ && param2[_loc8_.cannon_id] === 0)
            {
               BoardLogic.setUnitLanding(_loc8_.cannon_pos.x,_loc8_.cannon_pos.y,AnimClip.resourceProxy.getSize(_loc8_.cannon_kind));
            }
            else
            {
               _loc4_.changeConstructionCount(_loc8_.cannon_kind,1);
               if(_loc8_.cannon_pos.x < 0)
               {
                  _loc8_.cannon_build_state.variance = PBuildState.FINISHED;
                  _loc4_.addBuyOfferItem(_loc8_);
               }
               else
               {
                  _loc11_ = _loc8_.cannon_level;
                  _loc12_ = _loc8_.cannon_build_state.variance == PBuildState.IN_PROGRESS;
                  if(_loc11_ > 1 && _loc12_)
                  {
                     _loc11_--;
                  }
                  _loc17_ = UnitFactory.createConstruction(_loc3_.getCannonShop(_loc8_.cannon_kind,_loc11_),_loc8_.cannon_id,_loc8_.cannon_pos) as Cannon;
                  if(_loc12_)
                  {
                     _loc17_.setUpdateLevel(_loc8_.cannon_level);
                  }
               }
            }
         }
         CannonLogic.checkPylonCannon();
         if(Facade.isBattle)
         {
            CannonLogic.setSkipPylonAnim();
         }
         for each(_loc9_ in param1.decors)
         {
            _loc4_.changeConstructionCount(_loc9_.decor_kind,1);
            if(_loc9_.decor_pos.x < 0)
            {
               _loc4_.addBuyOfferItem(_loc9_);
            }
            else
            {
               UnitFactory.createConstruction(_loc3_.getDecorShop(_loc9_.decor_kind),_loc9_.decor_id,_loc9_.decor_pos);
            }
         }
         for each(_loc10_ in param1.garbages)
         {
            (UnitFactory.createConstruction(_loc3_.getGarbageShop(_loc10_.garbage_kind),_loc10_.garbage_id,_loc10_.garbage_pos) as Garbage).prize = _loc10_.garbage_remove_prize;
         }
         BoardLogic.updateLanding(false,!_loc5_);
      }
      
      public static function addTroops(param1:PUserBase, param2:PAttackerInfo = null) : void
      {
         var _loc5_:PShopUnit = null;
         var _loc6_:PShopSpell = null;
         var _loc7_:PKindCount = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc3_:UserProxy = Facade.userProxy;
         var _loc4_:ManualProxy = Facade.manualProxy;
         if(param1)
         {
            _loc8_ = param1.units;
            _loc9_ = param1.units_levels;
            _loc3_.heroSpecList = param1.heroes;
         }
         else if(param2)
         {
            _loc8_ = param2.ai_units;
            _loc9_ = param2.ai_units_levels;
            _loc3_.heroSpecList = param2.ai_heroes;
         }
         else
         {
            _loc3_.heroSpecList = null;
         }
         for each(_loc5_ in _loc4_.soldierShopList)
         {
            if(_loc5_.su_level == 1)
            {
               _loc3_.soldierLevelHash[_loc5_.su_kind] = _loc4_.getUnitLevel(_loc9_,_loc5_.su_kind,0);
               _loc3_.soldierCountHash[_loc5_.su_kind] = 0;
            }
         }
         for each(_loc6_ in _loc4_.spellShopList)
         {
            if(_loc6_.ssp_level == 1)
            {
               _loc3_.soldierLevelHash[_loc6_.ssp_kind] = _loc4_.getUnitLevel(_loc9_,_loc6_.ssp_kind,0);
            }
         }
         for each(_loc7_ in _loc8_)
         {
            _loc3_.soldierCountHash[_loc7_.kind] = _loc7_.count;
            _loc5_ = _loc4_.getSoldierShop(_loc7_.kind,1);
            if(!_loc5_.su_is_hero)
            {
               _loc3_.soldierCapacityCur += _loc7_.count * _loc5_.su_hspace;
            }
         }
      }
      
      public static function useActions(param1:PUm, param2:PUser) : void
      {
         var _loc6_:PBuilding = null;
         var _loc7_:PCannon = null;
         var _loc8_:PGarbage = null;
         var _loc11_:PBuildingSpec = null;
         var _loc12_:PHero = null;
         var _loc13_:POffer = null;
         var _loc3_:UserProxy = Facade.userProxy;
         var _loc4_:ManualProxy = Facade.manualProxy;
         ActionLogic.createEndSeason();
         var _loc5_:uint = PBuildState.IN_PROGRESS;
         for each(_loc6_ in param1.buildings)
         {
            if(_loc6_.building_build_state.variance == _loc5_)
            {
               ActionLogic.addFinishConstruction(_loc6_.building_id,_loc4_.getBuildShop(_loc6_.building_kind,_loc6_.building_level).sb_upgrade_time,_loc6_.building_build_state.value);
            }
            else
            {
               _loc11_ = _loc6_.building_spec;
               if(_loc11_.variance == PBuildingSpec.RESEARCH)
               {
                  ActionLogic.addResearchP(_loc6_.building_id,_loc11_.value);
               }
               else if(_loc11_.variance == PBuildingSpec.SHIELD)
               {
                  ActionLogic.addRecoveryShield(_loc6_.building_id);
               }
            }
         }
         for each(_loc7_ in param1.cannons)
         {
            if(_loc7_.cannon_build_state.variance == _loc5_)
            {
               ActionLogic.addFinishConstruction(_loc7_.cannon_id,_loc4_.getCannonShop(_loc7_.cannon_kind,_loc7_.cannon_level).sc_upgrade_time,_loc7_.cannon_build_state.value);
            }
         }
         for each(_loc8_ in param1.garbages)
         {
            if(!isNaN(_loc8_.garbage_start_remove))
            {
               ActionLogic.addCleanupGarbage(_loc8_.garbage_id,_loc8_.garbage_start_remove);
            }
         }
         if(param2)
         {
            for each(_loc12_ in _loc3_.heroSpecList)
            {
               ActionLogic.addRecoveryHero(_loc12_);
            }
            if(_loc3_.energy < _loc3_.energyMax)
            {
               ActionLogic.addRecoveryEnergy(param2.call_lat);
            }
            ActionLogic.addRecoveryRequestEnergy(null,param2.clan_calls_time);
            for each(_loc13_ in param2.offers)
            {
               ActionLogic.addOffer(_loc13_);
            }
            OfferHalloween.showBanner(param2.offers);
            if(Facade.socialnet == Facade.VKONTAKTE && param2.base.level >= 5 && param2.quests_closed.indexOf("likeActionVk") >= 0)
            {
               Facade.questMediator.openQuestOffer(PQuest.create(QuestProxy.VK_SOCIAL_TANK,null));
            }
         }
         var _loc9_:BuildLogic = UnitFactory.buildLogic;
         var _loc10_:Build = _loc3_.buildList.head as Build;
         while(_loc10_)
         {
            _loc9_.syncStatus(_loc10_);
            _loc10_ = _loc10_.link_next as Build;
         }
         if(_loc3_.workerList.length > _loc3_.workerMax)
         {
            throw new Error("bad worker use=" + _loc3_.workerList.length + ", max=" + _loc3_.workerMax);
         }
         Facade.myMediator.checkBuyWorker();
      }
      
      public static function waitUserAttack(param1:PFightAttakerInfo) : void
      {
         Facade.mainPanel.hideLoadPanel();
         CoreLogic.start(0,1000);
         Facade.mainPanel.addInterLayer(new WaitAttackPanel(Facade.references.max_fight_time + Facade.references.fight_prepare_time - param1.fat_time + 1,param1.fat_name,param1.fat_clan),false);
      }
      
      private static function startRaid(param1:PGroupFightInfo) : void
      {
         if(param1.fgi_raid_kind != "rd_bosses" && param1.fgi_time >= param1.fgi_create_time + Facade.references.raid_bot_time)
         {
            getMyMap();
         }
         else
         {
            Facade.mainPanel.hideLoadPanel();
            CoreLogic.start(param1.fgi_time,1000);
            new StartRaidMediator().show(param1);
         }
      }
   }
}

