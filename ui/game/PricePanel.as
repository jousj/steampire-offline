package ui.game
{
   import engine.signal.Signal;
   import engine.signal.Tween;
   import logic.ShopLogic;
   import model.CommonEvent;
   import proto.model.PCost;
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class PricePanel extends VComponent
   {
      
      public static const GLOW_FILTER:uint = 1;
      
      public static const GLOW_B_FILTER:uint = GLOW_FILTER | 2;
      
      public static const VERTICAL:uint = 4;
      
      public static const NEGATIVE:uint = 8;
      
      public static const SHORT:uint = 16;
      
      public static const CLAN:uint = 32;
      
      public static const IGNORE_CAPITAL:uint = 64;
      
      public static const TWEEN:uint = 128;
      
      public static const ZERO_VISIBLE:uint = 256;
      
      public const skin:VSkin = new VSkin();
      
      public const text:VText = new VText(null);
      
      public var useCheck:Boolean;
      
      private var premiumText:VText;
      
      private var premiumArrow:VSkin;
      
      private var tween:Tween;
      
      private var variance:uint;
      
      private var value:uint;
      
      private var checkState:uint = 2;
      
      private var isListener:Boolean;
      
      private var gap:uint;
      
      private var speedupMin:uint;
      
      private var speedupVariance:uint;
      
      public function PricePanel(param1:uint, param2:uint, param3:uint = 0, param4:uint = 2, param5:uint = 0)
      {
         super();
         mouseChildren = mouseEnabled = false;
         this.gap = param4;
         this.text.maxW = param5;
         this.text.format.fontSize = param2;
         this.skin.maxW = this.skin.layoutH = param1;
         addChild(this.skin);
         addChild(this.text);
         if((param3 & VERTICAL) == 0)
         {
            this.skin.vCenter = 0;
            this.text.setMode(VText.CONTAIN);
            this.text.vCenter = 2;
         }
         else
         {
            this.skin.hCenter = 0;
            this.text.setMode(VText.CONTAIN_CENTER);
            this.text.layoutW = -100;
            this.text.bottom = 0;
         }
         this.mode = param3;
      }
      
      private function changeCheck(param1:CommonEvent = null) : void
      {
         this.setCheckState(!param1 && !this.useCheck ? true : this.getCheck(),Boolean(param1));
      }
      
      public function setCheckState(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:uint = param1 ? 1 : 0;
         if(this.checkState != _loc3_)
         {
            this.checkState = _loc3_;
            if((mode & GLOW_FILTER) != 0)
            {
               Style.applyDefaultFilter(this.text,this.text.format.fontSize,param1 ? ((mode & 2) != 0 ? Style.brownGlowRGB : Style.grayGlowRGB) : 16777215);
            }
            this.text.format.color = param1 ? Style.yellowRGB : Style.redRGB;
            this.text.syncFormat(param2);
         }
      }
      
      public function getCheck() : Boolean
      {
         return Facade.userProxy.checkCost(this.variance,this.value) == 0;
      }
      
      public function assign(param1:uint, param2:uint) : void
      {
         if(param1 != this.variance)
         {
            this.setListener(false);
         }
         this.variance = param1;
         SkinManager.applyEmbed(this.skin,CostHelper.getKind(param1,(mode & CLAN) != 0 || Facade.isCapital && (mode & IGNORE_CAPITAL) == 0));
         this.value = param2 + 1;
         this.setValue(param2);
         if(this.useCheck)
         {
            this.setListener(true);
         }
         if((mode & ZERO_VISIBLE) != 0)
         {
            this.text.visible = param2 != 0;
            this.skin.filters = param2 == 0 ? VSkin.GREY_FILTER : null;
            this.skin.alpha = param2 == 0 ? 0.5 : 1;
         }
      }
      
      public function assignCost(param1:PCost) : void
      {
         this.assign(param1.variance,param1.value);
      }
      
      public function set innerValue(param1:uint) : void
      {
         this.changeCheck();
         this.text.value = this.getValueString(param1);
         if(this.premiumText)
         {
            this.premiumText.value = "+" + this.getValueString(param1 * 0.25);
         }
      }
      
      private function getValueString(param1:uint) : String
      {
         if((mode & SHORT) == 0)
         {
            return StringHelper.getCurrencyValue(param1,true,(mode & NEGATIVE) != 0);
         }
         return ((mode & NEGATIVE) != 0 && param1 > 0 ? "-" : "") + (param1 >= 1000000 ? param1 / 1000000 + "m" : (param1 >= 1000 ? param1 / 1000 + "k" : param1));
      }
      
      public function get innerValue() : uint
      {
         return this.value;
      }
      
      public function setAdditionalMode(param1:Boolean, param2:Boolean = true) : void
      {
         if(this.variance == PCost.BLUE_PRINT || this.variance == PCost.GOLD || this.variance == PCost.CLAN_POINTS)
         {
            return;
         }
         if(param1 != Boolean(this.premiumArrow))
         {
            if(param1)
            {
               this.premiumArrow = SkinManager.getEmbed("PremiumArrowIcon");
               if(param2)
               {
                  add(this.premiumArrow,{
                     "w":18,
                     "left":26,
                     "bottom":0
                  });
                  this.text.vCenter = EMPTY;
                  this.text.top = 0;
                  this.premiumText = new VText(null,VText.CONTAIN,Style.greenRGB,16);
                  add(this.premiumText,{
                     "bottom":0,
                     "hCenter":22
                  });
                  this.innerValue = this.value;
               }
               else
               {
                  add(this.premiumArrow,{
                     "w":10,
                     "left":16,
                     "bottom":0
                  });
                  this.setValue(Math.ceil(this.value * 1.25));
                  this.text.format.color = Style.lightGreenRGB;
                  this.text.syncFormat(true);
               }
            }
            else
            {
               remove(this.premiumArrow);
               this.premiumArrow = null;
               if(param2)
               {
                  this.text.top = EMPTY;
                  this.text.vCenter = 2;
                  remove(this.premiumText);
                  this.premiumText = null;
               }
               else
               {
                  this.setValue(this.value * 0.8);
                  this.text.format.color = Style.yellowRGB;
                  this.text.syncFormat(true);
               }
            }
         }
      }
      
      public function setValue(param1:uint) : void
      {
         if((mode & TWEEN) != 0)
         {
            if(this.tween)
            {
               this.tween.propertyList[2] = param1;
            }
            else
            {
               this.tween = new Tween(this);
               this.tween.play(["innerValue",0,param1],1.2);
            }
         }
         if(this.value != param1)
         {
            this.value = param1;
            this.innerValue = param1;
         }
      }
      
      public function getValue() : uint
      {
         return this.value;
      }
      
      private function setListener(param1:Boolean) : void
      {
         var _loc2_:String = null;
         if(param1 != this.isListener)
         {
            _loc2_ = CostHelper.getEventType(this.variance);
            if(_loc2_)
            {
               this.isListener = param1;
               if(param1)
               {
                  Facade.addListener(_loc2_,this.changeCheck);
               }
               else
               {
                  Facade.removeListener(_loc2_,this.changeCheck);
               }
            }
         }
      }
      
      override public function dispose() : void
      {
         if(this.tween)
         {
            this.tween.stop();
         }
         this.setListener(false);
         Signal.stopRef(this);
         super.dispose();
      }
      
      override protected function calcContentSize() : void
      {
         if(!this.text.parent)
         {
            super.calcContentSize();
         }
         else if((mode & VERTICAL) == 0)
         {
            contentW = this.skin.measuredWidth + this.text.measuredWidth + this.gap;
            contentH = this.skin.measuredHeight > this.text.measuredHeight ? this.skin.measuredHeight : this.text.measuredHeight;
         }
         else
         {
            contentW = this.skin.measuredWidth > this.text.measuredWidth ? this.skin.measuredWidth : this.text.measuredWidth;
            contentH = this.skin.measuredHeight + this.text.measuredHeight - this.gap;
         }
      }
      
      public function runTrackSpeedup(param1:Number, param2:Number = 0, param3:uint = 0, param4:uint = 0) : void
      {
         var _loc5_:PCost = ShopLogic.getSpeedupCost(param2 > 0 ? Math.ceil(param1 / param2) * param2 : param1,param3,param4);
         if(_loc5_.value > param3)
         {
            Signal.createRef(this,this.onSpeedupSignal,param2 > 0 ? Signal.ADD_PERIOD : 0,param2 > 0 ? param2 : 5).run(param1);
         }
         this.speedupMin = param3;
         this.speedupVariance = param4;
         this.assignCost(_loc5_);
      }
      
      public function stopTrackSpeedup() : void
      {
         Signal.stopRef(this);
      }
      
      private function onSpeedupSignal(param1:Signal) : void
      {
         var _loc2_:uint = ShopLogic.getSpeedupGold(param1.tail,this.speedupMin,this.speedupVariance);
         if(_loc2_ == this.speedupMin)
         {
            this.stopTrackSpeedup();
         }
         this.setValue(_loc2_);
      }
      
      public function assignTime(param1:Number) : void
      {
         this.setListener(false);
         this.variance = uint.MAX_VALUE;
         SkinManager.applyEmbed(this.skin,"ClockIcon");
         this.useCheck = false;
         this.changeCheck();
         this.text.value = StringHelper.getTimeDesc(param1);
      }
      
      override public function updatePhase(param1:Boolean = false) : void
      {
         if((mode & VERTICAL) == 0 && Boolean(this.text.parent))
         {
            this.text.maxW = this.skin.measuredWidth + this.gap;
            this.text.maxW = this.text.maxW >= w ? 1 : uint(w - this.text.maxW);
            super.customUpdate();
            this.text.maxW = 0;
            this.skin.x = Math.round((w - (this.skin.w + this.gap + this.text.w)) / 2);
            this.text.x = this.skin.x + this.skin.w + this.gap;
         }
         else
         {
            super.updatePhase(param1);
         }
      }
   }
}

