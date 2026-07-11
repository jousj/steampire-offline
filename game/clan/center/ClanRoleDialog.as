package game.clan.center
{
   import flash.events.MouseEvent;
   import model.ui.VOCallback;
   import proto.model.PCost;
   import proto.model.PShopClanRole;
   import proto.model.clan.PMember;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.LevelPanel;
   import ui.common.RectButton;
   import ui.game.PriceButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VLabel;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class ClanRoleDialog extends BaseDialog
   {
      
      public var member:PMember;
      
      public function ClanRoleDialog(param1:PMember, param2:PShopClanRole, param3:String, param4:Function, param5:Array = null, param6:PCost = null)
      {
         var _loc9_:VButton = null;
         super();
         this.member = param1;
         useWhiteBg(674,0,param3);
         add(SkinManager.getEmbed("TrainArrow",VSkin.FLIP_X),{
            "left":22,
            "top":82,
            "w":400
         });
         add(new LevelPanel(LevelPanel.size28,param1.user_base.level),{
            "left":42,
            "top":112
         });
         add(UIFactory.createYellowText(param1.user_base.name,VText.CONTAIN,20),{
            "left":80,
            "top":107,
            "w":315
         });
         add(new VText(Lang.getString("clan_role" + param1.role.variance),VText.CONTAIN,Style.metalRGB,16),{
            "left":80,
            "top":130,
            "w":315
         });
         var _loc7_:String = "clan_role" + param2.scr_role_kind.variance;
         add(new VText(Lang.getString(_loc7_),VText.CENTER | VText.MIDDLE,Style.metalRGB,20),{
            "right":46,
            "top":85,
            "w":200,
            "h":80
         });
         add(new VFill(12103845),{
            "left":12,
            "right":11,
            "top":180,
            "bottom":110
         });
         if(param6)
         {
            _loc9_ = new PriceButton().assignCost(param6);
            _loc7_ = "<div" + Style.redColor + " paddingTop=\"16\" paddingBottom=\"16\">" + Lang.getPatternString("clan_creator_change","__VALUE__","clan_role" + param1.role.variance,true) + "</div>";
         }
         else
         {
            _loc9_ = new RectButton(Lang.getString("setRoleBt"),RectButton.h56);
            _loc7_ = "<div" + Style.metalColor + ">" + Lang.getPatternString("clan_role_prompt","__ROLE__",_loc7_,true) + "<list textAlign=\"left\" paddingTop=\"10\" fontSize=\"16\">" + Lang.getString(_loc7_ + "_desc") + "</list></div>";
         }
         add(new VLabel(_loc7_,VLabel.CENTER),{
            "left":40,
            "right":40,
            "top":192,
            "bottom":124
         });
         _loc9_.data = new VOCallback(param4,param5);
         _loc9_.addClickListener(this.onOk);
         var _loc8_:RectButton = new RectButton(Lang.getString("cancelBt"),RectButton.h56,RectButton.ORANGE);
         _loc8_.addClickListener(close);
         add(new VBox(new <VComponent>[_loc8_,_loc9_],10),{
            "hCenter":0,
            "bottom":31
         });
      }
      
      private function onOk(param1:MouseEvent) : void
      {
         close();
         ((param1.currentTarget as RectButton).data as VOCallback).apply();
      }
   }
}

