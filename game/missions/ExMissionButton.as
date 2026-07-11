package game.missions
{
   import engine.signal.Signal;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class ExMissionButton extends MissionButton
   {
      
      private const signal:Signal;
      
      private const timeText:VText = UIFactory.createYellowText(null,VText.CONTAIN_CENTER | VText.MIDDLE);
      
      public function ExMissionButton(param1:uint)
      {
         this.signal = new Signal(this.onSignal,Signal.ADD_TIMER);
         super(param1);
      }
      
      private function setExIcon(param1:int, param2:Number = 0) : void
      {
         var _loc3_:VComponent = null;
         var _loc4_:int = 0;
         switch(param1)
         {
            case ExtMissionStatus.OIL:
               _loc3_ = SkinManager.getEmbed("Oil");
               break;
            case ExtMissionStatus.CRYSTAL:
               _loc3_ = SkinManager.getEmbed("Crystal");
               break;
            case ExtMissionStatus.BOTH:
               _loc3_ = new VComponent();
               _loc3_.add(SkinManager.getEmbed("Oil"),{
                  "w":40,
                  "h":40
               });
               _loc3_.add(SkinManager.getEmbed("Crystal"),{
                  "left":11,
                  "top":7,
                  "w":32,
                  "h":32
               });
               break;
            default:
               _loc4_ = -1;
               this.syncTimer(param2);
               _loc3_ = this.timeText;
         }
         setIcon(_loc3_,{
            "hCenter":0,
            "vCenter":-3 + _loc4_,
            "w":44,
            "h":44
         });
      }
      
      public function applyExState(param1:uint, param2:uint, param3:Number) : void
      {
         applyState(param1);
         this.setExIcon(param1 == MissionButton.M_DISABLED ? -1 : int(param2),param3);
      }
      
      private function syncTimer(param1:Number) : void
      {
         this.signal.run(param1,0,true);
      }
      
      private function onSignal() : void
      {
         this.timeText.value = StringHelper.getTimeDesc(this.signal.tail);
         if(this.signal.tail == 0)
         {
            dispatcher.dispatchEvent(new VEvent(VEvent.CHANGE));
         }
      }
      
      override public function dispose() : void
      {
         this.signal.stop();
         super.dispose();
      }
   }
}

