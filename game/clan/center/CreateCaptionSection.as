package game.clan.center
{
   import proto.model.PPermission;
   import proto.model.clan.PBase;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class CreateCaptionSection extends VComponent
   {
      
      public function CreateCaptionSection(param1:PBase, param2:uint, param3:uint, param4:Boolean, param5:Boolean, param6:Array)
      {
         var _loc8_:StatPanel = null;
         var _loc9_:StatPanel = null;
         var _loc13_:CircleButton = null;
         var _loc14_:String = null;
         var _loc15_:VComponent = null;
         var _loc16_:RectButton = null;
         super();
         layoutH = param4 ? 205 : 175;
         var _loc7_:int = -103;
         add(ClanCenterFactory.createFill(),{
            "top":8,
            "hCenter":_loc7_,
            "w":85,
            "h":70
         });
         _loc8_ = new StatPanel(SkinManager.getEmbed("ClanEmblemIcon"),param1.clan_points,StatPanel.YELLOW_B_TEXT | StatPanel.VERTICAL,4,35,16);
         _loc8_.hint = Lang.getString("ClanEmblemIcon");
         add(_loc8_,{
            "top":16,
            "hCenter":_loc7_,
            "maxW":81
         });
         _loc7_ = 103;
         add(ClanCenterFactory.createFill(),{
            "top":8,
            "hCenter":_loc7_,
            "w":85,
            "h":70
         });
         _loc9_ = new StatPanel(SkinManager.getEmbed("RatingIcon"),param1.ratio,StatPanel.YELLOW_B_TEXT | StatPanel.VERTICAL,4,35,16);
         _loc9_.hint = Lang.getString("rating");
         add(_loc9_,{
            "top":16,
            "hCenter":_loc7_,
            "maxW":81
         });
         add(SkinManager.getEmbed("RSeparator",VSkin.STRETCH),{
            "wP":100,
            "top":90
         });
         add(SkinManager.getEmbed("TrainCircleBg"),{
            "hCenter":0,
            "w":100,
            "h":100
         });
         add(SkinManager.getPack(UIFactory.EMBLEM_PACK,param1.icon,0,SkinManager.LOAD_CLIP),{
            "top":7,
            "hCenter":0,
            "w":84,
            "h":84
         });
         add(UIFactory.createDecorText(param1.name,true,26,270,false),{
            "hCenter":0,
            "top":101
         });
         if((param3 & 1 << PPermission.INFO) != 0)
         {
            _loc13_ = new CircleButton(SkinManager.getEmbed("SettingGroupIcon"),CircleButton.TEAL,CircleButton.size42);
            _loc13_.addVarianceListener(this,ClanCenterFactory.EDIT_CLAN);
            add(_loc13_,{
               "top":-8,
               "hCenter":36
            });
         }
         switch(param2)
         {
            case 1:
               _loc14_ = "CupIconGold";
               break;
            case 2:
               _loc14_ = "CupIconSilver";
               break;
            case 3:
               _loc14_ = "CupIconBronze";
         }
         var _loc10_:VBox = new VBox(new Vector.<VComponent>(0),8);
         if(_loc14_)
         {
            _loc15_ = SkinManager.getEmbed(_loc14_,VSkin.LEFT);
            _loc15_.setSize(38,26);
            _loc10_.add(_loc15_);
         }
         if(param2 > 10)
         {
            _loc15_ = UIFactory.createYellowText(param2.toString());
         }
         else if(param2 <= 3)
         {
            _loc15_ = UIFactory.createDecorText(param2 == 0 ? "-" : param2.toString(),true,28,36);
         }
         else
         {
            _loc15_ = UIFactory.createGrayDecorText(param2.toString(),28,36);
         }
         _loc10_.add(_loc15_);
         var _loc11_:VText = UIFactory.createYellowText(Lang.getString("clan_top_place"),VText.CONTAIN);
         _loc10_.add(_loc11_);
         if(param4)
         {
            _loc11_.layoutW = -100;
            _loc16_ = new RectButton(Lang.getString("season"),RectButton.h30);
            _loc16_.addVarianceListener(this,ClanCenterFactory.SEASONS);
            _loc10_.add(_loc16_);
            add(_loc10_,{
               "left":16,
               "right":16,
               "bottom":(param4 ? 27 : 0)
            });
         }
         else
         {
            _loc11_.maxW = 130;
            add(_loc10_,{
               "hCenter":0,
               "bottom":(param4 ? 27 : 0)
            });
         }
         var _loc12_:CupPanel = new CupPanel();
         _loc12_.setData(param6);
         if(param4)
         {
            add(_loc12_,{
               "hCenter":0,
               "bottom":0
            });
         }
         else
         {
            _loc10_.add(_loc12_,{
               "hCenter":0,
               "bottom":0
            });
         }
      }
   }
}

