package engine
{
   import flash.geom.Point;
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   
   public class Position
   {
      
      public var x:int;
      
      public var y:int;
      
      public function Position(param1:int = 0, param2:int = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
      }
      
      public static function create(param1:int, param2:int) : Position
      {
         return new Position(param1,param2);
      }
      
      public static function read(param1:IDataInput) : Position
      {
         return new Position(param1.readShort(),param1.readShort());
      }
      
      public function clone() : Position
      {
         return new Position(this.x,this.y);
      }
      
      public function equal(param1:int, param2:int) : Boolean
      {
         return this.x == param1 && this.y == param2;
      }
      
      public function equal_p(param1:Position) : Boolean
      {
         return this.x == param1.x && this.y == param1.y;
      }
      
      public function setTo(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function setFromPoint(param1:Point) : void
      {
         this.x = param1.x;
         this.y = param1.y;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeShort(this.x);
         param1.writeShort(this.y);
      }
      
      public function toString() : String
      {
         return "(" + this.x + "," + this.y + ")";
      }
   }
}

