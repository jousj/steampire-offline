package game.offer
{
   import proto.model.POffer;
   
   public class OfferHalloween
   {
      
      private static var isBanner:Boolean;
      
      public function OfferHalloween()
      {
         super();
      }
      
      public static function showBanner(param1:Array) : void
      {
         var _loc4_:POffer = null;
         if(isBanner)
         {
            return;
         }
         var _loc2_:Array = ["so_daily_281015","so_daily_291015","so_daily_301015","so_daily_311015","so_daily_011115","so_daily_021115","so_daily_031115"];
         var _loc3_:int = -1;
         for each(_loc4_ in param1)
         {
            _loc3_ = _loc2_.indexOf(_loc4_.offer_kind);
            if(_loc3_ >= 0)
            {
               break;
            }
         }
         if(_loc3_ >= 0)
         {
            isBanner = true;
            Facade.myMediator.openOfferDialog(_loc4_.offer_kind);
         }
      }
   }
}

