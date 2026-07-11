package engine.units
{
   import engine.Isometric;
   import engine.display.AnimClip;
   import engine.display.AnimDisplay;
   import engine.display.Animation;
   import engine.signal.Tween;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import model.ResourceProxy;
   
   public class RadiusUnit extends Unit
   {
      
      public var updateLevel:uint;
      
      public var updateMax:uint;
      
      private var radiusShape:Shape;
      
      public function RadiusUnit()
      {
         super();
      }
      
      public static function drawRadius(param1:Graphics, param2:uint, param3:uint, param4:uint, param5:uint = 0) : void
      {
         param1.clear();
         var _loc6_:Number = (param2 & 1) == 0 ? 1 : 0.5;
         var _loc7_:Number = Isometric.POS_WORLD_SIZE * (param3 + _loc6_);
         var _loc8_:Number = _loc7_ * 2;
         var _loc9_:Matrix = new Matrix();
         _loc9_.createGradientBox(_loc8_,_loc8_,0,-_loc7_,-_loc7_);
         if(param4 == 0)
         {
            param1.beginGradientFill(GradientType.RADIAL,[2756621,6305550,9394707,11958041,13995294,15441185,16295716,16558628,16557348,16355876,16288549,16288549,16289575,16289575,16572282,16711327],[0,0.176,0.333,0.467,0.569,0.639,0.682,0.486,0.682,0.62,0.42,0.129,0.184,0,0.122,0.25],[16,28,39,51,63,74,84,94,101,133,156,220,222,222,253,253],_loc9_);
         }
         else
         {
            param1.beginGradientFill(GradientType.RADIAL,[param4,param4],[0,0.4],[200,255],_loc9_);
         }
         param1.drawCircle(0,0,_loc7_);
         if(param5 > 0)
         {
            _loc7_ = Isometric.POS_WORLD_SIZE * (param5 + _loc6_);
            param4 = 16711680;
            _loc8_ = _loc7_ * 2;
            _loc9_.createGradientBox(_loc8_,_loc8_,0,-_loc7_,-_loc7_);
            param1.beginGradientFill(GradientType.RADIAL,[param4,param4],[0,0.6],[210,255],_loc9_);
            param1.drawCircle(0,0,_loc7_);
         }
      }
      
      public static function getTileName(param1:uint, param2:uint, param3:uint) : String
      {
         var _loc4_:Number = param1 / param2;
         if(_loc4_ <= 0.33)
         {
            _loc4_ = 1;
         }
         else if(_loc4_ >= 0.68)
         {
            _loc4_ = 3;
         }
         else
         {
            _loc4_ = 2;
         }
         return "type" + param3 + _loc4_;
      }
      
      public function showRadius(param1:uint, param2:uint, param3:uint = 0) : void
      {
         this.hideRadius();
         if(param1 >= 15)
         {
            return;
         }
         this.radiusShape = new Shape();
         Tween.createRef(this.radiusShape).play(["scaleX",0,1,"scaleY",0,0.7071],0.25,Tween.backOut);
         board.tilePanel.addChild(this.radiusShape);
         this.syncRadiusLocation();
         drawRadius(this.radiusShape.graphics,size,param1,param2,param3);
      }
      
      public function hideRadius() : void
      {
         if(this.radiusShape)
         {
            Tween.stopRef(this.radiusShape);
            if(this.radiusShape.parent)
            {
               this.radiusShape.parent.removeChild(this.radiusShape);
            }
            this.radiusShape = null;
         }
      }
      
      public function get isRadius() : Boolean
      {
         return this.radiusShape != null;
      }
      
      public function useTopRadius() : void
      {
         if(this.radiusShape)
         {
            board.tilePanel.addChild(this.radiusShape);
         }
      }
      
      override public function move(param1:int, param2:int) : void
      {
         super.move(param1,param2);
         if(this.radiusShape)
         {
            this.syncRadiusLocation();
         }
      }
      
      private function syncRadiusLocation() : void
      {
         this.radiusShape.x = display.x;
         this.radiusShape.y = display.y - Isometric.POS_HALF_HEIGHT * (size - 1);
      }
      
      override public function dispose() : void
      {
         this.hideRadius();
         super.dispose();
      }
      
      public function changeTile(param1:String, param2:String) : void
      {
         var _loc3_:AnimClip = display.getClip("tile");
         if(!_loc3_)
         {
            _loc3_ = display.addNew("tile",AnimDisplay.OUTSIDE);
            if(display.parent)
            {
               this.addTileClip(_loc3_);
            }
         }
         param1 += "_t";
         if(animHash.hasOwnProperty(param1))
         {
            _loc3_.go(animHash[param1] as Animation);
         }
         else
         {
            _loc3_.go(AnimClip.resourceProxy.getAnimation(param2,getTileName(level,this.updateMax,size)));
         }
      }
      
      override public function onToBoard(param1:Boolean) : void
      {
         var _loc2_:AnimClip = display.getClip("tile");
         if(_loc2_)
         {
            if(param1)
            {
               this.addTileClip(_loc2_);
            }
            else
            {
               _loc2_.removeFromParent();
            }
         }
      }
      
      private function addTileClip(param1:AnimClip) : void
      {
         board.tilePanel.addChildAt(param1,0);
      }
      
      public function setUpdateLevel(param1:uint) : void
      {
         this.updateLevel = param1;
         if(display.parent)
         {
            this.scaffolding(param1 > 0);
            stand();
         }
         else if(param1 == 0)
         {
            this.scaffolding(false);
         }
      }
      
      public function scaffolding(param1:Boolean) : void
      {
         var _loc4_:ResourceProxy = null;
         var _loc2_:String = "scaff_f";
         var _loc3_:String = "scaff_b";
         if(param1 != Boolean(display.getClip(_loc2_)))
         {
            if(param1)
            {
               _loc4_ = AnimClip.resourceProxy;
               display.addNew(_loc2_).go(_loc4_.getAnimation("scaffolding","type" + size + "_f"));
               display.addNew(_loc2_ + "_sh",AnimDisplay.INSIDE,0).go(_loc4_.getAnimation("scaffolding","type" + size + "_f_sh"));
               display.addNew(_loc3_,AnimDisplay.SCENE,0).go(_loc4_.getAnimation("scaffolding","type" + size + "_b"));
               display.addNew(_loc3_ + "_sh",AnimDisplay.INSIDE,0).play(_loc4_.getAnimation("scaffolding","type" + size + "_b_sh"));
            }
            else
            {
               display.removeByName(_loc2_);
               display.removeByName(_loc2_ + "_sh");
               display.removeByName(_loc3_);
               display.removeByName(_loc3_ + "_sh");
            }
         }
      }
   }
}

