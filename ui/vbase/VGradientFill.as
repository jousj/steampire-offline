package ui.vbase
{
   import flash.geom.Matrix;
   
   public class VGradientFill extends VComponent
   {
      
      private var fillColors:Array;
      
      private var fillAlphas:Array;
      
      private var fillRatios:Array;
      
      private var gradientType:String;
      
      private var rotate:Number = 0;
      
      public function VGradientFill()
      {
         super();
         mouseEnabled = mouseChildren = false;
      }
      
      public function setFill(param1:Array, param2:Array, param3:Array, param4:Number = 0, param5:String = "linear") : void
      {
         this.fillColors = param1;
         this.fillAlphas = param2;
         this.fillRatios = param3;
         this.gradientType = param5;
         this.rotate = param4;
         if(isGeometryPhase)
         {
            updatePhase(true);
         }
      }
      
      override protected function customUpdate() : void
      {
         graphics.clear();
         var _loc1_:Matrix = new Matrix();
         _loc1_.createGradientBox(w,h,this.rotate);
         graphics.beginGradientFill(this.gradientType,this.fillColors,this.fillAlphas,this.fillRatios,_loc1_);
         graphics.drawRect(0,0,w,h);
         graphics.endFill();
      }
   }
}

