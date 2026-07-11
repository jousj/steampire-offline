package game.missions
{
   import proto.model.PCost;
   import proto.model.PMissionPercentage;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import utils.CostHelper;
   
   public class MissionButton extends VButton
   {
      
      public static var currentBoss:String;
      
      public static const M_ACTIVE:int = 1;
      
      public static const M_COMPLETE:int = 2;
      
      public static const M_DISABLED:int = 3;
      
      public static const M_EX:int = 4;
      
      protected var state:uint;
      
      protected var boss:String;
      
      protected var levelBox:VComponent;
      
      protected var isMouseLock:Boolean;
      
      public var resourceBossPack:Array;
      
      public var shineClip:VSkin;
      
      private var oilPanel:ResourcePanel;
      
      private var crystalPanel:ResourcePanel;
      
      public function MissionButton(param1:uint, param2:String = null)
      {
         super();
         this.boss = param2;
         var _loc3_:uint = param2 ? 125 : 80;
         setSize(_loc3_,_loc3_);
         setSkin(new VSkin(),{
            "hCenter":0,
            "vCenter":0
         });
         variance = param1;
         hitArea = skin;
      }
      
      public static function getDigitBox(param1:uint) : VBox
      {
         var _loc2_:Vector.<VComponent> = new Vector.<VComponent>();
         var _loc3_:String = param1.toString();
         var _loc4_:* = int(_loc3_.length - 1);
         while(_loc4_ >= 0)
         {
            _loc2_.unshift(SkinManager.getPack("MMapDg","map_" + _loc3_.charAt(_loc4_)));
            _loc4_--;
         }
         return new VBox(_loc2_,0,VBox.STRETCH);
      }
      
      public function applyState(param1:uint, param2:VComponent = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         if(param1 == this.state && Boolean(currentBoss))
         {
            return;
         }
         switch(param1)
         {
            case M_COMPLETE:
               if(this.boss)
               {
                  currentBoss = null;
                  setSize(80,80);
                  skin.resetLayout();
                  skin.assignLayout({
                     "hCenter":0,
                     "vCenter":0
                  });
               }
               _loc3_ = "completeMb";
               _loc4_ = -8;
               break;
            case M_ACTIVE:
               _loc3_ = "activeMb";
               if(variance == 0)
               {
                  skin.layoutH = 89;
                  _loc4_ = -4;
               }
               else
               {
                  _loc4_ = -5;
               }
               if(this.boss)
               {
                  if(!currentBoss)
                  {
                     currentBoss = this.boss;
                     _loc4_ = -9;
                  }
                  this.checkBossResources(false);
               }
               break;
            case M_EX:
               _loc3_ = "exMb";
               _loc4_ = -4;
               break;
            default:
               _loc3_ = "disableMb";
               _loc4_ = -4;
               if(this.boss)
               {
                  if(!currentBoss)
                  {
                     currentBoss = this.boss;
                     _loc4_ = -9;
                  }
                  this.checkBossResources(true);
                  skin.layoutH = -100;
               }
         }
         SkinManager.applyExternal(skin as VSkin,"MMapDg",_loc3_);
         if(this.levelBox)
         {
            remove(this.levelBox);
            this.levelBox = null;
         }
         mouseEnabled = !this.isMouseLock && param1 != M_DISABLED;
         if(variance > 0)
         {
            if(param2)
            {
               add(this.levelBox = param2,{
                  "hCenter":1,
                  "vCenter":_loc4_
               });
            }
            else if(Boolean(this.boss) && param1 != M_COMPLETE)
            {
               this.levelBox = new VBox(new <VComponent>[SkinManager.getExternal(this.boss,SkinManager.PNG)],0,VBox.STRETCH);
               add(this.levelBox,{
                  "hCenter":2,
                  "vCenter":_loc4_,
                  "h":(param1 == M_ACTIVE ? 74 : 85)
               });
            }
            else
            {
               this.levelBox = getDigitBox(variance);
               add(this.levelBox,{
                  "hCenter":1,
                  "vCenter":_loc4_,
                  "h":(variance >= 10 ? 36 : 42)
               });
            }
            if(param1 == M_ACTIVE != Boolean(this.shineClip))
            {
               if(this.shineClip)
               {
                  this.shineClip.removeFromParent();
                  this.shineClip = null;
               }
               else
               {
                  this.shineClip = SkinManager.getPack("MMapDg","activeShineClip",VSkin.NO_STRETCH | VSkin.PLAY_MOVIE_CLIP | VSkin.ZERO_CENTER);
                  add(this.shineClip,{
                     "vCenter":-2,
                     "hCenter":0
                  },0);
               }
            }
            visible = mouseEnabled || Boolean(this.boss) && currentBoss == this.boss;
         }
         this.state = param1;
      }
      
      private function checkBossResources(param1:Boolean) : void
      {
         var _loc2_:Array = null;
         var _loc3_:PMissionPercentage = null;
         var _loc4_:uint = 0;
         if(param1)
         {
            _loc2_ = this.resourceBossPack[0];
            _loc3_ = this.resourceBossPack[1];
            if(!this.oilPanel)
            {
               this.oilPanel = new ResourcePanel(PCost.OIL,ResourcePanel.BG | ResourcePanel.PROGRESS);
               this.crystalPanel = new ResourcePanel(PCost.CRYSTAL,ResourcePanel.BG | ResourcePanel.PROGRESS);
               this.crystalPanel.scaleX = this.crystalPanel.scaleY = this.oilPanel.scaleX = this.oilPanel.scaleY = 0.7;
               if(this.boss == "un_healer_mithril1")
               {
                  add(this.oilPanel,{
                     "right":80,
                     "vCenter":-18
                  });
                  add(this.crystalPanel,{
                     "right":80,
                     "vCenter":14
                  });
               }
               else
               {
                  add(this.oilPanel,{
                     "left":130,
                     "vCenter":-18
                  });
                  add(this.crystalPanel,{
                     "left":130,
                     "vCenter":14
                  });
               }
            }
            _loc4_ = CostHelper.getValueFromList(_loc2_,PCost.OIL);
            this.oilPanel.setDataEx(_loc3_ ? int(_loc3_.mp_oil_perc * _loc4_) : int(_loc4_),_loc4_);
            _loc4_ = CostHelper.getValueFromList(_loc2_,PCost.CRYSTAL);
            this.crystalPanel.setDataEx(_loc3_ ? int(_loc3_.mp_cry_perc * _loc4_) : int(_loc4_),_loc4_);
         }
         else if(this.oilPanel)
         {
            this.oilPanel.removeFromParent(true);
            this.crystalPanel.removeFromParent(true);
            this.oilPanel = this.crystalPanel = null;
         }
      }
      
      public function set mouseLock(param1:Boolean) : void
      {
         this.isMouseLock = param1;
         mouseEnabled = !this.isMouseLock && this.state != M_DISABLED && !this.boss;
      }
   }
}

