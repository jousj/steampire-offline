package ui.load
{
   import engine.signal.Signal;
   import flash.events.MouseEvent;
   import logic.MainLogic;
   import ui.Style;
   import ui.common.DurationPanel;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class WaitStormPanel extends VComponent
   {
      
      public function WaitStormPanel(param1:Number, param2:Boolean, param3:Boolean, param4:Boolean)
      {
         var _loc5_:RectButton = null;
         super();
         setSize(364,85);
         addStretch(SkinManager.getEmbed("BattleBlock",VSkin.STRETCH));
         add(new VText(Lang.getString(param2 ? "enemy_capital_destroy" : (param3 ? "my_capital_destroy" : "capital_destroy")) + "\n" + Lang.getString("storm_wait"),VText.CENTER | VText.MIDDLE | VText.CONTAIN,Style.yellowRGB,14),{
            "w":250,
            "top":10,
            "hCenter":0
         });
         add(new DurationPanel(32,14).setTrackTime(param1),{
            "hCenter":0,
            "top":45
         });
         if(param4)
         {
            _loc5_ = new RectButton(Lang.getString("to_home"),RectButton.h56);
            _loc5_.addClickListener(this.onClick);
            add(_loc5_,{
               "hCenter":0,
               "bottom":-16
            });
         }
         new Signal(this.onClick).delayCall(param1);
      }
      
      private function onClick(param1:MouseEvent = null) : void
      {
         removeFromParent();
         MainLogic.getMyMap();
      }
   }
}

