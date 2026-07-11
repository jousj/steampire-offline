package logic.battle
{
   import ESkins.RedLandingPos;
   import engine.Board;
   import engine.Isometric;
   import engine.Map;
   import engine.Position;
   import engine.data.MapCell;
   import engine.signal.Tween;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Garbage;
   import engine.units.Unit;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import logic.BoardLogic;
   import logic.ErrorLogic;
   import model.calc.VectorCalc;
   import proto.model.spell.PEffect;
   import ui.Style;
   import utils.CommonUtils;
   
   public class BattleBoardDrop
   {
      
      private static var matrix:Matrix;
      
      private static var out1:Point;
      
      private static var out2:Point;
      
      private static var out3:Point;
      
      private static var out4:Point;
      
      private static var pC:Point;
      
      public var attackList:Vector.<Unit>;
      
      public var vectorNum:uint;
      
      public var p_screen_a:Point;
      
      public var a_pos:Position;
      
      public var s_pos:Position;
      
      public var b_pos:Position;
      
      public var vectorG:Graphics;
      
      public var cancelSkin:RedLandingPos;
      
      public function BattleBoardDrop(param1:Graphics)
      {
         super();
         this.vectorG = param1;
      }
      
      private static function initVariables() : void
      {
         matrix = new Matrix();
         out1 = new Point();
         out2 = new Point();
         out3 = new Point();
         out4 = new Point();
         pC = new Point();
      }
      
      public static function drawVector(param1:Graphics, param2:Point, param3:Point, param4:uint = 0) : void
      {
         if(!matrix)
         {
            initVariables();
         }
         param1.clear();
         var _loc5_:Number = CommonUtils.calcAngle(param2.x,param2.y,param3.x,param3.y);
         _loc5_ = _loc5_ + 90;
         if(_loc5_ >= 360)
         {
            _loc5_ -= 360;
         }
         var _loc6_:Number = 85;
         getPerpendicularPoints(param3,param2,_loc6_,out1,out2);
         getPerpendicularPoints(param2,param3,_loc6_,out3,out4);
         _loc6_ = Math.min(out1.x,out2.x,out3.x,out4.x);
         var _loc7_:Number = Math.min(out1.y,out2.y,out3.y,out4.y);
         matrix.createGradientBox(Math.max(out1.x,out2.x,out3.x,out4.x) - _loc6_,Math.max(out1.y,out2.y,out3.y,out4.y) - _loc7_,_loc5_ * Math.PI / 180,_loc6_,_loc7_);
         param1.lineStyle(1.5,16312488,0.7);
         if(Facade.isNormalQuality)
         {
            if(param4 == 0)
            {
               param1.beginGradientFill(GradientType.LINEAR,[16444729,13286690,10931490],[0.6,0.6,0.6],[0,128,255],matrix);
            }
            else if(param4 == 1)
            {
               param1.beginGradientFill(GradientType.LINEAR,[3713502,3289999],[0.537,0.478],[0,255],matrix);
            }
            else if(param4 == 2)
            {
               param1.beginGradientFill(GradientType.LINEAR,[16444729,15897134],[0.42,0.6],[0,253],matrix);
            }
            else if(param4 == 3)
            {
               param1.beginGradientFill(GradientType.LINEAR,[14212918,616248],[0.6,0.6],[0,255],matrix);
            }
            else if(param4 == 4)
            {
               param1.beginGradientFill(GradientType.LINEAR,[16550190,12263729],[0.6,0.6],[3,255],matrix);
            }
            else
            {
               param1.beginGradientFill(GradientType.LINEAR,[15856370,8422021],[0.478,0.6],[0,254],matrix);
            }
         }
         else if(param4 == 0)
         {
            param1.beginFill(13286690,0.6);
         }
         else if(param4 == 1)
         {
            param1.beginFill(3567800,0.5);
         }
         else if(param4 == 2)
         {
            param1.beginFill(16237108,0.5);
         }
         else if(param4 == 3)
         {
            param1.beginFill(7316023,0.6);
         }
         else if(param4 == 4)
         {
            param1.beginFill(14505775,0.6);
         }
         else
         {
            param1.beginFill(11843256,0.55);
         }
         param1.moveTo(param3.x,param3.y);
         _loc7_ = Point.distance(param2,param3);
         if(_loc7_ > 75)
         {
            _loc6_ = 20 / _loc7_;
            pC.x = param3.x + (param2.x - param3.x) * _loc6_;
            pC.y = param3.y + (param2.y - param3.y) * _loc6_;
            getPerpendicularPoints(param2,pC,25,out3,out4);
            param1.lineTo(out3.x,out3.y);
         }
         param1.lineTo(out1.x,out1.y);
         if(_loc7_ > 45)
         {
            _loc6_ = 20 / _loc7_;
            param1.lineTo(param2.x + (param3.x - param2.x) * _loc6_,param2.y + (param3.y - param2.y) * _loc6_);
         }
         param1.lineTo(out2.x,out2.y);
         if(_loc7_ > 75)
         {
            param1.lineTo(out4.x,out4.y);
         }
         param1.lineTo(param3.x,param3.y);
         param1.endFill();
      }
      
      public static function getPerpendicularPoints(param1:Point, param2:Point, param3:Number, param4:Point, param5:Point) : void
      {
         if(param1.y == param2.y)
         {
            param5.x = param4.x = param2.x;
            param4.y = param2.y + param3;
            param5.y = param2.y - param3;
            return;
         }
         var _loc6_:Number = -(param2.x - param1.x) / (param2.y - param1.y);
         var _loc7_:Number = 1 + _loc6_ * _loc6_;
         var _loc8_:Number = param3 * param3 - param2.x * param2.x - param2.y * param2.y;
         var _loc9_:Number = 2 * param2.x;
         var _loc10_:Number = 2 * param2.y;
         var _loc11_:Number = param2.y - _loc6_ * param2.x;
         var _loc12_:Number = 2 * _loc6_ * _loc11_ - _loc9_ - _loc10_ * _loc6_;
         var _loc13_:Number = _loc11_ * _loc11_ - _loc10_ * _loc11_ - _loc8_;
         _loc13_ = Math.sqrt(_loc12_ * _loc12_ - 4 * _loc7_ * _loc13_);
         var _loc14_:Number = (-_loc12_ + _loc13_) / (2 * _loc7_);
         param5.x = _loc14_;
         param5.y = _loc6_ * _loc14_ + _loc11_;
         _loc14_ = (-_loc12_ - _loc13_) / (2 * _loc7_);
         param4.x = _loc14_;
         param4.y = _loc6_ * _loc14_ + _loc11_;
      }
      
      public function down(param1:MapCell, param2:Position, param3:Board) : Boolean
      {
         if(!param1)
         {
            param1 = Facade.map.getCorrectMapCell(param2.x,param2.y);
         }
         if(param1)
         {
            if(param1.unit)
            {
               if(!this.searchBorderCell(param1.unit,param2))
               {
                  return false;
               }
            }
            this.startMove(param2.x,param2.y);
            this.s_pos.x = param1.x;
            this.s_pos.y = param1.y;
         }
         this.cancelSkin = new RedLandingPos();
         param3.addChild(this.cancelSkin);
         this.cancelSkin.x = this.p_screen_a.x;
         this.cancelSkin.y = this.p_screen_a.y;
         return true;
      }
      
      private function startMove(param1:int, param2:int) : void
      {
         if(!this.s_pos)
         {
            this.s_pos = new Position();
            this.a_pos = new Position();
            this.b_pos = new Position();
            this.p_screen_a = new Point();
         }
         this.a_pos.x = param1;
         this.a_pos.y = param2;
         Isometric.posToScreen(param1,param2,this.p_screen_a);
      }
      
      private function searchBorderCell(param1:Unit, param2:Position) : Boolean
      {
         var _loc8_:MapCell = null;
         var _loc11_:* = 0;
         var _loc12_:MapCell = null;
         var _loc13_:uint = 0;
         var _loc3_:Map = Facade.map;
         var _loc4_:int = param1.t_x - 1;
         var _loc5_:int = param1.t_y - 1;
         var _loc6_:int = param1.b_x + 1;
         var _loc7_:int = param1.b_y + 1;
         var _loc9_:uint = uint.MAX_VALUE;
         var _loc10_:* = _loc6_;
         while(_loc10_ >= _loc4_)
         {
            _loc11_ = _loc7_;
            while(_loc11_ >= _loc5_)
            {
               if(_loc10_ == _loc4_ || _loc10_ == _loc6_ || _loc11_ == _loc5_ || _loc11_ == _loc7_)
               {
                  _loc12_ = _loc3_.getSafeMapCell(_loc10_,_loc11_);
                  if((Boolean(_loc12_)) && Boolean(_loc12_.landing) && !_loc12_.unit)
                  {
                     _loc13_ = Math.abs(param2.x - _loc10_) + Math.abs(param2.y - _loc11_);
                     if(_loc13_ < _loc9_)
                     {
                        _loc8_ = _loc12_;
                        _loc9_ = _loc13_;
                     }
                  }
               }
               _loc11_--;
            }
            _loc10_--;
         }
         if(_loc8_)
         {
            param2.x = _loc8_.x;
            param2.y = _loc8_.y;
            return true;
         }
         Facade.mainMediator.flightMessage(Lang.getString("bad_vector"));
         return false;
      }
      
      public function move(param1:Point) : void
      {
         var _loc2_:Position = new Position();
         Isometric.screenToPos(param1.x,param1.y,_loc2_);
         this.checkBPos(_loc2_);
         this.hideAttackConstruction();
         if(!this.a_pos.equal_p(_loc2_) && !this.s_pos.equal_p(_loc2_))
         {
            drawVector(this.vectorG,this.p_screen_a,param1,this.vectorNum);
            this.showAttackConstruction(this.a_pos,_loc2_);
         }
         else
         {
            this.vectorG.clear();
         }
      }
      
      private function hideAttackConstruction() : void
      {
         var _loc1_:Unit = null;
         for each(_loc1_ in this.attackList)
         {
            _loc1_.display.removeFilter(Style.CHOICE_FILTER);
         }
         this.attackList = null;
      }
      
      private function addAttackConstruction(param1:MapCell, param2:Boolean = true, param3:Boolean = false) : void
      {
         if(Boolean(param1.unit) && (param1.unit is Cannon || param1.unit is Build && param2))
         {
            if(!this.attackList)
            {
               this.attackList = new Vector.<Unit>();
            }
            if(this.attackList.indexOf(param1.unit) < 0)
            {
               this.attackList.push(param1.unit);
               if(!param3)
               {
                  param1.unit.display.addFilter(Style.CHOICE_FILTER);
               }
            }
         }
      }
      
      private function showAttackConstruction(param1:Position, param2:Position) : void
      {
         var _loc4_:Point = null;
         var _loc3_:Map = Facade.map;
         for each(_loc4_ in new VectorCalc().getVectorList(param1,param2))
         {
            this.addAttackConstruction(_loc3_.getMapCell(_loc4_.x,_loc4_.y));
         }
      }
      
      private function checkBPos(param1:Position) : void
      {
         var _loc2_:Map = null;
         var _loc3_:MapCell = null;
         var _loc4_:Vector.<MapCell> = null;
         var _loc5_:* = 0;
         if(!this.a_pos.equal_p(param1))
         {
            _loc2_ = Facade.map;
            _loc2_.checkVectorArea(this.a_pos,param1);
            _loc3_ = _loc2_.getSafeMapCell(param1.x,param1.y);
            if(Boolean(_loc3_) && _loc3_.walkFactor == 0)
            {
               _loc4_ = new Vector.<MapCell>();
               _loc2_.getBresenhamLine(this.a_pos.x,this.a_pos.y,param1.x,param1.y,_loc4_,false);
               _loc5_ = int(_loc4_.length - 1);
               while(_loc5_ >= 0)
               {
                  _loc3_ = _loc4_[_loc5_];
                  if(_loc3_.walkFactor != 0)
                  {
                     param1.x = _loc3_.x;
                     param1.y = _loc3_.y;
                     break;
                  }
                  _loc5_--;
               }
            }
         }
      }
      
      public function up(param1:Point) : void
      {
         var map:Map;
         var un:Unit = null;
         var p:Point = param1;
         Isometric.screenToPos(p.x,p.y,this.b_pos);
         map = Facade.map;
         if(!map.getSafeMapCell(this.a_pos.x,this.a_pos.y) && !map.getSafeMapCell(this.b_pos.x,this.b_pos.y))
         {
            if(!this.a_pos.equal_p(this.b_pos))
            {
               Facade.mainMediator.flightMessage(Lang.getString("bad_vector"));
            }
            return;
         }
         map.checkVectorArea(this.b_pos,this.a_pos);
         try
         {
            un = map.getMapCell(this.a_pos.x,this.a_pos.y).unit;
            if(Boolean(un) && !(un is Garbage))
            {
               Facade.mainMediator.flightMessage(Lang.getString("bad_vector"));
               return;
            }
         }
         catch(e:Error)
         {
            ErrorLogic.sendError("something wrong at get map cell " + a_pos.x + " " + a_pos.y + " " + Facade.isBattle + " " + Facade.battleMediator.train);
            throw e;
         }
         this.checkBPos(this.b_pos);
         if(!this.a_pos.equal_p(this.b_pos) && !this.s_pos.equal_p(this.b_pos))
         {
            this.tweenVector(this.p_screen_a,p,Facade.battleMediator.dropSoldier(this.a_pos.clone(),this.b_pos.clone()),this.vectorNum);
         }
      }
      
      public function tweenVector(param1:Point, param2:Point, param3:Boolean, param4:uint) : void
      {
         var _loc5_:Shape = Facade.board.addDirectionShape();
         drawVector(_loc5_.graphics,param1,param2,param4);
         var _loc6_:Tween = new Tween(_loc5_,this.tweenHandler,true);
         _loc6_.play(["alpha",1,0.3],1.2);
         _loc6_.data = param3;
      }
      
      private function tweenHandler(param1:Tween) : void
      {
         var _loc2_:Shape = null;
         if(param1.step == 1)
         {
            param1.wait(param1.data ? 4.7 : 1.7);
         }
         else if(param1.step == 2)
         {
            param1.play(["alpha",0.3,0],1.5);
         }
         else
         {
            _loc2_ = param1.target as Shape;
            if(_loc2_.parent)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         }
      }
      
      public function clear() : void
      {
         this.hideAttackConstruction();
         this.vectorG.clear();
         if(this.cancelSkin)
         {
            this.cancelSkin.parent.removeChild(this.cancelSkin);
            this.cancelSkin = null;
         }
         if(this.a_pos)
         {
            this.a_pos.x = int.MIN_VALUE;
         }
      }
      
      public function reset() : void
      {
         this.clear();
         if(this.a_pos)
         {
            this.s_pos = null;
            this.a_pos = null;
            this.b_pos = null;
            this.p_screen_a = null;
         }
         if(matrix)
         {
            matrix = null;
            out1 = null;
            out2 = null;
            out3 = null;
            out4 = null;
            pC = null;
         }
      }
      
      public function spellMove(param1:Point, param2:int, param3:uint, param4:Boolean) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:Boolean = false;
         var _loc9_:MapCell = null;
         if(!this.a_pos)
         {
            this.a_pos = new Position(int.MIN_VALUE);
            this.b_pos = new Position();
         }
         Isometric.screenToPos(param1.x,param1.y,this.b_pos);
         this.a_pos.x = this.b_pos.x;
         this.a_pos.y = this.b_pos.y;
         this.vectorG.clear();
         var _loc5_:Number = Isometric.POS_WORLD_SIZE * (param2 * 2 + 1.4);
         var _loc6_:Number = _loc5_ * 0.7071;
         if(!matrix)
         {
            initVariables();
         }
         else
         {
            matrix.identity();
         }
         switch(param3)
         {
            case PEffect.FIREBALL:
               _loc7_ = 16295716;
               break;
            case PEffect.CURE:
            case PEffect.WORKER:
               _loc7_ = 5093595;
               break;
            case PEffect.SHOCK:
               _loc7_ = 5363961;
               break;
            case PEffect.LOW_DAMAGE:
               _loc7_ = 8042677;
               break;
            case PEffect.MULTIFIREBALL:
               _loc7_ = 6082335;
               break;
            default:
               _loc7_ = 16777215;
         }
         matrix.createGradientBox(_loc5_,_loc6_,0,param1.x - _loc5_ / 2,param1.y - _loc6_ / 2);
         this.vectorG.beginGradientFill(GradientType.RADIAL,[_loc7_,_loc7_,_loc7_],[0,0.4,0.6],[70,200,255],matrix);
         this.vectorG.drawEllipse(param1.x - _loc5_ / 2,param1.y - _loc6_ / 2,_loc5_,_loc6_);
         if(param3 == PEffect.FIREBALL || param3 == PEffect.MULTIFIREBALL || param3 == PEffect.SHOCK || param3 == PEffect.WORKER)
         {
            this.hideAttackConstruction();
            _loc8_ = param3 != PEffect.SHOCK;
            for each(_loc9_ in BoardLogic.getRadiusPositionList(this.a_pos.x,this.a_pos.y,1,param2))
            {
               this.addAttackConstruction(_loc9_,_loc8_,param4);
            }
         }
      }
   }
}

