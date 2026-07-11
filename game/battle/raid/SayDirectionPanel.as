package game.battle.raid
{
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class SayDirectionPanel extends VComponent
   {
      
      public function SayDirectionPanel()
      {
         super();
         setSize(96,96);
         var _loc1_:VSkin = SkinManager.getEmbed("BoardMoveBg",VSkin.STRETCH);
         _loc1_.setPadding(10);
         addChild(_loc1_);
         add(SkinManager.getEmbed("TargetIcon"),{
            "vCenter":0,
            "hCenter":0
         });
         this.addButton(2);
         this.addButton(1).hCenter = 0;
         this.addButton(8).right = 0;
         this.addButton(7).assignLayout({
            "right":0,
            "vCenter":0
         });
         this.addButton(6).assignLayout({
            "right":0,
            "bottom":0
         });
         this.addButton(5).assignLayout({
            "hCenter":0,
            "bottom":0
         });
         this.addButton(4).bottom = 0;
         this.addButton(3).vCenter = 0;
      }
      
      private function addButton(param1:uint) : RectButton
      {
         var _loc2_:RectButton = new RectButton(SkinManager.getEmbed("AttackDirection" + param1));
         _loc2_.setSize(30,30);
         _loc2_.addVarianceListener(this,param1);
         addChild(_loc2_);
         return _loc2_;
      }
   }
}

