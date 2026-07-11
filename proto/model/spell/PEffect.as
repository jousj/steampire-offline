package proto.model.spell
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PEffect implements IClientPacket
   {
      
      public static const SHOCK:uint = 9;
      
      public static const FOG:uint = 8;
      
      public static const MULTIFIREBALL:uint = 7;
      
      public static const RAGE:uint = 6;
      
      public static const LOW_DAMAGE:uint = 5;
      
      public static const UNKNOWN:uint = 4;
      
      public static const WORKER:uint = 3;
      
      public static const CALL:uint = 2;
      
      public static const CURE:uint = 1;
      
      public static const FIREBALL:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PEffect()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PEffect
      {
         var _loc3_:PEffect = new PEffect();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PEffect
      {
         var _loc2_:PEffect = new PEffect();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = PFireball.read(param1);
               break;
            case 1:
               _loc2_.value = PCure.read(param1);
               break;
            case 2:
               _loc2_.value = PCall.read(param1);
               break;
            case 3:
               _loc2_.value = PCure.read(param1);
               break;
            case 4:
               break;
            case 5:
               _loc2_.value = PLowDamage.read(param1);
               break;
            case 6:
               _loc2_.value = PRage.read(param1);
               break;
            case 7:
               _loc2_.value = PMultifireball.read(param1);
               break;
            case 8:
               _loc2_.value = PFog.read(param1);
               break;
            case 9:
               _loc2_.value = PShock.read(param1);
               break;
            default:
               throw new Error("Packet incorrect");
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
         switch(this.variance)
         {
            case 0:
               (this.value as PFireball).write(param1);
               break;
            case 1:
               (this.value as PCure).write(param1);
               break;
            case 2:
               (this.value as PCall).write(param1);
               break;
            case 3:
               (this.value as PCure).write(param1);
               break;
            case 4:
               break;
            case 5:
               (this.value as PLowDamage).write(param1);
               break;
            case 6:
               (this.value as PRage).write(param1);
               break;
            case 7:
               (this.value as PMultifireball).write(param1);
               break;
            case 8:
               (this.value as PFog).write(param1);
               break;
            case 9:
               (this.value as PShock).write(param1);
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

