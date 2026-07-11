package ui.game
{
   import engine.signal.Signal;
   import logic.CoreLogic;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VProgressBar;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class UnitProgressBar extends VComponent
   {
      
      private const text:VText = new VText();
      
      private var pb:VProgressBar;
      
      private var endTime:Number = 0;
      
      private var duration:Number;
      
      private var textSignal:Signal;
      
      private var pbSignal:Signal;
      
      private var icon:VSkin;
      
      private var isSimulate:Boolean;
      
      private var isVisible:Boolean = true;
      
      public function UnitProgressBar(param1:String = null, param2:uint = 16, param3:uint = 24)
      {
         super();
         mouseChildren = mouseEnabled = false;
         setSize(80,35);
         this.pb = UIFactory.createProgressBar(param1 ? param1 : UIFactory.INDICATOR_BLUE);
         add(this.pb,{
            "wP":100,
            "h":param3,
            "bottom":0
         });
         addChild(this.text);
         this.text.hCenter = 0;
         Style.applyDefaultFormat(this.text,param2);
      }
      
      public function set value(param1:Number) : void
      {
         this.signalStop();
         this.pb.value = param1;
      }
      
      public function setTimerValue(param1:Number, param2:Number, param3:Boolean = false) : void
      {
         this.endTime = param1;
         this.duration = param2;
         this.isSimulate = param3;
         if(isGeometryPhase)
         {
            this.signalStart();
         }
      }
      
      public function setEndTime(param1:Number) : void
      {
         this.endTime = param1;
         if(this.pbSignal)
         {
            this.signalStart();
         }
      }
      
      private function signalStart() : void
      {
         if(!this.pbSignal)
         {
            this.pbSignal = new Signal(this.onProgressSignal);
            this.pbSignal.delay = this.duration / Math.max(this.pb.getIndicator().w,50);
            this.textSignal = new Signal(this.onTextSignal,Signal.ADD_TIMER);
         }
         this.pbSignal.run(this.duration,this.endTime,true,this.isSimulate);
         this.textSignal.run(this.duration,this.endTime,true,this.isSimulate);
      }
      
      private function signalStop() : void
      {
         if(this.pbSignal)
         {
            this.pbSignal.stop();
            this.textSignal.stop();
         }
      }
      
      private function onTextSignal() : void
      {
         if(this.isVisible)
         {
            this.text.value = StringHelper.getTimeDesc(this.textSignal.tail);
         }
         else
         {
            this.textSignal.data = true;
         }
      }
      
      private function onProgressSignal() : void
      {
         if(this.isVisible)
         {
            this.pb.value = this.pbSignal.passedRate;
         }
         else
         {
            this.pbSignal.data = true;
         }
      }
      
      override protected function customUpdate() : void
      {
         super.customUpdate();
         if(this.endTime > 0)
         {
            if(!this.pbSignal)
            {
               this.signalStart();
            }
            else
            {
               this.pbSignal.handlerTime = CoreLogic.getSignalTime(false);
               this.pbSignal.delay = this.duration / Math.max(this.pb.getIndicator().w,50);
            }
         }
      }
      
      override public function dispose() : void
      {
         this.signalStop();
         super.dispose();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(this.isVisible != param1)
         {
            this.isVisible = param1;
            if(this.pbSignal)
            {
               if(param1)
               {
                  if(this.pbSignal.data)
                  {
                     this.onProgressSignal();
                  }
                  if(this.textSignal.data)
                  {
                     this.onTextSignal();
                  }
               }
               else
               {
                  this.textSignal.data = this.pbSignal.data = false;
               }
            }
         }
      }
      
      public function setIcon(param1:String) : void
      {
         if(!this.icon)
         {
            this.icon = new VSkin();
            add(this.icon,{
               "left":-30,
               "w":30,
               "vCenter":3
            });
         }
         SkinManager.applyExternal(this.icon,param1,null,SkinManager.PNG);
      }
   }
}

