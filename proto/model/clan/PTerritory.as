package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PTerritory implements IClientPacket
   {
      
      public var kind:String;
      
      public var clan_owner:PTerritoryOwner;
      
      public var level:int;
      
      public var state:PTerritoryState;
      
      public var logs:Array;
      
      public function PTerritory()
      {
         super();
      }
      
      public static function create(param1:String, param2:PTerritoryOwner, param3:int, param4:PTerritoryState, param5:Array) : PTerritory
      {
         var _loc6_:PTerritory = new PTerritory();
         _loc6_.kind = param1;
         _loc6_.clan_owner = param2;
         _loc6_.level = param3;
         _loc6_.state = param4;
         _loc6_.logs = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PTerritory
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PTerritory = new PTerritory();
         _loc2_.kind = param1.readUTF();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.clan_owner = PTerritoryOwner.read(param1);
         }
         else
         {
            _loc2_.clan_owner = null;
         }
         _loc2_.level = param1.readInt();
         _loc2_.state = PTerritoryState.read(param1);
         _loc2_.logs = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.logs.length)
         {
            _loc2_.logs[_loc3_] = _loc4_ = PTerLog.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.kind);
         if(this.clan_owner != null)
         {
            param1.writeByte(1);
            this.clan_owner.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         param1.writeInt(this.level);
         this.state.write(param1);
         if(this.logs == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.logs.length);
            _loc2_ = 0;
            while(_loc2_ < this.logs.length)
            {
               this.logs[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

