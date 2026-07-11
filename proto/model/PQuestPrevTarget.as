package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PQuestPrevTarget implements IClientPacket
   {
      
      public var prev_quest_id:String;
      
      public var prev_target_num:uint;
      
      public function PQuestPrevTarget()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint) : PQuestPrevTarget
      {
         var _loc3_:PQuestPrevTarget = new PQuestPrevTarget();
         _loc3_.prev_quest_id = param1;
         _loc3_.prev_target_num = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PQuestPrevTarget
      {
         var _loc2_:PQuestPrevTarget = new PQuestPrevTarget();
         _loc2_.prev_quest_id = param1.readUTF();
         _loc2_.prev_target_num = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.prev_quest_id);
         param1.writeByte(this.prev_target_num);
      }
   }
}

