package engine.units
{
   import engine.display.AnimClip;
   import engine.display.AnimDisplay;
   import engine.display.Animation;
   import engine.display.PeriodClip;
   import flash.geom.Point;
   import model.vo.VOResourceSpec;
   import model.vo.VOShieldSpec;
   import model.vo.VOStorageSpec;
   import proto.model.PBtype;
   import proto.model.PCost;
   import proto.model.PShopBuilding;
   import ui.UIFactory;
   import ui.vbase.VComponent;
   
   public class Build extends RadiusUnit
   {
      
      public var shop:PShopBuilding;
      
      public var type:uint;
      
      public var spec:*;
      
      public var isUseAnim:Boolean = true;
      
      private var animLevel:String;
      
      private var frameIndex:uint;
      
      public function Build(param1:PShopBuilding, param2:uint)
      {
         super();
         applyKind(param1.sb_kind);
         this.updateMax = param2;
         this.assignShop(param1);
      }
      
      public function assignShop(param1:PShopBuilding) : void
      {
         animClip.weakClear();
         this.shop = param1;
         this.type = param1.sb_btype.variance;
         level = param1.sb_level;
         stamina = param1.sb_stamina;
         armor = param1.sb_armor;
         this.animLevel = "level";
         this.animLevel += param1.sb_model_level == 1 || !animHash.hasOwnProperty(this.animLevel + param1.sb_model_level) ? "1" : param1.sb_model_level.toString();
         boomList = boomHash[kind + this.animLevel];
         if(this.type == PBtype.RESOURCE && pointHash.hasOwnProperty(kind))
         {
            this.showLevelText();
         }
      }
      
      override public function stand() : void
      {
         var _loc1_:Animation = animHash[this.animLevel];
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Boolean = !animClip.animation;
         if((this.type == PBtype.RESOURCE || this.type == PBtype.STORAGE) && kind != "bl_ruby_mine")
         {
            this.calcResIndex();
            goAnim(_loc1_,this.frameIndex);
         }
         else if(this.type == PBtype.SHIELD)
         {
            this.shieldStand(_loc1_);
         }
         else if(this.isUseAnim)
         {
            playAnim(_loc1_,true,_loc1_.getRandomIndex());
         }
         else
         {
            goAnim(_loc1_,_loc1_.getRandomIndex());
         }
         if(this.type == PBtype.RESOURCE)
         {
            this.syncResJob();
         }
         else if(this.type == PBtype.SCOUTING)
         {
            this.radarStand();
         }
         else
         {
            this.syncAuxClip();
         }
         if(_loc2_)
         {
            if(updateLevel > 0)
            {
               scaffolding(true);
            }
            changeTile(this.animLevel,"tl_build");
            setShadow(this.animLevel);
         }
      }
      
      public function syncResAnim() : void
      {
         if(Boolean(animClip.animation) && Boolean(this.calcResIndex()) && kind != "bl_ruby_mine")
         {
            animClip.go_to(this.frameIndex);
         }
      }
      
      private function calcResIndex() : Boolean
      {
         var _loc2_:uint = 0;
         var _loc1_:Number = -1;
         if(this.spec is VOResourceSpec)
         {
            _loc1_ = (this.spec as VOResourceSpec).percentage;
         }
         else if(this.spec is VOStorageSpec)
         {
            _loc1_ = (this.spec as VOStorageSpec).percentage;
         }
         if(_loc1_ >= 0)
         {
            if(_loc1_ == 0)
            {
               _loc2_ = 4;
            }
            else if(_loc1_ <= 0.4)
            {
               _loc2_ = 3;
            }
            else if(_loc1_ <= 0.7)
            {
               _loc2_ = 2;
            }
            else if(_loc1_ <= 0.95)
            {
               _loc2_ = 1;
            }
            if(this.frameIndex != _loc2_)
            {
               this.frameIndex = _loc2_;
               return true;
            }
         }
         return false;
      }
      
      public function syncResJob() : void
      {
         var _loc1_:VOResourceSpec = null;
         var _loc4_:Animation = null;
         var _loc5_:AnimClip = null;
         _loc1_ = this.spec as VOResourceSpec;
         var _loc2_:Boolean = updateLevel == 0 && _loc1_.capacityCur < _loc1_.capacityMax && this.isUseAnim;
         var _loc3_:String = "resJob";
         if(_loc2_ || _loc1_.prodVariance == PCost.OIL)
         {
            _loc4_ = animHash[this.animLevel + "_a"] as Animation;
            if(_loc4_)
            {
               _loc5_ = display.getClip(_loc3_);
               if(!_loc5_)
               {
                  if(Facade.userProxy.level > 8)
                  {
                     _loc5_ = PeriodClip.create(this,_loc3_);
                  }
                  else
                  {
                     _loc5_ = display.addNew(_loc3_,AnimDisplay.SCENE,display.getClipIndex(animClip) + 1);
                  }
               }
               if(_loc2_)
               {
                  _loc5_.play(_loc4_,true,_loc4_.getRandomIndex());
               }
               else
               {
                  _loc5_.go(_loc4_);
               }
               return;
            }
         }
         display.removeByName(_loc3_);
      }
      
      private function syncAuxClip() : void
      {
         var _loc2_:Animation = null;
         var _loc3_:AnimClip = null;
         var _loc1_:String = "aux";
         if(this.isUseAnim && updateLevel == 0)
         {
            _loc2_ = animHash[this.animLevel + "_a"] as Animation;
            if(_loc2_)
            {
               _loc3_ = display.getClip(_loc1_);
               if(!_loc3_)
               {
                  if(Facade.userProxy.level > 8 && this.type != PBtype.CAMP)
                  {
                     _loc3_ = PeriodClip.create(this,_loc1_,true);
                  }
                  else
                  {
                     _loc3_ = display.addNew(_loc1_,AnimDisplay.SCENE,display.getClipIndex(animClip) + 1);
                  }
               }
               _loc3_.play(_loc2_,true,_loc2_.getRandomIndex());
               return;
            }
         }
         display.removeByName(_loc1_);
      }
      
      private function showLevelText() : void
      {
         var _loc1_:VComponent = null;
         var _loc2_:* = int(display.numChildren - 1);
         while(_loc2_ >= 0)
         {
            _loc1_ = display.getChildAt(_loc2_) as VComponent;
            if(Boolean(_loc1_) && _loc1_.hint === 1)
            {
               display.removeChildAt(_loc2_);
               _loc1_.dispose();
               break;
            }
            _loc2_--;
         }
         if(level <= 9)
         {
            _loc2_ = 34;
         }
         else if(level < 100)
         {
            _loc2_ = 28;
         }
         else
         {
            _loc2_ = 24;
         }
         _loc1_ = UIFactory.createDecorText(level.toString(),true,_loc2_,0,false);
         _loc1_.mouseEnabled = false;
         _loc1_.hint = 1;
         display.addChild(_loc1_);
         _loc1_.geometryPhase();
         var _loc3_:Point = pointHash[kind];
         _loc1_.x = Math.round(_loc3_.x - _loc1_.w / 2);
         _loc1_.y = Math.round(_loc3_.y - _loc1_.h / 2);
      }
      
      private function shieldStand(param1:Animation) : void
      {
         var _loc2_:Boolean = updateLevel == 0 && (this.spec as VOShieldSpec).isRecovery;
         if(this.isUseAnim && _loc2_)
         {
            playAnim(param1,true);
         }
         else
         {
            goAnim(param1,_loc2_ ? 0 : uint(param1.frameNum - 1));
         }
      }
      
      private function radarStand() : void
      {
         var _loc3_:AnimClip = null;
         var _loc1_:Animation = animHash[this.animLevel + "_ex"] as Animation;
         var _loc2_:String = "radar";
         if(_loc1_)
         {
            _loc3_ = display.getClip(_loc2_);
            if(!_loc3_)
            {
               _loc3_ = PeriodClip.create(this,_loc2_);
            }
            if(updateLevel == 0)
            {
               _loc3_.play(_loc1_,true);
            }
            else
            {
               _loc3_.go(_loc1_);
            }
         }
         else
         {
            display.removeByName(_loc2_);
         }
      }
   }
}

