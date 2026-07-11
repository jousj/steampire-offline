package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PSended implements IClientPacket
   {
      
      public var s_call:int;
      
      public var s_crystal:int;
      
      public var s_oil:int;
      
      public var s_gold:int;
      
      public function PSended()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:int, param4:int) : PSended
      {
         var _loc5_:PSended = new PSended();
         _loc5_.s_call = param1;
         _loc5_.s_crystal = param2;
         _loc5_.s_oil = param3;
         _loc5_.s_gold = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PSended
      {
         var _loc2_:PSended = new PSended();
         _loc2_.s_call = param1.readInt();
         _loc2_.s_crystal = param1.readInt();
         _loc2_.s_oil = param1.readInt();
         _loc2_.s_gold = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.s_call);
         param1.writeInt(this.s_crystal);
         param1.writeInt(this.s_oil);
         param1.writeInt(this.s_gold);
      }
   }
}

