package ui.game
{
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import ui.vbase.VSkin;
   
   public class BubblePanel extends VComponent
   {
      
      public static const TAIL_LEFT:uint = 1;
      
      public static const TAIL_RIGHT:uint = 2;
      
      public static const TAIL_TOP:uint = 3;
      
      public static const TAIL_BOTTOM:uint = 4;
      
      public const label:VLabel = new VLabel(null,VLabel.CENTER | VLabel.MIDDLE);
      
      private const tailSkin:VSkin = SkinManager.getEmbed("StoryMsgTail");
      
      public var fontSize:uint;
      
      private var cacheDirection:uint;
      
      public function BubblePanel(param1:String = null, param2:uint = 1, param3:uint = 20, param4:int = 14)
      {
         super();
         addStretch(SkinManager.getEmbed("StoryMsgBg",VSkin.STRETCH_BG));
         addChild(this.tailSkin);
         this.direction = param2;
         this.fontSize = param3;
         this.label.setPadding(param4);
         addChild(this.label);
         if(param1)
         {
            this.setMessage(param1);
         }
      }
      
      public function set direction(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         if(this.cacheDirection == param1)
         {
            return;
         }
         this.cacheDirection = param1;
         _loc2_ = 4 - this.tailSkin.measuredHeight;
         switch(param1)
         {
            case TAIL_LEFT:
               _loc3_ = VSkin.ROTATE_90;
               _loc4_ = {
                  "left":_loc2_ - 2,
                  "vCenter":0
               };
               break;
            case TAIL_RIGHT:
               _loc3_ = uint(VSkin.ROTATE_270 | VSkin.FLIP_Y);
               _loc4_ = {
                  "right":_loc2_ - 2,
                  "vCenter":0
               };
               break;
            case TAIL_BOTTOM:
               _loc3_ = 0;
               _loc4_ = {
                  "bottom":_loc2_,
                  "hCenter":0
               };
               break;
            case TAIL_TOP:
               _loc3_ = VSkin.ROTATE_180;
               _loc4_ = {
                  "top":_loc2_,
                  "hCenter":0
               };
         }
         this.tailSkin.resetLayout();
         this.tailSkin.assignLayout(_loc4_);
         this.tailSkin.setMode(_loc3_);
      }
      
      public function set wpadding(param1:uint) : void
      {
         this.label.left = this.label.right = param1;
      }
      
      public function setMessage(param1:String) : void
      {
         if(param1.length > 260)
         {
            this.fontSize = 15;
         }
         else if(param1.length > 200)
         {
            this.fontSize = 16;
         }
         else if(param1.length > 160)
         {
            this.fontSize = 18;
         }
         this.label.text = "<div" + Style.metalColor + " fontSize=\"" + this.fontSize + "\">" + param1 + "</div>";
      }
      
      public function changeMessageBottom(param1:int, param2:Boolean) : void
      {
         if(this.label.bottom != param1)
         {
            if(param2)
            {
               this.label.text = null;
            }
            this.label.bottom = param1;
            this.label.syncLayout();
         }
      }
   }
}

