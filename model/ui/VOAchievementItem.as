package model.ui
{
   import model.vo.VOQuest;
   import proto.model.PQuestTargetInfo;
   
   public class VOAchievementItem
   {
      
      public var kind:String;
      
      public var lang:String;
      
      public var targetList:Vector.<PQuestTargetInfo> = new Vector.<PQuestTargetInfo>(6,true);
      
      public var pointList:Vector.<uint> = new Vector.<uint>(6,true);
      
      public var quest:VOQuest;
      
      public var index:int = -1;
      
      public var max_index:int = 0;
      
      public function VOAchievementItem()
      {
         super();
      }
   }
}

