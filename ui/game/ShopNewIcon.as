package ui.game
{
   import engine.signal.Signal;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   
   public class ShopNewIcon extends VSkin
   {
      
      private const signal:Signal = new Signal();
      
      public function ShopNewIcon(param1:Number = 0)
      {
         super();
         SkinManager.applyEmbed(this,"NewIconAnim");
         if(param1 != 0)
         {
            rotation = param1;
         }
      }
      
      public function launch() : ShopNewIcon
      {
         this.signal.handler = this.run;
         this.signal.delay = 5;
         this.signal.run(Number.MAX_VALUE,0,true);
         return this;
      }
      
      private function run() : void
      {
         contentPlay(true);
      }
      
      override public function dispose() : void
      {
         this.signal.stopWithoutHandler();
         super.dispose();
      }
   }
}

