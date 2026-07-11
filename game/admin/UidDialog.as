package game.admin
{
   import flash.events.MouseEvent;
   import flash.system.Capabilities;
   import flash.system.System;
   import model.ProtoProxy;
   import ui.Style;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.vbase.VText;
   
   public class UidDialog extends BaseDialog
   {
      
      public function UidDialog()
      {
         super();
         useWhiteBg(460,0,"user id");
         var _loc1_:String = Preloader.uid + "\nv=" + ProtoProxy.PROTOCOL_VERSION + "/" + ProtoProxy.CLIENT_VERSION + " (" + Capabilities.version + ")";
         add(new VText(_loc1_,VText.CENTER,Style.metalRGB),{
            "left":15,
            "right":15,
            "top":89,
            "bottom":102
         });
         var _loc2_:RectButton = new RectButton(Lang.getString("text_copy"),RectButton.h56);
         add(_loc2_,{
            "hCenter":0,
            "bottom":30
         });
         _loc2_.addClickListener(this.onCopy,_loc1_);
      }
      
      private function onCopy(param1:MouseEvent) : void
      {
         System.setClipboard(param1.target.data as String);
         close();
      }
   }
}

