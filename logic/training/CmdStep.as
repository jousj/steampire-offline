package logic.training
{
   import ESkins.GreenLandingPos;
   import engine.Isometric;
   import engine.Map;
   import engine.Position;
   import engine.data.MapCell;
   import engine.units.Unit;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.battle.drop.DropPanel;
   import logic.ErrorLogic;
   import model.CommonEvent;
   import model.ui.VOBattleItem;
   import ui.Style;
   
   public class CmdStep extends AbstractTrainStep
   {
      
      public var fact:uint;
      
      public var isForceEnd:Boolean;
      
      private var area:uint = 1;
      
      private var cmdAPos:Position;
      
      private var cmdBPos:Position;
      
      private var movePos:Position;
      
      private var trainClip:ClickCmdClip;
      
      private var targetId:uint;
      
      private var landingSprite:Sprite;
      
      private var m_vector_click:String;
      
      private var isResetLock:Boolean;
      
      private var visibleLock:Boolean;
      
      public function CmdStep(param1:Position, param2:Position, param3:String = null, param4:Position = null, param5:Boolean = true, param6:Boolean = true)
      {
         super();
         this.cmdAPos = param1;
         this.cmdBPos = param2;
         this.visibleLock = param6;
         this.movePos = param4;
         this.m_vector_click = param3;
         this.isResetLock = param5;
      }
      
      private function btLock(param1:Boolean) : void
      {
         var _loc2_:DropPanel = Facade.battleMediator.dropPanel;
         if(this.visibleLock && Boolean(_loc2_.selectPanel))
         {
            _loc2_.selectPanel.boxVisible(!param1);
         }
         _loc2_.mouseLock = param1;
      }
      
      override public function run() : void
      {
         var _loc4_:Point = null;
         var _loc1_:VOBattleItem = Facade.battleMediator.selectItem;
         if(!_loc1_ || !_loc1_.shop)
         {
            return;
         }
         var _loc2_:MapCell = Facade.map.getMapCell(this.cmdAPos.x,this.cmdAPos.y);
         if(_loc2_.unit)
         {
            ErrorLogic.sendError("CmdStep pos=" + this.cmdAPos + " unit=" + _loc2_.unit);
            return;
         }
         this.filterLanding(this.cmdAPos);
         this.btLock(true);
         Facade.boardMediator.isBattleOutside = false;
         if(this.movePos)
         {
            Facade.boardMediator.smoothMoveBoard(this.movePos.x,this.movePos.y);
            this.movePos = null;
         }
         var _loc3_:Point = new Point();
         Isometric.posToScreen(this.cmdAPos.x,this.cmdAPos.y,_loc3_);
         _loc4_ = new Point();
         Isometric.posToScreen(this.cmdBPos.x,this.cmdBPos.y,_loc4_);
         _loc2_ = Facade.map.getSafeMapCell(this.cmdBPos.x,this.cmdBPos.y);
         if(Boolean(_loc2_) && Boolean(_loc2_.unit))
         {
            this.targetId = _loc2_.unit.id;
            _loc2_.unit.display.addFilter(Style.SELECT_FILTER,true);
         }
         this.landingSprite = new GreenLandingPos();
         this.landingSprite.scaleX = this.landingSprite.scaleY = 2;
         this.landingSprite.x = _loc3_.x;
         this.landingSprite.y = _loc3_.y;
         Facade.board.addChild(this.landingSprite);
         this.trainClip = new ClickCmdClip();
         this.trainClip.playCmd(_loc3_.x,_loc3_.y,_loc4_.x,_loc4_.y,1.5,Facade.board.addDirectionShape());
         Facade.board.addChild(this.trainClip);
         Facade.board.addEventListener(MouseEvent.MOUSE_DOWN,this.onStartCmd);
      }
      
      override public function dispose() : void
      {
         var _loc1_:Unit = null;
         if(this.targetId > 0)
         {
            _loc1_ = Facade.userProxy.constructionHash[this.targetId];
            if(_loc1_)
            {
               _loc1_.display.removeFilter(Style.SELECT_FILTER);
            }
         }
         this.onReset(false);
         this.filterLanding(this.cmdAPos,false);
         if(this.isResetLock)
         {
            this.btLock(false);
         }
      }
      
      private function filterLanding(param1:Position, param2:Boolean = true) : void
      {
         var _loc5_:int = 0;
         var _loc6_:MapCell = null;
         var _loc3_:Map = Facade.map;
         _loc3_.setGlobalLanding(!param2);
         var _loc4_:int = -this.area;
         while(_loc4_ <= this.area)
         {
            _loc5_ = -this.area;
            while(_loc5_ <= this.area)
            {
               _loc6_ = _loc3_.getSafeMapCell(param1.x + _loc4_,param1.y + _loc5_);
               if(_loc6_)
               {
                  _loc6_.landing = param2;
               }
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      private function checkPos(param1:Position, param2:Position) : Boolean
      {
         var _loc3_:int = param1.x;
         var _loc4_:int = param1.y;
         return param2.x >= _loc3_ - this.area && param2.x <= _loc3_ + this.area && param2.y >= _loc4_ - this.area && param2.y <= _loc4_ + this.area;
      }
      
      public function setArea(param1:uint) : CmdStep
      {
         this.area = param1;
         return this;
      }
      
      private function onStartCmd(param1:MouseEvent) : void
      {
         var _loc4_:Point = null;
         var _loc2_:Point = Facade.board.globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc3_:Position = new Position();
         Isometric.screenToPos(_loc2_.x,_loc2_.y,_loc3_);
         if(this.checkPos(this.cmdAPos,_loc3_))
         {
            if(this.m_vector_click)
            {
               Facade.changeUserStage(this.m_vector_click);
               this.m_vector_click = null;
            }
            Facade.board.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStartCmd);
            this.trainClip.stopCmd();
            _loc4_ = new Point();
            Isometric.posToScreen(this.cmdBPos.x,this.cmdBPos.y,_loc4_);
            this.trainClip.x = _loc4_.x;
            this.trainClip.y = _loc4_.y;
            this.trainClip.playClick();
            Facade.board.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,1);
            Facade.addListener(CommonEvent.BOARD_RESET_DOWN,this.onReset);
         }
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Unit = null;
         var _loc2_:Point = Facade.board.globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc3_:Position = new Position();
         Isometric.screenToPos(_loc2_.x,_loc2_.y,_loc3_);
         if(this.targetId > 0)
         {
            for each(_loc5_ in Facade.boardMediator.battleDrop.attackList)
            {
               if(_loc5_.id == this.targetId)
               {
                  _loc4_ = true;
                  break;
               }
            }
         }
         if(!_loc4_)
         {
            _loc4_ = this.checkPos(this.cmdBPos,_loc3_);
         }
         if(Facade.battleMediator.selectItem)
         {
         }
         if((_loc4_ || this.isForceEnd) && Boolean(Facade.battleMediator.selectItem))
         {
            if(this.fact > 0)
            {
               Facade.fact(this.fact);
            }
            Isometric.posToScreen(this.cmdBPos.x,this.cmdBPos.y,_loc2_);
            Facade.boardMediator.battleDrop.a_pos = this.cmdAPos;
            Facade.boardMediator.battleDrop.up(_loc2_);
            this.onReset(false);
            end();
         }
         else
         {
            if(this.fact > 0)
            {
               if(this.cmdAPos.equal_p(_loc3_))
               {
                  ++this.fact;
               }
               else
               {
                  this.fact += 3;
                  for each(_loc5_ in Facade.boardMediator.battleDrop.attackList)
                  {
                     if(_loc5_.kind == "cn_cannon")
                     {
                        --this.fact;
                        break;
                     }
                  }
               }
               Facade.fact(this.fact);
               this.fact = 0;
            }
            Facade.mainMediator.flightMessage(Lang.getString("bad_train_vector"));
            this.onReset(true);
         }
         Facade.boardMediator.resetDown();
      }
      
      private function onReset(param1:Object) : void
      {
         var _loc2_:Boolean = Boolean(param1);
         if(this.trainClip)
         {
            Facade.board.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStartCmd);
            Facade.board.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            Facade.removeListener(CommonEvent.BOARD_RESET_DOWN,this.onReset);
            if(_loc2_)
            {
               this.trainClip.replayCmd(Facade.board.addDirectionShape());
               Facade.board.addEventListener(MouseEvent.MOUSE_DOWN,this.onStartCmd);
            }
            else
            {
               Facade.boardMediator.isBattleOutside = true;
               this.trainClip.dispose();
               this.trainClip = null;
               this.landingSprite.parent.removeChild(this.landingSprite);
               this.landingSprite = null;
            }
         }
      }
   }
}

