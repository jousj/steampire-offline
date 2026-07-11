package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.clan.PCallRequest;
   import proto.model.clan.PClan;
   
   public class PHome implements IClientPacket
   {
      
      public var um:PUm;
      
      public var dt:Number;
      
      public var shield_time_opt:Number;
      
      public var clan:PClan;
      
      public var clan_requests:Array;
      
      public function PHome()
      {
         super();
      }
      
      public static function create(param1:PUm, param2:Number, param3:Number, param4:PClan, param5:Array) : PHome
      {
         var _loc6_:PHome = new PHome();
         _loc6_.um = param1;
         _loc6_.dt = param2;
         _loc6_.shield_time_opt = param3;
         _loc6_.clan = param4;
         _loc6_.clan_requests = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PHome
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PHome = new PHome();
         _loc2_.um = PUm.read(param1);
         _loc2_.dt = param1.readDouble();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.shield_time_opt = param1.readDouble();
         }
         else
         {
            _loc2_.shield_time_opt = NaN;
         }
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.clan = PClan.read(param1);
         }
         else
         {
            _loc2_.clan = null;
         }
         _loc2_.clan_requests = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.clan_requests.length)
         {
            _loc2_.clan_requests[_loc3_] = _loc4_ = PCallRequest.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         this.um.write(param1);
         param1.writeDouble(this.dt);
         if(!isNaN(this.shield_time_opt))
         {
            param1.writeByte(1);
            param1.writeDouble(this.shield_time_opt);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.clan != null)
         {
            param1.writeByte(1);
            this.clan.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.clan_requests == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.clan_requests.length);
            _loc2_ = 0;
            while(_loc2_ < this.clan_requests.length)
            {
               this.clan_requests[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

