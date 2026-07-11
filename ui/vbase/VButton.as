package ui.vbase
{
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class VButton extends VComponent
   {
      
      public static const UP:uint = 0;
      
      public static const OVER:uint = 1;
      
      public static const DOWN:uint = 2;
      
      public static const DISABLED:uint = 3;
      
      private static const downTransform:ColorTransform = new ColorTransform(0.9,0.9,0.9);
      
      private static const upTransform:ColorTransform = new ColorTransform();
      
      private var downFlag:Boolean;
      
      private var state:uint = 0;
      
      public var skin:VComponent;
      
      public var icon:VComponent;
      
      public var changeStateFunc:Function = defaultButtonChangeState;
      
      public var variance:uint;
      
      public var data:Object;
      
      public function VButton()
      {
         super();
         mouseChildren = false;
         buttonMode = true;
         addListener(MouseEvent.ROLL_OVER,this.onMouse);
         addListener(MouseEvent.ROLL_OUT,this.onMouse);
         addListener(MouseEvent.MOUSE_DOWN,this.onMouse);
         addListener(MouseEvent.MOUSE_UP,this.onMouse);
      }
      
      public static function defaultButtonChangeState(param1:VButton, param2:uint) : void
      {
         if(param2 == VButton.DISABLED)
         {
            param1.filters = VSkin.GREY_FILTER;
         }
         else
         {
            param1.filters = null;
            if(param2 == VButton.DOWN)
            {
               param1.transform.colorTransform = downTransform;
            }
            else
            {
               param1.transform.colorTransform = upTransform;
               if(param2 == VButton.OVER)
               {
                  param1.filters = VSkin.CONTRAST_FILTER;
               }
            }
         }
      }
      
      public static function create(param1:VComponent, param2:Object = null, param3:VComponent = null, param4:Object = null, param5:Function = null) : VButton
      {
         var _loc6_:VButton = new VButton();
         if(param1)
         {
            _loc6_.setSkin(param1,param2);
         }
         if(param3)
         {
            _loc6_.setIcon(param3,param4);
         }
         if(param5 != null)
         {
            _loc6_.changeStateFunc = param5;
         }
         return _loc6_;
      }
      
      public static function createEmbed(param1:String, param2:uint = 0, param3:VComponent = null, param4:Object = null, param5:Function = null) : VButton
      {
         var _loc6_:VSkin = SkinManager.getEmbed(param1,param2);
         var _loc7_:VButton = new VButton();
         _loc7_.setSize(_loc6_.measuredWidth,_loc6_.measuredHeight);
         _loc7_.setSkin(_loc6_);
         _loc6_.stretch();
         if(param3)
         {
            _loc7_.setIcon(param3,param4);
         }
         if(param5 != null)
         {
            _loc7_.changeStateFunc = param5;
         }
         return _loc7_;
      }
      
      public function setSkin(param1:VComponent, param2:Object = null) : void
      {
         if(this.skin)
         {
            remove(this.skin);
         }
         this.skin = param1;
         if(param1)
         {
            add(param1,param2,0);
         }
      }
      
      public function setIcon(param1:VComponent, param2:Object = null) : void
      {
         if(this.icon)
         {
            remove(this.icon);
         }
         this.icon = param1;
         if(param1)
         {
            add(param1,param2);
         }
      }
      
      public function set disabled(param1:Boolean) : void
      {
         if(this.state == DISABLED != param1)
         {
            this.changeState(param1 ? DISABLED : UP);
            this.mouseEnabled = !param1;
         }
      }
      
      public function get disabled() : Boolean
      {
         return this.state == DISABLED;
      }
      
      private function onMouse(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         if(this.state == DISABLED)
         {
            return;
         }
         switch(param1.type)
         {
            case MouseEvent.ROLL_OVER:
               if(this.downFlag && !param1.buttonDown)
               {
                  this.downFlag = false;
               }
               _loc2_ = this.downFlag ? DOWN : OVER;
               break;
            case MouseEvent.MOUSE_DOWN:
               this.downFlag = true;
               _loc2_ = DOWN;
               break;
            case MouseEvent.MOUSE_UP:
               _loc2_ = OVER;
               break;
            default:
               _loc2_ = UP;
         }
         this.changeState(_loc2_);
      }
      
      private function changeState(param1:uint) : void
      {
         if(param1 != this.state)
         {
            if(this.changeStateFunc != null)
            {
               this.changeStateFunc(this,param1);
            }
            this.state = param1;
         }
      }
      
      override protected function calcContentSize() : void
      {
         if(this.skin)
         {
            contentW = this.skin.measuredWidth;
            contentH = this.skin.measuredHeight;
         }
         else
         {
            super.calcContentSize();
         }
      }
      
      override public function dispose() : void
      {
         this.changeStateFunc = null;
         super.dispose();
      }
      
      public function addClickListener(param1:Function, param2:Object = null) : void
      {
         if(param2 != null)
         {
            this.data = param2;
         }
         addListener(MouseEvent.CLICK,param1);
      }
      
      public function click() : void
      {
         dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      public function addVarianceListener(param1:EventDispatcher, param2:uint, param3:Object = null) : void
      {
         this.dispatcher = param1;
         this.variance = param2;
         if(param3 != null)
         {
            this.data = param3;
         }
         addListener(MouseEvent.CLICK,this.onVariance);
      }
      
      protected function onVariance(param1:MouseEvent = null) : void
      {
         var _loc2_:VEvent = new VEvent(VEvent.VARIANCE,this.data);
         _loc2_.variance = this.variance;
         dispatcher.dispatchEvent(_loc2_);
      }
      
      override public function set mouseEnabled(param1:Boolean) : void
      {
         if(!param1)
         {
            if(this.state != UP && this.state != DISABLED)
            {
               this.changeState(UP);
            }
         }
         super.mouseEnabled = param1;
      }
   }
}

