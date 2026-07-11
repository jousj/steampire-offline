package model.vo
{
   import proto.model.PQuestInfo;
   import proto.model.PQuestTargetInfo;
   
   public class VOQuest
   {
      
      public var kind:String;
      
      public var meta:PQuestInfo;
      
      public var target:PQuestTargetInfo;
      
      public var count:uint;
      
      public var isNew:Boolean;
      
      public var isHidden:Boolean;
      
      public function VOQuest()
      {
         super();
      }
      
      public function get isComplete() : Boolean
      {
         return this.count >= this.target.qti_count;
      }
   }
}

