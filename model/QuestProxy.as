package model
{
   import model.vo.VOQuest;
   import proto.model.PQuest;
   import proto.model.PQuestInfo;
   import proto.model.PQuestTarget;
   
   public class QuestProxy
   {
      
      public static const FB_MOBILE:String = "mobileActionFb";
      
      public static const VK_SOCIAL_TANK:String = "vk_social_tank";
      
      public var questDict:Object;
      
      public const questList:Array = [];
      
      public function QuestProxy()
      {
         super();
      }
      
      public static function isLikeOffer(param1:String) : Boolean
      {
         return param1.indexOf("likeAction") == 0;
      }
      
      public function assignOpenQuests(param1:Array) : void
      {
         var _loc2_:PQuest = null;
         this.questList.length = 0;
         for each(_loc2_ in param1)
         {
            this.addQuest(_loc2_,false);
         }
      }
      
      public function addQuest(param1:PQuest, param2:Boolean = true) : VOQuest
      {
         var _loc3_:PQuestInfo = this.questDict[param1.qname];
         if(isLikeOffer(param1.qname))
         {
            Facade.questMediator.likeEvent(param1);
            return null;
         }
         if(param1.qname == FB_MOBILE)
         {
            Facade.questMediator.openQuestOffer(param1);
            return null;
         }
         if(param1.qname == "mobileActionVk" || param1.qname == "mobileRateUs")
         {
            return null;
         }
         var _loc4_:VOQuest = new VOQuest();
         _loc4_.kind = param1.qname;
         _loc4_.meta = _loc3_;
         if(_loc3_.qi_achievement)
         {
            _loc4_.isHidden = true;
         }
         if(param1.qtargets.length != _loc3_.qi_targets.length || param1.qtargets.length != 1)
         {
            throw new Error("bad count target for data: " + param1.qname);
         }
         _loc4_.target = _loc3_.qi_targets[0];
         _loc4_.count = (param1.qtargets[0] as PQuestTarget).variance == PQuestTarget.QTOPEN ? uint((param1.qtargets[0] as PQuestTarget).value) : _loc4_.target.qti_count;
         if(_loc4_.count > _loc4_.target.qti_count)
         {
            _loc4_.count = _loc4_.target.qti_count;
         }
         if(!_loc4_.isComplete)
         {
            _loc4_.isNew = param2;
         }
         if(param2 || _loc4_.isComplete)
         {
            this.questList.unshift(_loc4_);
         }
         else
         {
            this.questList.push(_loc4_);
         }
         return _loc4_;
      }
      
      public function editQuest(param1:String, param2:uint) : Object
      {
         var _loc5_:int = 0;
         var _loc3_:VOQuest = this.getQuest(param1);
         if(!_loc3_)
         {
            return 0;
         }
         if(_loc3_.isNew)
         {
            _loc3_.isNew = false;
         }
         var _loc4_:Boolean = _loc3_.isComplete;
         _loc3_.count = param2 > _loc3_.target.qti_count ? _loc3_.target.qti_count : param2;
         if(_loc3_.isHidden)
         {
            return _loc3_;
         }
         if(_loc3_.isComplete)
         {
            if(_loc4_)
            {
               return 0;
            }
            _loc5_ = this.questList.indexOf(_loc3_);
            if(_loc5_ > 0)
            {
               this.questList.splice(_loc5_,1);
               this.questList.unshift(_loc3_);
               return 2;
            }
            return 1;
         }
         return _loc3_.target.qti_count < 100 ? _loc3_.count + "/" + _loc3_.target.qti_count : _loc3_.count.toString();
      }
      
      public function getQuest(param1:String) : VOQuest
      {
         var _loc2_:VOQuest = null;
         for each(_loc2_ in this.questList)
         {
            if(_loc2_.kind == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
   }
}

