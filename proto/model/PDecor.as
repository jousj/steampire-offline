package proto.model
{
   import engine.Position;
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PDecor implements IClientPacket
   {
      
      public var decor_id:uint;
      
      public var decor_kind:String;
      
      public var decor_pos:Position;
      
      public function PDecor()
      {
         super();
      }
      
      public static function create(param1:uint, param2:String, param3:Position) : PDecor
      {
         var _loc4_:PDecor = new PDecor();
         _loc4_.decor_id = param1;
         _loc4_.decor_kind = param2;
         _loc4_.decor_pos = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PDecor
      {
         var _loc2_:PDecor = new PDecor();
         _loc2_.decor_id = param1.readUnsignedInt();
         _loc2_.decor_kind = param1.readUTF();
         _loc2_.decor_pos = Position.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.decor_id);
         param1.writeUTF(this.decor_kind);
         this.decor_pos.write(param1);
      }
   }
}

