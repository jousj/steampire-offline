package game.offer
{
   import flash.events.MouseEvent;
   import game.shop.ShopMediator;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import proto.model.POffer;
   import proto.model.PShopOffer;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.DurationPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class OfferOk
   {
      
      public static const kind:String = "ok_ticket";
      
      public function OfferOk()
      {
         super();
      }
      
      public static function checkRun() : void
      {
         var duration:Number = NaN;
         var startTime:Number = new Date(2017,5,28,0,0,0,0).time / 1000;
         duration = (24 * 3 - 0) * 60 * 60;
         if(CoreLogic.serverTime >= startTime && CoreLogic.serverTime < startTime + duration)
         {
            try
            {
               Facade.manualProxy.getOfferShop(kind);
            }
            catch(error:Error)
            {
               Facade.manualProxy.offerShopList.push(PShopOffer.create(kind,null,duration,0,0,null,0,0,null,false));
            }
            ActionLogic.addOffer(POffer.create(kind,startTime,false),true);
         }
      }
      
      public static function setButtonIcon(param1:VButton) : void
      {
         SkinManager.applyExternal(param1.icon as VSkin,"OkTicketOffer","BtIcon",SkinManager.LOAD_CLIP);
      }
      
      public static function createDialog(param1:POffer) : BaseDialog
      {
         var _loc2_:BaseDialog = new BaseDialog();
         _loc2_.setSize(878,488);
         var _loc3_:VSkin = SkinManager.getPack("OkTicketOffer","DialogBg");
         _loc2_.add(_loc3_);
         _loc2_.add(UIFactory.createDecorText("Уникальное предложение!",true,32,700,false),{
            "hCenter":0,
            "top":16
         });
         _loc2_.add(UIFactory.createYellowText(Lang.getString("ok_ticket_desc"),VText.CENTER,19),{
            "vCenter":-141,
            "hCenter":1,
            "w":630
         });
         _loc2_.add(new VBox(new <VComponent>[UIFactory.createYellowText("До конца акции осталось:",0,20),new DurationPanel(32).setTrackTime(param1.offer_start_time + Facade.manualProxy.getOfferShop(param1.offer_kind).offer_duration,true)],8),{
            "hCenter":0,
            "top":362
         });
         var _loc4_:VButton = new VButton();
         _loc4_.addStretch(SkinManager.getPack("OkTicketOffer","BuyBt",VSkin.STRETCH));
         _loc4_.setIcon(UIFactory.createYellowText("Купить золото!",VText.CENTER | VText.MIDDLE,20),{
            "left":17,
            "right":18,
            "top":10,
            "bottom":11
         });
         _loc2_.add(_loc4_,{
            "hCenter":0,
            "bottom":0
         });
         _loc4_.addClickListener(onClick,_loc2_);
         if(!_loc3_.isContent)
         {
            _loc3_.useCustomLoadClip(UIFactory.createLoadPanel(_loc2_,{
               "wP":100,
               "hP":100
            }));
         }
         _loc2_.addCloseButton({
            "top":13,
            "right":15
         });
         return _loc2_;
      }
      
      private static function onClick(param1:MouseEvent) : void
      {
         DialogLogic.openShop(ShopMediator.CURRENCY);
         ((param1.currentTarget as VButton).data as BaseDialog).close();
      }
   }
}

