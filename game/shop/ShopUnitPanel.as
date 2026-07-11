package game.shop
{
   import engine.display.AnimClip;
   import engine.display.AnimDisplay;
   import engine.display.Library;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Decor;
   import engine.units.Fence;
   import engine.units.Garbage;
   import engine.units.Unit;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import logic.UnitFactory;
   import model.vo.VOResourceSpec;
   import model.vo.VOStorageSpec;
   import proto.model.PBtype;
   import ui.UIFactory;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   
   public class ShopUnitPanel extends VComponent
   {
      
      private var isLibListener:Boolean;
      
      private var loadSkin:VSkin;
      
      public var unit:Unit;
      
      public function ShopUnitPanel()
      {
         super();
         setSize(50,50);
         mouseChildren = false;
      }
      
      public function show(param1:String, param2:uint) : void
      {
         this.setLibListener(false);
         this.clearUnit();
         if(param1.indexOf("bl_") == 0)
         {
            this.unit = UnitFactory.newBuild(Facade.manualProxy.getBuildShop(param1,param2));
            if(param1 != "bl_camp")
            {
               (this.unit as Build).isUseAnim = false;
            }
            this.setResSpec(this.unit as Build);
         }
         else if(param1.indexOf("cn_") == 0)
         {
            this.unit = UnitFactory.newCannon(Facade.manualProxy.getCannonShop(param1,param2),true);
            (this.unit as Cannon).rotate(215,true,true);
         }
         else if(param1.indexOf("fn_") == 0)
         {
            this.unit = new Fence(Facade.manualProxy.getFenceShop(param1,param2));
         }
         else if(param1.indexOf("dc_") == 0)
         {
            this.unit = new Decor(Facade.manualProxy.getDecorShop(param1));
         }
         else
         {
            if(param1.indexOf("gb_") != 0)
            {
               this.useLoadClip = false;
               return;
            }
            this.unit = new Garbage(Facade.manualProxy.getGarbageShop(param1));
         }
         this.unit.configViewRect(false);
         this.unit.display.pauseAll(true);
         this.unit.stand();
         if(this.unit.animClip.animation)
         {
            if(this.unit.animClip.animation.lib.loadMode == Library.LOAD)
            {
               this.useLoadClip = true;
               this.setLibListener(true);
            }
            else
            {
               this.onLibLoad(null);
            }
         }
         else
         {
            this.useLoadClip = false;
         }
      }
      
      private function setResSpec(param1:Build) : void
      {
         if(param1.type == PBtype.RESOURCE)
         {
            (param1.spec as VOResourceSpec).capacityCur = (param1.spec as VOResourceSpec).capacityMax;
         }
         else if(param1.type == PBtype.STORAGE)
         {
            (param1.spec as VOStorageSpec).capacityCur = (param1.spec as VOStorageSpec).capacityMax;
         }
      }
      
      private function setLibListener(param1:Boolean) : void
      {
         if(this.isLibListener != param1)
         {
            this.isLibListener = param1;
            AnimClip.resourceProxy.setLoadLibListener(this.unit.animClip.animation,this.onLibLoad,param1);
         }
      }
      
      private function set useLoadClip(param1:Boolean) : void
      {
         if(param1 != Boolean(this.loadSkin))
         {
            if(param1)
            {
               this.loadSkin = UIFactory.getExternalLoadClip();
               addChild(this.loadSkin);
               this.loadSkin.geometryPhase();
            }
            else
            {
               remove(this.loadSkin);
               this.loadSkin = null;
            }
         }
      }
      
      private function onLibLoad(param1:VEvent) : void
      {
         var _loc3_:AnimClip = null;
         var _loc4_:* = 0;
         this.setLibListener(false);
         this.useLoadClip = false;
         addChild(this.unit.display);
         if(this.unit is Build)
         {
            _loc3_ = this.unit.display.getClip("tile");
            if(_loc3_)
            {
               this.unit.display.add(_loc3_,AnimDisplay.INSIDE,0);
            }
         }
         else if(this.unit is Decor)
         {
            this.unit.display.pauseAll(false);
            _loc4_ = int(this.unit.animClip.parent.numChildren - 1);
            while(_loc4_ >= 0)
            {
               _loc3_ = this.unit.animClip.parent.getChildAt(_loc4_) as AnimClip;
               if(_loc3_)
               {
                  _loc3_.useCommonTime();
               }
               _loc4_--;
            }
         }
         var _loc2_:Rectangle = this.unit.display.getRect(null);
         contentW = Math.ceil(_loc2_.width);
         contentH = Math.ceil(_loc2_.height);
         syncContentSize(false);
      }
      
      private function clearUnit() : void
      {
         if(this.unit)
         {
            this.unit.dispose();
            if(this.unit.display.parent)
            {
               removeChild(this.unit.display);
            }
            this.unit = null;
         }
      }
      
      public function reset() : void
      {
         this.setLibListener(false);
         this.clearUnit();
         this.useLoadClip = false;
      }
      
      override public function dispose() : void
      {
         this.setLibListener(false);
         this.clearUnit();
         super.dispose();
      }
      
      override protected function customUpdate() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Rectangle = null;
         if(this.loadSkin)
         {
            this.loadSkin.geometryPhase();
         }
         if(Boolean(this.unit) && this.unit.animClip.numChildren > 0)
         {
            _loc1_ = this.unit.display;
            _loc1_.scaleX = _loc1_.scaleY = 1;
            VSkin.contain(_loc1_,w,h,true);
            _loc2_ = _loc1_.getRect(null);
            _loc1_.x = Math.round(-_loc2_.x * _loc1_.scaleX + (w - _loc1_.width) / 2);
            _loc1_.y = Math.round(-_loc2_.y * _loc1_.scaleY + (h - _loc1_.height) / 2);
            if(this.unit is Cannon)
            {
               _loc1_.x += Math.round((_loc2_.x - this.unit.animClip.parent.getRect(_loc1_).x) * _loc1_.scaleX / 2);
            }
         }
      }
   }
}

