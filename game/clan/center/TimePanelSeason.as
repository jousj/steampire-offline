package game.clan.center
{
   import ui.common.TimePanel;
   
   public class TimePanelSeason extends TimePanel
   {
      
      public function TimePanelSeason()
      {
         super();
      }
      
      override public function assign(param1:Number, param2:Number) : TimePanel
      {
         super.assign(param1,param2);
         textSignal.stopHandler = this.onEndTime;
         return this;
      }
      
      private function onEndTime(param1:* = null) : void
      {
         layoutW = 0;
         text.value = Lang.getString("result_wait");
      }
   }
}

