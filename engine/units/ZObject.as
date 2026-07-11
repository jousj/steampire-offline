package engine.units
{
   import engine.Board;
   import engine.Isometric;
   
   public class ZObject extends AnimObject
   {
      
      public static var POS_WORLD_SIZE:Number;
      
      public static var POS_WORLD_ONE_THIRD:Number;
      
      public static var POS_WORLD_TWO_THIRD:Number;
      
      public static var POS_WORLD_ONE_SIXTH:Number;
      
      public static var DIAG_K:Number;
      
      public static var POS_WORLD_DIAG:Number;
      
      protected static var board:Board;
      
      private static const walkType1List:Vector.<uint> = new <uint>[432,54,438,216,27,219,504,63,511];
      
      private static const walkType2List:Vector.<uint> = new <uint>[256,4,292,64,1,73,448,7,511];
      
      public var c_x:int;
      
      public var c_y:int;
      
      public var t_y:int;
      
      public var b_x:int;
      
      public var b_y:int;
      
      public var t_x:int;
      
      public var z_x:Number = 0;
      
      public var z_y:Number = 0;
      
      public var z_m:Number = 0;
      
      private var zMargin:Number = 1;
      
      public function ZObject()
      {
         super();
      }
      
      public static function init(param1:Board) : void
      {
         ZObject.board = param1;
         POS_WORLD_SIZE = Isometric.POS_WORLD_SIZE;
         POS_WORLD_ONE_THIRD = Isometric.POS_WORLD_SIZE / 3;
         POS_WORLD_TWO_THIRD = POS_WORLD_SIZE * 2 / 3;
         POS_WORLD_ONE_SIXTH = POS_WORLD_SIZE / 6;
         POS_WORLD_DIAG = Isometric.POS_WORLD_DIAG;
         DIAG_K = POS_WORLD_DIAG / POS_WORLD_SIZE;
      }
      
      public function setZMargin(param1:uint) : void
      {
         if(param1 == 0 || param1 > 3)
         {
            throw new Error("bad value zMargin=" + param1);
         }
         this.zMargin = param1;
      }
      
      public function setGeometry(param1:int, param2:int, param3:Boolean) : void
      {
         if(size > 1)
         {
            this.b_x = param1;
            this.b_y = param2;
            this.t_x = param1 - (size - 1);
            this.t_y = param2 - (size - 1);
            if((size & 1) != 0)
            {
               this.c_x = param1 - (size - 1 >> 1);
               this.c_y = param2 - (size - 1 >> 1);
            }
            else
            {
               this.c_x = param1 - ((size >> 1) - 1);
               this.c_y = param2 - ((size >> 1) - 1);
            }
         }
         else
         {
            this.t_x = this.b_x = this.c_x = param1;
            this.t_y = this.b_y = this.c_y = param2;
         }
         if(param3)
         {
            this.syncPosition();
         }
      }
      
      public function syncPosition() : void
      {
         this.updateZSize();
         board.isNeedZSort = true;
         Isometric.applyScreenPoint(this);
         testViewRect();
      }
      
      public function updateZSize() : void
      {
         this.z_y = size / 2;
         this.z_x = POS_WORLD_SIZE * (this.t_x + this.z_y);
         this.z_y = POS_WORLD_SIZE * (this.t_y + this.z_y);
         this.z_m = this.z_x + this.z_y;
      }
      
      public function move(param1:int, param2:int) : void
      {
         this.setGeometry(param1,param2,false);
         Isometric.applyScreenPoint(this);
      }
      
      public function calcDirection(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.z_x == param1)
         {
            if(param2 > this.z_y)
            {
               _loc3_ = 180;
            }
            else
            {
               _loc3_ = 0;
            }
         }
         else
         {
            _loc4_ = -(this.z_y - param2) / (param1 - this.z_x);
            _loc3_ = Math.atan(_loc4_) * 180 / Math.PI;
            if(param1 > this.z_x)
            {
               _loc3_ += 90;
            }
            else
            {
               _loc3_ += 270;
            }
         }
         if(_loc3_ < 22.5)
         {
            direction = RIGHT_UP;
         }
         else if(_loc3_ < 67.5)
         {
            direction = H_RIGHT;
         }
         else if(_loc3_ < 112.5)
         {
            direction = RIGHT_DOWN;
         }
         else if(_loc3_ < 157.5)
         {
            direction = V_DOWN;
         }
         else if(_loc3_ < 202.5)
         {
            direction = LEFT_DOWN;
         }
         else if(_loc3_ < 247.5)
         {
            direction = H_LEFT;
         }
         else if(_loc3_ < 292.5)
         {
            direction = LEFT_UP;
         }
         else if(_loc3_ < 337.5)
         {
            direction = V_UP;
         }
         else
         {
            direction = RIGHT_UP;
         }
      }
      
      public function getWalkType(param1:uint, param2:uint) : uint
      {
         var _loc3_:uint = 0;
         if(this.zMargin > 2)
         {
            return param1 > 1 && param1 < size && param2 > 1 && param2 < size ? 511 : 0;
         }
         if(param1 == 1)
         {
            if(param2 == 1)
            {
               _loc3_ = 0;
            }
            else if(param2 == size)
            {
               _loc3_ = 1;
            }
            else
            {
               _loc3_ = 2;
            }
         }
         else if(param1 == size)
         {
            if(param2 == 1)
            {
               _loc3_ = 3;
            }
            else if(param2 == size)
            {
               _loc3_ = 4;
            }
            else
            {
               _loc3_ = 5;
            }
         }
         else if(param2 == 1)
         {
            _loc3_ = 6;
         }
         else if(param2 == size)
         {
            _loc3_ = 7;
         }
         else
         {
            _loc3_ = 8;
         }
         return this.zMargin == 2 ? walkType2List[_loc3_] : walkType1List[_loc3_];
      }
      
      public function onToBoard(param1:Boolean) : void
      {
      }
   }
}

