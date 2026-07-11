package model.vo
{
   public class MapAction
   {
      
      public var time:Number;
      
      public var objId:uint;
      
      public var variance:uint;
      
      public var value:*;
      
      public var handler:Function;
      
      public var useSelfArg:Boolean;
      
      public function MapAction()
      {
         super();
      }
      
      public function run() : void
      {
         if(this.useSelfArg)
         {
            this.handler(this);
         }
         else if(this.objId > 0 && this.value != null)
         {
            this.handler(this.objId,this.value);
         }
         else if(this.objId > 0)
         {
            this.handler(this.objId);
         }
         else
         {
            this.handler(this.value);
         }
      }
   }
}

