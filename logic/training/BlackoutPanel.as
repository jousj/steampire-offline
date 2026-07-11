package logic.training
{
   import engine.signal.Signal;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.RectButton;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   
   public class BlackoutPanel extends VComponent
   {
      
      private const hole:Sprite = new Sprite();
      
      private var target:VComponent;
      
      private var signal:Signal;
      
      private var lx:Number = 0;
      
      private var ly:Number = 0;
      
      private var cx:Number;
      
      private var cy:Number;
      
      private var p:DisplayObject;
      
      private var arrowPanel:VComponent;
      
      public function BlackoutPanel()
      {
         super();
         mouseChildren = mouseEnabled = false;
         blendMode = BlendMode.LAYER;
         addStretch(new VFill(0,0.35));
         addChild(this.hole);
         this.hole.visible = false;
         this.hole.blendMode = BlendMode.ERASE;
      }
      
      public function track(param1:VComponent, param2:Boolean = false, param3:Number = NaN, param4:Object = null) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:VSkin = null;
         this.target = param1;
         if(param1 is CircleButton)
         {
            _loc6_ = param1.measuredWidth + 20;
         }
         else if(param1 is RectButton)
         {
            _loc6_ = param1.measuredWidth / 2 + 10;
         }
         else
         {
            _loc6_ = 50 + (param1.measuredWidth > param1.measuredHeight ? param1.measuredWidth / 2 : param1.measuredHeight / 2);
         }
         var _loc5_:Matrix = new Matrix();
         _loc5_.createGradientBox(_loc6_ * 2,_loc6_ * 2);
         this.hole.graphics.beginGradientFill(GradientType.RADIAL,[0,0],[1,0],[210,255],_loc5_);
         this.hole.graphics.drawCircle(_loc6_,_loc6_,_loc6_);
         this.hole.graphics.endFill();
         if(param2)
         {
            mouseChildren = true;
            this.hole.buttonMode = true;
         }
         if(!isNaN(param3))
         {
            this.arrowPanel = new VComponent();
            _loc7_ = UIFactory.createLearnArrow(param3,true);
            this.arrowPanel.add(_loc7_,param4);
            this.arrowPanel.visible = false;
            add(this.arrowPanel);
         }
         this.signal = new Signal(this.onSignal);
         this.signal.delay = 0.25;
         this.signal.run(0,Number.MAX_VALUE,isGeometryPhase);
      }
      
      private function onSignal() : void
      {
         if(Boolean(this.target.stage) && isGeometryPhase)
         {
            this.cx = 0;
            this.cy = 0;
            this.p = this.target;
            while(this.p)
            {
               if(this.p.scaleX != 1)
               {
                  this.cx *= this.p.scaleX;
               }
               if(this.p.scaleY != 1)
               {
                  this.cy *= this.p.scaleY;
               }
               this.cx += this.p.x;
               this.cy += this.p.y;
               this.p = this.p.parent;
            }
            if(this.cx != this.lx || this.cy != this.ly)
            {
               this.lx = this.cx;
               this.ly = this.cy;
               this.updateHolePos();
            }
         }
      }
      
      private function updateHolePos() : void
      {
         this.hole.x = Math.round(this.lx - (this.hole.width - this.target.w) / 2);
         this.hole.y = Math.round(this.ly - (this.hole.height - this.target.h) / 2);
         this.hole.visible = true;
         if(this.arrowPanel)
         {
            this.arrowPanel.visible = true;
            if(this.arrowPanel.w != this.target.w || this.arrowPanel.h != this.target.h)
            {
               this.arrowPanel.setGeometrySize(this.target.w,this.target.h,false);
            }
            this.arrowPanel.x = this.lx;
            this.arrowPanel.y = this.ly;
         }
      }
      
      override protected function customUpdate() : void
      {
         super.customUpdate();
         if(this.target)
         {
            this.onSignal();
         }
      }
      
      override public function dispose() : void
      {
         if(this.signal)
         {
            this.signal.stop();
         }
         super.dispose();
      }
   }
}

