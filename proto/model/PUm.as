package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PUm implements IClientPacket
   {
      
      public var init_time:Number;
      
      public var object_id:uint;
      
      public var buildings:Array;
      
      public var cannons:Array;
      
      public var fences:Array;
      
      public var decors:Array;
      
      public var garbages:Array;
      
      public function PUm()
      {
         super();
      }
      
      public static function create(param1:Number, param2:uint, param3:Array, param4:Array, param5:Array, param6:Array, param7:Array) : PUm
      {
         var _loc8_:PUm = new PUm();
         _loc8_.init_time = param1;
         _loc8_.object_id = param2;
         _loc8_.buildings = param3;
         _loc8_.cannons = param4;
         _loc8_.fences = param5;
         _loc8_.decors = param6;
         _loc8_.garbages = param7;
         return _loc8_;
      }
      
      public static function read(param1:IDataInput) : PUm
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PUm = new PUm();
         _loc2_.init_time = param1.readDouble();
         _loc2_.object_id = param1.readUnsignedInt();
         _loc2_.buildings = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.buildings.length)
         {
            _loc2_.buildings[_loc3_] = _loc4_ = PBuilding.read(param1);
            _loc3_++;
         }
         _loc2_.cannons = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.cannons.length)
         {
            _loc2_.cannons[_loc3_] = _loc4_ = PCannon.read(param1);
            _loc3_++;
         }
         _loc2_.fences = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.fences.length)
         {
            _loc2_.fences[_loc3_] = _loc4_ = PFence.read(param1);
            _loc3_++;
         }
         _loc2_.decors = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.decors.length)
         {
            _loc2_.decors[_loc3_] = _loc4_ = PDecor.read(param1);
            _loc3_++;
         }
         _loc2_.garbages = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.garbages.length)
         {
            _loc2_.garbages[_loc3_] = _loc4_ = PGarbage.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeDouble(this.init_time);
         param1.writeInt(this.object_id);
         if(this.buildings == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.buildings.length);
            _loc2_ = 0;
            while(_loc2_ < this.buildings.length)
            {
               this.buildings[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.cannons == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.cannons.length);
            _loc2_ = 0;
            while(_loc2_ < this.cannons.length)
            {
               this.cannons[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.fences == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.fences.length);
            _loc2_ = 0;
            while(_loc2_ < this.fences.length)
            {
               this.fences[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.decors == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.decors.length);
            _loc2_ = 0;
            while(_loc2_ < this.decors.length)
            {
               this.decors[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.garbages == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.garbages.length);
            _loc2_ = 0;
            while(_loc2_ < this.garbages.length)
            {
               this.garbages[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

