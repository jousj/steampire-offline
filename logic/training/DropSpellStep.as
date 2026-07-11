package logic.training
{
   import engine.Board;
   import engine.Isometric;
   import engine.Position;
   import engine.data.MapCell;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Unit;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.board.BoardMediator;
   import logic.BoardLogic;
   import model.ui.VOBattleItem;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class DropSpellStep extends AbstractTrainStep
   {
      
      private const learnSkin:VSkin = UIFactory.createLearnArrow();
      
      private const bm:BoardMediator = Facade.boardMediator;
      
      private const board:Board = Facade.board;
      
      private const text:VText = UIFactory.createYellowText(Lang.getString("use_spell"),VText.CENTER,20);
      
      private const shape:Shape = new Shape();
      
      private const skin:VSkin = SkinManager.getEmbed("SpellAreaBorder");
      
      private const unitList:Vector.<Unit> = new Vector.<Unit>();
      
      private var x:int;
      
      private var y:int;
      
      private var area:int;
      
      public function DropSpellStep(param1:int, param2:int, param3:Number = 0, param4:Number = 0, param5:int = 2)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.area = param5;
         this.skin.geometryPhase();
         this.text.geometryPhase();
         this.text.x = param3;
         this.text.y = param4;
      }
      
      override public function run() : void
      {
         var _loc2_:Point = null;
         var _loc6_:MapCell = null;
         var _loc1_:VOBattleItem = Facade.battleMediator.selectItem;
         if(!_loc1_ || !_loc1_.spellShop)
         {
            return;
         }
         Facade.battleMediator.dropPanel.mouseLock = true;
         this.board.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,10000);
         this.bm.smoothMoveBoard(this.x,this.y);
         this.board.effectPanel.addChild(this.learnSkin);
         _loc2_ = new Point();
         Isometric.posToScreen(this.x,this.y,_loc2_);
         this.learnSkin.x = _loc2_.x;
         this.learnSkin.y = _loc2_.y - 30;
         this.learnSkin.geometryPhase();
         var _loc3_:int = Facade.boardMediator.spellRadius;
         var _loc4_:Number = Isometric.POS_WORLD_SIZE * (_loc3_ * 2 + 1.4);
         var _loc5_:Number = _loc4_ * 0.7071;
         this.shape.graphics.beginFill(16295716,0.5);
         this.shape.graphics.drawEllipse(-_loc4_ / 2,-_loc5_ / 2,_loc4_,_loc5_);
         Facade.board.tilePanel.addChild(this.shape);
         this.skin.width = _loc4_;
         this.skin.height = _loc5_;
         Facade.board.tilePanel.addChild(this.skin);
         this.skin.x = this.shape.x = _loc2_.x;
         this.skin.y = this.shape.y = _loc2_.y;
         Facade.board.addChild(this.text);
         this.text.x = Math.round(_loc2_.x + this.text.x);
         this.text.y = Math.round(_loc2_.y - this.text.y);
         for each(_loc6_ in BoardLogic.getRadiusPositionList(this.x,this.y,1,_loc3_))
         {
            if(Boolean(_loc6_.unit) && (Boolean(_loc6_.unit is Build || _loc6_.unit is Cannon)) && this.unitList.indexOf(_loc6_.unit) < 0)
            {
               this.unitList.push(_loc6_.unit);
               _loc6_.unit.display.addFilter(Style.CONFLICT_FILTER);
            }
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:Unit = null;
         this.board.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
         this.learnSkin.removeFromParent();
         Facade.battleMediator.dropPanel.mouseLock = false;
         if(this.shape.parent)
         {
            this.shape.parent.removeChild(this.shape);
         }
         this.skin.removeFromParent();
         this.text.removeFromParent();
         for each(_loc1_ in this.unitList)
         {
            _loc1_.display.removeFilter(Style.CONFLICT_FILTER);
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
            Facade.battleMediator.dropSpell(_loc2_);
            end();
         }
         else
         {
            Facade.mainMediator.flightMessage(Lang.getString("bad_train_spell"));
            this.bm.smoothMoveBoard(this.x,this.y);
            if(!Facade.checkUserStage("m1_fireball_use1"))
            {
               Facade.changeUserStage("m1_fireball_use1");
               Facade.fact(22);
            }
         }
      }
   }
}

