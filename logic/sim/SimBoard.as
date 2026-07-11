package logic.sim
{
   import engine.data.MapCell;
   import flash.geom.Point;
   import logic.sim.SimAstar.SimAstar;
   
   public class SimBoard
   {
      
      public static const LEFT:int = 1;
      
      public static const LEFT_UP:int = 2;
      
      public static const UP:int = 3;
      
      public static const RIGHT_UP:int = 4;
      
      public static const RIGHT:int = 5;
      
      public static const RIGHT_DOWN:int = 6;
      
      public static const DOWN:int = 7;
      
      public static const LEFT_DOWN:int = 8;
      
      public static const directionList:Vector.<SimDirection> = new <SimDirection>[new SimDirection(-1,0,LEFT),new SimDirection(-1,1,LEFT_UP),new SimDirection(0,1,UP),new SimDirection(1,1,RIGHT_UP),new SimDirection(1,0,RIGHT),new SimDirection(1,-1,RIGHT_DOWN),new SimDirection(0,-1,DOWN),new SimDirection(-1,-1,LEFT_DOWN)];
      
      private static const sqrt2:Number = Math.sqrt(2);
      
      public const data:Vector.<Vector.<SimBoardElt>>;
      
      public var w:int;
      
      public var h:int;
      
      private const _default_passability:int = 4;
      
      private var elt:SimBoardElt;
      
      private var astar:SimAstar;
      
      public function SimBoard(param1:int, param2:int)
      {
         var _loc4_:Vector.<SimBoardElt> = null;
         var _loc5_:int = 0;
         this.data = new Vector.<Vector.<SimBoardElt>>();
         this.astar = new SimAstar();
         super();
         this.w = param1;
         this.h = param2;
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc4_ = new Vector.<SimBoardElt>();
            _loc5_ = 0;
            while(_loc5_ < param2)
            {
               _loc4_.push(new SimBoardElt());
               _loc5_++;
            }
            this.data.push(_loc4_);
            _loc3_++;
         }
      }
      
      public static function findCenter(param1:Point, param2:Point) : Point
      {
         var _loc3_:int = int((param2.x - 1) / 2);
         var _loc4_:int = int((param2.y - 1) / 2);
         return new Point(param1.x - _loc3_,param1.y - _loc4_);
      }
      
      public static function findCenter_(param1:Point, param2:Point, param3:Point) : Point
      {
         var _loc4_:Point = SimBoard.findCenter(param1,param2);
         if(param2.x % 2 == 0 && param3.x < _loc4_.x)
         {
            --_loc4_.x;
         }
         if(param2.y % 2 == 0 && param3.y < _loc4_.y)
         {
            --_loc4_.y;
         }
         return _loc4_;
      }
      
      public static function distance2(param1:Point, param2:Point) : int
      {
         return (param1.x - param2.x) * (param1.x - param2.x) + (param1.y - param2.y) * (param1.y - param2.y);
      }
      
      public static function distancef(param1:Point, param2:Point) : Number
      {
         return Math.sqrt((param1.x - param2.x) * (param1.x - param2.x) + (param1.y - param2.y) * (param1.y - param2.y));
      }
      
      public static function radius(param1:int) : int
      {
         return param1 * param1 + ((param1 + 1) * (param1 + 1) - param1 * param1) / 2;
      }
      
      public static function perimeter(param1:Point, param2:Point) : Vector.<Point>
      {
         var _loc3_:Vector.<Point> = new Vector.<Point>(0);
         var _loc4_:int = param2.x;
         var _loc5_:int = param2.y;
         var _loc6_:Point = param1.clone();
         var _loc7_:int = 1;
         var _loc8_:int = DOWN;
         while(true)
         {
            if(_loc8_ == DOWN && _loc7_ < _loc5_)
            {
               --_loc6_.y;
               _loc7_ += 1;
               _loc3_.push(_loc6_.clone());
            }
            else if(_loc8_ == DOWN)
            {
               _loc7_ = 1;
               _loc8_ = LEFT;
            }
            else if(_loc8_ == LEFT && _loc7_ < _loc4_)
            {
               --_loc6_.x;
               _loc7_ += 1;
               _loc3_.push(_loc6_.clone());
            }
            else if(_loc8_ == LEFT)
            {
               _loc7_ = 1;
               _loc8_ = UP;
            }
            else if(_loc8_ == UP && _loc7_ < _loc5_ && _loc4_ != 1)
            {
               _loc6_.y += 1;
               _loc7_ += 1;
               _loc3_.push(_loc6_.clone());
            }
            else if(_loc8_ == UP)
            {
               _loc7_ = 1;
               _loc8_ = RIGHT;
            }
            else if(_loc8_ == RIGHT && _loc7_ < _loc4_ && _loc5_ != 1)
            {
               _loc6_.x += 1;
               _loc7_ += 1;
               _loc3_.push(_loc6_.clone());
            }
            else
            {
               if(!(_loc5_ == 1 || _loc4_ == 1))
               {
                  break;
               }
               _loc3_.push(_loc6_.clone());
            }
         }
         return _loc3_;
      }
      
      public function rhombInBoard(param1:int, param2:int) : Boolean
      {
         return param1 >= 0 && param2 >= 0 && param1 < this.w && param2 < this.h;
      }
      
      public function rhombsInCircle(param1:Point, param2:int, param3:Point) : Vector.<Point>
      {
         var radius2:int = 0;
         var y:int = 0;
         var p:Point = param1;
         var r:int = param2;
         var size:Point = param3;
         var checkDisatance:Function = function(param1:int, param2:int):Boolean
         {
            var _loc3_:int = p.x;
            if(size.x % 2 == 0 && param1 < p.x)
            {
               _loc3_--;
            }
            var _loc4_:int = p.y;
            if(size.y % 2 == 0 && param2 < p.y)
            {
               _loc4_--;
            }
            return (param1 - _loc3_) * (param1 - _loc3_) + (param2 - _loc4_) * (param2 - _loc4_) <= radius2;
         };
         var res:Vector.<Point> = new Vector.<Point>();
         radius2 = radius(r);
         var x:int = p.x + r;
         while(x >= p.x - r - 1)
         {
            y = p.y + r;
            while(y >= p.y - r - 1)
            {
               if(this.rhombInBoard(x,y) && Boolean(checkDisatance(x,y)))
               {
                  res.push(new Point(x,y));
               }
               y--;
            }
            x--;
         }
         return res;
      }
      
      public function rhombs(param1:Point, param2:Point) : Vector.<Point>
      {
         var _loc5_:* = 0;
         var _loc3_:Vector.<Point> = new Vector.<Point>();
         var _loc4_:* = int(param1.x);
         while(_loc4_ > param1.x - param2.x)
         {
            _loc5_ = int(param1.y);
            while(_loc5_ > param1.y - param2.y)
            {
               _loc3_.push(new Point(_loc4_,_loc5_));
               _loc5_--;
            }
            _loc4_--;
         }
         return _loc3_;
      }
      
      public function removeUnit(param1:int, param2:Point) : void
      {
         this.elt = this.data[param2.x][param2.y];
         var _loc3_:int = this.elt.units.indexOf(param1);
         if(_loc3_ >= 0)
         {
            this.elt.units.splice(_loc3_,1);
         }
      }
      
      public function addUnit(param1:int, param2:Point) : void
      {
         this.elt = this.data[param2.x][param2.y];
         if(this.elt.units.indexOf(param1) < 0)
         {
            this.elt.units.push(param1);
         }
      }
      
      public function removeReg(param1:int, param2:Point) : void
      {
         this.elt = this.data[param2.x][param2.y];
         var _loc3_:int = this.elt.regs.indexOf(param1);
         if(_loc3_ >= 0)
         {
            this.elt.regs.splice(_loc3_,1);
         }
      }
      
      public function addReg(param1:int, param2:Point) : void
      {
         this.elt = this.data[param2.x][param2.y];
         if(this.elt.regs.indexOf(param1) < 0)
         {
            this.elt.regs.push(param1);
         }
      }
      
      private function passabilityByObj(param1:Point, param2:Point, param3:SimBoardObj, param4:Point) : Number
      {
         var _loc6_:Number = NaN;
         var _loc5_:Boolean = param1.x - param4.x + 1 == param2.x || param1.y - param4.y + 1 == param2.y || param1.x == param2.x || param1.y == param2.y;
         if(param3.kind == SimBoardObj.FENCE)
         {
            _loc6_ = 128;
         }
         else if(_loc5_)
         {
            _loc6_ = 12;
         }
         return _loc6_;
      }
      
      public function addObject(param1:SimBoardObj, param2:Point, param3:Point) : void
      {
         var _loc4_:Vector.<Point> = null;
         var _loc5_:* = 0;
         var _loc6_:Point = null;
         var _loc7_:SimBoardElt = null;
         if(param1.kind == SimBoardObj.UNIT)
         {
            this.addUnit(param1.id,param2);
         }
         else
         {
            _loc4_ = this.rhombs(param2,param3);
            _loc5_ = int(_loc4_.length - 1);
            while(_loc5_ >= 0)
            {
               _loc6_ = _loc4_[_loc5_];
               if(this.rhombInBoard(_loc6_.x,_loc6_.y))
               {
                  _loc7_ = this.data[_loc6_.x][_loc6_.y];
                  _loc7_.passability = this.passabilityByObj(param2,_loc6_,param1,param3);
                  _loc7_.obj = param1;
               }
               _loc5_--;
            }
         }
         if(param1.kind != SimBoardObj.GARBAGE && param1.kind != SimBoardObj.UNIT)
         {
            this.addLanding(param2.x,param2.y,param3.x,param3.y,param1.id);
         }
      }
      
      public function addLanding(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:Point = null;
         for each(_loc6_ in perimeter(new Point(param1 + 1,param2 + 1),new Point(param3 + 2,param4 + 2)))
         {
            if(this.rhombInBoard(_loc6_.x,_loc6_.y))
            {
               this.getElt(_loc6_.x,_loc6_.y).landing.push(param5);
            }
         }
      }
      
      public function removeObject(param1:SimBoardObj, param2:Point, param3:Point) : void
      {
         var _loc4_:Vector.<Point> = null;
         var _loc5_:Point = null;
         if(param1.kind == SimBoardObj.UNIT)
         {
            this.removeUnit(param1.id,param2);
         }
         else
         {
            _loc4_ = this.rhombs(param2,param3);
            for each(_loc5_ in _loc4_)
            {
               if(this.rhombInBoard(_loc5_.x,_loc5_.y))
               {
                  this.elt = this.getElt(_loc5_.x,_loc5_.y);
                  this.elt.passability = this._default_passability;
                  this.elt.obj = null;
               }
            }
         }
      }
      
      public function unregisterCannon(param1:int, param2:Point, param3:Point, param4:int) : void
      {
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc5_:Vector.<Point> = this.rhombsInCircle(param2,param4,param3);
         var _loc6_:* = int(_loc5_.length - 1);
         while(_loc6_ >= 0)
         {
            _loc7_ = _loc5_[_loc6_];
            this.elt = this.data[_loc7_.x][_loc7_.y];
            _loc8_ = this.elt.cannons.indexOf(param1);
            if(_loc8_ >= 0)
            {
               this.elt.cannons.splice(_loc8_,1);
            }
            _loc6_--;
         }
      }
      
      public function registerCannon(param1:int, param2:Point, param3:Point, param4:int) : void
      {
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc5_:Vector.<Point> = this.rhombsInCircle(param2,param4,param3);
         var _loc6_:* = int(_loc5_.length - 1);
         while(_loc6_ >= 0)
         {
            _loc7_ = _loc5_[_loc6_];
            this.elt = this.data[_loc7_.x][_loc7_.y];
            _loc8_ = this.elt.cannons.indexOf(param1);
            if(_loc8_ < 0)
            {
               this.elt.cannons.push(param1);
            }
            _loc6_--;
         }
      }
      
      public function unregisterGuard(param1:int, param2:Point, param3:Point, param4:int) : void
      {
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc5_:Vector.<Point> = this.rhombsInCircle(param2,param4,param3);
         var _loc6_:* = int(_loc5_.length - 1);
         while(_loc6_ >= 0)
         {
            _loc7_ = _loc5_[_loc6_];
            this.elt = this.data[_loc7_.x][_loc7_.y];
            _loc8_ = this.elt.guards.indexOf(param1);
            if(_loc8_ >= 0)
            {
               this.elt.guards.splice(_loc8_,1);
            }
            _loc6_--;
         }
      }
      
      public function registerGuard(param1:int, param2:Point, param3:Point, param4:int) : void
      {
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc5_:Vector.<Point> = this.rhombsInCircle(param2,param4,param3);
         var _loc6_:* = int(_loc5_.length - 1);
         while(_loc6_ >= 0)
         {
            _loc7_ = _loc5_[_loc6_];
            this.elt = this.data[_loc7_.x][_loc7_.y];
            _loc8_ = this.elt.guards.indexOf(param1);
            if(_loc8_ < 0)
            {
               this.elt.guards.push(param1);
            }
            _loc6_--;
         }
      }
      
      public function neigbours(param1:Point) : Vector.<int>
      {
         var _loc3_:SimDirection = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Vector.<int> = new Vector.<int>(0);
         var _loc4_:* = int(directionList.length - 1);
         while(_loc4_ >= 0)
         {
            _loc3_ = directionList[_loc4_];
            _loc5_ = int(param1.x) + _loc3_.x;
            if(_loc5_ >= 0)
            {
               _loc6_ = int(param1.y) + _loc3_.y;
               if(_loc6_ >= 0)
               {
                  _loc2_.push(_loc3_.direction << 12 | _loc5_ << 6 | _loc6_);
               }
            }
            _loc4_--;
         }
         return _loc2_;
      }
      
      public function speedByDirection(param1:Point, param2:Point) : Number
      {
         var _loc3_:int = param2.x - param1.x;
         var _loc4_:int = param2.y - param1.y;
         return _loc3_ != 0 && _loc4_ != 0 ? sqrt2 : 1;
      }
      
      private function denyInObject(param1:Point, param2:int, param3:int, param4:int) : Boolean
      {
         if(param4 == UP || param4 == LEFT || param4 == DOWN || param4 == RIGHT)
         {
            return false;
         }
         return Boolean(this.data[param1.x][param1.y].obj) && this.data[param1.x][param1.y].obj.equal(this.data[param2][param3].obj);
      }
      
      private function costByDirection(param1:int) : int
      {
         if(param1 == UP || param1 == RIGHT || param1 == DOWN || param1 == LEFT)
         {
            return 1000;
         }
         return 1414;
      }
      
      public function cannonsGuardsOnPos(param1:Point) : Vector.<SimBoardObj>
      {
         var i:int = 0;
         var obj:SimBoardObj = null;
         var p:Point = param1;
         var res:Vector.<SimBoardObj> = new Vector.<SimBoardObj>();
         var elt:SimBoardElt = this.data[p.x][p.y];
         if(Boolean(elt.cannons) && elt.cannons.length > 0)
         {
            i = elt.cannons.length - 1;
            while(i >= 0)
            {
               obj = new SimBoardObj(SimBoardObj.CANNON,elt.cannons[i]);
               res.push(obj);
               i--;
            }
         }
         if(Boolean(elt.guards) && elt.guards.length > 0)
         {
            i = elt.guards.length - 1;
            while(i >= 0)
            {
               obj = new SimBoardObj(SimBoardObj.BUILDING,elt.guards[i]);
               res.push(obj);
               i--;
            }
         }
         return res.sort(function(param1:SimBoardObj, param2:SimBoardObj):Number
         {
            return param1.id - param2.id;
         });
      }
      
      public function findNeigbourPoint(param1:Point, param2:Point, param3:Point) : Point
      {
         var _loc4_:Point = new Point(0,0);
         var _loc5_:int = param2.x - 1;
         var _loc6_:int = param2.y - 1;
         if(param3.x <= param1.x && param3.x >= param1.x - _loc5_ && param3.y <= param1.y && param3.y >= param1.y - _loc6_)
         {
            _loc4_ = param3;
         }
         else if(param3.x > param1.x)
         {
            if(param3.y > param1.y)
            {
               _loc4_ = param1;
            }
            else if(param3.y < param1.y - _loc6_)
            {
               _loc4_.x = param1.x;
               _loc4_.y = param1.y - _loc6_;
            }
            else
            {
               _loc4_.x = param1.x;
               _loc4_.y = param3.y;
            }
         }
         else if(param3.x < param1.x - _loc5_)
         {
            if(param3.y > param1.y)
            {
               _loc4_.x = param1.x - _loc5_;
               _loc4_.y = param1.y;
            }
            else if(param3.y < param1.y - _loc6_)
            {
               _loc4_.x = param1.x - _loc5_;
               _loc4_.y = param1.y - _loc6_;
            }
            else
            {
               _loc4_.x = param1.x - _loc5_;
               _loc4_.y = param3.y;
            }
         }
         else if(param3.y > param1.y)
         {
            _loc4_.x = param3.x;
            _loc4_.y = param1.y;
         }
         else
         {
            _loc4_.x = param3.x;
            _loc4_.y = param1.y - _loc6_;
         }
         return _loc4_;
      }
      
      private function astarDistance(param1:Point, param2:Point) : int
      {
         var _loc3_:int = Math.abs(param1.x - param2.x);
         var _loc4_:int = Math.abs(param1.y - param2.y);
         var _loc5_:int = _loc3_ < _loc4_ ? _loc3_ : _loc4_;
         return 1414 * _loc5_ + (_loc3_ + _loc4_ - 2 * _loc5_) * 1000;
      }
      
      private function rhombPassability(param1:int, param2:int, param3:int, param4:Boolean, param5:Vector.<int>, param6:SimBoardObj, param7:int) : Number
      {
         var _loc8_:SimBoardElt = this.getElt(param1,param2);
         var _loc9_:Number = _loc8_.passability;
         if(!isNaN(_loc8_.passability))
         {
            if(Boolean(_loc8_.obj) && Boolean(_loc8_.obj.equal(param6)) || param6.kind == SimBoardObj.UNIT && _loc8_.units.indexOf(param6.id) >= 0)
            {
               _loc9_ = 0;
            }
            else
            {
               if(Boolean(_loc8_.obj) && Boolean(_loc8_.obj.kind == SimBoardObj.FENCE) && param4)
               {
                  _loc9_ = this._default_passability;
                  if(param5.indexOf(SimFun.Point2Int(param1,param2)) >= 0)
                  {
                     _loc9_ /= 4;
                  }
               }
               else if(!_loc8_.obj && param5.indexOf(SimFun.Point2Int(param1,param2)) >= 0)
               {
                  _loc9_ /= 4;
               }
               _loc9_ = this.costByDirection(param3) * _loc9_;
            }
         }
         if(!isNaN(_loc9_))
         {
            _loc9_ += _loc8_.regs.length * 2000;
         }
         return _loc9_;
      }
      
      public function findPath(param1:Point, param2:SimBoardObj, param3:Point, param4:Point, param5:int, param6:Boolean, param7:Vector.<int>, param8:int) : Vector.<Point>
      {
         var res:Vector.<Point> = null;
         var r2:int = 0;
         var successor:Function = null;
         var astarDistanceToNeigbour:Function = null;
         var from_p:Point = param1;
         var target_id:SimBoardObj = param2;
         var target_pos:Point = param3;
         var target_size:Point = param4;
         var r:int = param5;
         var is_air:Boolean = param6;
         var vector_rhombs:Vector.<int> = param7;
         var etime:int = param8;
         successor = function(param1:Point):Vector.<int>
         {
            var _loc5_:int = 0;
            var _loc6_:int = 0;
            var _loc7_:int = 0;
            var _loc8_:int = 0;
            var _loc9_:Number = NaN;
            var _loc2_:Vector.<int> = new Vector.<int>();
            var _loc3_:Vector.<int> = neigbours(param1);
            var _loc4_:* = int(_loc3_.length - 1);
            while(_loc4_ >= 0)
            {
               _loc5_ = _loc3_[_loc4_];
               _loc6_ = _loc5_ >> 6 & 0x3F;
               _loc7_ = _loc5_ & 0x3F;
               _loc8_ = _loc5_ >> 12;
               if(rhombInBoard(_loc6_,_loc7_) && !denyInObject(param1,_loc6_,_loc7_,_loc8_))
               {
                  _loc9_ = rhombPassability(_loc6_,_loc7_,_loc8_,is_air,vector_rhombs,target_id,etime);
                  if(!isNaN(_loc9_))
                  {
                     _loc2_.push(SimAstar.packState(_loc6_,_loc7_,_loc9_));
                  }
               }
               _loc4_--;
            }
            return _loc2_;
         };
         astarDistanceToNeigbour = function(param1:Point):int
         {
            var _loc2_:int = 0;
            var _loc4_:Point = null;
            var _loc5_:int = 0;
            var _loc3_:SimBoardElt = data[param1.x][param1.y];
            if(Boolean(_loc3_.obj) && _loc3_.obj.equal(target_id))
            {
               _loc2_ = 0;
            }
            else
            {
               _loc4_ = findNeigbourPoint(target_pos,target_size,param1);
               _loc5_ = distance2(_loc4_,param1);
               _loc2_ = _loc5_ <= r2 ? 0 : astarDistance(param1,_loc4_);
            }
            return _loc2_ * 16;
         };
         r2 = radius(r);
         if(this.data[from_p.x][from_p.y].obj == target_id)
         {
            res = new Vector.<Point>();
         }
         else
         {
            res = this.astar.find(from_p,successor,astarDistanceToNeigbour,etime);
         }
         return res;
      }
      
      public function getElt(param1:int, param2:int) : SimBoardElt
      {
         if(this.rhombInBoard(param1,param2))
         {
            return this.data[param1][param2];
         }
         return null;
      }
      
      public function vertical(param1:Vector.<MapCell>) : Vector.<Point>
      {
         var _loc3_:MapCell = null;
         var _loc4_:SimBoardElt = null;
         var _loc2_:Vector.<Point> = new Vector.<Point>();
         for each(_loc3_ in param1)
         {
            _loc4_ = this.getElt(_loc3_.x,_loc3_.y);
            if(_loc4_.landing.length == 0 && !_loc4_.obj)
            {
               _loc2_.push(new Point(_loc3_.x,_loc3_.y));
            }
         }
         return _loc2_;
      }
   }
}

