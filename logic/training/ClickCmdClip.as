package logic.training
{
   import ESkins.MouseDemo;
   import engine.signal.Signal;
   import engine.signal.Tween;
   import flash.display.Shape;
   import flash.geom.Point;
   import logic.battle.BattleBoardDrop;
   import ui.UIFactory;
   import ui.vbase.VText;
   
   public class ClickCmdClip extends MouseDemo
   {
      
      private var signal:Signal;
      
      private var shape:Shape;
      
      private var startPoint:Point;
      
      private const tween:Tween = new Tween(this);
      
      private const curPoint:Point = new Point();
      
      private const downText:VText = UIFactory.createYellowText(Lang.getString("cmd_down"),0,26);
      
      private const moveText:VText = UIFactory.createYellowText(Lang.getString("cmd_move"),0,26);
      
      private const upText:VText = UIFactory.createYellowText(Lang.getString("cmd_up"),0,26);
      
      public function ClickCmdClip()
      {
         super();
         mouseEnabled = mouseChildren = false;
         stop();
         this.downText.geometryPhase();
         this.moveText.geometryPhase();
         this.upText.geometryPhase();
         this.changeTextVisible(0);
         addChild(this.downText);
         addChild(this.moveText);
         addChild(this.upText);
         this.downText.x = this.moveText.x = this.upText.x = 34;
         this.downText.y = this.moveText.y = this.upText.y = -14;
      }
      
      private function changeTextVisible(param1:uint) : void
      {
         this.downText.visible = param1 == 1;
         this.moveText.visible = param1 == 2;
         this.upText.visible = param1 == 3;
      }
      
      private function clickFunc(param1:Tween) : void
      {
         gotoAndPlay(1);
         param1.wait(1.5);
      }
      
      public function playClick() : void
      {
         this.tween.completeFunc = this.clickFunc;
         this.clickFunc(this.tween);
      }
      
      public function playCmd(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Shape) : void
      {
         this.tween.completeFunc = this.cmdFunc;
         this.tween.propertyList = ["x",param1,param3,"y",param2,param4];
         this.tween.duration = param5;
         this.tween.easy = Tween.cubicOut;
         this.tween.step = 1;
         this.signal = new Signal(this.drawCmd);
         this.signal.delay = 0.03;
         this.shape = param6;
         this.startPoint = new Point(param1,param2);
         this.cmdFunc(this.tween);
      }
      
      public function stopCmd() : void
      {
         if(this.signal)
         {
            this.signal.stop();
         }
         if(this.shape)
         {
            if(this.shape.parent)
            {
               this.shape.parent.removeChild(this.shape);
            }
            this.shape = null;
         }
         this.tween.stop();
         this.changeTextVisible(2);
      }
      
      public function replayCmd(param1:Shape) : void
      {
         this.tween.completeFunc = this.cmdFunc;
         this.shape = param1;
         this.cmdFunc(this.tween);
      }
      
      private function cmdFunc(param1:Tween) : void
      {
         if(param1.step == 1)
         {
            this.shape.graphics.clear();
            param1.applyStartProperties();
            param1.wait(1);
            this.changeTextVisible(1);
            this.upText.visible = false;
            this.downText.visible = true;
         }
         else if(param1.step == 3)
         {
            param1.repeat();
            this.signal.run(param1.duration);
            this.changeTextVisible(2);
         }
         else if(param1.step == 2)
         {
            gotoAndPlay(21);
            param1.wait(0.5);
         }
         else
         {
            param1.step = 0;
            gotoAndPlay(31);
            param1.wait(0.8);
            this.changeTextVisible(3);
         }
      }
      
      private function drawCmd() : void
      {
         this.curPoint.x = x;
         this.curPoint.y = y;
         if(!this.curPoint.equals(this.startPoint))
         {
            BattleBoardDrop.drawVector(this.shape.graphics,this.startPoint,this.curPoint);
         }
      }
      
      public function dispose() : void
      {
         this.stopCmd();
         this.signal = null;
         stop();
         if(parent)
         {
            parent.removeChild(this);
         }
         this.downText.dispose();
         this.moveText.dispose();
         this.upText.dispose();
      }
   }
}

