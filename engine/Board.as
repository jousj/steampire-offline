package engine
{
   import engine.display.AnimClip;
   import engine.display.AnimDisplay;
   import engine.units.ZObject;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class Board extends Sprite
   {
      
      public const PADDING:Number = 125;
      
      public const groundPanel:Sprite = new Sprite();
      
      public const airPanel:Sprite = new Sprite();
      
      public const effectPanel:Sprite = new Sprite();
      
      public const tilePanel:Sprite = new Sprite();
      
      public const bgHash:Object = {};
      
      public var lastSortTime:int;
      
      public var isNeedZSort:Boolean;
      
      public var w:Number = 1;
      
      public var h:Number = 1;
      
      private const depthList:Array = [];
      
      private var directionPanel:Sprite;
      
      private var landingPanel:Sprite;
      
      private var uW:uint;
      
      private var uH:uint;
      
      private var minXScroll:Number = 0;
      
      private var maxXScroll:Number = 0;
      
      private var minYScroll:Number = 0;
      
      private var maxYScroll:Number = 0;
      
      public function Board()
      {
         super();
         this.tilePanel.mouseEnabled = this.tilePanel.mouseChildren = false;
         addChild(this.tilePanel);
         this.groundPanel.mouseEnabled = false;
         addChild(this.groundPanel);
         this.airPanel.mouseEnabled = this.airPanel.mouseChildren = false;
         addChild(this.airPanel);
         this.effectPanel.mouseEnabled = this.effectPanel.mouseChildren = false;
         addChild(this.effectPanel);
      }
      
      public function getVectorG() : Graphics
      {
         return this.groundPanel.graphics;
      }
      
      public function clear() : void
      {
         var _loc1_:DisplayObject = null;
         this.depthList.length = 0;
         while(this.groundPanel.numChildren)
         {
            (this.groundPanel.removeChildAt(0) as AnimDisplay).animObj.dispose();
         }
         while(this.airPanel.numChildren)
         {
            (this.airPanel.removeChildAt(0) as AnimDisplay).animObj.dispose();
         }
         while(this.effectPanel.numChildren)
         {
            _loc1_ = this.effectPanel.removeChildAt(0);
            if(_loc1_ is AnimDisplay)
            {
               (_loc1_ as AnimDisplay).animObj.dispose();
            }
            else if(_loc1_ is AnimClip)
            {
               (_loc1_ as AnimClip).clear();
            }
         }
         while(this.tilePanel.numChildren)
         {
            _loc1_ = this.tilePanel.removeChildAt(0);
            if(_loc1_ is AnimDisplay)
            {
               (_loc1_ as AnimDisplay).animObj.dispose();
            }
            else if(_loc1_ is AnimClip)
            {
               (_loc1_ as AnimClip).clear();
            }
         }
         if(this.directionPanel)
         {
            removeChild(this.directionPanel);
            this.directionPanel = null;
         }
         if(this.landingPanel)
         {
            removeChild(this.landingPanel);
            this.landingPanel = null;
         }
      }
      
      public function add(param1:ZObject, param2:Boolean) : void
      {
         if(param2)
         {
            this.airPanel.addChild(param1.display);
         }
         else
         {
            this.groundPanel.addChild(param1.display);
            this.depthList.push(param1);
         }
         param1.onToBoard(true);
      }
      
      public function remove(param1:ZObject) : void
      {
         if(param1.display.parent == this.groundPanel)
         {
            this.depthList.splice(this.depthList.indexOf(param1),1);
            this.isNeedZSort = true;
         }
         param1.display.parent.removeChild(param1.display);
         param1.onToBoard(false);
      }
      
      public function zSort() : void
      {
         var _loc2_:AnimDisplay = null;
         this.isNeedZSort = false;
         this.depthList.sortOn("z_m",Array.NUMERIC);
         var _loc1_:* = int(this.depthList.length - 1);
         while(_loc1_ >= 0)
         {
            _loc2_ = (this.depthList[_loc1_] as ZObject).display;
            if(this.groundPanel.getChildIndex(_loc2_) != _loc1_)
            {
               this.groundPanel.addChildAt(_loc2_,_loc1_);
            }
            _loc1_--;
         }
      }
      
      public function addDirectionShape() : Shape
      {
         var _loc1_:Shape = new Shape();
         if(!this.directionPanel)
         {
            this.directionPanel = new Sprite();
            this.directionPanel.mouseChildren = this.directionPanel.mouseEnabled = false;
            addChildAt(this.directionPanel,getChildIndex(this.tilePanel) + 1);
         }
         this.directionPanel.addChild(_loc1_);
         return _loc1_;
      }
      
      public function createLanding() : Sprite
      {
         if(!this.landingPanel)
         {
            this.landingPanel = new Sprite();
            this.landingPanel.mouseEnabled = this.landingPanel.mouseChildren = false;
            addChildAt(this.landingPanel,getChildIndex(this.tilePanel));
         }
         return this.landingPanel;
      }
      
      public function removeLanding() : void
      {
         if(this.landingPanel)
         {
            removeChild(this.landingPanel);
            this.landingPanel = null;
         }
      }
      
      public function airToGround(param1:ZObject) : void
      {
         if(param1.display.parent == this.airPanel)
         {
            this.groundPanel.addChild(param1.display);
            this.depthList.push(param1);
            this.isNeedZSort = true;
            return;
         }
         throw new Error("airToGround: obj != air " + param1);
      }
      
      public function move(param1:Number, param2:Number) : void
      {
         if(this.minXScroll != this.maxXScroll)
         {
            if(param1 > this.maxXScroll)
            {
               param1 = this.maxXScroll;
            }
            else if(param1 < this.minXScroll)
            {
               param1 = this.minXScroll;
            }
            this.x = Math.round(param1);
         }
         if(this.minYScroll != this.maxYScroll)
         {
            if(param2 > this.maxYScroll)
            {
               param2 = this.maxYScroll;
            }
            else if(param2 < this.minYScroll)
            {
               param2 = this.minYScroll;
            }
            this.y = Math.round(param2);
         }
      }
      
      public function toPosition(param1:int, param2:int) : void
      {
         var _loc3_:Point = new Point();
         Isometric.posToScreen(param1,param2,_loc3_);
         this.move(-(_loc3_.x * scaleX - this.w / 2),-(_loc3_.y * scaleY - this.h / 2));
      }
      
      private function updateBoardSize() : void
      {
         var _loc1_:Number = scaleX;
         var _loc2_:Number = Facade.map_sx * Isometric.POS_WIDTH;
         var _loc3_:Number = Facade.map_sy * Isometric.POS_HEIGHT;
         if(this.w >= (_loc2_ + this.PADDING + this.PADDING) * _loc1_)
         {
            this.minXScroll = this.maxXScroll = 0;
            x = Math.round(this.w / 2);
         }
         else
         {
            this.maxXScroll = (_loc2_ / 2 + this.PADDING) * _loc1_;
            this.minXScroll = this.w - this.maxXScroll;
         }
         if(this.h >= (_loc3_ + this.PADDING + this.PADDING) * _loc1_)
         {
            this.minYScroll = this.maxYScroll = 0;
            y = Math.round((this.h - _loc3_ * _loc1_) / 2);
         }
         else
         {
            this.minYScroll = this.h - (_loc3_ + this.PADDING) * _loc1_;
            this.maxYScroll = this.PADDING * _loc1_;
         }
      }
      
      public function updateScale(param1:int, param2:int) : void
      {
         this.updateBoardSize();
         this.toPosition(param1,param2);
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         this.w = param1 > 0 ? param1 : 1;
         this.h = param2 > 0 ? param2 : 1;
         var _loc3_:Number = this.x;
         if(this.uW > 0)
         {
            _loc3_ += (param1 - this.uW) / 2;
         }
         var _loc4_:Number = this.y;
         if(this.uH > 0)
         {
            _loc4_ += (param2 - this.uH) / 2;
         }
         this.updateBoardSize();
         this.move(_loc3_,_loc4_);
         this.uW = param1;
         this.uH = param2;
      }
      
      public function initBg(param1:DisplayObject) : void
      {
         param1.x = -1430 - this.PADDING;
         param1.y = -this.PADDING;
      }
      
      public function changeMapBg(param1:String = null) : void
      {
         if(!param1)
         {
            param1 = "map_bg_default";
         }
         if(!this.bgHash.hasOwnProperty(param1) || !(this.bgHash[param1] is DisplayObject) || this.bgHash[param1] == getChildAt(0))
         {
            return;
         }
         removeChildAt(0);
         addChildAt(this.bgHash[param1],0);
         stage.color = param1 == "map_bg_winter" ? 2961716 : 2894116;
      }
   }
}

