package ui.vbase
{
   import flash.display.Shape;
   
   public class VProgressBar extends VComponent
   {
      
      protected var _value:Number = 0;
      
      protected var indicator:VSkin;
      
      protected var maskShape:Shape;
      
      public var isFlip:Boolean;
      
      public function VProgressBar()
      {
         super();
         mouseChildren = false;
      }
      
      public function init(param1:VSkin, param2:VSkin = null, param3:Boolean = false) : void
      {
         this.indicator = param1;
         if(param2)
         {
            addChild(param2);
         }
         addChild(param1);
         if(param3)
         {
            this.maskShape = new Shape();
            addChild(this.maskShape);
            param1.mask = this.maskShape;
         }
      }
      
      protected function updateIndicator() : void
      {
         var _loc1_:Number = Math.round(this.indicator.w * this._value);
         if(this.maskShape)
         {
            this.maskShape.graphics.clear();
            this.maskShape.graphics.beginFill(0);
            this.maskShape.graphics.drawRect(this.isFlip ? this.w - _loc1_ : 0,0,_loc1_,this.indicator.h);
         }
         else
         {
            this.indicator.width = _loc1_;
            if(this.isFlip)
            {
               this.indicator.x = this.w - _loc1_;
            }
         }
      }
      
      public function getIndicator() : VSkin
      {
         return this.indicator;
      }
      
      public function set value(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > 1)
         {
            param1 = 1;
         }
         this._value = param1;
         if(isGeometryPhase && visible)
         {
            this.updateIndicator();
         }
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      override protected function customUpdate() : void
      {
         super.customUpdate();
         if(this.maskShape)
         {
            this.maskShape.x = this.indicator.x;
            this.maskShape.y = this.indicator.y;
         }
         this.updateIndicator();
      }
   }
}

