package ui
{
   import flash.display.DisplayObject;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import ui.vbase.VText;
   
   public class Style
   {
      
      public static const SELECT_FILTER:GlowFilter = new GlowFilter(16776960,1,4,4,8);
      
      public static const CHOICE_OUT_FILTER:GlowFilter = new GlowFilter(3656659,1,4,4,4);
      
      public static const CONFLICT_FILTER:GlowFilter = new GlowFilter(16711680,1,4,4,4);
      
      public static const CHOICE_FILTER:GlowFilter = new GlowFilter(3656694,1,4,4,8);
      
      public static const brownGlowRGB:uint = 3146242;
      
      public static const grayGlowRGB:uint = 3684408;
      
      public static const yellowRGB:uint = 15917721;
      
      public static const anthraciteRGB:uint = 2634037;
      
      public static const redRGB:uint = 8532492;
      
      public static const bgRGB:uint = 9220030;
      
      public static const metalRGB:uint = 4018009;
      
      public static const greenRGB:uint = 1072915;
      
      public static const lightGreenRGB:uint = 11663737;
      
      public static const darkKhakiRGB:uint = 7361073;
      
      public static const brownColor:String = " color=\"#" + brownGlowRGB.toString(16) + "\"";
      
      public static const redColor:String = " color=\"#" + redRGB.toString(16) + "\"";
      
      public static const darkKhakiColor:String = " color=\"#" + darkKhakiRGB.toString(16) + "\"";
      
      public static const greenColor:String = " color=\"#" + greenRGB.toString(16) + "\"";
      
      public static const yellowColor:String = " color=\"#" + yellowRGB.toString(16) + "\"";
      
      public static const anthraciteColor:String = " color=\"#" + anthraciteRGB.toString(16) + "\"";
      
      public static const metalColor:String = " color=\"#" + metalRGB.toString(16) + "\"";
      
      public static const hint:String = darkKhakiColor + " fontSize=\"14\"";
      
      public static const myriadFont:String = " fontFamily=\"Myriad Pro\"";
      
      public function Style()
      {
         super();
      }
      
      public static function applyGlowFormat(param1:VText, param2:uint, param3:uint, param4:uint) : void
      {
         param1.setBaseFormat(param2,param3);
         param1.filters = [new GlowFilter(param4,1,2,2,6)];
      }
      
      public static function applyDefaultFormat(param1:VText, param2:uint, param3:Boolean = false) : void
      {
         applyGlowFormat(param1,param2,yellowRGB,param3 ? brownGlowRGB : grayGlowRGB);
      }
      
      public static function applyDefaultFilter(param1:DisplayObject, param2:uint = 18, param3:uint = 3684408) : void
      {
         param1.filters = [new GlowFilter(param3,1,2,2,6)];
      }
      
      public static function applyGlowFilter(param1:DisplayObject, param2:uint, param3:uint) : void
      {
         param1.filters = [new GlowFilter(param2,1,2,2,param3)];
      }
      
      public static function applyShadowFilter(param1:DisplayObject, param2:uint = 3684408, param3:uint = 8020005, param4:Number = 1, param5:Number = 180) : void
      {
         param1.filters = [new DropShadowFilter(param4,param5,param3,1,0,0,1,1,true),new GlowFilter(param2,1,2,2,4)];
      }
   }
}

