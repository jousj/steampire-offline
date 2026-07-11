package game.clan.center
{
   import proto.model.PCost;
   import proto.model.PShopClanIcon;
   import proto.model.clan.PClan;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class EmblemBuyDialog extends BaseDialog
   {
      
      public function EmblemBuyDialog(param1:PShopClanIcon, param2:PClan)
      {
         var _loc6_:ResourcePanel = null;
         super();
         layoutW = 560;
         add(SkinManager.getEmbed("FeatureSectionBg",VSkin.STRETCH_BG),{
            "top":250,
            "bottom":0,
            "wP":100
         });
         add(SkinManager.getEmbed("FeatureDialogBg",VSkin.STRETCH_BG),{
            "top":42,
            "wP":100,
            "h":220
         });
         addHeader();
         addCloseButton();
         var _loc3_:Boolean = Boolean(param2);
         if(_loc3_)
         {
            _loc6_ = new ResourcePanel(PCost.GOLD,ResourcePanel.CLAN | ResourcePanel.BG);
            _loc6_.cur = param2.base.gold;
            add(_loc6_,{
               "right":68,
               "top":13
            });
         }
         addDialogTitle(Lang.getString("confirm"),false,_loc3_ ? 248 : 64);
         add(SkinManager.getEmbed("TrainCircleBg"),{
            "hCenter":0,
            "top":78
         });
         add(SkinManager.getPack(UIFactory.EMBLEM_PACK,param1.sci_kind),{
            "top":88,
            "hCenter":1,
            "h":142
         });
         add(new VText(Lang.getString(_loc3_ ? "buy_emblem_prompt" : "buy_emblem_lock"),VText.CENTER,Style.darkKhakiRGB,16),{
            "top":272,
            "bottom":92,
            "hCenter":0,
            "w":510
         });
         var _loc4_:PriceListPanel = new PriceListPanel();
         _loc4_.priceMode |= PricePanel.CLAN;
         _loc4_.assignList(param1.sci_price);
         var _loc5_:RectButton = new RectButton(_loc4_,RectButton.h56);
         add(_loc5_,{
            "hCenter":0,
            "bottom":24
         });
         if(_loc3_)
         {
            _loc5_.addVarianceListener(this,0,param1);
         }
         else
         {
            _loc5_.disabled = true;
         }
      }
   }
}

