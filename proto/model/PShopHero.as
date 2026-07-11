package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopHero implements IClientPacket
   {
      
      public var sh_kind:String;
      
      public var sh_level:int;
      
      public var sh_unit_kind:String;
      
      public var sh_reg_time:Number;
      
      public var sh_raid_reward:Array;
      
      public function PShopHero()
      {
         super();
      }
      
      public static function create(param1:String, param2:int, param3:String, param4:Number, param5:Array) : PShopHero
      {
         var _loc6_:PShopHero = new PShopHero();
         _loc6_.sh_kind = param1;
         _loc6_.sh_level = param2;
         _loc6_.sh_unit_kind = param3;
         _loc6_.sh_reg_time = param4;
         _loc6_.sh_raid_reward = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PShopHero
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PShopHero = new PShopHero();
         _loc2_.sh_kind = param1.readUTF();
         _loc2_.sh_level = param1.readInt();
         _loc2_.sh_unit_kind = param1.readUTF();
         _loc2_.sh_reg_time = param1.readDouble();
         _loc2_.sh_raid_reward = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.sh_raid_reward.length)
         {
            _loc2_.sh_raid_reward[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.sh_kind);
         param1.writeInt(this.sh_level);
         param1.writeUTF(this.sh_unit_kind);
         param1.writeDouble(this.sh_reg_time);
         if(this.sh_raid_reward == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.sh_raid_reward.length);
            _loc2_ = 0;
            while(_loc2_ < this.sh_raid_reward.length)
            {
               this.sh_raid_reward[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

