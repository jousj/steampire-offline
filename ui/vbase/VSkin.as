package ui.vbase
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.PixelSnapping;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class VSkin extends VComponent
   {
      
      public static var defaultIconClass:Class;
      
      public static var loadClipFactory:Function;
      
      public static const NO_STRETCH:uint = 1;
      
      public static const CONTAIN:uint = 2;
      
      public static const STRETCH:uint = 4;
      
      public static const DRAW_FILL:uint = 8;
      
      public static const SPLIT_SCALE:uint = 16;
      
      public static const ZERO_CENTER:uint = 32;
      
      public static const CACHE_AS_BITMAP:uint = 64;
      
      public static const NO_SMOOTHING:uint = 128;
      
      public static const PLAY_MOVIE_CLIP:uint = 256;
      
      public static const ROTATE_90:uint = 512;
      
      public static const ROTATE_180:uint = 1024;
      
      public static const ROTATE_270:uint = 2048;
      
      public static const FLIP_X:uint = 4096;
      
      public static const FLIP_Y:uint = 8192;
      
      public static const TOP:uint = 16384;
      
      public static const LEFT:uint = 32768;
      
      public static const RIGHT:uint = 65536;
      
      public static const BOTTOM:uint = 131072;
      
      public static const EXTERNAL_EVENT:uint = 262144;
      
      public static const RANDOM_FRAME:uint = 524288;
      
      public static const STRETCH_BG:uint = STRETCH | SKIP_CONTENT_SIZE;
      
      public static const GREY_FILTER:Array = [new ColorMatrixFilter([0.4077399957180023,0.5484599471092224,0.0737999975681305,0,10,0.2777400016784668,0.6784599709510803,0.0737999975681305,0,10,0.2777400016784668,0.5484599471092224,0.303799991607666,0,10,0,0,0,1,0])];
      
      public static const CONTRAST_FILTER:Array = [new ColorMatrixFilter([1.28,0,0,0,-17.78,0,1.28,0,0,-17.78,0,0,1.28,0,-17.78,0,0,0,1,0])];
      
      private var view:DisplayObject;
      
      private var externalInfo:VOExternalInfo;
      
      private var $isContent:Boolean;
      
      public function VSkin(param1:uint = 0)
      {
         super();
         this.mode = param1;
         mouseEnabled = mouseChildren = false;
      }
      
      public static function controlMovieClipPlay(param1:DisplayObjectContainer, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:DisplayObject = null;
         if(param1 is MovieClip)
         {
            _loc5_ = param1 as MovieClip;
            if(param2)
            {
               _loc5_.play();
            }
            else if(_loc5_.totalFrames > 1)
            {
               if(param3)
               {
                  _loc5_.stop();
               }
               else
               {
                  _loc5_.gotoAndStop(0);
               }
            }
         }
         var _loc4_:* = int(param1.numChildren - 1);
         while(_loc4_ >= 0)
         {
            _loc6_ = param1.getChildAt(_loc4_);
            if(_loc6_ is DisplayObjectContainer)
            {
               controlMovieClipPlay(_loc6_ as DisplayObjectContainer,param2,param3);
            }
            _loc4_--;
         }
      }
      
      public static function center(param1:DisplayObject, param2:Object) : void
      {
         if(param2 is DisplayObject)
         {
            param2 = new Rectangle(param2.x,param2.y,param2.width,param2.height);
         }
         var _loc3_:Rectangle = param2 as Rectangle;
         if(_loc3_)
         {
            param1.x = Math.round(_loc3_.x + (_loc3_.width - param1.width) / 2);
            param1.y = Math.round(_loc3_.y + (_loc3_.height - param1.height) / 2);
         }
      }
      
      public static function contain(param1:DisplayObject, param2:Number, param3:Number, param4:Boolean = false) : void
      {
         if(param4 && param1.width <= param2 && param1.height <= param3)
         {
            return;
         }
         if(param2 / param3 <= param1.width / param1.height)
         {
            param1.width = param2;
            param1.scaleY = param1.scaleX;
         }
         else
         {
            param1.height = param3;
            param1.scaleX = param1.scaleY;
         }
      }
      
      public static function outside(param1:DisplayObject, param2:Number, param3:Number) : void
      {
         if(param2 / param3 <= param1.width / param1.height)
         {
            param1.height = param3;
            param1.scaleX = param1.scaleY;
         }
         else
         {
            param1.width = param2;
            param1.scaleY = param1.scaleX;
         }
      }
      
      public function useLoadClip() : void
      {
         var _loc1_:VComponent = null;
         if(!this.isContent)
         {
            this.clearContent();
            if(loadClipFactory != null)
            {
               _loc1_ = loadClipFactory();
               if(_loc1_)
               {
                  this.view = _loc1_;
                  addChild(this.view);
                  if(isGeometryPhase)
                  {
                     _loc1_.geometryPhase();
                  }
               }
            }
         }
      }
      
      public function useCustomLoadClip(param1:VComponent) : void
      {
         if(!this.isContent)
         {
            this.clearContent();
            this.view = param1;
         }
      }
      
      public function setMode(param1:uint, param2:Boolean = true) : void
      {
         mode = param1;
         if(param2)
         {
            syncContentSize(false);
         }
      }
      
      public function get content() : DisplayObject
      {
         return this.$isContent ? this.view : null;
      }
      
      public function get isContent() : Boolean
      {
         return this.$isContent;
      }
      
      override public function get measuredWidth() : uint
      {
         var _loc1_:uint = 0;
         if(layoutW > 0)
         {
            return applyRangeW(layoutW);
         }
         if(this.$isContent)
         {
            if((mode & NO_STRETCH) == 0 && (mode & STRETCH) == 0)
            {
               _loc1_ = calcAccurateW();
               if(_loc1_ > 0)
               {
                  return _loc1_;
               }
               _loc1_ = calcAccurateH();
               if(_loc1_ > 0 && contentH > 0)
               {
                  return applyRangeW(contentW * (_loc1_ / contentH));
               }
            }
         }
         return applyRangeW(contentW);
      }
      
      override public function get measuredHeight() : uint
      {
         var _loc1_:uint = 0;
         if(layoutH > 0)
         {
            return applyRangeH(layoutH);
         }
         if(this.$isContent)
         {
            if((mode & NO_STRETCH) == 0 && (mode & STRETCH) == 0)
            {
               _loc1_ = calcAccurateH();
               if(_loc1_ > 0)
               {
                  return _loc1_;
               }
               _loc1_ = calcAccurateW();
               if(_loc1_ > 0 && contentW > 0)
               {
                  return applyRangeH(contentH * (_loc1_ / contentW));
               }
            }
         }
         return applyRangeH(contentH);
      }
      
      public function resetContent() : void
      {
         this.setExternalInterest();
         this.clearContent();
         contentW = contentH = 0;
      }
      
      protected function clearContent() : void
      {
         this.$isContent = false;
         if(this.view)
         {
            this.view.parent.removeChild(this.view);
            if(this.view is VComponent)
            {
               (this.view as VComponent).dispose();
            }
            else if(this.view is DisplayObjectContainer)
            {
               controlMovieClipPlay(this.view as DisplayObjectContainer,false);
            }
            this.view = null;
         }
      }
      
      override public function dispose() : void
      {
         this.setExternalInterest();
         if(this.view is DisplayObjectContainer)
         {
            controlMovieClipPlay(this.view as DisplayObjectContainer,false);
         }
         super.dispose();
      }
      
      public function setExternalInterest(param1:VOExternalInfo = null) : void
      {
         if(this.externalInfo)
         {
            SkinManager.externalDispatcher.removeEventListener(this.externalInfo.packName,this.onExternal);
            this.externalInfo = null;
         }
         if(param1)
         {
            this.clearContent();
            this.externalInfo = param1;
            SkinManager.externalDispatcher.addEventListener(this.externalInfo.packName,this.onExternal);
         }
      }
      
      private function onExternal(param1:Event) : void
      {
         if(this.externalInfo)
         {
            this.applyContent(SkinManager.getCopyExternal(this.externalInfo.packName,this.externalInfo.skinName));
            if((mode & EXTERNAL_EVENT) != 0)
            {
               dispatchEvent(new VEvent(VEvent.EXTERNAL_COMPLETE,this.externalInfo));
            }
         }
      }
      
      public function applyContent(param1:Object) : void
      {
         var _loc3_:Boolean = false;
         this.setExternalInterest();
         this.clearContent();
         this.$isContent = true;
         if(param1)
         {
            _loc3_ = true;
            if(param1 is BitmapData)
            {
               param1 = new Bitmap(param1 as BitmapData,PixelSnapping.AUTO,(mode & NO_SMOOTHING) == 0);
               _loc3_ = false;
            }
            else if(param1 is MovieClip)
            {
               if((mode & RANDOM_FRAME) != 0)
               {
                  this.useRandomFrame(param1 as MovieClip);
               }
               if((mode & PLAY_MOVIE_CLIP) == 0 || (mode & SPLIT_SCALE) != 0)
               {
                  controlMovieClipPlay(param1 as MovieClip,false);
               }
               _loc3_ = false;
            }
            if((mode & SPLIT_SCALE) != 0 && param1.scale9Grid != null)
            {
               param1 = new ScaleSkin(param1 as DisplayObject);
               _loc3_ = false;
            }
            if(_loc3_ && (mode & CACHE_AS_BITMAP) != 0)
            {
               (param1 as DisplayObject).cacheAsBitmap = true;
            }
         }
         else if(defaultIconClass != null)
         {
            param1 = new defaultIconClass();
         }
         else
         {
            param1 = this.getDefaultContent();
         }
         this.view = addChildAt(param1 as DisplayObject,0);
         var _loc2_:Boolean = (mode & ROTATE_90) != 0 || (mode & ROTATE_270) != 0;
         contentW = Math.ceil(_loc2_ ? this.view.height : this.view.width);
         contentH = Math.ceil(_loc2_ ? this.view.width : this.view.height);
         syncContentSize(false);
      }
      
      private function useRandomFrame(param1:MovieClip) : void
      {
         if(param1.totalFrames > 1)
         {
            param1.gotoAndPlay(Math.round(Math.random() * param1.totalFrames));
         }
      }
      
      private function getDefaultContent() : Shape
      {
         var _loc1_:Shape = new Shape();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.beginFill(16711680);
         _loc2_.drawRect(0,0,50,50);
         _loc2_.beginFill(16777215);
         _loc2_.drawRect(1,1,48,48);
         _loc2_.beginFill(16711680);
         _loc2_.drawRect(0,0,2,2);
         _loc2_.drawRect(48,0,2,2);
         _loc2_.drawRect(0,48,2,2);
         _loc2_.drawRect(48,48,2,2);
         _loc2_.lineStyle(1,16711680);
         _loc2_.moveTo(2,2);
         _loc2_.lineTo(48,48);
         _loc2_.moveTo(48,2);
         _loc2_.lineTo(2,48);
         return _loc1_;
      }
      
      override protected function customUpdate() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if((mode & DRAW_FILL) != 0)
         {
            graphics.clear();
            graphics.beginFill(0,0);
            graphics.drawRect(0,0,w,h);
         }
         if(!this.view)
         {
            return;
         }
         if(this.$isContent)
         {
            this.view.transform.matrix = new Matrix();
            _loc1_ = (mode & ROTATE_90) != 0 || (mode & ROTATE_270) != 0;
            if(_loc1_)
            {
               _loc6_ = h;
               _loc7_ = w;
            }
            else
            {
               _loc6_ = w;
               _loc7_ = h;
            }
            if((mode & NO_STRETCH) == 0)
            {
               if((mode & STRETCH) != 0)
               {
                  this.view.width = _loc6_;
                  this.view.height = _loc7_;
               }
               else
               {
                  contain(this.view,_loc6_,_loc7_,(mode & CONTAIN) != 0);
               }
            }
            _loc2_ = 0;
            _loc3_ = 0;
            if((mode & ROTATE_90) != 0)
            {
               this.view.rotation = 90;
               _loc2_ = this.view.width;
            }
            else if((mode & ROTATE_180) != 0)
            {
               this.view.rotation = 180;
               _loc2_ = this.view.width;
               _loc3_ = this.view.height;
            }
            else if((mode & ROTATE_270) != 0)
            {
               this.view.rotation = 270;
               _loc3_ = this.view.height;
            }
            if((mode & FLIP_X) != 0)
            {
               if(_loc1_)
               {
                  _loc5_ = true;
               }
               else
               {
                  _loc4_ = true;
               }
               _loc2_ = _loc2_ == 0 ? this.view.width : 0;
            }
            if((mode & FLIP_Y) != 0)
            {
               if(_loc1_)
               {
                  _loc4_ = true;
               }
               else
               {
                  _loc5_ = true;
               }
               _loc3_ = _loc3_ == 0 ? this.view.height : 0;
            }
            if(_loc4_)
            {
               this.view.scaleX *= -1;
            }
            if(_loc5_)
            {
               this.view.scaleY *= -1;
            }
            if((mode & ZERO_CENTER) != 0)
            {
               this.view.x = _loc6_ >> 1;
               this.view.y = _loc7_ >> 1;
            }
            else
            {
               if((mode & RIGHT) != 0)
               {
                  _loc2_ += w - this.view.width;
               }
               else if((mode & LEFT) == 0)
               {
                  _loc2_ += (w - this.view.width) / 2;
               }
               if((mode & BOTTOM) != 0)
               {
                  _loc3_ += h - this.view.height;
               }
               else if((mode & TOP) == 0)
               {
                  _loc3_ += (h - this.view.height) / 2;
               }
               this.view.x = _loc2_;
               this.view.y = _loc3_;
            }
         }
         else if(this.view is VComponent)
         {
            (this.view as VComponent).geometryPhase();
         }
      }
      
      public function contentPlay(param1:Boolean, param2:Boolean = false) : void
      {
         if(this.$isContent)
         {
            if(this.view is DisplayObjectContainer)
            {
               if(param1 && !param2 && (mode & RANDOM_FRAME) != 0 && this.view is MovieClip)
               {
                  this.useRandomFrame(this.view as MovieClip);
               }
               controlMovieClipPlay(this.view as DisplayObjectContainer,param1,param2);
            }
         }
         else if(param1)
         {
            mode |= PLAY_MOVIE_CLIP;
         }
         else
         {
            mode &= ~PLAY_MOVIE_CLIP;
         }
      }
   }
}

