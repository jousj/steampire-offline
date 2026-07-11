package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PTerritoryOwner implements IClientPacket
   {
      
      public var to_clan_id:String;
      
      public var to_clan_icon:String;
      
      public var to_clan_name:String;
      
      public var regent:PRegent;
      
      public function PTerritoryOwner()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:String, param4:PRegent) : PTerritoryOwner
      {
         var _loc5_:PTerritoryOwner = new PTerritoryOwner();
         _loc5_.to_clan_id = param1;
         _loc5_.to_clan_icon = param2;
         _loc5_.to_clan_name = param3;
         _loc5_.regent = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PTerritoryOwner
      {
         var _loc2_:PTerritoryOwner = new PTerritoryOwner();
         _loc2_.to_clan_id = param1.readUTF();
         _loc2_.to_clan_icon = param1.readUTF();
         _loc2_.to_clan_name = param1.readUTF();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.regent = PRegent.read(param1);
         }
         else
         {
            _loc2_.regent = null;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.to_clan_id);
         param1.writeUTF(this.to_clan_icon);
         param1.writeUTF(this.to_clan_name);
         if(this.regent != null)
         {
            param1.writeByte(1);
            this.regent.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

