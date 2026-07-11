package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PCostt implements IClientPacket
   {
      
      public static const RUBY:uint = 16;
      
      public static const CLAN_POINTS:uint = 15;
      
      public static const RAR_DRAGON:uint = 14;
      
      public static const J_GLORY:uint = 13;
      
      public static const BLUE_PRINT:uint = 12;
      
      public static const TROPHY:uint = 11;
      
      public static const UNKNOWN:uint = 10;
      
      public static const MITHRIL:uint = 9;
      
      public static const GREEN_ORE:uint = 8;
      
      public static const BLUE_ORE:uint = 7;
      
      public static const RED_ORE:uint = 6;
      
      public static const CALL:uint = 5;
      
      public static const H_GLORY:uint = 4;
      
      public static const EXP:uint = 3;
      
      public static const OIL:uint = 2;
      
      public static const CRYSTAL:uint = 1;
      
      public static const GOLD:uint = 0;
      
      public var variance:uint;
      
      public function PCostt()
      {
         super();
      }
      
      public static function create(param1:uint) : PCostt
      {
         var _loc2_:PCostt = new PCostt();
         _loc2_.variance = param1;
         return _loc2_;
      }
      
      public static function read(param1:IDataInput) : PCostt
      {
         var _loc2_:PCostt = new PCostt();
         _loc2_.variance = param1.readUnsignedByte();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.variance);
      }
   }
}

