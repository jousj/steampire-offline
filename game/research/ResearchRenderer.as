package game.research
{
   import game.barrack.BarrackBuyRenderer;
   import model.ui.VOBarrackItem;
   import proto.model.PShopUnit;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   
   public class ResearchRenderer extends BarrackBuyRenderer
   {
      
      public function ResearchRenderer()
      {
         super();
      }
      
      override protected function showItem(param1:VOBarrackItem) : void
      {
         var _loc3_:VSkin = null;
         initBuyBt(param1);
         var _loc2_:PShopUnit = param1.shop;
         if(param1.flag || param1.isResearchRun)
         {
            if(param1.flag)
            {
               buyBt.disabled = true;
            }
            _loc3_ = getContextComponent(VSkin);
            if(_loc3_)
            {
               _loc3_.visible = true;
            }
            else
            {
               contextComponent = _loc3_ = new VSkin();
               add(_loc3_,{
                  "bottom":18,
                  "hCenter":0,
                  "h":44
               });
            }
            SkinManager.applyEmbed(_loc3_,param1.flag ? "CollectIcon" : "ClockIcon");
         }
         else if(buyBt.disabled)
         {
            applyReq(param1);
         }
         else if(_loc2_.su_upgrade_price.length == 1)
         {
            showPrice(_loc2_.su_upgrade_price[0]);
         }
         else
         {
            showPriceList(_loc2_.su_upgrade_price);
         }
      }
      
      override protected function showEmpty() : void
      {
         super.showEmpty();
         if(contextComponent is VSkin)
         {
            contextComponent.visible = false;
         }
      }
   }
}

