package ui.game
{
   import proto.model.PCost;
   import ui.common.DurationPanel;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   
   public class PriceButton extends RectButton
   {
      
      public const pricePanel:PricePanel;
      
      public function PriceButton(param1:Boolean = true, param2:Number = 0)
      {
         var _loc3_:VComponent = null;
         this.pricePanel = new PricePanel(26,18,PricePanel.GLOW_FILTER);
         if(param2 > 0)
         {
            _loc3_ = new VBox(new <VComponent>[new DurationPanel(26,18,2).setStaticTime(param2),this.pricePanel],8);
         }
         else if(param2 == 0)
         {
            _loc3_ = this.pricePanel;
         }
         else
         {
            _loc3_ = SkinManager.getEmbed("WorkerIcon");
            _loc3_.layoutW = 48;
            _loc3_ = new VBox(new <VComponent>[_loc3_,this.pricePanel],8);
         }
         super(_loc3_,h56);
         this.pricePanel.useCheck = param1;
      }
      
      public function assignCost(param1:PCost) : PriceButton
      {
         this.pricePanel.assignCost(param1);
         return this;
      }
      
      public function assignTime(param1:Number, param2:Number = 0, param3:uint = 0, param4:uint = 0) : PriceButton
      {
         this.pricePanel.runTrackSpeedup(param1,param2,param3,param4);
         return this;
      }
   }
}

