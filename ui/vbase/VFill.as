package ui.vbase
{
   public class VFill extends VComponent
   {
      
      private var fillColor:uint;
      
      private var fillAlpha:Number;
      
      private var round:uint;
      
      private var thickness:Number;
      
      private var lineColor:uint;
      
      private var lineAlpha:Number = 1;
      
      public function VFill(param1:uint, param2:Number = 1, param3:uint = 0)
      {
         super();
         mouseEnabled = mouseChildren = false;
         this.setFill(param1,param2,param3);
      }
      
      public function setLine(param1:Number, param2:uint, param3:Number = 1) : void
      {
         this.thickness = param1;
         this.lineColor = param2;
         this.lineAlpha = param3;
         if(isGeometryPhase)
         {
            updatePhase(true);
         }
      }
      
      public function setFill(param1:uint, param2:Number = 1, param3:uint = 0) : void
      {
         this.fillColor = param1;
         this.fillAlpha = param2;
         this.round = param3;
         if(isGeometryPhase)
         {
            updatePhase(true);
         }
      }
      
      override protected function customUpdate() : void
      {
         graphics.clear();
         var _loc1_:Boolean = !isNaN(this.thickness);
         if(_loc1_)
         {
            graphics.lineStyle(this.thickness,this.lineColor,this.lineAlpha,true);
         }
         if(this.fillAlpha > 0 || !_loc1_)
         {
            graphics.beginFill(this.fillColor,this.fillAlpha);
         }
         if(this.round == 0)
         {
            graphics.drawRect(0,0,w,h);
         }
         else
         {
            graphics.drawRoundRect(0,0,w,h,this.round);
         }
         graphics.endFill();
      }
   }
}

