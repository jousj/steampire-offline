package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PPoesd implements IClientPacket
   {
      
      public var sid:String;
      
      public var objects:Array;
      
      public var from_time:PCeventFrom;
      
      public function PPoesd()
      {
         super();
      }
      
      public static function create(param1:String, param2:Array, param3:PCeventFrom) : PPoesd
      {
         var _loc4_:PPoesd = new PPoesd();
         _loc4_.sid = param1;
         _loc4_.objects = param2;
         _loc4_.from_time = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PPoesd
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PPoesd = new PPoesd();
         _loc2_.sid = param1.readUTF();
         _loc2_.objects = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.objects.length)
         {
            _loc2_.objects[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.from_time = PCeventFrom.read(param1);
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.sid);
         if(this.objects == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.objects.length);
            _loc2_ = 0;
            while(_loc2_ < this.objects.length)
            {
               param1.writeUTF(this.objects[_loc2_]);
               _loc2_++;
            }
         }
         this.from_time.write(param1);
      }
   }
}

