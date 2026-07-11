package game.quest
{
   import engine.signal.Signal;
   import flash.events.MouseEvent;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.game.BubblePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class NewStoryDialog extends BaseDialog
   {
      
      private const basePanel:VComponent = new VComponent();
      
      private const skinPanel:VComponent = new VComponent();
      
      private const skin:VSkin = new VSkin();
      
      private const bubblePanel:BubblePanel = new BubblePanel();
      
      private const personText:VText = new VText(null,VText.CENTER,4209978,20);
      
      private const signal:Signal = new Signal();
      
      private var leftOrRight:Boolean;
      
      private var isShowPerson:Boolean;
      
      private var isNewPerson:Boolean;
      
      private var cacheKind:String;
      
      private var continueText:VText;
      
      private var button:RectButton;
      
      public var data:String;
      
      public function NewStoryDialog(param1:String = null, param2:String = null, param3:Boolean = true)
      {
         super();
         stretch();
         addStretch(new VFill(0,0));
         add(new VFill(0),{
            "wP":100,
            "hP":15
         });
         add(new VFill(0),{
            "wP":100,
            "hP":15,
            "bottom":0
         });
         add(this.basePanel,{
            "hP":85,
            "hCenter":0,
            "wP":100,
            "maxW":1300
         });
         this.basePanel.add(this.skinPanel,{
            "h":360,
            "w":360,
            "bottom":0
         });
         this.skinPanel.addStretch(this.skin);
         this.skin.addListener(VEvent.EXTERNAL_COMPLETE,this.onLoad);
         this.skinPanel.add(this.personText,{
            "bottom":-50,
            "hCenter":0
         });
         if(Lang.locale == Lang.RU || Lang.locale == Lang.EN)
         {
            this.bubblePanel.layoutW = 370;
            this.bubblePanel.wpadding = 50;
         }
         else
         {
            this.bubblePanel.layoutW = 390;
            this.bubblePanel.wpadding = 25;
         }
         this.basePanel.add(this.bubblePanel,{
            "h":155,
            "bottom":40
         });
         this.signal.delay = 0.001;
         addListener(MouseEvent.CLICK,this.onClick);
         if(param1)
         {
            this.say(param1,param2,param3);
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(!this.button && this.bubblePanel.label.visible)
         {
            close();
         }
      }
      
      public function say(param1:String, param2:String, param3:Boolean = true, param4:String = null, param5:String = null) : void
      {
         var _loc6_:uint = 0;
         this.signal.stopWithoutHandler();
         this.bubblePanel.direction = param3 ? BubblePanel.TAIL_LEFT : BubblePanel.TAIL_RIGHT;
         this.bubblePanel.changeMessageBottom(14,true);
         this.bubblePanel.setMessage(param2);
         if(this.leftOrRight != param3 || !this.cacheKind)
         {
            _loc6_ = uint(VSkin.NO_STRETCH | VSkin.BOTTOM | VSkin.EXTERNAL_EVENT);
            if(param3)
            {
               this.skinPanel.left = 0;
               this.bubblePanel.left = 330;
               this.bubblePanel.right = this.skinPanel.right = VComponent.EMPTY;
            }
            else
            {
               _loc6_ |= VSkin.FLIP_X;
               this.skinPanel.right = 0;
               this.bubblePanel.right = 330;
               this.bubblePanel.left = this.skinPanel.left = VComponent.EMPTY;
            }
            this.skin.setMode(_loc6_,false);
            this.skinPanel.syncLayout();
            this.bubblePanel.syncLayout();
         }
         this.bubblePanel.label.visible = this.bubblePanel.visible = this.skinPanel.visible = false;
         this.isNewPerson = this.cacheKind != param1;
         this.isShowPerson = this.isNewPerson || this.leftOrRight != param3;
         if(this.isNewPerson)
         {
            this.personText.visible = false;
            this.cacheKind = param1;
            this.personText.value = Lang.getString(param1 + "_desc");
         }
         this.leftOrRight = param3;
         if(param5)
         {
            if(this.button)
            {
               this.button.title = param5;
            }
            else
            {
               this.button = new RectButton(param5,RectButton.h56,RectButton.ORANGE);
               if(this.continueText)
               {
                  this.continueText.removeFromParent();
                  this.continueText = null;
               }
               this.bubblePanel.add(this.button,{
                  "bottom":-28,
                  "hCenter":0
               });
               this.button.addClickListener(close);
            }
            this.button.visible = false;
         }
         else
         {
            if(this.button)
            {
               this.button.removeFromParent();
               this.button = null;
            }
            else if(!this.continueText)
            {
               this.continueText = new VText(Lang.getString("tap_for_continue"),VText.CONTAIN_CENTER,16777215,20);
               this.bubblePanel.add(this.continueText,{
                  "bottom":-30,
                  "left":-8,
                  "right":-8
               });
            }
            this.continueText.visible = false;
         }
         SkinManager.applyExternal(this.skin,"story_" + (param4 ? param1 + param4 : param1),null,SkinManager.PNG);
         if(this.skin.isContent)
         {
            this.onLoad(null);
         }
      }
      
      private function onLoad(param1:VEvent) : void
      {
         if(this.isShowPerson)
         {
            this.signal.handler = this.onPersonSignal;
            this.signal.run(0.2,0,true);
         }
         else
         {
            this.signal.handler = this.showBubble;
            this.signal.delayCall(0.2);
         }
         this.skinPanel.visible = true;
      }
      
      private function onPersonSignal() : void
      {
         var _loc1_:Number = 1 - this.signal.passedRate;
         var _loc2_:int = _loc1_ * -300;
         this.skinPanel.alpha = 1 - 0.5 * _loc1_;
         if(this.leftOrRight)
         {
            this.skinPanel.x = this.skinPanel.left = _loc2_;
         }
         else
         {
            this.skinPanel.right = _loc2_;
            this.skinPanel.x = this.basePanel.w - this.skinPanel.layoutW - _loc2_;
         }
         if(_loc1_ == 0)
         {
            this.showBubble();
         }
      }
      
      private function showBubble() : void
      {
         this.bubblePanel.visible = true;
         this.signal.handler = this.onBubbleSignal;
         this.signal.run(0.2,0,true);
      }
      
      private function onBubbleSignal() : void
      {
         this.bubblePanel.alpha = this.signal.passedRate;
         if(this.signal.tail == 0)
         {
            this.showMessage();
         }
      }
      
      private function showMessage() : void
      {
         this.bubblePanel.label.visible = true;
         this.signal.handler = this.onMessageSignal;
         this.signal.run(0.2,0,true);
      }
      
      private function onMessageSignal() : void
      {
         this.bubblePanel.label.alpha = this.signal.passedRate;
         if(this.signal.tail == 0)
         {
            if(this.isNewPerson)
            {
               this.showPersonText();
            }
            else
            {
               this.useWaitClose();
            }
         }
      }
      
      private function showPersonText() : void
      {
         this.personText.visible = true;
         this.signal.handler = this.onPersonTextSignal;
         this.signal.run(0.3,0,true);
      }
      
      private function onPersonTextSignal() : void
      {
         this.personText.alpha = this.signal.passedRate;
         if(this.signal.tail == 0)
         {
            this.useWaitClose();
         }
      }
      
      private function useWaitClose() : void
      {
         if(this.continueText)
         {
            this.signal.handler = this.showContinue;
            this.signal.delayCall(0.4);
         }
         else
         {
            this.bubblePanel.changeMessageBottom(30,false);
            this.button.visible = true;
         }
      }
      
      private function showContinue() : void
      {
         this.continueText.visible = true;
         this.signal.handler = this.onContinueSignal;
         this.signal.data = false;
         this.continueText.alpha = 0;
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
      
      override public function dispose() : void
      {
         this.signal.stopWithoutHandler();
         super.dispose();
      }
   }
}

