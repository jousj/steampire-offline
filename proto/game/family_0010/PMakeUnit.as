package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PMakeUnit implements IClientPacket
   {
      
      public var mu_kind:String;
      
      public var mu_count:uint;
      
      public function PMakeUnit()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint) : PMakeUnit
      {
         var _loc3_:PMakeUnit = new PMakeUnit();
         _loc3_.mu_kind = param1;
         _loc3_.mu_count = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PMakeUnit
      {
         var _loc2_:PMakeUnit = new PMakeUnit();
         _loc2_.mu_kind = param1.readUTF();
         _loc2_.mu_count = param1.readUnsignedInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.mu_kind);
         param1.writeInt(this.mu_count);
      }
   }
}

