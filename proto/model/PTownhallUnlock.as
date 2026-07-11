package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.tuples.str_i;
   
   public class PTownhallUnlock implements IClientPacket
   {
      
      public var tu_level:uint;
      
      public var tu_unlocks:Array;
      
      public var tu_find_target_price:PCost;
      
      public var tu_storage_fight_k:Number;
      
      public var tu_req_crystal:int;
      
      public var tu_req_oil:int;
      
      public var tu_req_time:Number;
      
      public var tu_req_call:int;
      
      public var tu_calls:int;
      
      public function PTownhallUnlock()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Array, param3:PCost, param4:Number, param5:int, param6:int, param7:Number, param8:int, param9:int) : PTownhallUnlock
      {
         var _loc10_:PTownhallUnlock = new PTownhallUnlock();
         _loc10_.tu_level = param1;
         _loc10_.tu_unlocks = param2;
         _loc10_.tu_find_target_price = param3;
         _loc10_.tu_storage_fight_k = param4;
         _loc10_.tu_req_crystal = param5;
         _loc10_.tu_req_oil = param6;
         _loc10_.tu_req_time = param7;
         _loc10_.tu_req_call = param8;
         _loc10_.tu_calls = param9;
         return _loc10_;
      }
      
      public static function read(param1:IDataInput) : PTownhallUnlock
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PTownhallUnlock = new PTownhallUnlock();
         _loc2_.tu_level = param1.readUnsignedByte();
         _loc2_.tu_unlocks = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.tu_unlocks.length)
         {
            _loc2_.tu_unlocks[_loc3_] = _loc4_ = str_i.read(param1);
            _loc3_++;
         }
         _loc2_.tu_find_target_price = PCost.read(param1);
         _loc2_.tu_storage_fight_k = param1.readDouble();
         _loc2_.tu_req_crystal = param1.readInt();
         _loc2_.tu_req_oil = param1.readInt();
         _loc2_.tu_req_time = param1.readDouble();
         _loc2_.tu_req_call = param1.readInt();
         _loc2_.tu_calls = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeByte(this.tu_level);
         if(this.tu_unlocks == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.tu_unlocks.length);
            _loc2_ = 0;
            while(_loc2_ < this.tu_unlocks.length)
            {
               this.tu_unlocks[_loc2_].write(param1);
               _loc2_++;
            }
         }
         this.tu_find_target_price.write(param1);
         param1.writeDouble(this.tu_storage_fight_k);
         param1.writeInt(this.tu_req_crystal);
         param1.writeInt(this.tu_req_oil);
         param1.writeDouble(this.tu_req_time);
         param1.writeInt(this.tu_req_call);
         param1.writeInt(this.tu_calls);
      }
   }
}

