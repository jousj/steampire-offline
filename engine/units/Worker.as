package engine.units
{
   public class Worker extends MovementUnit
   {
      
      public var targetId:uint;
      
      public var alreadyBoard:Boolean;
      
      public var endTime:Number;
      
      public var actionVariance:uint;
      
      public var isFree:Boolean;
      
      public function Worker()
      {
         super();
         applyKind("un_builder");
         calcMoveData(kind,0);
         useWalkPath();
         walkAir = true;
      }
   }
}

