package game.clan.center
{
   import proto.model.PClanTownhallUnlock;
   import proto.model.PCost;
   import proto.model.PShopMine;
   import proto.model.PShopTerritory;
   import proto.model.PTerritoryLevel;
   import proto.model.clan.PClan;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VText;
   import utils.CostHelper;
   
   public class CreateDomainSection extends VComponent
   {
      
      public function CreateDomainSection(param1:PClan, param2:Boolean, param3:Array)
      {
         var _loc4_:VComponent = null;
         var _loc7_:PriceListPanel = null;
         var _loc8_:PricePanel = null;
         var _loc9_:PriceListPanel = null;
         var _loc10_:PricePanel = null;
         var _loc11_:String = null;
         var _loc12_:PClanTownhallUnlock = null;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:PTerritoryLevel = null;
         var _loc16_:PShopTerritory = null;
         var _loc17_:PShopMine = null;
         var _loc18_:Array = null;
         var _loc19_:RectButton = null;
         super();
         layoutH = 85;
         add(UIFactory.createYellowText(Lang.getString("clan_territory"),VText.CONTAIN,15),{
            "left":20,
            "right":2
         });
         _loc4_ = new VComponent();
         _loc4_.layoutH = 65;
         _loc4_.addStretch(ClanCenterFactory.createFill());
         var _loc5_:Array = [PCost.create(PCost.GOLD,0),PCost.create(PCost.MITHRIL,0),PCost.create(PCost.OIL,0),PCost.create(PCost.CRYSTAL,0)];
         _loc5_ = CostHelper.mergeCostLists(_loc5_,param3);
         var _loc6_:Array = [PCost.create(PCost.TROPHY,1000),PCost.create(PCost.TROPHY,param1.trophy)];
         _loc7_ = new PriceListPanel();
         _loc7_.priceMode |= PricePanel.ZERO_VISIBLE;
         _loc7_.useVertical();
         _loc7_.assignList(_loc5_);
         _loc4_.add(_loc7_,{
            "left":20,
            "vCenter":4
         });
         for each(_loc8_ in _loc7_.box.list)
         {
            _loc8_.text.layoutW = param2 ? 48 : 43;
         }
         _loc9_ = new PriceListPanel();
         _loc9_.useVertical();
         _loc9_.assignList(_loc6_);
         _loc4_.add(_loc9_,{
            "right":(param2 ? 155 : 15),
            "vCenter":2
         });
         for each(_loc8_ in _loc9_.box.list)
         {
            _loc8_.text.layoutW = param2 ? 48 : 43;
         }
         _loc10_ = _loc9_.box.list[0] as PricePanel;
         SkinManager.applyEmbed(_loc10_.skin,"TerritoryIcon");
         _loc10_.text.value = param1.territories_count.toString() + "/" + Facade.manualProxy.getClanLeagueByNum(param1.base.division).cd_ter_limit;
         _loc10_.hint = Lang.getString("occupied_territory");
         _loc11_ = "";
         if(param1.base.has_capital)
         {
            _loc12_ = Facade.manualProxy.getClanTownHallUnlock(param1.townhall_level);
            _loc11_ += Lang.getString("clan_base") + ": " + CostHelper.getListString(CostHelper.getCostMul(_loc12_.ctu_capital_resources,24 * 60 * 60 / Facade.references.capital_resources_period),18,14,5,0,false);
         }
         if(Boolean(param1.territories) && param1.territories.length > 0)
         {
            _loc11_ += param1.base.has_capital ? "<br/>" + Lang.getString("clan_territory") : Lang.getString("mithril_per_day_desc");
            _loc13_ = [];
            _loc14_ = 0;
            while(_loc14_ < param1.territories.length)
            {
               _loc15_ = param1.territories[_loc14_];
               _loc16_ = Facade.manualProxy.getTerritoryShop(_loc15_.kind);
               _loc17_ = Facade.manualProxy.getMineShop(_loc16_.ter_region,_loc15_.level);
               _loc18_ = _loc16_.ter_resource_cost;
               _loc18_ = CostHelper.mergeCostLists(_loc18_,_loc17_.mine_resource_addition);
               _loc18_ = CostHelper.getCostMul(_loc18_,60 * 60 * 24 / _loc16_.ter_resource_time / _loc17_.mine_time_k);
               if(_loc14_ < 7)
               {
                  _loc11_ += "<br/>" + Lang.getString(_loc15_.kind) + ": " + CostHelper.getListString(_loc18_,18,14,5,0,false);
               }
               else
               {
                  _loc13_ = CostHelper.mergeCostLists(_loc13_,_loc18_);
               }
               _loc14_++;
            }
            if(_loc13_.length > 0)
            {
               _loc11_ += "<br/>" + Lang.getString("other") + ": " + CostHelper.getListString(_loc13_,18,14,5,0,false);
            }
         }
         _loc7_.hint = _loc11_;
         _loc7_.mouseChildren = false;
         if(param2)
         {
            _loc19_ = new RectButton(Lang.getString("to_regions_map"),RectButton.h42,RectButton.ORANGE);
            _loc19_.addVarianceListener(this,ClanCenterFactory.TO_POLITICAL_MAP);
            _loc4_.add(_loc19_,{
               "right":10,
               "vCenter":2,
               "w":125
            });
         }
         add(_loc4_,{
            "wP":100,
            "top":17
         });
      }
   }
}

