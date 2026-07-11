package game.clan.center
{
   import proto.model.PCost;
   import proto.model.clan.PBase;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VText;
   
   public class CreateResourceSection extends VComponent
   {
      
      public function CreateResourceSection(param1:PBase, param2:Boolean)
      {
         var _loc3_:RectButton = null;
         var _loc4_:RectButton = null;
         super();
         layoutH = 107;
         add(UIFactory.createYellowText(Lang.getString("clan_resources"),VText.CONTAIN,15),{
            "left":20,
            "right":2
         });
         add(ClanCenterFactory.createFill(),{
            "wP":100,
            "top":20,
            "bottom":0
         });
         add(ClanCenterFactory.createResourcePanel(PCost.GOLD,param1.gold),{
            "left":18,
            "top":32,
            "maxW":130
         });
         add(ClanCenterFactory.createResourcePanel(PCost.MITHRIL,param1.mithril),{
            "left":18,
            "bottom":10,
            "maxW":130
         });
         add(ClanCenterFactory.createResourcePanel(PCost.OIL,param1.oil),{
            "left":162,
            "top":32,
            "maxW":166
         });
         add(ClanCenterFactory.createResourcePanel(PCost.CRYSTAL,param1.crystal),{
            "left":162,
            "bottom":10,
            "maxW":166
         });
         if(param2)
         {
            _loc3_ = new RectButton(Lang.getString("to_treasure"),RectButton.h30,RectButton.ORANGE);
            _loc3_.addVarianceListener(this,ClanCenterFactory.TREASURY);
            add(_loc3_,{
               "right":8,
               "top":29,
               "w":125
            });
            _loc4_ = RectButton.createIconAndTitle30(SkinManager.getEmbed("DonateIcon"),Lang.getString("donateBt"));
            _loc4_.addVarianceListener(this,ClanCenterFactory.DONATE);
            add(_loc4_,{
               "right":8,
               "bottom":7,
               "w":125
            });
         }
      }
   }
}

