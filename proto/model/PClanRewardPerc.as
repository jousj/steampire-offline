package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanRewardPerc implements IClientPacket
   {
      
      public var place:int;
      
      public var perc:Number;
      
      public function PClanRewardPerc()
      {
         super();
      }
      
      public static function create(param1:int, param2:Number) : PClanRewardPerc
      {
         var _loc3_:PClanRewardPerc = new PClanRewardPerc();
         _loc3_.place = param1;
         _loc3_.perc = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PClanRewardPerc
      {
         var _loc2_:PClanRewardPerc = new PClanRewardPerc();
         _loc2_.place = param1.readInt();
         _loc2_.perc = param1.readDouble();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.place);
         param1.writeDouble(this.perc);
      }
   }
}

