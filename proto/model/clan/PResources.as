package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PResources implements IClientPacket
   {
      
      public var crystal:int;
      
      public var oil:int;
      
      public var gold:int;
      
      public var trophy:int;
      
      public function PResources()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:int, param4:int) : PResources
      {
         var _loc5_:PResources = new PResources();
         _loc5_.crystal = param1;
         _loc5_.oil = param2;
         _loc5_.gold = param3;
         _loc5_.trophy = param4;
         return _loc5_;
      }
      
      public static function read(param1:IDataInput) : PResources
      {
         var _loc2_:PResources = new PResources();
         _loc2_.crystal = param1.readInt();
         _loc2_.oil = param1.readInt();
         _loc2_.gold = param1.readInt();
         _loc2_.trophy = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.crystal);
         param1.writeInt(this.oil);
         param1.writeInt(this.gold);
         param1.writeInt(this.trophy);
      }
   }
}

