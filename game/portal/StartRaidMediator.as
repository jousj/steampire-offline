package game.portal
{
   import engine.signal.Signal;
   import game.battle.RaidMembersProxy;
   import game.friends.FriendsMediator;
   import logic.CoreLogic;
   import logic.MainLogic;
   import logic.SocialLogic;
   import model.vo.VORaidMember;
   import proto.game.family_0010.Packet_0010_0A;
   import proto.game.family_0010.Packet_0010_0E;
   import proto.game.family_0010.Packet_0010_10;
   import proto.model.PGroupFightInfo;
   import proto.model.PRaidEvent;
   import proto.model.PRaidFriendEvent;
   import proto.model.PUserBase;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   
   public class StartRaidMediator
   {
      
      private const panel:VComponent = new VComponent();
      
      private const membersProxy:RaidMembersProxy = new RaidMembersProxy();
      
      private var id:Number = 200;
      
      private var heroRaid:Boolean;
      
      private var dialog:StartRaidDialog;
      
      public function StartRaidMediator()
      {
         super();
      }
      
      public function show(param1:PGroupFightInfo) : void
      {
         this.id = Math.random() * 100;
         this.heroRaid = param1.fgi_raid_kind == "rd_bosses";
         if(this.heroRaid && !Facade.userProxy.getCustomData("boss_raid"))
         {
            Facade.userProxy.setCustomData("boss_raid","true");
         }
         this.membersProxy.assignUserBaseList(param1.fgi_members,null,this.heroRaid);
         var _loc2_:VORaidMember = this.membersProxy.list[0] as VORaidMember;
         Facade.userProxy.clan = _loc2_.ub.clan;
         this.dialog = new StartRaidDialog(param1.fgi_raid_kind,Facade.references.raid_members_count,PortalMediator.getRaidReward(param1.fgi_raid_kind,_loc2_.soldierLevelHash));
         this.dialog.mediator = this;
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         this.dialog.addListener(VEvent.CLOSE_DIALOG,this.onClose);
         this.syncMembers();
         this.panel.add(SkinManager.getEmbed("DialogBg",VSkin.STRETCH),{
            "left":-20,
            "right":-20,
            "top":-5,
            "bottom":-18
         });
         this.dialog.useCenter();
         this.panel.add(this.dialog);
         Facade.mainPanel.addInterLayer(this.panel);
         if(!this.checkFullMembers())
         {
            Facade.gameStream.assign(param1.fgi_time,this.onGameStream).run();
            if(param1.fgi_raid_kind != "rd_bosses")
            {
               this.setCreateTime(param1.fgi_create_time);
            }
         }
      }
      
      private function syncMembers() : void
      {
         this.dialog.setMembers(this.membersProxy.list);
      }
      
      private function setCreateTime(param1:Number) : void
      {
         if(!isNaN(param1))
         {
            param1 += Facade.references.raid_bot_time;
            if(param1 < CoreLogic.serverTime)
            {
               param1 = 0;
            }
         }
         this.dialog.setSearchMode(param1);
         if(!isNaN(param1) && param1 > 0)
         {
            Signal.createRef(this.panel,this.onClose,0,0,false).delayEnd(param1);
         }
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:FriendsMediator = null;
         if(param1.variance == this.dialog.INVITE)
         {
            _loc2_ = new FriendsMediator(FriendsMediator.RAID,Lang.getString("friend_mode1"),this.friendCallback,null,true);
            _loc2_.isOnline = _loc2_.useClan = _loc2_.isGetClan = true;
            Facade.mainMediator.showDialog(_loc2_);
         }
         else if(param1.variance == this.dialog.AUTO_SEARCH)
         {
            this.onClose(null,true);
         }
      }
      
      private function friendCallback(param1:PUserBase) : void
      {
         Facade.protoProxy.request(new Packet_0010_0E(param1.user_id));
      }
      
      private function onGameStream(param1:Array) : void
      {
         var _loc2_:PRaidFriendEvent = null;
         var _loc3_:uint = 0;
         for each(_loc2_ in param1)
         {
            _loc3_ = _loc2_.rf_event.variance;
            if(_loc3_ == PRaidEvent.NEW_MEMBER)
            {
               this.addMember(_loc2_.rf_event.value);
            }
            else if(_loc3_ == PRaidEvent.START_FIGHT)
            {
               this.onClose();
            }
            else if(_loc3_ == PRaidEvent.DEL_MEMBER)
            {
               if(this.membersProxy.remove(_loc2_.rf_event.value))
               {
                  this.syncMembers();
               }
            }
            else if(_loc3_ == PRaidEvent.ENABLE_AUTO_MODE)
            {
               this.setCreateTime(_loc2_.rf_event.value);
            }
            else if(_loc3_ == PRaidEvent.DEL_CLAN_MEMBER)
            {
               if(_loc2_.rf_event.value == Preloader.uid)
               {
                  Facade.userProxy.clan = null;
                  SocialLogic.onlineTime = 0;
               }
            }
         }
      }
      
      private function addMember(param1:PUserBase) : void
      {
         if(this.membersProxy.getById(param1.user_id))
         {
            return;
         }
         this.membersProxy.add(param1,this.membersProxy.length + 1,false,this.heroRaid);
         this.syncMembers();
         if(this.checkFullMembers())
         {
            Facade.gameStream.clear();
         }
      }
      
      private function checkFullMembers() : Boolean
      {
         if(this.membersProxy.length >= Facade.references.raid_members_count)
         {
            this.dialog.closeBt.disabled = this.dialog.portalBt.disabled = true;
            Signal.createRef(this.panel,this.onClose,0,0,false).delayCall(3);
            return true;
         }
         return false;
      }
      
      private function onClose(param1:VEvent = null, param2:Boolean = false) : void
      {
         Signal.stopRef(this.panel);
         Facade.gameStream.clear();
         this.panel.removeFromParent();
         if(param2)
         {
            MainLogic.requestMap(new Packet_0010_10());
         }
         else
         {
            if(param1)
            {
               Facade.protoProxy.request(new Packet_0010_0A());
            }
            MainLogic.getMyMap(Boolean(param1) && Boolean(param1.data) ? Facade.myMediator.toPortal : null);
         }
      }
   }
}

