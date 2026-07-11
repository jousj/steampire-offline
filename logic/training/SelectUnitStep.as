package logic.training
{
   import engine.Board;
   import engine.Isometric;
   import engine.Position;
   import engine.signal.Signal;
   import engine.units.Unit;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.board.BoardMediator;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class SelectUnitStep extends AbstractTrainStep
   {
      
      private const learnSkin:VSkin = SkinManager.getEmbed("MouseDemo");
      
      private const bm:BoardMediator = Facade.boardMediator;
      
      private const board:Board = Facade.board;
      
      private const clickSignal:Signal;
      
      private var selectOrTake:Boolean;
      
      private var x:int;
      
      private var y:int;
      
      private var unit:Unit;
      
      private var offset:Point;
      
      private var area:uint;
      
      public function SelectUnitStep(param1:Unit, param2:uint = 1, param3:Boolean = true, param4:Point = null)
      {
         this.clickSignal = new Signal(this.onClickSignal);
         super();
         this.unit = param1;
         this.area = param2;
         this.selectOrTake = param3;
         this.offset = param4 || new Point();
         this.x = param1.c_x;
         this.y = param1.c_y;
      }
      
      override public function run() : void
      {
         var _loc1_:Point = null;
         this.board.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,10000);
         this.board.effectPanel.addChild(this.learnSkin);
         _loc1_ = new Point();
         Isometric.posToScreen(this.x,this.y,_loc1_);
         var _loc2_:VText = UIFactory.createYellowText(Lang.getString(this.selectOrTake ? "train_mouse_select_1" : "train_mouse_select_2"),0,20);
         _loc2_.maxW = 250;
         _loc2_.geometryPhase();
         this.learnSkin.addChild(_loc2_);
         _loc2_.x = 34;
         _loc2_.y = -14;
         this.learnSkin.x = _loc1_.x + this.offset.x;
         this.learnSkin.y = _loc1_.y - 30 + this.offset.y;
         this.clickSignal.delay = 1;
         this.clickSignal.run(uint.MAX_VALUE);
         if(this.selectOrTake)
         {
            this.unit.display.addFilter(Style.CHOICE_FILTER);
         }
      }
      
      private function onClickSignal() : void
      {
         (this.learnSkin.content as MovieClip).gotoAndPlay(0);
      }
      
      override public function dispose() : void
      {
         this.board.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
         this.learnSkin.removeFromParent();
         this.clickSignal.stopWithoutHandler();
         if(this.selectOrTake)
         {
            this.unit.display.removeFilter(Style.CHOICE_FILTER);
            this.unit.display.removeFilter(Style.CHOICE_OUT_FILTER);
         }
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         if(!this.bm.checkClick())
         {
            return;
         }
         param1.stopImmediatePropagation();
         this.bm.resetDown();
         var _loc2_:Point = this.board.globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc3_:Position = new Position();
         Isometric.screenToPos(_loc2_.x,_loc2_.y,_loc3_);
         if(_loc3_.x >= this.x - this.area && _loc3_.x <= this.x + this.area && _loc3_.y >= this.y - this.area && _loc3_.y <= this.y + this.area)
         {
            if(this.selectOrTake)
            {
               Facade.boardMediator.setSelected(this.unit);
            }
            else
            {
               Facade.boardMediator.useMoveState(this.unit);
            }
            end();
         }
         else
         {
            Facade.mainMediator.flightMessage(Lang.getString("bad_area"));
            this.bm.smoothMoveBoard(this.x,this.y);
         }
      }
   }
}

