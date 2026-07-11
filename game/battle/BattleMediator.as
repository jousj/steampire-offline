package game.battle
{
   import engine.Isometric;
   import engine.Position;
   import engine.data.MapCell;
   import engine.signal.Signal;
   import engine.units.*;
   import flash.display.StageQuality;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import game.battle.common.RivalPanel;
   import game.battle.drop.DropPanel;
   import game.battle.drop.PowerBuyDialog;
   import game.battle.raid.RaidMemberRenderer;
   import game.battle.result.BattleResultMediator;
   import game.battle.result.StormResultDialog;
   import game.missions.EventMapMediator;
   import game.my.GoMediator;
   import game.quest.NewStoryDialog;
   import game.quest.StoryDialog;
   import game.shop.AlinkDialog;
   import logic.*;
   import logic.battle.SimBaseVisual;
   import logic.battle.SimVisual;
   import logic.sim.Sim;
   import logic.sim.SimUnitT;
   import logic.training.*;
   import logic.training.firstsession.BossTrain;
   import logic.training.firstsession.Mission0NewestTrain;
   import logic.training.firstsession.Mission1NewTrain;
   import logic.training.firstsession.Mission2NewTrain;
   import logic.training.firstsession.RaidNewTrain;
   import logic.units.BuildLogic;
   import model.BattleProxy;
   import model.CommonEvent;
   import model.ManualProxy;
   import model.UserProxy;
   import model.ui.VOBattleItem;
   import model.ui.VOWinItem;
   import model.vo.VORaidMember;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.game.family_0010.*;
   import proto.game.family_0020.Packet_0020_09;
   import proto.game.family_0050.Packet_0050_03;
   import proto.game.family_0060.*;
   import proto.model.*;
   import proto.model.clan.PTerritoryCommand;
   import proto.tuples.str_Position;
   import ui.load.WaitStormPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import utils.CostHelper;
   
   public class BattleMediator
   {
      
      public static const REPLAY:uint = uint.MAX_VALUE;
      
      public static const SELF:uint = 500;
      
      public static const CMD_RAID_VECTOR:uint = 10000;
      
      public static const CMD_RAID_AUTO:uint = 10001;
      
      public static const CMD_WORKER:uint = 100002;
      
      public const bp:BattleProxy = new BattleProxy();
      
      public const myCommandList:Array = [];
      
      public const soldierDp:Array = [];
      
      public var train:uint;
      
      public var isBoss:Boolean = false;
      
      public var rivalPanel:RivalPanel;
      
      public var visitorPanel:VisitorPanel;
      
      public var battlePanel:BattlePanel;
      
      public var dropPanel:DropPanel;
      
      public var targetInfo:PTargetInfo;
      
      public var sim:Sim;
      
      public var selectItem:VOBattleItem;
      
      public var isAudioTheme:Boolean;
      
      public var isRaid:Boolean;
      
      public var heroRaid:Boolean;
      
      public var isStorm:Boolean;
      
      public var isTerritoryStorm:Boolean;
      
      public var isAttacker:Boolean;
      
      public var isDefender:Boolean;
      
      public var membersProxy:RaidMembersProxy;
      
      public var simVisual:SimVisual;
      
      public var reloadCount:uint;
      
      public var staminaKoef:Number = 1;
      
      private const up:UserProxy = Facade.userProxy;
      
      private const mp:ManualProxy = Facade.manualProxy;
      
      private const timerSignal:Signal = new Signal(null,Signal.ADD_PERIOD);
      
      private const simSignal:Signal;
      
      private const waitCommandList:Vector.<PCommand> = new Vector.<PCommand>();
      
      private const requestControl:BattleRequestControl = new BattleRequestControl();
      
      private const F_RUN:uint = 0;
      
      private const F_SPEEDUP:uint = 1;
      
      private const F_SURRENDER:uint = 50;
      
      private const F_END:uint = 100;
      
      private const F_SOLDIER:uint = 101;
      
      private const F_TIME:uint = 102;
      
      private const F_CONSTRUCTION:uint = 103;
      
      private var useStormWait:Boolean;
      
      private var runMode:uint;
      
      private var fightType:uint;
      
      private var startTime:Number;
      
      private var stopTime:Number;
      
      private var lastSimTime:int;
      
      private var soldierLimit:int;
      
      private var battleDuration:Number;
      
      private var nextDamageTime:int;
      
      private var adventure:PCurrentAdventure;
      
      private var isSpeedUpMe:Boolean = false;
      
      public function BattleMediator()
      {
         this.simSignal = new Signal(this.onBattleSim);
         super();
         this.simSignal.delay = 0.01;
         this.timerSignal.delay = 1;
      }
      
      public function get curSimTime() : int
      {
         return (CoreLogic.getSignalTime(true) - this.startTime) * 1000 + 1;
      }
      
      public function getSimulateTime(param1:int) : Number
      {
         return this.startTime + param1 / 1000;
      }
      
      public function visit(param1:PTargetInfo, param2:PStorm = null, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc5_:PShopTerritory = null;
         var _loc6_:PClanDivision = null;
         var _loc7_:PFightType = null;
         var _loc8_:uint = 0;
         if(!this.visitorPanel)
         {
            this.visitorPanel = new VisitorPanel();
            this.visitorPanel.addEventListener(VEvent.VARIANCE,this.onVariance);
            this.rivalPanel = this.visitorPanel.rivalPanel;
            this.battlePanel = new BattlePanel();
            this.dropPanel = this.battlePanel.dropPanel;
            this.dropPanel.addListener(VEvent.SELECT,this.onDropSelect);
            this.dropPanel.spellGrid.addListener(VEvent.VARIANCE,this.onSpellBlock);
         }
         if(param2)
         {
            _loc4_ = 0;
            if(param2.storm_territory)
            {
               _loc5_ = Facade.manualProxy.getTerritoryShop(param2.storm_territory.st_ter_kind);
               _loc6_ = Facade.manualProxy.getClanDivision(_loc5_.ter_region);
               _loc4_ = int(_loc6_.cd_num);
            }
            else
            {
               _loc4_ = param2.storm_tclan_base.division;
            }
            switch(_loc4_)
            {
               case 2:
                  EventMapMediator.setBg("map_bg_jaina");
                  break;
               case 4:
                  EventMapMediator.setBg("map_bg_winter");
                  break;
               case 5:
                  EventMapMediator.setBg("map_bg_winter");
            }
            this.rivalPanel.assignStorm(param2.storm_tclan_base,param2.storm_territory);
         }
         else
         {
            _loc7_ = param1.ti_fight_type;
            _loc8_ = _loc7_.variance;
            if(_loc8_ == PFightType.JAINA_MISSION)
            {
               this.initJaina(_loc7_);
            }
            else if(_loc8_ == PFightType.ADVENTURE)
            {
               this.initJaina(_loc7_);
               _loc7_.variance = PFightType.JAINA_MISSION;
            }
            this.rivalPanel.assign(_loc7_,param1.ti_user_base,_loc8_ == PFightType.EXT_MISSION ? Lang.getString(this.up.getMissionExKind(_loc7_.value,true) + "_ex") : null,param3);
            if(_loc8_ == PFightType.SINGLE)
            {
               this.rivalPanel.setSingleInfo(param1.ti_user_base.scouting > CoreLogic.serverTime,this.mp.getLeagueShop(param1.ti_user_base.level).division_num);
            }
         }
         if(!Facade.isBattle)
         {
            if(Boolean(!this.up.missionPercentageList) && Boolean(param1.ti_fight_type.value) && param1.ti_fight_type.value.indexOf("mission") != -1)
            {
               Facade.protoProxy.request(new Packet_0010_0B(),this.resultPercentage,0,0,[param1]);
            }
            this.up.crystal = param1.ti_crystal;
            this.up.oil = param1.ti_oil;
            this.rivalPanel.oilTargetPanel.setDataEx(this.up.oil,this.up.oilMax);
            this.rivalPanel.crystalTargetPanel.setDataEx(this.up.crystal,this.up.crystalMax);
            BuildLogic.calcStorage();
            this.visitorPanel.useHome();
         }
         Facade.mainPanel.showCommonPanel(this.visitorPanel);
         if(Facade.fakeResize)
         {
            this.visitorPanel.rightBox.scaleX = this.visitorPanel.rightBox.scaleY = this.rivalPanel.scaleX = this.rivalPanel.scaleY = 0.85;
            this.visitorPanel.rightBox.right = -27;
         }
      }
      
      private function resultPercentage(param1:BinaryBuffer, param2:PTargetInfo) : void
      {
         var _loc3_:PMissionPercentage = null;
         this.up.missionPercentageList = new Packet_0010_0C(param1).value;
         for each(_loc3_ in this.up.missionPercentageList)
         {
            if(_loc3_.mp_mission_kind == param2.ti_fight_type.value)
            {
               break;
            }
         }
         if(Boolean(_loc3_) && _loc3_.mp_mission_kind != param2.ti_fight_type.value)
         {
            _loc3_ = null;
            return;
         }
         this.up.crystal = param2.ti_crystal * _loc3_.mp_cry_perc;
         this.up.oil = param2.ti_oil * _loc3_.mp_oil_perc;
         this.rivalPanel.oilTargetPanel.setDataEx(this.up.oil,this.up.oilMax);
         this.rivalPanel.crystalTargetPanel.setDataEx(this.up.crystal,this.up.crystalMax);
         BuildLogic.calcStorage();
      }
      
      private function initRaid(param1:PGroupFightInfo) : String
      {
         this.membersProxy = new RaidMembersProxy();
         this.membersProxy.assignUserBaseList(param1.fgi_members,param1.fgi_units_levels,this.heroRaid);
         this.visitorPanel.setRaidMembers(this.membersProxy.list,this.onVariance);
         if(Facade.checkUserStage("tryRaid1_group_search"))
         {
            Facade.changeUserStage("tryRaid1_start");
         }
         return param1.fgi_mission_kind;
      }
      
      public function syncRaidMembers() : void
      {
         if(this.visitorPanel.raidGrid)
         {
            this.visitorPanel.raidGrid.sync();
         }
      }
      
      public function get isJoinAttacker() : Boolean
      {
         return this.isAttacker && Boolean(this.targetInfo.ti_attacker_info);
      }
      
      private function get isWaitAttacker() : Boolean
      {
         return this.isAttacker && !this.targetInfo.ti_attacker_info;
      }
      
      private function initStorm(param1:PStorm) : void
      {
         var _loc2_:PShopTerritory = null;
         this.up.crystal = param1.storm_my_crystal;
         this.up.oil = param1.storm_my_oil;
         this.up.gold = param1.storm_my_gold;
         this.up.energy = param1.storm_my_calls;
         this.bp.storm = param1;
         this.bp.stormId = this.isTerritoryStorm ? param1.storm_territory.st_ter_kind : param1.storm_tclan_base.id;
         if(this.isWaitAttacker)
         {
            if(param1.storm_members.length < Facade.references.wp_wave_members_count)
            {
               this.battlePanel.showStormPanel(this.onStormJoin,param1.storm_my_hspace,Math.ceil(Facade.references.raid_units_min_perc / 100 * param1.storm_my_full_hspace));
            }
            else
            {
               this.battlePanel.showStormPanel();
            }
         }
         else if(!this.isAttacker && !this.isDefender)
         {
            this.battlePanel.showStormPanel(null,-1);
         }
         if(this.isTerritoryStorm)
         {
            _loc2_ = Facade.manualProxy.getTerritoryShop(param1.storm_territory.st_ter_kind);
            this.staminaKoef = param1.storm_territory.st_regent ? this.mp.getMineShop(_loc2_.ter_region,param1.storm_territory.st_ter_level).mine_stamina_koef : 1;
         }
         this.rivalPanel.showWarTime(param1.storm_end_time < this.startTime + this.battleDuration ? this.startTime + this.battleDuration : param1.storm_end_time);
      }
      
      public function init(param1:PTargetInfo, param2:uint, param3:PCurrentFight, param4:uint, param5:PStorm) : void
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         this.runMode = this.F_RUN;
         this.useStormWait = false;
         this.targetInfo = param1;
         this.train = param2;
         this.visitorPanel.add(this.battlePanel);
         this.isAudioTheme = param2 != REPLAY;
         this.fightType = param1.ti_fight_type.variance;
         var _loc6_:PAttackerInfo = param1.ti_attacker_info;
         var _loc7_:Boolean = Boolean(param3);
         if(_loc7_)
         {
            param3.fight_commands.sort(this.commandSort);
         }
         if(param5)
         {
            this.isRaid = this.isStorm = true;
            this.isTerritoryStorm = Boolean(param5.storm_territory);
            if(param4 == 0)
            {
               if(this.isTerritoryStorm)
               {
                  this.isAttacker = Boolean(this.up.clan) && this.up.clan.uc_clan_id == param5.storm_territory.st_attacker_clan_id;
                  this.isDefender = !this.isAttacker && Boolean(this.up.clan) && this.up.clan.uc_clan_id == param5.storm_territory.st_owner_clan_id;
               }
               else
               {
                  this.isAttacker = !this.up.clan || param5.storm_tclan_base.id != this.up.clan.uc_clan_id;
                  this.isDefender = !this.isAttacker;
               }
            }
            else
            {
               this.isAttacker = this.isDefender = false;
            }
            this.battleDuration = Facade.references.wp_wave_duration;
            this.initStorm(param5);
         }
         else
         {
            this.isRaid = this.fightType == PFightType.GROUP;
            if(this.isRaid)
            {
               this.battleDuration = Facade.references.max_raid_time;
               if((param1.ti_fight_type.value as PGroupFightInfo).fgi_raid_kind == "rd_bosses")
               {
                  this.heroRaid = true;
                  for(_loc9_ in this.up.soldierCountHash)
                  {
                     if(_loc9_ != "un_hero")
                     {
                        this.up.soldierCountHash[_loc9_] = 0;
                     }
                  }
               }
            }
            else
            {
               this.battleDuration = Facade.references.max_fight_time;
            }
            if(_loc6_)
            {
               this.up.energy = _loc6_.ai_calls;
               this.up.gold = _loc6_.ai_gold;
            }
            this.bp.calcSteal(param1,this.up.buildList);
         }
         if(this.staminaKoef > 1)
         {
            UnitFactory.applyStaminaMultiplier(this.staminaKoef);
         }
         Facade.boardMediator.battleDrop.vectorNum = this.isRaid ? 1 : 0;
         this.rivalPanel.initResources(this.bp.oil,this.bp.crystal);
         this.soldierLimit = -1;
         if(param2 == REPLAY)
         {
            this.bp.allowHSpace = int.MAX_VALUE;
            this.battlePanel.timerPanel.useReplayButtons = true;
            this.visitorPanel.useHome();
         }
         else
         {
            if(_loc6_)
            {
               this.assignDropDp(_loc7_ ? param3.fight_commands : null,this.isRaid,_loc6_);
            }
            this.bp.allowHSpace = 750;
         }
         this.dropPanel.usePower = this.isStorm ? this.isAttacker : this.bp.startPower > 0;
         if(this.isRaid)
         {
            _loc8_ = this.initRaid(param1.ti_fight_type.value as PGroupFightInfo);
            this.bp.raidDropCapacity = 0;
            this.bp.isHeroDrop = false;
            if(this.isStorm && !this.isJoinAttacker)
            {
               this.visitorPanel.useHome();
            }
         }
         else if(this.fightType == PFightType.MISSION || this.fightType == PFightType.EXT_MISSION || this.fightType == PFightType.JAINA_MISSION)
         {
            _loc8_ = param1.ti_fight_type.value;
            if(param2 == 0 && !_loc7_)
            {
               this.visitorPanel.useHome();
            }
         }
         else if(this.fightType == PFightType.SINGLE && param2 == 0 && !_loc7_)
         {
            this.rivalPanel.showRatio(param1.ti_inc_ratio,param1.ti_dec_ratio);
            if(param4 == 0)
            {
               this.visitorPanel.useNextPvP(this.up.crystal,this.mp.getTownHallUnlock(_loc6_.ai_townhall_level));
            }
            else
            {
               this.visitorPanel.useHome();
            }
         }
         Facade.board.addEventListener(MouseEvent.ROLL_OVER,this.onBoardRoll);
         Facade.board.addEventListener(MouseEvent.ROLL_OUT,this.onBoardRoll);
         if(param2 > 0 && param2 <= 5)
         {
            AbstractTrain.assign(this.getTrain(param2));
            this.startBattle();
         }
         else
         {
            if(_loc8_)
            {
               this.bp.mission = this.mp.getMissionInfo(_loc8_);
               if(!_loc7_)
               {
                  if(this.bp.mission.mi_tunits.length > 0)
                  {
                     this.addDefenderSoldiers();
                  }
               }
            }
            if(this.fightType != PFightType.JAINA_MISSION)
            {
               this.bp.assignWinList(param1.ti_um.buildings,this.up.constructionHash);
               this.battlePanel.setWinTarget(this.bp.winList,this.onToWinTarget);
               if(this.isBoss && param2 != REPLAY)
               {
                  AbstractTrain.assign(new BossRegularTrain(this.up.getBossKind()));
               }
               if(param2 == SELF)
               {
                  this.battlePanel.timerPanel.useReplayButtons = true;
                  this.visitorPanel.useHome();
                  this.startBattle();
               }
            }
            else
            {
               this.bp.assignWinList(null,null);
               this.validJainaWinList();
               this.battlePanel.setWinTarget(null,null);
            }
         }
         this.nextDamageTime = 0;
         if(_loc7_)
         {
            this.resume(param3.fight_commands,param3.fight_time / 1000);
            if(this.runMode == this.F_RUN && this.isRaid)
            {
               if(this.isStorm && this.bp.winList.length > 0 && (this.bp.winList[0] as VOWinItem).count == 0)
               {
                  this.useLastStormWait();
               }
               else if(this.runMode == 0)
               {
                  if(param3.fight_commands.length > 0)
                  {
                     this.syncRaidMembers();
                  }
                  Facade.gameStream.assign(param1.ti_time_now,this.onGameStream);
                  if(this.isStorm)
                  {
                     if(this.isDefender)
                     {
                        this.assignWorkerSpell(param5.storm_has_free_worker,param3.fight_commands,param3.fight_time);
                     }
                     if(param5.storm_territory)
                     {
                        Facade.gameStream.run(PEventPlace.TERRITORY,param5.storm_territory.st_ter_kind);
                     }
                     else if(this.isAttacker || this.isDefender)
                     {
                        Facade.gameStream.run(this.isAttacker ? PEventPlace.ENEMY_CAPITAL : PEventPlace.MY_CAPITAL,param5.storm_tclan_base.id);
                     }
                     else
                     {
                        Facade.gameStream.run(PEventPlace.OTHER_CAPITAL,param5.storm_tclan_base.id);
                     }
                  }
                  else
                  {
                     Facade.gameStream.run(PEventPlace.NOTHING);
                  }
               }
            }
         }
         else if(param2 == 0)
         {
            this.battlePanel.changeTimer(true,1);
            this.timerSignal.handler = this.onPreBattleSim;
            this.timerSignal.run(Facade.references.fight_prepare_time,0,true,true);
         }
         this.rivalPanel.damagePanel.value = this.getDamage();
         if(this.sim)
         {
            this.simVisual.changePower(this.sim.data.power,0);
         }
         else
         {
            this.dropPanel.powerPanel.setData(this.bp.startPower);
            this.dropPanel.powerPanel.removeBuyBt();
         }
         Facade.boardMediator.setBattleOver(!this.sim);
      }
      
      private function getTrain(param1:uint) : AbstractTrain
      {
         switch(param1)
         {
            case 1:
               return new Mission0NewestTrain();
            case 2:
               return new Mission1NewTrain();
            case 3:
               return new BossTrain();
            case 4:
               return new Mission2NewTrain();
            default:
               return new RaidNewTrain();
         }
      }
      
      private function getDamage() : uint
      {
         if(this.fightType == PFightType.JAINA_MISSION)
         {
            return this.getJainaDamage();
         }
         return this.sim ? this.sim.getDamage() : 0;
      }
      
      private function getJainaDamage() : uint
      {
         var _loc1_:uint = this.targetInfo.ti_um.buildings.length + this.targetInfo.ti_um.cannons.length;
         if(this.sim)
         {
            _loc1_ -= this.sim.data.rmBuildCount + this.sim.data.rmCannonCount;
         }
         var _loc2_:uint = uint(this.bp.mission.mi_init_obj_cnt);
         return (_loc2_ - _loc1_) / _loc2_ * 100;
      }
      
      private function initJaina(param1:PFightType) : void
      {
         var _loc2_:PJainaMissionInfo = null;
         var _loc3_:PJainaMission = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1.value is PJainaMission)
         {
            _loc3_ = param1.value;
            _loc4_ = _loc3_.event_id;
            this.staminaKoef = _loc3_.jaina_event.je_stamina_koef;
            _loc5_ = _loc3_.jaina_event.je_mission;
            if(_loc3_.jaina_event.je_mission_finished)
            {
               _loc5_++;
            }
         }
         else
         {
            this.adventure = param1.value;
            _loc4_ = this.adventure.event_id;
            this.staminaKoef = 1 + Facade.references.adventure_perc_per_level * this.adventure.adventure_level;
            _loc5_ = this.adventure.mission_num;
         }
         for each(_loc2_ in this.mp.jainaMissionList)
         {
            if(_loc2_.jmi_event_id == _loc4_ && _loc2_.jmi_number == _loc5_)
            {
               break;
            }
         }
         param1.value = _loc2_.jmi_mission;
         EventMapMediator.applyBg(_loc4_);
      }
      
      private function validJainaWinList() : void
      {
         var _loc1_:VOWinItem = null;
         var _loc2_:PMissionWin = null;
         var _loc3_:uint = 0;
         for each(_loc1_ in this.bp.winList)
         {
            _loc2_ = _loc1_.info;
            _loc3_ = this.up.getConstructionCount(_loc2_.mw_kind);
            if(_loc3_ < _loc2_.mw_count)
            {
               _loc1_.info = PMissionWin.create(_loc2_.mw_kind,_loc2_.mw_level,_loc3_);
               _loc1_.count = _loc3_;
            }
         }
      }
      
      public function onToWinTarget(param1:VEvent) : void
      {
         var _loc3_:Unit = null;
         var _loc2_:String = (param1.data as VOWinItem).info.mw_kind;
         for each(_loc3_ in this.up.constructionHash)
         {
            if(_loc3_.kind == _loc2_)
            {
               Facade.boardMediator.moveBoard(_loc3_.b_x,_loc3_.b_y);
               break;
            }
         }
      }
      
      private function onBoardRoll(param1:MouseEvent) : void
      {
         this.battlePanel.isCursor = param1.type == MouseEvent.ROLL_OVER;
         this.battlePanel.syncCursor(this.selectItem);
      }
      
      public function clear() : void
      {
         if(this.rivalPanel)
         {
            this.rivalPanel.setSingleInfo(false,0);
         }
         if(!this.targetInfo)
         {
            return;
         }
         this.heroRaid = false;
         this.selectItem = null;
         Facade.mainPanel.applyCursor(null);
         Facade.board.removeEventListener(MouseEvent.ROLL_OVER,this.onBoardRoll);
         Facade.board.removeEventListener(MouseEvent.ROLL_OUT,this.onBoardRoll);
         this.requestControl.clear();
         if(this.isRaid)
         {
            this.isRaid = false;
            if(this.isStorm)
            {
               this.isStorm = this.isTerritoryStorm = false;
               this.battlePanel.hideStormPanel();
               this.rivalPanel.hideWarTime();
            }
            this.visitorPanel.setRaidMembers(null);
            this.membersProxy = null;
         }
         this.sim = null;
         if(this.simVisual)
         {
            this.simVisual.clear();
            this.simVisual = null;
         }
         this.timerSignal.stop();
         this.simSignal.stop();
         this.soldierDp.length = 0;
         this.waitCommandList.length = 0;
         this.myCommandList.length = 0;
         this.bp.clear();
         this.runMode = this.F_END;
         this.isBoss = false;
         this.staminaKoef = 1;
         this.adventure = null;
         this.battlePanel.clear();
         this.visitorPanel.clear();
         if(this.train > 0)
         {
            this.battlePanel.timerPanel.useReplayButtons = false;
         }
         this.targetInfo = null;
         this.changeQuality(false);
         if(this.fightType == PFightType.JAINA_MISSION || this.fightType == PFightType.STORM)
         {
            Facade.board.changeMapBg();
         }
      }
      
      private function changeQuality(param1:Boolean) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         if(param1)
         {
            _loc2_ = StageQuality.MEDIUM;
            _loc3_ = Facade.isNormalQuality ? 24 : 20;
         }
         else
         {
            _loc2_ = StageQuality.HIGH;
            _loc3_ = 30;
         }
         Facade.stage.quality = _loc2_;
         Facade.fpsControl.applyFrameRate(_loc3_);
      }
      
      private function assignDropDp(param1:Array, param2:Boolean, param3:PAttackerInfo) : void
      {
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc10_:String = null;
         var _loc11_:uint = 0;
         var _loc12_:PCommand = null;
         var _loc13_:PUnitCommand = null;
         var _loc14_:PShopLibrary = null;
         var _loc15_:VOBattleItem = null;
         var _loc4_:Boolean = Boolean(param1);
         if((_loc4_) && param2)
         {
            _loc10_ = Preloader.uid;
         }
         var _loc5_:uint = 0;
         for(_loc6_ in this.up.soldierCountHash)
         {
            _loc11_ = uint(this.up.soldierCountHash[_loc6_]);
            if(_loc11_ > 0)
            {
               if(_loc4_)
               {
                  for each(_loc12_ in param1)
                  {
                     if(_loc12_.cm_kind.variance == PCommandKind.UNIT && (!param2 || _loc12_.cm_user_id == _loc10_))
                     {
                        _loc13_ = _loc12_.cm_kind.value;
                        if(_loc13_.pucm_kind == _loc6_)
                        {
                           _loc5_ += _loc13_.pucm_count;
                           _loc11_ = _loc13_.pucm_count > _loc11_ ? 0 : uint(_loc11_ - _loc13_.pucm_count);
                        }
                     }
                  }
                  if(_loc11_ == 0)
                  {
                     continue;
                  }
               }
               this.soldierDp.push(new VOBattleItem().assignSoldier(this.mp.getSoldierShop(_loc6_),_loc11_));
            }
         }
         this.soldierDp.sort(VOBattleItem.sort);
         _loc7_ = [];
         if(param3.ai_library_level > 0)
         {
            _loc14_ = this.mp.getLibraryShop(param3.ai_library_level);
            this.bp.startPower = _loc14_.sl_start_power + this.up.ruby;
            for each(_loc6_ in param3.ai_spells)
            {
               _loc7_.push(new VOBattleItem().assignSpell(this.mp.getSpellShop(_loc6_)));
            }
            _loc7_.sort(VOBattleItem.sort);
            if(param3.ai_spells.length < _loc14_.sl_book_size)
            {
               _loc7_.push(new VOBattleItem().assignSpell(null,true,true));
            }
         }
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         if(param2 && (!this.isStorm || this.isAttacker))
         {
            _loc9_ = Facade.references.raid_max_units_count;
            if(_loc5_ < _loc9_)
            {
               for each(_loc15_ in this.soldierDp)
               {
                  _loc8_ += _loc15_.count;
               }
               _loc8_ += _loc5_;
               if(_loc8_ > _loc9_)
               {
                  _loc8_ = _loc9_ - _loc5_;
               }
               else
               {
                  _loc9_ = 0;
               }
            }
         }
         if(_loc9_ > 0)
         {
            this.dropPanel.useLimiter(_loc8_,_loc9_);
            if(_loc8_ == 0)
            {
               this.dropPanel.soldierLock = true;
            }
            this.soldierLimit = _loc8_;
         }
         if(this.soldierDp.length > 0 || _loc7_.length > 0)
         {
            this.battlePanel.useDropPanel(true);
            this.dropPanel.setSpellDp(_loc7_);
            this.dropPanel.update(this.soldierDp);
         }
      }
      
      private function assignWorkerSpell(param1:Boolean, param2:Array, param3:uint) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:PCommand = null;
         var _loc10_:PSpellCommand = null;
         var _loc4_:VOBattleItem = new VOBattleItem().assignSpell(this.mp.getSpellShop("sp_worker",this.bp.thLevel),true,!param1);
         var _loc5_:uint = _loc4_.workerDuration;
         var _loc6_:VOBattleItem = new VOBattleItem().assignSpell(this.mp.getSpellShop("sp_worker_gold",this.bp.thLevel),true);
         var _loc7_:uint = _loc6_.workerDuration;
         for each(_loc9_ in param2)
         {
            if(_loc9_.cm_kind.variance == PCommandKind.SPELL && _loc9_.cm_user_id == Preloader.uid)
            {
               _loc10_ = _loc9_.cm_kind.value as PSpellCommand;
               if(_loc10_.pscm_kind == _loc4_.spellShop.ssp_kind)
               {
                  _loc8_ = _loc9_.cm_time + _loc5_;
                  if(_loc8_ > _loc4_.waitTime)
                  {
                     _loc4_.waitTime = _loc8_;
                  }
               }
               else if(_loc10_.pscm_kind == _loc6_.spellShop.ssp_kind)
               {
                  _loc8_ = _loc9_.cm_time + _loc7_;
                  if(_loc8_ > _loc6_.waitTime)
                  {
                     _loc6_.waitTime = _loc8_;
                  }
               }
            }
         }
         if(_loc4_.waitTime > param3)
         {
            this.addWaitCommand(PCommand.create(PCommandKind.create(CMD_WORKER,_loc4_),_loc4_.waitTime,null));
         }
         else
         {
            _loc4_.waitTime = 0;
         }
         if(_loc6_.waitTime > param3)
         {
            this.addWaitCommand(PCommand.create(PCommandKind.create(CMD_WORKER,_loc6_),_loc6_.waitTime,null));
         }
         else
         {
            _loc6_.waitTime = 0;
         }
         if(this.dropPanel.useResource(param1))
         {
            this.dropPanel.crystalPanel.addBuyBt(this.onResourceBuy);
            this.dropPanel.goldPanel.addBuyBt(this.onResourceBuy);
         }
         this.battlePanel.useDropPanel(true);
         this.dropPanel.setSpellDp([_loc4_,_loc6_]);
         this.dropPanel.update(this.soldierDp);
      }
      
      public function syncDropDp() : void
      {
         var _loc1_:Boolean = this.soldierDp.length > 0 || this.dropPanel.spellGrid.length > 0;
         this.battlePanel.useDropPanel(_loc1_);
         if(_loc1_)
         {
            this.dropPanel.update(this.soldierDp);
         }
      }
      
      public function syncResourcePanel(param1:uint) : void
      {
         if(param1 == PCost.CRYSTAL)
         {
            this.rivalPanel.crystalMyPanel.setData(this.bp.stealCrystal);
            this.rivalPanel.crystalTargetPanel.setData(this.bp.crystal);
         }
         else if(param1 == PCost.OIL)
         {
            this.rivalPanel.oilMyPanel.setData(this.bp.stealOil);
            this.rivalPanel.oilTargetPanel.setData(this.bp.oil);
         }
      }
      
      public function resume(param1:Array, param2:Number) : void
      {
         var _loc3_:SimBaseVisual = null;
         var _loc4_:PCommand = null;
         if(!this.sim)
         {
            this.startBattle();
         }
         CoreLogic.changeTime(param2);
         if(param1.length > 0)
         {
            _loc3_ = new SimBaseVisual(this.simVisual.deathSoldierDp);
            this.simVisual.curTime = _loc3_.curTime = this.lastSimTime = param2 * 1000;
            this.sim.changeSimRun(_loc3_);
            this.calcPower(param1);
            for each(_loc4_ in param1)
            {
               if(_loc4_.cm_time <= this.lastSimTime)
               {
                  this.parseCommand(_loc4_);
               }
               else
               {
                  this.addWaitCommand(_loc4_);
               }
            }
            if(this.sim.processQueueToTime(this.lastSimTime) || this.runMode >= this.F_SOLDIER)
            {
               this.runMode = this.F_END;
            }
            this.sim.changeSimRun(this.simVisual);
            this.syncResourcePanel(PCost.CRYSTAL);
            this.syncResourcePanel(PCost.OIL);
            this.simVisual.applyResume(this.up.buildList.head as Build,this.sim.data);
            if((this.bp.checkWinList(this.targetInfo.ti_um,this.sim.data) || this.fightType == PFightType.JAINA_MISSION) && this.train == 0)
            {
               this.useSpeedup();
            }
            this.battlePanel.syncWinTargets();
         }
         if(this.isRaid)
         {
            this.syncRaidSpeedup(null);
            if(this.soldierLimit >= 0)
            {
               this.dropPanel.setLimit(this.soldierLimit);
            }
            if(!this.isStorm && param2 < Facade.references.auto_command_time)
            {
               this.addWaitCommand(PCommand.create(PCommandKind.create(CMD_RAID_AUTO,null),Facade.references.auto_command_time * 1000,Preloader.uid));
            }
         }
         if(this.runMode <= this.F_SPEEDUP)
         {
            this.timerSignal.run(this.battleDuration - param2,0,true,true);
         }
      }
      
      private function useSpeedup() : void
      {
         var _loc1_:VORaidMember = null;
         if(!this.isBoss)
         {
            this.visitorPanel.useSpeedup();
         }
         this.isSpeedUpMe = true;
         if(this.membersProxy)
         {
            for each(_loc1_ in this.membersProxy.list)
            {
               if(_loc1_.isBotFinish())
               {
                  this.syncRaidSpeedup(_loc1_.id);
                  this.visitorPanel.sayPanel.addMessage(_loc1_,"rs_raid_sim",true);
               }
            }
         }
      }
      
      private function calcPower(param1:Array) : void
      {
         var _loc2_:PCommand = null;
         var _loc3_:uint = 0;
         var _loc4_:PShopPowerPoint = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = _loc2_.cm_kind.variance;
            if(_loc3_ == PCommandKind.SPELL || _loc3_ == PCommandKind.BUY_POWER)
            {
               if(!this.isRaid || _loc2_.cm_user_id == Preloader.uid)
               {
                  if(_loc3_ == PCommandKind.SPELL)
                  {
                     this.sim.changePower(-this.mp.getSpellShop((_loc2_.cm_kind.value as PSpellCommand).pscm_kind).ssp_power_price);
                  }
                  else
                  {
                     _loc3_ = _loc2_.cm_kind.value;
                     for each(_loc4_ in this.mp.powerShopList)
                     {
                        if(_loc4_.power_count == _loc3_)
                        {
                           this.sim.changePower(_loc3_);
                           ShopLogic.applyCost(_loc4_.power_price,true);
                           break;
                        }
                     }
                  }
               }
            }
         }
      }
      
      protected function commandSort(param1:PCommand, param2:PCommand) : int
      {
         return param1.cm_time - param2.cm_time;
      }
      
      public function dropSoldier(param1:Position, param2:Position) : Boolean
      {
         var _loc4_:PShopUnit = null;
         var _loc3_:uint = this.dropPanel.getSelectCount();
         if(_loc3_ > this.selectItem.count)
         {
            _loc3_ = this.selectItem.count;
         }
         if(_loc3_ > 0)
         {
            if(this.soldierLimit > 0 && _loc3_ > this.soldierLimit)
            {
               _loc3_ = uint(this.soldierLimit);
            }
            _loc4_ = this.selectItem.shop;
            if(_loc3_ * _loc4_.su_hspace > this.bp.allowHSpace)
            {
               Facade.mainMediator.flightMessage(Lang.getString("drop_hspace_limit"));
               return false;
            }
            if(!this.isRaid)
            {
               this.bp.allowHSpace -= _loc4_.su_hspace * _loc3_;
            }
            this.dropSoldierApply(_loc4_,_loc4_.su_is_hero ? this.up.getHeroSpec(_loc4_.su_kind) : null,_loc3_,param1,param2);
            this.dropPanel.drop(_loc3_);
            if(this.soldierLimit > 0)
            {
               if(this.soldierDp.length == 0)
               {
                  this.soldierLimit = -1;
                  this.dropPanel.removeLimiter();
               }
               else
               {
                  this.soldierLimit -= _loc3_;
                  this.dropPanel.setLimit(this.soldierLimit);
               }
            }
         }
         return this.isRaid;
      }
      
      private function dropSoldierApply(param1:PShopUnit, param2:PHero, param3:uint, param4:Position, param5:Position, param6:int = -1, param7:VORaidMember = null) : void
      {
         if(!this.sim)
         {
            this.startBattle();
         }
         if(this.isAudioTheme)
         {
         }
         if(param6 < 0)
         {
            param6 = this.curSimTime;
            if(this.train == 0)
            {
               if(this.runCommand(PCommandKind.UNIT,PUnitCommand.create(param1.su_kind,param4,param3,param5),param6))
               {
                  return;
               }
            }
         }
         if(this.isRaid && Boolean(param7))
         {
            this.dropRaidSoldier(param7,param1,param3);
            this.sim.addUnitEvent(param1,param2,param3,param4,param5,param6,param7.num);
            if(param7.isBotFinish() && this.isSpeedUpMe)
            {
               this.syncRaidSpeedup(param7.id);
               this.visitorPanel.sayPanel.addMessage(param7,"rs_raid_sim",true);
            }
         }
         else
         {
            this.sim.addUnitEvent(param1,param2,param3,param4,param5,param6,this.train == 5 ? 1 : 0);
         }
      }
      
      private function dropRaidSoldier(param1:VORaidMember, param2:PShopUnit, param3:uint) : void
      {
         var _loc6_:VOBattleItem = null;
         param1.soldierCount = param3 >= param1.soldierCount ? 0 : int(param1.soldierCount - param3);
         param1.soldierBattleCount += param3;
         param1.dropCapacity += param3 * param2.su_hspace;
         if(param1.num == 1 && !param2.su_is_hero)
         {
            this.bp.raidDropCapacity += param3 * param2.su_hspace;
         }
         if(param1.num == 1 && param2.su_is_hero)
         {
            this.bp.isHeroDrop = true;
         }
         var _loc4_:Array = param1.soldierDp;
         var _loc5_:* = int(_loc4_.length - 1);
         while(_loc5_ >= 0)
         {
            _loc6_ = _loc4_[_loc5_];
            if(_loc6_.shop == param2)
            {
               if(_loc6_.count > param3)
               {
                  _loc6_.count -= param3;
                  break;
               }
               _loc4_.splice(_loc5_,1);
               break;
            }
            _loc5_--;
         }
         if(this.sim.getSimRun() is SimVisual)
         {
            this.syncRaidMembers();
         }
      }
      
      protected function runCommand(param1:uint, param2:*, param3:int) : Boolean
      {
         var _loc4_:PCommand = PCommand.create(PCommandKind.create(param1,param2),param3,Preloader.uid);
         if(this.isRaid)
         {
            if(this.isStorm)
            {
               if(this.isTerritoryStorm)
               {
                  this.requestControl.add(new Packet_0060_32(PTerritoryCommand.create(_loc4_,this.bp.stormId)));
               }
               else
               {
                  this.requestControl.add(new Packet_0060_25(_loc4_));
               }
            }
            else
            {
               this.requestControl.add(new Packet_0050_03(_loc4_));
            }
            return true;
         }
         if(this.myCommandList.push(_loc4_) == 1)
         {
            if(this.fightType == PFightType.JAINA_MISSION)
            {
               this.useSpeedup();
            }
         }
         this.requestControl.add(new Packet_0010_01([PUaPacket.create(CoreLogic.serverTime,PUserAction.create(PUserAction.FIGHT_ADD_COMMAND,_loc4_))],false));
         return false;
      }
      
      private function checkAutoRaid(param1:Boolean = true) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:PCommand = null;
         var _loc5_:PUnitCommand = null;
         var _loc6_:PShopUnit = null;
         if(param1 && this.lastSimTime / 1000 > Facade.references.auto_command_time)
         {
            return false;
         }
         if(this.membersProxy.isOneOrAllBots)
         {
            return false;
         }
         if(this.heroRaid)
         {
            _loc2_ = !this.bp.isHeroDrop;
         }
         else
         {
            _loc3_ = this.bp.raidDropCapacity;
            for each(_loc4_ in this.waitCommandList)
            {
               if(_loc4_.cm_user_id == Preloader.uid && _loc4_.cm_kind.variance == PCommandKind.UNIT)
               {
                  _loc5_ = _loc4_.cm_kind.value;
                  _loc6_ = this.mp.getSoldierShop(_loc5_.pucm_kind);
                  if(!_loc6_.su_is_hero)
                  {
                     _loc3_ += _loc6_.su_hspace * _loc5_.pucm_count;
                  }
               }
            }
            _loc2_ = _loc3_ / this.targetInfo.ti_my_camp_capacity * 100 < Facade.references.auto_command_perc;
         }
         if(_loc2_)
         {
            Facade.mainMediator.searchDialog(StoryDialog,true);
            Facade.mainMediator.showDialog(new StoryDialog("un_jaina1",Lang.getString(param1 ? "raid_stop_exit" : "raid_auto")));
         }
         return _loc2_;
      }
      
      public function toHome(param1:VEvent = null) : void
      {
         var _loc4_:String = null;
         var _loc2_:Function = null;
         var _loc3_:Array = null;
         if(this.bp.isWin)
         {
            if(this.fightType == PFightType.MISSION)
            {
               _loc4_ = this.targetInfo.ti_fight_type.value;
               if(this.up.winMissionList.indexOf(_loc4_) < 0)
               {
                  Facade.commonHash[this] = _loc4_;
               }
            }
            else if(this.fightType == PFightType.JAINA_MISSION)
            {
               if(Boolean(this.adventure) && this.adventure.mission_num >= this.mp.getJainaEventInfo(this.adventure.event_id).jei_missions_number)
               {
                  _loc2_ = GoMediator.showAdventureLevelComplete;
                  _loc3_ = [this.adventure.event_id,this.adventure.adventure_level + 1];
               }
            }
         }
         else if(this.fightType == PFightType.JAINA_MISSION)
         {
            if(!this.adventure && this.myCommandList.length > 0)
            {
               _loc2_ = GoMediator.showJainaProgressDialog;
            }
         }
         MainLogic.getMyMap(_loc2_,_loc3_);
      }
      
      public function changeHeroHp(param1:Soldier, param2:uint) : void
      {
         var _loc3_:RaidMemberRenderer = null;
         for each(_loc3_ in this.visitorPanel.raidGrid.renderList)
         {
            if(_loc3_.item.num == param1.user_num)
            {
               if(!_loc3_.damageProgresBar)
               {
                  _loc3_.initDamageProgress(param1);
               }
               _loc3_.damageProgresBar.sync(param2);
            }
         }
      }
      
      public function changeDamage(param1:String, param2:uint) : void
      {
         var _loc3_:VOWinItem = null;
         this.nextDamageTime = this.lastSimTime + 1000;
         this.simVisual.damageCount = 0;
         this.rivalPanel.damagePanel.setTweenValue(this.getDamage());
         Facade.dispatchCommonEvent(CommonEvent.DAMAGE,param1,param2);
         for each(_loc3_ in this.bp.winList)
         {
            if(_loc3_.count > 0 && _loc3_.info.mw_kind == param1)
            {
               --_loc3_.count;
               if(this.fightType == PFightType.JAINA_MISSION)
               {
                  break;
               }
               this.battlePanel.syncWinTargets();
               if((this.train == 0 || this.isStorm) && this.bp.checkWinList(this.targetInfo.ti_um,this.sim.data))
               {
                  if(this.isStorm)
                  {
                     this.runMode = this.F_CONSTRUCTION;
                     break;
                  }
                  this.useSpeedup();
               }
               break;
            }
         }
      }
      
      public function checkFinishBattle(param1:String, param2:uint) : void
      {
         var _loc3_:VOWinItem = null;
         if(param1)
         {
            for each(_loc3_ in this.bp.winList)
            {
               if(_loc3_.count > 0 && _loc3_.info.mw_kind == param1)
               {
                  --_loc3_.count;
                  this.battlePanel.syncWinTargets();
                  if(this.bp.checkWinList(this.targetInfo.ti_um,this.sim.data))
                  {
                     this.useSpeedup();
                  }
                  break;
               }
            }
         }
         else
         {
            if(this.isRaid)
            {
               if(this.decRaidSoldier(param2) || this.isStorm)
               {
                  return;
               }
            }
            else if(this.checkLiveSoldiers())
            {
               return;
            }
            this.runMode = this.F_SOLDIER;
         }
      }
      
      private function checkLiveSoldiers() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:uint = 0;
         if(this.runMode != this.F_SPEEDUP)
         {
            for each(_loc1_ in this.soldierDp)
            {
               if((_loc1_ as VOBattleItem).count > 0)
               {
                  return true;
               }
            }
         }
         for each(_loc1_ in this.sim.data.units)
         {
            if((_loc1_ as SimUnitT).is_attacker)
            {
               return true;
            }
         }
         for each(_loc1_ in this.waitCommandList)
         {
            _loc2_ = (_loc1_ as PCommand).cm_kind.variance;
            if(_loc2_ == PCommandKind.UNIT || _loc2_ == PCommandKind.SPELL)
            {
               return true;
            }
         }
         return false;
      }
      
      private function decRaidSoldier(param1:uint) : Boolean
      {
         if(this.soldierLimit >= 0 && param1 == 1)
         {
            ++this.soldierLimit;
            if(this.sim.getSimRun() is SimVisual)
            {
               this.dropPanel.setLimit(this.soldierLimit);
            }
         }
         return this.membersProxy.removeSoldier(param1,this.runMode == this.F_RUN);
      }
      
      protected function startBattle() : void
      {
         this.startTime = CoreLogic.time;
         if(this.train == 0 || this.train == REPLAY || this.train == SELF)
         {
            this.stopTime = this.startTime + this.battleDuration - 6;
            this.battlePanel.changeTimer(true);
            if(this.train == 0)
            {
               if(!this.isStorm || this.isJoinAttacker)
               {
                  this.visitorPanel.useStartBattle(this.isRaid,this.isStorm);
                  if(this.bp.startPower > 0)
                  {
                     this.usePowerBuy();
                  }
               }
            }
            else
            {
               this.rivalPanel.myResourceVisible = true;
            }
            this.timerSignal.handler = this.onTimerSignal;
            this.timerSignal.run(this.battleDuration,0,true,true);
            this.changeQuality(true);
            UnitFactory.buildLogic.stopExAnimation();
            if(this.train == 0 && Facade.myMediator.prefPanel.useDamageBt(true))
            {
               Facade.myMediator.prefPanel.damageBt.addClickListener(this.onDamageVisible);
            }
         }
         else
         {
            this.stopTime = Number.MAX_VALUE;
            this.battlePanel.changeTimer(false);
            this.timerSignal.stop();
         }
         this.lastSimTime = 0;
         this.simVisual = new SimVisual(this.soldierDp);
         this.simVisual.usePower = this.dropPanel.powerPanel.visible;
         this.simVisual.useDefenderMarker = !this.isRaid;
         this.simVisual.isBoss = this.isBoss;
         this.simVisual.heroRaid = this.heroRaid;
         if(this.bp.mission)
         {
            this.assignMissionReward(this.bp.mission);
         }
         this.sim = new Sim(Facade.map_sx,Facade.map_sy,Facade.references,this.simVisual);
         this.sim.data.initPower(this.bp.startPower,this.isRaid,this.isStorm,this.isBoss);
         if(this.fightType == PFightType.JAINA_MISSION)
         {
            this.sim.data.powerK = 0;
         }
         if(Boolean(this.bp.mission) && this.bp.mission.mi_tunits.length > 0)
         {
            this.addDefenderSoldiers();
         }
         if(this.isBoss && Boolean(this.visitorPanel.surrenderBt))
         {
            this.visitorPanel.useSpeedup();
         }
         if(this.isStorm)
         {
            this.sim.data.assignUm(this.targetInfo.ti_um,this.bp.storm.storm_tunits_levels,this.bp.storm.storm_obj_stamina,this.staminaKoef);
         }
         else
         {
            this.sim.data.assignUm(this.targetInfo.ti_um,this.targetInfo.ti_user_base.units_levels,null,this.staminaKoef,Boolean(this.adventure));
         }
         this.simSignal.run(0,Number.MAX_VALUE,false,true);
         Facade.boardMediator.setBattleOver(false);
      }
      
      private function assignMissionReward(param1:PMissionInfo) : void
      {
         var _loc3_:Array = null;
         var _loc2_:int = param1.mi_init_obj_cnt;
         if(this.adventure)
         {
            _loc3_ = this.mp.getAdventureReward(param1.mi_kind,this.adventure.adventure_level);
            this.simVisual.jglory = CostHelper.getValueFromList(_loc3_,PCost.J_GLORY) / _loc2_;
            this.simVisual.rar_dragon = CostHelper.getValueFromList(_loc3_,PCost.RAR_DRAGON) / _loc2_;
            this.simVisual.onyx = CostHelper.getValueFromList(_loc3_,PCost.MITHRIL) / _loc2_;
         }
         else
         {
            this.simVisual.jglory = param1.mi_jglory / _loc2_;
            this.simVisual.rar_dragon = param1.mi_rar_dragon / _loc2_;
            this.simVisual.onyx = param1.mi_mithril / _loc2_;
         }
      }
      
      private function onTimerSignal() : void
      {
         this.battlePanel.updateTime(this.timerSignal.tail);
      }
      
      private function onPreBattleSim() : void
      {
         if(this.timerSignal.tail == 0)
         {
            this.startBattle();
         }
         else
         {
            this.battlePanel.updateTime(this.timerSignal.tail);
         }
      }
      
      private function onBattleSim() : void
      {
         this.simVisual.curTime = (CoreLogic.time - this.startTime) * 1000;
         this.lastSimTime = (this.simSignal.handlerTime - this.startTime) * 1000;
         if(this.waitCommandList.length > 0)
         {
            while(this.waitCommandList[0].cm_time <= this.lastSimTime)
            {
               this.parseCommand(this.waitCommandList.shift());
               if(this.waitCommandList.length == 0)
               {
                  break;
               }
            }
         }
         if(this.sim.processQueueToTime(this.lastSimTime))
         {
            this.runMode = this.F_CONSTRUCTION;
         }
         if(this.simSignal.handlerTime >= this.stopTime)
         {
            if(this.stopTime < this.startTime + this.battleDuration)
            {
               this.stopTime = this.startTime + this.battleDuration;
               if(this.runMode != this.F_SPEEDUP)
               {
                  this.battlePanel.useDropPanel(false);
                  this.simVisual.usePower = false;
                  Facade.mainMediator.searchDialog(PowerBuyDialog,true);
                  if(this.isStorm && (this.isAttacker || this.isDefender))
                  {
                     this.battlePanel.showStormPanel();
                  }
               }
               else
               {
                  CoreLogic.simulateFactor = 1;
               }
               this.battlePanel.changeTimer(true,2);
            }
            else if(this.train == REPLAY && !this.checkLiveSoldiers())
            {
               this.runMode = this.F_SOLDIER;
            }
            else
            {
               this.runMode = this.F_TIME;
            }
         }
         if(this.runMode > this.F_SPEEDUP)
         {
            if(this.isStorm && this.runMode == this.F_CONSTRUCTION)
            {
               this.useLastStormWait();
            }
            else
            {
               this.finish();
            }
         }
         else if(this.lastSimTime >= this.nextDamageTime)
         {
            if(this.simVisual.damageCount > 10)
            {
               this.rivalPanel.damagePanel.setTweenValue(this.getDamage());
               this.simVisual.damageCount = 0;
            }
            this.nextDamageTime = this.lastSimTime + 1000;
         }
      }
      
      private function finish() : void
      {
         var _loc1_:Soldier = null;
         var _loc2_:* = 0;
         var _loc3_:PKindCount = null;
         Facade.audioProxy.clear(false);
         Facade.gameStream.clear();
         this.simSignal.stop();
         this.timerSignal.stop();
         CoreLogic.pause = true;
         this.visitorPanel.clear();
         this.battlePanel.hideStormPanel();
         this.battlePanel.changeTimer(false);
         for each(_loc1_ in this.up.soldierHash)
         {
            if(!_loc1_.isStand)
            {
               _loc1_.stand();
            }
         }
         this.changeQuality(false);
         if(this.runMode == this.F_SURRENDER)
         {
            this.bp.isWin = false;
            if(this.heroRaid)
            {
               _loc2_ = int(this.targetInfo.ti_attacker_info.ai_units.length - 1);
               while(_loc2_ >= 0)
               {
                  _loc3_ = this.targetInfo.ti_attacker_info.ai_units[_loc2_];
                  if(_loc3_.kind != "un_hero")
                  {
                     this.targetInfo.ti_attacker_info.ai_units.splice(_loc2_,1);
                  }
                  _loc2_--;
               }
            }
            this.simVisual.calcDeathSoldier(this.targetInfo.ti_attacker_info.ai_units,this.soldierDp);
            Facade.protoProxy.request(this.isRaid ? new Packet_0010_0A() : new Packet_0010_24());
            this.showResult(null,this.getDamage(),Math.ceil(this.targetInfo.ti_dec_ratio * -1));
         }
         else if(this.runMode >= this.F_SOLDIER)
         {
            Facade.mainMediator.flightGlobalMessage("<span fontSize=\"30\">" + Lang.getString(this.runMode == this.F_SOLDIER ? (this.isBoss ? "finish_boss" : (this.train == REPLAY ? "finish_replay_army" : "finish_army")) : (this.runMode == this.F_TIME ? "finish_time" : (this.isBoss ? "my_base_destroy" : "finish_construction"))) + "</span>",this.bp.isWin || this.isBoss || this.train == 4 || this.train == 5 ? 2.2 : 8.2);
            this.timerSignal.handler = this.endWaitResult;
            this.timerSignal.delayCall(2.5);
         }
         else
         {
            this.endWaitResult();
         }
      }
      
      private function endWaitResult() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:PCost = null;
         var _loc3_:PCost = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:PCost = null;
         var _loc8_:String = null;
         var _loc9_:NewStoryDialog = null;
         if(this.train > 0)
         {
            if(this.train == REPLAY)
            {
               MainLogic.getMyMap();
            }
            else
            {
               this.trainResult();
            }
         }
         else
         {
            this.simVisual.deathSoldierDp.sort(VOBattleItem.sort);
            _loc1_ = this.getDamage();
            this.bp.checkWinList(this.targetInfo.ti_um,this.sim.data);
            _loc2_ = PCost.create(PCost.CRYSTAL,0);
            _loc3_ = PCost.create(PCost.OIL,0);
            _loc4_ = [_loc2_,_loc3_];
            if(!this.isStorm && this.bp.isWin)
            {
               BattleProxy.getSteal(this.sim.data.buildings,this.targetInfo,_loc2_,_loc3_);
            }
            if(this.targetInfo.ti_fight_id)
            {
               Facade.protoProxy.request(new Packet_0020_09(PClientSimRes.create(this.targetInfo.ti_fight_id,this.myCommandList,_loc4_,_loc1_,this.bp.isWin)));
            }
            if(this.fightType == PFightType.JAINA_MISSION)
            {
               if(_loc2_.value == 0 && _loc3_.value == 0)
               {
                  _loc4_.length = 0;
               }
               if(this.adventure)
               {
                  this.addAdventurePrize(_loc4_,this.mp.getAdventureReward(this.bp.mission.mi_kind,this.adventure.adventure_level));
               }
               else
               {
                  this.addJainaPrize(_loc4_,this.bp.mission.mi_jglory,PCost.J_GLORY);
                  this.addJainaPrize(_loc4_,this.bp.mission.mi_rar_dragon,PCost.RAR_DRAGON);
                  this.addJainaPrize(_loc4_,this.bp.mission.mi_mithril,PCost.MITHRIL);
               }
            }
            _loc5_ = 0;
            if(!this.isStorm)
            {
               _loc6_ = [];
               for each(_loc7_ in _loc4_)
               {
                  if(_loc7_.variance != PCost.CLAN_POINTS)
                  {
                     _loc6_.push(_loc7_);
                  }
               }
               this.runCommand(PCommandKind.FINISH,PFinishCommand.create(_loc1_,_loc6_),uint((CoreLogic.time - this.startTime) * 1000));
               if(this.fightType == PFightType.SINGLE)
               {
                  if(this.bp.isWin)
                  {
                     if(this.targetInfo.ti_inc_ratio > 0)
                     {
                        _loc5_ = this.targetInfo.ti_inc_ratio * _loc1_ / 100;
                        if(_loc5_ == 0)
                        {
                           _loc5_ = uint(Facade.references.min_ratio_per_fight);
                        }
                        if(_loc5_ > Facade.references.max_ratio_per_fight)
                        {
                           _loc5_ = uint(Facade.references.max_ratio_per_fight);
                        }
                        _loc5_ = this.up.checkIncRatio(_loc5_);
                     }
                  }
                  else
                  {
                     _loc5_ = Math.ceil(this.targetInfo.ti_dec_ratio * (_loc1_ / 100 - 1));
                  }
               }
            }
            if(this.bp.isWin)
            {
               if(this.isBoss)
               {
                  _loc8_ = (AbstractTrain.instance as BossRegularTrain).bossKind;
                  _loc9_ = new NewStoryDialog(_loc8_,Lang.getRangedString(_loc8_ + "_victory"),false);
                  _loc9_.addListener(VEvent.CLOSE_DIALOG,this.toHome);
                  Facade.mainMediator.showDialog(_loc9_);
               }
               else
               {
                  this.battlePanel.showWinPanel(this.showResult,[_loc4_,_loc1_,_loc5_]);
               }
            }
            else if(this.isBoss)
            {
               _loc8_ = (AbstractTrain.instance as BossRegularTrain).bossKind;
               _loc9_ = new NewStoryDialog(_loc8_,Lang.getRangedString(_loc8_ + "_lose"),false);
               _loc9_.addListener(VEvent.CLOSE_DIALOG,this.toHome);
               this.battlePanel.showWinPanel(Facade.mainMediator.showDialog,[_loc9_]);
            }
            else
            {
               this.showResult(_loc4_,_loc1_,_loc5_);
            }
         }
      }
      
      private function addJainaPrize(param1:Array, param2:uint, param3:uint) : void
      {
         if(param2 > 0)
         {
            param1.push(PCost.create(param3,int(param2 / this.bp.mission.mi_init_obj_cnt) * (this.sim.data.rmBuildCount + this.sim.data.rmCannonCount)));
         }
      }
      
      private function addAdventurePrize(param1:Array, param2:Array) : void
      {
         var _loc3_:PCost = null;
         for each(_loc3_ in param2)
         {
            this.addJainaPrize(param1,_loc3_.value,_loc3_.variance);
         }
      }
      
      private function trainResult() : void
      {
         var _loc1_:AbstractTrain = AbstractTrain.instance;
         if(_loc1_ is RaidNewTrain)
         {
            (_loc1_ as RaidNewTrain).stepResult();
         }
         else if(_loc1_ is Mission3Train)
         {
            (_loc1_ as Mission3Train).stepResult(this.myCommandList);
         }
         else if(_loc1_ is Mission0NewestTrain)
         {
            Facade.changeUserStage("ms_mission" + this.train + "_complete");
            MainLogic.checkTrainMission();
         }
         else if(_loc1_ is Mission2NewTrain)
         {
            (_loc1_ as Mission2NewTrain).stepResult();
         }
         else
         {
            Facade.changeUserStage("ms_mission" + this.train + "_complete");
            MainLogic.checkTrainMission();
         }
      }
      
      protected function showResult(param1:Array, param2:uint, param3:int) : void
      {
         var _loc5_:StormResultDialog = null;
         var _loc4_:BattleResultMediator = new BattleResultMediator(this.targetInfo,param2,this.bp.isWin,this.simVisual.deathSoldierDp,this.membersProxy,this.bp.winList,this.heroRaid);
         if(this.isStorm)
         {
            _loc5_ = _loc4_.assignStorm(this.isAttacker,this.isJoinAttacker,this.isDefender,this.isTerritoryStorm,this.bp.isWin);
            _loc5_.toStormBt.addClickListener(this.reload);
            _loc5_.addListener(VEvent.CLOSE_DIALOG,this.toHome);
         }
         else
         {
            _loc4_.assign(this.isRaid,param1,param3,this.bp.mission,this.fightType == PFightType.JAINA_MISSION,this.adventure).addListener(VEvent.CLOSE_DIALOG,this.toHome);
         }
      }
      
      public function get spellSelected() : Boolean
      {
         return Boolean(this.selectItem) && Boolean(this.selectItem.spellShop);
      }
      
      public function checkLanding(param1:Point, param2:Position, param3:Boolean) : void
      {
         var _loc5_:Boolean = false;
         Isometric.screenToPos(param1.x,param1.y,param2);
         var _loc4_:MapCell = Facade.map.getSafeMapCell(param2.x,param2.y);
         if(_loc4_)
         {
            _loc5_ = _loc4_.landing;
         }
         else
         {
            _loc5_ = param3;
         }
         if(_loc5_ != this.battlePanel.isLanding)
         {
            this.battlePanel.isLanding = _loc5_;
            this.battlePanel.syncCursor(this.selectItem);
         }
      }
      
      private function onDropSelect(param1:VEvent) : void
      {
         if(this.selectItem != param1.data)
         {
            if(Boolean(this.selectItem) && Boolean(this.selectItem.spellShop))
            {
               Facade.boardMediator.battleDrop.clear();
            }
            this.selectItem = param1.data;
            if(this.selectItem)
            {
               SkinManager.applyExternal(this.battlePanel.soldierCursor,this.selectItem.shop ? this.selectItem.shop.su_kind + this.selectItem.shop.su_model_level + "_m" : this.selectItem.spellShop.ssp_kind + "1_m",null,SkinManager.PNG);
               if(this.selectItem.spellShop)
               {
                  SimBaseVisual.syncSpellRadius(this.selectItem.spellShop.ssp_effect);
               }
            }
            else
            {
               this.battlePanel.syncCursor(null);
               if(this.dropPanel.isEmpty)
               {
                  this.battlePanel.useDropPanel(false);
               }
            }
         }
      }
      
      private function parseCommand(param1:PCommand) : void
      {
         var _loc2_:uint = param1.cm_kind.variance;
         if(this.isRaid)
         {
            if(_loc2_ == PCommandKind.UNIT || _loc2_ == PCommandKind.MESSAGE)
            {
               if(!this.membersProxy.getById(param1.cm_user_id))
               {
                  this.membersProxy.sendLog("parseCommand " + _loc2_ + " id=" + param1.cm_user_id,this.lastSimTime,this.isStorm,this.isTerritoryStorm);
                  return;
               }
            }
         }
         switch(_loc2_)
         {
            case PCommandKind.UNIT:
               this.useSoldierCommand(param1.cm_kind.value,param1.cm_time,param1.cm_user_id);
               break;
            case PCommandKind.SPELL:
               this.useSpellCommand(param1.cm_kind.value,param1.cm_time,param1.cm_user_id);
               break;
            case CMD_RAID_VECTOR:
               this.drawRaidVector(param1.cm_kind.value,param1.cm_user_id);
               break;
            case PCommandKind.MESSAGE:
               this.useMessageCommand(param1,false);
               break;
            case CMD_WORKER:
               (param1.cm_kind.value as VOBattleItem).waitTime = 0;
               this.dropPanel.spellGrid.sync();
               if(Boolean(this.selectItem) && this.selectItem == param1.cm_kind.value)
               {
                  this.dropPanel.selectPanel.sync();
               }
               break;
            case CMD_RAID_AUTO:
               if(this.checkAutoRaid(false))
               {
                  this.dropPanel.soldierLock = true;
               }
               Facade.protoProxy.request(new Packet_0010_1F(),this.onAutoRaid,16,32,null,"raidAuto");
         }
      }
      
      private function useSoldierCommand(param1:PUnitCommand, param2:uint, param3:String) : void
      {
         var _loc4_:PHero = null;
         var _loc5_:VORaidMember = null;
         var _loc6_:uint = 0;
         var _loc7_:PShopUnit = null;
         if(this.isRaid)
         {
            _loc5_ = this.membersProxy.getById(param3);
         }
         if(!this.isRaid || param3 == Preloader.uid)
         {
            _loc6_ = uint(this.up.soldierLevelHash[param1.pucm_kind]);
            _loc7_ = this.mp.getSoldierShop(param1.pucm_kind,_loc6_);
            if(_loc7_.su_is_hero)
            {
               _loc4_ = this.up.getHeroSpec(param1.pucm_kind);
            }
            this.bp.allowHSpace -= _loc7_.su_hspace * param1.pucm_count;
         }
         else
         {
            _loc6_ = uint(_loc5_.soldierLevelHash[param1.pucm_kind]);
            _loc7_ = this.mp.getSoldierShop(param1.pucm_kind,_loc6_);
            if(_loc7_.su_is_hero)
            {
               _loc4_ = _loc5_.heroByKind(param1.pucm_kind);
            }
         }
         this.dropSoldierApply(_loc7_,_loc4_,param1.pucm_count,param1.pucm_pos,param1.pucm_vector,param2,_loc5_);
         if(this.train == REPLAY)
         {
            this.sim.getSimRun().drawVector(param1.pucm_pos,param1.pucm_vector,false,0);
         }
      }
      
      private function drawRaidVector(param1:PUnitCommand, param2:String) : void
      {
         this.sim.getSimRun().drawVector(param1.pucm_pos,param1.pucm_vector,true,this.membersProxy.getById(param2).num);
      }
      
      private function useMessageCommand(param1:PCommand, param2:Boolean) : void
      {
         if(!this.membersProxy)
         {
            ErrorLogic.sendError("useMessageCommand not membersProxy msg=\"" + param1.cm_kind.value + "\" isRaid=" + this.isRaid + " isStorm=" + this.isStorm + " sim=" + Boolean(this.sim) + " time=" + this.lastSimTime);
            return;
         }
         var _loc3_:VORaidMember = this.membersProxy.getById(param1.cm_user_id);
         if(!_loc3_)
         {
            this.membersProxy.sendLog("useMessageCommand id: " + param1.cm_user_id,this.lastSimTime,this.isStorm,this.isTerritoryStorm);
            return;
         }
         if(param1.cm_kind.value == "rs_raid_sim")
         {
            this.syncRaidSpeedup(param1.cm_user_id);
         }
         if(param2)
         {
            if(this.visitorPanel.sayPanel)
            {
               this.visitorPanel.sayPanel.addMessage(_loc3_,param1.cm_kind.value,true);
            }
            else
            {
               ErrorLogic.sendError("useMessageCommand not sayPanel msg=\"" + param1.cm_kind.value + "\" isRaid=" + this.isRaid + " isStorm=" + this.isStorm + " sim=" + Boolean(this.sim) + " time=" + this.lastSimTime + " train=" + this.train);
            }
         }
      }
      
      private function addWaitCommand(param1:PCommand) : void
      {
         if(this.isRaid)
         {
            if(param1.cm_kind.variance == PCommandKind.UNIT)
            {
               if(param1.cm_user_id != Preloader.uid)
               {
                  this.addWaitCommand(PCommand.create(PCommandKind.create(CMD_RAID_VECTOR,param1.cm_kind.value),param1.cm_time - this.lastSimTime >= 3000 ? uint(param1.cm_time - 3000) : uint(this.lastSimTime + 1),param1.cm_user_id));
               }
            }
            else if(param1.cm_kind.variance == PCommandKind.MESSAGE)
            {
               this.useMessageCommand(param1,true);
               return;
            }
         }
         var _loc2_:* = int(this.waitCommandList.length - 1);
         while(_loc2_ >= 0)
         {
            if(param1.cm_time >= this.waitCommandList[_loc2_].cm_time)
            {
               this.waitCommandList.splice(_loc2_ + 1,0,param1);
               return;
            }
            _loc2_--;
         }
         this.waitCommandList.unshift(param1);
      }
      
      public function addMyCommand(param1:PCommand, param2:Boolean) : void
      {
         this.myCommandList.push(param1);
         this.addWaitCommand(param1);
         var _loc3_:int = param1.cm_time - this.lastSimTime;
         if(param2 && _loc3_ > 2500)
         {
            _loc3_ -= 2500;
            Facade.log("simulation up " + _loc3_);
            CoreLogic.changeTime(CoreLogic.time + _loc3_ / 1000);
         }
      }
      
      private function onGameStream(param1:Array) : void
      {
         var _loc3_:PRaidFriendEvent = null;
         var _loc4_:uint = 0;
         var _loc5_:PCommand = null;
         if(this.runMode != this.F_RUN)
         {
            return;
         }
         var _loc2_:Boolean = false;
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_.rf_event.variance;
            if(_loc4_ == PRaidEvent.COMMAND)
            {
               _loc5_ = _loc3_.rf_event.value as PCommand;
               this.addWaitCommand(_loc5_);
               if(_loc5_.cm_time <= this.lastSimTime)
               {
                  if(this.reloadCount < 3)
                  {
                     if(this.reloadCount == 0)
                     {
                        ErrorLogic.sendLog("bad_simulation",null,(getTimer() / 1000).toFixed(2) + ": bad raid simulation time=" + _loc5_.cm_time + " cur=" + this.lastSimTime + " event_t=" + _loc3_.rf_ts + " cur_t=" + CoreLogic.serverTime);
                     }
                     ++this.reloadCount;
                     Facade.mainPanel.showLoadPanel(Lang.getString("battle_reload"));
                     this.reload();
                  }
                  else
                  {
                     this.reloadCount = 0;
                     ErrorLogic.show(Lang.getString("bad_simulation"),null,null,false);
                  }
                  return;
               }
               if(_loc5_.cm_user_id == Preloader.uid && _loc5_.cm_kind.variance == PCommandKind.UNIT)
               {
                  _loc2_ = true;
                  this.dropSoldierAuto(_loc5_.cm_kind.value);
               }
            }
            else if(_loc4_ == PRaidEvent.DEL_MEMBER)
            {
               this.removeMember(_loc3_.rf_event.value);
            }
            else if(_loc4_ == PRaidEvent.NEW_STORM_MEMBER && this.isStorm && !this.membersProxy.getById(_loc3_.rf_friend_id))
            {
               _loc4_ = this.membersProxy.length;
               this.membersProxy.add(_loc3_.rf_event.value,_loc4_ > 0 ? uint((this.membersProxy.list[_loc4_ - 1] as VORaidMember).num + 1) : 2);
               this.visitorPanel.setRaidMembers(this.membersProxy.list);
               if(this.isWaitAttacker && this.membersProxy.length >= Facade.references.wp_wave_members_count)
               {
                  this.battlePanel.showStormPanel();
               }
            }
         }
         if(_loc2_)
         {
            this.syncDropDp();
            this.dropPanel.soldierLock = false;
         }
      }
      
      public function reload(param1:MouseEvent = null) : void
      {
         if(this.isTerritoryStorm)
         {
            MainLogic.getTerritoryStorm(this.bp.stormId);
         }
         else if(this.isStorm)
         {
            if(this.isAttacker || this.isDefender)
            {
               MainLogic.getStorm(this.isAttacker);
            }
            else
            {
               MainLogic.getWatchStorm(this.bp.stormId);
            }
         }
         else
         {
            MainLogic.getMyMap();
         }
      }
      
      private function removeMember(param1:String) : void
      {
         var _loc2_:VORaidMember = this.membersProxy.getById(param1);
         if(Boolean(_loc2_) && !_loc2_.losing)
         {
            _loc2_.losing = true;
            _loc2_.soldierDp.length = 0;
            _loc2_.soldierCount = 0;
            if(!_loc2_.sim)
            {
               this.syncRaidSpeedup(param1);
            }
         }
      }
      
      private function confirmSurrender() : void
      {
         this.visitorPanel.useEmpty();
         this.runMode = this.F_SURRENDER;
         this.finish();
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:uint = param1.variance;
         switch(_loc2_)
         {
            case VisitorPanel.TO_HOME:
               this.toHome();
               return;
            case VisitorPanel.SURRENDER:
               if(!this.isRaid || !this.checkAutoRaid())
               {
                  Facade.mainMediator.showYesNoDialog(Lang.getString("confirm_surrender"),this.confirmSurrender,null,Lang.getString("to_surrender"),SkinManager.getEmbed("SurrenderIcon"));
               }
               return;
            case VisitorPanel.SPEEDUP:
               if(this.isRaid)
               {
                  if(!this.checkAutoRaid())
                  {
                     this.visitorPanel.useEmpty();
                     this.runCommand(PCommandKind.MESSAGE,"rs_raid_sim",this.curSimTime);
                  }
               }
               else
               {
                  this.speedup();
               }
               return;
            case VisitorPanel.NEXT:
               Facade.myMediator.nextSearchPvP(false);
               return;
            case VisitorPanel.MESSAGE:
               this.runCommand(PCommandKind.MESSAGE,param1.data,this.curSimTime);
               return;
            default:
               return;
         }
      }
      
      private function speedup() : void
      {
         this.runMode = this.F_SPEEDUP;
         if(this.checkLiveSoldiers())
         {
            this.battlePanel.useDropPanel(false);
            this.simVisual.usePower = false;
            this.visitorPanel.useMessage(Lang.getString("wait_finish_battle"));
            CoreLogic.simulateFactor = 3;
         }
         else
         {
            this.runMode = this.F_TIME;
            this.visitorPanel.useEmpty();
         }
      }
      
      private function onStormJoin(param1:MouseEvent) : void
      {
         if(this.up.isCost(Facade.references.enter_storm_price))
         {
            this.battlePanel.hideStormPanel();
            this.visitorPanel.useEmpty();
            Facade.protoProxy.request(this.isTerritoryStorm ? new Packet_0060_31(this.bp.stormId) : new Packet_0060_23(),this.resultStormJoin);
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
      
      private function onAlinkEnergy(param1:MouseEvent = null) : void
      {
         var _loc2_:Array = Facade.manualProxy.energyShopList;
         var _loc3_:int = this.up.energyMax - this.up.energy;
         var _loc4_:AlinkDialog = new AlinkDialog();
         var _loc5_:Number = Facade.userProxy.getEnergyCooldown();
         _loc4_.useEnergyMode(_loc3_ > 0 ? CoreLogic.getActionTimeLeft(ActionLogic.RECOVERY_ENERGY) + (_loc3_ - 1) * _loc5_ : 0,_loc5_,_loc2_[0],_loc2_[1]);
         Facade.mainMediator.showDialog(_loc4_);
      }
      
      private function resultStormJoin(param1:BinaryBuffer) : void
      {
         var _loc2_:PAttackerInfo = null;
         var _loc3_:PUserBase = null;
         if(param1.family == 96 && param1.subfamily == 36)
         {
            _loc2_ = new Packet_0060_24(param1).value;
            this.targetInfo.ti_attacker_info = _loc2_;
            this.up.gold = _loc2_.ai_gold;
            MainLogic.addTroops(null,_loc2_);
            _loc3_ = this.up.base;
            _loc3_.units = _loc2_.ai_units;
            _loc3_.units_levels = _loc2_.ai_units_levels;
            _loc3_.heroes = _loc2_.ai_heroes;
            this.membersProxy.add(_loc3_,1,true);
            this.visitorPanel.setRaidMembers(this.membersProxy.list);
            this.assignDropDp(null,true,_loc2_);
            this.visitorPanel.useStartBattle(true,true);
            if(this.bp.startPower > 0)
            {
               this.usePowerBuy();
               this.sim.changePower(this.bp.startPower);
            }
         }
         else
         {
            this.visitorPanel.useHome();
            this.battlePanel.showStormPanel();
            Facade.mainMediator.showDialog(Lang.getString("storm_full"));
         }
      }
      
      private function syncRaidSpeedup(param1:String) : void
      {
         var _loc4_:VORaidMember = null;
         var _loc5_:Boolean = false;
         if(this.isStorm)
         {
            return;
         }
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         for each(_loc4_ in this.membersProxy.list)
         {
            _loc5_ = _loc4_.id == Preloader.uid;
            if(_loc4_.id == param1)
            {
               _loc4_.sim = true;
               _loc4_.soldierDp.length = 0;
               _loc4_.soldierCount = 0;
               if(_loc5_)
               {
                  this.visitorPanel.useEmpty();
                  this.battlePanel.useDropPanel(false);
               }
            }
            if(_loc4_.sim || _loc4_.losing)
            {
               if(_loc5_)
               {
                  _loc3_ = true;
               }
               _loc2_++;
            }
         }
         if(this.sim.getSimRun() is SimVisual)
         {
            this.syncRaidMembers();
            if(_loc3_)
            {
               this.visitorPanel.useMessage(Lang.getString("wait_speedup_in_raid") + ": " + _loc2_ + "/" + this.membersProxy.length);
            }
         }
         if(_loc2_ == this.membersProxy.length)
         {
            this.speedup();
         }
      }
      
      public function dropSpell(param1:Point) : void
      {
         var _loc2_:Position = new Position();
         Isometric.screenToPos(param1.x,param1.y,_loc2_);
         if(!Facade.map.checkBorder(_loc2_.x,_loc2_.y,0))
         {
            Facade.mainMediator.flightMessage(Lang.getString("spell_bad_drop"));
            return;
         }
         var _loc3_:PShopSpell = this.selectItem.spellShop;
         if(this.selectItem.isWorker)
         {
            this.dropWorkerSpell(_loc3_,_loc2_);
            return;
         }
         var _loc4_:int = this.sim ? this.sim.data.power : this.bp.startPower;
         if(_loc4_ < _loc3_.ssp_power_price)
         {
            Facade.mainMediator.flightMessage(Lang.getString("no_power"));
            this.dropPanel.focusPanel(this.dropPanel.powerPanel);
         }
         else
         {
            this.dropSpellApply(_loc3_,_loc2_);
            this.dropPanel.drop(1);
            this.sim.changePower(-_loc3_.ssp_power_price);
            this.simVisual.flightPowerMessage(-_loc3_.ssp_power_price,null);
         }
      }
      
      private function dropWorkerSpell(param1:PShopSpell, param2:Position) : void
      {
         if(this.selectItem.waitTime > 0)
         {
            Facade.mainMediator.flightMessage(Lang.getString("worker_cooldown"));
            return;
         }
         var _loc3_:PCost = param1.ssp_price[0];
         if(!this.up.isCost(_loc3_))
         {
            Facade.mainMediator.flightMessage(Lang.getString("not_enough_title"));
            this.dropPanel.focusPanel(_loc3_.variance == PCost.CRYSTAL ? this.dropPanel.crystalPanel : this.dropPanel.goldPanel);
            return;
         }
         this.dropSpellApply(param1,param2);
         ShopLogic.applyCost(_loc3_,true);
         CostHelper.flightMessage(_loc3_.variance,"-" + _loc3_.value);
         this.selectItem.waitTime = this.curSimTime + this.selectItem.workerDuration;
         this.addWaitCommand(PCommand.create(PCommandKind.create(CMD_WORKER,this.selectItem),this.selectItem.waitTime,null));
         this.dropPanel.spellGrid.sync();
         this.dropPanel.selectPanel.sync();
      }
      
      private function dropSpellApply(param1:PShopSpell, param2:Position, param3:int = -1, param4:VORaidMember = null) : void
      {
         var _loc5_:int = 0;
         if(!this.sim)
         {
            this.startBattle();
         }
         if(param3 < 0)
         {
            param3 = this.curSimTime;
            if(this.train == 0)
            {
               if(this.runCommand(PCommandKind.SPELL,PSpellCommand.create(param1.ssp_kind,param2),param3))
               {
                  return;
               }
            }
         }
         if(this.isRaid)
         {
            _loc5_ = param4 ? int(param4.num) : -1;
         }
         else
         {
            _loc5_ = 0;
         }
         this.sim.addSpellEvent(param3,param2,param1,_loc5_,!this.isBoss);
         if(!this.isRaid && !this.checkLiveSoldiers())
         {
            if(this.train == REPLAY)
            {
               this.stopTime = this.simSignal.handlerTime + 3;
            }
            else
            {
               this.runMode = this.F_SOLDIER;
            }
         }
      }
      
      private function useSpellCommand(param1:PSpellCommand, param2:uint, param3:String) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:VORaidMember = null;
         if(this.isRaid)
         {
            _loc5_ = this.membersProxy.getById(param3);
            if(!_loc5_)
            {
               _loc4_ = this.bp.thLevel;
            }
         }
         if(_loc4_ == 0)
         {
            _loc4_ = !this.isRaid || param3 == Preloader.uid ? uint(this.up.soldierLevelHash[param1.pscm_kind]) : uint(_loc5_.soldierLevelHash[param1.pscm_kind]);
         }
         this.dropSpellApply(this.mp.getSpellShop(param1.pscm_kind,_loc4_),param1.pscm_pos,param2,_loc5_);
      }
      
      private function dropSoldierAuto(param1:PUnitCommand) : void
      {
         var _loc3_:VOBattleItem = null;
         var _loc2_:* = int(this.soldierDp.length - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this.soldierDp[_loc2_];
            if(_loc3_.shop.su_kind == param1.pucm_kind)
            {
               if(param1.pucm_count >= _loc3_.count)
               {
                  this.soldierDp.splice(_loc2_,1);
                  break;
               }
               _loc3_.count -= param1.pucm_count;
               break;
            }
            _loc2_--;
         }
      }
      
      private function onAutoRaid(param1:BinaryBuffer) : void
      {
         var _loc2_:Array = null;
         var _loc3_:PCommand = null;
         var _loc4_:Boolean = false;
         if(this.runMode <= this.F_SPEEDUP)
         {
            _loc2_ = new Packet_0010_20(param1).value;
            if(_loc2_.length > 0)
            {
               for each(_loc3_ in _loc2_)
               {
                  if(_loc3_.cm_user_id == Preloader.uid && _loc3_.cm_kind.variance == PCommandKind.UNIT)
                  {
                     this.dropSoldierAuto(_loc3_.cm_kind.value);
                     _loc4_ = true;
                  }
                  this.addWaitCommand(_loc3_);
               }
               if(_loc4_)
               {
                  this.syncDropDp();
                  this.dropPanel.soldierLock = false;
               }
            }
         }
      }
      
      private function useLastStormWait() : void
      {
         if(this.useStormWait)
         {
            return;
         }
         this.useStormWait = true;
         var _loc1_:Number = this.battleDuration - this.curSimTime / 1000 + 1;
         var _loc2_:Boolean = !this.targetInfo.ti_attacker_info;
         this.visitorPanel.setRaidMembers([]);
         this.visitorPanel.clear();
         this.visitorPanel.add(new WaitStormPanel(_loc1_,this.isAttacker,this.isDefender,_loc2_),{"right":0});
      }
      
      public function usePowerBuy() : void
      {
         this.dropPanel.powerPanel.addBuyBt(this.onPowerBuy);
      }
      
      private function onPowerBuy(param1:MouseEvent) : void
      {
         var _loc2_:PowerBuyDialog = new PowerBuyDialog(this.mp.powerShopList,this.up.gold);
         _loc2_.addListener(VEvent.VARIANCE,this.onPowerBuySelect);
         Facade.mainMediator.showDialog(_loc2_);
      }
      
      private function onPowerBuySelect(param1:VEvent) : void
      {
         if(!this.sim)
         {
            return;
         }
         var _loc3_:PShopPowerPoint = param1.data;
         if(ShopLogic.checkPrice(_loc3_.power_price,this.onPowerBuySelect,arguments))
         {
            ShopLogic.applyCost(_loc3_.power_price,true);
            this.sim.changePower(_loc3_.power_count);
            this.runCommand(PCommandKind.BUY_POWER,_loc3_.power_count,this.curSimTime);
            (param1.currentTarget as PowerBuyDialog).close();
         }
      }
      
      private function onResourceBuy(param1:MouseEvent) : void
      {
         var _loc2_:PCost = null;
         var _loc3_:uint = 0;
         if(param1.currentTarget == this.dropPanel.crystalPanel.buyBt)
         {
            _loc2_ = (this.dropPanel.spellGrid.getDataProvider()[0] as VOBattleItem).spellShop.ssp_price[0];
            _loc3_ = Math.ceil(this.bp.storm.storm_my_capacity_crystal * 0.1);
            if(_loc3_ < _loc2_.value)
            {
               _loc3_ = _loc2_.value;
            }
            ShopLogic.showExchangeDialog(_loc2_.variance,_loc3_,_loc3_ * 2);
         }
         else
         {
            DialogLogic.openShop();
         }
      }
      
      private function onSpellBlock(param1:VEvent) : void
      {
         var _loc2_:VOBattleItem = param1.data;
         if(_loc2_.isWorker)
         {
            if(_loc2_.spellShop)
            {
               Facade.mainMediator.showMessage(Lang.getString("worker_spell_lock"),Lang.getString(_loc2_.spellShop.ssp_kind),SkinManager.getEmbed("WorkerIcon"));
            }
            else
            {
               Facade.mainMediator.showMessage(Lang.getString("jaina_blank_slot"),Lang.getString("spells"),SkinManager.getEmbed("SpellIcon"));
            }
         }
      }
      
      public function onDamageVisible(param1:MouseEvent) : void
      {
         this.simVisual.revertDamageVisible(this.sim.data);
      }
      
      private function addDefenderSoldiers() : void
      {
         var _loc3_:str_Position = null;
         var _loc4_:PShopUnit = null;
         var _loc5_:Soldier = null;
         var _loc1_:int = 0;
         var _loc2_:Boolean = Boolean(this.sim);
         for each(_loc3_ in this.bp.mission.mi_tunits)
         {
            _loc1_++;
            _loc4_ = this.mp.getSoldierShop(_loc3_.field_0,this.mp.getUnitLevel(this.targetInfo.ti_user_base.units_levels,_loc3_.field_0));
            if(_loc2_)
            {
               this.sim.addDefenderEvent(_loc4_,_loc1_,_loc3_.field_1,this.curSimTime);
            }
            else
            {
               _loc5_ = UnitFactory.createSoldier(_loc4_,_loc1_);
               _loc5_.direction = AnimObject.LEFT_DOWN;
               _loc5_.setGeometry(_loc3_.field_1.x,_loc3_.field_1.y,false);
               _loc5_.updateZSize();
               Facade.boardMediator.addObject(_loc5_,_loc5_.shop.su_is_air);
            }
         }
         if(_loc2_)
         {
            this.sim.data.unitId = _loc1_;
         }
      }
      
      public function checkFightType(param1:uint) : Boolean
      {
         return this.fightType == param1;
      }
   }
}

