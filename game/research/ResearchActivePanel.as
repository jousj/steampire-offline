package game.research
{
   import engine.signal.Signal;
   import game.barrack.BarrackDialog;
   import logic.ShopLogic;
   import proto.model.PCost;
   import proto.model.PShopUnit;
   import ui.Style;
   import ui.common.RectButton;
   import ui.game.PriceButton;
   import ui.game.PricePanel;
   import ui.game.SquareSoldierPanel;
   import ui.game.UnitProgressBar;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import utils.StringHelper;
   
   public class ResearchActivePanel extends VComponent
   {
      
      private var speedupBt:RectButton;
      
      public function ResearchActivePanel(param1:PShopUnit, param2:Number, param3:Number)
      {
         super();
         layoutH = 96;
         var _loc4_:SquareSoldierPanel = new SquareSoldierPanel();
         _loc4_.assignShopUnit(param1);
         add(_loc4_,{
            "w":102,
            "h":98,
            "vCenter":0
         });
         add(new VLabel("<p" + Style.metalColor + ">" + Lang.getPatternString("research_run","__NAME__",StringHelper.getUnitName(param1.su_kind,param1.su_level)) + "</p>",VLabel.CONTAIN),{
            "left":116,
            "right":160,
            "top":7
         });
         var _loc5_:UnitProgressBar = new UnitProgressBar(null,20,32);
         _loc5_.setTimerValue(param2,param1.su_upgrade_time);
         add(_loc5_,{
            "left":111,
            "right":160,
            "h":54,
            "bottom":6
         });
         var _loc6_:RectButton = new RectButton(Lang.getString("move_cancel"),RectButton.h30,RectButton.ORANGE);
         _loc6_.addVarianceListener(this,BarrackDialog.CLEAR,param1);
         param3 -= ShopLogic.getSpeedupFreeTime();
         this.speedupBt = param3 > 0 ? new RectButton(Lang.getString("speedupBt"),RectButton.h56) : new PriceButton(false);
         this.speedupBt.addVarianceListener(this,BarrackDialog.SPEEDUP);
         add(new VBox(new <VComponent>[_loc6_,this.speedupBt],12,VBox.VERTICAL),{
            "right":0,
            "vCenter":2,
            "w":150
         });
         if(param3 > 0)
         {
            Signal.createRef(this,this.onFree,0,0,false).delayCall(param3);
         }
         else
         {
            this.onFree();
         }
      }
      
      private function onFree() : void
      {
         var _loc1_:PricePanel = this.speedupBt.icon as PricePanel;
         if(!_loc1_)
         {
            _loc1_ = new PricePanel(26,18,PricePanel.GLOW_FILTER);
            this.speedupBt.setIcon(_loc1_,{
               "hCenter":0,
               "vCenter":-2
            });
         }
         _loc1_.assign(PCost.GOLD,0);
      }
      
      override public function dispose() : void
      {
         Signal.stopRef(this);
         super.dispose();
      }
   }
}

