package game.clan.donate
{
   import model.CommonEvent;
   import proto.model.PCost;
   import proto.model.clan.PBase;
   import proto.model.clan.PClan;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   
   public class TreasuryPanel extends VComponent
   {
      
      public static const DONATE:uint = 1;
      
      public static const DONATE_REPORT:uint = 2;
      
      public static const DONATE_ALERT:uint = 3;
      
      public var grid:VGrid;
      
      public function TreasuryPanel(param1:PClan, param2:Boolean, param3:uint)
      {
         var _loc8_:VText = null;
         super();
         add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH),{
            "wP":100,
            "h":124
         });
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "left":24,
            "right":24,
            "top":34,
            "h":57
         });
         add(UIFactory.createYellowText(Lang.getString("clan_resources"),VText.CONTAIN_CENTER),{
            "left":20,
            "right":20,
            "top":13
         });
         var _loc4_:PBase = param1.base;
         add(new VBox(new <VComponent>[createResPanel(PCost.GOLD,_loc4_.gold,0,150),createResPanel(PCost.MITHRIL,_loc4_.mithril,Facade.references.clan_mithril_limit,150),createResPanel(PCost.OIL,_loc4_.oil,param1.storage_max_oil),createResPanel(PCost.CRYSTAL,_loc4_.crystal,param1.storage_max_crystal)],8),{
            "top":44,
            "hCenter":0
         });
         this.grid = new VGrid(1,param2 ? 7 : 8,TreasuryRenderer,null,0,0,VGrid.H_STRETCH);
         var _loc5_:int = 136;
         add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH),{
            "top":_loc5_,
            "wP":100,
            "h":(param2 ? 343 : 389)
         });
         _loc5_ += 8;
         var _loc6_:int = int(this.grid.renderList[0].measuredHeight);
         var _loc7_:int = 1;
         while(_loc7_ < this.grid.vCount)
         {
            add(new VFill(12893879),{
               "h":_loc6_,
               "top":_loc5_ + _loc6_ * _loc7_,
               "left":13,
               "right":11
            });
            _loc7_ += 2;
         }
         add(new VFill(16777215,0.15),{
            "right":10,
            "top":_loc5_ + 2,
            "w":128,
            "h":(param2 ? 320 : 366)
         });
         add(this.grid,{
            "left":13,
            "right":11,
            "top":_loc5_ - 1
         });
         this.grid.emptyFactory = this.emptyFactory;
         UIFactory.useGridControlNav(this.grid,UIFactory.addNavBt30);
         this.grid.setDataProvider(param1.capital_log,param3);
         if(param2)
         {
            _loc8_ = UIFactory.createYellowText(Lang.getString("money_report"),VText.CONTAIN,16);
            _loc8_.maxW = 100;
            add(new VBox(new <VComponent>[_loc8_,this.createBt(DONATE_REPORT,PCost.GOLD),this.createBt(DONATE_REPORT,PCost.MITHRIL),this.createBt(DONATE_REPORT,PCost.OIL),this.createBt(DONATE_REPORT,PCost.CRYSTAL),this.createBt(DONATE_ALERT,null,"BHornIcon","require_donate",RectButton.YELLOW,148)],10),{
               "bottom":2,
               "hCenter":0
            });
         }
      }
      
      public static function createResPanel(param1:uint, param2:int, param3:uint, param4:int = 192) : ResourcePanel
      {
         var _loc5_:uint = uint(ResourcePanel.BG | ResourcePanel.CLAN);
         if(param3 > 0)
         {
            _loc5_ |= ResourcePanel.PROGRESS;
         }
         var _loc6_:ResourcePanel = new ResourcePanel(param1,_loc5_);
         _loc6_.layoutW = param4;
         if(param3 > 0)
         {
            _loc6_.setMax(param3);
         }
         _loc6_.cur = param2;
         Facade.addListenerForComponent(CommonEvent.CLAN_RESOURCE,_loc6_.onTrack,_loc6_);
         return _loc6_;
      }
      
      private function createBt(param1:uint, param2:Object, param3:String = null, param4:String = null, param5:String = null, param6:int = 124) : RectButton
      {
         if(!param3)
         {
            param3 = CostHelper.getKind(uint(param2),true);
            param4 = CostHelper.getKind(uint(param2));
         }
         var _loc7_:RectButton = RectButton.createIconAndTitle30(SkinManager.getEmbed(param3),Lang.getString(param4 ? param4 : param3),param6,param5 ? param5 : RectButton.GREEN);
         _loc7_.minW = 110;
         _loc7_.addVarianceListener(this,param1,param2);
         return _loc7_;
      }
      
      private function emptyFactory() : VComponent
      {
         var _loc1_:VText = new VText(Lang.getString("capital_log_empty"),VText.CENTER,Style.darkKhakiRGB);
         _loc1_.assignLayout({
            "vCenter":1,
            "left":50,
            "right":50
         });
         return _loc1_;
      }
   }
}

