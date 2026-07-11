package game.shop
{
   import ui.Style;
   import ui.common.BaseDialog;
   import ui.game.UnitPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class ShopInfoDialog extends BaseDialog
   {
      
      public function ShopInfoDialog(param1:String)
      {
         super();
         layoutW = 600;
         minH = 240;
         add(SkinManager.getEmbed("FeatureGear"),{
            "left":-57,
            "top":158
         });
         add(SkinManager.getEmbed("FeatureSectionBg",VSkin.STRETCH_BG),{
            "wP":100,
            "top":50,
            "bottom":0
         });
         var _loc2_:VText = new VText(Lang.getString(param1 + "_about"),VText.CENTER | VText.MIDDLE,Style.darkKhakiRGB);
         add(_loc2_,{
            "right":30,
            "top":72,
            "bottom":18,
            "w":470
         });
         addHeader();
         addUnitDialogTitle(param1,1);
         var _loc3_:UnitPanel = new UnitPanel(UnitPanel.FEATURE_MODE);
         UnitPanel.feature(_loc3_,param1);
         add(_loc3_,{
            "left":-72,
            "top":50
         });
         _loc3_.show(param1,1);
      }
   }
}

