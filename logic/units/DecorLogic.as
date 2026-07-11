package logic.units
{
   import engine.units.Decor;
   import engine.units.Unit;
   import game.my.MyMediator;
   import logic.ActionLogic;
   import logic.ShopLogic;
   import logic.UnitFactory;
   import proto.game.family_0010.PUserAction;
   import ui.vbase.VComponent;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class DecorLogic extends AbstractLogic
   {
      
      public function DecorLogic()
      {
         super();
      }
      
      override public function getMenu(param1:Unit, param2:Vector.<VComponent>) : void
      {
         MyMediator.commonBt.change("SellIcon",true,Lang.getString("sellBt"),this.sell);
         param2.push(MyMediator.commonBt);
      }
      
      private function sell(param1:Decor) : void
      {
         mainMediator.showYesNoDialog(Lang.getReplaceString("sell_prompt",{
            "__TITLE__":StringHelper.getUnitName(param1.kind,0),
            "__PRICE__":CostHelper.get18StringC(param1.shop.sd_sell_price)
         }),this.confirmSell,[param1]);
      }
      
      public function confirmSell(param1:Decor, param2:Boolean = true) : void
      {
         ShopLogic.applyCost(param1.shop.sd_sell_price);
         userProxy.changeConstructionCount(param1.kind,-1);
         UnitFactory.removeConstruction(param1);
         if(param2)
         {
            ActionLogic.request(PUserAction.SELL_DECOR,param1.id);
         }
      }
   }
}

