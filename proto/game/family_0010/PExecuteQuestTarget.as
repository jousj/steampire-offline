package proto.game.family_0010
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PExecuteQuestTarget implements IClientPacket
   {
      
      public var eqt_quest_name:String;
      
      public var eqt_target_num:uint;
      
      public function PExecuteQuestTarget()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint) : PExecuteQuestTarget
      {
         var _loc3_:PExecuteQuestTarget = new PExecuteQuestTarget();
         _loc3_.eqt_quest_name = param1;
         _loc3_.eqt_target_num = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PExecuteQuestTarget
      {
         var _loc2_:PExecuteQuestTarget = new PExecuteQuestTarget();
         _loc2_.eqt_quest_name = param1.readUTF();
         _loc2_.eqt_target_num = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.eqt_quest_name);
         param1.writeByte(this.eqt_target_num);
      }
   }
}

