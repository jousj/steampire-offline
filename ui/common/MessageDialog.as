package ui.common
{
   import flash.events.MouseEvent;
   import model.ui.VOCallback;
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   
   public class MessageDialog extends BaseDialog
   {
      
      public static const ADD_OK_BUTTON:uint = 1;
      
      public static const HIDE_CLOSE_BUTTON:uint = 4;
      
      public static const UNIT_ICON:uint = 8;
      
      public const box:VBox;
      
      public var data:Object;
      
      private var btBox:VBox;
      
      public function MessageDialog(param1:String, param2:String = null, param3:VComponent = null, param4:uint = 0, param5:String = null)
      {
         var _loc7_:RectButton = null;
         this.box = new VBox(null,10,VBox.VERTICAL);
         super();
         useWhiteBg(535,0,param2 ? param2 : Lang.getString("message"),(param4 & HIDE_CLOSE_BUTTON) == 0);
         var _loc6_:Boolean = param3 != null;
         this.box.add(new VLabel("<div" + Style.metalColor + ">" + param1 + "</div>",VLabel.CENTER | VLabel.MIDDLE | VLabel.LEADING_BOX),{
            "w":(_loc6_ ? 395 : 440),
            "hP":100
         });
         add(this.box,{
            "left":(_loc6_ ? 88 : 20),
            "right":20,
            "top":77,
            "minH":170,
            "bottom":20
         });
         if(_loc6_)
         {
            add(SkinManager.getEmbed("FeatureGear"),{
               "left":-60,
               "top":184
            },0);
            if((param4 & UNIT_ICON) == 0)
            {
               add(SkinManager.getEmbed("TrainCircleBg"),{
                  "left":-72,
                  "top":76,
                  "w":160,
                  "h":160
               });
               add(param3,{
                  "left":-62,
                  "top":85,
                  "w":140,
                  "h":140
               });
            }
            else
            {
               add(param3,{
                  "top":76,
                  "left":-72
               });
            }
         }
         if((param4 & ADD_OK_BUTTON) != 0)
         {
            _loc7_ = new RectButton(param5 ? param5 : Lang.getString("bt_good"),RectButton.h56);
            this.box.add(_loc7_);
            _loc7_.addClickListener(close);
         }
      }
      
      override protected function calcContentSize() : void
      {
         contentH = this.box.measuredHeight + this.box.vPadding;
      }
      
      public function addYesNoButton(param1:Function, param2:Array = null, param3:Function = null) : void
      {
         var _loc4_:RectButton = new RectButton(Lang.getString("yesBt"),RectButton.h56);
         _loc4_.data = new VOCallback(param1,param2);
         _loc4_.addClickListener(this.delegateHandler);
         var _loc5_:RectButton = new RectButton(Lang.getString("noBt"),RectButton.h56,RectButton.ORANGE);
         if(param3 != null)
         {
            _loc5_.data = new VOCallback(param3,param2);
            _loc5_.addClickListener(this.delegateHandler);
         }
         else
         {
            _loc5_.addClickListener(close);
         }
         this.addButton(_loc5_);
         this.addButton(_loc4_);
      }
      
      public function addButton(param1:VButton) : void
      {
         if(!this.btBox)
         {
            this.btBox = new VBox(null,10);
            this.box.add(this.btBox);
         }
         this.btBox.add(param1);
      }
      
      public function addDelegateButton(param1:VButton, param2:Function = null, param3:Array = null) : MessageDialog
      {
         if(param2 != null)
         {
            param1.data = VOCallback.create(param2,param3);
         }
         param1.addClickListener(this.delegateHandler);
         this.addButton(param1);
         return this;
      }
      
      public function addDelegateRectButton(param1:Object, param2:Function = null, param3:Array = null, param4:String = null) : MessageDialog
      {
         this.addDelegateButton(new RectButton(param1,RectButton.h56,param4 ? param4 : RectButton.GREEN),param2,param3);
         return this;
      }
      
      private function delegateHandler(param1:MouseEvent) : void
      {
         close();
         var _loc2_:VOCallback = (param1.currentTarget as VButton).data as VOCallback;
         if(_loc2_)
         {
            _loc2_.apply();
         }
      }
   }
}

