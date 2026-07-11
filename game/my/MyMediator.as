package game.my
{
   import engine.signal.Signal;
   import engine.units.Build;
   import flash.display.StageDisplayState;
   import flash.events.FullScreenEvent;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import game.barrack.BarrackMediator;
   import game.board.UnitMenuButton;
   import game.clan.center.ClanEditMediator;
   import game.clan.social.ClanSocialMediator;
   import game.clan.war.StormTerritoryMediator;
   import game.clan.war.WarEnemyMediator;
   import game.destruction.VODestruction;
   import game.missions.EventMapMediator;
   import game.missions.JainaMapMediator;
   import game.offer.OfferButton;
   import game.offer.OfferMediator;
   import game.offer.OfferOk;
   import game.portal.PortalMediator;
   import game.quest.NewStoryDialog;
   import game.radar.RadarMediator;
   import game.shop.AlinkDialog;
   import game.shop.ShopMediator;
   import logic.*;
   import logic.quests.QuestTrain;
   import logic.training.AbstractTrain;
   import logic.training.BlackoutClickStep;
   import logic.training.DownStep;
   import logic.training.firstsession.NewPortalTrain;
   import logic.units.BuildLogic;
   import model.CommonEvent;
   import model.ManualProxy;
   import model.QuestProxy;
   import model.UserProxy;
   import model.vo.VOQuest;
   import model.vo.VOResourceSpec;
   import proto.BinaryBuffer;
   import proto.game.family_0010.PFightKind;
   import proto.game.family_0010.Packet_0010_0F;
   import proto.game.family_0050.Packet_0050_02;
   import proto.game.family_0060.Packet_0060_13;
   import proto.game.family_0060.Packet_0060_22;
   import proto.model.*;
   import proto.model.clan.*;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.MessageDialog;
   import ui.game.CircleAvatarPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class MyMediator
   {
      
      public static const infoBt:UnitMenuButton = new UnitMenuButton(false);
      
      public static const updateBt:UnitMenuButton = new UnitMenuButton(false);
      
      public static const speedupBt:UnitMenuButton = new UnitMenuButton(false);
      
      public static const cancelBt:UnitMenuButton = new UnitMenuButton(false);
      
      public static const commonBt:UnitMenuButton = new UnitMenuButton(false);
      
      public static const common2Bt:UnitMenuButton = new UnitMenuButton(false);
      
      public static const common3Bt:UnitMenuButton = new UnitMenuButton(false);
      
      public static const common4Bt:UnitMenuButton = new UnitMenuButton(false);
      
      public const myPanel:MyPanel = new MyPanel();
      
      public const prefPanel:PrefPanel = new PrefPanel();
      
      private var shieldSignal:Signal;
      
      private var sleepSignal:Signal;
      
      private var stormStatusPanel:StormStatusPanel;
      
      private const up:UserProxy = Facade.userProxy;
      
      public function MyMediator()
      {
         super();
         Facade.mainPanel.layerPanel.add(this.prefPanel,{
            "top":145,
            "right":6
         });
         this.prefPanel.setZoomValue(Facade.board.scaleX);
         this.prefPanel.addListener(VEvent.SCROLL,this.onZoom);
         this.prefPanel.fullScreenBt.addEventListener(MouseEvent.CLICK,this.onFullScreen);
         this.prefPanel.settingBt.addClickListener(this.onSettings);
         this.myPanel.addEventListener(VEvent.VARIANCE,this.onVariance);
         Facade.addListener(CommonEvent.EXP,this.onExp);
         Facade.addListener(CommonEvent.CRYSTAL,this.onResource);
         Facade.addListener(CommonEvent.MITHRIL,this.onMithril);
         Facade.addListener(CommonEvent.OIL,this.onResource);
         Facade.addListener(CommonEvent.LEVEL,this.onLevel);
         Facade.addListener(CommonEvent.RATING,this.onRating);
         Facade.addListener(CommonEvent.WORKER,this.onWorker);
         Facade.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.onFullScreenChange);
         this.myPanel.goldPanel.useTrack(false);
         this.myPanel.goldPanel.addBuyBt(this.onGoldBuy);
         this.myPanel.shieldPanel.setCustom(Lang.getString("not_shield"));
         this.myPanel.shieldPanel.addBuyBt(this.onShieldBuy,Lang.getString("buyShieldBt"));
         this.myPanel.energyPanel.addBuyBt(this.onAlinkEnergy,Lang.getString("resource_buy"));
         this.myPanel.energyPanel.hint = this.getEnergyHint;
         Facade.addListener(CommonEvent.ENERGY,this.onEnergy);
         infoBt.changeView("InfoIcon",Lang.getString("info"));
         updateBt.changeView("UpdateIcon",Lang.getString("updateBt"));
         speedupBt.changeView("SpeedupIcon",Lang.getString("speedupBt"));
         cancelBt.changeView("CancelIcon",Lang.getString("move_cancel"));
         this.myPanel.workerPanel.hint = this.getWorkerHint;
         this.myPanel.ratingPanel.hint = this.getRatingHint;
      }
      
      private function getWorkerHint() : String
      {
         return Lang.getString("worker_help") + "\n" + Lang.getPatternString("free_worker","__VALUE__",this.up.getFreeWorker().toString());
      }
      
      private function getRatingHint() : String
      {
         if(this.up.radarEnabled)
         {
            return "<p" + Style.metalColor + ">" + StringHelper.getTLFImage("lib,RatingIcon",20,2) + Lang.getString("rating") + "</p><p>" + Lang.getString("rating_desc") + "</p><p>" + Lang.getPatternString("ratio_max","__MAX__",("<span" + Style.greenColor + ">" + Facade.manualProxy.getLevelInfo().l_max_ratio * 2).toString() + "</span>") + "</p><p" + Style.greenColor + ">" + StringHelper.getTLFImage("lib,PremiumArrowIcon",18) + Lang.getString("scout_ratio_max_hint") + "</p><p" + Style.greenColor + ">" + StringHelper.getTLFImage("lib,PremiumArrowIcon",18) + Lang.getString("scout_ratio_bonus_hint") + "</p>";
         }
         return "<p" + Style.metalColor + ">" + StringHelper.getTLFImage("lib,RatingIcon",20,2) + Lang.getString("rating") + "</p><p>" + Lang.getString("rating_desc") + "</p><p>" + Lang.getPatternString("ratio_max","__MAX__",Facade.manualProxy.getLevelInfo().l_max_ratio.toString()) + "</p>";
      }
      
      public function clear() : void
      {
         if(this.sleepSignal)
         {
            this.sleepSignal.stop();
            Facade.protoProxy.sleepSignal = null;
         }
         this.myPanel.clear();
         this.setEmptyShield();
         this.closeClanPanel();
         if(this.stormStatusPanel)
         {
            this.stormStatusPanel.clear();
         }
      }
      
      public function closeClanPanel() : void
      {
         if(Boolean(this.myPanel.chatBt) && this.myPanel.chatBt.data is ClanSocialMediator)
         {
            (this.myPanel.chatBt.data as ClanSocialMediator).onClose();
         }
      }
      
      private function setEmptyShield() : void
      {
         if(this.shieldSignal)
         {
            this.shieldSignal.stop();
            this.shieldSignal = null;
            this.myPanel.shieldPanel.setCustom(Lang.getString("not_shield"));
         }
      }
      
      public function show(param1:PHome) : void
      {
         var _loc5_:PHistFight = null;
         Facade.mainPanel.showCommonPanel(this.myPanel);
         this.updateStorageMax();
         if(isNaN(param1.shield_time_opt) || param1.shield_time_opt <= 0)
         {
            this.setEmptyShield();
         }
         else
         {
            this.showShield(param1.shield_time_opt,false);
         }
         var _loc2_:uint = 0;
         var _loc3_:VODestruction = null;
         var _loc4_:Number = Number(this.up.getCustomData("destruction_last_show"));
         for each(_loc5_ in this.up.historyList)
         {
            if(!_loc5_.phf_read)
            {
               if(_loc5_.phf_time > _loc4_)
               {
                  if(!_loc3_)
                  {
                     _loc3_ = new VODestruction();
                     _loc3_.humiliationCount = 1;
                     _loc3_.ratioCount = _loc5_.phf_change_ratio;
                     _loc3_.resourceSteal = _loc5_.phf_steal_res;
                  }
                  else
                  {
                     ++_loc3_.humiliationCount;
                     _loc3_.ratioCount += _loc5_.phf_change_ratio;
                     _loc3_.resourceSteal = CostHelper.mergeCostLists(_loc3_.resourceSteal,_loc5_.phf_steal_res);
                  }
               }
               _loc2_++;
            }
         }
         if(_loc3_)
         {
            this.up.setCustomData("destruction_last_show",Math.round(CoreLogic.serverTime).toString());
            Facade.showDestruction(_loc3_);
         }
         this.myPanel.syncHistoryButton(_loc2_,this.up.historyList.length);
         this.syncClanButton();
         this.syncRadarButton();
         this.prefPanel.useDamageBt(false);
         if(this.up.buyOfferList)
         {
            this.myPanel.useEditButton(Facade.boardMediator.useEditorMode,this.up.buyOfferList.length);
         }
         if(this.stormStatusPanel)
         {
            if(!this.up.clan)
            {
               this.stormStatusPanel.removeFromParent(true);
               this.stormStatusPanel = null;
            }
            else
            {
               this.stormStatusPanel.visible = false;
            }
         }
         if(!Facade.isMissionEditor)
         {
            this.myPanel.energyPanel.setMax(this.up.energyMax,false,false);
            this.onEnergy();
            if(!this.sleepSignal)
            {
               this.sleepSignal = new Signal(this.onGameSleep);
               this.sleepSignal.delay = Facade.references.online_timeout;
            }
            Facade.protoProxy.sleepSignal = this.sleepSignal;
            this.sleepSignal.delayCall(this.sleepSignal.delay);
            Facade.gameStream.assign(param1.um.init_time + param1.dt,this.onGameStream).run(PEventPlace.NOTHING,this.up.clan ? this.up.clan.uc_clan_id : null);
            if(this.up.clan)
            {
               this.getChatHistory();
            }
         }
         this.syncAdventureButton();
      }
      
      public function syncAdventureButton() : void
      {
         this.myPanel.useAdventureButton(GoMediator.getActiveAdventure(false),this.onAdventure,Facade.userProxy.currentAdventure);
      }
      
      public function onAdventure(param1:MouseEvent) : void
      {
         var _loc2_:Array = GoMediator.getActiveAdventure();
         if(_loc2_[0] > 0)
         {
            DialogLogic.open(_loc2_[1].jei_id >= 2 ? new EventMapMediator(_loc2_) : new JainaMapMediator(_loc2_));
         }
         else
         {
            DialogLogic.openGo();
            this.myPanel.useAdventureButton(0,null);
         }
      }
      
      public function getChatHistory() : void
      {
         this.syncStormStatus(this.up.clanData);
         Facade.protoProxy.request(new Packet_0060_13(),this.resultChatHistory,80,2,null,"getChat");
      }
      
      public function syncClanButton() : void
      {
         this.myPanel.syncClanButton(Boolean(this.up.clan) || this.up.alinkRequestList.length > 0);
      }
      
      public function syncShopButton(param1:Boolean) : void
      {
         this.myPanel.changeNewIcon(this.myPanel.shopBt,param1);
      }
      
      public function showShield(param1:Number, param2:Boolean) : void
      {
         if(!this.shieldSignal)
         {
            this.shieldSignal = new Signal(this.onShieldSignal,Signal.ADD_TIMER);
            if(param2)
            {
               param1 += CoreLogic.serverTime;
            }
         }
         else if(param2)
         {
            param1 += this.shieldSignal.endTime;
         }
         this.shieldSignal.run(0,param1,true);
      }
      
      private function onShieldSignal() : void
      {
         if(this.shieldSignal.tail > 0)
         {
            this.myPanel.shieldPanel.setCustom(StringHelper.getTimeDesc(this.shieldSignal.tail));
         }
         else
         {
            this.setEmptyShield();
         }
      }
      
      public function checkBuyWorker() : void
      {
         var _loc4_:String = null;
         var _loc5_:PShopBuilding = null;
         var _loc1_:ManualProxy = Facade.manualProxy;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         for each(_loc5_ in _loc1_.buildShopList)
         {
            if(_loc5_.sb_level == 1 && _loc5_.sb_btype.variance == PBtype.WORKER)
            {
               _loc4_ = _loc5_.sb_kind;
               _loc3_ += this.up.getConstructionMax(_loc4_);
               _loc2_ += this.up.getConstructionCount(_loc4_);
               break;
            }
         }
         if(_loc2_ < _loc3_)
         {
            this.myPanel.workerPanel.addBuyBt(this.toBuyWorker,Lang.getString("buyWorkerBt"),_loc5_);
         }
         else
         {
            this.myPanel.workerPanel.removeBuyBt();
         }
         this.onWorker(null);
      }
      
      private function toBuyWorker(param1:MouseEvent) : void
      {
         var _loc2_:PShopBuilding = (param1.currentTarget as VButton).data as PShopBuilding;
         if(Facade.isMyMap)
         {
            ShopLogic.buyWorker(_loc2_);
         }
         else
         {
            DialogLogic.openShop(ShopMediator.RESOURCE,_loc2_.sb_kind);
         }
      }
      
      private function onWorker(param1:CommonEvent) : void
      {
         var _loc4_:Build = null;
         var _loc5_:String = null;
         var _loc6_:NewStoryDialog = null;
         var _loc2_:uint = this.up.getFreeWorker();
         this.myPanel.workerPanel.setCustom(_loc2_ + "/" + this.up.workerMax);
         if(Facade.isMyMap && this.up.workerMax == 1 && _loc2_ == 0 && Facade.checkUserStage("home4_hero_click"))
         {
            _loc5_ = this.up.getCustomData("first_worker");
            if(!_loc5_)
            {
               Facade.userProxy.setCustomData("first_worker","1");
               _loc6_ = new NewStoryDialog("un_jaina1",Lang.getString("jaina_add_builder"));
               Facade.mainMediator.showDialog(_loc6_);
               _loc6_.addListener(VEvent.CLOSE_DIALOG,this.onDialogClose);
            }
         }
         var _loc3_:Vector.<Build> = new Vector.<Build>();
         this.up.getBuild(PBtype.WORKER,true,0,_loc3_);
         for each(_loc4_ in _loc3_)
         {
            if(_loc2_ > 0)
            {
               _loc4_.spec = true;
               _loc2_--;
            }
            else
            {
               _loc4_.spec = false;
            }
            UnitFactory.buildLogic.syncWorkerStatus(_loc4_);
         }
      }
      
      private function onDialogClose(param1:VEvent) : void
      {
         var _loc2_:AbstractTrain = new AbstractTrain();
         AbstractTrain.assign(_loc2_);
         _loc2_.assignStep(new BlackoutClickStep(Facade.myMediator.myPanel.workerPanel.buyBt,270,{
            "vCenter":0,
            "left":-30
         }),AbstractTrain.clear);
      }
      
      private function onExp(param1:CommonEvent) : void
      {
         this.myPanel.expPanel.setCur(param1.data);
      }
      
      private function onRating(param1:CommonEvent) : void
      {
         this.myPanel.ratingPanel.setData(param1.data);
      }
      
      private function onLevel(param1:CommonEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:PLevelInfo = Facade.manualProxy.getLevelInfo(this.up.level);
         if(!Facade.isCapital)
         {
            _loc3_ = uint(Facade.manualProxy.getLeagueShop(this.up.level).division_num);
            if(param1.data)
            {
               ShopLogic.applyCostList(_loc2_.l_bonus);
               Facade.questMediator.checkNewLeague(this.up.level);
               EventLogic.sync();
            }
         }
         this.myPanel.expPanel.setData(this.up.level,this.up.exp,this.up.nextExp,_loc2_.l_require,_loc3_);
      }
      
      public function updateStorageMax() : void
      {
         this.myPanel.crystalPanel.setMax(this.up.crystalMax);
         this.myPanel.oilPanel.setMax(this.up.oilMax);
         this.myPanel.onyxPanel.setMax(Facade.isCapital ? uint(Facade.references.clan_mithril_limit) : uint(Facade.references.mithril_limit));
      }
      
      private function onVariance(param1:VEvent) : void
      {
         switch(param1.variance)
         {
            case MyPanel.GO:
               DialogLogic.openGo();
               break;
            case MyPanel.CLAN:
               DialogLogic.openClanCenter();
               break;
            case MyPanel.SHOP:
               DialogLogic.openShop();
               break;
            case MyPanel.CHAT:
               if(!this.myPanel.chatBt.data)
               {
                  if(!this.myPanel.chatBt.disabled)
                  {
                     MyPanel.changeButtonCount(this.myPanel.chatBt,0);
                     new ClanSocialMediator(this.myPanel.chatBt);
                  }
               }
               break;
            case MyPanel.HISTORY:
               DialogLogic.openHistory();
               break;
            case MyPanel.SOCIAL:
               DialogLogic.openFriends();
               break;
            case MyPanel.BARRACK:
               Facade.mainMediator.showDialog(new BarrackMediator(param1.data));
               break;
            case MyPanel.DEAD_TROOPS:
               UnitFactory.buildLogic.onBuyLastArmy(param1.data);
         }
      }
      
      public function checkShieldAndCall(param1:Function, param2:Array = null) : void
      {
         if(this.shieldSignal)
         {
            Facade.mainMediator.showYesNoDialog(Lang.getString("shield_break"),param1,param2,null,SkinManager.getEmbed("ShieldIcon"));
         }
         else
         {
            param1.apply(null,param2);
         }
      }
      
      public function startSearchPvP() : void
      {
         if(MainLogic.checkArmy())
         {
            this.checkShieldAndCall(this.nextSearchPvP);
         }
      }
      
      public function nextSearchPvP(param1:Boolean = true) : void
      {
         var _loc2_:PCost = param1 ? Facade.references.enter_pvp_price : Facade.manualProxy.getTownHallUnlock().tu_find_target_price;
         if(this.up.isCost(_loc2_))
         {
            ShopLogic.applyCost(_loc2_,true);
            MainLogic.getRivalMap(PFightKind2.create(PFightKind2.USER,null),false);
         }
         else if(Facade.isMyMap)
         {
            this.onAlinkEnergy();
         }
         else
         {
            Facade.setMapCallback(this.onAlinkEnergy);
            MainLogic.getMyMap();
         }
      }
      
      private function onZoom(param1:VEvent) : void
      {
         Facade.boardMediator.changeZoom(this.prefPanel.zoomMin + (this.prefPanel.zoomMax - this.prefPanel.zoomMin) * (1 - Number(param1.data) / 100));
         Signal.createRef(this.prefPanel,SettingMediator.save,0,0,false).delayCall(10);
      }
      
      public function changeZoom(param1:Number) : void
      {
         if(param1 > this.prefPanel.zoomMax)
         {
            param1 = this.prefPanel.zoomMax;
         }
         else if(param1 < this.prefPanel.zoomMin)
         {
            param1 = this.prefPanel.zoomMin;
         }
         Facade.boardMediator.changeZoom(param1);
         this.prefPanel.setZoomValue(param1);
      }
      
      private function onFullScreen(param1:MouseEvent) : void
      {
         var event:MouseEvent = param1;
         var isNormal:Boolean = Facade.stage.displayState == StageDisplayState.NORMAL;
         var newMode:String = isNormal ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
         if(isNormal)
         {
            try
            {
               Facade.stage.displayState = newMode;
            }
            catch(error:Error)
            {
               Facade.mainMediator.showMessage(Lang.getString("full_screen_lock"));
            }
         }
         else
         {
            Facade.stage.displayState = newMode;
         }
      }
      
      private function onFullScreenChange(param1:FullScreenEvent) : void
      {
         this.myPanel.questBtPanel.setScale(param1.fullScreen ? 1.25 : 1);
      }
      
      public function onGoldBuy(param1:MouseEvent = null) : void
      {
         if(Facade.socialnet == Facade.VZ)
         {
            ShopLogic.openVZBuy();
         }
         else
         {
            DialogLogic.openShop(ShopMediator.CURRENCY);
         }
      }
      
      private function onShieldBuy(param1:MouseEvent) : void
      {
         var _loc2_:Array = Facade.manualProxy.shieldPackList;
         DialogLogic.openShop(ShopMediator.CURRENCY,_loc2_.length > 0 ? (_loc2_[0] as PShopShield).sh_kind : null,false);
      }
      
      public function showBuildNeed(param1:String, param2:String, param3:String, param4:String) : void
      {
         var _loc5_:Build = this.up.getBuildEx(param4,false);
         var _loc6_:MessageDialog = new MessageDialog(Lang.getString(param1),Lang.getString(param2),SkinManager.getEmbed(param3),_loc5_ ? MessageDialog.ADD_OK_BUTTON : 0);
         if(_loc5_)
         {
            Facade.boardMediator.moveBoard(_loc5_.b_x,_loc5_.b_y);
            Facade.boardMediator.setSelected(_loc5_);
         }
         else
         {
            _loc6_.addDelegateRectButton(Lang.getString("help_toShop"),DialogLogic.openShop,[ShopMediator.ARMY,param4]);
         }
         Facade.mainMediator.showDialog(_loc6_);
      }
      
      public function toPortal() : void
      {
         var _loc1_:VOQuest = null;
         var _loc2_:QuestTrain = null;
         if(this.up.getBuild(PBtype.RAID,false))
         {
            _loc1_ = Facade.questProxy.getQuest("tryRaid1");
            if(Boolean(_loc1_) && !_loc1_.isComplete)
            {
               _loc2_ = new NewPortalTrain();
               _loc2_.item = _loc1_;
               AbstractTrain.assign(_loc2_);
            }
            else
            {
               Facade.mainMediator.showDialog(new PortalMediator());
            }
         }
         else
         {
            this.showBuildNeed("portal_need","getRaidBt","PortalIcon","bl_portal");
         }
      }
      
      private function onResource(param1:CommonEvent) : void
      {
         var _loc2_:Boolean = false;
         if(Facade.isMyMap || Facade.isCapital)
         {
            _loc2_ = param1.type == CommonEvent.CRYSTAL;
            if(_loc2_)
            {
               this.myPanel.crystalPanel.setData(param1.data);
            }
            else
            {
               this.myPanel.oilPanel.setData(param1.data);
            }
            BuildLogic.calcStorage(_loc2_,!_loc2_);
         }
      }
      
      private function onMithril(param1:CommonEvent) : void
      {
         if(Facade.isMyMap || Facade.isCapital)
         {
            this.myPanel.onyxPanel.setData(param1.data);
         }
      }
      
      public function changeWar(param1:PWar) : void
      {
         if(this.up.clanData)
         {
            this.up.clanData.war = param1;
            this.syncStormStatus(this.up.clanData);
            EventLogic.sync();
         }
      }
      
      public function onGameStream(param1:Array) : void
      {
         var _loc3_:PRaidFriendEvent = null;
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:* = undefined;
         var _loc2_:Boolean = Boolean(this.up.clanData);
         for each(_loc3_ in param1)
         {
            _loc4_ = false;
            _loc5_ = _loc3_.rf_event.variance;
            _loc6_ = _loc3_.rf_event.value;
            if(_loc5_ == PRaidEvent.FETCH_EVENTS)
            {
               Facade.log("FETCH_EVENTS");
               EventLogic.sync();
            }
            else if(_loc5_ == PRaidEvent.ASK || _loc5_ == PRaidEvent.HELP)
            {
               this.up.updateAskRequest(_loc6_);
               if(!this.myPanel.chatBt)
               {
                  this.syncClanButton();
               }
               this.showMyClanNotify();
               _loc4_ = true;
            }
            else if(_loc5_ == PRaidEvent.RAID_INVITE)
            {
               this.showRaidInvite(_loc6_);
            }
            else
            {
               if(_loc5_ == PRaidEvent.BUY_OFFER)
               {
                  MainLogic.getMyMap();
                  return;
               }
               if(_loc2_ || _loc5_ == PRaidEvent.NEW_CLAN_MEMBER)
               {
                  _loc4_ = true;
                  switch(_loc5_)
                  {
                     case PRaidEvent.UPDATE_CALL_REQUEST:
                        if(!this.updateEnergyRequest(_loc6_))
                        {
                           return;
                        }
                        break;
                     case PRaidEvent.INC_WARPOINTS:
                        if(this.up.clanData.war)
                        {
                           this.addWarPoints(_loc6_,this.up.clanData.war);
                           break;
                        }
                        _loc4_ = false;
                        break;
                     case PRaidEvent.CLAN_DONATE:
                        this.up.changeClanResource(_loc6_,false,PCapitalLogKind.DONATE,_loc3_.rf_friend_id);
                        break;
                     case PRaidEvent.CHAT_MESSAGE:
                        if(this.up.chatList)
                        {
                           this.up.chatList.push(_loc6_);
                        }
                        this.showMyClanNotify();
                        break;
                     case PRaidEvent.START_WAR:
                     case PRaidEvent.FINISH_WAR:
                        this.changeWar(_loc6_ as PWar);
                        Facade.mainMediator.searchDialog(WarEnemyMediator,true);
                        break;
                     case PRaidEvent.START_STORM:
                        this.syncStormStatus(this.up.clanData,_loc6_);
                        break;
                     case PRaidEvent.TERRITORY_REGENT:
                        this.onRegentChange(this.up.clanData.members,_loc6_);
                        break;
                     case PRaidEvent.DEL_CLAN_MEMBER:
                        if(_loc6_ == Preloader.uid)
                        {
                           _loc2_ = false;
                           this.resetClan();
                           break;
                        }
                        this.up.deleteMember(_loc6_);
                        break;
                     case PRaidEvent.NEW_CLAN_MEMBER:
                        if((_loc6_ as PMember).user_base.user_id == Preloader.uid)
                        {
                           ClanEditMediator.joinClan((_loc6_ as PMember).user_base.clan);
                           return;
                        }
                        if(!_loc2_)
                        {
                           return;
                        }
                        this.up.addClanMember(_loc6_);
                        break;
                     case PRaidEvent.NEW_CLAN_REQUEST:
                        this.up.addClanRequest(_loc6_);
                        if(this.up.checkClanRolePermission(PPermission.APPROVE) > 0)
                        {
                           this.showMyClanNotify();
                        }
                        break;
                     case PRaidEvent.DEL_CLAN_REQUEST:
                        this.up.deleteClanRequest(_loc6_);
                        break;
                     case PRaidEvent.SET_CLAN_ROLE:
                        this.up.setClanRole(_loc6_);
                        break;
                     case PRaidEvent.CREATE_CAPITAL:
                        EventLogic.sync();
                  }
               }
            }
            if(_loc4_)
            {
               Facade.dispatchCommonEvent(CommonEvent.MY_GAME_STREAM,_loc3_.rf_event);
            }
         }
      }
      
      private function addWarPoints(param1:PIncWarpoints, param2:PWar) : void
      {
         if(param2.war_enemy == param1.iw_clan_id)
         {
            param2.war_enemy_points += param1.iw_count;
         }
         else
         {
            param2.war_points += param1.iw_count;
         }
      }
      
      private function showRaidInvite(param1:PRaidInvite) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:PRaidCooldown = null;
         var _loc4_:String = null;
         for each(_loc3_ in this.up.raidMissionList)
         {
            if(_loc3_.rc_raid_kind == param1.ri_raid_kind)
            {
               if(_loc3_.rc_end_time > CoreLogic.serverTime)
               {
                  _loc2_ = true;
               }
               break;
            }
         }
         _loc4_ = Lang.getReplaceString(_loc2_ ? "raid_invite_lock" : "raid_invite_msg",{
            "__NAME__":"<span" + Style.darkKhakiColor + ">" + param1.ri_name + "</span>",
            "__RAID__":Lang.getString(param1.ri_raid_kind)
         });
         if(_loc2_)
         {
            Facade.mainMediator.showMessage(_loc4_);
            return;
         }
         var _loc5_:CircleAvatarPanel = new CircleAvatarPanel();
         _loc5_.setSize(160,160);
         _loc5_.setUser(param1.ri_avatar,1);
         var _loc6_:MessageDialog = new MessageDialog(_loc4_,null,_loc5_,MessageDialog.UNIT_ICON);
         _loc6_.addYesNoButton(this.confirmRaidInvite,[param1]);
         Facade.mainMediator.showDialog(_loc6_,true);
      }
      
      private function confirmRaidInvite(param1:PRaidInvite) : void
      {
         if(GoMediator.checkRaidArmy())
         {
            MainLogic.requestMap(new Packet_0010_0F(PApplyRaidInvite.create(param1.ri_raid_id,param1.ri_raid_kind)),[0,PFightKind.RAID]);
         }
         else
         {
            this.showRaidInvite(param1);
         }
      }
      
      public function resetClan() : void
      {
         Facade.userProxy.base.clan_points = null;
         this.up.clan = null;
         this.up.clanData = null;
         this.up.energyRequestList = null;
         this.up.clanEnergy = 0;
         CoreLogic.removeFilterActions(0,ActionLogic.RECOVERY_REQUEST_ENERGY);
         if(this.myPanel.chatBt)
         {
            if(this.myPanel.chatBt.data is ClanSocialMediator)
            {
               (this.myPanel.chatBt.data as ClanSocialMediator).onClose();
            }
            this.syncClanButton();
         }
         UnitFactory.buildLogic.syncClanCenter(true);
         BarrackMediator.sellClanArmy();
         Facade.gameStream.run(PEventPlace.NOTHING);
      }
      
      private function updateEnergyRequest(param1:PCallRequest) : Boolean
      {
         if(param1.cr_user_id == Preloader.uid)
         {
            this.up.clanEnergy += Facade.references.clan_request_size;
            UnitFactory.buildLogic.syncClanCenter();
            return false;
         }
         if(param1.cr_current_count == 0)
         {
            this.showMyClanNotify();
         }
         else if(param1.cr_senders.indexOf(Preloader.uid) >= 0)
         {
            return false;
         }
         var _loc2_:Array = this.up.energyRequestList;
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:* = int(_loc2_.length - 1);
         while(_loc3_ >= 0)
         {
            if((_loc2_[_loc3_] as PCallRequest).cr_user_id == param1.cr_user_id)
            {
               if(param1.cr_current_count >= param1.cr_full_count)
               {
                  _loc2_.splice(_loc3_,1);
               }
               else
               {
                  param1.member = (_loc2_[_loc3_] as PCallRequest).member;
                  _loc2_[_loc3_] = param1;
               }
               param1 = null;
               break;
            }
            _loc3_--;
         }
         if(param1)
         {
            param1.member = this.up.getClanMember(param1.cr_user_id);
            if(!param1.member)
            {
               return false;
            }
            _loc2_.push(param1);
         }
         _loc2_.sortOn("cr_time",Array.DESCENDING);
         return true;
      }
      
      public function showMyClanNotify() : void
      {
         if(Boolean(this.myPanel.chatBt) && !(this.myPanel.chatBt.data is ClanSocialMediator))
         {
            MyPanel.changeButtonCount(this.myPanel.chatBt,-1);
         }
      }
      
      private function onGameSleep() : void
      {
         if(Facade.boardMediator.isEditorMode)
         {
            return;
         }
         Facade.protoProxy.clear();
         DialogLogic.sleepReOpen();
         MainLogic.free(false);
         Facade.mainMediator.showDialog(new SleepDialog()).addListener(VEvent.CLOSE_DIALOG,this.onSleepExit);
      }
      
      private function onSleepExit(param1:VEvent) : void
      {
         MainLogic.getDict();
      }
      
      public function syncStormStatus(param1:PClan, param2:PStartStorm = null) : void
      {
         var _loc3_:int = 0;
         if(Boolean(param2) && Boolean(param1))
         {
            ClanEditMediator.joinClan(this.up.clan);
            if(param2.territory)
            {
               _loc3_ = StormStatusPanel.TERRITORY;
               param1.active_territories = true;
            }
            else if(param1.war)
            {
               if(param2.attacker_id == param1.base.id)
               {
                  param1.war.war_my_storm = param2.start_time;
                  _loc3_ = StormStatusPanel.MY_STORM;
               }
               else
               {
                  param1.war.war_storm = param2.start_time;
                  _loc3_ = StormStatusPanel.ENEMY_STORM;
               }
            }
            else
            {
               _loc3_ = StormStatusPanel.CLAN_WAR;
            }
         }
         else
         {
            _loc3_ = -1;
         }
         if(Boolean(param1) && (Boolean(param1.active_territories) || Boolean(param1.war)))
         {
            if(!this.stormStatusPanel)
            {
               this.stormStatusPanel = new StormStatusPanel();
               this.stormStatusPanel.addListener(VEvent.VARIANCE,this.onStormStatus);
               this.myPanel.add(this.stormStatusPanel,{
                  "right":186,
                  "top":13
               });
            }
            else
            {
               this.stormStatusPanel.visible = true;
            }
            this.stormStatusPanel.sync(param1.war,param1.active_territories,_loc3_);
         }
         else if(this.stormStatusPanel)
         {
            this.stormStatusPanel.removeFromParent(true);
            this.stormStatusPanel = null;
         }
      }
      
      private function onStormStatus(param1:VEvent) : void
      {
         if(param1.variance == 0)
         {
            DialogLogic.openWar();
         }
         else if(param1.variance == 1)
         {
            DialogLogic.open(new StormTerritoryMediator());
         }
         else
         {
            this.toStorm(param1.variance == 2);
         }
      }
      
      public function toStorm(param1:Boolean) : void
      {
         if(param1 && isNaN(this.up.clanData.war.war_my_storm))
         {
            Facade.mainPanel.showLoadPanel();
            Facade.protoProxy.request(new Packet_0060_22(),null,96,38);
         }
         MainLogic.getStorm(param1);
      }
      
      private function resultChatHistory(param1:BinaryBuffer) : void
      {
         if(!Facade.isMyMap || !this.up.clan || Facade.boardMediator.isEditorMode)
         {
            return;
         }
         this.up.applyChatList(new Packet_0050_02(param1).value.re_evs);
         if(Facade.isMyMap && Facade.commonHash[this] is uint)
         {
            new ClanSocialMediator(this.myPanel.chatBt,true,Facade.commonHash[this]);
            delete Facade.commonHash[this];
         }
         else if(this.up.checkReadClanTime(this.up.checkClanRolePermission(PPermission.APPROVE)) > 0)
         {
            this.showMyClanNotify();
         }
      }
      
      private function onSettings(param1:MouseEvent = null) : void
      {
         Facade.mainMediator.showDialog(new SettingMediator());
      }
      
      public function changeOffer(param1:String, param2:* = null) : void
      {
         var _loc4_:Boolean = false;
         var _loc3_:OfferMediator = Facade.mainMediator.searchDialog(OfferMediator);
         if(param2)
         {
            if(!this.up.offerHash)
            {
               this.up.offerHash = new Dictionary();
            }
            this.up.offerHash[param1] = param2;
            _loc4_ = !this.myPanel.offerBt;
            this.myPanel.addOffer(param1);
            if(_loc4_)
            {
               this.myPanel.offerBt.init(this.openOfferDialog,this.swipeOffer,param1);
               this.swipeOffer(null);
            }
         }
         else
         {
            this.myPanel.removeOffer(param1);
            if(this.up.offerHash)
            {
               delete this.up.offerHash[param1];
            }
            if(Boolean(_loc3_) && _loc3_.kind == param1)
            {
               _loc3_.dialog.close();
               _loc3_ = null;
            }
         }
         if(_loc3_)
         {
            _loc3_.sync();
         }
      }
      
      public function openOfferDialog(param1:Object, param2:Boolean = false) : void
      {
         var _loc4_:String = null;
         if(param1 is MouseEvent)
         {
            _loc4_ = String(((param1 as MouseEvent).currentTarget as VButton).data);
            if(_loc4_ == QuestProxy.VK_SOCIAL_TANK)
            {
               Facade.callJS("openSpecialOffers");
               return;
            }
         }
         else
         {
            _loc4_ = String(param1);
         }
         var _loc3_:OfferMediator = Facade.mainMediator.searchDialog(OfferMediator);
         if(param2 && (!_loc3_ || _loc3_.kind != _loc4_))
         {
            return;
         }
         if(!_loc3_)
         {
            _loc3_ = new OfferMediator();
         }
         _loc3_.show(_loc4_);
      }
      
      public function swipeOffer(param1:Object) : void
      {
         var _loc4_:POffer = null;
         var _loc5_:PShopOffer = null;
         var _loc6_:PQuest = null;
         var _loc2_:OfferButton = this.myPanel.offerBt;
         if(!_loc2_ || _loc2_.data == param1)
         {
            return;
         }
         if(param1 is String)
         {
            _loc2_.data = param1;
            _loc2_.swipe = true;
         }
         else
         {
            param1 = this.myPanel.getOfferKind(_loc2_.data as String,1);
            if(param1 == "kind tanks-a")
            {
               if(this.myPanel.offerList.length <= 2)
               {
                  return;
               }
               param1 = this.myPanel.getOfferKind(param1 as String,1);
            }
            _loc2_.data = param1;
         }
         var _loc3_:Object = this.up.offerHash[_loc2_.data];
         if(_loc3_ is POffer)
         {
            _loc4_ = _loc3_ as POffer;
            _loc5_ = Facade.manualProxy.getOfferShop(_loc4_.offer_kind);
            _loc2_.sync(_loc4_.offer_kind,_loc5_.offer_duration + _loc4_.offer_start_time - CoreLogic.serverTime);
            if(_loc4_.offer_kind == OfferOk.kind)
            {
               OfferOk.setButtonIcon(_loc2_);
            }
            else
            {
               SkinManager.applyExternal(_loc2_.icon as VSkin,UIFactory.OFFER_PACK,_loc5_.offer_type,SkinManager.LOAD_CLIP);
            }
         }
         else
         {
            _loc6_ = _loc3_ as PQuest;
            if(QuestProxy.isLikeOffer(_loc6_.qname))
            {
               this.myPanel.offerBt.sync("like_title");
               SkinManager.applyExternal(_loc2_.icon as VSkin,"LikeDialog","LikeIcon",SkinManager.LOAD_CLIP);
            }
            else
            {
               this.myPanel.offerBt.sync(_loc6_.qname);
               SkinManager.applyExternal(_loc2_.icon as VSkin,_loc6_.qname,null,SkinManager.LOAD_CLIP | SkinManager.PNG);
            }
         }
      }
      
      public function onLink(param1:VEvent) : void
      {
         if(param1.data == "event:donate" && Facade.isMyMap && Boolean(this.up.clanData))
         {
            DialogLogic.openDonate();
         }
      }
      
      private function onRegentChange(param1:Array, param2:PSetRegent) : void
      {
         var _loc3_:PMember = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.user_base.user_id == param2.sr_regent)
            {
               _loc3_.territory_regent = param2.sr_ter_kind;
            }
            else if(_loc3_.territory_regent == param2.sr_ter_kind)
            {
               _loc3_.territory_regent = null;
            }
         }
      }
      
      public function syncRadarButton(param1:MouseEvent = null) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Build = null;
         if(param1)
         {
            this.toRadar();
         }
         else
         {
            _loc2_ = this.up.radarEnabled && Facade.isMyMap;
            this.myPanel.useRadarButton(_loc2_ ? this.syncRadarButton : null);
            this.myPanel.ratingPanel.setPremiumArrow(_loc2_);
            this.myPanel.oilPanel.setPremiumArrow(_loc2_);
            this.myPanel.crystalPanel.setPremiumArrow(_loc2_);
            this.myPanel.energyPanel.setPremiumArrow(_loc2_);
            if(this.myPanel.radarTimer)
            {
               this.myPanel.radarTimer.addBuyBt(Facade.myMediator.toRadar);
               Signal.createRef(this.myPanel.radarTimer,this.onRadarTimerSignal,Signal.ADD_TIMER).run(0,this.up.base.scouting,true);
            }
            _loc3_ = this.up.buildList.head as Build;
            while(_loc3_)
            {
               if(Facade.isMyMap && _loc3_.type == PBtype.RESOURCE && (_loc3_.spec as VOResourceSpec).prodVariance != PCost.GOLD)
               {
                  ActionLogic.statusResource(_loc3_);
               }
               _loc3_ = _loc3_.link_next as Build;
            }
         }
      }
      
      private function onRadarTimerSignal(param1:Signal) : void
      {
         if(param1.tail > 0 && Boolean(this.myPanel.radarTimer))
         {
            this.myPanel.radarTimer.setCustom(StringHelper.getTimeDesc(param1.tail));
         }
      }
      
      public function toRadar(param1:MouseEvent = null) : void
      {
         var _loc2_:Build = Facade.userProxy.getBuildEx(PBtype.SCOUTING,false);
         if(_loc2_)
         {
            if(_loc2_.updateLevel != 0)
            {
               Facade.boardMediator.setSelected(_loc2_);
               Facade.boardMediator.smoothMoveBoard(_loc2_.t_x,_loc2_.t_y);
               AbstractTrain.assignStep(new DownStep(MyMediator.speedupBt,180,{
                  "hCenter":0,
                  "bottom":0
               }));
            }
            else
            {
               this.syncRadarButton();
               Facade.mainMediator.showDialog(new RadarMediator());
            }
         }
         else
         {
            Facade.mainMediator.showDialog(new ShopMediator(ShopMediator.RESOURCE,"bl_scouting_hh"));
         }
      }
      
      public function showRequests() : void
      {
         var _loc1_:VButton = this.myPanel.chatBt;
         if(_loc1_)
         {
            if(_loc1_.data is ClanSocialMediator)
            {
               (_loc1_.data as ClanSocialMediator).toRequestsTab();
            }
            else
            {
               MyPanel.changeButtonCount(_loc1_,0);
               new ClanSocialMediator(_loc1_,true);
            }
         }
         else if(this.up.clan)
         {
            Facade.commonHash[this] = 0;
         }
      }
      
      private function getEnergyHint() : String
      {
         var _loc1_:Number = this.up.energyMax - this.up.energy;
         if(_loc1_ > 0)
         {
            _loc1_ = CoreLogic.getActionTimeLeft(ActionLogic.RECOVERY_ENERGY) + (_loc1_ - 1) * Facade.userProxy.getEnergyCooldown();
         }
         return "<p" + Style.metalColor + ">" + StringHelper.getTLFImage("lib,Energy",20) + Lang.getString("energyN") + "</p><p>" + Lang.getString("energyN_desc") + "</p><p" + Style.metalColor + ">" + Lang.getPatternString("energy_max","__VALUE__",this.up.energyMax.toString()) + (_loc1_ > 0 ? "</p><p" + Style.greenColor + ">" + Lang.getPatternString("energy_recovery","__TIME__",StringHelper.getTimeDesc(_loc1_,true)) + "</p>" : "</p>") + (this.up.radarEnabled ? "<p" + Style.greenColor + ">" + StringHelper.getTLFImage("lib,PremiumArrowIcon",18) + Lang.getString("scout_energy_hint") + "</p>" : "");
      }
      
      private function onEnergy(param1:CommonEvent = null) : void
      {
         Facade.mainMediator.syncHint(this.myPanel.energyPanel);
         this.myPanel.energyPanel.setData(this.up.energy);
         this.myPanel.useEnergyPlay(this.up.energy < this.up.energyMax);
      }
      
      public function onAlinkEnergy(param1:MouseEvent = null) : void
      {
         var _loc2_:Array = Facade.manualProxy.energyShopList;
         var _loc3_:int = this.up.energyMax - this.up.energy;
         var _loc4_:AlinkDialog = new AlinkDialog();
         var _loc5_:Number = Facade.userProxy.getEnergyCooldown();
         _loc4_.useEnergyMode(_loc3_ > 0 ? CoreLogic.getActionTimeLeft(ActionLogic.RECOVERY_ENERGY) + (_loc3_ - 1) * _loc5_ : 0,_loc5_,_loc2_[0],_loc2_[1]);
         Facade.mainMediator.showDialog(_loc4_);
      }
   }
}

