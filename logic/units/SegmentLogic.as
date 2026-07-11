package logic.units
{
   import engine.data.MapCell;
   import engine.units.Fence;
   import engine.units.Unit;
   import logic.BoardLogic;
   import model.ui.VOTownHallItem;
   import ui.vbase.VGrid;
   
   public class SegmentLogic extends AbstractLogic
   {
      
      public const list:Vector.<Fence> = new Vector.<Fence>();
      
      public var link_x:int;
      
      public var link_y:int;
      
      public var count:int;
      
      public var gridItem:VOTownHallItem;
      
      public var grid:VGrid;
      
      public function SegmentLogic()
      {
         super();
      }
      
      override public function onMove(param1:Unit) : void
      {
         var _loc7_:MapCell = null;
         var _loc8_:Fence = null;
         var _loc2_:* = int(Math.abs(param1.c_x - this.link_x));
         var _loc3_:int = Math.abs(param1.c_y - this.link_y);
         var _loc4_:Boolean = _loc2_ >= _loc3_;
         if(_loc4_)
         {
            _loc3_ = param1.c_x > this.link_x ? 1 : -1;
         }
         else
         {
            _loc2_ = _loc3_;
            _loc3_ = param1.c_y > this.link_y ? 1 : -1;
         }
         var _loc5_:int = this.link_x;
         var _loc6_:int = this.link_y;
         this.count = 0;
         while(_loc2_ > 0 && this.count < this.list.length)
         {
            _loc2_--;
            if(_loc4_)
            {
               _loc5_ += _loc3_;
            }
            else
            {
               _loc6_ += _loc3_;
            }
            if(!map.checkBorder(_loc5_,_loc6_))
            {
               break;
            }
            _loc7_ = map.getMapCell(_loc5_,_loc6_);
            if(!_loc7_.occupied)
            {
               _loc8_ = this.list[this.count];
               if(_loc8_.display.parent)
               {
                  BoardLogic.bind(_loc8_,false);
                  if(this.count == 0)
                  {
                     FenceLogic.aroundConnect(_loc8_.c_x,_loc8_.c_y);
                  }
                  _loc8_.setGeometry(_loc5_,_loc6_,true);
               }
               else
               {
                  _loc8_.setGeometry(_loc5_,_loc6_,false);
                  boardMediator.addObject(_loc8_,false,false);
                  userProxy.fenceList.add(_loc8_);
               }
               BoardLogic.bind(_loc8_,true);
               ++this.count;
            }
            else if(_loc7_.unit == this.list[this.count])
            {
               ++this.count;
            }
         }
         _loc3_ = 0;
         while(_loc3_ < this.count)
         {
            _loc8_ = this.list[_loc3_];
            FenceLogic.aroundConnect(_loc8_.c_x,_loc8_.c_y);
            _loc3_++;
         }
         if(this.count > 0)
         {
            FenceLogic.connect(this.list[this.count - 1]);
         }
         this.clear(this.count);
         BoardLogic.updateLanding();
         this.gridItem.count = this.list.length - this.count;
         this.grid.sync();
      }
      
      public function clear(param1:int = 0) : void
      {
         var _loc4_:Fence = null;
         var _loc2_:int = int(this.list.length);
         var _loc3_:int = param1;
         while(_loc3_ < _loc2_)
         {
            if(!this.list[_loc3_].display.parent)
            {
               break;
            }
            BoardLogic.bind(this.list[_loc3_],false);
            _loc3_++;
         }
         _loc3_ = param1;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.list[_loc3_];
            if(!_loc4_.display.parent)
            {
               break;
            }
            Facade.boardMediator.removeObject(_loc4_);
            Facade.userProxy.fenceList.remove(_loc4_);
            FenceLogic.aroundConnect(_loc4_.c_x,_loc4_.c_y);
            _loc3_++;
         }
      }
      
      public function reset(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.clear();
         }
         this.list.length = 0;
         this.count = 0;
         this.gridItem = null;
      }
   }
}

