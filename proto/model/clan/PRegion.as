package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PRegion implements IClientPacket
   {
      
      public var clan_base:PBase;
      
      public var territories:Array;
      
      public function PRegion()
      {
         super();
      }
      
      public static function create(param1:PBase, param2:Array) : PRegion
      {
         var _loc3_:PRegion = new PRegion();
         _loc3_.clan_base = param1;
         _loc3_.territories = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PRegion
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PRegion = new PRegion();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.clan_base = PBase.read(param1);
         }
         else
         {
            _loc2_.clan_base = null;
         }
         _loc2_.territories = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.territories.length)
         {
            _loc2_.territories[_loc3_] = _loc4_ = PTerritory.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         if(this.clan_base != null)
         {
            param1.writeByte(1);
            this.clan_base.write(param1);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.territories == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.territories.length);
            _loc2_ = 0;
            while(_loc2_ < this.territories.length)
            {
               this.territories[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

