package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PClanCenter implements IClientPacket
   {
      
      public var lat:Number;
      
      public var resources:Array;
      
      public function PClanCenter()
      {
         super();
      }
      
      public static function create(param1:Number, param2:Array) : PClanCenter
      {
         var _loc3_:PClanCenter = new PClanCenter();
         _loc3_.lat = param1;
         _loc3_.resources = param2;
         return _loc3_;
      }
      
      public static function read(param1:IDataInput) : PClanCenter
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PClanCenter = new PClanCenter();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.lat = param1.readDouble();
         }
         else
         {
            _loc2_.lat = NaN;
         }
         _loc2_.resources = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.resources.length)
         {
            _loc2_.resources[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         if(!isNaN(this.lat))
         {
            param1.writeByte(1);
            param1.writeDouble(this.lat);
         }
         else
         {
            param1.writeByte(0);
         }
         if(this.resources == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.resources.length);
            _loc2_ = 0;
            while(_loc2_ < this.resources.length)
            {
               this.resources[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

