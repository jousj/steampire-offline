package ui.common
{
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class CircleButton extends VButton
   {
      
      public static const TEAL:String = "BtTeal";
      
      public static const GOLD:String = "BtGold";
      
      public static const ORANGE:String = "BtOrange";
      
      public function CircleButton(param1:VComponent, param2:String, param3:Function = null)
      {
         super();
         skin = SkinManager.getEmbed(param2,VSkin.STRETCH);
         addStretch(skin);
         if(param1)
         {
            this.icon = param1;
            addChild(param1);
            param1.useCenter();
         }
         if(param3 != null)
         {
            param3(this);
         }
      }
      
      public static function create(param1:VComponent, param2:String, param3:Function, param4:Object = null, param5:Function = null) : CircleButton
      {
         var _loc6_:CircleButton = new CircleButton(param1,param2,param5);
         _loc6_.addClickListener(param3,param4);
         return _loc6_;
      }
      
      public static function size70(param1:CircleButton) : void
      {
         param1.setSize(70,70);
         if(param1.icon)
         {
            param1.icon.setSize(40,40);
         }
      }
      
      public static function size42(param1:CircleButton) : void
      {
         param1.setSize(42,42);
         if(param1.icon)
         {
            param1.icon.setSize(26,26);
         }
      }
      
      public static function size30(param1:CircleButton) : void
      {
         param1.setSize(30,30);
         if(param1.icon)
         {
            param1.icon.setSize(16,16);
         }
      }
      
      public static function sizeMenu74(param1:CircleButton) : void
      {
         param1.setSize(74,74);
         if(param1.icon)
         {
            param1.icon.setSize(50,50);
         }
      }
      
      public static function sizeStatus50(param1:CircleButton) : void
      {
         param1.setSize(50,50);
         if(param1.icon)
         {
            param1.icon.setSize(34,34);
         }
         param1.cacheAsBitmap = true;
      }
      
      public function changeSkin(param1:String) : void
      {
         SkinManager.applyEmbed(skin as VSkin,param1);
      }
      
      public function applyText(param1:String, param2:uint, param3:int) : void
      {
         var _loc4_:VText = UIFactory.createYellowText(param1,0,param2);
         _loc4_.useCenter(0,param3);
         setIcon(_loc4_);
      }
      
      public function sizeCustom(param1:uint, param2:uint = 0) : void
      {
         setSize(param1,param1);
         if(param2 > 0)
         {
            icon.setSize(param2,param2);
         }
      }
   }
}

