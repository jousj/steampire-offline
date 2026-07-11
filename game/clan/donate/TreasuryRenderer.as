package game.clan.donate
{
   import proto.model.PCost;
   import proto.model.clan.PCapitalLog;
   import proto.model.clan.PCapitalLogKind;
   import proto.tuples.str_i;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.vbase.VLabel;
   import ui.vbase.VRenderer;
   import ui.vbase.VText;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class TreasuryRenderer extends VRenderer
   {
      
      private const levelPanel:LevelPanel = new LevelPanel(LevelPanel.size28);
      
      private const nameText:VText = UIFactory.createYellowText(null,VText.CONTAIN);
      
      private const statusText:VText = new VText(null,VText.CONTAIN,Style.metalRGB,14);
      
      private const priceListPanel:PriceListPanel = new PriceListPanel();
      
      private const descLabel:VLabel = new VLabel(null,VLabel.MIDDLE | VLabel.LEADING_BOX | VLabel.CENTER);
      
      private const timeText:VText = new VText(null,0,Style.metalRGB,14);
      
      public function TreasuryRenderer()
      {
         super();
         layoutH = 46;
         add(this.levelPanel,{
            "vCenter":0,
            "left":8
         });
         add(this.nameText,{
            "left":48,
            "w":230,
            "top":7
         });
         add(this.statusText,{
            "left":48,
            "w":230,
            "bottom":4
         });
         add(this.descLabel,{
            "left":290,
            "w":210,
            "hP":100
         });
         add(this.priceListPanel,{
            "left":508,
            "vCenter":0,
            "maxW":116
         });
         add(this.timeText,{
            "right":6,
            "vCenter":0
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc5_:String = null;
         var _loc2_:PCapitalLog = param1 as PCapitalLog;
         this.levelPanel.changeSNetwork(_loc2_.cl_snetwork);
         this.levelPanel.value = _loc2_.cl_level;
         this.nameText.value = _loc2_.cl_name;
         this.statusText.value = Lang.getString("clan_role" + _loc2_.cl_role.variance);
         this.priceListPanel.priceMode = (_loc2_.cl_costs.length > 1 ? PricePanel.GLOW_FILTER : PricePanel.GLOW_FILTER) | PricePanel.CLAN;
         var _loc3_:PCapitalLogKind = _loc2_.cl_kind;
         var _loc4_:uint = _loc3_.variance;
         if(_loc4_ != PCapitalLogKind.DONATE && _loc4_ != PCapitalLogKind.CANCEL && _loc4_ != PCapitalLogKind.WIN_WAR)
         {
            if(_loc4_ == PCapitalLogKind.BUY_RESOURCES)
            {
               _loc4_ = PCapitalLogKind.BUY;
            }
            this.priceListPanel.priceMode |= PricePanel.NEGATIVE;
         }
         this.priceListPanel.assignList(_loc2_.cl_costs);
         if(_loc4_ == PCapitalLogKind.BUY_CAPITAL)
         {
            _loc5_ = Lang.getString("capital_log_" + PCapitalLogKind.BUY) + "\n" + Lang.getString("clan_base");
         }
         else
         {
            _loc5_ = Lang.getString("capital_log_" + _loc4_);
            if(_loc4_ == PCapitalLogKind.WIN_WAR || _loc4_ == PCapitalLogKind.LOSE_WAR)
            {
               if(_loc3_.value > 0)
               {
                  this.priceListPanel.addCost(PCost.create(PCost.TROPHY,_loc3_.value));
               }
            }
            else if(_loc3_.value is str_i)
            {
               _loc5_ += "\n" + StringHelper.getUnitName(_loc3_.value.field_0,_loc3_.value.field_1,18,Style.metalColor);
            }
            else if(_loc3_.value is String)
            {
               _loc5_ += "\n" + Lang.getString(_loc3_.value);
            }
            else if(_loc3_.value is PCost)
            {
               _loc5_ += "\n" + CostHelper.getClanString(PCost(_loc3_.value).variance,PCost(_loc3_.value).value,false,18,14,0);
            }
         }
         this.descLabel.text = "<div lineHeight=\"100%\"" + Style.metalColor + " fontSize=\"14\">" + _loc5_ + "</div>";
         this.timeText.value = StringHelper.getDateDesc(_loc2_.cl_time);
      }
   }
}

