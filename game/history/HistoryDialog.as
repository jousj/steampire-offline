package game.history
{
   import engine.signal.Signal;
   import flash.filters.ColorMatrixFilter;
   import ui.common.VerticalTabDialog;
   import ui.vbase.SkinManager;
   import ui.vbase.VRenderer;
   
   public class HistoryDialog extends VerticalTabDialog
   {
      
      public static const HISTORY_TAB:uint = 0;
      
      public static const NEWS_TAB:uint = 1;
      
      private var filter:ColorMatrixFilter;
      
      private var repeat:Boolean;
      
      private var signal:Signal;
      
      public function HistoryDialog(param1:uint)
      {
         super();
         addTab("HistoryIcon",Lang.getString("battle_logs"),param1);
         addTab(SkinManager.getExternal("NewsIcon",SkinManager.LOAD_CLIP),Lang.getString("news_title"),param1);
      }
      
      public function highLightBossFight() : void
      {
         this.signal = new Signal(this.onSignal1);
         this.signal.delay = 0.02;
         this.signal.data = grid.renderList[0];
         this.signal.run(0.4);
      }
      
      private function onSignal1() : void
      {
         var _loc1_:VRenderer = this.signal.data;
         this.getFilter(28 * this.signal.passedRate,1 + 0.28 * this.signal.passedRate);
         _loc1_.filters = [this.filter];
         if(this.signal.tail == 0)
         {
            this.signal.handler = this.onSignal2;
            this.signal.run(0.4);
         }
      }
      
      private function onSignal2() : void
      {
         var _loc1_:VRenderer = this.signal.data;
         this.getFilter(28 * (1 - this.signal.passedRate),1.28 - 0.28 * this.signal.passedRate);
         _loc1_.filters = [this.filter];
         if(this.signal.tail == 0)
         {
            if(!this.repeat)
            {
               this.repeat = true;
               this.signal.handler = this.onSignal1;
               this.signal.run(0.4);
            }
            else
            {
               this.signal.stopWithoutHandler();
               this.signal = null;
               this.filter = null;
               _loc1_.filters = null;
            }
         }
      }
      
      private function getFilter(param1:Number, param2:Number) : void
      {
         if(!this.filter)
         {
            this.filter = new ColorMatrixFilter();
         }
         this.filter.matrix = [param2,0,0,0,param1,0,param2,0,0,param1,0,0,param2,0,param1,0,0,0,1,0];
      }
   }
}

