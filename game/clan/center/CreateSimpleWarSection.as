package game.clan.center
{
   import proto.model.clan.PWar;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VText;
   
   public class CreateSimpleWarSection extends VComponent
   {
      
      public function CreateSimpleWarSection(param1:PWar)
      {
         var _loc2_:VText = null;
         super();
         layoutH = 65;
         addStretch(ClanCenterFactory.createFill());
         if(param1)
         {
            add(SkinManager.getEmbed("WarFireImg"),{
               "w":60,
               "h":57,
               "left":4,
               "top":6
            });
            add(SkinManager.getEmbed("MoralIcon"),{
               "w":45,
               "left":12,
               "top":16
            });
            _loc2_ = new VText(param1.war_enemy_name,0,15892093,15);
            Style.applyGlowFilter(_loc2_,5898755,6);
            _loc2_.maxH = 33;
            add(new VBox(new <VComponent>[UIFactory.createYellowText(Lang.getString("war_enemy"),VText.CONTAIN,14),_loc2_],5,VBox.VERTICAL | VBox.STRETCH),{
               "left":72,
               "right":10,
               "vCenter":1
            });
         }
         else
         {
            add(SkinManager.getEmbed("PeaceIcon"),{
               "left":20,
               "top":13,
               "w":55
            });
            add(UIFactory.createYellowText(Lang.getString("no_war_status"),VText.CENTER | VText.MIDDLE,15,true),{
               "left":80,
               "right":20,
               "vCenter":1,
               "h":51
            });
         }
      }
   }
}

