package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCurrentFight implements IClientPacket
   {
      
      public var fight_time:uint;
      
      public var fight_commands:Array;
      
      public var target_info:PTargetInfo;
      
      public function PCurrentFight()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Array, param3:PTargetInfo) : PCurrentFight
      {
         var _loc4_:PCurrentFight = new PCurrentFight();
         _loc4_.fight_time = param1;
         _loc4_.fight_commands = param2;
         _loc4_.target_info = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PCurrentFight
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PCurrentFight = new PCurrentFight();
         _loc2_.fight_time = param1.readUnsignedInt();
         _loc2_.fight_commands = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.fight_commands.length)
         {
            _loc2_.fight_commands[_loc3_] = _loc4_ = PCommand.read(param1);
            _loc3_++;
         }
         _loc2_.target_info = PTargetInfo.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeInt(this.fight_time);
         if(this.fight_commands == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.fight_commands.length);
            _loc2_ = 0;
            while(_loc2_ < this.fight_commands.length)
            {
               this.fight_commands[_loc2_].write(param1);
               _loc2_++;
            }
         }
         this.target_info.write(param1);
      }
   }
}

