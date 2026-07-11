package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PMissionPercentage implements IClientPacket
   {
      
      public var mp_mission_kind:String;
      
      public var mp_oil_perc:Number;
      
      public var mp_cry_perc:Number;
      
      public function PMissionPercentage()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number, param3:Number) : PMissionPercentage
      {
         var _loc4_:PMissionPercentage = new PMissionPercentage();
         _loc4_.mp_mission_kind = param1;
         _loc4_.mp_oil_perc = param2;
         _loc4_.mp_cry_perc = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PMissionPercentage
      {
         var _loc2_:PMissionPercentage = new PMissionPercentage();
         _loc2_.mp_mission_kind = param1.readUTF();
         _loc2_.mp_oil_perc = param1.readDouble();
         _loc2_.mp_cry_perc = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.mp_mission_kind);
         param1.writeDouble(this.mp_oil_perc);
         param1.writeDouble(this.mp_cry_perc);
      }
   }
}

