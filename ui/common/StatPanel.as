package ui.common
{
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class StatPanel extends VBox
   {
      
      public static const GREY_TEXT:uint = 1;
      
      public static const YELLOW_TEXT:uint = 2;
      
      public static const YELLOW_B_TEXT:uint = 4;
      
      public static const VERTICAL:uint = 8;
      
      public static const RED_TEXT:uint = 16;
      
      public const text:VText = new VText(null,VText.CONTAIN_CENTER);
      
      public var cacheValue:int = 2147483647;
      
      public var icon:VSkin;
      
      private var premiumArrow:VSkin;
      
      private var premiumBox:VBox;
      
      private var premiumText:VText;
      
      public function StatPanel(param1:VSkin, param2:Object = null, param3:uint = 0, param4:uint = 3, param5:uint = 30, param6:uint = 18)
      {
         super(new <VComponent>[param1,this.text],param4,(param3 & VERTICAL) != 0 ? VBox.VERTICAL : 0);
         this.text.layoutW = -100;
         this.icon = param1;
         param1.layoutH = param5;
         if(param2 != null)
         {
            this.cacheValue = param2 as int;
            this.text.value = String(param2);
         }
         if((param3 & YELLOW_TEXT) != 0)
         {
            Style.applyDefaultFormat(this.text,param6);
         }
         else if((param3 & YELLOW_B_TEXT) != 0)
         {
            Style.applyDefaultFormat(this.text,param6,true);
         }
         else if((param3 & GREY_TEXT) != 0)
         {
            Style.applyGlowFormat(this.text,param6,10065554,2959400);
         }
         else if((param3 & RED_TEXT) != 0)
         {
            this.text.setBaseFormat(param6,Style.redRGB);
         }
         else
         {
            this.text.setBaseFormat(param6,Style.metalRGB);
         }
      }
      
      public function setAdditionalMode(param1:Boolean, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         if(param1 != Boolean(this.premiumArrow))
         {
            if(param1)
            {
               this.premiumArrow = SkinManager.getEmbed("PremiumArrowIcon");
               remove(this.text,false);
               list[0].add(this.premiumArrow,{
                  "w":18,
                  "right":-5,
                  "bottom":0
               });
               this.premiumText = new VText(null,VText.CONTAIN_CENTER,Style.greenRGB,16);
               this.premiumBox = new VBox(new <VComponent>[this.text,this.premiumText],2,VBox.VERTICAL);
               if(!param2 && this.cacheValue != int.MAX_VALUE)
               {
                  this.cacheValue /= 2;
                  this.text.value = String(this.cacheValue);
               }
               _loc3_ = this.cacheValue == int.MAX_VALUE ? 0 : this.cacheValue;
               this.premiumText.value = "+" + (_loc3_ < 1000 ? _loc3_.toString() : StringHelper.getCurrencyValue(_loc3_));
               add(this.premiumBox);
            }
            else
            {
               this.text.top = EMPTY;
               this.text.vCenter = 2;
               this.premiumArrow.removeFromParent();
               this.premiumArrow = null;
               this.premiumBox.remove(this.text,false);
               remove(this.premiumBox);
               add(this.text);
            }
         }
      }
      
      public function set value(param1:int) : void
      {
         if(param1 != this.cacheValue)
         {
            this.cacheValue = param1;
            this.text.value = param1 < 1000 ? param1.toString() : StringHelper.getCurrencyValue(param1);
            if(this.premiumArrow)
            {
               this.premiumText.value = "+" + (param1 < 1000 ? param1.toString() : StringHelper.getCurrencyValue(param1));
            }
         }
      }
      
      public function useBg() : StatPanel
      {
         var _loc1_:VSkin = SkinManager.getEmbed("StatBg",VSkin.STRETCH_BG);
         _loc1_.useRuledLayout();
         _loc1_.assignLayout({
            "left":list[0].measuredWidth >> 1,
            "right":-8,
            "vCenter":0
         });
         addChildAt(_loc1_,0);
         return this;
      }
   }
}

