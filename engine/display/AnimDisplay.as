package engine.display
{
   import engine.units.AnimObject;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.BitmapFilter;
   import flash.geom.Rectangle;
   
   public class AnimDisplay extends Sprite
   {
      
      public static const SCENE:uint = 0;
      
      public static const INSIDE:uint = 1;
      
      public static const OUTSIDE:uint = 2;
      
      private const scene:Sprite = new Sprite();
      
      private const clipList:Vector.<AnimClip> = new Vector.<AnimClip>();
      
      public var animObj:AnimObject;
      
      public var viewRect:Rectangle;
      
      private var filterList:Array;
      
      public function AnimDisplay()
      {
         super();
         mouseEnabled = false;
         super.visible = false;
         this.scene.mouseChildren = false;
         addChild(this.scene);
      }
      
      public function isScene(param1:DisplayObject) : Boolean
      {
         return param1 == this.scene;
      }
      
      public function add(param1:AnimClip, param2:uint = 0, param3:int = -1) : void
      {
         if(param2 == SCENE)
         {
            if(param3 < 0 || param3 >= this.scene.numChildren)
            {
               this.scene.addChild(param1);
            }
            else
            {
               this.scene.addChildAt(param1,param3);
            }
         }
         else if(param2 == INSIDE)
         {
            if(param3 < 0 || param3 >= numChildren)
            {
               addChild(param1);
            }
            else
            {
               addChildAt(param1,param3);
            }
         }
         else
         {
            param1.x = x;
            param1.y = y;
         }
         this.clipList.push(param1);
         if(this.clipList.length == 2)
         {
            this.viewRect = this.viewRect ? this.viewRect.clone() : new Rectangle();
         }
         param1.setSimulate(visible);
      }
      
      public function addNew(param1:String, param2:uint = 0, param3:int = -1) : AnimClip
      {
         var _loc4_:AnimClip = new AnimClip();
         if(param1)
         {
            _loc4_.name = param1;
         }
         this.add(_loc4_,param2,param3);
         return _loc4_;
      }
      
      public function remove(param1:AnimClip) : void
      {
         param1.stop();
         var _loc2_:int = this.clipList.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.clipList.splice(_loc2_,1);
            if(param1.parent)
            {
               param1.parent.removeChild(param1);
            }
            if(this.clipList.length > 0 && Boolean(this.clipList[0].animation))
            {
               if(this.clipList.length == 1)
               {
                  this.viewRect = this.clipList[0].animation.viewRect;
               }
               else
               {
                  this.unionViewRect(this.clipList[0].animation.viewRect);
               }
            }
         }
      }
      
      public function removeByName(param1:String) : void
      {
         var _loc2_:AnimClip = this.getClip(param1);
         if(_loc2_)
         {
            this.remove(_loc2_);
         }
      }
      
      public function pauseAll(param1:Boolean) : void
      {
         var _loc2_:AnimClip = null;
         for each(_loc2_ in this.clipList)
         {
            _loc2_.pause = param1;
         }
      }
      
      override public function set visible(param1:Boolean) : void
      {
         var _loc2_:AnimClip = null;
         super.visible = param1;
         for each(_loc2_ in this.clipList)
         {
            _loc2_.setSimulate(param1);
            if(_loc2_.parent != this.scene && _loc2_.parent != this)
            {
               _loc2_.visible = param1;
            }
         }
      }
      
      public function setPos(param1:Number, param2:Number) : void
      {
         this.x = Math.round(param1);
         this.y = Math.round(param2);
         if(this.scene.numChildren != this.clipList.length)
         {
            this.setPosEx(this.x,this.y);
         }
      }
      
      private function setPosEx(param1:Number, param2:Number) : void
      {
         var _loc3_:AnimClip = null;
         for each(_loc3_ in this.clipList)
         {
            if(_loc3_.parent != this.scene && _loc3_.parent != this)
            {
               _loc3_.x = param1;
               _loc3_.y = param2;
            }
         }
      }
      
      public function getClip(param1:String) : AnimClip
      {
         var _loc2_:AnimClip = null;
         for each(_loc2_ in this.clipList)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getOrNewClip(param1:String, param2:int = -1) : AnimClip
      {
         var _loc3_:AnimClip = this.getClip(param1);
         if(_loc3_)
         {
            return _loc3_;
         }
         return this.addNew(param1,0,param2);
      }
      
      public function getClipIndex(param1:AnimClip) : int
      {
         return param1.parent == this.scene ? this.scene.getChildIndex(param1) : 0;
      }
      
      public function addFilter(param1:BitmapFilter, param2:Boolean = false, param3:Boolean = true) : void
      {
         if(!this.filterList)
         {
            this.filterList = [];
         }
         else if(param2 && this.filterList.indexOf(param1) >= 0)
         {
            return;
         }
         this.filterList.push(param1);
         if(param3)
         {
            this.scene.filters = this.filterList;
         }
      }
      
      public function removeFilter(param1:BitmapFilter, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         if(this.filterList)
         {
            _loc3_ = this.filterList.indexOf(param1);
            if(_loc3_ >= 0)
            {
               this.filterList.splice(_loc3_,1);
               if(param2)
               {
                  this.scene.filters = this.filterList;
               }
            }
         }
      }
      
      public function changeViewRect(param1:Rectangle) : void
      {
         if(this.clipList.length > 1)
         {
            this.unionViewRect(param1);
         }
         else
         {
            this.viewRect = param1;
         }
      }
      
      private function unionViewRect(param1:Rectangle) : void
      {
         if(param1)
         {
            this.viewRect.x = param1.x;
            this.viewRect.y = param1.y;
            this.viewRect.width = param1.width;
            this.viewRect.height = param1.height;
         }
         else
         {
            this.viewRect.setEmpty();
         }
         var _loc2_:* = int(this.clipList.length - 1);
         while(_loc2_ > 0)
         {
            this.clipList[_loc2_].unionViewRect(this.viewRect);
            _loc2_--;
         }
      }
      
      public function setSceneAlpha(param1:Number) : void
      {
         this.scene.alpha = param1;
      }
      
      public function setInactive(param1:Boolean) : void
      {
         this.scene.mouseEnabled = !param1;
      }
      
      public function get isActive() : Boolean
      {
         return this.scene.mouseEnabled;
      }
      
      public function dispose() : void
      {
         var _loc1_:AnimClip = null;
         for each(_loc1_ in this.clipList)
         {
            _loc1_.stop();
            _loc1_.removeFromParent();
         }
         this.clipList.length = 0;
         this.animObj = null;
      }
   }
}

