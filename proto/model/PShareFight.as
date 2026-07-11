package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShareFight implements IClientPacket
   {
      
      public var win_sign:PSign;
      
      public var lose_sign:PSign;
      
      public function PShareFight()
      {
         super();
      }
      
      public static function create(param1:PSign, param2:PSign) : PShareFight
      {
         var _loc3_:PShareFight = new PShareFight();
         _loc3_.win_sign = param1;
         _loc3_.lose_sign = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PShareFight
      {
         var _loc2_:PShareFight = new PShareFight();
         _loc2_.win_sign = PSign.read(param1);
         _loc2_.lose_sign = PSign.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         this.win_sign.write(param1);
         this.lose_sign.write(param1);
      }
   }
}

