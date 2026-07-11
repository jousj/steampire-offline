package ui.game
{
   import model.ui.VOBattleItem;
   import proto.model.PShopUnit;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class SquareSoldierPanel extends VComponent
   {
      
      private const skin:VSkin = new VSkin(VComponent.SKIP_CONTENT_SIZE | VSkin.CONTAIN);
      
      private var cacheCount:uint;
      
      private var levelPanel:LevelPanel;
      
      private var text:VText;
      
      private var sectorSkin:VSkin;
      
      private var cacheKind:String;
      
      public function SquareSoldierPanel()
      {
         super();
         mouseChildren = false;
         var _loc1_:VFill = new VFill(0,0.25);
         _loc1_.setPadding(3);
         addChild(_loc1_);
         this.skin.setPadding(3);
         addChild(this.skin);
         addStretch(SkinManager.getEmbed("DarkBorder",VSkin.STRETCH_BG));
      }
      
      public function useLevelPanel() : void
      {
         if(!this.levelPanel)
         {
            this.levelPanel = new LevelPanel(LevelPanel.size28);
            add(this.levelPanel,{
               "right":-5,
               "top":-5
            });
         }
      }
      
      public function show(param1:String, param2:uint, param3:uint = 0) : void
      {
         if(this.cacheKind != param1)
         {
            this.cacheKind = param1;
            SkinManager.applyExternal(this.skin,param1,null,SkinManager.PNG | SkinManager.LOAD_CLIP);
         }
         if(this.cacheCount != param3)
         {
            this.cacheCount = param3;
            if(param3 > 0)
            {
               if(!this.text)
               {
                  this.sectorSkin = SkinManager.getEmbed("CounterSectorBg");
                  add(this.sectorSkin,{
                     "left":2,
                     "bottom":2
                  });
                  this.text = UIFactory.createYellowText(null,VText.CONTAIN_CENTER);
                  add(this.text,{
                     "w":28,
                     "bottom":5
                  });
               }
               this.text.value = param3.toString();
            }
            if(this.text)
            {
               this.text.visible = this.sectorSkin.visible = param3 > 0;
            }
         }
         if(this.levelPanel)
         {
            this.levelPanel.visible = true;
            this.levelPanel.value = param2;
         }
      }
      
      public function clear() : void
      {
         if(this.cacheKind)
         {
            this.skin.resetContent();
            this.cacheKind = null;
         }
         if(this.cacheCount > 0)
         {
            this.cacheCount = 0;
            if(this.text)
            {
               this.text.visible = this.sectorSkin.visible = false;
            }
         }
         if(this.levelPanel)
         {
            this.levelPanel.visible = false;
         }
      }
      
      public function assignShopUnit(param1:PShopUnit, param2:uint = 0, param3:String = "_q") : void
      {
         this.show(param1.su_kind + param1.su_model_level + param3,param1.su_level,param2);
      }
      
      public function assignBattleItem(param1:VOBattleItem, param2:VComponent = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(param1)
         {
            if(param1.shop)
            {
               _loc3_ = param1.shop.su_kind;
               _loc4_ = param1.shop.su_level;
               _loc5_ = param1.shop.su_model_level;
            }
            else
            {
               _loc3_ = param1.spellShop.ssp_kind;
               _loc4_ = uint(param1.spellShop.ssp_level);
               _loc5_ = 1;
            }
            if(Boolean(param2) && this.cacheKind != _loc3_)
            {
               param2.hint = StringHelper.getUnitName(_loc3_,_loc4_,22,Style.darkKhakiColor);
            }
            this.show(_loc3_ + _loc5_ + "_q",_loc4_,param1.count);
         }
         else
         {
            this.clear();
            if(param2)
            {
               param2.hint = null;
            }
         }
      }
   }
}

