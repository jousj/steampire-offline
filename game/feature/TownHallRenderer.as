package game.feature
{
   import model.ui.VOTownHallItem;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.game.UnitClipPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class TownHallRenderer extends VRenderer
   {
      
      private const unitClip:UnitClipPanel = new UnitClipPanel();
      
      private var text:VText;
      
      private var sectorBg:VSkin;
      
      private var levelPanel:LevelPanel;
      
      private var selectSkin:VSkin;
      
      private var cacheKind:String;
      
      private var cacheCount:uint = 4294967295;
      
      private var newSkin:VSkin;
      
      public function TownHallRenderer()
      {
         super();
         mouseChildren = false;
         setSize(96,92);
         addStretch(SkinManager.getEmbed("DarkPanelBg",VSkin.STRETCH));
         add(this.unitClip,{
            "left":3,
            "right":3,
            "top":4,
            "bottom":5
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc2_:VOTownHallItem = param1 as VOTownHallItem;
         if(_loc2_)
         {
            _loc3_ = _loc2_.level;
            _loc4_ = _loc2_.count;
            if(_loc2_.kind != this.cacheKind || _loc3_ != (this.levelPanel ? this.levelPanel.value : 0))
            {
               this.cacheKind = _loc2_.kind;
               this.unitClip.show(_loc2_.kind,_loc3_);
               hint = Lang.getString(_loc2_.kind);
            }
         }
         else if(this.cacheKind)
         {
            this.unitClip.reset();
            this.cacheKind = null;
            hint = null;
         }
         if(_loc3_ > 0)
         {
            if(!this.levelPanel)
            {
               this.levelPanel = new LevelPanel(LevelPanel.size28,_loc3_);
               add(this.levelPanel,{
                  "right":-5,
                  "top":-5
               });
            }
            else
            {
               this.levelPanel.value = _loc3_;
            }
         }
         else if(this.levelPanel)
         {
            remove(this.levelPanel);
            this.levelPanel = null;
         }
         if(_loc4_ > 0)
         {
            if(!this.text)
            {
               this.sectorBg = SkinManager.getEmbed("CounterSectorBg");
               add(this.sectorBg,{
                  "left":2,
                  "bottom":2
               });
               this.text = UIFactory.createYellowText(null,VText.CONTAIN_CENTER);
               add(this.text,{
                  "w":28,
                  "bottom":5
               });
            }
            if(this.cacheCount != _loc4_)
            {
               this.cacheCount = _loc4_;
               this.text.value = _loc2_.usePlus ? "+" + _loc4_ : _loc4_.toString();
            }
         }
         else if(this.text)
         {
            remove(this.sectorBg);
            this.sectorBg = null;
            remove(this.text);
            this.text = null;
         }
      }
      
      public function useNew() : void
      {
         if(!this.newSkin)
         {
            this.newSkin = SkinManager.getEmbed("NewIcon");
            add(this.newSkin,{
               "left":8,
               "top":-11
            });
         }
      }
      
      override public function setSelected(param1:Boolean) : void
      {
         if(param1 != Boolean(this.selectSkin))
         {
            if(param1)
            {
               this.selectSkin = SkinManager.getEmbed("CollectIcon");
               add(this.selectSkin);
               if(this.newSkin)
               {
                  remove(this.newSkin);
                  this.newSkin = null;
               }
            }
            else
            {
               remove(this.selectSkin);
               this.selectSkin = null;
            }
         }
      }
   }
}

