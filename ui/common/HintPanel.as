package ui.common
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import ui.vbase.VSkin;
   
   public class HintPanel extends Sprite
   {
      
      public var target:Object;
      
      private const bg:VSkin = SkinManager.getEmbed("HintBg",VSkin.STRETCH);
      
      private const label:VLabel = new VLabel(null,VLabel.LEADING_BOX);
      
      private const lastPos:Point = new Point();
      
      private var isListener:Boolean;
      
      private var customContent:DisplayObject;
      
      private var w:uint;
      
      private var h:uint;
      
      private var topMode:Boolean;
      
      public function HintPanel()
      {
         super();
         visible = false;
         this.label.assignLayout({
            "left":12,
            "top":9,
            "maxW":320
         });
         mouseChildren = mouseEnabled = false;
      }
      
      private function set listener(param1:Boolean) : void
      {
         if(param1)
         {
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
         }
         else
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveHandler);
         }
         this.isListener = param1;
         visible = param1;
      }
      
      public function applyContent(param1:Object, param2:Object = null, param3:Boolean = true) : void
      {
         if(param1 is String && (param1 as String).length == 0)
         {
            param1 = null;
         }
         if(this.customContent)
         {
            removeChild(this.customContent);
            if(this.customContent is VComponent)
            {
               (this.customContent as VComponent).dispose();
            }
            this.customContent = null;
         }
         if(!param1)
         {
            if(this.isListener)
            {
               this.listener = false;
               this.label.text = null;
            }
            this.target = null;
            return;
         }
         this.target = param2;
         if(param1 is DisplayObject)
         {
            if(this.bg.parent)
            {
               removeChild(this.bg);
               removeChild(this.label);
            }
            this.customContent = param1 as DisplayObject;
            addChild(this.customContent);
         }
         else
         {
            if(!this.bg.parent)
            {
               addChild(this.bg);
               addChild(this.label);
            }
            this.label.isGeometryPhase = false;
            this.label.text = "<div" + Style.hint + ">" + param1 + "</div>";
            this.label.geometryPhase();
            this.w = this.label.w + 24;
            this.h = this.label.h + 18;
            this.bg.setGeometrySize(this.w,this.h,true);
         }
         this.topMode = param3;
         if(!this.isListener)
         {
            this.listener = true;
         }
         if(this.customContent)
         {
            this.customContentUpdate();
         }
         else
         {
            this.move(stage.mouseX,stage.mouseY);
         }
      }
      
      public function customContentUpdate() : void
      {
         var _loc1_:VComponent = null;
         if(this.customContent)
         {
            if(this.customContent is VComponent)
            {
               _loc1_ = this.customContent as VComponent;
               _loc1_.geometryPhase();
               this.w = _loc1_.w;
               this.h = _loc1_.h;
            }
            else
            {
               this.w = Math.ceil(this.customContent.width);
               this.h = Math.ceil(this.customContent.height);
            }
            this.move(stage.mouseX,stage.mouseY);
         }
      }
      
      private function move(param1:Number, param2:Number) : void
      {
         this.lastPos.x = param1;
         this.lastPos.y = param2;
         x = param1 + this.w + 20 <= stage.stageWidth ? param1 + 16 : param1 - this.w - 5;
         if(this.topMode)
         {
            if(param2 > this.h + 4)
            {
               y = param2 - this.h + 8;
            }
            else
            {
               y = param2 + this.h + 6 > stage.stageHeight ? stage.stageHeight - this.h - 6 : param2 + 8;
            }
         }
         else if(param2 + this.h + 12 < stage.stageHeight - 6)
         {
            y = param2 + 12;
         }
         else
         {
            y = stage.stageHeight - this.h - 6;
         }
      }
      
      private function onMouseMoveHandler(param1:MouseEvent) : void
      {
         if(this.lastPos.x != param1.stageX || this.lastPos.y != param1.stageY)
         {
            this.move(param1.stageX,param1.stageY);
         }
      }
   }
}

