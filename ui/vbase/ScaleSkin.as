package ui.vbase
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class ScaleSkin extends MovieClip
   {
      
      private var bitmapTL:DisplayObject;
      
      private var bitmapTC:DisplayObject;
      
      private var bitmapTR:DisplayObject;
      
      private var bitmapML:DisplayObject;
      
      private var bitmapMC:DisplayObject;
      
      private var bitmapMR:DisplayObject;
      
      private var bitmapBL:DisplayObject;
      
      private var bitmapBC:DisplayObject;
      
      private var bitmapBR:DisplayObject;
      
      public var master:DisplayObject;
      
      public function ScaleSkin(param1:DisplayObject)
      {
         super();
         mouseChildren = false;
         this.master = param1;
         this.update();
      }
      
      public static function create(param1:DisplayObject) : DisplayObject
      {
         return param1 is Sprite && (param1 as Sprite).scale9Grid != null ? new ScaleSkin(param1) : param1;
      }
      
      private static function slice(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number) : DisplayObject
      {
         var _loc6_:BitmapData = new BitmapData(Math.ceil(param4),Math.ceil(param5),true,0);
         var _loc7_:Matrix = new Matrix();
         _loc7_.translate(-param2,-param3);
         _loc6_.draw(param1,_loc7_);
         var _loc8_:Sprite = new Sprite();
         _loc8_.graphics.beginBitmapFill(_loc6_,null,false,true);
         _loc8_.graphics.drawRect(0,0,_loc6_.width,_loc6_.height);
         _loc8_.graphics.endFill();
         _loc8_.x = param2;
         _loc8_.y = param3;
         return _loc8_;
      }
      
      override public function gotoAndStop(param1:Object, param2:String = null) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this.master is MovieClip)
         {
            _loc3_ = this.master as MovieClip;
            _loc4_ = _loc3_.currentFrame;
            _loc3_.gotoAndStop(param1);
            if(_loc4_ != _loc3_.currentFrame)
            {
               _loc5_ = width;
               _loc6_ = height;
               this.update();
               this.width = _loc5_;
               this.height = _loc6_;
            }
         }
      }
      
      public function update() : void
      {
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         var _loc1_:Rectangle = this.master.scale9Grid;
         this.bitmapTL = addChild(slice(this.master,0,0,_loc1_.x,_loc1_.y));
         this.bitmapTC = addChild(slice(this.master,_loc1_.x,0,_loc1_.width,_loc1_.y));
         this.bitmapTR = addChild(slice(this.master,_loc1_.right,0,this.master.width - _loc1_.right,_loc1_.y));
         this.bitmapML = addChild(slice(this.master,0,_loc1_.y,_loc1_.x,_loc1_.height));
         this.bitmapMC = addChild(slice(this.master,_loc1_.x,_loc1_.y,_loc1_.width,_loc1_.height));
         this.bitmapMR = addChild(slice(this.master,_loc1_.right,_loc1_.y,this.bitmapTR.width,_loc1_.height));
         this.bitmapBL = addChild(slice(this.master,0,_loc1_.bottom,_loc1_.x,this.master.height - _loc1_.bottom));
         this.bitmapBC = addChild(slice(this.master,_loc1_.x,_loc1_.bottom,_loc1_.width,this.bitmapBL.height));
         this.bitmapBR = addChild(slice(this.master,_loc1_.right,_loc1_.bottom,this.bitmapTR.width,this.bitmapBL.height));
      }
      
      override public function set width(param1:Number) : void
      {
         var _loc2_:Number = param1 - this.bitmapTL.width - this.bitmapTR.width;
         var _loc3_:Number = param1 - this.bitmapTR.width;
         this.bitmapTC.width = _loc2_;
         this.bitmapMC.width = _loc2_;
         this.bitmapBC.width = _loc2_;
         this.bitmapTR.x = _loc3_;
         this.bitmapMR.x = _loc3_;
         this.bitmapBR.x = _loc3_;
      }
      
      override public function set height(param1:Number) : void
      {
         var _loc2_:Number = param1 - this.bitmapTL.height - this.bitmapBL.height;
         var _loc3_:Number = param1 - this.bitmapBL.height;
         this.bitmapML.height = _loc2_;
         this.bitmapMC.height = _loc2_;
         this.bitmapMR.height = _loc2_;
         this.bitmapBL.y = _loc3_;
         this.bitmapBC.y = _loc3_;
         this.bitmapBR.y = _loc3_;
      }
   }
}

