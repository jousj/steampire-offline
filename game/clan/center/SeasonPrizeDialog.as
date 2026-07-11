package game.clan.center
{
   import proto.model.PClanCompPrize;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class SeasonPrizeDialog extends BaseDialog
   {
      
      public const panel:VComponent = new VComponent();
      
      private const centerOffset:uint = Facade.fakeResize ? 60 : 80;
      
      private const packName:String = "BattleResultDialog";
      
      private var prize:PClanCompPrize;
      
      private var pricePanel:PriceListPanel;
      
      public function SeasonPrizeDialog(param1:PClanCompPrize)
      {
         super();
         stretch();
         this.prize = param1;
         this.panel.setSize(600,515);
         this.panel.useCenter(this.centerOffset);
         addChild(this.panel);
         this.panel.add(SkinManager.getEmbed("PaperDialogBg",VSkin.STRETCH),{
            "wP":100,
            "hP":100,
            "hCenter":-5
         });
         this.panel.add(SkinManager.getExternal("jaina",SkinManager.PNG),{"left":-230});
         this.panel.add(UIFactory.createDecorText(Lang.getReplaceString("finish_season_prize",{"__NUM__":(TopClansMediator.getCurSeason() - 1).toString()}),true,30),{
            "top":40,
            "hCenter":0
         });
         closeBt = new RectButton(Lang.getString("bt_good"),RectButton.h56);
         closeBt.addClickListener(close);
         this.panel.add(closeBt,{
            "bottom":40,
            "hCenter":0
         });
         this.panel.cacheAsBitmap = true;
         this.addHeaderClan();
         this.panel.add(SkinManager.getPack(this.packName,"DSeparator"),{
            "hCenter":0,
            "top":205
         });
         this.panel.add(new VText(Lang.getString("clan_prize") + ":",VText.CONTAIN,Style.redRGB,18),{
            "hCenter":0,
            "top":220
         });
         this.panel.add(new ClanChestReward(param1.clan_place),{
            "hCenter":0,
            "top":242,
            "h":58
         });
         this.panel.add(SkinManager.getPack(this.packName,"DSeparator"),{
            "hCenter":0,
            "top":308
         });
         this.panel.add(new VText(Lang.getString("clan_prize_part") + ":",VText.CONTAIN,Style.metalRGB,18),{
            "hCenter":0,
            "top":323
         });
         this.panel.add(this.getPrizeList(param1.prize),{
            "hCenter":0,
            "top":352
         });
      }
      
      private function addHeaderClan() : void
      {
         var _loc1_:VComponent = new VComponent();
         this.panel.add(_loc1_,{
            "hCenter":0,
            "top":100,
            "w":410
         });
         _loc1_.add(SkinManager.getEmbed("RSeparator",VSkin.STRETCH),{
            "w":360,
            "left":50
         });
         _loc1_.add(UIFactory.createDecorText(Facade.userProxy.clan ? Facade.userProxy.clan.uc_name : "",true,20,270),{
            "left":110,
            "vCenter":-25
         });
         var _loc2_:VComponent = new VComponent();
         _loc1_.add(_loc2_,{"top":-9});
         _loc2_.add(SkinManager.getEmbed("TrainCircleBg"),{
            "hCenter":0,
            "w":100,
            "h":100
         });
         _loc2_.add(SkinManager.getPack(UIFactory.EMBLEM_PACK,Facade.userProxy.clan ? Facade.userProxy.clan.uc_icon : "",0,SkinManager.LOAD_CLIP),{
            "vCenter":0,
            "hCenter":0,
            "w":84,
            "h":84
         });
         var _loc3_:StatPanel = new StatPanel(SkinManager.getEmbed("CupIcon"),null,StatPanel.YELLOW_TEXT,3,25,16);
         var _loc4_:StatPanel = new StatPanel(SkinManager.getEmbed("ClanEmblemIcon"),null,StatPanel.YELLOW_TEXT,3,35,16);
         _loc1_.add(_loc3_,{
            "top":58,
            "left":240
         });
         _loc1_.add(_loc4_,{
            "top":53,
            "left":110
         });
         _loc3_.value = this.prize.clan_place;
         _loc4_.value = this.prize.clan_points;
      }
      
      private function getPrizeList(param1:Array) : PriceListPanel
      {
         this.pricePanel = new PriceListPanel(25,VSkin.BOTTOM);
         this.pricePanel.priceMode |= PricePanel.TWEEN;
         this.pricePanel.useVertical(34);
         this.pricePanel.setStyle(40,18);
         this.pricePanel.assignList(param1);
         this.pricePanel.maxW = 430;
         return this.pricePanel;
      }
   }
}

