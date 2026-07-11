package model.calc
{
   import engine.Position;
   import flash.geom.Point;
   
   public class VectorCalc
   {
      
      private const mC:Position = new Position();
      
      private const mD:Position = new Position();
      
      private const map_sx:int = Facade.map_sx;
      
      private const map_sy:int = Facade.map_sy;
      
      public function VectorCalc()
      {
         super();
      }
      
      private function getLine(param1:Position, param2:Position, param3:Vector.<Point>) : void
      {
         var _loc6_:Position = null;
         var _loc7_:int = 0;
         if(param1.x == param2.x && param1.y == param2.y)
         {
            return;
         }
         this.addOutList(param2.x,param2.y,param3);
         if(param1.x > param2.x || param1.x == param2.x && param1.y > param2.y)
         {
            _loc6_ = param2;
            param2 = param1;
            param1 = _loc6_;
         }
         var _loc4_:int = param1.x;
         var _loc5_:int = param1.y;
         if(_loc4_ == param2.x)
         {
            _loc7_ = param1.y > param2.y ? -1 : 1;
            while(_loc5_ != param2.y)
            {
               this.addOutList(_loc4_,_loc5_,param3);
               _loc5_ += _loc7_;
            }
         }
         else if(_loc5_ == param2.y)
         {
            while(_loc4_ != param2.x)
            {
               this.addOutList(_loc4_,_loc5_,param3);
               _loc4_++;
            }
         }
         else
         {
            this.lineDiag(param1,param2,param3);
         }
      }
      
      private function lineDiag(param1:Position, param2:Position, param3:Vector.<Point>) : void
      {
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc4_:int = param1.x;
         var _loc5_:* = param1.y;
         var _loc6_:int = 40;
         var _loc7_:int = 20;
         var _loc8_:int = (param2.x - param1.x) * _loc6_;
         var _loc9_:int = (param2.y - param1.y) * _loc6_;
         if(param2.y < param1.y)
         {
            _loc9_ *= -1;
            _loc10_ = true;
            if(_loc8_ > _loc9_)
            {
               _loc4_++;
            }
            else if(_loc8_ < _loc9_)
            {
               _loc5_--;
            }
            else
            {
               _loc4_++;
               _loc5_--;
            }
         }
         else
         {
            _loc10_ = false;
            if(_loc8_ < _loc9_)
            {
               _loc5_++;
            }
            else if(_loc8_ > _loc9_)
            {
               _loc4_++;
            }
            else
            {
               _loc4_++;
               _loc5_++;
            }
         }
         while(_loc4_ != param2.x || _loc5_ != param2.y)
         {
            this.addOutList(_loc4_,_loc5_,param3);
            _loc11_ = (_loc4_ - param1.x) * _loc6_ + _loc7_;
            _loc12_ = (_loc5_ - param1.y) * _loc6_;
            if(_loc10_)
            {
               _loc12_ -= _loc7_;
            }
            else
            {
               _loc12_ += _loc7_;
            }
            if(_loc12_ < 0)
            {
               _loc12_ *= -1;
            }
            _loc11_ = _loc8_ * _loc12_ - _loc9_ * _loc11_;
            if(_loc11_ > 0)
            {
               _loc4_++;
            }
            else
            {
               if(_loc11_ == 0)
               {
                  _loc4_++;
               }
               if(_loc10_)
               {
                  _loc5_--;
               }
               else
               {
                  _loc5_++;
               }
            }
         }
      }
      
      public function getPerpendicularPos(param1:Position, param2:Position, param3:Position, param4:Position) : void
      {
         var _loc5_:Number = 2;
         var _loc6_:Number = param2.x - param1.x;
         var _loc7_:Number = param2.y - param1.y;
         if(_loc7_ == 0)
         {
            _loc7_ = 1;
         }
         var _loc8_:Number = Math.sqrt(_loc5_ * _loc5_ / (1 + _loc6_ * _loc6_ / (_loc7_ * _loc7_)));
         var _loc9_:Number = _loc6_ * _loc8_ / -_loc7_;
         param3.x = Math.floor(param1.x + _loc8_ + 0.5);
         param3.y = Math.floor(param1.y + _loc9_ + 0.5);
         param4.x = Math.floor(param1.x - _loc8_ + 0.5);
         param4.y = Math.floor(param1.y - _loc9_ + 0.5);
      }
      
      private function isPointInTriangle(param1:Position, param2:Position, param3:Position, param4:int, param5:int) : Boolean
      {
         return (param4 - param1.x) * (param1.y - param2.y) - (param5 - param1.y) * (param1.x - param2.x) >= 0 && (param4 - param2.x) * (param2.y - param3.y) - (param5 - param2.y) * (param2.x - param3.x) >= 0 && (param4 - param3.x) * (param3.y - param1.y) - (param5 - param3.y) * (param3.x - param1.x) >= 0;
      }
      
      private function topTriangleDirection(param1:Position, param2:Position, param3:Position) : Boolean
      {
         return (param2.x - param1.x) * (param3.y - param1.y) - (param3.x - param1.x) * (param2.y - param1.y) > 0;
      }
      
      public function getVectorList(param1:Position, param2:Position) : Vector.<Point>
      {
         var _loc11_:int = 0;
         var _loc3_:Position = this.mC;
         var _loc4_:Position = this.mD;
         this.getPerpendicularPos(param1,param2,_loc3_,_loc4_);
         if(!this.topTriangleDirection(param2,_loc3_,_loc4_))
         {
            param1 = _loc3_;
            _loc3_ = _loc4_;
            _loc4_ = param1;
         }
         var _loc5_:int = param2.x < _loc3_.x ? param2.x : _loc3_.x;
         if(_loc4_.x < _loc5_)
         {
            _loc5_ = _loc4_.x;
         }
         var _loc6_:int = param2.x < _loc3_.x ? _loc3_.x : param2.x;
         if(_loc4_.x > _loc6_)
         {
            _loc6_ = _loc4_.x;
         }
         var _loc7_:int = param2.y < _loc3_.y ? param2.y : _loc3_.y;
         if(_loc4_.y < _loc7_)
         {
            _loc7_ = _loc4_.y;
         }
         var _loc8_:int = param2.y < _loc3_.y ? _loc3_.y : param2.y;
         if(_loc4_.y > _loc8_)
         {
            _loc8_ = _loc4_.y;
         }
         var _loc9_:Vector.<Point> = new Vector.<Point>();
         var _loc10_:int = _loc5_;
         while(_loc10_ <= _loc6_)
         {
            _loc11_ = _loc7_;
            while(_loc11_ <= _loc8_)
            {
               if(_loc10_ >= 0 && _loc11_ >= 0 && _loc10_ < this.map_sx && _loc11_ < this.map_sy)
               {
                  if(this.isPointInTriangle(param2,_loc3_,_loc4_,_loc10_,_loc11_))
                  {
                     _loc9_.push(new Point(_loc10_,_loc11_));
                  }
               }
               _loc11_++;
            }
            _loc10_++;
         }
         this.getLine(param2,_loc3_,_loc9_);
         this.getLine(param2,_loc4_,_loc9_);
         this.getLine(_loc3_,_loc4_,_loc9_);
         return _loc9_;
      }
      
      private function addOutList(param1:int, param2:int, param3:Vector.<Point>) : void
      {
         var _loc5_:Point = null;
         if(param1 < 0 || param2 < 0 || param1 >= this.map_sx || param2 >= this.map_sy)
         {
            return;
         }
         var _loc4_:* = int(param3.length - 1);
         while(_loc4_ >= 0)
         {
            _loc5_ = param3[_loc4_];
            if(_loc5_.x == param1 && _loc5_.y == param2)
            {
               return;
            }
            _loc4_--;
         }
         param3.push(new Point(param1,param2));
      }
   }
}

