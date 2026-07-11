package proto
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class BinaryBuffer extends ByteArray
   {
      
      public var family:uint;
      
      public var subfamily:uint;
      
      public function BinaryBuffer(param1:uint = 0, param2:uint = 0)
      {
         super();
         this.family = param1;
         this.subfamily = param2;
         endian = Endian.LITTLE_ENDIAN;
      }
      
      public function clone() : BinaryBuffer
      {
         var _loc1_:BinaryBuffer = new BinaryBuffer(this.family,this.subfamily);
         _loc1_.writeBytes(this);
         _loc1_.position = 0;
         return _loc1_;
      }
   }
}

