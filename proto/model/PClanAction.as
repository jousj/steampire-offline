package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanAction implements IClientPacket
   {
      
      public static const UNKNOWN:uint = 17;
      
      public static const BUY_RESOURCES_PACK:uint = 16;
      
      public static const CANCEL_STUDY:uint = 15;
      
      public static const SPEED_UP_STUDY:uint = 14;
      
      public static const START_STUDY:uint = 13;
      
      public static const BUY_RESOURCE_BY_GOLD:uint = 12;
      
      public static const SELL_DECOR:uint = 11;
      
      public static const CANCEL_REMOVE_GARBAGE:uint = 10;
      
      public static const CANCEL_CONSTRUCTING_CANNON:uint = 9;
      
      public static const CANCEL_CONSTRUCTING_BUILDING:uint = 8;
      
      public static const SPEED_UP_GARBAGE:uint = 7;
      
      public static const REMOVE_GARBAGE:uint = 6;
      
      public static const COLLECT_RESOURCE:uint = 5;
      
      public static const MOVE:uint = 4;
      
      public static const UPGRADE:uint = 3;
      
      public static const SPEED_UP_CANNON:uint = 2;
      
      public static const SPEED_UP_BUILDING:uint = 1;
      
      public static const BUY_OBJECT:uint = 0;
      
      public var variance:uint;
      
      public var value:*;
      
      public function PClanAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:*) : PClanAction
      {
         var _loc3_:PClanAction = new PClanAction();
         _loc3_.variance = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PClanAction
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PClanAction = new PClanAction();
         _loc2_.variance = param1.readUnsignedByte();
         switch(_loc2_.variance)
         {
            case 0:
               _loc2_.value = PBoardObj.read(param1);
               break;
            case 1:
               _loc2_.value = PSpeedUp.read(param1);
               break;
            case 2:
               _loc2_.value = PSpeedUp.read(param1);
               break;
            case 3:
               _loc2_.value = PObjectId.read(param1);
               break;
            case 4:
               _loc2_.value = new Array(param1.readUnsignedShort());
               _loc3_ = 0;
               while(_loc3_ < _loc2_.value.length)
               {
                  _loc2_.value[_loc3_] = _loc4_ = PMove.read(param1);
                  _loc3_++;
               }
               break;
            case 5:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 6:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 7:
               _loc2_.value = PSpeedUp.read(param1);
               break;
            case 8:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 9:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 10:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 11:
               _loc2_.value = param1.readUnsignedInt();
               break;
            case 12:
               _loc2_.value = PCost.read(param1);
               break;
            case 13:
               _loc2_.value = PStartStudy.read(param1);
               break;
            case 14:
               _loc2_.value = PSpeedUp.read(param1);
               break;
            case 15:
               _loc2_.value = PStartStudy.read(param1);
               break;
            case 16:
               _loc2_.value = param1.readUTF();
               break;
            case 17:
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
               (this.value as PBoardObj).write(param1);
               break;
            case 1:
               (this.value as PSpeedUp).write(param1);
               break;
            case 2:
               (this.value as PSpeedUp).write(param1);
               break;
            case 3:
               (this.value as PObjectId).write(param1);
               break;
            case 4:
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
            case 5:
               param1.writeInt(this.value as uint);
               break;
            case 6:
               param1.writeInt(this.value as uint);
               break;
            case 7:
               (this.value as PSpeedUp).write(param1);
               break;
            case 8:
               param1.writeInt(this.value as uint);
               break;
            case 9:
               param1.writeInt(this.value as uint);
               break;
            case 10:
               param1.writeInt(this.value as uint);
               break;
            case 11:
               param1.writeInt(this.value as uint);
               break;
            case 12:
               (this.value as PCost).write(param1);
               break;
            case 13:
               (this.value as PStartStudy).write(param1);
               break;
            case 14:
               (this.value as PSpeedUp).write(param1);
               break;
            case 15:
               (this.value as PStartStudy).write(param1);
               break;
            case 16:
               param1.writeUTF(this.value as String);
               break;
            case 17:
               break;
            default:
               throw new Error("Packet incorrect");
         }
      }
   }
}

