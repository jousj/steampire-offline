package game.clan.war
{
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class StormProgressPanel extends VComponent
   {
      
      public const bt:CircleButton;
      
      public const text:VText;
      
      public function StormProgressPanel()
      {
         var _loc1_:VSkin = null;
         var _loc2_:VBox = null;
         this.bt = new CircleButton(SkinManager.getEmbed("SearchIcon"),CircleButton.GOLD,CircleButton.size42);
         this.text = UIFactory.createYellowText(null);
         super();
         setSize(162,42);
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "left":0,
            "h":32,
            "vCenter":0,
            "right":20
         });
         this.bt.hint = Lang.getString("to_friend");
         this.bt.addVarianceListener(this,21);
         this.bt.right = 0;
         addChild(this.bt);
         _loc1_ = SkinManager.getEmbed("DamageIcon");
         _loc1_.layoutH = 42;
         _loc2_ = new VBox(new <VComponent>[_loc1_,this.text]);
         _loc2_.hint = Lang.getString("damage_count");
         _loc2_.hCenter = -15;
         addChild(_loc2_);
      }
   }
}

