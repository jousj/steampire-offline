package ui.vbase
{
   import flash.events.MouseEvent;
   
   public class VCheckbox extends VComponent
   {
      
      public var data:*;
      
      private var label:VComponent;
      
      private var checkSkin:VComponent;
      
      protected var isCheck:Boolean;
      
      public function VCheckbox(param1:VComponent, param2:VComponent, param3:VComponent, param4:Boolean = false)
      {
         super();
         mouseChildren = false;
         buttonMode = true;
         addChild(param1);
         this.checkSkin = param2;
         this.checked = param4;
         if(param3)
         {
            this.label = param3;
            addChild(param3);
         }
         addListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function set text(param1:String) : void
      {
         if(this.label is VText)
         {
            (this.label as VText).value = param1;
         }
         else if(this.label is VLabel)
         {
            (this.label as VLabel).text = param1;
         }
      }
      
      public function set checked(param1:Boolean) : void
      {
         if(this.isCheck != param1)
         {
            this.isCheck = param1;
            if(param1)
            {
               addChild(this.checkSkin);
               this.checkSkin.geometryPhase();
            }
            else
            {
               removeChild(this.checkSkin);
            }
         }
      }
      
      public function get checked() : Boolean
      {
         return this.isCheck;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:Boolean = this.isCheck;
         this.checked = !this.isCheck;
         if(_loc2_ != this.isCheck)
         {
            dispatcher.dispatchEvent(new VEvent(VEvent.CHANGE,this.isCheck));
         }
      }
   }
}

