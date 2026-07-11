package game.clan.center
{
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.SkinManager;
   import ui.vbase.VScrollBar;
   import ui.vbase.VScrollLabel;
   import ui.vbase.VSkin;
   
   public class TextInfoDialog extends BaseDialog
   {
      
      public function TextInfoDialog(param1:String, param2:String)
      {
         super();
         useDefaultBg(200,Lang.getString(param1));
         setSize(700,500);
         add(SkinManager.getEmbed("WhBlockBg",VSkin.STRETCH),{
            "left":30,
            "right":30,
            "bottom":30,
            "top":80
         });
         var _loc3_:VScrollBar = UIFactory.createScrollBar();
         add(new VScrollLabel(_loc3_,"<div fontSize=\"18\" " + Style.darkKhakiColor + " >" + Lang.getString(param2) + "</div>",VScrollLabel.SELECTION_MODE),{
            "left":15,
            "top":95,
            "right":80,
            "bottom":50
         });
         add(_loc3_,{
            "top":96,
            "right":50,
            "bottom":50
         });
         _loc3_.changeButtonSize(18);
      }
   }
}

