package game.feature
{
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Fence;
   import engine.units.Unit;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import game.common.DialogMediator;
   import game.research.ResearchDialog;
   import game.research.ResearchMediator;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.ShopLogic;
   import logic.units.BuildLogic;
   import model.CommonEvent;
   import model.ManualProxy;
   import model.UserProxy;
   import model.ui.VOBattleItem;
   import model.ui.VOFeatureItem;
   import model.ui.VOTownHallItem;
   import model.vo.MapAction;
   import model.vo.VOGuardSpec;
   import model.vo.VOResourceSpec;
   import model.vo.VOStorageSpec;
   import proto.game.family_0010.PUpgradeHero;
   import proto.game.family_0010.PUserAction;
   import proto.model.*;
   import proto.model.spell.*;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.MessageDialog;
   import ui.game.UnitPanel;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   import ui.vbase.VText;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class FeatureMediator extends DialogMediator
   {
      
      public static const HERO_HP:uint = 1;
      
      public static const HERO_REGEN:uint = 2;
      
      public static const HERO_ARMOR:uint = 3;
      
      public static const HERO_DMG:uint = 4;
      
      public var dialog:FeatureDialog;
      
      private const dp:Array = [];
      
      private var data:Object;
      
      private var isUpdate:Boolean;
      
      private var updatePrice:Object;
      
      private var updateDuration:Number;
      
      private var upgradeType:uint;
      
      public var isOfferMode:Boolean;
      
      public function FeatureMediator(param1:Object, param2:Boolean = false, param3:uint = 0)
      {
         super();
         this.data = param1;
         this.upgradeType = param3;
         this.isUpdate = param2;
      }
      
      public static function getMySoldierDp(param1:Boolean = false) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:VOBattleItem = null;
         var _loc2_:UserProxy = Facade.userProxy;
         var _loc3_:ManualProxy = Facade.manualProxy;
         for(_loc5_ in _loc2_.soldierCountHash)
         {
            _loc6_ = uint(_loc2_.soldierCountHash[_loc5_]);
            if(_loc6_ > 0)
            {
               _loc7_ = new VOBattleItem();
               _loc7_.shop = _loc3_.getSoldierShop(_loc5_,_loc2_.soldierLevelHash[_loc5_]);
               _loc7_.count = _loc6_;
               if(!_loc4_)
               {
                  _loc4_ = [];
               }
               _loc4_.push(_loc7_);
            }
         }
         if(_loc4_)
         {
            _loc4_.sort(VOBattleItem.sort);
         }
         if(param1)
         {
            for each(_loc5_ in _loc2_.spellList)
            {
               _loc7_ = new VOBattleItem();
               _loc7_.spellShop = _loc3_.getSpellShop(_loc5_,_loc2_.soldierLevelHash[_loc5_]);
               if(!_loc4_)
               {
                  _loc4_ = [];
               }
               _loc4_.unshift(_loc7_);
            }
         }
         return _loc4_;
      }
      
      override public function onAdd() : BaseDialog
      {
         if(this.data is PShopUnit)
         {
            this.useSoldierOrSpell(this.data as PShopUnit);
         }
         else if(this.data is PShopSpell)
         {
            this.getSpellDialog(this.data as PShopSpell);
         }
         else if(this.data is PShopCannon)
         {
            this.getShopDialog(this.data as PShopCannon);
         }
         else
         {
            this.getConstructionDialog(this.data as Unit);
         }
         this.dialog.setDp(this.dp);
         return this.dialog;
      }
      
      private function useSoldierOrSpell(param1:PShopUnit) : void
      {
         if(param1.su_kind.indexOf("sp_") == 0)
         {
            this.getSpellDialog(mp.getSpellShop(param1.su_kind,param1.su_level));
         }
         else
         {
            this.getSoldierDialog(param1);
         }
      }
      
      private function addStaminaItem(param1:uint, param2:uint) : void
      {
         this.addItem("StaminaIcon","stamina",param1,param2);
      }
      
      private function addArmorItem(param1:uint, param2:uint, param3:Boolean = false) : VOFeatureItem
      {
         if(param1 > 0 || param2 > 0 || param3)
         {
            return this.addItem("ArmorIcon","armor",param1,param2);
         }
         return null;
      }
      
      private function addItem(param1:String, param2:String, param3:uint = 0, param4:uint = 0, param5:Boolean = false) : VOFeatureItem
      {
         var _loc6_:VOFeatureItem = new VOFeatureItem();
         _loc6_.skinName = param1;
         _loc6_.kind = param2;
         _loc6_.cur = param3;
         _loc6_.max = param4;
         _loc6_.selected = param5;
         this.dp.push(_loc6_);
         return _loc6_;
      }
      
      private function onConstructionUpdate(param1:MouseEvent = null) : void
      {
         var _loc2_:Unit = this.data as Unit;
         var _loc3_:uint = _loc2_ is Build ? (_loc2_ as Build).type : uint.MAX_VALUE;
         if(_loc3_ == PBtype.RESEARCH && Boolean(CoreLogic.getAction(ActionLogic.FINISH_RESEARCH)))
         {
            ShopLogic.showActionSpeedupDialog(_loc2_,ActionLogic.FINISH_RESEARCH,null,this.onConstructionUpdate);
         }
         else
         {
            BuildLogic.startUpdate(_loc2_,this.updatePrice,this.updateDuration);
            this.dialog.close();
         }
      }
      
      private function getConstructionDialog(param1:Unit) : void
      {
         var _loc3_:uint = 0;
         var _loc5_:Build = null;
         var _loc6_:PShopBuilding = null;
         var _loc2_:uint = this.isUpdate ? uint(param1.level + 1) : param1.level;
         this.dialog = new FeatureDialog(param1.kind,_loc2_,!this.isUpdate,0,false,false);
         var _loc4_:uint = uint.MAX_VALUE;
         if(param1 is Build)
         {
            _loc5_ = param1 as Build;
            if(this.isUpdate)
            {
               _loc6_ = mp.getBuildShop(param1.kind,_loc2_);
               this.updatePrice = _loc6_.sb_price;
               this.updateDuration = _loc6_.sb_upgrade_time;
               _loc3_ = _loc6_.sb_townhall_req;
            }
            else
            {
               _loc6_ = _loc5_.shop;
            }
            this.addStaminaItem(_loc5_.shop.sb_stamina,_loc6_.sb_stamina);
            this.addArmorItem(_loc5_.shop.sb_armor,_loc6_.sb_armor);
            _loc4_ = _loc5_.type;
            if(_loc4_ == PBtype.STORAGE)
            {
               this.useStorage(_loc5_);
            }
            else if(_loc4_ == PBtype.RESOURCE)
            {
               this.useResource(_loc5_);
            }
            else if(_loc4_ == PBtype.CAMP)
            {
               this.useCamp(_loc5_);
            }
            else if(_loc4_ == PBtype.BARRACK)
            {
               this.useBarrack(_loc5_);
            }
            else if(_loc4_ == PBtype.PYLON)
            {
               this.usePylon(_loc5_);
            }
            else if(_loc4_ == PBtype.GUARD)
            {
               this.useGuard(_loc5_);
            }
            else if(_loc4_ == PBtype.CLAN)
            {
               this.useClan(_loc5_);
            }
            else if(_loc4_ == PBtype.LIBRARY)
            {
               this.useLibrary(_loc5_);
            }
            else if(_loc4_ == PBtype.TOWNHALL)
            {
               this.useTownHall(_loc5_);
            }
            else if(_loc4_ == PBtype.RAID)
            {
               this.useRaid(_loc5_);
            }
            else if(_loc4_ == PBtype.SHIELD)
            {
               this.useShield(_loc5_);
            }
            else if(this.isUpdate)
            {
               if(_loc4_ == PBtype.RESEARCH)
               {
                  this.useSoldierUnlock(_loc5_,true);
               }
            }
         }
         else if(param1 is Cannon)
         {
            _loc3_ = this.useCannon((param1 as Cannon).shop);
         }
         else if(param1 is Fence)
         {
            _loc3_ = this.useFence((param1 as Fence).shop);
         }
         if(!this.isUpdate)
         {
            Facade.addListenerForComponent(CommonEvent.CONSTRUCTION_UP,this.onConstructionUp,this.dialog);
         }
         if(this.updatePrice)
         {
            if(_loc3_ <= up.townHallLevel || Facade.isMissionEditor)
            {
               _loc3_ = 0;
            }
            if(_loc3_ == 0 && param1 is Build)
            {
               if(_loc4_ == PBtype.RESEARCH)
               {
                  if(this.checkConstructionAction(param1.id))
                  {
                     return;
                  }
               }
            }
            this.dialog.addUpdateButton(this.updatePrice,param1 is Fence && _loc2_ >= Facade.references.fence_builder_req_lvl ? -1 : this.updateDuration,this.onConstructionUpdate,_loc3_);
         }
         this.dialog.addUnitDialogTitle(param1.kind,_loc2_);
      }
      
      private function useRaid(param1:Build) : void
      {
         if(this.isUpdate)
         {
            this.dialog.addAbout("bl_portal_up");
         }
      }
      
      private function checkConstructionAction(param1:uint) : Boolean
      {
         var _loc2_:MapAction = CoreLogic.getAction(ActionLogic.FINISH_RESEARCH,param1);
         if(_loc2_)
         {
            this.dialog.addUpdateButton(this.updatePrice,this.updateDuration,this.onConstructionUpdate,_loc2_,true);
            return true;
         }
         return false;
      }
      
      private function onConstructionUp(param1:CommonEvent) : void
      {
         if(param1.data === this.data)
         {
            this.dialog.close();
            Facade.mainMediator.showDialog(new FeatureMediator(this.data,this.isUpdate),true);
         }
      }
      
      private function getShopDialog(param1:PShopCannon) : void
      {
         this.dialog = new FeatureDialog(param1.sc_kind,param1.sc_level,true);
         this.useCannon(param1);
      }
      
      private function onSoldierUpdate(param1:MouseEvent = null) : void
      {
         var _loc2_:ResearchDialog = Facade.mainMediator.searchDialog(ResearchDialog);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:ResearchMediator = _loc2_.mediator as ResearchMediator;
         if(CoreLogic.getAction(ActionLogic.FINISH_RESEARCH))
         {
            _loc3_.speedup(this.onSoldierUpdate);
            return;
         }
         var _loc4_:PShopUnit = this.data as PShopUnit;
         if(ShopLogic.checkPrice(_loc4_.su_upgrade_price,this.onSoldierUpdate))
         {
            _loc3_.start(_loc4_);
            this.dialog.close();
         }
      }
      
      private function getSoldierDialog(param1:PShopUnit) : void
      {
         this.dialog = new FeatureDialog(param1.su_kind,param1.su_level,!this.isUpdate,param1.su_model_level,param1.su_is_hero && !this.isUpdate,!param1.su_is_hero);
         var _loc2_:PShopUnit = param1;
         if(this.isUpdate && param1.su_level > 1)
         {
            param1 = mp.getSoldierShop(param1.su_kind,param1.su_level - 1);
         }
         if(param1.su_is_hero)
         {
            this.useHero(param1,_loc2_);
         }
         else
         {
            this.addStaminaItem(param1.su_stamina,_loc2_.su_stamina);
            this.addArmorItem(param1.su_armor,_loc2_.su_armor);
            if(param1.su_is_healer)
            {
               this.addItem("HealingIcon","healing",param1.su_damage,_loc2_.su_damage);
            }
            else
            {
               this.addItem("BarrackIcon","damage",param1.su_damage,_loc2_.su_damage);
               this.addItem("BarrackIcon","damage_sec",param1.su_damage * 1000 / (param1.su_attack_time + param1.su_attack_delay),_loc2_.su_damage * 1000 / (_loc2_.su_attack_time + _loc2_.su_attack_delay));
            }
            this.addItem(CostHelper.getKind(param1.su_price.variance),"price").setOnlySuffix(CostHelper.get18StringC(param1.su_price) + (param1.su_price.value != _loc2_.su_price.value ? FeatureRenderer.addUpdateStyle("+" + (_loc2_.su_price.value - param1.su_price.value)) : ""));
         }
         if(this.isUpdate)
         {
            if(!param1.su_is_hero)
            {
               this.dialog.addUpdateButton(_loc2_.su_upgrade_price,_loc2_.su_upgrade_time,this.onSoldierUpdate,CoreLogic.getAction(ActionLogic.FINISH_RESEARCH),true);
            }
         }
         else
         {
            if(param1.su_hspace > 0)
            {
               this.addItem("ArmyCapacityIcon","soldierSpace",param1.su_hspace);
            }
            if(param1.su_radius > 0)
            {
               this.addItem("RadiusIcon","radius",param1.su_radius);
            }
            this.addItem("AttackSpeedIcon","attackSpeed").setOnlySuffix(((param1.su_attack_time + param1.su_attack_delay) / 1000).toFixed(1) + Lang.getTimeShortString(Lang.SECOND));
         }
         var _loc3_:Array = param1.su_info_icons.slice();
         this.applyPenetration(_loc3_,param1.su_penetration);
         if(param1.su_priority_type.variance == PUnitProirityType.FENCE)
         {
            _loc3_.unshift("infoFences");
         }
         if(param1.su_is_kamikaze)
         {
            _loc3_.unshift("infoSuicide");
         }
         if(param1.su_aoe_radius > 0)
         {
            _loc3_.unshift("infoAoE");
         }
         if(param1.su_is_air)
         {
            _loc3_.unshift("infoFlying");
         }
         if(param1.su_is_clan)
         {
            _loc3_.unshift("infoElite");
         }
         _loc3_.unshift(this.getTargetIcon(param1.su_target_type.variance));
         this.dialog.setExIcons(_loc3_);
      }
      
      private function useHero(param1:PShopUnit, param2:PShopUnit) : void
      {
         var _loc3_:PHero = up.getHeroSpec(param1.su_kind);
         var _loc4_:Boolean = _loc3_ != null;
         var _loc5_:VOFeatureItem = this.addItem("HeroIcon","stamina",param1.su_stamina,param2.su_stamina,this.upgradeType == HERO_HP);
         if(_loc4_)
         {
            this.dialog.grid.addListener(VEvent.VARIANCE,this.onHeroStatUpdate);
            this.applyHeroUpdate(_loc3_.stamina_mod_level,_loc5_,param1,PHeroUpgradeKind.STAMINA);
         }
         var _loc6_:PShopHero = mp.getHeroShop(param1.su_kind,param1.su_level);
         _loc5_ = this.addItem("HeroTimeIcon","hero_duration",_loc6_.sh_reg_time * 1000,this.isUpdate ? uint(mp.getHeroShop(param2.su_kind,param2.su_level).sh_reg_time * 1000) : 0,this.upgradeType == HERO_REGEN);
         _loc5_.isTime = true;
         if(_loc4_)
         {
            this.applyHeroUpdate(_loc3_.recover_mod_level,_loc5_,param1,PHeroUpgradeKind.RECOVER);
         }
         _loc5_ = this.addItem("ArmorIcon","armor",param1.su_armor,param2.su_armor,this.upgradeType == HERO_ARMOR);
         if(_loc4_)
         {
            this.applyHeroUpdate(_loc3_.armor_mod_level,_loc5_,param1,PHeroUpgradeKind.ARMOR);
         }
         _loc5_ = this.addItem("BarrackIcon","damage",param1.su_damage,param2.su_damage,this.upgradeType == HERO_DMG);
         if(_loc4_)
         {
            this.applyHeroUpdate(_loc3_.damage_mod_level,_loc5_,param1,PHeroUpgradeKind.DAMAGE);
         }
         _loc5_ = this.addItem("BarrackIcon","damage_sec",param1.su_damage * 1000 / (param1.su_attack_time + param1.su_attack_delay));
         if(_loc4_)
         {
            this.applyHeroUpdate(_loc3_.damage_mod_level,_loc5_,param1,PHeroUpgradeKind.DAMAGE);
         }
         _loc5_.updateData = null;
         _loc5_.max = 0;
         this.dialog.addUpdateUnitTitle(param1.su_kind,up.getHeroLevel(param1.su_kind),mp.getHeroUpdateShop(param1.su_kind,1,PHeroUpgradeKind.STAMINA).shu_price.variance);
         this.dialog.resPanel.useTrack();
      }
      
      private function applyHeroUpdate(param1:uint, param2:VOFeatureItem, param3:PShopUnit, param4:uint) : void
      {
         var _loc5_:PRequirement = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(!this.isUpdate)
         {
            param2.updateData = mp.getHeroUpdateShop(param3.su_kind,param1 + 1,param4,true);
            if(param2.updateData)
            {
               _loc7_ = param2.updateData.shu_effect;
               if(param4 == PHeroUpgradeKind.RECOVER)
               {
                  _loc7_ *= -1000;
               }
               _loc7_ += param2.cur;
               param2.max = _loc7_ > 0 ? uint(_loc7_) : 1;
               _loc5_ = param2.updateData.shu_upgrade_requirement;
               if(_loc5_.req_building_level > 0 && up.checkBuild(_loc5_.req_building_kind,_loc5_.req_building_level))
               {
                  _loc5_.req_building_level = 0;
               }
            }
         }
         if(param1 > 0)
         {
            _loc6_ = mp.getHeroUpdateShop(param3.su_kind,param1,param4).shu_effect;
            if(param4 == PHeroUpgradeKind.RECOVER)
            {
               _loc6_ *= -1000;
            }
            _loc7_ = _loc6_ + param2.cur;
            param2.cur = _loc7_ > 0 ? uint(_loc7_) : 0;
            if(this.isUpdate)
            {
               if(param2.max > 0)
               {
                  _loc7_ = _loc6_ + param2.max;
                  param2.max = _loc7_ > 0 ? uint(_loc7_) : 1;
               }
            }
            else if(!param2.updateData)
            {
               param2.max = param2.cur;
            }
         }
      }
      
      private function useTownHall(param1:Build) : void
      {
         var _loc3_:PTownhallUnlock = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc2_:Boolean = this.isUpdate || this.isOfferMode;
         if(!Facade.isCapital)
         {
            if(_loc2_)
            {
               _loc3_ = mp.getTownHallUnlock(this.isOfferMode ? param1.level : uint(param1.level + 1));
            }
            this.addItem("StealPercentIcon","stealPercent",mp.getTownHallUnlock(this.isOfferMode ? up.townHallLevel : param1.level).tu_storage_fight_k * 100,_loc2_ ? uint(_loc3_.tu_storage_fight_k * 100) : 0).suffix = "%";
            if(_loc2_)
            {
               _loc4_ = up.energyMax;
               _loc5_ = up.energyMax + (_loc3_.tu_calls - up.energyMax);
            }
            else
            {
               _loc4_ = up.energy;
               _loc5_ = up.energyMax;
            }
            this.addItem("Energy","Energy",_loc4_,_loc5_).isCompare = !_loc2_;
            this.addItem("ClockIcon","campDuration",Facade.userProxy.getEnergyCooldown() * 1000).isTime = true;
         }
         else if(_loc2_)
         {
            this.addItem("TerritoryIcon","limit_territory",Facade.manualProxy.getClanLeagueByNum(param1.shop.sb_level).cd_ter_limit,Facade.manualProxy.getClanLeagueByNum(param1.shop.sb_level).cd_ter_limit + 1);
         }
         else
         {
            this.addItem("TerritoryIcon","limit_territory",Facade.manualProxy.getClanLeagueByNum(param1.shop.sb_level).cd_ter_limit);
         }
         if(_loc2_ && param1.level < mp.townHallUnlockList.length)
         {
            this.addTownHallUpdate(param1);
         }
      }
      
      private function addTownHallUpdate(param1:Build) : void
      {
         var _loc4_:String = null;
         var _loc5_:Boolean = false;
         var _loc6_:Dictionary = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:PShopCannon = null;
         var _loc10_:PShopBuilding = null;
         var _loc11_:VOTownHallItem = null;
         var _loc12_:PClanDivision = null;
         var _loc13_:VComponent = null;
         var _loc14_:Object = null;
         var _loc15_:VGrid = null;
         var _loc2_:Dictionary = mp.townHallUnlockList[param1.level];
         if(this.isOfferMode)
         {
            _loc6_ = mp.townHallUnlockList[up.townHallLevel];
         }
         else
         {
            _loc6_ = mp.townHallUnlockList[param1.level - 1];
         }
         var _loc3_:Array = [];
         for(_loc4_ in _loc2_)
         {
            _loc7_ = uint(_loc2_[_loc4_]);
            _loc8_ = _loc6_.hasOwnProperty(_loc4_) ? uint(_loc6_[_loc4_]) : 0;
            if(_loc8_ == 0)
            {
               _loc9_ = mp.getCannonShop(_loc4_,1,true);
               if((Boolean(_loc9_)) && !_loc9_.sc_can_buy)
               {
                  _loc7_ = 0;
               }
               else
               {
                  _loc10_ = mp.getBuildShop(_loc4_,1,true);
                  if((Boolean(_loc10_)) && !_loc10_.sb_can_buy)
                  {
                     _loc7_ = 0;
                  }
               }
            }
            if(_loc7_ > _loc8_)
            {
               _loc11_ = new VOTownHallItem();
               _loc11_.kind = _loc4_;
               _loc11_.count = _loc7_ - _loc8_;
               _loc11_.usePlus = true;
               _loc3_.push(_loc11_);
            }
         }
         _loc5_ = _loc3_.length > 0;
         if(Facade.isCapital)
         {
            _loc12_ = mp.getClanLeagueByNum(mp.getDivisionByLevel(param1.level + 1).division,true);
            if((Boolean(_loc12_)) && _loc12_.cd_num == Facade.userProxy.clanData.base.division)
            {
               _loc12_ = null;
            }
         }
         if(_loc5_ || Boolean(_loc12_))
         {
            _loc13_ = new VComponent();
            _loc14_ = {"wP":100};
            _loc13_.add(new VText(Lang.getString("unlock"),VText.CONTAIN_CENTER,Style.darkKhakiRGB,16),_loc14_);
            if(_loc5_)
            {
               _loc15_ = new VGrid(5,1,TownHallRenderer,_loc3_,7,0,VGrid.USE_VISIBLE_CALC_LAYOUT);
               _loc13_.add(_loc15_,{
                  "top":19,
                  "left":28,
                  "right":28
               });
               UIFactory.useGridControlNav(_loc15_,UIFactory.addNavBt30);
            }
            if(_loc12_)
            {
               _loc13_.add(this.dialog.createClanLeague(_loc12_.cd_num,_loc12_.cd_region),{
                  "hCenter":0,
                  "top":21
               });
               if(_loc5_)
               {
                  _loc15_.top = 132;
               }
            }
            this.dialog.descBox.add(_loc13_,_loc14_,0);
         }
      }
      
      private function useSoldierUnlock(param1:Build, param2:Boolean = false) : void
      {
         var _loc4_:PShopUnit = null;
         var _loc5_:uint = 0;
         var _loc6_:Build = null;
         var _loc7_:uint = 0;
         var _loc8_:PRequirement = null;
         var _loc9_:Boolean = false;
         var _loc10_:VOBattleItem = null;
         var _loc11_:PShopSpell = null;
         var _loc12_:CampSoldierPanel = null;
         if(this.isOfferMode)
         {
            _loc5_ = param1.level;
            _loc6_ = up.getBuildEx(param1.kind,false);
            _loc7_ = _loc6_ ? _loc6_.level : 0;
         }
         else
         {
            _loc7_ = param1.level;
            _loc5_ = _loc7_ + 1;
         }
         var _loc3_:Array = [];
         for each(_loc4_ in mp.soldierShopList)
         {
            if(!(!_loc4_.su_can_buy || _loc4_.su_is_clan != Facade.isCapital))
            {
               if(!(Boolean(_loc4_.su_event_requirement) && !ShopLogic.checkRequierement(_loc4_.su_event_requirement)))
               {
                  _loc8_ = _loc4_.su_upgrade_requirement;
                  if(_loc8_.req_building_level > _loc7_ && _loc8_.req_building_level <= _loc5_ && param1.kind == _loc8_.req_building_kind)
                  {
                     _loc9_ = true;
                     for each(_loc10_ in _loc3_)
                     {
                        if(_loc10_.shop.su_kind == _loc4_.su_kind)
                        {
                           if(_loc4_.su_level > _loc10_.shop.su_level)
                           {
                              _loc10_.shop = _loc4_;
                           }
                           _loc9_ = false;
                           break;
                        }
                     }
                     if(_loc9_)
                     {
                        _loc10_ = new VOBattleItem();
                        _loc10_.shop = _loc4_;
                        _loc3_.push(_loc10_);
                     }
                  }
               }
            }
         }
         if(param2)
         {
            for each(_loc11_ in mp.spellShopList)
            {
               if(!(!_loc11_.ssp_can_buy || Facade.isCapital))
               {
                  _loc8_ = _loc11_.ssp_upgrade_requirement;
                  if(_loc8_.req_building_level > _loc7_ && _loc8_.req_building_level <= _loc5_ && param1.kind == _loc8_.req_building_kind)
                  {
                     _loc9_ = true;
                     for each(_loc10_ in _loc3_)
                     {
                        if(Boolean(_loc10_.spellShop) && _loc10_.spellShop.ssp_kind == _loc11_.ssp_kind)
                        {
                           if(_loc11_.ssp_level > _loc10_.spellShop.ssp_level)
                           {
                              _loc10_.spellShop = _loc11_;
                           }
                           _loc9_ = false;
                           break;
                        }
                     }
                     if(_loc9_)
                     {
                        _loc10_ = new VOBattleItem();
                        _loc10_.spellShop = _loc11_;
                        _loc3_.push(_loc10_);
                     }
                  }
               }
            }
         }
         if(_loc3_.length > 0)
         {
            _loc12_ = new CampSoldierPanel(Lang.getString("unlock"),Style.darkKhakiRGB);
            _loc12_.setDp(_loc3_,6);
            this.dialog.descBox.add(_loc12_,null,0);
         }
      }
      
      private function usePylon(param1:Build) : void
      {
         this.addItem("RadiusIcon","radius",param1.spec.radius,this.isUpdate ? mp.getPylonShop(param1.kind,param1.level + 1).sp_radius : 0);
      }
      
      private function useGuard(param1:Build) : void
      {
         var _loc3_:PShopGuard = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc2_:VOGuardSpec = param1.spec;
         if(this.isUpdate)
         {
            _loc3_ = mp.getGuardShop(param1.kind,param1.level + 1);
            _loc4_ = _loc2_.chargeMax;
            _loc5_ = _loc3_.sga_charge_count;
         }
         else
         {
            _loc4_ = _loc2_.chargeCur;
            _loc5_ = _loc2_.chargeMax;
         }
         this.addItem("RadiusIcon","radius",_loc2_.radius,this.isUpdate ? _loc3_.sga_radius : 0);
         this.addItem("ArmyCapacityIcon","guardCapacity",_loc2_.capacity,this.isUpdate ? _loc3_.sga_capacity : 0);
         this.addItem("GuardIcon","guardCharge",_loc4_,_loc5_).isCompare = !this.isUpdate;
      }
      
      private function useStorage(param1:Build) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc2_:VOStorageSpec = param1.spec as VOStorageSpec;
         if(this.isUpdate)
         {
            _loc3_ = _loc2_.capacityMax;
            _loc4_ = mp.getStorageShop(param1.kind,param1.level + 1).ss_capacity.value;
         }
         else
         {
            _loc3_ = _loc2_.capacityCur;
            _loc4_ = _loc2_.capacityMax;
         }
         this.addItem(CostHelper.getKind(_loc2_.costVariance) + "CapacityIcon","capacity",_loc3_,_loc4_).isCompare = !this.isUpdate;
      }
      
      private function useResource(param1:Build) : void
      {
         var _loc4_:PShopResource = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc2_:VOResourceSpec = param1.spec as VOResourceSpec;
         _loc5_ = Math.round(_loc2_.prodValue * _loc2_.prodTime);
         if(this.isUpdate)
         {
            _loc4_ = mp.getResourceShop(param1.kind,param1.level + 1);
            _loc6_ = _loc4_.sr_cost.value;
         }
         this.addItem(CostHelper.getKind(_loc2_.prodVariance),"production",_loc5_,_loc6_).suffix = " " + Lang.getPatternString("resource_prod","__TIME__",StringHelper.getTimeDesc(_loc2_.prodTime,true));
         if(this.isUpdate)
         {
            _loc5_ = _loc2_.capacityMax;
            _loc6_ = _loc4_.sr_capacity;
         }
         else
         {
            if(this.isOfferMode)
            {
               _loc5_ = 0;
            }
            else
            {
               BuildLogic.calcResource(param1);
               _loc5_ = _loc2_.capacityCur;
            }
            _loc6_ = _loc2_.capacityMax;
         }
         var _loc3_:VOFeatureItem = this.addItem(CostHelper.getKind(_loc2_.prodVariance) + "CapacityIcon","capacity",_loc5_,_loc6_);
         if(!this.isUpdate)
         {
            _loc3_.isCompare = true;
            if(param1.updateLevel == 0 && _loc2_.capacityCur < _loc2_.capacityMax && !this.isOfferMode)
            {
               _loc3_.trackPeriod = 1 / _loc2_.prodValue;
               _loc3_.trackEndTime = _loc2_.lastTime + (_loc2_.capacityMax - _loc2_.capacityCur) / _loc2_.prodValue;
               _loc3_.trackDuration = _loc2_.capacityMax / _loc2_.prodValue;
            }
         }
      }
      
      private function useBarrack(param1:Build) : void
      {
         if(this.isUpdate || this.isOfferMode)
         {
            this.useSoldierUnlock(param1);
         }
         else
         {
            this.addSoldierList();
         }
      }
      
      private function addSoldierList() : void
      {
         var _loc2_:CampSoldierPanel = null;
         if(!Facade.isMyMap)
         {
            return;
         }
         var _loc1_:Array = getMySoldierDp();
         if(_loc1_)
         {
            _loc2_ = new CampSoldierPanel(Lang.getString("shop_army"),Style.darkKhakiRGB);
            this.dialog.descBox.add(_loc2_,null,0);
            _loc2_.setDp(_loc1_,6);
         }
      }
      
      private function useCamp(param1:Build) : void
      {
         var _loc2_:PShopCamp = null;
         var _loc5_:uint = 0;
         var _loc6_:PShopCamp = null;
         if(this.isOfferMode)
         {
            try
            {
               _loc2_ = mp.getCampShop(up.getBuild(PBtype.CAMP,false).level);
            }
            catch(error:Error)
            {
            }
         }
         if(!_loc2_)
         {
            _loc2_ = mp.getCampShop(param1.level);
         }
         var _loc3_:uint = _loc2_.sca_capacity;
         var _loc4_:Boolean = this.isUpdate || this.isOfferMode;
         if(_loc4_)
         {
            _loc5_ = _loc3_;
            _loc6_ = mp.getCampShop(this.isOfferMode ? param1.level : uint(param1.level + 1));
            _loc3_ = _loc6_.sca_capacity;
         }
         else
         {
            _loc5_ = up.soldierCapacityCur;
         }
         this.addItem("ArmyCapacityIcon","capacity",_loc5_,_loc3_).isCompare = !_loc4_;
         if(!_loc4_)
         {
            this.addSoldierList();
         }
      }
      
      private function useShield(param1:Build) : void
      {
         var _loc3_:PShopShieldGen = null;
         var _loc2_:PShopShieldGen = mp.getShieldShop(param1.kind,param1.level);
         if(this.isUpdate)
         {
            _loc3_ = mp.getShieldShop(param1.kind,param1.level + 1);
         }
         this.addItem("ShieldStat","shield_stat",_loc2_.ssg_time * 1000,this.isUpdate ? uint(_loc3_.ssg_time * 1000) : 0).isTime = true;
         this.addItem("ShieldCooldown","hero_duration",_loc2_.ssg_cooldown * 1000,this.isUpdate ? uint(_loc3_.ssg_cooldown * 1000) : 0).isTime = true;
      }
      
      private function useCannon(param1:PShopCannon) : uint
      {
         var _loc4_:PShopCannon = null;
         if(this.isUpdate)
         {
            _loc4_ = mp.getCannonShop(param1.sc_kind,param1.sc_level + 1);
            this.updatePrice = _loc4_.sc_price;
            this.updateDuration = _loc4_.sc_upgrade_time;
         }
         this.addStaminaItem(param1.sc_stamina,this.isUpdate ? _loc4_.sc_stamina : 0);
         this.addArmorItem(param1.sc_armor,this.isUpdate ? _loc4_.sc_armor : 0);
         if(param1.sc_damage > 0)
         {
            this.addItem("BarrackIcon","damage",param1.sc_damage,this.isUpdate ? _loc4_.sc_damage : 0);
         }
         if(param1.sc_radius < 15)
         {
            this.addItem("RadiusIcon","radius",param1.sc_radius);
         }
         if(param1.sc_blind_radius > 0)
         {
            this.addItem("BlindRadiusIcon","blindRadius",param1.sc_blind_radius);
         }
         var _loc2_:String = Lang.getTimeShortString(Lang.SECOND);
         this.addItem("AttackSpeedIcon","attackSpeed").setOnlySuffix(((param1.sc_attack_time + param1.sc_attack_delay) / 1000).toFixed(1) + _loc2_);
         if(param1.sc_slowdown > 0)
         {
            this.addItem("FreezPercIcon","freezPercentage",param1.sc_slowdown,this.isUpdate ? _loc4_.sc_slowdown : 0).suffix = "%";
            this.addItem("FreezTimeIcon","freezTime").setOnlySuffix((param1.sc_slowdown_time / 1000).toFixed(1) + _loc2_);
         }
         var _loc3_:Array = param1.sc_info_icons.slice();
         this.applyPenetration(_loc3_,param1.sc_penetration);
         if(param1.sc_aoe_radius > 0)
         {
            _loc3_.unshift("infoAoE");
         }
         _loc3_.unshift(this.getTargetIcon(param1.sc_target_type.variance));
         this.dialog.setExIcons(_loc3_);
         return this.isUpdate ? _loc4_.sc_townhall_req : 0;
      }
      
      private function applyPenetration(param1:Array, param2:Number) : void
      {
         if(param2 > 1)
         {
            if(param2 < 4)
            {
               param1.push("infoPenetrationLow");
            }
            else if(param2 < 8)
            {
               param1.push("infoPenetrationMid");
            }
            else
            {
               param1.push("infoPenetrationHigh");
            }
            param1.push(param2);
         }
      }
      
      private function useFence(param1:PShopFence) : uint
      {
         var _loc2_:PShopFence = null;
         if(this.isUpdate)
         {
            _loc2_ = mp.getFenceShop(param1.sf_kind,param1.sf_level + 1);
            this.updatePrice = _loc2_.sf_price;
            this.updateDuration = 0;
         }
         else
         {
            _loc2_ = param1;
         }
         this.addStaminaItem(param1.sf_stamina,_loc2_.sf_stamina);
         this.addArmorItem(param1.sf_armor,_loc2_.sf_armor);
         return this.isUpdate ? _loc2_.sf_townhall_req : 0;
      }
      
      private function getTargetIcon(param1:uint) : String
      {
         if(param1 == PCannonTargetType.GROUND)
         {
            return "infoTargetsGround";
         }
         if(param1 == PCannonTargetType.AIR)
         {
            return "infoTargetsAir";
         }
         return "infoTargetsAny";
      }
      
      private function onHeroStatUpdate(param1:VEvent) : void
      {
         var _loc3_:VOFeatureItem = param1.data;
         var _loc4_:PShopUpgradeHero = _loc3_.updateData;
         var _loc5_:uint = _loc4_.shu_upgrade_requirement.req_building_level;
         if(_loc5_ > 0)
         {
            Facade.mainMediator.showMessage(Lang.getPatternString("bl_hero_req","__LEVEL__",_loc5_.toString()),null,UnitPanel.createForMessage("bl_hero_workshop",_loc5_),MessageDialog.UNIT_ICON);
            return;
         }
         if(!ShopLogic.checkPrice(_loc4_.shu_price,this.onHeroStatUpdate,arguments))
         {
            return;
         }
         ShopLogic.applyCost(_loc4_.shu_price,true);
         var _loc6_:PHero = up.getHeroSpec(_loc4_.shu_hero_kind);
         _loc5_ = _loc4_.shu_kind.variance;
         ActionLogic.removeHeroRecovery(_loc6_);
         var _loc7_:PShopUnit = this.data as PShopUnit;
         if(_loc5_ == PHeroUpgradeKind.DAMAGE)
         {
            _loc3_.cur = _loc7_.su_damage;
            this.applyHeroUpdate(++_loc6_.damage_mod_level,_loc3_,_loc7_,PHeroUpgradeKind.DAMAGE);
         }
         else if(_loc5_ == PHeroUpgradeKind.STAMINA)
         {
            _loc3_.cur = _loc7_.su_stamina;
            this.applyHeroUpdate(++_loc6_.stamina_mod_level,_loc3_,_loc7_,PHeroUpgradeKind.STAMINA);
         }
         else if(_loc5_ == PHeroUpgradeKind.ARMOR)
         {
            _loc3_.cur = _loc7_.su_armor;
            this.applyHeroUpdate(++_loc6_.armor_mod_level,_loc3_,_loc7_,PHeroUpgradeKind.ARMOR);
         }
         else
         {
            if(_loc5_ != PHeroUpgradeKind.RECOVER)
            {
               throw new Error("onHeroStatUpdate bad variance " + _loc5_);
            }
            _loc3_.cur = mp.getHeroShop(_loc7_.su_kind,_loc7_.su_level).sh_reg_time * 1000;
            this.applyHeroUpdate(++_loc6_.recover_mod_level,_loc3_,_loc7_,PHeroUpgradeKind.RECOVER);
         }
         _loc5_ = uint(up.soldierLevelHash[_loc7_.su_kind] = up.getHeroLevel(_loc7_.su_kind));
         ActionLogic.addRecoveryHero(_loc6_);
         ActionLogic.request(PUserAction.UPGRADE_HERO,PUpgradeHero.create(_loc4_.shu_hero_kind,_loc4_.shu_kind));
         if(_loc7_.su_level != _loc5_ || true)
         {
            Facade.mainMediator.showDialog(new FeatureMediator(mp.getSoldierShop(_loc7_.su_kind,_loc5_)));
            this.dialog.close();
         }
         else
         {
            this.dialog.grid.sync();
         }
      }
      
      private function useClan(param1:Build) : void
      {
         var _loc2_:Boolean = !Facade.isCapital;
         var _loc3_:uint = mp.getClanCapacity(param1.level,_loc2_);
         var _loc4_:uint = _loc3_;
         if(this.isUpdate)
         {
            _loc3_ = mp.getClanCapacity(param1.level + 1,_loc2_);
         }
         if(_loc2_)
         {
            if(!this.isUpdate)
            {
               _loc4_ = up.clanEnergy;
            }
            this.addItem("CallRequestIcon","capacity",_loc4_,_loc3_).isCompare = !this.isUpdate;
         }
         else
         {
            this.addItem("MembersIcon","clan_capacity",_loc4_,_loc3_);
         }
      }
      
      private function useLibrary(param1:Build) : void
      {
         var _loc5_:Array = null;
         var _loc6_:PShopSpell = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Build = null;
         var _loc10_:uint = 0;
         var _loc11_:PRequirement = null;
         var _loc12_:VOBattleItem = null;
         var _loc13_:CampSoldierPanel = null;
         var _loc2_:PShopLibrary = mp.getLibraryShop(param1.level);
         var _loc3_:PShopLibrary = this.isUpdate ? mp.getLibraryShop(param1.level + 1) : _loc2_;
         this.addItem("Power","start_power",_loc2_.sl_start_power,_loc3_.sl_start_power);
         var _loc4_:uint = _loc2_.sl_book_size;
         if(this.isUpdate)
         {
            _loc7_ = _loc4_;
            _loc4_ = _loc3_.sl_book_size;
         }
         else
         {
            _loc7_ = up.spellList.length;
         }
         this.addItem("SpellIcon","capacity",_loc7_,_loc4_).isCompare = !this.isUpdate;
         if(!this.isUpdate && !this.isOfferMode)
         {
            return;
         }
         if(this.isOfferMode)
         {
            _loc8_ = param1.level;
            _loc9_ = up.getBuildEx(param1.kind,false);
            _loc10_ = _loc9_ ? _loc9_.level : 0;
         }
         else
         {
            _loc10_ = param1.level;
            _loc8_ = _loc10_ + 1;
         }
         for each(_loc6_ in mp.spellShopList)
         {
            if(_loc6_.ssp_can_buy)
            {
               _loc11_ = _loc6_.ssp_upgrade_requirement;
               if(_loc11_.req_building_level > _loc10_ && _loc11_.req_building_level <= _loc8_ && param1.kind == _loc11_.req_building_kind)
               {
                  _loc12_ = new VOBattleItem();
                  _loc12_.spellShop = _loc6_;
                  if(!_loc5_)
                  {
                     _loc5_ = [];
                  }
                  _loc5_.push(_loc12_);
               }
            }
         }
         if(_loc5_)
         {
            _loc13_ = new CampSoldierPanel(Lang.getString("unlock"),Style.darkKhakiRGB);
            _loc13_.setDp(_loc5_,6);
            this.dialog.descBox.add(_loc13_,null,0);
         }
      }
      
      private function getSpellDialog(param1:PShopSpell) : void
      {
         this.dialog = new FeatureDialog(param1.ssp_kind,param1.ssp_level,!this.isUpdate,1);
         var _loc2_:PShopSpell = param1;
         var _loc3_:* = param1.ssp_effect.value;
         var _loc4_:* = _loc3_;
         if(this.isUpdate && param1.ssp_level > 1)
         {
            param1 = mp.getSpellShop(param1.ssp_kind,param1.ssp_level - 1);
            _loc3_ = param1.ssp_effect.value;
         }
         this.addItem("Power","power_price",param1.ssp_power_price,_loc2_.ssp_power_price);
         var _loc5_:uint = param1.ssp_effect.variance;
         switch(_loc5_)
         {
            case PEffect.FIREBALL:
               this.useFireball(_loc3_,_loc4_);
               break;
            case PEffect.CALL:
               this.useCall(_loc3_,_loc4_);
               break;
            case PEffect.CURE:
               this.useCure(_loc3_,_loc4_);
               break;
            case PEffect.SHOCK:
               this.useShock(_loc3_,_loc4_);
               break;
            case PEffect.LOW_DAMAGE:
               this.useStoneSkin(_loc3_,_loc4_);
               break;
            case PEffect.MULTIFIREBALL:
               this.useAcid(_loc3_,_loc4_);
               break;
            case PEffect.RAGE:
               this.useRage(_loc3_,_loc4_);
               break;
            case PEffect.FOG:
               this.useFog(_loc3_,_loc4_);
         }
         if(this.isUpdate)
         {
            this.dialog.addUpdateButton(_loc2_.ssp_upgrade_price,_loc2_.ssp_upgrade_time,this.onSoldierUpdate,CoreLogic.getAction(ActionLogic.FINISH_RESEARCH),true);
         }
      }
      
      private function useFireball(param1:PFireball, param2:PFireball) : void
      {
         this.addItem("BarrackIcon","damage",param1.fireball_damage,param2.fireball_damage);
         this.addItem("RadiusIcon","radius",param1.fireball_radius,param2.fireball_radius);
      }
      
      private function useCall(param1:PCall, param2:PCall) : void
      {
         this.addItem("ClockIcon","duration",param1.call_duration,param2.call_duration).isTime = true;
      }
      
      private function useCure(param1:PCure, param2:PCure) : void
      {
         this.addItem("HealingIcon","healing",param1.cure_stamina * param1.cure_count,param2.cure_stamina * param1.cure_count);
         this.addItem("ClockIcon","duration",param1.cure_duration * param1.cure_count,param1.cure_duration * param1.cure_count).isTime = true;
         this.addItem("RadiusIcon","radius",param1.cure_radius,param2.cure_radius);
      }
      
      private function useShock(param1:PShock, param2:PShock) : void
      {
         this.addItem("ClockIcon","duration",param1.shock_duration,param2.shock_duration).isTime = true;
         this.addItem("RadiusIcon","radius",param1.shock_radius,param2.shock_radius);
      }
      
      private function useStoneSkin(param1:PLowDamage, param2:PLowDamage) : void
      {
         this.addItem("ArmorIcon","dec_damage",(1 - param1.low_damage_k) * 100,(1 - param2.low_damage_k) * 100).suffix = "%";
         this.addItem("ClockIcon","duration",param1.low_damage_duration,param2.low_damage_duration).isTime = true;
         this.addItem("RadiusIcon","radius",param1.low_damage_radius,param2.low_damage_radius);
      }
      
      private function useAcid(param1:PMultifireball, param2:PMultifireball) : void
      {
         this.addItem("BarrackIcon","damage",param1.mf_damage,param2.mf_damage).preSuffix = "x10";
         this.addItem("ClockIcon","duration",param1.mf_period * param1.mf_count,param2.mf_period * param2.mf_count).isTime = true;
         this.addItem("RadiusIcon","radius",param1.mf_radius,param2.mf_radius);
         var _loc3_:Array = [];
         this.applyPenetration(_loc3_,param1.mf_penetration);
         this.dialog.setExIcons(_loc3_);
      }
      
      private function useRage(param1:PRage, param2:PRage) : void
      {
         this.addItem("AttackSpeedIcon","attackSpeed",(1 - param1.rage_attack_k) * 100,(1 - param2.rage_attack_k) * 100).suffix = "%";
         this.addItem("ClockIcon","duration",param1.rage_duration,param2.rage_duration).isTime = true;
         this.addItem("RadiusIcon","radius",param1.rage_radius,param2.rage_radius);
      }
      
      private function useFog(param1:PFog, param2:PFog) : void
      {
         this.addItem("ClockIcon","duration",param1.fog_duration,param2.fog_duration).isTime = true;
         this.addItem("RadiusIcon","radius",param1.fog_radius,param2.fog_radius);
      }
   }
}

