package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PAsk implements IClientPacket
   {
      
      public var ask_user_id:String;
      
      public var ask_user_name:String;
      
      public var ask_user_level:uint;
      
      public var ask_time:Number;
      
      public var ask_data:PAskData;
      
      public var ask_is_help:Boolean;
      
      public var ask_value:PAskValue;
      
      public function PAsk()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:uint, param4:Number, param5:PAskData, param6:Boolean, param7:PAskValue) : PAsk
      {
         var _loc8_:PAsk = new PAsk();
         _loc8_.ask_user_id = param1;
         _loc8_.ask_user_name = param2;
         _loc8_.ask_user_level = param3;
         _loc8_.ask_time = param4;
         _loc8_.ask_data = param5;
         _loc8_.ask_is_help = param6;
         _loc8_.ask_value = param7;
         return _loc8_;
      }
      
      public static function read(param1:IDataInput) : PAsk
      {
         var _loc2_:PAsk = new PAsk();
         _loc2_.ask_user_id = param1.readUTF();
         _loc2_.ask_user_name = param1.readUTF();
         _loc2_.ask_user_level = param1.readUnsignedInt();
         _loc2_.ask_time = param1.readDouble();
         _loc2_.ask_data = PAskData.read(param1);
         _loc2_.ask_is_help = param1.readBoolean();
         _loc2_.ask_value = PAskValue.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.ask_user_id);
         param1.writeUTF(this.ask_user_name);
         param1.writeInt(this.ask_user_level);
         param1.writeDouble(this.ask_time);
         this.ask_data.write(param1);
         param1.writeBoolean(this.ask_is_help);
         this.ask_value.write(param1);
      }
   }
}

