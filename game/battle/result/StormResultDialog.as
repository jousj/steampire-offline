package game.battle.result
{
   import game.feature.CampSoldierPanel;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class StormResultDialog extends BaseDialog
   {
      
      public var toStormBt:RectButton;
      
      public function StormResultDialog(param1:Boolean, param2:uint, param3:Array, param4:uint, param5:String, param6:Boolean, param7:Boolean = false)
      {
         var _loc11_:CampSoldierPanel = null;
         super();
         var _loc8_:Boolean = param4 > 0;
         var _loc9_:Boolean = param7 && param6 && param1;
         setSize(570,424);
         var _loc10_:int = 50;
         add(SkinManager.getEmbed("PaperDialogBg",VSkin.STRETCH),{
            "wP":100,
            "hP":100,
            "hCenter":_loc10_ - 10
         });
         add(SkinManager.getExternal("jaina",SkinManager.PNG),{
            "left":-180,
            "vCenter":0
         });
         add(UIFactory.createDecorText(Lang.getString("storm_result"),true,38,390),{
            "top":(_loc8_ || _loc9_ ? 18 : 30),
            "hCenter":_loc10_
         });
         this.addStat(_loc8_ || _loc9_ ? 80 : 105,_loc10_,param1 ? "regent_damage" : "capital_damage",param2 + "%","DamageIcon",48);
         if(_loc8_)
         {
            this.addStat(136,_loc10_,"storm_ratio",param4.toString(),"RatingIcon",40);
         }
         if(_loc9_)
         {
            add(new StatPanel(SkinManager.getEmbed("ClanEmblemIcon"),Facade.references.terra_win,StatPanel.YELLOW_TEXT,3,42,24),{
               "hCenter":_loc10_,
               "top":135
            });
         }
         add(SkinManager.getPack("BattleResultDialog","DSeparator"),{
            "top":(_loc8_ || _loc9_ ? 194 : 174),
            "hCenter":_loc10_,
            "w":394
         });
         param4 = _loc8_ || _loc9_ ? 108 : 124;
         if(param3.length > 0)
         {
            _loc11_ = new CampSoldierPanel(Lang.getString("your_loss"));
            _loc11_.setDp(param3,3);
            add(_loc11_,{
               "bottom":param4,
               "hCenter":_loc10_
            });
         }
         else
         {
            add(new VText(Lang.getString("lossless"),VText.MIDDLE | VText.CENTER,Style.metalRGB,22),{
               "w":342,
               "bottom":param4,
               "h":90,
               "hCenter":_loc10_
            });
         }
         closeBt = new RectButton(Lang.getString("bt_good"),RectButton.h56,RectButton.GREEN);
         closeBt.addClickListener(close);
         this.toStormBt = new RectButton(Lang.getString(param5),RectButton.h56,RectButton.ORANGE);
         if(param6)
         {
            add(new VBox(new <VComponent>[closeBt],14),{
               "bottom":(_loc8_ || _loc9_ ? 32 : 40),
               "hCenter":_loc10_
            });
         }
         else
         {
            add(new VBox(new <VComponent>[this.toStormBt,closeBt],14),{
               "bottom":(_loc8_ || _loc9_ ? 32 : 40),
               "hCenter":_loc10_
            });
         }
      }
      
      private function addStat(param1:int, param2:int, param3:String, param4:String, param5:String, param6:int) : void
      {
         var _loc7_:VText = null;
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH_BG),{
            "w":342,
            "top":param1,
            "h":35,
            "hCenter":param2
         });
         _loc7_ = UIFactory.createYellowText(Lang.getString(param3),VText.CONTAIN);
         _loc7_.maxW = 240;
         var _loc8_:VSkin = SkinManager.getEmbed(param5,VSkin.RIGHT);
         _loc8_.setSize(36,param6);
         add(new VBox(new <VComponent>[_loc7_,_loc8_,UIFactory.createYellowText(param4)],4),{
            "hCenter":param2,
            "top":param1 - Math.ceil((_loc8_.layoutH - 35) / 2)
         });
      }
   }
}

