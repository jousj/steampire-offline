package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PFightLogInfo implements IClientPacket
   {
      
      public var fli_user_id:String;
      
      public var fli_townhall_level:uint;
      
      public var fli_resources:Array;
      
      public var fli_is_online:Boolean;
      
      public var fli_shield_end_time:Number;
      
      public function PFightLogInfo()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:Array, param4:Boolean, param5:Number) : PFightLogInfo
      {
         var _loc6_:PFightLogInfo = new PFightLogInfo();
         _loc6_.fli_user_id = param1;
         _loc6_.fli_townhall_level = param2;
         _loc6_.fli_resources = param3;
         _loc6_.fli_is_online = param4;
         _loc6_.fli_shield_end_time = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PFightLogInfo
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PFightLogInfo = new PFightLogInfo();
         _loc2_.fli_user_id = param1.readUTF();
         _loc2_.fli_townhall_level = param1.readUnsignedInt();
         _loc2_.fli_resources = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.fli_resources.length)
         {
            _loc2_.fli_resources[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.fli_is_online = param1.readBoolean();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.fli_shield_end_time = param1.readDouble();
         }
         else
         {
            _loc2_.fli_shield_end_time = NaN;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.fli_user_id);
         param1.writeInt(this.fli_townhall_level);
         if(this.fli_resources == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.fli_resources.length);
            _loc2_ = 0;
            while(_loc2_ < this.fli_resources.length)
            {
               this.fli_resources[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeBoolean(this.fli_is_online);
         if(!isNaN(this.fli_shield_end_time))
         {
            param1.writeByte(1);
            param1.writeDouble(this.fli_shield_end_time);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

