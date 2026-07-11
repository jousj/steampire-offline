package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopBoss implements IClientPacket
   {
      
      public var sb_num:int;
      
      public var sb_mission_from:String;
      
      public var sb_mission_base:String;
      
      public function PShopBoss()
      {
         super();
      }
      
      public static function create(param1:int, param2:String, param3:String) : PShopBoss
      {
         var _loc4_:PShopBoss = new PShopBoss();
         _loc4_.sb_num = param1;
         _loc4_.sb_mission_from = param2;
         _loc4_.sb_mission_base = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PShopBoss
      {
         var _loc2_:PShopBoss = new PShopBoss();
         _loc2_.sb_num = param1.readInt();
         _loc2_.sb_mission_from = param1.readUTF();
         _loc2_.sb_mission_base = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.sb_num);
         param1.writeUTF(this.sb_mission_from);
         param1.writeUTF(this.sb_mission_base);
      }
   }
}

