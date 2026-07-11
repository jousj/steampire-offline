package game.my
{
   import ui.Style;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class SleepDialog extends BaseDialog
   {
      
      public function SleepDialog()
      {
         super();
         stretch();
         add(SkinManager.getEmbed("DialogBg",VSkin.STRETCH),{
            "left":-20,
            "right":-20,
            "top":-5,
            "bottom":-18
         });
         add(SkinManager.getExternal("SleepDialogBg",SkinManager.PNG),{
            "hCenter":0,
            "vCenter":0
         });
         var _loc1_:VText = new VText(Lang.getString("sleep_msg"),VText.CENTER | VText.MIDDLE,Style.redRGB);
         _loc1_.format.lineHeight = "140%";
         add(_loc1_,{
            "hCenter":-133,
            "vCenter":0,
            "w":376,
            "h":200
         });
         var _loc2_:RectButton = new RectButton(Lang.getString("gameBt"),RectButton.h56);
         _loc2_.addClickListener(onBtClose);
         add(_loc2_,{
            "hCenter":0,
            "vCenter":136
         });
      }
   }
}

