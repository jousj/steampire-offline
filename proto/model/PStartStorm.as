package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PStartStorm implements IClientPacket
   {
      
      public var attacker_id:String;
      
      public var start_time:Number;
      
      public var territory:String;
      
      public function PStartStorm()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number, param3:String) : PStartStorm
      {
         var _loc4_:PStartStorm = new PStartStorm();
         _loc4_.attacker_id = param1;
         _loc4_.start_time = param2;
         _loc4_.territory = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PStartStorm
      {
         var _loc2_:PStartStorm = new PStartStorm();
         _loc2_.attacker_id = param1.readUTF();
         _loc2_.start_time = param1.readDouble();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.territory = param1.readUTF();
         }
         else
         {
            _loc2_.territory = null;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.attacker_id);
         param1.writeDouble(this.start_time);
         if(this.territory != null)
         {
            param1.writeByte(1);
            param1.writeUTF(this.territory);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

