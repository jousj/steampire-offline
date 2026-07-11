package game.radar
{
   import game.common.DialogMediator;
   import logic.CoreLogic;
   import logic.ShopLogic;
   import proto.BinaryBuffer;
   import proto.game.family_0010.Packet_0010_21;
   import proto.game.family_0010.Packet_0010_22;
   import proto.model.PCost;
   import proto.model.PShopScoutingPack;
   import proto.model.PShopSubscription;
   import proto.model.PSubscription;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   
   public class RadarMediator extends DialogMediator
   {
      
      public var dialog:RadarDialog;
      
      public function RadarMediator()
      {
         super();
      }
      
      override public function onAdd() : BaseDialog
      {
         this.dialog = new RadarDialog(Facade.manualProxy.scoutingShopList,Facade.userProxy.base.scouting - CoreLogic.serverTime);
         this.dialog.goldPanel.useTrack();
         this.dialog.blueprintPanel.setMax(Facade.references.blue_print_limit);
         this.dialog.blueprintPanel.useTrack();
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         return this.dialog;
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc3_:PShopScoutingPack = null;
         var _loc4_:PCost = null;
         var _loc5_:PShopSubscription = null;
         var _loc6_:PSubscription = null;
         switch(param1.variance)
         {
            case RadarDialog.BT_PRIME_RESOURCES:
               _loc3_ = param1.data as PShopScoutingPack;
               _loc4_ = _loc3_.sp_price[0];
               if(ShopLogic.checkPrice(_loc4_,this.onVariance,arguments))
               {
                  ShopLogic.applyCost(_loc4_,true);
                  this.dialog.btLock = true;
                  Facade.protoProxy.request(new Packet_0010_21(_loc3_.sp_num),this.resultScouting,16,34);
               }
               break;
            case RadarDialog.BT_PRIME_VOICE:
               Facade.callJS("pay",RadarDialog.OFFER_KIND);
               Facade.log("pay :" + RadarDialog.OFFER_KIND);
               break;
            case RadarDialog.BT_PRIME_SUB:
               _loc5_ = Facade.manualProxy.subscriptions[0];
               Facade.callJS("buySubscription",_loc5_.id);
               break;
            case RadarDialog.BT_PRIME_RESUB:
               _loc6_ = Facade.userProxy.subs;
               _loc5_ = Facade.manualProxy.subscriptions[0];
               if(_loc5_)
               {
                  Facade.mainMediator.showYesNoDialog(Lang.getString("resume_unsubscribe_title"),Facade.callJS,["resumeSubscription",_loc5_.offer_kind,_loc6_.subscription_id],Lang.getString("resume_unsubscribe"));
               }
               break;
            case RadarDialog.BT_PRIME_UNSUB:
               _loc5_ = Facade.manualProxy.subscriptions[0];
               _loc6_ = Facade.userProxy.subs;
               if(_loc5_)
               {
                  Facade.mainMediator.showYesNoDialog(Lang.getString("unsubscribe_title"),Facade.callJS,["cancelSubscription",_loc5_.offer_kind,_loc6_.subscription_id],Lang.getString("unsubscribe"));
               }
         }
      }
      
      private function resultScouting(param1:BinaryBuffer) : void
      {
         var _loc2_:Number = new Packet_0010_22(param1).value;
         Facade.userProxy.base.scouting = _loc2_;
         Facade.myMediator.syncRadarButton();
         if(this.dialog.parent)
         {
            this.dialog.syncTime(_loc2_ - CoreLogic.serverTime);
            this.dialog.btLock = false;
         }
      }
   }
}

