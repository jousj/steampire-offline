package game.clan.center
{
   import flash.display.Shape;
   import game.clan.donate.DonateMediator;
   import proto.model.PClanTownhallUnlock;
   import proto.model.PRole;
   import proto.model.PShopMine;
   import proto.model.PShopTerritory;
   import proto.model.PTerritoryLevel;
   import proto.model.clan.PClan;
   import proto.tuples.i_i;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import utils.CostHelper;
   
   public class ClanCenterDialog extends BaseDialog
   {
      
      private var cur_season:int = 0;
      
      private var box:VBox = new VBox(null,20,VBox.CENTER);
      
      private var cnt_left:VComponent = new VComponent();
      
      private var cnt_right:VComponent = new VComponent();
      
      private var left_box:VBox = new VBox(null,20,VBox.STRETCH | VBox.VERTICAL);
      
      private var right_box:VBox = new VBox(null,5,VBox.STRETCH | VBox.VERTICAL);
      
      private var bg:VSkin = new VSkin();
      
      public function ClanCenterDialog(param1:Boolean, param2:int)
      {
         super();
         setSize(920,610);
         add(this.bg,{
            "left":-2,
            "right":-6,
            "top":-5,
            "w":-100
         });
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.beginFill(16711680);
         _loc3_.graphics.moveTo(-2,12);
         _loc3_.graphics.lineTo(10,0);
         _loc3_.graphics.lineTo(layoutW + 8 - 14,0);
         _loc3_.graphics.lineTo(layoutW + 8,14);
         _loc3_.graphics.lineTo(layoutW + 8,layoutH - 12);
         _loc3_.graphics.lineTo(layoutW + 8 - 12,layoutH + 2);
         _loc3_.graphics.lineTo(10,layoutH + 2);
         _loc3_.graphics.lineTo(-2,layoutH - 12);
         _loc3_.graphics.lineTo(-2,12);
         _loc3_.graphics.endFill();
         addChild(_loc3_);
         this.bg.mask = _loc3_;
         this.bg.alpha = 0.7;
         this.cur_season = param2;
         add(this.box,{
            "hCenter":0,
            "top":10,
            "bottom":10
         });
         this.box.add(this.cnt_left,{"h":-100});
         this.box.add(this.cnt_right,{"h":-100});
         var _loc4_:VFill = new VFill(14137231,0.9,10);
         _loc4_.setLine(1,0,0.2);
         this.cnt_left.addStretch(_loc4_);
         var _loc5_:VFill = new VFill(14137231,0.9,10);
         _loc5_.setLine(1,0,0.2);
         this.cnt_right.addStretch(_loc5_);
         this.cnt_left.add(this.left_box,{
            "vCenter":0,
            "left":20,
            "right":20
         });
         this.cnt_right.add(this.right_box,{
            "vCenter":0,
            "left":20,
            "right":20
         });
      }
      
      public static function getResPerDay(param1:PClan) : Array
      {
         var _loc2_:PTerritoryLevel = null;
         var _loc3_:PClanTownhallUnlock = null;
         var _loc4_:Array = null;
         var _loc5_:PShopTerritory = null;
         var _loc6_:PShopMine = null;
         var _loc7_:Array = null;
         if(param1.base.has_capital)
         {
            _loc3_ = Facade.manualProxy.getClanTownHallUnlock(param1.townhall_level);
            _loc4_ = CostHelper.getCostMul(_loc3_.ctu_capital_resources,24 * 60 * 60 / Facade.references.capital_resources_period);
         }
         else
         {
            _loc4_ = [];
         }
         for each(_loc2_ in param1.territories)
         {
            _loc5_ = Facade.manualProxy.getTerritoryShop(_loc2_.kind);
            _loc6_ = Facade.manualProxy.getMineShop(_loc5_.ter_region,_loc2_.level);
            _loc7_ = _loc5_.ter_resource_cost;
            _loc7_ = CostHelper.mergeCostLists(_loc7_,_loc6_.mine_resource_addition);
            _loc7_ = CostHelper.getCostMul(_loc7_,60 * 60 * 24 / _loc5_.ter_resource_time / _loc6_.mine_time_k);
            _loc4_ = CostHelper.mergeCostLists(_loc4_,_loc7_);
         }
         return _loc4_;
      }
      
      public function createNoClanPanel() : void
      {
         SkinManager.applyExternal(this.bg,UIFactory.POLITICAL_PACK,"map1");
         this.left_box.removeAll(true);
         this.right_box.removeAll(true);
         this.left_box.layoutW = 230;
         this.right_box.layoutW = 560;
         this.left_box.add(this.cr(new CreateTopClansSection()),{
            "hCenter":0,
            "vCenter":0
         });
         this.left_box.add(this.cr(new CreateNewClanSection()),{
            "hCenter":0,
            "vCenter":0
         });
         this.right_box.add(this.cr(new CreateWarPromoSection()),{
            "hCenter":0,
            "vCenter":0
         });
         this.right_box.add(this.cr(new CreateMapPromoSection()),{
            "hCenter":0,
            "vCenter":0
         });
      }
      
      private function cr(param1:VComponent) : VComponent
      {
         param1.dispatcher = this;
         return param1;
      }
      
      public function createClanPanel(param1:PClan, param2:Array, param3:uint, param4:uint, param5:uint, param6:i_i) : void
      {
         SkinManager.applyExternal(this.bg,UIFactory.POLITICAL_PACK,"map" + Facade.userProxy.clanData.base.division);
         this.left_box.removeAll(true);
         this.right_box.removeAll(true);
         this.left_box.layoutW = 280;
         this.right_box.layoutW = 510;
         syncLayout();
         var _loc7_:DonateMediator = new DonateMediator();
         this.left_box.add(this.cr(new CreateCaptionSection(param1.base,param1.clan_comp_place_opt,param4,true,true,param1.wins)),{
            "hCenter":0,
            "vCenter":0
         });
         this.left_box.add(this.cr(new CreateDescSection(param1.base.description,120)),{
            "hCenter":0,
            "vCenter":0
         });
         this.left_box.add(this.cr(new CreateMemberSection(param2,param1.members.length,param3,param5 != PRole.CREATOR || param1.members.length == 1)),{
            "hCenter":0,
            "vCenter":0
         });
         this.right_box.add(this.cr(param1.base.has_capital ? new CreateCapitalSection(param1,true) : new CreateNoCapitalSection(param1.base.gold,true)),{
            "hCenter":0,
            "vCenter":0
         });
         this.right_box.add(this.cr(new CreateDomainSection(param1,true,getResPerDay(param1))),{
            "hCenter":0,
            "vCenter":0
         });
         this.right_box.add(_loc7_.createPanel(),{
            "hCenter":0,
            "vCenter":0,
            "h":350
         });
      }
   }
}

