package proto.game.family_0040
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PPhfClan;
   
   public class PFriendInfo implements IClientPacket
   {
      
      public var fr_social_id:String;
      
      public var fr_id:String;
      
      public var fr_level:int;
      
      public var fr_clan:PPhfClan;
      
      public var fr_req_crystal:int;
      
      public var fr_req_oil:int;
      
      public var fr_req_time:Number;
      
      public var fr_req_call:int;
      
      public function PFriendInfo()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:int, param4:PPhfClan, param5:int, param6:int, param7:Number, param8:int) : PFriendInfo
      {
         var _loc9_:PFriendInfo = new PFriendInfo();
         _loc9_.fr_social_id = param1;
         _loc9_.fr_id = param2;
         _loc9_.fr_level = param3;
         _loc9_.fr_clan = param4;
         _loc9_.fr_req_crystal = param5;
         _loc9_.fr_req_oil = param6;
         _loc9_.fr_req_time = param7;
         _loc9_.fr_req_call = param8;
         return _loc9_;
      }
      
      public static function read(param1:IDataInput) : PFriendInfo
      {
         var _loc2_:PFriendInfo = new PFriendInfo();
         _loc2_.fr_social_id = param1.readUTF();
         _loc2_.fr_id = param1.readUTF();
         _loc2_.fr_level = param1.readInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.fr_clan = PPhfClan.read(param1);
         }
         else
         {
            _loc2_.fr_clan = null;
         }
         _loc2_.fr_req_crystal = param1.readInt();
         _loc2_.fr_req_oil = param1.readInt();
         _loc2_.fr_req_time = param1.readDouble();
         _loc2_.fr_req_call = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.fr_social_id);
         param1.writeUTF(this.fr_id);
         param1.writeInt(this.fr_level);
         if(this.fr_clan != null)
         {
            param1.writeByte(1);
            this.fr_clan.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.fr_req_crystal);
         param1.writeInt(this.fr_req_oil);
         param1.writeDouble(this.fr_req_time);
         param1.writeInt(this.fr_req_call);
      }
   }
}

