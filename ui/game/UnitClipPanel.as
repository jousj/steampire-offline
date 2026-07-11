package ui.game
{
   import engine.display.AnimClip;
   import engine.display.Animation;
   import engine.display.Library;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import model.ResourceProxy;
   import ui.UIFactory;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   
   public class UnitClipPanel extends VComponent
   {
      
      private const clip:AnimClip = new AnimClip();
      
      private var isLibListener:Boolean;
      
      private var loadSkin:VSkin;
      
      private var sprite:Sprite;
      
      private var exClip:AnimClip;
      
      public function UnitClipPanel()
      {
         super();
         this.clip.setSimulate(true);
         setSize(50,50);
         mouseChildren = false;
         addChild(this.clip);
      }
      
      public function show(param1:String, param2:uint) : void
      {
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc7_:uint = 0;
         this.setLibListener(false);
         if(this.exClip)
         {
            this.removeExClip();
         }
         this.clip.clear();
         this.clip.setSimulate(false);
         var _loc3_:ResourceProxy = AnimClip.resourceProxy;
         if(param1.indexOf("bl_") == 0)
         {
            param2 = uint(Facade.manualProxy.getBuildShop(param1,param2).sb_model_level);
            _loc4_ = "level";
            _loc4_ = _loc4_ + (param2 == 1 || !_loc3_.getAnimation(param1,_loc4_ + param2) ? "1" : param2.toString());
            if(param1 == "bl_oil_tower")
            {
               this.addExClip(_loc3_.getAnimation(param1,_loc4_ + "_a"),false);
            }
         }
         else if(param1.indexOf("cn_") == 0)
         {
            _loc4_ = "level" + Facade.manualProxy.getCannonShop(param1,param2).sc_model_level;
            _loc5_ = 10;
            this.addExClip(_loc3_.getAnimation(param1,_loc4_ + "_b"),true);
         }
         else if(param1.indexOf("fn_") == 0)
         {
            _loc4_ = "level" + Facade.manualProxy.getFenceShop(param1,param2).sf_model_level;
            _loc5_ = 9;
         }
         else
         {
            if(param1.indexOf("un_") == 0)
            {
               param1 += "_level" + param2;
            }
            _loc4_ = "stand";
         }
         var _loc6_:Animation = _loc3_.getAnimation(param1,_loc4_);
         if(_loc6_)
         {
            this.clip.go(_loc6_,_loc5_ < _loc6_.frameNum ? _loc5_ : 0);
            _loc7_ = _loc6_.lib.loadMode;
            if(_loc7_ == Library.LOAD || _loc7_ == Library.EMPTY)
            {
               this.useLoadClip = true;
               this.setLibListener(true);
               _loc3_.load(_loc6_.lib);
            }
            else
            {
               this.onLibLoadHandler(null);
            }
         }
         else
         {
            this.useLoadClip = false;
         }
      }
      
      private function addExClip(param1:Animation, param2:Boolean) : void
      {
         if(param1)
         {
            this.sprite = new Sprite();
            this.exClip = new AnimClip();
            this.exClip.setSimulate(false);
            this.exClip.animation = param1;
            this.clip.x = this.clip.y = 0;
            this.clip.scaleX = this.clip.scaleY = 1;
            this.sprite.addChild(this.clip);
            addChildAt(this.sprite,0);
            if(param2)
            {
               this.sprite.addChildAt(this.exClip,0);
            }
            else
            {
               this.sprite.addChild(this.exClip);
            }
         }
      }
      
      private function removeExClip() : void
      {
         this.exClip.clear();
         this.exClip = null;
         removeChild(this.sprite);
         this.sprite = null;
         addChild(this.clip);
      }
      
      private function setLibListener(param1:Boolean) : void
      {
         if(this.isLibListener != param1)
         {
            this.isLibListener = param1;
            AnimClip.resourceProxy.setLoadLibListener(this.clip.animation,this.onLibLoadHandler,param1);
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
      
      private function onLibLoadHandler(param1:VEvent) : void
      {
         this.setLibListener(false);
         this.useLoadClip = false;
         this.clip.setSimulate(true);
         if(this.exClip)
         {
            this.exClip.go(this.exClip.animation);
            this.exClip.setSimulate(true);
         }
         var _loc2_:Rectangle = this.sprite ? this.sprite.getRect(null) : this.clip.getRect(null);
         contentW = Math.ceil(_loc2_.width);
         contentH = Math.ceil(_loc2_.height);
         syncContentSize(false);
      }
      
      public function reset() : void
      {
         this.setLibListener(false);
         this.clip.clear();
         if(this.exClip)
         {
            this.removeExClip();
         }
         this.useLoadClip = false;
      }
      
      override public function dispose() : void
      {
         this.setLibListener(false);
         this.clip.clear();
         if(this.exClip)
         {
            this.exClip.clear();
         }
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
         if(this.clip.numChildren > 0)
         {
            _loc1_ = this.sprite ? this.sprite : this.clip;
            _loc1_.scaleX = _loc1_.scaleY = 1;
            VSkin.contain(_loc1_,w,h,true);
            _loc2_ = _loc1_.getRect(null);
            _loc1_.x = Math.round(-_loc2_.x * _loc1_.scaleX + (w - _loc1_.width) / 2);
            _loc1_.y = Math.round(-_loc2_.y * _loc1_.scaleY + (h - _loc1_.height) / 2);
         }
      }
   }
}

