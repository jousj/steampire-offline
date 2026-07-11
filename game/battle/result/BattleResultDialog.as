package game.battle.result
{
   import engine.signal.Signal;
   import engine.signal.Tween;
   import flash.events.MouseEvent;
   import game.battle.common.WinTargetAfterRenderer;
   import game.battle.common.WinTargetRenderer;
   import game.feature.CampSoldierPanel;
   import proto.model.PCost;
   import proto.model.PFightType;
   import proto.model.PShareFight;
   import proto.model.PShopBuilding;
   import proto.model.PSign;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.game.ShineClip;
   import ui.game.ShopNewIcon;
   import ui.game.UnitClipPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   
   public class BattleResultDialog extends BaseDialog
   {
      
      public const panel:VComponent;
      
      private const centerOffset:uint;
      
      private const packName:String = "BattleResultDialog";
      
      private var prizeList:Array;
      
      private var ratingPanel:StatPanel;
      
      private var pricePanel:PriceListPanel;
      
      private var raidRenderList:Vector.<VRenderer>;
      
      private var damage:uint;
      
      private var isWin:Boolean;
      
      private var fightType:uint;
      
      private var targetName:String;
      
      public function BattleResultDialog(param1:Boolean, param2:PShareFight, param3:uint, param4:String = null)
      {
         var _loc5_:RectButton = null;
         var _loc6_:ShineClip = null;
         this.panel = new VComponent();
         this.centerOffset = Facade.fakeResize ? 60 : 80;
         super();
         this.isWin = param1;
         this.fightType = param3;
         this.targetName = param4;
         stretch();
         this.panel.setSize(600,515);
         this.panel.useCenter(this.centerOffset);
         addChild(this.panel);
         this.panel.add(SkinManager.getEmbed("PaperDialogBg",VSkin.STRETCH),{
            "wP":100,
            "hP":100,
            "hCenter":-5
         });
         this.panel.add(SkinManager.getPack(this.packName,param1 ? "winner" : "loser"),{
            "left":-210,
            "vCenter":0
         });
         this.panel.add(UIFactory.createDecorText(Lang.getString(param1 ? "victory" : "defeat"),param1,param1 ? 48 : 30),{
            "top":25,
            "hCenter":0
         });
         closeBt = new RectButton(Lang.getString("bt_good"),RectButton.h56);
         closeBt.addClickListener(close);
         if(param2)
         {
            _loc5_ = new RectButton(Lang.getString("share"),RectButton.h56,RectButton.ORANGE);
            _loc5_.addClickListener(this.onShare,param1 ? param2.win_sign : param2.lose_sign);
            this.panel.addChild(new VBox(new <VComponent>[closeBt,_loc5_],14));
         }
         else
         {
            this.panel.addChild(closeBt);
         }
         (this.panel.getChildAt(this.panel.numChildren - 1) as VComponent).bottom = 20;
         if(param1)
         {
            _loc6_ = new ShineClip();
            add(_loc6_,{
               "hCenter":this.centerOffset,
               "vCenter":0
            },0);
         }
         this.panel.cacheAsBitmap = true;
      }
      
      private function applyHCenter() : void
      {
         var _loc1_:* = int(this.panel.numChildren - 1);
         while(_loc1_ >= 3)
         {
            (this.panel.getChildAt(_loc1_) as VComponent).hCenter = 0;
            _loc1_--;
         }
      }
      
      private function addToPanel(param1:VComponent, param2:int) : void
      {
         param1.top = param2;
         this.panel.addChild(param1);
      }
      
      private function addSoldierPanel(param1:Array, param2:uint = 0, param3:int = 93) : void
      {
         var _loc4_:CampSoldierPanel = null;
         if(param1.length > 0)
         {
            _loc4_ = new CampSoldierPanel(Lang.getString("your_loss"));
            if(param2 > 0)
            {
               _loc4_.grid.renderList[0].setSize(param2,param2);
            }
            _loc4_.setDp(param1,4);
            _loc4_.bottom = param3;
            this.panel.addChild(_loc4_);
         }
         else
         {
            this.panel.add(new VText(Lang.getString("lossless"),VText.MIDDLE | VText.CENTER,Style.metalRGB,22),{
               "left":110,
               "right":110,
               "bottom":param3 + 1,
               "h":90
            });
         }
      }
      
      private function getPrizeList(param1:Array) : PriceListPanel
      {
         this.pricePanel = new PriceListPanel(25,VSkin.LEFT);
         this.pricePanel.priceMode |= PricePanel.TWEEN;
         this.pricePanel.setStyle(42,24);
         this.pricePanel.assignList(param1);
         this.pricePanel.maxW = 430;
         return this.pricePanel;
      }
      
      public function setAdditionalMode(param1:*) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:RaidResultRenderer = null;
         if(param1 is MouseEvent)
         {
            _loc2_ = true;
            param1 = (param1 as MouseEvent).type == MouseEvent.MOUSE_OVER;
         }
         if(this.fightType == PFightType.GROUP)
         {
            for each(_loc3_ in this.raidRenderList)
            {
               if(_loc3_.isMy)
               {
                  _loc3_.setAdditionalMode(param1,true);
               }
            }
         }
         else
         {
            if(this.pricePanel)
            {
               this.pricePanel.setAdditionalMode(param1);
            }
            if(this.fightType == PFightType.SINGLE && Boolean(this.ratingPanel))
            {
               this.ratingPanel.setAdditionalMode(param1,_loc2_);
            }
         }
      }
      
      public function init(param1:Array, param2:uint, param3:Array, param4:Array) : void
      {
         this.prizeList = param1;
         this.damage = param2;
         this.addToPanel(SkinManager.getPack(this.packName,"DSeparator"),200);
         this.addToPanel(SkinManager.getPack(this.packName,"DSeparator"),270);
         this.panel.add(new VText(Lang.getString("battle_result"),VText.CENTER,Style.metalRGB,22),{
            "left":110,
            "right":110,
            "top":85
         });
         var _loc5_:VComponent = new VComponent();
         var _loc6_:VGrid = new VGrid(6,1,WinTargetAfterRenderer,param4,0,4,VGrid.USE_VISIBLE_CALC_LAYOUT);
         _loc5_.add(_loc6_);
         this.addToPanel(_loc5_,110);
         this.addToPanel(this.getPrizeList(param1),215);
         this.addSoldierPanel(param3);
         this.applyHCenter();
         if(this.isWin)
         {
            if(Facade.userProxy.radarEnabled)
            {
               this.setAdditionalMode(true);
            }
            else if(Facade.checkUserStage("home4_hero_click"))
            {
               Signal.delayCall(1.7,this.startAdvertising);
            }
         }
      }
      
      public function addBonus(param1:int, param2:Array, param3:uint, param4:Number) : void
      {
         var _loc7_:StatPanel = null;
         var _loc8_:VBox = null;
         var _loc5_:Boolean = Boolean(param2) && param2.length > 0;
         var _loc6_:Boolean = (_loc5_) || param3 > 0 || !isNaN(param4);
         if(param1 > 0 || !_loc6_)
         {
            _loc7_ = new StatPanel(SkinManager.getEmbed("RatingIcon"),param1,StatPanel.YELLOW_TEXT,5,42,24);
            _loc7_.hint = Lang.getString("rating");
            this.ratingPanel = _loc7_;
         }
         if(_loc6_)
         {
            _loc8_ = new VBox(null,14);
            if(_loc7_)
            {
               _loc8_.add(_loc7_);
               this.ratingPanel = _loc7_;
            }
            if(_loc5_)
            {
               _loc8_.add(this.getPrizeList(param2));
            }
            if(param3 > 0)
            {
               _loc7_ = new StatPanel(SkinManager.getEmbed("MoralIcon"),param3,StatPanel.YELLOW_TEXT,3,42,24);
               _loc7_.hint = Lang.getString("war_points");
               _loc8_.add(_loc7_);
            }
            if(!isNaN(param4))
            {
               _loc7_ = new StatPanel(SkinManager.getPack("Adventure","Ticket" + param4),1,StatPanel.YELLOW_TEXT,3,42,24);
               _loc7_.hint = Lang.getString("ticket" + param4);
               _loc8_.add(_loc7_);
            }
            this.addToPanel(_loc8_,280);
         }
         else
         {
            this.addToPanel(_loc7_,280);
         }
      }
      
      public function startAdvertising() : void
      {
         var _loc1_:VBox = new VBox(null,5,VBox.VERTICAL);
         var _loc2_:VText = new VText(Lang.getString("up_prize"),VText.CENTER);
         if(Lang.locale == Lang.DE)
         {
            Style.applyGlowFormat(_loc2_,18,Style.lightGreenRGB,Style.brownGlowRGB);
            _loc1_.add(_loc2_,{"maxW":100});
         }
         else
         {
            Style.applyGlowFormat(_loc2_,20,Style.lightGreenRGB,Style.brownGlowRGB);
            _loc1_.add(_loc2_,{"maxW":90});
         }
         _loc1_.add(SkinManager.getPack("ScoutingBg","Premium4"),{"w":80});
         if(this.fightType == PFightType.SINGLE)
         {
            _loc1_.add(SkinManager.getPack("ScoutingBg","Premium1"),{"w":80});
         }
         var _loc3_:VButton = new VButton();
         _loc3_.setSkin(_loc1_);
         var _loc4_:VFill = new VFill(16777215);
         _loc3_.setIcon(_loc4_,{
            "w":-100,
            "h":-100
         });
         this.panel.addChild(_loc3_);
         _loc3_.geometryPhase();
         _loc3_.x = 700;
         _loc3_.y = 157;
         _loc3_.addListener(MouseEvent.MOUSE_OVER,this.setAdditionalMode);
         _loc3_.addListener(MouseEvent.MOUSE_OUT,this.setAdditionalMode);
         _loc3_.addListener(MouseEvent.CLICK,this.onAdvClick);
         var _loc5_:Tween = new Tween(_loc3_);
         _loc5_.play(["x",_loc3_.x,_loc3_.x - 150],0.3);
         _loc5_ = new Tween(_loc4_);
         _loc5_.play(["alpha",1,0],0.3);
      }
      
      private function onAdvClick(param1:MouseEvent) : void
      {
         close();
         Facade.setMapCallback(Facade.myMediator.toRadar);
      }
      
      public function initRaid(param1:Array, param2:Array, param3:Array, param4:uint, param5:Array, param6:Boolean = false) : void
      {
         var _loc8_:VGrid = null;
         var _loc9_:RaidResultRenderer = null;
         var _loc10_:VText = null;
         this.prizeList = param1;
         this.damage = param4;
         if(param3)
         {
            _loc8_ = new VGrid(1,4,RaidResultRenderer,param3,0,6,VGrid.H_STRETCH | VGrid.USE_VISIBLE_CALC_LAYOUT);
            this.raidRenderList = _loc8_.renderList;
            this.panel.add(_loc8_,{
               "w":400,
               "vCenter":-10,
               "h":210
            });
            UIFactory.useGridControlNav(_loc8_,UIFactory.addNavBt18);
            if(param3.length > 1)
            {
               this.panel.layoutH += 33 * (param3.length - 1);
            }
            if(param6)
            {
               for each(_loc9_ in this.raidRenderList)
               {
                  _loc9_.removeCapacityStat();
               }
            }
         }
         else
         {
            _loc10_ = UIFactory.createYellowText(Lang.getString("surrender_info"),0,22);
            _loc10_.maxW = 320;
            this.panel.add(new VBox(new <VComponent>[SkinManager.getEmbed("SurrenderIcon"),_loc10_]),{"vCenter":-30});
         }
         var _loc7_:VComponent = new VComponent();
         _loc8_ = new VGrid(6,1,WinTargetRenderer,param5,0,4,VGrid.USE_VISIBLE_CALC_LAYOUT);
         _loc7_.add(_loc8_);
         this.addToPanel(_loc7_,90);
         this.addSoldierPanel(param2,70);
         this.applyHCenter();
         if(this.isWin && !Facade.userProxy.radarEnabled && Facade.checkUserStage("home4_hero_click"))
         {
            Signal.delayCall(1.7,this.startAdvertising);
         }
      }
      
      private function onShare(param1:MouseEvent) : void
      {
         var _loc2_:PSign = (param1.currentTarget as RectButton).data as PSign;
         if(this.isWin)
         {
            if(this.fightType == PFightType.GROUP)
            {
               Facade.callJS("shareWinRaid",this.targetName,this.damage,CostHelper.getValueFromList(this.prizeList,PCost.H_GLORY),_loc2_.sign_key,_loc2_.sign);
            }
            else if(this.fightType == PFightType.SINGLE)
            {
               Facade.callJS("shareWinPvP",this.targetName,CostHelper.getValueFromList(this.prizeList,PCost.CRYSTAL),CostHelper.getValueFromList(this.prizeList,PCost.OIL),_loc2_.sign_key,_loc2_.sign);
            }
            else
            {
               Facade.callJS("shareWinMission",CostHelper.getValueFromList(this.prizeList,PCost.CRYSTAL),CostHelper.getValueFromList(this.prizeList,PCost.OIL),_loc2_.sign_key,_loc2_.sign);
            }
         }
         else if(this.fightType == PFightType.GROUP)
         {
            Facade.callJS("shareLoseRaid",this.targetName,CostHelper.getValueFromList(this.prizeList,PCost.CRYSTAL),CostHelper.getValueFromList(this.prizeList,PCost.OIL),_loc2_.sign_key,_loc2_.sign);
         }
         else
         {
            Facade.callJS("shareLoseBattle",CostHelper.getValueFromList(this.prizeList,PCost.CRYSTAL),CostHelper.getValueFromList(this.prizeList,PCost.OIL),_loc2_.sign_key,_loc2_.sign);
         }
         close();
      }
      
      public function initJaina(param1:uint, param2:Array, param3:Array, param4:PShopBuilding = null) : void
      {
         var _loc6_:UnitClipPanel = null;
         var _loc7_:VComponent = null;
         this.damage = param1;
         this.addToPanel(SkinManager.getPack(this.packName,"DSeparator"),190);
         this.addToPanel(SkinManager.getPack(this.packName,"DSeparator"),290);
         this.panel.add(new VText(Lang.getString("battle_result"),VText.CENTER,Style.metalRGB,22),{
            "left":110,
            "right":110,
            "top":85
         });
         var _loc5_:StatPanel = new StatPanel(SkinManager.getEmbed("DamageIcon"),param1 + "%",StatPanel.YELLOW_TEXT,3,42,24);
         _loc5_.hint = Lang.getString("damage_count");
         this.addToPanel(_loc5_,122);
         if(param4)
         {
            _loc6_ = new UnitClipPanel();
            _loc6_.show(param4.sb_kind,1);
            _loc6_.hint = Lang.getString(param4.sb_kind);
            _loc7_ = new VComponent();
            _loc7_.addStretch(_loc6_);
            _loc7_.add(new ShopNewIcon(0).launch(),{
               "bottom":0,
               "left":60
            });
            _loc7_.setSize(78,76);
            this.addToPanel(new VBox(new <VComponent>[this.getPrizeList(param2),_loc7_],18),204);
         }
         else
         {
            this.addToPanel(this.getPrizeList(param2),219);
         }
         this.addSoldierPanel(param3);
         this.applyHCenter();
      }
   }
}

