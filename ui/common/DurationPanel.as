package ui.common
{
   import engine.signal.Signal;
   import logic.CoreLogic;
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class DurationPanel extends VBox
   {
      
      public const text:VText = new VText();
      
      public function DurationPanel(param1:uint = 49, param2:uint = 20, param3:uint = 5, param4:* = false)
      {
         if(param4 is uint)
         {
            this.text.setBaseFormat(param2,param4);
         }
         else
         {
            Style.applyDefaultFormat(this.text,param2,param4);
            this.text.format.baselineShift = -2;
         }
         var _loc5_:VSkin = SkinManager.getEmbed("ClockIcon");
         _loc5_.setSize(param1,param1);
         super(new <VComponent>[_loc5_,this.text],param3);
      }
      
      public function setTrackTime(param1:Number, param2:Boolean = false) : DurationPanel
      {
         if(param2)
         {
            param1 -= CoreLogic.serverTime;
         }
         if(param1 > 0)
         {
            Signal.createRef(this,this.onSignal,Signal.ADD_TIMER).run(param1,0,true);
         }
         else
         {
            this.text.value = "-";
            Signal.stopRef(this);
         }
         return this;
      }
      
      public function setStaticTime(param1:int) : DurationPanel
      {
         this.text.value = param1 > 0 ? StringHelper.getTimeDesc(param1) : Lang.getString("shop_zero_time");
         return this;
      }
      
      private function onSignal(param1:Signal) : void
      {
         if(param1.tail > 0)
         {
            this.text.value = StringHelper.getTimeDesc(param1.tail);
         }
         else
         {
            this.text.value = "-";
            dispatcher.dispatchEvent(new VEvent(VEvent.CHANGE));
         }
      }
      
      override public function dispose() : void
      {
         Signal.stopRef(this);
         super.dispose();
      }
      
      public function useBg(param1:uint) : void
      {
         this.text.minW = param1;
         this.text.setMode(VText.CENTER);
         var _loc2_:VSkin = SkinManager.getEmbed("ResBg",VSkin.STRETCH);
         _loc2_.useRuledLayout();
         _loc2_.assignLayout({
            "left":10,
            "right":-20
         });
         addChildAt(_loc2_,0);
         _loc2_ = SkinManager.getEmbed("ResFg",VSkin.STRETCH);
         _loc2_.useRuledLayout();
         _loc2_.assignLayout({
            "left":10,
            "right":-20
         });
         addChildAt(_loc2_,1);
      }
   }
}

