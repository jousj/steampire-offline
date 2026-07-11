package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanDivision implements IClientPacket
   {
      
      public var cd_num:uint;
      
      public var cd_reward:Array;
      
      public var cd_region:String;
      
      public var cd_mithril_min:uint;
      
      public var cd_ter_limit:int;
      
      public function PClanDivision()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Array, param3:String, param4:uint, param5:int) : PClanDivision
      {
         var _loc6_:PClanDivision = new PClanDivision();
         _loc6_.cd_num = param1;
         _loc6_.cd_reward = param2;
         _loc6_.cd_region = param3;
         _loc6_.cd_mithril_min = param4;
         _loc6_.cd_ter_limit = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PClanDivision
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PClanDivision = new PClanDivision();
         _loc2_.cd_num = param1.readUnsignedInt();
         _loc2_.cd_reward = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.cd_reward.length)
         {
            _loc2_.cd_reward[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.cd_region = param1.readUTF();
         _loc2_.cd_mithril_min = param1.readUnsignedInt();
         _loc2_.cd_ter_limit = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.cd_num);
         if(this.cd_reward == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.cd_reward.length);
            _loc2_ = 0;
            while(_loc2_ < this.cd_reward.length)
            {
               this.cd_reward[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeUTF(this.cd_region);
         param1.writeInt(this.cd_mithril_min);
         param1.writeInt(this.cd_ter_limit);
      }
   }
}

