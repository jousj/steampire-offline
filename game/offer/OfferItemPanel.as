package game.offer
{
   import flash.events.MouseEvent;
   import game.feature.FeatureMediator;
   import game.shop.ShopUnitPanel;
   import proto.model.PCost;
   import proto.model.POfferGoods;
   import proto.model.PShopUnit;
   import proto.model.PUserClan;
   import proto.tuples.str_i;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.DurationPanel;
   import ui.common.LevelPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   
   public class OfferItemPanel extends VComponent
   {
      
      public static const CLAN_COST:uint = 1000;
      
      private var isCount:Boolean;
      
      public function OfferItemPanel(param1:POfferGoods, param2:int, param3:uint = 22)
      {
         var _loc5_:String = null;
         var _loc6_:Object = null;
         super();
         setSize(248,235);
         var _loc4_:uint = param1.variance;
         switch(_loc4_)
         {
            case POfferGoods.COST:
            case CLAN_COST:
               _loc5_ = this.useCost(param1.value,param3,_loc4_ == CLAN_COST);
               break;
            case POfferGoods.SHIELD:
               this.useShield(param1.value,param3);
               break;
            case POfferGoods.UNIT:
               _loc6_ = this.useSoldier(param1.value,param3);
               param2 = str_i(param1.value).field_1;
               break;
            case POfferGoods.BUY:
            case POfferGoods.UPGRADE:
               _loc6_ = this.useConstruction(param1.value,param3);
               break;
            case POfferGoods.CLAN_CAPITAL:
               this.useCapital(param3);
         }
         if(!_loc5_)
         {
            _loc5_ = "4";
         }
         add(SkinManager.getPack(UIFactory.OFFER_PACK,"GlassBg"),{
            "bottom":8,
            "left":8
         },numChildren > 0 ? int(numChildren - 1) : 0);
         add(SkinManager.getEmbed("ShopBg" + _loc5_,VSkin.STRETCH),{
            "left":6,
            "right":6,
            "top":6,
            "bottom":6
         },0);
         add(SkinManager.getPack(UIFactory.OFFER_PACK,"Diffusion"),{
            "left":7,
            "top":7
         },1);
         addChild(SkinManager.getPack(UIFactory.OFFER_PACK,"ItemBorder"));
         if(param2 > 1)
         {
            _loc5_ = param2.toString();
            if(_loc4_ == POfferGoods.BUY)
            {
               _loc5_ = "+" + _loc5_;
            }
            this.showCount(_loc5_);
         }
         if(_loc4_ == POfferGoods.UPGRADE)
         {
            add(SkinManager.getPack(UIFactory.OFFER_PACK,"UpdateIcon"),{
               "right":-20,
               "top":34
            });
         }
         if(_loc6_)
         {
            this.addInfoButton(_loc6_);
         }
      }
      
      private function useCost(param1:PCost, param2:uint, param3:Boolean) : String
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         switch(param1.variance)
         {
            case PCost.CRYSTAL:
               _loc6_ = "rs_crystal3";
               _loc7_ = "2";
               break;
            case PCost.OIL:
               _loc6_ = "rs_oil3";
               _loc7_ = "3";
               break;
            case PCost.GOLD:
               _loc6_ = param1.value == 0 ? "rs_gold4" : "rs_gold6";
               break;
            case PCost.CALL:
               _loc7_ = "2";
               _loc6_ = "rs_calls2";
               break;
            case PCost.TROPHY:
               _loc6_ = "rs_trophy1";
               break;
            default:
               _loc8_ = true;
               _loc6_ = CostHelper.getKind(param1.variance);
         }
         if(_loc8_)
         {
            add(SkinManager.getEmbed(_loc6_),{
               "hCenter":0,
               "vCenter":-12,
               "w":180,
               "h":140
            });
            hint = Lang.getString(_loc6_);
         }
         else
         {
            add(SkinManager.getExternal(_loc6_,SkinManager.PNG | SkinManager.LOAD_CLIP),{
               "hCenter":0,
               "vCenter":-12,
               "w":210,
               "h":180
            });
            hint = Lang.getString(CostHelper.getKind(param1.variance));
         }
         var _loc4_:uint = PricePanel.GLOW_FILTER;
         if(param3)
         {
            _loc4_ |= PricePanel.CLAN;
         }
         var _loc5_:PricePanel = new PricePanel(38,param2,_loc4_);
         _loc5_.assignCost(param1);
         add(_loc5_,{
            "hCenter":0,
            "bottom":17,
            "maxW":220
         });
         return _loc7_;
      }
      
      private function useShield(param1:Number, param2:uint) : void
      {
         add(SkinManager.getExternal("sh_medium",SkinManager.PNG | SkinManager.LOAD_CLIP),{
            "hCenter":0,
            "vCenter":-12,
            "w":210,
            "h":180
         });
         var _loc3_:VText = UIFactory.createYellowText(Lang.getString("shield_offer"),VText.CONTAIN,param2);
         _loc3_.maxW = 140;
         add(new VBox(new <VComponent>[_loc3_,new DurationPanel(30,param2).setStaticTime(param1)],5),{
            "bottom":20,
            "hCenter":0
         });
      }
      
      private function useSoldier(param1:str_i, param2:uint) : PShopUnit
      {
         add(SkinManager.getEmbed("TrainFg",VSkin.STRETCH),{
            "hCenter":0,
            "w":159,
            "h":159,
            "vCenter":-10
         });
         var _loc3_:PShopUnit = Facade.manualProxy.getSoldierShop(param1.field_0);
         add(SkinManager.getExternal(param1.field_0 + _loc3_.su_model_level,SkinManager.PNG | SkinManager.LOAD_CLIP),{
            "hCenter":0,
            "vCenter":-16
         });
         var _loc4_:VText = UIFactory.createYellowText(Lang.getString(param1.field_0),VText.CENTER | VText.MIDDLE,param2);
         _loc4_.format.lineHeight = "104%";
         add(_loc4_,{
            "left":14,
            "right":14,
            "bottom":13,
            "h":46
         });
         return _loc3_;
      }
      
      private function useConstruction(param1:str_i, param2:uint) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:ShopUnitPanel = null;
         if(param1.field_0.indexOf("cn_") == 0)
         {
            _loc4_ = Facade.manualProxy.getCannonShop(param1.field_0,param1.field_1);
            add(SkinManager.getExternal(param1.field_0 + param1.field_1,SkinManager.PNG | SkinManager.LOAD_CLIP),{
               "hCenter":0,
               "vCenter":-12,
               "w":190,
               "h":150
            });
         }
         else
         {
            _loc5_ = new ShopUnitPanel();
            add(_loc5_,{
               "hCenter":0,
               "vCenter":-10,
               "w":218,
               "h":174
            });
            _loc5_.show(param1.field_0,param1.field_1);
            if(param1.field_0.indexOf("bl_builder") == -1)
            {
               _loc4_ = _loc5_.unit;
            }
         }
         var _loc3_:VText = UIFactory.createYellowText(Lang.getString(param1.field_0),VText.CONTAIN,param2);
         _loc3_.maxW = 180;
         add(new VBox(new <VComponent>[_loc3_,new LevelPanel(LevelPanel.size28,param1.field_1)]),{
            "bottom":22,
            "hCenter":0
         });
         return _loc4_;
      }
      
      private function useCapital(param1:uint) : void
      {
         var _loc2_:PUserClan = Facade.userProxy.clan;
         add(SkinManager.getPack(UIFactory.EMBLEM_PACK,_loc2_ ? _loc2_.uc_icon : "emblem33"),{
            "hCenter":0,
            "vCenter":-8,
            "w":180,
            "h":150
         });
         var _loc3_:VText = UIFactory.createYellowText(Lang.getString("news_capital_title"),VText.CENTER | VText.MIDDLE,param1);
         _loc3_.format.lineHeight = "104%";
         add(_loc3_,{
            "left":14,
            "right":14,
            "bottom":13,
            "h":46
         });
      }
      
      private function showCount(param1:String) : void
      {
         this.isCount = true;
         add(SkinManager.getPack(UIFactory.OFFER_PACK,"CountBg"),{
            "left":6,
            "top":6
         });
         add(UIFactory.createYellowText(param1,VText.CONTAIN_CENTER,24),{
            "left":7,
            "top":20,
            "w":43
         });
      }
      
      public function showSale(param1:uint) : void
      {
         if(this.isCount)
         {
            return;
         }
         add(SkinManager.getPack(UIFactory.OFFER_PACK,"SaleBg"),{
            "left":-8,
            "top":-7
         });
         add(SkinManager.getPack(UIFactory.OFFER_PACK,"SaleLabel"),{
            "left":-3,
            "top":-3
         });
         add(SkinManager.getPack(UIFactory.OFFER_PACK,"Sale" + param1),{
            "left":7,
            "top":7
         });
      }
      
      private function addInfoButton(param1:Object) : void
      {
         var _loc2_:CircleButton = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.TEAL,CircleButton.size42);
         _loc2_.hint = Lang.getString("info");
         add(_loc2_,{
            "right":-10,
            "top":-10
         });
         _loc2_.addClickListener(this.onInfo,param1);
      }
      
      private function onInfo(param1:MouseEvent) : void
      {
         var _loc2_:FeatureMediator = new FeatureMediator((param1.currentTarget as CircleButton).data);
         _loc2_.isOfferMode = true;
         Facade.mainMediator.showDialog(_loc2_);
      }
   }
}

