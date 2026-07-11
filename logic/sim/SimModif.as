package logic.sim
{
   public class SimModif
   {
      
      public static const MOVE_K:int = 0;
      
      public static const DAMAGE_K:int = 1;
      
      public static const INVISIBLE:int = 2;
      
      public static const ATTACK_K:int = 3;
      
      public var kind:int;
      
      public var etime:int;
      
      public var k:Number;
      
      public function SimModif(param1:int, param2:int, param3:Number)
      {
         super();
         this.kind = param1;
         this.etime = param2;
         this.k = param3;
      }
   }
}

