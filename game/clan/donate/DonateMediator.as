package game.clan.donate
{
   import game.common.DialogMediator;
   import logic.CoreLogic;
   import logic.EventLogic;
   import logic.ShopLogic;
   import proto.game.family_0060.Packet_0060_18;
   import proto.model.PAction;
   import proto.model.PClanTownhallUnlock;
   import proto.model.PCost;
   import proto.model.PCostt;
   import proto.model.PUserClan;
   import proto.model.clan.PBase;
   import proto.model.clan.PCapitalLogKind;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   
   public class DonateMediator extends DialogMediator
   {
      
      public var dialog:DonateDialog;
      
      private var resourceList:Vector.<uint>;
      
      public function DonateMediator(param1:Vector.<uint> = null)
      {
         super();
         this.resourceList = Boolean(param1) && param1.length == 6 ? param1 : null;
      }
      
      public function createPanel() : DonatePanel
      {
         var _loc4_:DonatePanel = null;
         var _loc1_:PClanTownhallUnlock = mp.getClanTownHallUnlock(up.clanData.base.has_capital ? up.clanData.townhall_level : 0);
         if(this.resourceList)
         {
            _loc4_ = new DonatePanel(up.clanData,_loc1_,this.resourceList[0],this.resourceList[1],this.resourceList[2],this.resourceList[3],this.resourceList[4],this.resourceList[5],true);
         }
         else
         {
            _loc4_ = new DonatePanel(up.clanData,_loc1_,up.oilMax,up.crystalMax,uint.MAX_VALUE,uint.MAX_VALUE,uint.MAX_VALUE,uint.MAX_VALUE,true);
         }
         _loc4_.addListener(VEvent.VARIANCE,this.onDonate);
         _loc4_.box.gap = 10;
         var _loc2_:Number = CoreLogic.serverTime;
         var _loc3_:PUserClan = up.clan;
         _loc4_.mithrilBar.setTime(_loc1_.ctu_donate_cooldown,_loc3_.uc_donate_mithril,_loc2_);
         _loc4_.oilBar.setTime(_loc1_.ctu_donate_cooldown,_loc3_.uc_donate_oil,_loc2_);
         _loc4_.cryBar.setTime(_loc1_.ctu_donate_cooldown,_loc3_.uc_donate_crystal,_loc2_);
         return _loc4_;
      }
      
      override public function onAdd() : BaseDialog
      {
         var _loc1_:PClanTownhallUnlock = mp.getClanTownHallUnlock(up.clanData.base.has_capital ? up.clanData.townhall_level : 0);
         if(this.resourceList)
         {
            this.dialog = new DonateDialog(up.clanData,_loc1_,this.resourceList[0],this.resourceList[1],this.resourceList[2],this.resourceList[3],this.resourceList[4],this.resourceList[5]);
         }
         else
         {
            this.dialog = new DonateDialog(up.clanData,_loc1_,up.oilMax,up.crystalMax,uint.MAX_VALUE,uint.MAX_VALUE,uint.MAX_VALUE,uint.MAX_VALUE);
         }
         var _loc2_:Number = CoreLogic.serverTime;
         var _loc3_:PUserClan = up.clan;
         this.dialog.panel.mithrilBar.setTime(_loc1_.ctu_donate_cooldown,_loc3_.uc_donate_mithril,_loc2_);
         this.dialog.panel.oilBar.setTime(_loc1_.ctu_donate_cooldown,_loc3_.uc_donate_oil,_loc2_);
         this.dialog.panel.cryBar.setTime(_loc1_.ctu_donate_cooldown,_loc3_.uc_donate_crystal,_loc2_);
         this.dialog.addListener(VEvent.VARIANCE,this.onDonate);
         return this.dialog;
      }
      
      private function onDonate(param1:VEvent) : void
      {
         var _loc4_:PClanTownhallUnlock = null;
         var _loc5_:DonatePanel = null;
         var _loc6_:PCost = null;
         var _loc7_:uint = 0;
         var _loc8_:DonateProgressBar = null;
         var _loc9_:Number = NaN;
         var _loc3_:PBase = up.clanData.base;
         _loc4_ = mp.getClanTownHallUnlock(_loc3_.has_capital ? up.clanData.townhall_level : 0);
         _loc5_ = param1.data;
         switch(param1.variance)
         {
            case PCostt.CRYSTAL:
               _loc6_ = PCost.create(PCost.CRYSTAL,_loc4_.ctu_donate_min_crystal);
               _loc7_ = 3;
               _loc8_ = _loc5_.cryBar;
               break;
            case PCostt.OIL:
               _loc6_ = PCost.create(PCost.OIL,_loc4_.ctu_donate_min_oil);
               _loc7_ = 2;
               _loc8_ = _loc5_.oilBar;
               break;
            case PCostt.GOLD:
               _loc6_ = PCost.create(PCost.GOLD,_loc4_.ctu_donate_min_gold);
               _loc7_ = 4;
               _loc8_ = _loc5_.goldBar;
               break;
            case PCostt.MITHRIL:
               _loc6_ = PCost.create(PCost.MITHRIL,_loc4_.ctu_donate_min_mithril);
               _loc7_ = 5;
               _loc8_ = _loc5_.mithrilBar;
         }
         if(Boolean(_loc6_) && (Boolean(this.resourceList) || Boolean(ShopLogic.checkPrice(_loc6_,this.onDonate,arguments))))
         {
            if(this.resourceList)
            {
               ShopLogic.applyCost(_loc6_);
               this.resourceList[_loc7_] -= _loc6_.value;
               _loc8_.myRes.cur = this.resourceList[_loc7_];
               _loc8_.toRes.cur = up.getCostCur(_loc6_.variance);
               if(_loc6_.variance == PCost.GOLD && this.resourceList[_loc7_] < _loc6_.value)
               {
                  _loc8_.bt.disabled = true;
               }
            }
            else
            {
               ShopLogic.applyCost(_loc6_,true);
               up.changeClanResource(_loc6_,false,PCapitalLogKind.DONATE,Preloader.uid);
            }
            Facade.protoProxy.request(new Packet_0060_18(_loc6_));
            if(Facade.isMyMap)
            {
               Facade.questMediator.changeQuest(PAction.AC_CLAN_HELP,1);
            }
            _loc7_ = param1.variance;
            if(_loc7_ == PCost.GOLD)
            {
               if(!_loc3_.has_capital && _loc3_.gold >= Facade.references.create_capital_price.value)
               {
                  _loc3_.has_capital = true;
                  up.clanData.townhall_level = 1;
                  if(this.dialog)
                  {
                     this.dialog.dispatchEvent(new VEvent(VEvent.CHANGE,true));
                     this.dialog.close();
                  }
                  EventLogic.sync();
                  return;
               }
            }
            else
            {
               _loc9_ = CoreLogic.serverTime;
               if(_loc7_ == PCost.OIL)
               {
                  up.clan.uc_donate_oil = _loc9_;
               }
               else if(_loc7_ == PCost.CRYSTAL)
               {
                  up.clan.uc_donate_crystal = _loc9_;
               }
               else if(_loc7_ == PCost.MITHRIL)
               {
                  up.clan.uc_donate_mithril = _loc9_;
               }
               _loc8_.setTime(_loc4_.ctu_donate_cooldown,_loc9_,_loc9_);
            }
            if(this.dialog)
            {
               this.dialog.dispatchEvent(new VEvent(VEvent.CHANGE));
            }
         }
      }
   }
}

