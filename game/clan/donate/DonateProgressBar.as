package game.clan.donate
{
   import engine.signal.Signal;
   import model.CommonEvent;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.DurationPanel;
   import ui.game.PricePanel;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class DonateProgressBar extends VComponent
   {
      
      public const bt:VButton = new VButton();
      
      public var myRes:ResourcePanel;
      
      public var toRes:ResourcePanel;
      
      private var headerPanel:VComponent;
      
      private var variance:uint;
      
      private var toMax:uint;
      
      private var isWait:Boolean;
      
      private var isCheckBt:Boolean;
      
      private const pricePanel:PricePanel = new PricePanel(20,18,PricePanel.GLOW_FILTER | PricePanel.IGNORE_CAPITAL);
      
      private var isLight:Boolean = false;
      
      public function DonateProgressBar(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:Boolean, param7:uint, param8:Boolean = false)
      {
         super();
         this.isLight = param8;
         setSize(478,param6 ? 71 : 52);
         this.variance = param1;
         this.toMax = param4;
         if(param6 && !param8)
         {
            add(SkinManager.getEmbed("ResHeaderBg",VSkin.STRETCH),{
               "hCenter":0,
               "w":406
            });
         }
         this.myRes = new ResourcePanel(param1,ResourcePanel.BG | (param2 > 0 ? ResourcePanel.PROGRESS : 0));
         if(param2 > 0)
         {
            this.myRes.setMax(param2);
         }
         add(this.myRes,{
            "left":0,
            "h":41,
            "bottom":6,
            "w":198
         });
         this.toRes = new ResourcePanel(param1,ResourcePanel.FLIP | ResourcePanel.BG | ResourcePanel.CLAN | (param4 > 0 ? ResourcePanel.PROGRESS : 0));
         if(param4 > 0)
         {
            this.toRes.setMax(param4);
         }
         this.toRes.cur = param3;
         add(this.toRes,{
            "right":0,
            "h":41,
            "bottom":6,
            "w":202
         });
         if(param7 == uint.MAX_VALUE)
         {
            this.myRes.useTrack();
            this.pricePanel.useCheck = true;
            Facade.addListenerForComponent(CommonEvent.CLAN_RESOURCE,this.onClanResource,this);
         }
         else
         {
            this.isCheckBt = true;
            this.myRes.cur = param7;
            if(param7 < param5)
            {
               this.bt.disabled = true;
            }
         }
         this.pricePanel.assign(param1,param5);
         var _loc9_:VBox = new VBox(new <VComponent>[UIFactory.createYellowText(Lang.getString("donateBt2"),VText.CONTAIN_CENTER,16).assignW(-100).assignMaxW(100),this.pricePanel],0,VBox.VERTICAL);
         this.bt.addStretch(SkinManager.getEmbed("BtArrow",VSkin.STRETCH_BG));
         this.bt.setIcon(_loc9_,{
            "left":8,
            "right":15,
            "vCenter":-1
         });
         add(this.bt,{
            "hCenter":2,
            "h":52,
            "minW":110,
            "bottom":0
         });
         this.syncBtDisabled();
      }
      
      private function syncBtDisabled() : void
      {
         this.bt.disabled = this.isWait || this.toMax > 0 && this.toRes.cur >= this.toMax || this.isCheckBt && this.myRes.cur < this.pricePanel.getValue();
      }
      
      private function onClanResource(param1:CommonEvent) : void
      {
         if(param1.variance == this.variance)
         {
            this.toRes.setData(param1.data);
            this.syncBtDisabled();
         }
      }
      
      public function setTime(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:VText = null;
         var _loc5_:Signal = null;
         if(this.headerPanel)
         {
            remove(this.headerPanel);
         }
         this.isWait = param3 < param2 + param1;
         this.syncBtDisabled();
         if(this.isWait)
         {
            param2 += param1 - param3;
            _loc4_ = this.isLight ? UIFactory.createYellowText(Lang.getString("donate_time"),VText.CONTAIN_CENTER,14) : new VText(Lang.getString("donate_time"),VText.CONTAIN,Style.metalRGB,14);
            _loc4_.maxW = 280;
            this.headerPanel = new VBox(new <VComponent>[_loc4_,new DurationPanel(20,16,5).setTrackTime(param2)]);
            add(this.headerPanel,{
               "top":1,
               "hCenter":0
            });
            _loc5_ = Signal.createRef(this,this.onEndWait);
            _loc5_.data = param1;
            _loc5_.delayCall(param2);
         }
         else
         {
            Signal.stopRef(this);
            this.headerPanel = this.isLight ? UIFactory.createYellowText(Lang.getPatternString("donate_cooldown","__TIME__",StringHelper.getTimeDesc(param1)),VText.CONTAIN_CENTER,14) : new VText(Lang.getPatternString("donate_cooldown","__TIME__",StringHelper.getTimeDesc(param1)),VText.CONTAIN_CENTER,Style.metalRGB,14);
            add(this.headerPanel,{
               "left":42,
               "right":42,
               "top":5
            });
         }
      }
      
      private function onEndWait(param1:Signal) : void
      {
         this.setTime(param1.data,0,Number.MAX_VALUE);
      }
      
      override public function dispose() : void
      {
         Signal.stopRef(this);
         super.dispose();
      }
   }
}

