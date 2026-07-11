package ui.common
{
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class RectButton extends VButton
   {
      
      public static const RED:String = "BtRectRed";
      
      public static const GREEN:String = "BtRectGreen";
      
      public static const ORANGE:String = "BtRectOrange";
      
      public static const YELLOW:String = "BtRectYellow";
      
      public static const H56:String = "56";
      
      public static const H42:String = "42";
      
      public static const H30:String = "30";
      
      public function RectButton(param1:Object, param2:Function = null, param3:String = "BtRectGreen")
      {
         super();
         if(param2 != null)
         {
            if(param3 != RED)
            {
               if(param2 == h56)
               {
                  param3 += H56;
               }
               else if(param2 == h30)
               {
                  param3 += H30;
               }
               else if(param2 == h42)
               {
                  param3 += H42;
               }
            }
         }
         skin = SkinManager.getEmbed(param3,VSkin.STRETCH);
         addStretch(skin);
         if(param1 is String)
         {
            setIcon(new VText(param1 as String,VText.CONTAIN_CENTER,Style.yellowRGB));
         }
         else
         {
            setIcon(param1 as VComponent);
         }
         if(param2 != null)
         {
            param2(this);
         }
         else
         {
            icon.useCenter();
         }
      }
      
      public static function h56(param1:RectButton) : void
      {
         param1.hCustom(56,14,150,18,-2);
      }
      
      public static function h42(param1:RectButton) : void
      {
         param1.hCustom(42,10,100,16,-1);
      }
      
      public static function h30(param1:RectButton) : void
      {
         param1.hCustom(30,8,80,13,0);
      }
      
      public static function createIconAndTitle(param1:VComponent, param2:String, param3:uint = 18, param4:String = "BtRectGreen", param5:int = 0, param6:uint = 5, param7:Function = null) : RectButton
      {
         var _loc11_:int = 0;
         var _loc8_:VText = UIFactory.createYellowText(param2,VText.CONTAIN,param3);
         var _loc9_:VBox = new VBox(new <VComponent>[param1,_loc8_],param6,VBox.CENTER);
         var _loc10_:RectButton = new RectButton(_loc9_,param7 != null ? param7 : h56,param4);
         _loc9_.left -= 4;
         param1.maxW = param1.layoutH = _loc10_.layoutH;
         if(param5 > 0)
         {
            _loc11_ = int(param1.measuredWidth);
            param5 -= param6 + (_loc11_ > 0 ? _loc11_ : param1.layoutH) + _loc9_.hPadding;
            _loc8_.maxW = param5 > 0 ? uint(param5) : 1;
         }
         return _loc10_;
      }
      
      public static function createIconAndTitle42(param1:VComponent, param2:String, param3:int = 0, param4:String = "BtRectGreen", param5:uint = 5) : RectButton
      {
         return createIconAndTitle(param1,param2,16,param4,param3,param5,h42);
      }
      
      public static function createIconAndTitle30(param1:VComponent, param2:String, param3:int = 0, param4:String = "BtRectGreen", param5:uint = 3) : RectButton
      {
         return createIconAndTitle(param1,param2,13,param4,param3,param5,h30);
      }
      
      public function set title(param1:String) : void
      {
         if(icon is VText)
         {
            (icon as VText).value = param1;
         }
      }
      
      override protected function calcContentSize() : void
      {
         contentW = icon.measuredWidth + icon.hPadding;
         contentH = icon.measuredHeight + 6;
      }
      
      public function hCustom(param1:uint, param2:uint, param3:uint, param4:uint, param5:int) : void
      {
         icon.left = icon.right = param2;
         this.minW = param3;
         layoutH = param1;
         icon.vCenter = param5;
         if(icon is VText)
         {
            (icon as VText).format.fontSize = param4;
            Style.applyDefaultFilter(icon,param4);
         }
      }
   }
}

