package ui.game
{
   import engine.signal.Tween;
   import model.CommonEvent;
   import proto.model.PCost;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VProgressBar;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class ResourcePanel extends VComponent
   {
      
      public static const PROGRESS:uint = 1;
      
      public static const TWEEN:uint = 2;
      
      public static const BG:uint = 4;
      
      public static const FLIP:uint = 8;
      
      public static const SKIP_ICON:uint = 16;
      
      public static const SKIP_HINT:uint = 32;
      
      public static const COMPARE:uint = 64;
      
      public static const CLAN:uint = 128;
      
      public static const CACHE_AS_BITMAP:uint = 256;
      
      public static const CACHE_ICON:uint = 512;
      
      private const curText:VText;
      
      public var buyBt:VButton;
      
      private var premiumArrow:VSkin;
      
      private var tween:Tween;
      
      private var variance:int = -1;
      
      private var pb:VProgressBar;
      
      private var last:int;
      
      private var max:uint;
      
      public function ResourcePanel(param1:*, param2:uint = 0, param3:String = null, param4:int = 42, param5:int = 40, param6:uint = 19)
      {
         var _loc9_:VSkin = null;
         this.curText = new VText(null,VText.CONTAIN_CENTER);
         super();
         setSize(163,39);
         this.mode = param2;
         var _loc7_:Boolean = (param2 & SKIP_ICON) == 0;
         if(param1 is uint)
         {
            this.variance = param1;
            if(_loc7_)
            {
               param1 = SkinManager.getEmbed(CostHelper.getKind(this.variance,(param2 & CLAN) != 0),(param2 & CACHE_ICON) != 0 ? VSkin.CACHE_AS_BITMAP : 0);
            }
         }
         if(param1 is String)
         {
            param1 = SkinManager.getEmbed(param1,(param2 & CACHE_ICON) != 0 ? VSkin.CACHE_AS_BITMAP : 0);
         }
         if(!param1)
         {
            _loc7_ = false;
         }
         var _loc8_:Boolean = (param2 & FLIP) != 0;
         if((param2 & BG) != 0)
         {
            add(SkinManager.getEmbed("ResBg",VSkin.STRETCH),this.getInnerLayout({"hP":100},_loc7_ ? 17 : 0,0,_loc8_));
         }
         if((param2 & PROGRESS) != 0)
         {
            if(!param3)
            {
               if(this.variance == PCost.CRYSTAL || this.variance == PCost.CALL)
               {
                  param3 = UIFactory.INDICATOR_BLUE;
               }
               else if(this.variance == PCost.OIL)
               {
                  param3 = UIFactory.INDICATOR_PURPLE;
               }
               else if(this.variance == PCost.TROPHY)
               {
                  param3 = UIFactory.INDICATOR_YELLOW;
               }
               else
               {
                  param3 = UIFactory.INDICATOR_GREEN;
               }
            }
            _loc9_ = SkinManager.getEmbed(param3,VSkin.STRETCH);
            _loc9_.stretch();
            this.pb = new VProgressBar();
            this.pb.mouseEnabled = false;
            this.pb.init(_loc9_);
            this.pb.isFlip = _loc8_;
            add(this.pb,this.getInnerLayout({
               "top":6,
               "bottom":7
            },param4 - 6,5,_loc8_));
         }
         else if(this.variance >= 0 && (param2 & SKIP_HINT) == 0)
         {
            this.hint = this.getCostHint();
         }
         add(SkinManager.getEmbed("ResFg",VSkin.STRETCH | VSkin.DRAW_FILL),this.getInnerLayout({"hP":100},_loc7_ ? 17 : 0,0,_loc8_));
         if(_loc7_)
         {
            add(SkinManager.getEmbed("FeatureIconBg",VSkin.STRETCH),this.getInnerLayout({
               "w":param4 - 2,
               "hP":100
            },0,VComponent.EMPTY,_loc8_));
            add(param1,this.getInnerLayout({
               "bottom":2,
               "w":param4,
               "h":param5
            },-2,VComponent.EMPTY,_loc8_));
         }
         Style.applyDefaultFormat(this.curText,param6,true);
         this.last = 1;
         this.cur = 0;
         add(this.curText,this.getInnerLayout({"vCenter":0},param4 - 1,8,_loc8_));
         if((param2 & TWEEN) != 0)
         {
            this.tween = new Tween(this);
            this.tween.propertyList = ["cur",0,0];
            this.tween.stopHandler = this.onTweenKill;
            this.tween.duration = 1.2;
         }
         if((param2 & CACHE_AS_BITMAP) != 0)
         {
            cacheAsBitmap = true;
         }
      }
      
      private function getInnerLayout(param1:Object, param2:int, param3:int, param4:Boolean) : Object
      {
         if(param3 != VComponent.EMPTY)
         {
            if(param4)
            {
               param1.left = param3;
            }
            else
            {
               param1.right = param3;
            }
         }
         if(param2 != VComponent.EMPTY)
         {
            if(param4)
            {
               param1.right = param2;
            }
            else
            {
               param1.left = param2;
            }
         }
         return param1;
      }
      
      public function getCostHint() : String
      {
         var _loc1_:String = CostHelper.getKind(this.variance);
         return "<p" + Style.metalColor + ">" + StringHelper.getTLFImage("lib," + CostHelper.getKind(this.variance,(mode & CLAN) != 0),20) + Lang.getString(_loc1_) + "</p><p>" + Lang.getString(_loc1_ + "_desc") + "</p>" + (this.premiumArrow ? "<p" + Style.greenColor + ">" + StringHelper.getTLFImage("lib,PremiumArrowIcon",20) + Lang.getString("scout_mine_hint") + "</p><p" + Style.greenColor + ">" + StringHelper.getTLFImage("lib,PremiumArrowIcon",20) + Lang.getString("scout_res_victory_hint") + "</p>" : "");
      }
      
      public function setData(param1:int) : void
      {
         if(this.tween)
         {
            this.tween.propertyList[2] = param1;
            if(this.last == param1)
            {
               this.tween.stop();
            }
            else
            {
               if((mode & CACHE_AS_BITMAP) != 0)
               {
                  cacheAsBitmap = false;
               }
               this.tween.propertyList[1] = this.last;
               this.tween.repeat();
            }
         }
         else
         {
            this.cur = param1;
         }
      }
      
      public function set cur(param1:int) : void
      {
         if(this.last != param1)
         {
            this.last = param1;
            this.curText.value = (mode & COMPARE) != 0 ? this.last + "/" + this.max : StringHelper.getCurrencyValue(this.last);
            this.syncPb();
         }
      }
      
      public function get cur() : int
      {
         return this.last;
      }
      
      private function syncPb() : void
      {
         if(this.pb)
         {
            this.pb.value = this.max > 0 ? this.last / this.max : 0;
         }
      }
      
      private function onTweenKill(param1:Tween) : void
      {
         this.cur = param1.propertyList[2];
         if((mode & CACHE_AS_BITMAP) != 0)
         {
            cacheAsBitmap = true;
         }
      }
      
      public function setMax(param1:uint, param2:Boolean = false, param3:Boolean = true) : void
      {
         this.max = param1;
         this.syncPb();
         if(param2)
         {
            this.setData(param1);
         }
         if(param3)
         {
            hint = this.getCostHint();
            if(param1 > 0)
            {
               hint += this.getCapacityHint();
            }
         }
      }
      
      private function getCapacityHint() : String
      {
         return "<p" + Style.metalColor + ">" + Lang.getPatternString(this.variance == PCost.CRYSTAL || this.variance == PCost.OIL ? "cost_storage" : (this.variance == PCost.CALL ? "energy_max" : "cost_max"),"__VALUE__",this.max.toString()) + "</p>";
      }
      
      public function setDataEx(param1:int, param2:uint) : void
      {
         if(this.max != param2)
         {
            this.max = param2;
            this.syncPb();
            if((mode & COMPARE) != 0 && param1 == this.last)
            {
               ++this.last;
            }
         }
         this.setData(param1);
      }
      
      public function setCustom(param1:String) : void
      {
         this.curText.value = param1;
      }
      
      override public function dispose() : void
      {
         if(this.tween)
         {
            this.tween.stopHandler = null;
            this.tween.stop();
            this.tween = null;
         }
         super.dispose();
      }
      
      public function addBuyBt(param1:Function = null, param2:String = null, param3:Object = null) : void
      {
         if(this.buyBt)
         {
            remove(this.buyBt);
         }
         this.buyBt = VButton.createEmbed("PlusBt");
         this.buyBt.hint = param2;
         if(param1 != null)
         {
            this.buyBt.addClickListener(param1,param3);
         }
         add(this.buyBt,{
            "right":4,
            "vCenter":-1
         });
         this.useBuyBtLayout(true);
      }
      
      public function useBuyBtLayout(param1:Boolean) : void
      {
         this.curText.right = param1 ? 31 : 8;
         this.curText.syncLayout();
         if(this.pb)
         {
            this.pb.right = param1 ? 26 : 5;
            this.pb.syncLayout();
         }
      }
      
      public function removeBuyBt() : void
      {
         if(this.buyBt)
         {
            remove(this.buyBt);
            this.buyBt = null;
            this.useBuyBtLayout(false);
         }
      }
      
      public function useTrack(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.cur = Facade.userProxy.getCostCur(this.variance);
         }
         var _loc2_:String = CostHelper.getEventType(this.variance);
         if(_loc2_)
         {
            addListener(_loc2_,this.onTrack,Facade.instance);
         }
      }
      
      public function onTrack(param1:CommonEvent) : void
      {
         if(param1.variance == this.variance)
         {
            this.setData(param1.data);
         }
      }
      
      public function removeTrack() : void
      {
         var _loc1_:String = CostHelper.getEventType(this.variance);
         if(_loc1_)
         {
            removeListener(_loc1_,this.onTrack,Facade.instance);
         }
      }
      
      public function addHeader(param1:String, param2:int = 40, param3:int = 20) : void
      {
         var _loc4_:VSkin = SkinManager.getEmbed("ResHeaderBg",VSkin.STRETCH);
         _loc4_.alpha = 0.5;
         add(_loc4_,{
            "left":param2,
            "right":param3,
            "top":-18,
            "h":18
         },0);
         add(new VText(param1,VText.CONTAIN_CENTER,Style.metalRGB,14),{
            "left":param2 + 4,
            "right":param3 + 4,
            "top":-15
         },1);
      }
      
      public function changeClanMode(param1:Boolean) : void
      {
         if(param1)
         {
            mode |= CLAN;
         }
         else
         {
            mode &= ~CLAN;
         }
         if(this.variance >= 0 && (mode & SKIP_ICON) == 0)
         {
            SkinManager.applyEmbed(getChildAt(getChildIndex(this.curText) - 1) as VSkin,CostHelper.getKind(this.variance,param1));
         }
      }
      
      public function setPremiumArrow(param1:Boolean) : void
      {
         if(param1 != Boolean(this.premiumArrow))
         {
            if(param1)
            {
               this.premiumArrow = SkinManager.getEmbed("PremiumArrowIcon");
               add(this.premiumArrow,{
                  "w":18,
                  "left":26,
                  "bottom":0
               });
            }
            else
            {
               remove(this.premiumArrow);
               this.premiumArrow = null;
            }
            if(this.variance > 0)
            {
               hint = this.getCostHint();
               if(this.max > 0)
               {
                  hint += this.getCapacityHint();
               }
            }
         }
      }
   }
}

