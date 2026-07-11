package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PWarOpponent implements IClientPacket
   {
      
      public var wo_id:String;
      
      public var wo_name:String;
      
      public var wo_role:PRole;
      
      public var wo_level:uint;
      
      public var wo_ratio:uint;
      
      public var wo_busy:PBusyState;
      
      public var wo_snetwork:String;
      
      public var wo_avatar:String;
      
      public var wo_warpoints:int;
      
      public function PWarOpponent()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:PRole, param4:uint, param5:uint, param6:PBusyState, param7:String, param8:String, param9:int) : PWarOpponent
      {
         var _loc10_:PWarOpponent = new PWarOpponent();
         _loc10_.wo_id = param1;
         _loc10_.wo_name = param2;
         _loc10_.wo_role = param3;
         _loc10_.wo_level = param4;
         _loc10_.wo_ratio = param5;
         _loc10_.wo_busy = param6;
         _loc10_.wo_snetwork = param7;
         _loc10_.wo_avatar = param8;
         _loc10_.wo_warpoints = param9;
         return _loc10_;
      }
      
      public static function read(param1:IDataInput) : PWarOpponent
      {
         var _loc2_:PWarOpponent = new PWarOpponent();
         _loc2_.wo_id = param1.readUTF();
         _loc2_.wo_name = param1.readUTF();
         _loc2_.wo_role = PRole.read(param1);
         _loc2_.wo_level = param1.readUnsignedInt();
         _loc2_.wo_ratio = param1.readUnsignedInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.wo_busy = PBusyState.read(param1);
         }
         else
         {
            _loc2_.wo_busy = null;
         }
         _loc2_.wo_snetwork = param1.readUTF();
         _loc2_.wo_avatar = param1.readUTF();
         _loc2_.wo_warpoints = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.wo_id);
         param1.writeUTF(this.wo_name);
         this.wo_role.write(param1);
         param1.writeInt(this.wo_level);
         param1.writeInt(this.wo_ratio);
         if(this.wo_busy != null)
         {
            param1.writeByte(1);
            this.wo_busy.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeUTF(this.wo_snetwork);
         param1.writeUTF(this.wo_avatar);
         param1.writeInt(this.wo_warpoints);
      }
   }
}

