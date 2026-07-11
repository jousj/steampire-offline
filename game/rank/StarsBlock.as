package game.rank
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.filters.GlowFilter;
   import model.ui.VOAchievementItem;
   import proto.model.PAction;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class StarsBlock extends VComponent
   {
      
      public var starList:Array;
      
      private var isFirst:Boolean = false;
      
      private var starFilters:Array;
      
      private var starFilterIndex:uint = 3;
      
      private var starGraySkin:VSkin;
      
      private var starGrayIndex:uint = 3;
      
      public function StarsBlock(param1:Boolean)
      {
         var _loc3_:Vector.<Number> = null;
         var _loc5_:Shape = null;
         this.starList = [];
         super();
         this.isFirst = param1;
         var _loc2_:String = "RankDialog";
         add(SkinManager.getPack(_loc2_,"StarsBg"),{"bottom":2});
         this.starList.push(SkinManager.getPack(_loc2_,"Star1"),SkinManager.getPack(_loc2_,"Star2"),SkinManager.getPack(_loc2_,"Star3"));
         add(this.starList[1],{
            "left":74,
            "bottom":35
         });
         add(this.starList[2],{
            "left":148,
            "bottom":17
         });
         add(this.starList[0],{
            "left":8,
            "bottom":15
         });
         _loc3_ = new <Number>[-4,40,-7,70,14,0,145,29,6];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = new Shape();
            addChild(_loc5_).x = _loc3_[_loc4_];
            _loc5_.y = _loc3_[_loc4_ + 1];
            _loc5_.rotation = _loc3_[_loc4_ + 2];
            this.starList[int(_loc4_ / 3)].mask = _loc5_;
            _loc4_ += 3;
         }
      }
      
      public function syncStars(param1:VOAchievementItem) : void
      {
         var _loc3_:Vector.<uint> = null;
         var _loc5_:Graphics = null;
         var _loc6_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc2_:int = this.isFirst ? 0 : 3;
         var _loc4_:uint = 0;
         while(_loc4_ <= 2)
         {
            _loc5_ = (this.starList[_loc4_].mask as Shape).graphics;
            _loc5_.clear();
            _loc5_.beginFill(0);
            if(param1.index > _loc4_ + _loc2_)
            {
               _loc6_ = 88;
            }
            else if(param1.index != _loc4_ + _loc2_ || !param1.quest)
            {
               _loc6_ = 0;
            }
            else
            {
               _loc6_ = 88;
               _loc7_ = 0;
               if(_loc4_ > 0)
               {
                  if(!_loc3_)
                  {
                     _loc3_ = new <uint>[PAction.AC_UP_BUILDING,PAction.AC_FINISH_BUILDING,PAction.AC_UP_CANNON,PAction.AC_HAVE_RATING,PAction.AC_HAVE_FRIEND,PAction.AC_LVL_UP];
                  }
                  if(_loc3_.indexOf(param1.targetList[_loc4_].qti_action.variance) >= 0)
                  {
                     _loc7_ = param1.targetList[_loc4_ - 1].qti_count;
                  }
               }
               _loc8_ = param1.quest.target.qti_count - _loc7_;
               if(_loc8_ > 0)
               {
                  _loc6_ *= (param1.quest.count - _loc7_) / _loc8_;
                  if(_loc6_ < 0)
                  {
                     _loc6_ = 0;
                  }
               }
            }
            _loc5_.drawRect(0,0,_loc6_,88);
            _loc5_.endFill();
            _loc4_++;
         }
         _loc4_ = param1.index <= 2 + _loc2_ && (!param1.quest || !param1.quest.isComplete) ? uint(param1.index - _loc2_) : 3;
         if(_loc4_ != this.starGrayIndex)
         {
            this.starGrayIndex = _loc4_;
            if(_loc4_ > 2)
            {
               if(Boolean(this.starGraySkin) && Boolean(this.starGraySkin.parent))
               {
                  remove(this.starGraySkin,false);
               }
            }
            else
            {
               if(!this.starGraySkin)
               {
                  this.starGraySkin = new VSkin();
                  this.starGraySkin.filters = VSkin.GREY_FILTER;
                  this.starGraySkin.alpha = 0.8;
               }
               SkinManager.applyExternal(this.starGraySkin,"RankDialog","Star" + (_loc4_ + 1));
               this.starGraySkin.copyLayout(this.starList[_loc4_]);
               if(this.starGraySkin.parent)
               {
                  this.starGraySkin.syncLayout();
               }
               else
               {
                  add(this.starGraySkin,null,getChildIndex(this.starList[1]));
               }
            }
         }
         if(Boolean(param1.index <= 2 + _loc2_) && Boolean(param1.quest) && param1.quest.isComplete)
         {
            if(!this.starFilters)
            {
               this.starFilters = [new GlowFilter(16711656,1,8,8),new GlowFilter(16774218,1,16,16)];
            }
            if(this.starFilterIndex + _loc2_ != param1.index)
            {
               this.starList[param1.index - _loc2_].filters = this.starFilters;
               this.starFilterIndex = param1.index - _loc2_;
            }
         }
         else if(this.starFilterIndex < 3)
         {
            this.starList[this.starFilterIndex].filters = null;
            this.starFilterIndex = 3;
         }
      }
      
      override public function dispose() : void
      {
         disposeFloat(this.starGraySkin);
         super.dispose();
      }
   }
}

