package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PTerritoryLevel implements IClientPacket
   {
      
      public var kind:String;
      
      public var level:int;
      
      public var regent:String;
      
      public function PTerritoryLevel()
      {
         super();
      }
      
      public static function create(param1:String, param2:int, param3:String) : PTerritoryLevel
      {
         var _loc4_:PTerritoryLevel = new PTerritoryLevel();
         _loc4_.kind = param1;
         _loc4_.level = param2;
         _loc4_.regent = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PTerritoryLevel
      {
         var _loc2_:PTerritoryLevel = new PTerritoryLevel();
         _loc2_.kind = param1.readUTF();
         _loc2_.level = param1.readInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.regent = param1.readUTF();
         }
         else
         {
            _loc2_.regent = null;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.kind);
         param1.writeInt(this.level);
         if(this.regent != null)
         {
            param1.writeByte(1);
            param1.writeUTF(this.regent);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

