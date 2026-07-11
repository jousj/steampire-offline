package logic.training
{
   import engine.Board;
   import engine.Isometric;
   import engine.Position;
   import engine.data.MapCell;
   import engine.signal.Signal;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.board.BoardMediator;
   import logic.battle.BattleBoardDrop;
   import model.CommonEvent;
   import model.ui.VOBattleItem;
   
   public class SoftDropStep extends AbstractTrainStep
   {
      
      private const VECTOR_DURATION:Number = 0.41;
      
      private const ALPHA_DURATION:Number = 1;
      
      private const bm:BoardMediator = Facade.boardMediator;
      
      private const board:Board = Facade.board;
      
      private var startPos:Position;
      
      private var startDelay:Number;
      
      private var startPoint:Point;
      
      private var curPoint:Point;
      
      private var finPoint:Point;
      
      private var shape:Shape;
      
      private var signal:Signal;
      
      private var posA:Position;
      
      private var posB:Position;
      
      private var isSpell:Boolean;
      
      public function SoftDropStep(param1:Position = null, param2:Position = null, param3:Number = 1.33)
      {
         super();
         if(!param1)
         {
            this.isSpell = true;
         }
         else
         {
            this.startDelay = param3;
            this.posA = param1;
            this.posB = param2;
         }
      }
      
      override public function run() : void
      {
         var _loc1_:VOBattleItem = Facade.battleMediator.selectItem;
         if(!_loc1_)
         {
            return;
         }
         if(Boolean(_loc1_.spellShop) && this.isSpell)
         {
            this.board.addEventListener(MouseEvent.MOUSE_UP,this.onSoftUp,false,10000);
         }
         else if(Boolean(_loc1_.shop) && !this.isSpell)
         {
            this.signal = new Signal();
            this.signal.handler = this.unitDropInit;
            this.signal.delayCall(this.startDelay);
            Facade.board.addEventListener(MouseEvent.MOUSE_DOWN,this.onUnitDown);
         }
         else
         {
            end();
         }
      }
      
      private function unitDropInit() : void
      {
         this.shape = Facade.board.addDirectionShape();
         this.startPoint = new Point();
         this.finPoint = new Point();
         this.curPoint = new Point();
         Isometric.posToScreen(this.posA.x,this.posA.y,this.startPoint);
         Isometric.posToScreen(this.posB.x,this.posB.y,this.finPoint);
         this.signal.handler = this.drawVector;
         this.signal.run(this.VECTOR_DURATION);
         this.signal.delay = 0.03;
         this.signal.data = 0;
      }
      
      override public function dispose() : void
      {
         this.board.removeEventListener(MouseEvent.MOUSE_UP,this.onSoftUp);
         if(this.signal)
         {
            this.signal.stopWithoutHandler();
            this.signal = null;
         }
         if(this.shape)
         {
            if(this.shape.parent)
            {
               this.shape.parent.removeChild(this.shape);
            }
            this.shape = null;
         }
         this.onReset(false);
         super.dispose();
      }
      
      private function onUnitDown(param1:MouseEvent) : void
      {
         var _loc2_:Point = this.board.globalToLocal(new Point(param1.stageX,param1.stageY));
         this.startPos = new Position();
         Isometric.screenToPos(_loc2_.x,_loc2_.y,this.startPos);
         var _loc3_:MapCell = Facade.map.getSafeMapCell(this.startPos.x,this.startPos.y);
         if(Boolean(_loc3_) && Boolean(_loc3_.landing) || !_loc3_)
         {
            Facade.addListener(CommonEvent.BOARD_RESET_DOWN,this.onReset);
            Facade.board.removeEventListener(MouseEvent.MOUSE_DOWN,this.onUnitDown);
            Facade.board.addEventListener(MouseEvent.MOUSE_UP,this.onSoftUp,false,1);
         }
      }
      
      private function drawVector() : void
      {
         this.shape.alpha = 0.7;
         this.curPoint.x = this.signal.passedRate * (this.finPoint.x - this.startPoint.x) + this.startPoint.x;
         this.curPoint.y = this.signal.passedRate * (this.finPoint.y - this.startPoint.y) + this.startPoint.y;
         if(!this.curPoint.equals(this.startPoint))
         {
            BattleBoardDrop.drawVector(this.shape.graphics,this.startPoint,this.curPoint);
         }
         if(this.signal.tail == 0)
         {
            ++this.signal.data;
            this.signal.handler = this.applyShapeAlpha;
            this.signal.run(this.ALPHA_DURATION);
         }
      }
      
      private function applyShapeAlpha() : void
      {
         this.shape.alpha = 0.7 - this.signal.passedRate * 0.7;
         if(this.signal.tail == 0)
         {
            Isometric.posToScreen(this.posA.x,this.posA.y,this.startPoint);
            Isometric.posToScreen(this.posB.x,this.posB.y,this.finPoint);
            this.signal.handler = this.drawVector;
            this.signal.run(this.VECTOR_DURATION);
         }
      }
      
      private function onSoftUp(param1:MouseEvent) : void
      {
         if(!this.bm.checkClick() || !Facade.battleMediator.selectItem)
         {
            return;
         }
         var _loc2_:Point = this.board.globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc3_:Position = new Position();
         Isometric.screenToPos(_loc2_.x,_loc2_.y,_loc3_);
         var _loc4_:MapCell = Facade.map.getSafeMapCell(_loc3_.x,_loc3_.y);
         if((Boolean(_loc4_)) && !(this.startPos && this.startPos.equal_p(_loc3_)))
         {
            if(this.isSpell)
            {
               Facade.battleMediator.dropSpell(_loc2_);
            }
            else
            {
               Facade.boardMediator.battleDrop.up(_loc2_);
            }
            param1.stopImmediatePropagation();
            this.bm.resetDown();
            end();
         }
      }
      
      private function onReset(param1:Object) : void
      {
         var _loc2_:Boolean = Boolean(param1);
         Facade.board.removeEventListener(MouseEvent.MOUSE_DOWN,this.onUnitDown);
         Facade.board.removeEventListener(MouseEvent.MOUSE_UP,this.onSoftUp);
         Facade.removeListener(CommonEvent.BOARD_RESET_DOWN,this.onReset);
         if(_loc2_)
         {
            Facade.board.addEventListener(MouseEvent.MOUSE_DOWN,this.onUnitDown);
         }
      }
   }
}

