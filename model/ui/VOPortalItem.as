package model.ui
{
   public class VOPortalItem
   {
      
      public var radar:Boolean;
      
      public var kind:String;
      
      public var duration:Number;
      
      public var endTime:Number;
      
      public var prize:Array;
      
      public var isNew:Boolean;
      
      public function VOPortalItem(param1:String, param2:Number, param3:Array, param4:Boolean, param5:Number = -1, param6:Boolean = false)
      {
         super();
         this.kind = param1;
         this.duration = param2;
         this.prize = param3;
         this.radar = param4;
         this.endTime = param5;
         this.isNew = param6;
      }
   }
}

