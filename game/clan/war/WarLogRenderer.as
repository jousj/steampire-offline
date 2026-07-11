package game.clan.war
{
   import logic.CoreLogic;
   import proto.model.clan.PWarLog;
   import proto.model.clan.PWarLogKind;
   import proto.model.clan.PWarPvp;
   import proto.tuples.str_i;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VDock;
   import ui.vbase.VLabel;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class WarLogRenderer extends VRenderer
   {
      
      private const levelPanel:LevelPanel = new LevelPanel(LevelPanel.size28);
      
      private const nameText:VText = UIFactory.createYellowText(null,VText.CONTAIN);
      
      private const statusText:VText = new VText(null,VText.CONTAIN,Style.metalRGB,14);
      
      private const descLabel:VLabel = new VLabel(null,VLabel.MIDDLE | VLabel.LEADING_BOX | VLabel.CENTER);
      
      private const timeText:VText = new VText(null,VText.CONTAIN_CENTER,Style.metalRGB,14);
      
      private var panel:VComponent;
      
      public function WarLogRenderer()
      {
         super();
         layoutH = 47;
         add(this.levelPanel,{
            "vCenter":0,
            "left":8
         });
         add(this.nameText,{
            "left":48,
            "w":210,
            "top":7
         });
         add(this.statusText,{
            "left":48,
            "w":210,
            "bottom":5
         });
         add(this.descLabel,{
            "left":266,
            "w":190,
            "hP":100
         });
         add(this.timeText,{
            "right":3,
            "vCenter":1,
            "w":116
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PWarLog = null;
         var _loc3_:PWarLogKind = null;
         var _loc4_:PWarPvp = null;
         var _loc5_:String = null;
         var _loc6_:VBox = null;
         var _loc7_:Array = null;
         var _loc8_:VDock = null;
         var _loc9_:str_i = null;
         _loc2_ = param1 as PWarLog;
         this.levelPanel.changeSNetwork(_loc2_.wl_snetwork);
         this.levelPanel.value = _loc2_.wl_user_level;
         this.nameText.value = _loc2_.wl_user_name;
         this.statusText.value = Lang.getString("clan_role" + _loc2_.wl_user_role.variance);
         this.timeText.value = Lang.getPatternString("time_ago","__TIME__",StringHelper.getTimeDesc(CoreLogic.serverTime - _loc2_.wl_time));
         _loc3_ = _loc2_.wl_kind;
         switch(_loc3_.variance)
         {
            case PWarLogKind.WAR_PVP:
               _loc4_ = _loc3_.value;
               _loc5_ = Lang.getPatternString("war_log_pvp","__NAME__",StringHelper.getUnitName(_loc4_.target_name,_loc4_.target_level,18,null,false));
               if(this.panel is StatPanel)
               {
                  (this.panel as StatPanel).value = _loc4_.inc_warpoints;
                  break;
               }
               this.changePanel(this.createStatPanel("MoralIcon",_loc4_.inc_warpoints,"war_points",null,30,3,18),{
                  "vCenter":0,
                  "hCenter":168
               });
               break;
            case PWarLogKind.USE_WORKER:
               _loc5_ = Lang.getString("war_log_worker");
               _loc6_ = new VBox();
               for each(_loc9_ in _loc3_.value)
               {
                  this.createStatPanel(SkinManager.getExternal(_loc9_.field_0 + "1_m",SkinManager.PNG),_loc9_.field_1,_loc9_.field_0,_loc6_,35);
               }
               this.changePanel(_loc6_,{
                  "vCenter":0,
                  "hCenter":168
               });
               break;
            case PWarLogKind.USE_UNIT:
            case PWarLogKind.USE_SPELL:
               _loc5_ = Lang.getString("war_log_storm");
               _loc7_ = _loc3_.value;
               _loc6_ = new VBox();
               if(_loc7_[0] > 0)
               {
                  this.createStatPanel("BarrackIcon",_loc7_[0],"common_army",_loc6_);
               }
               if(_loc7_[1] > 0)
               {
                  this.createStatPanel("EliteIcon",_loc7_[1],"elite_army",_loc6_);
               }
               if(_loc7_[2] > 0)
               {
                  this.createStatPanel("SpellIcon",_loc7_[2],"spells",_loc6_);
               }
               _loc8_ = new VDock();
               _loc8_.add(_loc6_);
               this.changePanel(_loc8_,{
                  "vCenter":2,
                  "right":126,
                  "w":150
               });
         }
         this.descLabel.text = "<div lineHeight=\"100%\"" + Style.metalColor + " fontSize=\"14\">" + _loc5_ + "</div>";
      }
      
      private function createStatPanel(param1:*, param2:uint, param3:String, param4:VBox, param5:uint = 30, param6:uint = 2, param7:uint = 16) : StatPanel
      {
         var _loc8_:StatPanel = new StatPanel(param1 is String ? SkinManager.getEmbed(param1) : param1 as VSkin,param2,StatPanel.YELLOW_TEXT,param6,param5,param7);
         _loc8_.hint = Lang.getString(param3);
         if(param4)
         {
            param4.add(_loc8_);
         }
         return _loc8_;
      }
      
      private function changePanel(param1:VComponent, param2:Object) : void
      {
         if(this.panel)
         {
            remove(this.panel);
         }
         this.panel = param1;
         add(param1,param2);
      }
   }
}

