package game.battle.drop
{
   import proto.model.PShopPowerPoint;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VFill;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class PowerBuyRenderer extends VRenderer
   {
      
      public const bt:RectButton = new RectButton(new PricePanel(28,20,PricePanel.GLOW_FILTER),RectButton.h56);
      
      private const text:VText = UIFactory.createYellowText(null,VText.CONTAIN_CENTER,30,true);
      
      private const powerSkin:VSkin = SkinManager.getEmbed("Power");
      
      public function PowerBuyRenderer()
      {
         super();
         setSize(210,235);
         var _loc1_:VFill = new VFill(16777215,0.15,8);
         _loc1_.setLine(1,0,0.25);
         addStretch(_loc1_);
         add(SkinManager.getEmbed("GoldDropBg"),{
            "w":130,
            "h":130,
            "top":22,
            "hCenter":0
         });
         add(this.powerSkin,{
            "hCenter":0,
            "vCenter":-32,
            "maxW":80
         });
         add(this.text,{
            "left":30,
            "right":32,
            "top":114
         });
         add(this.bt,{
            "w":170,
            "bottom":10,
            "hCenter":0
         });
         this.bt.addVarianceListener(this,0);
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PShopPowerPoint = param1 as PShopPowerPoint;
         this.bt.data = _loc2_;
         (this.bt.icon as PricePanel).assignCost(_loc2_.power_price);
         this.text.value = "+" + _loc2_.power_count;
         this.powerSkin.layoutH = dataIndex == 0 ? 54 : 80;
         this.powerSkin.syncLayout();
      }
   }
}

