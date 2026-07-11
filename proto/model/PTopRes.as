package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PTopRes implements IClientPacket
   {
      
      public var users:Array;
      
      public var me:PUserTop;
      
      public var full_count:int;
      
      public var dnum:Number;
      
      public function PTopRes()
      {
         super();
      }
      
      public static function create(param1:Array, param2:PUserTop, param3:int, param4:Number) : PTopRes
      {
         var _loc5_:PTopRes = new PTopRes();
         _loc5_.users = param1;
         _loc5_.me = param2;
         _loc5_.full_count = param3;
         _loc5_.dnum = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PTopRes
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PTopRes = new PTopRes();
         _loc2_.users = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.users.length)
         {
            _loc2_.users[_loc3_] = _loc4_ = PUserTop.read(param1);
            _loc3_++;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.me = PUserTop.read(param1);
         }
         else
         {
            _loc2_.me = null;
         }
         _loc2_.full_count = param1.readInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.dnum = param1.readInt();
         }
         else
         {
            _loc2_.dnum = NaN;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         if(this.users == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.users.length);
            _loc2_ = 0;
            while(_loc2_ < this.users.length)
            {
               this.users[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.me != null)
         {
            param1.writeByte(1);
            this.me.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.full_count);
         if(!isNaN(this.dnum))
         {
            param1.writeByte(1);
            param1.writeInt(this.dnum);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

