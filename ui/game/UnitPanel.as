package ui.game
{
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class UnitPanel extends VComponent
   {
      
      public static const ORANGE_BG:uint = 1;
      
      public static const GREEN_FG:uint = 2;
      
      public static const METAL_FG:uint = 4;
      
      public static const USE_PRICE_BG:uint = 8;
      
      public static const USE_COUNT_TEXT:uint = 16;
      
      public static const SKIP_BG:uint = 32;
      
      public static const BARRACK_MODE:uint = ORANGE_BG | METAL_FG | USE_PRICE_BG;
      
      public static const FEATURE_MODE:uint = ORANGE_BG | METAL_FG;
      
      private var avatar:VComponent;
      
      public const avatarContainer:VComponent;
      
      public var priceSkin:VSkin;
      
      public var countText:VText;
      
      public function UnitPanel(param1:uint = 0, param2:Function = null)
      {
         var _loc3_:String = null;
         this.avatarContainer = new VComponent();
         super();
         mouseChildren = false;
         if((param1 & SKIP_BG) == 0)
         {
            add(SkinManager.getEmbed((param1 & ORANGE_BG) != 0 ? "TrainBg" : "SoldierBg",VSkin.STRETCH),{
               "wP":86,
               "hP":86,
               "hCenter":0,
               "vCenter":0
            });
         }
         if((param1 & GREEN_FG) != 0)
         {
            _loc3_ = "ASoldierFg";
         }
         else if((param1 & METAL_FG) != 0)
         {
            _loc3_ = "TrainFg";
         }
         else
         {
            _loc3_ = "SoldierFg";
         }
         addStretch(SkinManager.getEmbed(_loc3_,VSkin.STRETCH));
         addChild(this.avatarContainer);
         if((param1 & USE_PRICE_BG) != 0)
         {
            this.priceSkin = SkinManager.getEmbed("TrainPriceBg");
            addChild(this.priceSkin);
         }
         if((param1 & USE_COUNT_TEXT) != 0)
         {
            this.countText = new VText(null,VText.CENTER);
            addChild(this.countText);
         }
         if(param2 != null)
         {
            param2(this);
         }
      }
      
      private static function getSoldierLayout(param1:uint) : Object
      {
         var _loc2_:Number = param1 / 160;
         return {
            "w":uint(_loc2_ * 170),
            "h":uint(_loc2_ * 176),
            "hCenter":0,
            "bottom":0
         };
      }
      
      public static function barrackSize160(param1:UnitPanel) : void
      {
         param1.setSize(160,160);
         (param1.getChildAt(1) as VComponent).layoutW = 159;
         param1.avatarContainer.assignLayout(getSoldierLayout(160));
         if(param1.priceSkin)
         {
            param1.priceSkin.assignLayout({
               "w":94,
               "hCenter":0,
               "bottom":16
            });
         }
      }
      
      public static function feature(param1:UnitPanel, param2:String = null, param3:uint = 160) : void
      {
         param1.setSize(param3,param3);
         if(Boolean(param2) && param2.indexOf("un_") == 0)
         {
            param1.avatarContainer.assignLayout(getSoldierLayout(param3));
         }
         else
         {
            param1.avatarContainer.assignLayout({
               "w":param3,
               "h":param3,
               "vCenter":0
            });
         }
      }
      
      public static function winTarget80W(param1:UnitPanel) : void
      {
         param1.setSize(80,80);
         param1.avatarContainer.assignLayout({
            "w":85,
            "h":85,
            "vCenter":0,
            "hCenter":0
         });
      }
      
      public static function winTarget80(param1:UnitPanel) : void
      {
         param1.setSize(80,80);
         param1.avatarContainer.assignLayout({
            "w":65,
            "h":65,
            "vCenter":0,
            "hCenter":0
         });
      }
      
      public static function winTarget60(param1:UnitPanel) : void
      {
         param1.setSize(60,60);
         param1.avatarContainer.assignLayout({
            "w":60,
            "h":60,
            "vCenter":0,
            "hCenter":0
         });
      }
      
      public static function createForMessage(param1:String, param2:uint) : UnitPanel
      {
         var _loc3_:UnitPanel = new UnitPanel(UnitPanel.FEATURE_MODE);
         feature(_loc3_,param1);
         _loc3_.show(param1,param2);
         return _loc3_;
      }
      
      public function show(param1:String, param2:uint = 1) : void
      {
         var _loc3_:Boolean = param1.indexOf("un_") == 0;
         if(_loc3_ || param1.indexOf("sp_") == 0)
         {
            if(!(this.avatar is VSkin))
            {
               if(this.avatar)
               {
                  this.avatarContainer.remove(this.avatar);
               }
               this.avatar = new VSkin();
               this.avatarContainer.addStretch(this.avatar);
            }
            (this.avatar as VSkin).setMode(_loc3_ ? 0 : VSkin.CONTAIN,false);
            SkinManager.applyExternal(this.avatar as VSkin,param2 > 0 ? param1 + param2 : param1,null,SkinManager.PNG | SkinManager.LOAD_CLIP);
         }
         else
         {
            if(!(this.avatar is UnitClipPanel))
            {
               if(this.avatar)
               {
                  this.avatarContainer.remove(this.avatar);
               }
               this.avatar = new UnitClipPanel();
               this.avatarContainer.addStretch(this.avatar);
            }
            (this.avatar as UnitClipPanel).show(param1,param2);
         }
      }
      
      override public function dispose() : void
      {
         disposeFloat(this.priceSkin);
         super.dispose();
      }
   }
}

