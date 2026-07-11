package game.clan.center
{
   import proto.model.clan.PClan;
   import proto.model.clan.PEntryPolicy;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class CreateJoinClanSection extends VComponent
   {
      
      public function CreateJoinClanSection(param1:PClan, param2:Boolean, param3:uint, param4:uint)
      {
         var _loc5_:uint = 0;
         var _loc6_:VText = null;
         var _loc7_:RectButton = null;
         var _loc8_:VSkin = null;
         super();
         _loc5_ = param1.base.entry_policy.variance;
         layoutH = 90;
         add(ClanCenterFactory.createFill(),{
            "wP":100,
            "top":20,
            "bottom":0
         });
         add(UIFactory.createYellowText(Lang.getString("clan_policy_title"),VText.CONTAIN,15),{
            "left":18,
            "right":2
         });
         _loc6_ = new VText(Lang.getString("clan_policy" + _loc5_),VText.CENTER,_loc5_ != PEntryPolicy.CLOSED ? Style.greenRGB : Style.redRGB,20);
         _loc6_.maxH = 44;
         if(param2 && _loc5_ != PEntryPolicy.CLOSED && param1.base.min_level <= param4 && param1.members.length < param3)
         {
            _loc7_ = new RectButton(Lang.getString(_loc5_ == PEntryPolicy.FREE ? "clan_join" : "clan_on_demand"),RectButton.h30,RectButton.GREEN);
            _loc7_.maxW = 100;
            _loc7_.addVarianceListener(this,ClanCenterFactory.JOIN);
            add(new VBox(new <VComponent>[_loc7_,_loc6_.assignMaxW(160)],16),{
               "hCenter":0,
               "vCenter":11
            });
         }
         else if(_loc5_ == PEntryPolicy.CLOSED)
         {
            _loc8_ = SkinManager.getEmbed("LockIcon");
            _loc8_.layoutH = 45;
            add(new VBox(new <VComponent>[_loc8_,_loc6_.assignMaxW(160)],16),{
               "hCenter":0,
               "vCenter":11
            });
         }
         else
         {
            add(_loc6_,{
               "left":10,
               "right":10,
               "vCenter":9
            });
         }
      }
   }
}

