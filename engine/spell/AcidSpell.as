package engine.spell
{
   import engine.Isometric;
   import engine.signal.Signal;
   import flash.geom.Point;
   import logic.battle.SimBaseVisual;
   import utils.CommonUtils;
   
   public class AcidSpell extends RAASpell
   {
      
      private var kind:String;
      
      private var rW:uint;
      
      private var rH:uint;
      
      public function AcidSpell(param1:String, param2:Point, param3:Number, param4:int)
      {
         super(param1,param2,param3);
         if(param4 > 0)
         {
            this.kind = param1;
            param4--;
            this.rW = param4 * Isometric.POS_WIDTH;
            this.rH = param4 * Isometric.POS_HEIGHT;
         }
      }
      
      override protected function step1() : void
      {
         if(this.rW == 0)
         {
            super.step1();
            return;
         }
         animation = animHash["repeat"];
         if(animation)
         {
            play(animation,true);
            signal = new Signal(this.addNClip);
            signal.delay = 0.15;
            signal.run(duration,0,true,true);
         }
         else
         {
            clear();
         }
      }
      
      private function addNClip() : void
      {
         if(signal.tail == 0)
         {
            step2();
         }
         else
         {
            SimBaseVisual.addEffect(this.kind,"boom",x + CommonUtils.getRangeRandom(0,this.rW << 1) - this.rW,y + CommonUtils.getRangeRandom(0,this.rH << 1) - this.rH);
         }
      }
   }
}

