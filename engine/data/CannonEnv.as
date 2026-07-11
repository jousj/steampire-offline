package engine.data
{
   public class CannonEnv
   {
      
      public var isRotate:Boolean;
      
      public var attackType:uint;
      
      public var isBarrelEffect:Boolean;
      
      public var barrelList:Vector.<uint>;
      
      public var rocketMode:uint;
      
      public function CannonEnv(param1:Boolean, param2:uint, param3:Vector.<uint>, param4:uint = 0, param5:Boolean = false)
      {
         super();
         this.isRotate = param1;
         this.attackType = param2;
         this.barrelList = param3;
         this.isBarrelEffect = param5;
         this.rocketMode = param4;
      }
   }
}

