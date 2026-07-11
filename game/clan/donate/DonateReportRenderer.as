package game.clan.donate
{
   import model.ui.VODonateItem;
   import proto.model.PUserBase;
   import proto.model.clan.PMember;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.game.PricePanel;
   import ui.vbase.VButton;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class DonateReportRenderer extends VRenderer
   {
      
      public const menuBt:VButton = VButton.createEmbed("MenuIcon",VSkin.DRAW_FILL);
      
      public var member:PMember;
      
      private const levelPanel:LevelPanel = new LevelPanel(LevelPanel.size28);
      
      private const nameText:VText = UIFactory.createYellowText(null,VText.CONTAIN);
      
      private const statusText:VText = new VText(null,VText.CONTAIN,Style.metalRGB,14);
      
      private const allPricePanel:PricePanel = new PricePanel(20,18,PricePanel.GLOW_FILTER | PricePanel.SHORT);
      
      private const sumPricePanel:PricePanel = new PricePanel(20,18,PricePanel.GLOW_FILTER | PricePanel.SHORT);
      
      private const d1PricePanel:PricePanel = new PricePanel(20,16,PricePanel.GLOW_FILTER | PricePanel.SHORT);
      
      private const d2PricePanel:PricePanel = new PricePanel(20,16,PricePanel.GLOW_FILTER | PricePanel.SHORT);
      
      private const d3PricePanel:PricePanel = new PricePanel(20,16,PricePanel.GLOW_FILTER | PricePanel.SHORT);
      
      public function DonateReportRenderer()
      {
         super();
         layoutH = 46;
         add(this.levelPanel,{
            "vCenter":0,
            "left":5
         });
         add(this.nameText,{
            "left":42,
            "w":200,
            "top":7
         });
         add(this.statusText,{
            "left":42,
            "w":200,
            "bottom":4
         });
         this.menuBt.addVarianceListener(this,1,this);
         add(this.menuBt,{
            "left":246,
            "vCenter":0
         });
         add(this.allPricePanel,{
            "left":276,
            "w":112,
            "vCenter":0
         });
         add(this.sumPricePanel,{
            "left":394,
            "w":98,
            "vCenter":0
         });
         add(this.d1PricePanel,{
            "left":497,
            "w":84,
            "vCenter":0
         });
         add(this.d2PricePanel,{
            "left":585,
            "w":82,
            "vCenter":0
         });
         add(this.d3PricePanel,{
            "right":1,
            "w":84,
            "vCenter":0
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:VODonateItem = param1 as VODonateItem;
         this.member = _loc2_.member;
         var _loc3_:PUserBase = this.member.user_base;
         this.levelPanel.changeSNetwork(_loc3_.snetwork);
         this.levelPanel.value = _loc3_.level;
         this.nameText.value = _loc3_.name;
         this.statusText.value = Lang.getString("clan_role" + this.member.role.variance);
         this.allPricePanel.assign(_loc2_.variance,_loc2_.all);
         this.sumPricePanel.assign(_loc2_.variance,_loc2_.week);
         this.d1PricePanel.assign(_loc2_.variance,_loc2_.day1);
         this.d2PricePanel.assign(_loc2_.variance,_loc2_.day2);
         this.d3PricePanel.assign(_loc2_.variance,_loc2_.day3);
         this.menuBt.visible = _loc3_.user_id != Preloader.uid;
      }
   }
}

