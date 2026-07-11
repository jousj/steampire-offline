package game.quest
{
   import engine.signal.Signal;
   import flash.events.MouseEvent;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class ComicDialog extends BaseDialog
   {
      
      private const basePanel:VComponent = new VComponent();
      
      private const signal:Signal = new Signal();
      
      private const comicFill:VFill = new VFill(0,1);
      
      private const continueText:VText = new VText(Lang.getString("tap_for_continue"),VText.CONTAIN_CENTER,16777215,20);
      
      private const currentText:VText = UIFactory.createYellowText(null,VText.CENTER,18,true);
      
      private const currentImage:VSkin = new VSkin(VSkin.EXTERNAL_EVENT | VSkin.STRETCH);
      
      private var stageChecker:String;
      
      private var slideCounter:uint = 0;
      
      private var imageList:Vector.<ComicSlide>;
      
      private var endHandler:Function;
      
      public function ComicDialog(param1:Vector.<ComicSlide>, param2:Function, param3:String = null)
      {
         super();
         this.imageList = param1;
         this.endHandler = param2;
         this.stageChecker = param3;
         stretch();
         addStretch(new VFill(0));
         add(this.currentImage,{
            "hCenter":0,
            "vCenter":0
         });
         add(this.basePanel,{
            "hP":85,
            "hCenter":0,
            "wP":100,
            "maxW":1300
         });
         this.basePanel.add(this.currentText,{
            "hCenter":0,
            "bottom":-10,
            "maxW":400
         });
         addStretch(this.comicFill);
         this.currentImage.addListener(VEvent.EXTERNAL_COMPLETE,this.onLoadNextSlide);
         addListener(MouseEvent.CLICK,this.nextSlide);
         this.signal.delay = 0.02;
         mouseEnabled = mouseChildren = false;
         this.revealSlide();
      }
      
      public function nextSlide(param1:MouseEvent = null) : void
      {
         mouseEnabled = mouseChildren = false;
         ++this.slideCounter;
         remove(this.continueText,false);
         this.signal.stopWithoutHandler();
         this.signal.handler = this.onFadeSignal;
         this.signal.run(0.7);
         if(this.stageChecker)
         {
            Facade.changeUserStage(this.stageChecker + this.slideCounter + "_click");
         }
      }
      
      private function revealSlide() : void
      {
         var _loc1_:ComicSlide = this.imageList[this.slideCounter];
         this.currentText.value = Lang.getString(_loc1_.text);
         SkinManager.applyExternal(this.currentImage,_loc1_.image,null,SkinManager.JPG);
         if(this.currentImage.isContent)
         {
            this.onLoadNextSlide(null);
         }
      }
      
      private function onShowContinue() : void
      {
         this.basePanel.add(this.continueText,{
            "hCenter":0,
            "bottom":-60
         });
         this.signal.handler = this.onContinueSignal;
         this.signal.data = false;
         this.signal.run(0,Number.MAX_VALUE);
      }
      
      private function onContinueSignal() : void
      {
         var _loc1_:Number = NaN;
         if(this.signal.duration < this.signal.handlerTime)
         {
            this.signal.duration = this.signal.handlerTime + 0.75;
            this.signal.data = !this.signal.data;
            _loc1_ = 1;
         }
         else
         {
            _loc1_ = this.signal.duration - this.signal.handlerTime;
         }
         if(this.signal.data)
         {
            _loc1_ = 1 - _loc1_;
         }
         this.continueText.alpha = _loc1_ * 0.5;
      }
      
      private function onLoadNextSlide(param1:VEvent) : void
      {
         this.continueText.alpha = 0;
         this.signal.handler = this.onUnFadeSignal;
         this.signal.run(0.7);
      }
      
      private function onFadeSignal() : void
      {
         this.comicFill.alpha = this.signal.passedRate;
         if(this.signal.tail == 0)
         {
            if(this.slideCounter == this.imageList.length)
            {
               this.close();
               if(Boolean(this.endHandler))
               {
                  this.endHandler();
               }
            }
            else
            {
               this.revealSlide();
            }
         }
      }
      
      override public function close(param1:MouseEvent = null) : void
      {
         if(this.signal)
         {
            this.signal.stopWithoutHandler();
         }
         super.close(param1);
      }
      
      private function onUnFadeSignal() : void
      {
         this.comicFill.alpha = 1 - this.signal.passedRate;
         if(this.signal.tail == 0)
         {
            this.signal.handler = this.onShowContinue;
            this.signal.delayCall(3);
            mouseEnabled = mouseChildren = true;
         }
      }
   }
}

