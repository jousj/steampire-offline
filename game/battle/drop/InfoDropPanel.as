package game.battle.drop
{
   import engine.signal.Signal;
   import model.ui.VOBattleItem;
   import proto.model.PCost;
   import proto.model.PShopSpell;
   import proto.model.PShopUnit;
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class InfoDropPanel extends VComponent
   {
      
      protected const bg:VSkin = SkinManager.getEmbed("UnitDropBg",VSkin.STRETCH);
      
      private const iconSkin:VSkin = new VSkin();
      
      private const valueText:VText = new VText(null,VText.CONTAIN,16777215);
      
      private var cacheValue:int = -1;
      
      private var costSkin:VSkin;
      
      private var cacheVariance:int = -1;
      
      private var isExHint:Boolean;
      
      public function InfoDropPanel(param1:int, param2:int, param3:int, param4:Boolean)
      {
         super();
         this.isExHint = param4;
         addStretch(this.bg);
         add(this.iconSkin,{
            "hCenter":0,
            "vCenter":0,
            "w":param1,
            "h":param2
         });
         add(SkinManager.getEmbed("UnitDropFg",VSkin.STRETCH),{
            "left":param3,
            "right":param3,
            "top":param3,
            "bottom":param3
         });
         Style.applyGlowFilter(this.valueText,0,8);
         this.addOnlyValue();
      }
      
      private function addOnlyValue() : void
      {
         add(this.valueText,{
            "maxW":this.iconSkin.layoutW - 2,
            "right":6,
            "bottom":6
         });
      }
      
      public function assign(param1:VOBattleItem, param2:Boolean, param3:VComponent) : void
      {
         var _loc11_:Boolean = false;
         var _loc12_:String = null;
         var _loc4_:int = -1;
         var _loc5_:int = -2;
         var _loc6_:int = -3;
         var _loc7_:int = -2;
         var _loc8_:int = _loc4_;
         var _loc9_:int = -1;
         var _loc10_:Boolean = Boolean(param1.spellShop);
         if(param1.isWorker && !_loc10_)
         {
            param2 = false;
            if(this.cacheValue != _loc7_)
            {
               _loc9_ = _loc7_;
               this.valueText.value = Lang.getString("spell_empty");
               SkinManager.applyEmbed(this.iconSkin,"SpellIcon");
            }
         }
         else if(param1.isWorker)
         {
            if(param1.isLock)
            {
               _loc9_ = this.cacheValue = -2;
               this.valueText.value = Lang.getString("worker_spell_busy");
            }
            else if(param1.waitTime > 0)
            {
               _loc9_ = this.cacheValue = _loc8_ = _loc6_;
               Signal.createRef(this,this.onSignal,0,1).run(0,Facade.battleMediator.getSimulateTime(param1.waitTime - 1),true,true);
            }
            else
            {
               _loc8_ = int((param1.spellShop.ssp_price[0] as PCost).variance);
               _loc9_ = (param1.spellShop.ssp_price[0] as PCost).value;
            }
         }
         else if(_loc10_)
         {
            if(param2)
            {
               _loc8_ = _loc5_;
               _loc9_ = param1.spellShop.ssp_power_price;
            }
            else
            {
               _loc8_ = this.cacheVariance;
               _loc9_ = this.cacheValue;
            }
         }
         else
         {
            _loc9_ = int(param1.count);
         }
         if(_loc8_ != this.cacheVariance)
         {
            if(this.cacheVariance == _loc6_)
            {
               Signal.stopRef(this);
            }
            this.cacheVariance = _loc8_;
            _loc11_ = _loc8_ != _loc4_;
            this.useCostSkin(_loc11_);
            if(_loc11_)
            {
               if(_loc8_ == _loc5_)
               {
                  _loc12_ = "Power";
               }
               else if(_loc8_ == _loc6_)
               {
                  _loc12_ = "ClockIcon";
               }
               else
               {
                  _loc12_ = CostHelper.getKind(_loc8_);
               }
               SkinManager.applyEmbed(this.costSkin,_loc12_);
            }
         }
         if(param2)
         {
            if(_loc10_)
            {
               this.changeSpellIcon(param1,param3);
            }
            else
            {
               this.changeUnitIcon(param1.shop,param3);
            }
         }
         if(this.cacheValue != _loc9_)
         {
            this.cacheValue = _loc9_;
            if(_loc9_ >= 0)
            {
               this.valueText.value = _loc9_ > 0 ? _loc9_.toString() : "...";
            }
         }
      }
      
      private function useCostSkin(param1:Boolean) : void
      {
         if(param1 != Boolean(this.costSkin))
         {
            if(param1)
            {
               this.costSkin = new VSkin();
               this.costSkin.layoutH = 22;
               Style.applyGlowFilter(this.costSkin,16777215,8);
               this.valueText.resetLayout();
               add(new VBox(new <VComponent>[this.costSkin,this.valueText],3,VBox.BOTTOM),{
                  "right":6,
                  "bottom":6,
                  "h":18
               });
            }
            else
            {
               (this.costSkin.parent as VBox).remove(this.valueText,false);
               remove(this.costSkin.parent as VBox);
               this.costSkin = null;
               this.addOnlyValue();
            }
         }
      }
      
      private function changeUnitIcon(param1:PShopUnit, param2:VComponent) : void
      {
         SkinManager.applyExternal(this.iconSkin,param1.su_kind + param1.su_model_level + "_q",null,SkinManager.PNG | SkinManager.LOAD_CLIP);
         param2.hint = StringHelper.getUnitName(param1.su_kind,param1.su_level);
      }
      
      private function changeSpellIcon(param1:VOBattleItem, param2:VComponent) : void
      {
         var _loc3_:PShopSpell = param1.spellShop;
         SkinManager.applyExternal(this.iconSkin,_loc3_.ssp_kind + "1_q",null,SkinManager.PNG | SkinManager.LOAD_CLIP);
         param2.hint = StringHelper.getUnitName(_loc3_.ssp_kind,_loc3_.ssp_level);
         if(this.isExHint)
         {
            param2.hint += "\n" + Lang.getString(_loc3_.ssp_kind + "_about");
            if(param1.isWorker)
            {
               param2.hint += "\n" + Lang.getString("duration") + ": " + StringHelper.getTimeDesc(param1.workerDuration / 1000);
            }
         }
      }
      
      private function onSignal(param1:Signal) : void
      {
         this.valueText.value = StringHelper.getTimeDesc(param1.tail);
      }
      
      override public function dispose() : void
      {
         Signal.stopRef(this);
         super.dispose();
      }
   }
}

