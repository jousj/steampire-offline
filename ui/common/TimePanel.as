package ui.common
{
   import engine.signal.Signal;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class TimePanel extends VComponent
   {
      
      protected const text:VText = UIFactory.createYellowText(null,VText.CONTAIN_CENTER,14);
      
      protected var textSignal:Signal;
      
      public function TimePanel()
      {
         super();
         setSize(88,24);
         this.text.setBaseFormat(16,Style.yellowRGB);
         add(this.text,{
            "left":32,
            "right":5,
            "vCenter":1
         });
         add(SkinManager.getEmbed("ClockIcon"),{
            "h":27,
            "left":0,
            "vCenter":0
         });
      }
      
      public function assign(param1:Number, param2:Number) : TimePanel
      {
         if(!this.textSignal)
         {
            this.textSignal = new Signal(this.onTextSignal,Signal.ADD_TIMER);
         }
         this.textSignal.run(param2,param1,true);
         return this;
      }
      
      private function onTextSignal() : void
      {
         this.text.value = StringHelper.getTimeDesc(this.textSignal.tail);
      }
      
      override public function dispose() : void
      {
         if(this.textSignal)
         {
            this.textSignal.stopWithoutHandler();
         }
         super.dispose();
      }
   }
}

