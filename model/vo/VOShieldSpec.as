package model.vo
{
   import proto.model.PShopShieldGen;
   
   public class VOShieldSpec
   {
      
      public var recoveryDuration:Number;
      
      public var time:Number;
      
      public var recoveryTime:Number;
      
      public var isRecovery:Boolean;
      
      public function VOShieldSpec()
      {
         super();
      }
      
      public function assignShop(param1:PShopShieldGen) : void
      {
         this.recoveryDuration = param1.ssg_cooldown;
         this.time = param1.ssg_time;
      }
      
      public function assignData(param1:Number, param2:Number = -1) : void
      {
         this.recoveryTime = param1 + this.recoveryDuration;
         this.isRecovery = param2 < 0 || this.recoveryTime > param2;
      }
   }
}

