package game.clan.center
{
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class CreateMemberSection extends VComponent
   {
      
      public function CreateMemberSection(param1:Array, param2:uint, param3:uint, param4:Boolean)
      {
         var _loc5_:VBox = null;
         var _loc6_:RectButton = null;
         super();
         if(param1)
         {
            layoutH = 188;
            add(new VFill(14077377),{
               "left":3,
               "right":3,
               "top":4,
               "h":142
            });
            add(new VFill(12893879),{
               "left":3,
               "right":3,
               "top":50,
               "h":48
            });
            add(new VGrid(1,3,InfoMemberRenderer,param1,0,0,VGrid.H_STRETCH),{
               "left":2,
               "right":2,
               "top":2
            });
            add(SkinManager.getEmbed("DarkBorder",VSkin.STRETCH),{
               "wP":100,
               "h":150
            });
         }
         _loc5_ = new VBox(null,8);
         _loc6_ = new RectButton(new VBox(new <VComponent>[UIFactory.createYellowText(Lang.getString("bt_members"),VText.CONTAIN,15).assignMaxW(70),SkinManager.getEmbed("HumanIcon"),UIFactory.createYellowText(param2 + "/" + param3,0,15)]),RectButton.h30,RectButton.ORANGE);
         _loc6_.addVarianceListener(this,ClanCenterFactory.MEMBERS);
         _loc5_.add(_loc6_);
         if(param4)
         {
            _loc6_ = new RectButton(Lang.getString(param1.length == 1 ? "clan_revoke" : "clan_leave"),RectButton.h30,RectButton.YELLOW);
            _loc6_.layoutW = 120;
            _loc6_.addVarianceListener(this,ClanCenterFactory.LEAVE);
            _loc5_.add(_loc6_);
         }
         add(_loc5_,{
            "hCenter":0,
            "bottom":0
         });
      }
   }
}

