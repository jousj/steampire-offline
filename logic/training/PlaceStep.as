package logic.training
{
   import engine.Isometric;
   import engine.Map;
   import engine.Position;
   import engine.data.MapCell;
   import engine.units.Unit;
   import flash.geom.Point;
   import game.board.UnitAreaBox;
   import logic.units.TrainLogic;
   import model.CommonEvent;
   import ui.UIFactory;
   
   public class PlaceStep extends AbstractTrainStep
   {
      
      public var smooth:Boolean = true;
      
      private var pos:Position;
      
      private var areaBox:UnitAreaBox;
      
      private var unit:Unit;
      
      private var isNew:Boolean;
      
      private var trainLogic:TrainLogic;
      
      public function PlaceStep(param1:Position = null, param2:Boolean = true)
      {
         super();
         this.pos = param1;
         this.isNew = param2;
      }
      
      private function checkPlace(param1:int, param2:int) : Boolean
      {
         var _loc6_:int = 0;
         var _loc3_:int = this.unit.size - 1;
         var _loc4_:Map = Facade.map;
         var _loc5_:int = param1 - _loc3_;
         while(_loc5_ <= param1)
         {
            _loc6_ = param2 - _loc3_;
            while(_loc6_ <= param2)
            {
               if(!_loc4_.checkBorder(_loc5_,_loc6_) || _loc4_.getMapCell(_loc5_,_loc6_).occupied)
               {
                  return false;
               }
               _loc6_++;
            }
            _loc5_++;
         }
         return true;
      }
      
      private function searchPlacePos() : Boolean
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc1_:uint = 2;
         var _loc2_:uint = 10;
         var _loc3_:* = this.pos.x;
         var _loc4_:* = this.pos.y;
         while(_loc2_ > 0)
         {
            _loc3_++;
            _loc4_--;
            _loc5_ = 0;
            while(_loc5_ < 4)
            {
               _loc6_ = 0;
               while(_loc6_ < _loc1_)
               {
                  if(_loc5_ == 0)
                  {
                     _loc4_++;
                  }
                  else if(_loc5_ == 1)
                  {
                     _loc3_--;
                  }
                  else if(_loc5_ == 2)
                  {
                     _loc4_--;
                  }
                  else
                  {
                     _loc3_++;
                  }
                  if(this.checkPlace(_loc3_,_loc4_))
                  {
                     this.pos.x = _loc3_;
                     this.pos.y = _loc4_;
                     return true;
                  }
                  _loc6_++;
               }
               _loc5_++;
            }
            _loc1_ += 2;
            _loc2_--;
         }
         return false;
      }
      
      override public function run() : void
      {
         if(this.isNew)
         {
            if(!Facade.boardMediator.checkNewUnit())
            {
               end();
               return;
            }
            this.unit = Facade.boardMediator.getSelected();
            Facade.addListener(CommonEvent.NEW_UNIT,end);
         }
         else
         {
            this.unit = Facade.boardMediator.getSelected();
            this.trainLogic = new TrainLogic(this.unit);
            this.trainLogic.changeMoveHandler = this.checkMoveEnd;
         }
         if(Boolean(this.pos) && !this.checkPlace(this.pos.x,this.pos.y))
         {
            if(!this.searchPlacePos())
            {
               end();
               return;
            }
         }
         if(!this.pos)
         {
            return;
         }
         if(this.smooth)
         {
            Facade.boardMediator.smoothMoveBoard(this.pos.x,this.pos.y);
         }
         else
         {
            Facade.boardMediator.moveBoard(this.pos.x,this.pos.y);
         }
         this.changeWalkFactor(true);
         Facade.addListener(CommonEvent.BOARD_RESET_DOWN,this.onBoardResetDown);
         this.areaBox = new UnitAreaBox();
         this.areaBox.changeSize(this.unit.size,this.unit.size);
         this.areaBox.resetCheck(true);
         this.areaBox.update();
         this.areaBox.addChild(UIFactory.createLearnArrow()).y = -this.unit.size * Isometric.POS_HALF_HEIGHT;
         var _loc1_:Point = new Point();
         Isometric.posToScreen(this.pos.x,this.pos.y,_loc1_);
         this.areaBox.x = _loc1_.x;
         this.areaBox.y = _loc1_.y;
         Facade.board.addChild(this.areaBox);
      }
      
      private function checkMoveEnd(param1:Boolean) : void
      {
         if(!param1)
         {
            end();
         }
      }
      
      private function changeWalkFactor(param1:Boolean) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:* = 0;
         var _loc10_:MapCell = null;
         if(param1)
         {
            _loc7_ = 1;
            _loc8_ = 1000;
         }
         else
         {
            _loc7_ = 1000;
            _loc8_ = 1;
         }
         var _loc2_:Map = Facade.map;
         var _loc3_:int = this.unit.size - 1;
         var _loc4_:int = this.pos.x - _loc3_;
         _loc3_ = this.pos.y - _loc3_;
         var _loc5_:int = Facade.map_sy - 1;
         var _loc6_:* = int(Facade.map_sx - 1);
         while(_loc6_ >= 0)
         {
            _loc9_ = _loc5_;
            while(_loc9_ >= 0)
            {
               _loc10_ = _loc2_.getMapCell(_loc6_,_loc9_);
               if((Boolean(_loc10_)) && Boolean(!_loc10_.unit) && _loc10_.walkFactor == _loc7_)
               {
                  if(_loc6_ < _loc4_ || _loc9_ < _loc3_ || _loc6_ > this.pos.x || _loc9_ > this.pos.y)
                  {
                     _loc10_.walkFactor = _loc8_;
                  }
               }
               _loc9_--;
            }
            _loc6_--;
         }
      }
      
      private function onBoardResetDown(param1:CommonEvent) : void
      {
         var _loc2_:Unit = Facade.boardMediator.getSelected();
         if(Boolean(_loc2_) && !this.pos.equal(_loc2_.b_x,_loc2_.b_y))
         {
            Facade.boardMediator.moveBoard(this.pos.x,this.pos.y);
         }
      }
      
      override public function dispose() : void
      {
         if(this.isNew)
         {
            Facade.removeListener(CommonEvent.NEW_UNIT,end);
         }
         else
         {
            this.trainLogic.dispose();
         }
         Facade.removeListener(CommonEvent.BOARD_RESET_DOWN,this.onBoardResetDown);
         if(Boolean(this.unit) && Boolean(this.pos))
         {
            this.changeWalkFactor(false);
         }
         if(this.areaBox)
         {
            this.areaBox.parent.removeChild(this.areaBox);
         }
      }
   }
}

