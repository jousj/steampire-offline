package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PTerLog implements IClientPacket
   {
      
      public var time:Number;
      
      public var clan_name:String;
      
      public var action:PTerLogAction;
      
      public function PTerLog()
      {
         super();
      }
      
      public static function create(param1:Number, param2:String, param3:PTerLogAction) : PTerLog
      {
         var _loc4_:PTerLog = new PTerLog();
         _loc4_.time = param1;
         _loc4_.clan_name = param2;
         _loc4_.action = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PTerLog
      {
         var _loc2_:PTerLog = new PTerLog();
         _loc2_.time = param1.readDouble();
         _loc2_.clan_name = param1.readUTF();
         _loc2_.action = PTerLogAction.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeDouble(this.time);
         param1.writeUTF(this.clan_name);
         this.action.write(param1);
      }
   }
}

