package logic
{
   import ESkins.RedLand;
   import ESkins.YellowLand;
   import engine.Isometric;
   import engine.Map;
   import engine.Position;
   import engine.data.GroupIterator;
   import engine.data.LinkedItem;
   import engine.data.MapCell;
   import engine.units.Fence;
   import engine.units.Unit;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   import game.board.BoardMediator;
   import game.feature.FeatureMediator;
   import logic.units.FenceLogic;
   import model.UserProxy;
   import proto.game.family_0010.PUserAction;
   import proto.model.PMove;
   
   public class BoardLogic
   {
      
      public function BoardLogic()
      {
         super();
      }
      
      public static function bind(param1:Unit, param2:Boolean) : void
      {
         var _loc6_:MapCell = null;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:uint = 0;
         var _loc3_:int = int(param1.size);
         var _loc4_:Map = Facade.map;
         var _loc5_:Boolean = param1 is Fence;
         if(_loc3_ == 1)
         {
            _loc6_ = _loc4_.getSafeMapCell(param1.t_x,param1.t_y);
            if(_loc6_)
            {
               if(param2)
               {
                  _loc6_.bind(param1,_loc5_ ? 4 : 3,16);
               }
               else
               {
                  _loc6_.unbind(param1);
               }
            }
         }
         else
         {
            _loc7_ = 1;
            while(_loc7_ <= _loc3_)
            {
               _loc8_ = param1.t_y + _loc7_ - 1;
               _loc9_ = 1;
               while(_loc9_ <= _loc3_)
               {
                  _loc10_ = param1.t_x + _loc9_ - 1;
                  _loc6_ = _loc4_.getSafeMapCell(_loc10_,_loc8_);
                  if(_loc6_)
                  {
                     if(param2)
                     {
                        if(_loc5_)
                        {
                           _loc6_.bind(param1,4,16);
                        }
                        else
                        {
                           _loc11_ = param1.getWalkType(_loc9_,_loc7_);
                           _loc6_.bind(param1,_loc11_ != 511 ? 3 : 0,_loc11_);
                        }
                     }
                     else
                     {
                        _loc6_.unbind(param1);
                     }
                  }
                  _loc9_++;
               }
               _loc7_++;
            }
         }
      }
      
      public static function getBind(param1:int, param2:int) : Unit
      {
         var _loc3_:MapCell = Facade.map.getSafeMapCell(param1,param2);
         if(_loc3_)
         {
            return _loc3_.unit;
         }
         return null;
      }
      
      public static function getRadiusDistance(param1:uint) : uint
      {
         var _loc2_:uint = param1 * param1;
         return _loc2_ + ((param1 + 1) * (param1 + 1) - _loc2_ >> 1);
      }
      
      public static function getRadiusPositionList(param1:int, param2:int, param3:uint, param4:uint, param5:uint = 0, param6:Vector.<MapCell> = null) : Vector.<MapCell>
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         var _loc15_:MapCell = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:uint = 0;
         if(param5 > 0)
         {
            param5 = getRadiusDistance(param5);
         }
         if((param3 & 1) != 0)
         {
            _loc9_ = param1 - param4;
            _loc10_ = param1 + param4;
            _loc11_ = param2 - param4;
            _loc12_ = param2 + param4;
         }
         else
         {
            _loc13_ = true;
            _loc9_ = param1 - 1 - param4;
            _loc10_ = param1 + param4;
            _loc11_ = param2 - 1 - param4;
            _loc12_ = param2 + param4;
         }
         param4 = getRadiusDistance(param4);
         if(!param6)
         {
            param6 = new Vector.<MapCell>();
         }
         var _loc7_:Map = Facade.map;
         var _loc8_:int = _loc9_;
         while(_loc8_ <= _loc10_)
         {
            _loc14_ = _loc11_;
            while(_loc14_ <= _loc12_)
            {
               _loc15_ = _loc7_.getSafeMapCell(_loc8_,_loc14_);
               if(_loc15_)
               {
                  _loc16_ = _loc8_ - param1;
                  _loc17_ = _loc14_ - param2;
                  if(_loc13_)
                  {
                     if(_loc8_ >= param1)
                     {
                        if(_loc14_ < param2)
                        {
                           _loc17_++;
                        }
                     }
                     else
                     {
                        _loc16_++;
                        if(_loc14_ < param2)
                        {
                           _loc17_++;
                        }
                     }
                  }
                  _loc18_ = _loc16_ * _loc16_ + _loc17_ * _loc17_;
                  if((param5 == 0 || _loc18_ > param5) && _loc18_ <= param4)
                  {
                     param6.push(_loc15_);
                  }
               }
               _loc14_++;
            }
            _loc8_++;
         }
         return param6;
      }
      
      public static function move(param1:Unit, param2:Object) : void
      {
         if(param2)
         {
            ShopLogic.confirmBuy(param1,param2);
         }
         else
         {
            ActionLogic.request(PUserAction.MOVE,PMove.create(UnitFactory.getServerObjectId(param1),new Position(param1.b_x,param1.b_y)));
         }
      }
      
      public static function updateLanding(param1:Boolean = true, param2:Boolean = true) : void
      {
         var _loc4_:Unit = null;
         if(param2)
         {
            Facade.map.setGlobalLanding(true);
         }
         var _loc3_:GroupIterator = new GroupIterator(Facade.userProxy.landingGroup);
         while(_loc3_.item)
         {
            _loc4_ = _loc3_.item as Unit;
            setUnitLanding(_loc4_.b_x,_loc4_.b_y,_loc4_.size);
            _loc3_.next();
         }
         _loc3_.dispose();
         if(param1)
         {
            drawLanding();
         }
      }
      
      public static function setUnitLanding(param1:int, param2:int, param3:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:MapCell = null;
         param1++;
         param2++;
         param3++;
         var _loc4_:Map = Facade.map;
         var _loc5_:int = param1 - param3;
         while(_loc5_ <= param1)
         {
            _loc6_ = param2 - param3;
            while(_loc6_ <= param2)
            {
               _loc7_ = _loc4_.getSafeMapCell(_loc5_,_loc6_);
               if(_loc7_)
               {
                  _loc7_.landing = false;
               }
               _loc6_++;
            }
            _loc5_++;
         }
      }
      
      public static function drawLanding() : void
      {
         var _loc10_:int = 0;
         var _loc11_:MapCell = null;
         var _loc12_:int = 0;
         var _loc13_:uint = 0;
         var _loc14_:MovieClip = null;
         var _loc1_:Map = Facade.map;
         var _loc2_:Sprite = Facade.board.createLanding();
         var _loc3_:Boolean = Facade.isBattle;
         var _loc4_:* = _loc2_.numChildren;
         var _loc5_:int = 0;
         var _loc6_:int = Facade.map_sx;
         var _loc7_:int = Facade.map_sy;
         var _loc8_:Point = new Point();
         var _loc9_:* = 0;
         while(_loc9_ < _loc6_)
         {
            _loc10_ = 0;
            while(_loc10_ < _loc7_)
            {
               _loc11_ = _loc1_.getSafeMapCell(_loc9_,_loc10_);
               if(!_loc11_.landing)
               {
                  _loc12_ = 0;
                  _loc11_ = _loc1_.getSafeMapCell(_loc9_ - 1,_loc10_);
                  if(!_loc11_ || _loc11_.landing)
                  {
                     _loc12_ |= 1;
                  }
                  _loc11_ = _loc1_.getSafeMapCell(_loc9_ + 1,_loc10_);
                  if(!_loc11_ || _loc11_.landing)
                  {
                     _loc12_ |= 4;
                  }
                  _loc11_ = _loc1_.getSafeMapCell(_loc9_,_loc10_ + 1);
                  if(!_loc11_ || _loc11_.landing)
                  {
                     _loc12_ |= 8;
                  }
                  _loc11_ = _loc1_.getSafeMapCell(_loc9_,_loc10_ - 1);
                  if(!_loc11_ || _loc11_.landing)
                  {
                     _loc12_ |= 2;
                  }
                  if(_loc12_ == 0)
                  {
                     _loc11_ = _loc1_.getSafeMapCell(_loc9_ - 1,_loc10_ + 1);
                     _loc13_ = 0;
                     if(!_loc11_ || _loc11_.landing)
                     {
                        _loc13_++;
                     }
                     _loc11_ = _loc1_.getSafeMapCell(_loc9_ + 1,_loc10_ - 1);
                     if(!_loc11_ || _loc11_.landing)
                     {
                        _loc12_ = 1;
                        _loc13_++;
                     }
                     _loc11_ = _loc1_.getSafeMapCell(_loc9_ - 1,_loc10_ - 1);
                     if(!_loc11_ || _loc11_.landing)
                     {
                        _loc12_ = 2;
                        _loc13_++;
                     }
                     _loc11_ = _loc1_.getSafeMapCell(_loc9_ + 1,_loc10_ + 1);
                     if(!_loc11_ || _loc11_.landing)
                     {
                        _loc12_ = 3;
                        _loc13_++;
                     }
                     if(_loc13_ > 0)
                     {
                        if(_loc13_ == 1)
                        {
                           _loc12_ += 16;
                        }
                        else
                        {
                           _loc12_ = 20;
                        }
                     }
                  }
                  if(_loc12_ > 0)
                  {
                     if(_loc5_ < _loc4_)
                     {
                        _loc14_ = _loc2_.getChildAt(_loc5_) as MovieClip;
                        if(_loc14_.currentFrame != _loc12_)
                        {
                           _loc14_.gotoAndStop(_loc12_);
                        }
                        _loc5_++;
                     }
                     else
                     {
                        _loc14_ = _loc3_ ? new RedLand() : new YellowLand();
                        _loc14_.gotoAndStop(_loc12_);
                        _loc2_.addChild(_loc14_);
                     }
                     Isometric.posToScreen(_loc9_,_loc10_,_loc8_);
                     _loc14_.x = _loc8_.x - Isometric.POS_HALF_WIDTH;
                     _loc14_.y = _loc8_.y - Isometric.POS_HALF_HEIGHT;
                  }
               }
               _loc10_++;
            }
            _loc9_++;
         }
         while(_loc5_ < _loc4_)
         {
            _loc4_--;
            _loc2_.removeChildAt(_loc4_);
         }
         if(_loc3_)
         {
            _loc9_ = int(_loc7_ - 1);
            while(_loc9_ >= 0)
            {
               addLandingBorder(_loc2_,4,-1,_loc9_,_loc8_);
               addLandingBorder(_loc2_,1,_loc6_,_loc9_,_loc8_);
               _loc9_--;
            }
            _loc9_ = int(_loc6_ - 1);
            while(_loc9_ >= 0)
            {
               addLandingBorder(_loc2_,8,_loc9_,-1,_loc8_);
               addLandingBorder(_loc2_,2,_loc9_,_loc7_,_loc8_);
               _loc9_--;
            }
            _loc2_.cacheAsBitmap = true;
         }
      }
      
      private static function addLandingBorder(param1:Sprite, param2:int, param3:int, param4:int, param5:Point) : void
      {
         var _loc6_:MovieClip = new YellowLand();
         _loc6_.gotoAndStop(param2);
         param1.addChild(_loc6_);
         Isometric.posToScreen(param3,param4,param5);
         _loc6_.x = param5.x - Isometric.POS_HALF_WIDTH;
         _loc6_.y = param5.y - Isometric.POS_HALF_HEIGHT;
      }
      
      public static function drawRhomb(param1:Graphics, param2:int, param3:int) : void
      {
         var _loc4_:Point = new Point();
         Isometric.posToScreen(param2,param3,_loc4_);
         var _loc5_:Number = Isometric.POS_HALF_WIDTH;
         var _loc6_:Number = Isometric.POS_HALF_HEIGHT;
         var _loc7_:Number = _loc4_.x - _loc5_;
         var _loc8_:Number = _loc4_.y - _loc6_;
         param1.moveTo(_loc7_ + _loc5_,_loc8_);
         var _loc9_:Number = _loc7_ + _loc5_ * 2 + 1;
         param1.lineTo(_loc9_,_loc8_ + _loc6_);
         var _loc10_:Number = _loc8_ + _loc6_ * 2;
         param1.lineTo(_loc7_ + _loc5_,_loc10_);
         param1.lineTo(_loc7_,_loc8_ + _loc6_);
         param1.lineTo(_loc7_ + _loc5_,_loc8_);
      }
      
      public static function addAllObjects() : void
      {
         var _loc4_:Unit = null;
         var _loc1_:UserProxy = Facade.userProxy;
         var _loc2_:BoardMediator = Facade.boardMediator;
         var _loc3_:LinkedItem = _loc1_.buildList.head;
         while(_loc3_)
         {
            _loc4_ = _loc3_ as Unit;
            _loc2_.addObject(_loc4_,false,true);
            _loc3_ = _loc3_.link_next;
         }
         _loc3_ = _loc1_.fenceList.head;
         while(_loc3_)
         {
            _loc2_.addObject(_loc3_ as Unit,false);
            FenceLogic.connect(_loc3_ as Fence);
            _loc3_ = _loc3_.link_next;
         }
         _loc3_ = _loc1_.cannonList.head;
         while(_loc3_)
         {
            _loc2_.addObject(_loc3_ as Unit);
            _loc3_ = _loc3_.link_next;
         }
         _loc3_ = _loc1_.decorList.head;
         while(_loc3_)
         {
            _loc2_.addObject(_loc3_ as Unit);
            _loc3_ = _loc3_.link_next;
         }
         _loc3_ = _loc1_.garbageList.head;
         while(_loc3_)
         {
            _loc2_.addObject(_loc3_ as Unit);
            _loc3_ = _loc3_.link_next;
         }
      }
      
      public static function onInfo(param1:Unit) : void
      {
         Facade.mainMediator.showDialog(new FeatureMediator(param1));
      }
      
      public static function onRemove(param1:Unit) : void
      {
         ActionLogic.request(PUserAction.DELETE_OBJECT,UnitFactory.getServerObjectId(param1));
         UnitFactory.removeConstruction(param1);
      }
   }
}

