package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PStormTerritory implements IClientPacket
   {
      
      public var st_ter_kind:String;
      
      public var st_ter_level:int;
      
      public var st_owner_clan_id:String;
      
      public var st_attacker_clan_id:String;
      
      public var st_regent:Boolean;
      
      public function PStormTerritory()
      {
         super();
      }
      
      public static function create(param1:String, param2:int, param3:String, param4:String, param5:Boolean) : PStormTerritory
      {
         var _loc6_:PStormTerritory = new PStormTerritory();
         _loc6_.st_ter_kind = param1;
         _loc6_.st_ter_level = param2;
         _loc6_.st_owner_clan_id = param3;
         _loc6_.st_attacker_clan_id = param4;
         _loc6_.st_regent = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PStormTerritory
      {
         var _loc2_:PStormTerritory = new PStormTerritory();
         _loc2_.st_ter_kind = param1.readUTF();
         _loc2_.st_ter_level = param1.readInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.st_owner_clan_id = param1.readUTF();
         }
         else
         {
            _loc2_.st_owner_clan_id = null;
         }
         _loc2_.st_attacker_clan_id = param1.readUTF();
         _loc2_.st_regent = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.st_ter_kind);
         param1.writeInt(this.st_ter_level);
         if(this.st_owner_clan_id != null)
         {
            param1.writeByte(1);
            param1.writeUTF(this.st_owner_clan_id);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeUTF(this.st_attacker_clan_id);
         param1.writeBoolean(this.st_regent);
      }
   }
}

