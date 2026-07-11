package ui.common
{
   import engine.signal.Signal;
   import flash.events.MouseEvent;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class BaseDialog extends VComponent
   {
      
      public var mediator:Object;
      
      public var closeBt:VButton;
      
      public var levelPanel:LevelPanel;
      
      public function BaseDialog()
      {
         super();
      }
      
      public function addDialogTitle(param1:String, param2:Boolean = true, param3:uint = 64) : VText
      {
         var _loc4_:uint = VText.CONTAIN;
         if(param2)
         {
            _loc4_ |= VText.CENTER;
         }
         var _loc5_:VText = UIFactory.createYellowText(param1,_loc4_,33,true);
         add(_loc5_,{
            "left":40,
            "top":18,
            "right":param3
         });
         return _loc5_;
      }
      
      public function addUnitDialogTitle(param1:String, param2:uint, param3:Boolean = true, param4:uint = 0, param5:int = 40) : void
      {
         var _loc6_:VText = UIFactory.createYellowText(Lang.getString(param1),VText.CONTAIN | VText.MIDDLE,33,true).assignW(-100);
         this.levelPanel = new LevelPanel(LevelPanel.size42,param2);
         _loc6_.maxW = param4 > 0 ? param4 : (layoutW > 0 ? uint(layoutW - this.levelPanel.measuredWidth - 120) : 0);
         var _loc7_:VBox = new VBox(new <VComponent>[_loc6_,this.levelPanel],7);
         _loc7_.top = 11;
         if(param3)
         {
            _loc7_.hCenter = 0;
         }
         else
         {
            _loc7_.left = param5;
         }
         add(_loc7_);
      }
      
      public function addCloseButton(param1:Object = null) : void
      {
         var _loc2_:VButton = VButton.createEmbed("CloseBt");
         _loc2_.addClickListener(this.close);
         add(_loc2_,param1 ? param1 : {
            "right":15,
            "top":15
         });
         this.closeBt = _loc2_;
      }
      
      public function close(param1:MouseEvent = null) : void
      {
         dispatchEvent(new VEvent(VEvent.CLOSE_DIALOG));
      }
      
      protected function onBtClose(param1:MouseEvent) : void
      {
         dispatchEvent(new VEvent(VEvent.CLOSE_DIALOG,(param1.currentTarget as VButton).data));
      }
      
      public function addBg(param1:Boolean) : void
      {
         addStretch(SkinManager.getEmbed("DialogBg",VSkin.STRETCH_BG));
         if(param1)
         {
            add(SkinManager.getEmbed("DialogGears1"),{
               "top":46,
               "left":1
            });
            add(SkinManager.getEmbed("DialogGears2"),{
               "top":64,
               "right":22
            });
         }
         add(SkinManager.getEmbed("DialogTop",VSkin.STRETCH_BG),{"wP":100});
      }
      
      public function useSimpleBg(param1:int, param2:int, param3:String = null) : void
      {
         setSize(param1,param2);
         addStretch(SkinManager.getEmbed("DialogBg",VSkin.STRETCH_BG));
         add(SkinManager.getEmbed("DialogTop",VSkin.STRETCH_BG),{"wP":100});
         if(param3)
         {
            this.addDialogTitle(param3);
         }
         this.addCloseButton();
      }
      
      public function useDefaultBg(param1:int, param2:String = null, param3:uint = 0) : void
      {
         setSize(814,param1);
         this.addBg(false);
         if(param2)
         {
            if(param3 > 0)
            {
               this.addDialogTitle(param2,false,param3);
            }
            else
            {
               this.addDialogTitle(param2);
            }
         }
         this.addCloseButton();
      }
      
      public function useWhiteBg(param1:int, param2:int, param3:String = null, param4:Boolean = true) : void
      {
         setSize(param1,param2);
         add(SkinManager.getEmbed("FeatureSectionBg",VSkin.STRETCH_BG),{
            "wP":100,
            "top":40,
            "bottom":0
         });
         add(SkinManager.getEmbed("DialogTop",VSkin.STRETCH_BG),{"wP":100});
         if(param3)
         {
            this.addDialogTitle(param3,true,param4 ? 64 : 40);
         }
         if(param4)
         {
            this.addCloseButton();
         }
      }
      
      public function addCloseSignal(param1:Number) : void
      {
         addListener(VEvent.CLOSE_DIALOG,this.onClearSignal);
         this.mediator = new Signal(this.close);
         (this.mediator as Signal).delayCall(param1);
      }
      
      private function onClearSignal(param1:VEvent) : void
      {
         if(this.mediator is Signal)
         {
            (this.mediator as Signal).stop();
            this.mediator = null;
         }
      }
      
      public function addHeader() : void
      {
         add(SkinManager.getEmbed("DialogTop",VSkin.STRETCH_BG),{"wP":100});
         this.addCloseButton();
      }
   }
}

