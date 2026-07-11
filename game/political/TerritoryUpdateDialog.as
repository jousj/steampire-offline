package game.political
{
   import game.feature.FeatureRenderer;
   import model.ui.VOFeatureItem;
   import proto.model.PCost;
   import proto.model.PShopMine;
   import proto.model.PShopTerritory;
   import proto.model.clan.PTerritory;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VGrid;
   import ui.vbase.VLabel;
   import ui.vbase.VSkin;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class TerritoryUpdateDialog extends BaseDialog
   {
      
      public var shop:PShopTerritory;
      
      public var mineShop:PShopMine;
      
      public function TerritoryUpdateDialog(param1:PTerritory, param2:PShopTerritory, param3:PShopMine, param4:PShopMine, param5:uint)
      {
         var _loc6_:VComponent = null;
         var _loc13_:PCost = null;
         var _loc15_:PCost = null;
         var _loc16_:PCost = null;
         var _loc17_:PCost = null;
         super();
         this.shop = param2;
         this.mineShop = param4;
         setSize(600,340);
         _loc6_ = new VComponent();
         add(_loc6_,{
            "wP":100,
            "bottom":0
         });
         addHeader();
         addDialogTitle(Lang.getString("territory_update"));
         _loc6_.layoutH = 110;
         _loc6_.add(SkinManager.getEmbed("FeatureSectionBg",VSkin.STRETCH_BG),{
            "wP":100,
            "bottom":0,
            "top":-20
         });
         _loc6_.add(new VLabel("<p" + Style.metalColor + ">" + Lang.getPatternString("update_to_level","__LEVEL__",StringHelper.getTLFImage("lib,Exp",20) + param4.mine_level) + "</p>",VLabel.CONTAIN_CENTER),{
            "left":20,
            "right":20,
            "top":4
         });
         var _loc7_:PriceListPanel = new PriceListPanel();
         _loc7_.assignList(param4.mine_price);
         var _loc8_:RectButton = new RectButton(_loc7_,RectButton.h56);
         _loc8_.addVarianceListener(this,0);
         _loc6_.add(_loc8_,{
            "hCenter":0,
            "bottom":24
         });
         var _loc9_:Array = [VOFeatureItem.create("ClanEmblemIcon","territory",0,0,Lang.getString(param1.kind),true),VOFeatureItem.create("EliteIcon","regent_multiplier",0,0,"x" + param3.mine_stamina_koef + FeatureRenderer.addUpdateStyle("+" + (param4.mine_stamina_koef - param3.mine_stamina_koef)),true)];
         var _loc10_:Array = CostHelper.getCostMul(CostHelper.mergeCostLists(param2.ter_resource_cost,param3.mine_resource_addition),24 * 60 * 60 / param2.ter_resource_time / param3.mine_time_k);
         var _loc11_:Array = CostHelper.getCostMul(CostHelper.mergeCostLists(param2.ter_resource_cost,param4.mine_resource_addition),24 * 60 * 60 / param2.ter_resource_time / param4.mine_time_k);
         var _loc12_:Array = CostHelper.mergeCostLists(param3.mine_resource_addition,CostHelper.mergeCostLists(param2.ter_resource_cost,param4.mine_resource_addition));
         for each(_loc13_ in _loc12_)
         {
            _loc15_ = null;
            for each(_loc16_ in _loc10_)
            {
               if(_loc16_.variance == _loc13_.variance)
               {
                  _loc15_ = _loc16_;
                  break;
               }
            }
            _loc17_ = null;
            for each(_loc16_ in _loc11_)
            {
               if(_loc16_.variance == _loc13_.variance)
               {
                  _loc17_ = _loc16_;
                  break;
               }
            }
            if(Boolean(_loc15_) && Boolean(_loc17_))
            {
               _loc9_.push(VOFeatureItem.create(CostHelper.getKind(_loc15_.variance),CostHelper.getKind(_loc15_.variance).toLowerCase() + "_production",0,0,Lang.getPatternString("mithril_per_day","__VALUE__",_loc15_.value + (_loc17_.value == _loc15_.value ? "" : FeatureRenderer.addUpdateStyle("+" + (_loc17_.value - _loc15_.value)))),true));
            }
         }
         if(_loc9_.length > 3)
         {
            layoutH += 40 * (_loc9_.length - 3);
         }
         var _loc14_:VGrid = new VGrid(1,_loc9_.length,FeatureRenderer,_loc9_,0,10,VGrid.H_STRETCH | VGrid.USE_TOP_LEFT);
         _loc14_.add(SkinManager.getEmbed("FrLine",VSkin.ROTATE_270 | VSkin.STRETCH),{
            "left":8,
            "top":24,
            "bottom":24,
            "w":17
         },0);
         _loc14_.add(SkinManager.getEmbed("FeatureDialogBg",VSkin.STRETCH),{
            "left":-110,
            "right":-36,
            "top":-40,
            "bottom":-28
         },0);
         add(_loc14_,{
            "left":110,
            "right":36,
            "top":86
         },1);
         add(SkinManager.getEmbed("FeatureGear"),{
            "left":-50,
            "top":155
         },0);
         add(SkinManager.getEmbed("TrainCircleBg"),{
            "left":-74,
            "top":44,
            "w":156,
            "h":157
         });
         add(SkinManager.getPack(UIFactory.POLITICAL_PACK,"TerritoryBg" + param5),{
            "left":-60,
            "top":48
         });
         add(SkinManager.getEmbed("UpdateIcon"),{
            "left":21,
            "top":130,
            "w":80,
            "h":73
         });
      }
   }
}

