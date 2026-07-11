package engine
{
   import engine.data.MapCell;
   import logic.sim.SimDirection;
   
   public class Map
   {
      
      private const mapList:Vector.<MapCell>;
      
      private const openList:Vector.<MapCell>;
      
      private const closeList:Vector.<MapCell>;
      
      public const roundList:Vector.<Position>;
      
      private var sx:int;
      
      private var sy:int;
      
      public function Map(param1:int, param2:int)
      {
         var _loc4_:int = 0;
         var _loc5_:MapCell = null;
         this.mapList = new Vector.<MapCell>();
         this.openList = new Vector.<MapCell>();
         this.closeList = new Vector.<MapCell>();
         this.roundList = new <Position>[new Position(-1,0),new Position(0,-1),new Position(0,1),new Position(1,0),new Position(1,-1),new Position(-1,-1),new Position(-1,1),new Position(1,1)];
         super();
         this.sx = param1;
         this.sy = param2;
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            _loc4_ = 0;
            while(_loc4_ < param1)
            {
               _loc5_ = new MapCell();
               _loc5_.x = _loc4_;
               _loc5_.y = _loc3_;
               this.mapList.push(_loc5_);
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public function reset() : void
      {
         var _loc1_:MapCell = null;
         for each(_loc1_ in this.mapList)
         {
            _loc1_.walkFactor = 1;
            _loc1_.walkType = 0;
            _loc1_.unit = null;
            _loc1_.landing = true;
         }
      }
      
      public function setGlobalLanding(param1:Boolean) : void
      {
         var _loc2_:uint = this.mapList.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.mapList[_loc3_].landing = param1;
            _loc3_++;
         }
      }
      
      public function getMapCell(param1:int, param2:int) : MapCell
      {
         return this.mapList[param2 * this.sx + param1];
      }
      
      public function getSafeMapCell(param1:int, param2:int) : MapCell
      {
         return param1 < 0 || param2 < 0 || param1 >= this.sx || param2 >= this.sy ? null : this.mapList[param2 * this.sx + param1];
      }
      
      public function findPath(param1:int, param2:int, param3:int, param4:int, param5:Vector.<MapCell>, param6:Boolean = false) : Boolean
      {
         var _loc8_:Boolean = false;
         var _loc9_:uint = 0;
         var _loc11_:Position = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:MapCell = null;
         var _loc15_:* = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         if(param1 == param3 && param2 == param4)
         {
            return true;
         }
         var _loc7_:Vector.<Position> = this.roundList;
         var _loc10_:MapCell = this.getMapCell(param1,param2);
         _loc10_.g = 0;
         _loc10_.f = 1;
         while(true)
         {
            _loc10_.isClosed = true;
            this.closeList.push(_loc10_);
            if(_loc10_.x == param3 && _loc10_.y == param4)
            {
               break;
            }
            _loc9_ = 0;
            for(; _loc9_ < 8; _loc9_++)
            {
               _loc11_ = _loc7_[_loc9_];
               _loc12_ = _loc10_.x + _loc11_.x;
               if(!(_loc12_ < 0 || _loc12_ >= this.sx))
               {
                  _loc13_ = _loc10_.y + _loc11_.y;
                  if(!(_loc13_ < 0 || _loc13_ >= this.sy))
                  {
                     _loc14_ = this.mapList[_loc13_ * this.sx + _loc12_];
                     if(!(_loc14_.isClosed || _loc14_.walkFactor == 0))
                     {
                        if(_loc11_.x == 0 || _loc11_.y == 0)
                        {
                           _loc19_ = 1000;
                        }
                        else
                        {
                           if(_loc10_.walkType != 0)
                           {
                              continue;
                           }
                           _loc19_ = 1414;
                        }
                        if(!param6 && _loc14_.walkFactor > 1)
                        {
                           _loc19_ *= _loc14_.walkFactor;
                        }
                        _loc15_ = int(_loc12_ - param3);
                        _loc16_ = _loc13_ - param4;
                        if(_loc15_ < 0)
                        {
                           _loc15_ *= -1;
                        }
                        if(_loc16_ < 0)
                        {
                           _loc16_ *= -1;
                        }
                        _loc17_ = _loc15_ < _loc16_ ? _loc15_ : _loc16_;
                        _loc17_ = (1414 * _loc17_ + (_loc15_ + _loc16_ - 2 * _loc17_) * 1000) * 2;
                        _loc18_ = _loc10_.g + _loc19_;
                        _loc17_ += _loc18_;
                        if(_loc14_.f > 0)
                        {
                           if(_loc14_.f <= _loc17_)
                           {
                              continue;
                           }
                           _loc15_ = int(this.openList.length - 1);
                           while(_loc15_ >= 0)
                           {
                              if(this.openList[_loc15_] == _loc14_)
                              {
                                 this.openList.splice(_loc15_,1);
                                 break;
                              }
                              _loc15_--;
                           }
                        }
                        _loc14_.f = _loc17_;
                        _loc14_.g = _loc18_;
                        _loc14_.parent = _loc10_;
                        _loc8_ = true;
                        _loc16_ = int(this.openList.length);
                        _loc15_ = 0;
                        while(_loc15_ < _loc16_)
                        {
                           if(_loc17_ <= this.openList[_loc15_].f)
                           {
                              this.openList.splice(_loc15_,0,_loc14_);
                              _loc8_ = false;
                              break;
                           }
                           _loc15_++;
                        }
                        if(_loc8_)
                        {
                           this.openList.push(_loc14_);
                        }
                     }
                  }
               }
            }
            if(this.openList.length == 0)
            {
               _loc10_ = null;
               break;
            }
            _loc10_ = this.openList.shift();
         }
         if(_loc10_)
         {
            _loc8_ = true;
            do
            {
               param5.unshift(_loc10_);
               _loc10_ = _loc10_.parent;
               if(!_loc10_)
               {
                  param5.length = 0;
                  break;
               }
            }
            while(_loc10_.x != param1 || _loc10_.y != param2);
         }
         else
         {
            _loc8_ = false;
         }
         this.clearList(this.openList);
         this.clearList(this.closeList);
         return _loc8_;
      }
      
      private function clearList(param1:Vector.<MapCell>) : void
      {
         var _loc2_:MapCell = null;
         for each(_loc2_ in param1)
         {
            _loc2_.parent = null;
            _loc2_.isClosed = false;
            _loc2_.f = 0;
         }
         param1.length = 0;
      }
      
      public function checkVectorArea(param1:Position, param2:Position) : void
      {
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc3_:Boolean = param2.x < 0 || param2.x >= this.sx;
         if(!_loc3_ && param2.y >= 0 && param2.y < this.sy)
         {
            return;
         }
         var _loc4_:int = param1.y - param2.y;
         var _loc5_:int = param2.x - param1.x;
         var _loc6_:int = param1.x * param2.y - param2.x * param1.y;
         if(_loc3_)
         {
            _loc7_ = param2.x < 0 ? 0 : int(this.sx - 1);
            _loc8_ = (-_loc6_ - _loc4_ * _loc7_) / _loc5_;
            if(_loc8_ >= 0 && _loc8_ < this.sx)
            {
               param2.x = _loc7_;
               param2.y = _loc8_;
            }
            else
            {
               _loc3_ = false;
            }
         }
         if(!_loc3_)
         {
            _loc7_ = param2.y < 0 ? 0 : int(this.sy - 1);
            param2.x = (-_loc6_ - _loc5_ * _loc7_) / _loc4_;
            param2.y = _loc7_;
         }
      }
      
      public function getBresenhamLine(param1:int, param2:int, param3:int, param4:int, param5:Vector.<MapCell>, param6:Boolean = true) : void
      {
         var _loc11_:Boolean = false;
         var _loc12_:int = 0;
         var _loc13_:MapCell = null;
         var _loc7_:int = param3 > param1 ? 1 : -1;
         var _loc8_:int = param4 > param2 ? 1 : -1;
         var _loc9_:int = param1 > param3 ? int(param1 - param3) : int(param3 - param1);
         var _loc10_:int = param2 > param4 ? int(param2 - param4) : int(param4 - param2);
         if(_loc10_ > _loc9_)
         {
            _loc11_ = true;
            _loc12_ = _loc9_;
            _loc9_ = _loc10_;
            _loc10_ = _loc12_;
         }
         _loc12_ = 2 * _loc10_ - _loc9_;
         if(param6)
         {
            _loc13_ = this.getSafeMapCell(param1,param2);
            if(_loc13_)
            {
               param5.push(_loc13_);
            }
         }
         while(param1 != param3 || param2 != param4)
         {
            if(_loc12_ >= 0)
            {
               if(_loc11_)
               {
                  param1 += _loc7_;
               }
               else
               {
                  param2 += _loc8_;
               }
               _loc12_ -= 2 * _loc9_;
            }
            if(_loc11_)
            {
               param2 += _loc8_;
            }
            else
            {
               param1 += _loc7_;
            }
            _loc13_ = this.getSafeMapCell(param1,param2);
            if(_loc13_)
            {
               param5.push(_loc13_);
            }
            _loc12_ += 2 * _loc10_;
         }
      }
      
      public function checkBorder(param1:int, param2:int, param3:int = 2) : Boolean
      {
         return param1 >= param3 && param2 >= param3 && param1 < this.sx - param3 && param2 < this.sy - param3;
      }
      
      public function getDropLine(param1:int, param2:int, param3:int, param4:int, param5:Vector.<SimDirection>) : Vector.<MapCell>
      {
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Position = null;
         var _loc11_:Position = null;
         var _loc12_:Position = null;
         var _loc13_:Position = null;
         var _loc14_:Number = NaN;
         var _loc15_:SimDirection = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Number = NaN;
         var _loc19_:Boolean = false;
         var _loc20_:MapCell = null;
         var _loc6_:Vector.<MapCell> = new Vector.<MapCell>();
         this.addDropMapCell(_loc6_,this.getSafeMapCell(param1,param2));
         var _loc7_:* = 2;
         if(param4 == param2)
         {
            _loc8_ = 1;
            while(_loc8_ <= _loc7_)
            {
               this.addDropMapCell(_loc6_,this.getSafeMapCell(param1,param2 + _loc8_));
               this.addDropMapCell(_loc6_,this.getSafeMapCell(param1,param2 - _loc8_));
               _loc8_++;
            }
         }
         else
         {
            _loc9_ = (param3 - param1) / (param4 - param2);
            _loc10_ = new Position(param1,param2);
            _loc11_ = _loc10_.clone();
            _loc12_ = new Position();
            _loc13_ = new Position();
            while(_loc7_ > 0)
            {
               _loc14_ = Number.MAX_VALUE;
               for each(_loc15_ in param5)
               {
                  _loc16_ = _loc10_.x + _loc15_.x;
                  _loc17_ = _loc10_.y + _loc15_.y;
                  _loc18_ = Math.abs(_loc17_ - (_loc9_ * (param1 - _loc16_) + param2));
                  if(_loc18_ < _loc14_)
                  {
                     _loc19_ = false;
                     for each(_loc20_ in _loc6_)
                     {
                        if(_loc16_ == _loc20_.x && _loc17_ == _loc20_.y)
                        {
                           _loc19_ = true;
                           break;
                        }
                     }
                     if(!_loc19_)
                     {
                        _loc14_ = _loc18_;
                        _loc12_.x = _loc16_;
                        _loc12_.y = _loc17_;
                        _loc13_.x = _loc16_ - _loc10_.x;
                        _loc13_.y = _loc17_ - _loc10_.y;
                     }
                  }
               }
               _loc10_.x = _loc12_.x;
               _loc10_.y = _loc12_.y;
               _loc16_ = _loc11_.x - _loc13_.x;
               _loc17_ = _loc11_.y - _loc13_.y;
               _loc11_.x = _loc16_;
               _loc11_.y = _loc17_;
               this.addDropMapCell(_loc6_,this.getSafeMapCell(_loc12_.x,_loc12_.y));
               this.addDropMapCell(_loc6_,this.getSafeMapCell(_loc16_,_loc17_));
               _loc7_--;
            }
         }
         return _loc6_;
      }
      
      private function addDropMapCell(param1:Vector.<MapCell>, param2:MapCell) : void
      {
         if(Boolean(param2) && Boolean(param2.landing) && !param2.unit)
         {
            param1.push(param2);
         }
      }
      
      public function getCorrectMapCell(param1:int, param2:int) : MapCell
      {
         var _loc3_:MapCell = this.getSafeMapCell(param1,param2);
         if(_loc3_)
         {
            return _loc3_;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 >= this.sx)
         {
            param1 = this.sx - 1;
         }
         if(param2 < 0)
         {
            param2 = 0;
         }
         if(param2 >= this.sy)
         {
            param2 = this.sy - 1;
         }
         return this.getMapCell(param1,param2);
      }
   }
}

