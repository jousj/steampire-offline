package game.board
{
   import engine.signal.Signal;
   import model.vo.VOResourceSpec;
   import ui.Style;
   import ui.vbase.VButton;
   import ui.vbase.VText;
   
   public class ResTrackText extends VText
   {
      
      private var max:uint;
      
      private var bt:VButton;
      
      public function ResTrackText(param1:uint = 0)
      {
         super(null,param1);
         Style.applyGlowFormat(this,14,Style.yellowRGB,Style.grayGlowRGB);
      }
      
      public function track(param1:VButton, param2:VOResourceSpec) : void
      {
         if(param2.capacityCur < param2.capacityMax)
         {
            if(param2.capacityCur == 0)
            {
               this.bt = param1;
               param1.disabled = true;
            }
            this.max = param2.capacityMax;
            Signal.createRef(this,this.onSignal,Signal.ADD_PERIOD,1 / param2.prodValue).run(param2.capacityMax / param2.prodValue,param2.lastTime + (param2.capacityMax - param2.capacityCur) / param2.prodValue,true);
         }
         else
         {
            value = param2.capacityMax.toString();
         }
      }
      
      private function onSignal(param1:Signal) : void
      {
         if(this.bt)
         {
            this.bt.disabled = false;
            this.bt = null;
         }
         value = uint(param1.passedRate * this.max).toString();
      }
      
      override public function dispose() : void
      {
         Signal.stopRef(this);
         super.dispose();
      }
   }
}

