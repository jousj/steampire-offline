package game.shop
{
   import flash.events.MouseEvent;
   import proto.model.PSign;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class ShareDialog extends BaseDialog
   {
      
      public function ShareDialog(param1:String, param2:String, param3:String, param4:PSign = null, param5:String = null, param6:Boolean = true)
      {
         var _loc9_:RectButton = null;
         var _loc10_:Array = null;
         super();
         setSize(567,473);
         addStretch(UIFactory.createPaperSkin());
         add(UIFactory.createDecorText(Lang.getString("congratulations"),true,42),{
            "hCenter":10,
            "top":-15
         });
         add(new VText(Lang.getString(param6 ? "share_buy_count" : "share_apply_count"),VText.CONTAIN_CENTER,Style.metalRGB,22),{
            "left":80,
            "right":70,
            "top":40
         });
         var _loc7_:VSkin = SkinManager.getEmbed(param1);
         _loc7_.setSize(26,28);
         add(new VBox(new <VComponent>[_loc7_,new VText(param2,0,Style.metalRGB,22)],3),{
            "hCenter":10,
            "top":66
         });
         add(SkinManager.getExternal(param3,SkinManager.JPG | SkinManager.LOAD_CLIP),{
            "hCenter":10,
            "top":100
         });
         var _loc8_:RectButton = new RectButton(Lang.getString("bt_ok"),RectButton.h56,param4 ? RectButton.ORANGE : RectButton.GREEN);
         _loc8_.addClickListener(close);
         if(param4)
         {
            _loc9_ = new RectButton(Lang.getString("share"),RectButton.h56);
            _loc10_ = [param5];
            if(param6)
            {
               _loc10_.push(param2);
            }
            _loc10_.push(param4.sign_key,param4.sign);
            _loc9_.addClickListener(this.onShare,_loc10_);
            add(new VBox(new <VComponent>[_loc8_,_loc9_],10),{
               "hCenter":10,
               "bottom":0
            });
         }
         else
         {
            add(_loc8_,{
               "hCenter":10,
               "bottom":0
            });
         }
      }
      
      private function onShare(param1:MouseEvent) : void
      {
         Facade.callJS.apply(null,(param1.currentTarget as RectButton).data as Array);
         close();
      }
   }
}

