package game.library
{
   import flash.display.Sprite;
   import game.barrack.BarrackDialog;
   import model.ui.VOSpellItem;
   import proto.model.PShopSpell;
   import ui.Style;
   import ui.common.CircleButton;
   import ui.common.LevelPanel;
   import ui.game.UnitPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VLabel;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import utils.StringHelper;
   
   public class SpellBuyRenderer extends VRenderer
   {
      
      public var buyBt:VButton;
      
      private var unitPanel:UnitPanel;
      
      private var infoBt:CircleButton;
      
      private var lockSkin:VSkin;
      
      private var levelPanel:LevelPanel;
      
      private var reqLabel:VLabel;
      
      private var reqSkin:VSkin;
      
      private var selectSkin:VSkin;
      
      public function SpellBuyRenderer()
      {
         super();
         setSize(160,160);
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:VOSpellItem = param1 as VOSpellItem;
         if(_loc2_)
         {
            this.showItem(_loc2_);
         }
         else
         {
            if(this.buyBt)
            {
               this.setBtVisible(false);
            }
            if(!this.lockSkin)
            {
               this.lockSkin = SkinManager.getEmbed("TrainBgLock");
               add(this.lockSkin);
            }
            else
            {
               this.lockSkin.visible = true;
            }
            hint = null;
         }
      }
      
      private function setBtVisible(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.lockSkin)
            {
               this.lockSkin.visible = false;
            }
            if(!this.buyBt)
            {
               this.createBt();
            }
         }
         if(this.infoBt)
         {
            this.infoBt.visible = param1;
         }
         this.buyBt.visible = param1;
      }
      
      private function createBt() : void
      {
         var _loc1_:Sprite = null;
         this.unitPanel = new UnitPanel(UnitPanel.FEATURE_MODE,UnitPanel.barrackSize160);
         this.buyBt = new VButton();
         this.buyBt.addVarianceListener(this,BarrackDialog.INC);
         this.buyBt.setSkin(this.unitPanel);
         add(this.buyBt,null,0);
         _loc1_ = new Sprite();
         _loc1_.graphics.beginFill(16776960,1);
         var _loc2_:Number = this.unitPanel.layoutW / 2;
         _loc1_.graphics.drawCircle(_loc2_,_loc2_,_loc2_);
         _loc1_.mouseEnabled = false;
         _loc1_.visible = false;
         addChild(_loc1_);
         this.buyBt.hitArea = _loc1_;
      }
      
      private function addInfoBt() : void
      {
         this.infoBt = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.TEAL,CircleButton.size42);
         this.infoBt.hint = Lang.getString("info");
         add(this.infoBt,{
            "left":-6,
            "top":-10
         });
         this.infoBt.addVarianceListener(this,BarrackDialog.INFO);
      }
      
      private function showItem(param1:VOSpellItem) : void
      {
         if(!this.infoBt)
         {
            this.addInfoBt();
         }
         this.setBtVisible(true);
         if(param1.isSelect != Boolean(this.selectSkin))
         {
            if(param1.isSelect)
            {
               this.selectSkin = SkinManager.getEmbed("ChCheck");
               add(this.selectSkin,{
                  "h":55,
                  "bottom":-8,
                  "right":0
               });
            }
            else
            {
               remove(this.selectSkin);
               this.selectSkin = null;
            }
            this.unitPanel.filters = param1.isSelect && !param1.isLock ? VSkin.GREY_FILTER : null;
         }
         this.buyBt.disabled = param1.isLock || param1.isLimit && !param1.isSelect;
         if(this.buyBt.data == param1)
         {
            return;
         }
         this.buyBt.data = param1;
         var _loc2_:PShopSpell = param1.shop;
         this.infoBt.data = _loc2_;
         this.unitPanel.show(_loc2_.ssp_kind);
         if(param1.isLock)
         {
            if(this.levelPanel)
            {
               this.buyBt.remove(this.levelPanel);
               this.levelPanel = null;
            }
            if(!this.reqLabel)
            {
               this.reqSkin = SkinManager.getEmbed("TrainPriceBg");
               this.buyBt.add(this.reqSkin,{
                  "w":94,
                  "hCenter":0,
                  "bottom":16
               });
               this.reqLabel = new VLabel(null,VLabel.CENTER | VLabel.MIDDLE | VLabel.LEADING_BOX);
               Style.applyGlowFilter(this.reqLabel,Style.grayGlowRGB,4);
               this.buyBt.add(this.reqLabel,{
                  "wP":100,
                  "top":105,
                  "h":40
               });
            }
            this.reqLabel.text = "<p fontSize=\"14\"" + Style.yellowColor + ">" + Lang.getPatternString("required_build","__BUILD__",StringHelper.getUnitName(_loc2_.ssp_upgrade_requirement.req_building_kind,_loc2_.ssp_upgrade_requirement.req_building_level,14,"")) + "</p>";
         }
         else
         {
            if(this.reqLabel)
            {
               this.buyBt.remove(this.reqLabel);
               this.reqLabel = null;
               this.buyBt.remove(this.reqSkin);
               this.reqSkin = null;
            }
            if(!this.levelPanel)
            {
               this.levelPanel = new LevelPanel(LevelPanel.size34);
               this.buyBt.add(this.levelPanel,{
                  "top":4,
                  "right":6
               });
            }
            this.levelPanel.value = param1.shop.ssp_level;
         }
      }
   }
}

