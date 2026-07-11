package game.offer
{
   import flash.events.MouseEvent;
   import game.common.DialogMediator;
   import game.quest.LikeDialog;
   import logic.ActionLogic;
   import logic.MainLogic;
   import logic.ShopLogic;
   import model.QuestProxy;
   import proto.game.family_0010.PUserAction;
   import proto.game.family_0010.Packet_0010_19;
   import proto.game.family_0010.Packet_0010_1B;
   import proto.model.PCost;
   import proto.model.POffer;
   import proto.model.PQuest;
   import proto.model.PQuestInfo;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.VButton;
   import ui.vbase.VEvent;
   
   public class OfferMediator extends DialogMediator
   {
      
      public var dialog:BaseDialog;
      
      public var kind:String;
      
      private var prevBt:VButton;
      
      private var nextBt:VButton;
      
      public function OfferMediator()
      {
         super();
      }
      
      public function show(param1:String) : void
      {
         var _loc2_:BaseDialog = null;
         var _loc3_:Object = Facade.userProxy.offerHash[param1];
         if(_loc3_ is POffer)
         {
            if(param1 == OfferOk.kind)
            {
               _loc2_ = OfferOk.createDialog(_loc3_ as POffer);
            }
            else
            {
               _loc2_ = this.createOfferDialog(_loc3_ as POffer);
            }
         }
         else
         {
            if(!(_loc3_ is PQuest))
            {
               return;
            }
            _loc2_ = this.createQuestDialog(_loc3_ as PQuest);
         }
         this.kind = param1;
         if(Boolean(_loc2_) && _loc2_ != this.dialog)
         {
            _loc2_.addListener(VEvent.VARIANCE,this.onVariance);
            Facade.mainMediator.showDialog(_loc2_);
            _loc2_.mediator = this;
            if(this.dialog)
            {
               if(this.nextBt)
               {
                  this.nextBt.removeFromParent(false);
                  this.prevBt.removeFromParent(false);
               }
               this.dialog.mediator = null;
               this.dialog.close();
            }
            this.dialog = _loc2_;
         }
         if(this.dialog)
         {
            this.sync();
         }
      }
      
      public function sync() : void
      {
         var _loc2_:String = null;
         var _loc1_:uint = 0;
         for(_loc2_ in Facade.userProxy.offerHash)
         {
            _loc1_++;
         }
         if(_loc1_ > 1)
         {
            if(!this.nextBt)
            {
               this.nextBt = UIFactory.createNavButton(true);
               this.nextBt.assignLayout({
                  "w":43,
                  "h":70,
                  "vCenter":0,
                  "right":-37
               });
               this.nextBt.addClickListener(this.onNav,1);
               this.prevBt = UIFactory.createNavButton(false);
               this.prevBt.assignLayout({
                  "w":43,
                  "h":70,
                  "vCenter":0,
                  "left":-37
               });
               this.prevBt.addClickListener(this.onNav,-1);
            }
            if(!this.nextBt.parent)
            {
               this.dialog.add(this.nextBt);
               this.dialog.add(this.prevBt);
            }
         }
         else if(this.nextBt)
         {
            this.nextBt.removeFromParent();
            this.prevBt.removeFromParent();
            this.nextBt = null;
            this.prevBt = null;
         }
      }
      
      private function onNav(param1:MouseEvent) : void
      {
         this.show(Facade.myMediator.myPanel.getOfferKind(this.kind,int((param1.currentTarget as VButton).data)));
      }
      
      private function createQuestDialog(param1:PQuest) : BaseDialog
      {
         var _loc2_:PQuestInfo = Facade.questProxy.questDict[param1.qname];
         if(QuestProxy.isLikeOffer(param1.qname))
         {
            return new LikeDialog(param1,_loc2_);
         }
         return new OfferDialog(param1,_loc2_);
      }
      
      private function createOfferDialog(param1:POffer) : BaseDialog
      {
         var _loc2_:OfferDialog = this.dialog as OfferDialog;
         if(Boolean(_loc2_) && Boolean(_loc2_.questData))
         {
            _loc2_ = null;
         }
         if(!_loc2_)
         {
            _loc2_ = new OfferDialog();
         }
         _loc2_.setData(Facade.manualProxy.getOfferShop(param1.offer_kind),param1.offer_is_gold,param1.offer_start_time);
         Facade.protoProxy.request(new Packet_0010_1B(param1.offer_kind));
         return _loc2_;
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:OfferDialog = null;
         if(param1.currentTarget is OfferDialog)
         {
            _loc2_ = param1.currentTarget as OfferDialog;
            if(_loc2_.questData)
            {
               this.onOfferQuest(_loc2_);
            }
            else
            {
               this.onOfferBuy(_loc2_);
            }
         }
         else if(param1.currentTarget is LikeDialog)
         {
            this.onLikeReward(param1.currentTarget as LikeDialog);
         }
      }
      
      private function onOfferBuy(param1:OfferDialog) : void
      {
         var _loc2_:PCost = null;
         if(param1.isGold)
         {
            _loc2_ = PCost.create(PCost.GOLD,param1.shop.offer_gold_price);
            if(ShopLogic.checkPrice(_loc2_))
            {
               ShopLogic.applyCost(_loc2_,true);
               Facade.protoProxy.request(new Packet_0010_19(param1.shop.offer_kind));
               MainLogic.getMyMap();
            }
         }
         else
         {
            param1.close();
            Facade.callJS("pay",param1.shop.offer_kind);
         }
      }
      
      private function onOfferQuest(param1:OfferDialog) : void
      {
         param1.close();
         var _loc2_:String = param1.questData.qname;
         if(_loc2_ == QuestProxy.VK_SOCIAL_TANK)
         {
            Facade.callJS("openSpecialOffers");
         }
         else if(param1.isQuestComplete)
         {
            this.reward(param1.questData,param1.questInfo);
         }
         else if(_loc2_ == QuestProxy.FB_MOBILE)
         {
            Facade.callJS("showInstallPushBox");
         }
      }
      
      private function onLikeReward(param1:LikeDialog) : void
      {
         param1.close();
         this.reward(param1.data,param1.info);
      }
      
      private function reward(param1:PQuest, param2:PQuestInfo) : void
      {
         ShopLogic.applyCostList(param2.qi_prize,false,false);
         ActionLogic.request(PUserAction.USER_COMPLITE_QUEST,param1.qname);
         Facade.myMediator.changeOffer(param1.qname);
      }
   }
}

