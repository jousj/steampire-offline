package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PFightAttakerInfo implements IClientPacket
   {
      
      public var fat_id:String;
      
      public var fat_name:String;
      
      public var fat_avatar:String;
      
      public var fat_time:Number;
      
      public var fat_clan:PPhfClan;
      
      public function PFightAttakerInfo()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:String, param4:Number, param5:PPhfClan) : PFightAttakerInfo
      {
         var _loc6_:PFightAttakerInfo = new PFightAttakerInfo();
         _loc6_.fat_id = param1;
         _loc6_.fat_name = param2;
         _loc6_.fat_avatar = param3;
         _loc6_.fat_time = param4;
         _loc6_.fat_clan = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PFightAttakerInfo
      {
         var _loc2_:PFightAttakerInfo = new PFightAttakerInfo();
         _loc2_.fat_id = param1.readUTF();
         _loc2_.fat_name = param1.readUTF();
         _loc2_.fat_avatar = param1.readUTF();
         _loc2_.fat_time = param1.readDouble();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.fat_clan = PPhfClan.read(param1);
         }
         else
         {
            _loc2_.fat_clan = null;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.fat_id);
         param1.writeUTF(this.fat_name);
         param1.writeUTF(this.fat_avatar);
         param1.writeDouble(this.fat_time);
         if(this.fat_clan != null)
         {
            param1.writeByte(1);
            this.fat_clan.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

