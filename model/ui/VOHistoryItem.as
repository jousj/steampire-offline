package model.ui
{
   import proto.model.PFightLogInfo;
   import proto.model.PHistFight;
   
   public class VOHistoryItem
   {
      
      public var boss:String;
      
      public var item:PHistFight;
      
      public var soldierList:Array;
      
      public var tailTime:Number;
      
      public var isLog:Boolean;
      
      public var log:PFightLogInfo;
      
      public var isRevenge:Boolean;
      
      public function VOHistoryItem()
      {
         super();
      }
   }
}

