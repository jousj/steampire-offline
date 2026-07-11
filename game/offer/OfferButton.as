package game.offer
{
   import engine.signal.Signal;
   import ui.UIFactory;
   import ui.common.DurationPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class OfferButton extends VButton
   {
      
      private const text:VText = UIFactory.createYellowText(null,VText.CENTER | VText.MIDDLE,16);
      
      private const bgSkin:VSkin = new VSkin(VSkin.CACHE_AS_BITMAP);
      
      private const bottomSkin:VSkin = new VSkin(VSkin.STRETCH | VSkin.CACHE_AS_BITMAP);
      
      private var durationPanel:DurationPanel;
      
      private var topSkin:VSkin;
      
      private var leftSkin:VSkin;
      
      private var signal:Signal;
      
      public function OfferButton()
      {
         super();
         SkinManager.applyExternal(this.bgSkin,UIFactory.OFFER_PACK,"OfferBtBg");
         addChild(this.bgSkin);
         setIcon(new VSkin(VSkin.CACHE_AS_BITMAP),{
            "w":71,
            "h":67
         });
         SkinManager.applyExternal(this.bottomSkin,UIFactory.OFFER_PACK,"OfferBtBottom");
         this.bottomSkin.right = 0;
         addChildAt(this.bottomSkin,0);
         this.text.format.lineHeight = "100%";
         add(this.text,{
            "minW":20,
            "maxW":134,
            "h":32
         });
         layoutH = 93;
      }
      
      public function init(param1:Function, param2:Function, param3:String) : void
      {
         addClickListener(param1);
         addListener(VEvent.CHANGE,param2);
         data = param3;
      }
      
      public function sync(param1:String, param2:Number = 0) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param2 > 0)
         {
            if(!this.durationPanel)
            {
               this.durationPanel = new DurationPanel(20,12,1);
               this.durationPanel.text.setMode(VText.CENTER);
               this.durationPanel.text.layoutW = -100;
               this.durationPanel.left = -2;
               this.durationPanel.minW = 72;
               this.topSkin = SkinManager.getPack(UIFactory.OFFER_PACK,"OfferBtTop");
               this.leftSkin = SkinManager.getPack(UIFactory.OFFER_PACK,"OfferBtLeft");
            }
            if(!this.durationPanel.parent)
            {
               addChild(this.topSkin);
               addChild(this.durationPanel);
               addChildAt(this.leftSkin,0);
            }
            _loc3_ = 12;
            _loc4_ = 9;
            this.durationPanel.setTrackTime(param2);
         }
         else
         {
            if(this.durationPanel)
            {
               this.durationPanel.setTrackTime(-1);
               if(this.durationPanel.parent)
               {
                  removeChild(this.durationPanel);
                  removeChild(this.topSkin);
                  removeChild(this.leftSkin);
               }
            }
            _loc3_ = 0;
            _loc4_ = 6;
         }
         this.bgSkin.left = _loc3_;
         this.bgSkin.top = _loc4_;
         icon.left = _loc3_ + 6;
         icon.top = _loc4_ + 6;
         this.text.left = 87 + _loc3_;
         this.text.bottom = 22 - _loc4_;
         this.bottomSkin.bottom = 9 - _loc4_;
         this.bottomSkin.left = _loc3_ + 9;
         this.text.isGeometryPhase = false;
         this.text.value = Lang.getStringOrDefault(param1,"so_default");
         this.text.geometryPhase();
         layoutW = this.text.left + 22 + this.text.w;
         syncLayout();
      }
      
      public function set swipe(param1:Boolean) : void
      {
         if(param1)
         {
            if(!this.signal)
            {
               this.signal = new Signal(this.change);
               this.signal.delay = 15;
            }
            this.signal.data = true;
            this.signal.run(0,Number.MAX_VALUE,false,true);
         }
         else if(this.signal)
         {
            this.signal.data = false;
            this.signal.stop();
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(Boolean(this.signal) && Boolean(this.signal.data))
         {
            if(param1)
            {
               this.signal.run(0,Number.MAX_VALUE,false,true);
            }
            else
            {
               this.signal.stop();
            }
         }
      }
      
      public function change() : void
      {
         dispatchEvent(new VEvent(VEvent.CHANGE));
      }
   }
}

