package game.clan.donate
{
   import model.CommonEvent;
   import proto.model.PCost;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.game.ResourcePanel;
   import ui.game.UnitClipPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class CapitalBuyPanel extends VComponent
   {
      
      private const goldBar:ResourcePanel = new ResourcePanel(PCost.GOLD,ResourcePanel.BG | ResourcePanel.PROGRESS | ResourcePanel.COMPARE | ResourcePanel.CLAN,UIFactory.INDICATOR_YELLOW,36,32,15);
      
      public var bt:RectButton;
      
      public function CapitalBuyPanel(param1:uint, param2:Boolean)
      {
         super();
         setSize(270,80);
         add(new VFill(0,0.2),{
            "w":80,
            "h":78,
            "left":2,
            "top":2
         });
         add(SkinManager.getEmbed("DarkBorder",VSkin.STRETCH),{
            "w":82,
            "h":80
         });
         var _loc3_:UnitClipPanel = new UnitClipPanel();
         _loc3_.show("bl_town_hall",4);
         add(_loc3_,{
            "left":2,
            "top":1,
            "w":78,
            "h":76
         });
         this.goldBar.setDataEx(param1,Facade.references.create_capital_price.value);
         add(this.goldBar,{
            "w":178,
            "right":0,
            "h":33,
            "top":(param2 ? 0 : 36)
         });
         Facade.addListenerForComponent(CommonEvent.CLAN_RESOURCE,this.goldBar.onTrack,this);
         if(param2)
         {
            this.bt = RectButton.createIconAndTitle42(SkinManager.getEmbed("DonateIcon"),Lang.getString("donateBt"),150);
            add(this.bt,{
               "bottom":0,
               "hCenter":46,
               "minW":150
            });
         }
         else
         {
            add(UIFactory.createYellowText(Lang.getString("capital_buy"),VText.CONTAIN_CENTER),{
               "right":0,
               "top":10,
               "w":178
            });
         }
      }
   }
}

