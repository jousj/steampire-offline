package game.my
{
   import ui.common.CircleButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VScrollBar;
   import ui.vbase.VSkin;
   
   public class PrefPanel extends VComponent
   {
      
      public const zoomMin:Number = 0.6;
      
      public const zoomMax:Number = 1;
      
      public const fullScreenBt:CircleButton;
      
      public const settingBt:CircleButton;
      
      public var damageBt:CircleButton;
      
      private var sb:VScrollBar;
      
      public function PrefPanel()
      {
         var _loc1_:CircleButton = null;
         var _loc2_:CircleButton = null;
         this.fullScreenBt = new CircleButton(SkinManager.getEmbed("FullScreenIcon"),CircleButton.GOLD,CircleButton.size42);
         this.settingBt = new CircleButton(SkinManager.getEmbed("SettingGroupIcon"),CircleButton.GOLD,CircleButton.size42);
         super();
         layoutW = 42;
         this.fullScreenBt.hint = Lang.getString("FullScreenBt");
         addChild(this.fullScreenBt);
         this.settingBt.hint = Lang.getString("settingGroup");
         this.settingBt.top = 46;
         addChild(this.settingBt);
         _loc1_ = new CircleButton(SkinManager.getEmbed("ZoomIn"),CircleButton.GOLD,CircleButton.size30);
         _loc2_ = new CircleButton(SkinManager.getEmbed("ZoomOut"),CircleButton.GOLD,CircleButton.size30);
         _loc1_.hint = Lang.getString("zoomInBt");
         _loc2_.hint = Lang.getString("zoomOutBt");
         var _loc3_:VSkin = SkinManager.getEmbed("ZoomTrack");
         var _loc4_:VSkin = SkinManager.getEmbed("ZoomThumb",VSkin.NO_STRETCH);
         this.sb = new VScrollBar(_loc3_,_loc4_,VScrollBar.TRACK_DOWN);
         this.sb.setSize(_loc3_.measuredWidth,160);
         this.sb.add(_loc3_,{
            "vCenter":0,
            "hCenter":0
         });
         this.sb.add(_loc4_,{
            "hCenter":0,
            "minH":2,
            "top":36,
            "h":90
         });
         _loc1_.hCenter = 1;
         this.sb.addChild(_loc1_);
         this.sb.add(_loc2_,{
            "hCenter":1,
            "bottom":0
         });
         this.sb.assignButton(_loc1_,_loc2_,10);
         this.sb.setEnv(2,102,0,5);
         add(this.sb,{
            "top":92,
            "hCenter":0
         });
         this.sb.dispatcher = this;
         cacheAsBitmap = true;
      }
      
      public function setZoomValue(param1:Number) : void
      {
         this.sb.value = (1 - (param1 - this.zoomMin) / (this.zoomMax - this.zoomMin)) * 100;
      }
      
      public function set lock(param1:Boolean) : void
      {
         this.sb.visible = !param1;
      }
      
      public function useDamageBt(param1:Boolean) : Boolean
      {
         if(Boolean(this.damageBt) != param1)
         {
            if(!this.damageBt)
            {
               this.damageBt = new CircleButton(SkinManager.getEmbed("DamageIcon"),CircleButton.GOLD);
               this.damageBt.sizeCustom(42,32);
               this.damageBt.hint = Lang.getString("damage_visible");
               add(this.damageBt,{
                  "hCenter":0,
                  "top":262
               });
               return true;
            }
            remove(this.damageBt);
            this.damageBt = null;
         }
         return false;
      }
      
      public function setDamageMode(param1:Boolean) : void
      {
         SkinManager.applyEmbed(this.damageBt.skin as VSkin,param1 ? CircleButton.ORANGE : CircleButton.GOLD);
      }
   }
}

