package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PTopRequest implements IClientPacket
   {
      
      public var name:String;
      
      public var from_place:Number;
      
      public var count:uint;
      
      public var can_invite:Boolean;
      
      public var for_war:Boolean;
      
      public var division:Number;
      
      public function PTopRequest()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number, param3:uint, param4:Boolean, param5:Boolean, param6:Number) : PTopRequest
      {
         var _loc7_:PTopRequest = new PTopRequest();
         _loc7_.name = param1;
         _loc7_.from_place = param2;
         _loc7_.count = param3;
         _loc7_.can_invite = param4;
         _loc7_.for_war = param5;
         _loc7_.division = param6;
         return _loc7_;
      }
      
      public static function read(param1:IDataInput) : PTopRequest
      {
         var _loc2_:PTopRequest = new PTopRequest();
         _loc2_.name = param1.readUTF();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.from_place = param1.readUnsignedInt();
         }
         else
         {
            _loc2_.from_place = NaN;
         }
         _loc2_.count = param1.readUnsignedInt();
         _loc2_.can_invite = param1.readBoolean();
         _loc2_.for_war = param1.readBoolean();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.division = param1.readUnsignedInt();
         }
         else
         {
            _loc2_.division = NaN;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.name);
         if(!isNaN(this.from_place))
         {
            param1.writeByte(1);
            param1.writeInt(this.from_place);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.count);
         param1.writeBoolean(this.can_invite);
         param1.writeBoolean(this.for_war);
         if(!isNaN(this.division))
         {
            param1.writeByte(1);
            param1.writeInt(this.division);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

