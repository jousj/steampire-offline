package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PQuest implements IClientPacket
   {
      
      public var qname:String;
      
      public var qtargets:Array;
      
      public function PQuest()
      {
         super();
      }
      
      public static function create(param1:String, param2:Array) : PQuest
      {
         var _loc3_:PQuest = new PQuest();
         _loc3_.qname = param1;
         _loc3_.qtargets = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PQuest
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PQuest = new PQuest();
         _loc2_.qname = param1.readUTF();
         _loc2_.qtargets = new Array(param1.readUnsignedByte());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.qtargets.length)
         {
            _loc2_.qtargets[_loc3_] = _loc4_ = PQuestTarget.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.qname);
         if(this.qtargets == null)
         {
            param1.writeByte(0);
         }
         else
         {
            param1.writeByte(this.qtargets.length);
            _loc2_ = 0;
            while(_loc2_ < this.qtargets.length)
            {
               this.qtargets[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

