package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PUserTop implements IClientPacket
   {
      
      public var ut_id:String;
      
      public var ut_place:int;
      
      public var ut_name:String;
      
      public var ut_snetwork:String;
      
      public var ut_level:int;
      
      public var ut_ratio:int;
      
      public var ut_achv_points:int;
      
      public var ut_clan:PClanInfo;
      
      public function PUserTop()
      {
         super();
      }
      
      public static function create(param1:String, param2:int, param3:String, param4:String, param5:int, param6:int, param7:int, param8:PClanInfo) : PUserTop
      {
         var _loc9_:PUserTop = new PUserTop();
         _loc9_.ut_id = param1;
         _loc9_.ut_place = param2;
         _loc9_.ut_name = param3;
         _loc9_.ut_snetwork = param4;
         _loc9_.ut_level = param5;
         _loc9_.ut_ratio = param6;
         _loc9_.ut_achv_points = param7;
         _loc9_.ut_clan = param8;
         return _loc9_;
      }
      
      public static function read(param1:IDataInput) : PUserTop
      {
         var _loc2_:PUserTop = new PUserTop();
         _loc2_.ut_id = param1.readUTF();
         _loc2_.ut_place = param1.readInt();
         _loc2_.ut_name = param1.readUTF();
         _loc2_.ut_snetwork = param1.readUTF();
         _loc2_.ut_level = param1.readInt();
         _loc2_.ut_ratio = param1.readInt();
         _loc2_.ut_achv_points = param1.readInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.ut_clan = PClanInfo.read(param1);
         }
         else
         {
            _loc2_.ut_clan = null;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.ut_id);
         param1.writeInt(this.ut_place);
         param1.writeUTF(this.ut_name);
         param1.writeUTF(this.ut_snetwork);
         param1.writeInt(this.ut_level);
         param1.writeInt(this.ut_ratio);
         param1.writeInt(this.ut_achv_points);
         if(this.ut_clan != null)
         {
            param1.writeByte(1);
            this.ut_clan.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

