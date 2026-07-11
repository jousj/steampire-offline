package ui.game
{
   import ui.common.DurationPanel;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   
   public class PriceListButton extends RectButton
   {
      
      public var priceListPanel:PriceListPanel;
      
      public function PriceListButton(param1:Array, param2:Boolean = true, param3:Number = 0, param4:uint = 8, param5:uint = 0)
      {
         var _loc6_:VComponent = null;
         this.priceListPanel = new PriceListPanel(param4,param5);
         this.priceListPanel.setStyle(26,18);
         this.priceListPanel.useCostCheck = param2;
         if(param3 > 0)
         {
            _loc6_ = new VBox(new <VComponent>[new DurationPanel(26,18,2).setStaticTime(param3),this.priceListPanel],param4);
         }
         else if(param3 == 0)
         {
            _loc6_ = this.priceListPanel;
         }
         else
         {
            _loc6_ = SkinManager.getEmbed("WorkerIcon");
            _loc6_.layoutW = 48;
            _loc6_ = new VBox(new <VComponent>[_loc6_,this.priceListPanel],8);
         }
         super(_loc6_,h56);
         this.priceListPanel.assignList(param1);
      }
   }
}

