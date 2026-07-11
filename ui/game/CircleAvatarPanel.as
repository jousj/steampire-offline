package ui.game
{
   import game.missions.MissionButton;
   import game.missions.MissionMapDialog;
   import ui.UIFactory;
   import ui.common.AvatarLoader;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class CircleAvatarPanel extends VComponent
   {
      
      private const bgSkin:VSkin = new VSkin(VSkin.STRETCH_BG);
      
      private const borderSkin:VSkin = new VSkin(VSkin.STRETCH_BG);
      
      private var avatarLoader:AvatarLoader;
      
      private var msSkin:VSkin;
      
      private var msIcon:VComponent;
      
      private var cacheNum:uint;
      
      public function CircleAvatarPanel()
      {
         super();
         mouseChildren = false;
         setSize(85,85);
         addStretch(this.bgSkin);
         addStretch(this.borderSkin);
      }
      
      public function setUser(param1:Object, param2:uint) : void
      {
         if(this.msSkin)
         {
            remove(this.msSkin);
            this.msSkin = null;
         }
         if(this.msIcon)
         {
            remove(this.msIcon);
            this.msIcon = null;
         }
         if(!this.avatarLoader)
         {
            this.avatarLoader = new AvatarLoader();
            this.avatarLoader.mask = SkinManager.getEmbed("AvaBg",VSkin.STRETCH_BG);
            this.avatarLoader.addStretch(this.avatarLoader.mask as VSkin);
            addStretch(this.avatarLoader,1);
            SkinManager.applyEmbed(this.bgSkin,"AvaBg");
            this.cacheNum = 1000;
         }
         if(this.cacheNum != param2)
         {
            this.cacheNum = param2;
            SkinManager.applyEmbed(this.borderSkin,"AvaBorder" + param2);
         }
         this.avatarLoader.load(param1);
      }
      
      public function setMission(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc6_:Number = NaN;
         if(this.avatarLoader)
         {
            remove(this.avatarLoader);
            this.avatarLoader = null;
         }
         if(this.msIcon)
         {
            remove(this.msIcon);
            this.msIcon = null;
         }
         else
         {
            SkinManager.applyEmbed(this.bgSkin,"MsAvaBg");
            if(param4)
            {
               SkinManager.applyEmbed(this.borderSkin,"AvaBorder0");
            }
            else
            {
               SkinManager.applyEmbed(this.borderSkin,"MsBorder");
            }
         }
         var _loc5_:int = getChildIndex(this.borderSkin) + 1;
         if(!param2 != Boolean(this.msSkin))
         {
            if(param2)
            {
               remove(this.msSkin);
               this.msSkin = null;
            }
            else
            {
               this.msSkin = SkinManager.getPack("MMapDg","activeMb");
               add(this.msSkin,{
                  "vCenter":3,
                  "hCenter":0,
                  "w":70,
                  "h":70
               },_loc5_);
            }
         }
         if(param4)
         {
            this.msIcon = SkinManager.getExternal(param1,SkinManager.PNG);
            addStretch(this.msIcon,_loc5_);
         }
         else if(param2)
         {
            this.msIcon = param3 ? SkinManager.getEmbed(param1) : SkinManager.getPack(UIFactory.EMBLEM_PACK,param1);
            addStretch(this.msIcon,_loc5_);
         }
         else
         {
            if(param1)
            {
               _loc6_ = Number(param1.substr(MissionMapDialog.MISSION_PREFIX.length));
               if(!isNaN(_loc6_))
               {
                  this.msIcon = MissionButton.getDigitBox(_loc6_);
               }
            }
            if(!this.msIcon)
            {
               this.msIcon = SkinManager.getEmbed("CannonIcon");
            }
            add(this.msIcon,{
               "hCenter":0,
               "vCenter":0,
               "h":40
            },_loc5_ + 1);
         }
      }
   }
}

