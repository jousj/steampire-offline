package ui.common
{
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class LevelPanel extends VComponent
   {
      
      public const text:VText = new VText(null,VText.CONTAIN_CENTER);
      
      private const bg:VSkin = SkinManager.getEmbed("Exp",VSkin.STRETCH);
      
      private var level:uint;
      
      private var sNetwork:String;
      
      public function LevelPanel(param1:Function = null, param2:uint = 0)
      {
         super();
         mouseChildren = false;
         addStretch(this.bg);
         this.text.vCenter = 2;
         Style.applyShadowFilter(this.text,16703556,3415810,2,90);
         addChild(this.text);
         if(param1 != null)
         {
            param1(this);
         }
         if(param2 > 0)
         {
            this.value = param2;
         }
      }
      
      public static function size28(param1:LevelPanel) : void
      {
         param1.setCustomSize(28,28,18,5,4);
      }
      
      public static function size34(param1:LevelPanel) : void
      {
         param1.setCustomSize(34,34,18,7,6);
      }
      
      public static function size42(param1:LevelPanel) : void
      {
         param1.setCustomSize(42,42,20,7,6);
      }
      
      public static function size48(param1:LevelPanel) : void
      {
         param1.setCustomSize(48,48,24,9,8);
      }
      
      public function set value(param1:uint) : void
      {
         if(param1 != this.level)
         {
            this.level = param1;
            this.text.value = param1.toString();
         }
      }
      
      public function get value() : uint
      {
         return this.level;
      }
      
      public function reset() : void
      {
         if(this.level > 0)
         {
            this.level = 0;
            this.text.value = null;
         }
      }
      
      public function changeSNetwork(param1:String) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(Boolean(param1 && param1 != "vk" && param1 != "ok" && param1 != "mm" && param1 != "gc") && Boolean(param1 != "gp") && param1 != "fb")
         {
            param1 = null;
         }
         if(param1 != this.sNetwork)
         {
            _loc2_ = uint.MAX_VALUE;
            _loc3_ = uint.MAX_VALUE;
            if(param1 == "vk")
            {
               _loc2_ = 16777215;
               _loc3_ = 1327718;
            }
            else if(param1 == "ok")
            {
               _loc2_ = 16777215;
               _loc3_ = 9308672;
            }
            else if(param1 == "mm")
            {
               _loc2_ = 16766208;
               _loc3_ = 78435;
            }
            else if(param1 == "fb")
            {
               _loc2_ = 16777215;
               _loc3_ = 1643834;
            }
            else if(param1 == "gc")
            {
               _loc2_ = 16777215;
               _loc3_ = 2697513;
            }
            else if(param1 == "gp")
            {
               _loc2_ = 16777215;
               _loc3_ = 1390619;
            }
            else if(!param1)
            {
               _loc2_ = 12331042;
               Style.applyShadowFilter(this.text,16703556,3415810,2,90);
            }
            else if(!this.sNetwork)
            {
               _loc2_ = 3487827;
               _loc3_ = 16777215;
            }
            if(_loc2_ != uint.MAX_VALUE)
            {
               this.text.format.color = _loc2_;
               this.text.syncFormat();
               this.level = 0;
            }
            if(_loc3_ != uint.MAX_VALUE)
            {
               Style.applyGlowFilter(this.text,_loc3_,8);
            }
            this.sNetwork = param1;
            SkinManager.applyEmbed(this.bg,param1 ? "Exp_" + param1 : "Exp");
         }
      }
      
      public function setCustomSize(param1:int, param2:int, param3:uint, param4:int, param5:int) : void
      {
         setSize(param1,param2);
         this.text.left = param4;
         this.text.right = param5;
         this.text.setBaseFormat(param3,12331042);
      }
   }
}

