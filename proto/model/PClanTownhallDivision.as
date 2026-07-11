package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanTownhallDivision implements IClientPacket
   {
      
      public var townhall:int;
      
      public var division:int;
      
      public var townhall_upgrade_reward:Array;
      
      public function PClanTownhallDivision()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:Array) : PClanTownhallDivision
      {
         var _loc4_:PClanTownhallDivision = new PClanTownhallDivision();
         _loc4_.townhall = param1;
         _loc4_.division = param2;
         _loc4_.townhall_upgrade_reward = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PClanTownhallDivision
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PClanTownhallDivision = new PClanTownhallDivision();
         _loc2_.townhall = param1.readInt();
         _loc2_.division = param1.readInt();
         _loc2_.townhall_upgrade_reward = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.townhall_upgrade_reward.length)
         {
            _loc2_.townhall_upgrade_reward[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.townhall);
         param1.writeInt(this.division);
         if(this.townhall_upgrade_reward == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.townhall_upgrade_reward.length);
            _loc2_ = 0;
            while(_loc2_ < this.townhall_upgrade_reward.length)
            {
               this.townhall_upgrade_reward[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

