package logic
{
   import flash.utils.getTimer;
   import model.CommonEvent;
   import proto.BinaryBuffer;
   import proto.game.family_0000.Packet_0000_00;
   import proto.game.family_0040.PFriendInfo;
   import proto.game.family_0040.Packet_0040_02;
   import proto.game.family_0040.Packet_0040_03;
   import proto.model.PUserBase;
   import proto.model.PUserClan;
   import proto.model.clan.PMember;
   import utils.CommonUtils;
   
   public class SocialLogic
   {
      
      public static var onlineTime:int;
      
      public static var friendList:Array;
      
      public static var onlineList:Array;
      
      public static var noAppList:Array;
      
      public static var isLoad:Boolean;
      
      public static var isOnlineLoad:Boolean;
      
      public function SocialLogic()
      {
         super();
      }
      
      public static function init() : void
      {
         Facade.addJSCallback("handleAppFriends",onJSAppFriends);
         Facade.addJSCallback("onlineAppFriends",onJSOnlineFriends);
      }
      
      public static function run(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(param1)
         {
            if(!onlineList || getTimer() - onlineTime > 300000)
            {
               if(!friendList)
               {
                  return run();
               }
               if(onlineList)
               {
                  onlineList.length = 0;
               }
               else
               {
                  onlineList = [];
               }
               onlineTime = getTimer();
               isOnlineLoad = true;
               Facade.callJS("getFriendsOnline",param2 ? getClanMemberIdList() : []);
            }
         }
         else if(!friendList)
         {
            friendList = [];
            noAppList = [];
            isLoad = true;
            Facade.callJS("processFriends");
         }
      }
      
      private static function getClanMemberIdList() : Array
      {
         var _loc2_:PMember = null;
         var _loc3_:String = null;
         var _loc1_:Array = [];
         if(Facade.userProxy.clanData)
         {
            for each(_loc2_ in Facade.userProxy.clanData.members)
            {
               if(_loc2_.user_base.user_id != Preloader.uid)
               {
                  _loc3_ = _loc2_.user_base.account_id;
                  if(Boolean(_loc3_) && _loc3_.indexOf("_") == 3)
                  {
                     _loc1_.push(_loc3_);
                  }
               }
            }
         }
         return _loc1_;
      }
      
      private static function onJSAppFriends(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:PUserBase = null;
         if(!friendList || !param1)
         {
            return;
         }
         friendList.length = 0;
         noAppList.length = 0;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = new PUserBase();
            _loc4_.user_id = _loc3_.fi_id;
            _loc4_.account_id = _loc4_.user_id;
            _loc4_.name = _loc3_.fi_name;
            _loc4_.avatar = _loc3_.fi_avatar;
            if(_loc3_.fi_is_app)
            {
               _loc4_.level = 1;
               _loc2_.push(_loc4_.user_id);
               friendList.push(_loc4_);
            }
            else
            {
               noAppList.push(_loc4_);
            }
            if(Facade.isHttps && Facade.socialnet != Facade.VKONTAKTE)
            {
               if(_loc4_.avatar)
               {
                  _loc4_.avatar = _loc4_.avatar.replace("http://","https://");
               }
            }
         }
         if(friendList.length > 0)
         {
            Facade.protoProxy.request(new Packet_0040_02(_loc2_),resultFriendInfo,0,0,[false]);
         }
         else
         {
            isLoad = false;
            Facade.dispatchCommonEvent(CommonEvent.SOCIAL,false);
         }
      }
      
      private static function onJSOnlineFriends(param1:Array) : void
      {
         var _loc2_:PUserBase = null;
         var _loc3_:PMember = null;
         var _loc4_:int = 0;
         if(!onlineList || !param1)
         {
            return;
         }
         onlineList.length = 0;
         if(Facade.userProxy.clanData)
         {
            for each(_loc3_ in Facade.userProxy.clanData.members)
            {
               if(_loc3_.user_base.account_id)
               {
                  _loc4_ = param1.indexOf(_loc3_.user_base.account_id);
                  if(_loc4_ >= 0)
                  {
                     param1[_loc4_] = null;
                     onlineList.push(_loc3_.user_base);
                  }
               }
            }
         }
         for each(_loc2_ in friendList)
         {
            if(param1.indexOf(_loc2_.account_id) >= 0)
            {
               onlineList.push(_loc2_);
            }
         }
         if(onlineList.length > 0)
         {
            param1.length = 0;
            for each(_loc2_ in onlineList)
            {
               param1.push(_loc2_.account_id);
            }
            Facade.protoProxy.request(new Packet_0040_02(param1),resultFriendInfo);
         }
         else
         {
            isOnlineLoad = false;
            Facade.dispatchCommonEvent(CommonEvent.SOCIAL,true);
         }
      }
      
      private static function resultFriendInfo(param1:BinaryBuffer, param2:Boolean = true) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:* = 0;
         var _loc6_:PUserBase = null;
         var _loc7_:Boolean = false;
         var _loc8_:PFriendInfo = null;
         var _loc9_:Packet_0000_00 = null;
         if(param1.family == 64 && param1.subfamily == 3)
         {
            _loc3_ = param2 ? onlineList : friendList;
            _loc4_ = new Packet_0040_03(param1).value;
            _loc5_ = int(_loc3_.length - 1);
            while(_loc5_ >= 0)
            {
               _loc6_ = _loc3_[_loc5_];
               _loc7_ = true;
               for each(_loc8_ in _loc4_)
               {
                  if(_loc8_.fr_social_id == _loc6_.account_id)
                  {
                     _loc6_.user_id = _loc8_.fr_id;
                     _loc6_.level = _loc8_.fr_level;
                     if(_loc8_.fr_clan)
                     {
                        if(!_loc6_.clan)
                        {
                           _loc6_.clan = new PUserClan();
                        }
                        _loc6_.clan.uc_name = _loc8_.fr_clan.phf_name;
                        _loc6_.clan.uc_icon = _loc8_.fr_clan.phf_icon;
                     }
                     else
                     {
                        _loc6_.clan = null;
                     }
                     _loc6_.units = [_loc8_.fr_req_crystal,_loc8_.fr_req_oil,_loc8_.fr_req_call,_loc8_.fr_req_time];
                     _loc7_ = false;
                     break;
                  }
               }
               if(_loc7_)
               {
                  if(!param2)
                  {
                     _loc6_ = _loc3_[_loc5_];
                     _loc6_.level = 0;
                     noAppList.push(_loc6_);
                  }
                  _loc3_.splice(_loc5_,1);
               }
               _loc5_--;
            }
         }
         else
         {
            if(param1.family == 0 && param1.subfamily == 0)
            {
               _loc9_ = new Packet_0000_00(param1);
            }
            ErrorLogic.sendError("Friend bad request " + param1.family.toString(16) + "x" + param1.subfamily.toString(16) + (_loc9_ ? CommonUtils.getConstantName(Packet_0000_00,_loc9_.variance) + " " + _loc9_.value : ""));
         }
         if(param2)
         {
            isOnlineLoad = false;
         }
         else
         {
            isLoad = false;
            EventLogic.sync();
         }
         Facade.dispatchCommonEvent(CommonEvent.SOCIAL,param2);
      }
   }
}

