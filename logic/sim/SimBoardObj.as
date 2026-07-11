package logic.sim
{
   import proto.model.PObjectId;
   import utils.CommonUtils;
   
   public class SimBoardObj
   {
      
      public static const BUILDING:int = 1;
      
      public static const FENCE:int = 2;
      
      public static const CANNON:int = 3;
      
      public static const UNIT:int = 4;
      
      public static const DECOR:int = 5;
      
      public static const GARBAGE:int = 6;
      
      public var kind:int;
      
      public var id:int;
      
      public function SimBoardObj(param1:int, param2:int)
      {
         super();
         this.kind = param1;
         this.id = param2;
      }
      
      public function toPObjectId() : PObjectId
      {
         var _loc1_:int = 0;
         switch(this.kind)
         {
            case BUILDING:
               _loc1_ = int(PObjectId.BUILDING);
               break;
            case FENCE:
               _loc1_ = int(PObjectId.FENCE);
               break;
            case CANNON:
               _loc1_ = int(PObjectId.CANNON);
               break;
            case UNIT:
               _loc1_ = int(PObjectId.UNIT);
               break;
            case DECOR:
               _loc1_ = int(PObjectId.DECOR);
               break;
            case GARBAGE:
               _loc1_ = int(PObjectId.GARBAGE);
         }
         return PObjectId.create(_loc1_,this.id);
      }
      
      public function equal(param1:SimBoardObj) : Boolean
      {
         return Boolean(param1) && param1.kind == this.kind && param1.id == this.id;
      }
      
      public function clone() : SimBoardObj
      {
         return new SimBoardObj(this.kind,this.id);
      }
      
      public function toString() : String
      {
         return "{kind = " + CommonUtils.getConstantName(SimBoardObj,this.kind) + ", id = " + this.id + "}";
      }
   }
}

