package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClientSimRes implements IClientPacket
   {
      
      public var cl_fight_id:String;
      
      public var cl_commands:Array;
      
      public var cl_prize:Array;
      
      public var cl_percentage:int;
      
      public var cl_is_win:Boolean;
      
      public function PClientSimRes()
      {
         super();
      }
      
      public static function create(param1:String, param2:Array, param3:Array, param4:int, param5:Boolean) : PClientSimRes
      {
         var _loc6_:PClientSimRes = new PClientSimRes();
         _loc6_.cl_fight_id = param1;
         _loc6_.cl_commands = param2;
         _loc6_.cl_prize = param3;
         _loc6_.cl_percentage = param4;
         _loc6_.cl_is_win = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PClientSimRes
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PClientSimRes = new PClientSimRes();
         _loc2_.cl_fight_id = param1.readUTF();
         _loc2_.cl_commands = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.cl_commands.length)
         {
            _loc2_.cl_commands[_loc3_] = _loc4_ = PCommand.read(param1);
            _loc3_++;
         }
         _loc2_.cl_prize = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.cl_prize.length)
         {
            _loc2_.cl_prize[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.cl_percentage = param1.readInt();
         _loc2_.cl_is_win = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.cl_fight_id);
         if(this.cl_commands == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.cl_commands.length);
            _loc2_ = 0;
            while(_loc2_ < this.cl_commands.length)
            {
               this.cl_commands[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.cl_prize == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.cl_prize.length);
            _loc2_ = 0;
            while(_loc2_ < this.cl_prize.length)
            {
               this.cl_prize[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.cl_percentage);
         param1.writeBoolean(this.cl_is_win);
      }
   }
}

