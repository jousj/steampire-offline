package engine.units
{
   import engine.display.AnimClip;
   import engine.display.AnimDisplay;
   import engine.display.Animation;
   import proto.model.PShopDecor;
   
   public class Decor extends Unit
   {
      
      public var shop:PShopDecor;
      
      private var effectCount:uint;
      
      public function Decor(param1:PShopDecor)
      {
         super();
         applyKind(param1.sd_kind);
         this.shop = param1;
      }
      
      override public function stand() : void
      {
         var _loc2_:Animation = null;
         var _loc3_:AnimClip = null;
         super.stand();
         var _loc1_:uint = 1;
         while(true)
         {
            _loc2_ = animHash["stand_a" + _loc1_] as Animation;
            if(!_loc2_)
            {
               break;
            }
            _loc3_ = display.getClip(_loc2_.name);
            if(!_loc3_)
            {
               _loc3_ = display.addNew(_loc2_.name,AnimDisplay.SCENE);
            }
            _loc3_.play(_loc2_,true,_loc2_.getRandomIndex());
            _loc1_++;
         }
         _loc1_--;
         if(_loc1_ != this.effectCount)
         {
            while(this.effectCount > _loc1_)
            {
               display.removeByName("stand_a" + this.effectCount);
               --this.effectCount;
            }
            this.effectCount = _loc1_;
         }
         setShadow("stand");
      }
   }
}

