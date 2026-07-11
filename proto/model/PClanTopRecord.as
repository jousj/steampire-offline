package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanTopRecord implements IClientPacket
   {
      
      public var place:uint;
      
      public var id:String;
      
      public var name:String;
      
      public var clan_points:uint;
      
      public var members_count:uint;
      
      public var icon:String;
      
      public function PClanTopRecord()
      {
         super();
      }
      
      public static function create(param1:uint, param2:String, param3:String, param4:uint, param5:uint, param6:String) : PClanTopRecord
      {
         var _loc7_:PClanTopRecord = new PClanTopRecord();
         _loc7_.place = param1;
         _loc7_.id = param2;
         _loc7_.name = param3;
         _loc7_.clan_points = param4;
         _loc7_.members_count = param5;
         _loc7_.icon = param6;
         return _loc7_;
      }
      
      public static function read(param1:IDataInput) : PClanTopRecord
      {
         var _loc2_:PClanTopRecord = new PClanTopRecord();
         _loc2_.place = param1.readUnsignedInt();
         _loc2_.id = param1.readUTF();
         _loc2_.name = param1.readUTF();
         _loc2_.clan_points = param1.readUnsignedInt();
         _loc2_.members_count = param1.readUnsignedInt();
         _loc2_.icon = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.place);
         param1.writeUTF(this.id);
         param1.writeUTF(this.name);
         param1.writeInt(this.clan_points);
         param1.writeInt(this.members_count);
         param1.writeUTF(this.icon);
      }
   }
}

