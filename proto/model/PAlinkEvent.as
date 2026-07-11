package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_i;
   
   public class PAlinkEvent implements IClientPacket
   {
      
      public static const SHIELD:uint = 4;
      
      public static const UNIT:uint = 3;
      
      public static const UNKNOWN:uint = 2;
      
      public static const MESSAGE:uint = 1;
      
      public static const COSTS:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PAlinkEvent()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PAlinkEvent
      {
         var _loc3_:PAlinkEvent = new PAlinkEvent();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PAlinkEvent
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PAlinkEvent = new PAlinkEvent();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = new Array(param1.readUnsignedShort());
               _loc3_ = 0;
               while(_loc3_ < _loc2_.value.length)
               {
                  _loc2_.value[_loc3_] = _loc4_ = PCost.read(param1);
                  _loc3_++;
               }
               break;
            case 1:
               _loc2_.value = param1.readUTF();
               break;
            case 2:
               break;
            case 3:
               _loc2_.value = str_i.read(param1);
               break;
            case 4:
               if(param1.readUnsignedByte() == 1)
               {
                  _loc2_.value = param1.readDouble();
                  break;
               }
               _loc2_.value = NaN;
               break;
            default:
               throw new Error("Packet incorrect");
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeByte(this.variance);
         switch(this.variance)
         {
            case 0:
               if(this.value as Array == null)
               {
                  param1.writeShort(0);
                  break;
               }
               param1.writeShort((this.value as Array).length);
               _loc2_ = 0;
               while(_loc2_ < (this.value as Array).length)
               {
                  (this.value as Array)[_loc2_].write(param1);
                  _loc2_++;
               }
               break;
            case 1:
               param1.writeUTF(this.value as String);
               break;
            case 2:
               break;
            case 3:
               (this.value as str_i).write(param1);
               break;
            case 4:
               if(!isNaN(this.value as Number))
               {
                  param1.writeByte(1);
                  param1.writeDouble(this.value as Number);
                  break;
               }
               param1.writeByte(0);
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

