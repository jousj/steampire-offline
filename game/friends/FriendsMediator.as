package game.friends
{
   import game.common.DialogMediator;
   import logic.DialogLogic;
   import logic.MainLogic;
   import logic.SocialLogic;
   import model.CommonEvent;
   import proto.BinaryBuffer;
   import proto.game.family_0060.Packet_0060_02;
   import proto.game.family_0060.Packet_0060_03;
   import proto.model.PRaidEvent;
   import proto.model.PUserBase;
   import proto.model.clan.PMember;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   
   public class FriendsMediator extends DialogMediator
   {
      
      public static const REQUEST:String = "to_friend_mode2";
      
      public static const RAID:String = "to_friend_mode1";
      
      public var dialog:FriendsDialog;
      
      public var skipList:Array;
      
      public var isNoApp:Boolean;
      
      public var isGetClan:Boolean;
      
      public var isOnline:Boolean;
      
      public var useClan:Boolean;
      
      public var saveIndex:uint;
      
      public var typeValue:uint;
      
      private var callbackFunc:Function;
      
      private var callbackArgs:Array;
      
      private const dp:Array = [];
      
      public function FriendsMediator(param1:String = null, param2:String = null, param3:Function = null, param4:Array = null, param5:Boolean = false)
      {
         super();
         this.callbackFunc = param3;
         this.callbackArgs = param4;
         this.dialog = new FriendsDialog(param5,param1,param2);
      }
      
      override public function onAdd() : BaseDialog
      {
         this.dialog.grid.setDataProvider(this.dp);
         var _loc1_:Boolean = this.useClan && Boolean(up.clan);
         if(this.dialog.tabPanel)
         {
            this.dialog.tabPanel.addListener(VEvent.CHANGE,this.onTabChange);
            if(_loc1_)
            {
               Facade.addListenerForComponent(CommonEvent.MY_GAME_STREAM,this.onMyLongGet,this.dialog);
            }
            else
            {
               this.dialog.tabPanel.getTab(1).disabled = true;
            }
         }
         Facade.addListenerForComponent(CommonEvent.SOCIAL,this.onSocial,this.dialog);
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         this.dialog.input.addListener(VEvent.CHANGE,this.onTabChange);
         if(_loc1_ && this.isGetClan && !up.clanData)
         {
            Facade.protoProxy.request(new Packet_0060_03(),this.resultMyClanData,96,2);
         }
         else
         {
            SocialLogic.run(this.isOnline,this.useClan);
         }
         this.onTabChange();
         return this.dialog;
      }
      
      private function onTabChange(param1:Object = null) : void
      {
         var _loc2_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(this.dialog.tabPanel)
         {
            _loc5_ = this.dialog.tabPanel.index;
            if(param1 is uint && _loc5_ != uint(param1))
            {
               return;
            }
         }
         var _loc3_:String = this.dialog.input.value;
         if(_loc3_.length == 0)
         {
            _loc3_ = null;
         }
         else
         {
            _loc3_ = _loc3_.toLowerCase();
         }
         this.dp.length = 0;
         if(_loc5_ == 0)
         {
            if(SocialLogic.isLoad || this.isOnline && SocialLogic.isOnlineLoad)
            {
               _loc2_ = true;
            }
            else
            {
               _loc6_ = this.getFriendDp(_loc3_);
            }
         }
         else if(up.clan)
         {
            if(up.clanData)
            {
               _loc6_ = this.getClanDp(_loc3_);
            }
            else
            {
               _loc2_ = true;
            }
         }
         var _loc4_:int = int(this.dialog.grid.index);
         this.dialog.syncDp(this.saveIndex);
         if(param1 is VEvent)
         {
            this.saveIndex = _loc4_;
         }
         if(this.dialog.grid.length == 0)
         {
            if(_loc2_)
            {
               _loc3_ = "load_title";
            }
            else if(_loc6_ == 0)
            {
               if(this.isOnline)
               {
                  _loc3_ = "empty_raid_friends";
               }
               else if(_loc5_ == 0)
               {
                  _loc3_ = "empty_friends";
               }
               else
               {
                  _loc3_ = "empty_clan_members";
               }
            }
            else
            {
               _loc3_ = "not_found";
            }
            this.dialog.emptyText = Lang.getString(_loc3_);
         }
      }
      
      private function onSocial(param1:CommonEvent) : void
      {
         if(param1.data == this.isOnline || this.isOnline && !SocialLogic.run(true,this.useClan))
         {
            this.onTabChange(0);
         }
      }
      
      private function onMyLongGet(param1:CommonEvent) : void
      {
         var _loc2_:int = param1.data is PRaidEvent ? int((param1.data as PRaidEvent).variance) : -1;
         if(_loc2_ < 0 || _loc2_ == PRaidEvent.DEL_CLAN_MEMBER || _loc2_ == PRaidEvent.NEW_CLAN_MEMBER)
         {
            if(!up.clan)
            {
               this.dialog.tabPanel.getTab(1).disabled = true;
               if(this.dialog.tabPanel.index == 1)
               {
                  this.dialog.tabPanel.index = 0;
                  this.onTabChange();
                  return;
               }
            }
            this.onTabChange(1);
         }
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:PUserBase = param1.data;
         if(this.callbackFunc != null)
         {
            if(this.callbackArgs)
            {
               this.callbackArgs.unshift(_loc2_);
               this.callbackFunc.apply(null,this.callbackArgs);
            }
            else
            {
               this.callbackFunc(_loc2_);
            }
         }
         else
         {
            Facade.setMapCallback(DialogLogic.openFriends,[this.dialog.grid.index,this.dialog.tabPanel.index == 1]);
            MainLogic.getFriendMap(_loc2_.user_id);
         }
         this.dialog.close();
      }
      
      private function getFriendDp(param1:String = null) : uint
      {
         var _loc6_:Array = null;
         var _loc9_:Boolean = false;
         var _loc10_:PUserBase = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = this.dialog.grid.maxRenderer;
         var _loc5_:uint = 0;
         var _loc7_:Boolean = this.dialog.type == REQUEST;
         var _loc8_:uint = 0;
         while(_loc8_ <= 1)
         {
            _loc9_ = _loc8_ == 0;
            if(_loc9_)
            {
               _loc6_ = this.isOnline ? SocialLogic.onlineList : SocialLogic.friendList;
            }
            else
            {
               _loc6_ = this.isNoApp ? SocialLogic.noAppList : null;
            }
            for each(_loc10_ in _loc6_)
            {
               _loc5_++;
               if((!this.skipList || this.skipList.indexOf(_loc10_.user_id) < 0) && (!param1 || _loc10_.name.toLowerCase().indexOf(param1) >= 0))
               {
                  if(_loc9_)
                  {
                     this.dp.push(_loc10_);
                  }
                  else
                  {
                     this.dp.splice(_loc2_,0,_loc10_);
                     _loc3_++;
                     if(_loc3_ == 2)
                     {
                        _loc2_ += _loc4_;
                        _loc3_ = 0;
                     }
                  }
                  if(_loc7_)
                  {
                     _loc10_.ratio = this.typeValue;
                  }
               }
            }
            _loc8_++;
         }
         return _loc5_;
      }
      
      private function getClanDp(param1:String = null) : uint
      {
         var _loc3_:PMember = null;
         var _loc4_:PUserBase = null;
         var _loc2_:uint = 0;
         for each(_loc3_ in up.clanData.members)
         {
            _loc4_ = _loc3_.user_base;
            if(_loc4_.user_id != Preloader.uid)
            {
               _loc2_++;
               if((!this.skipList || this.skipList.indexOf(_loc4_.user_id) < 0) && (!param1 || _loc4_.name.toLowerCase().indexOf(param1) >= 0))
               {
                  this.dp.push(_loc4_);
               }
            }
         }
         return _loc2_;
      }
      
      private function resultMyClanData(param1:BinaryBuffer) : void
      {
         if(this.dialog.parent)
         {
            up.assignClanData(new Packet_0060_02(param1).value);
            SocialLogic.run(true,true);
         }
      }
   }
}

