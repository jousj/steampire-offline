package game.board
{
   import engine.Isometric;
   import engine.units.Unit;
   import flash.display.Sprite;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   
   public class UnitAreaBox extends Sprite
   {
      
      public const checkList:Vector.<Boolean> = new Vector.<Boolean>();
      
      public var sx:uint;
      
      public var sy:uint;
      
      private const areaList:Vector.<VSkin> = new Vector.<VSkin>();
      
      public function UnitAreaBox()
      {
         super();
         mouseChildren = mouseEnabled = false;
      }
      
      public function assign(param1:Unit) : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         if(param1)
         {
            this.changeSize(param1.size,param1.size);
            param1.display.addChildAt(this,0);
         }
      }
      
      public function changeSize(param1:uint, param2:uint) : void
      {
         var _loc5_:VSkin = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc3_:uint = this.areaList.length;
         var _loc4_:uint = param1 * param2;
         this.checkList.length = _loc4_;
         if(_loc3_ != _loc4_)
         {
            while(_loc3_ > _loc4_)
            {
               this.areaList.pop().removeFromParent();
               _loc3_--;
            }
            while(_loc4_ > _loc3_)
            {
               _loc5_ = new VSkin(VSkin.NO_STRETCH);
               this.areaList.push(_loc5_);
               addChild(_loc5_);
               _loc3_++;
            }
         }
         if(this.sx != param1 || this.sy != param2)
         {
            this.sx = param1;
            this.sy = param2;
            _loc3_ = 0;
            for each(_loc5_ in this.areaList)
            {
               _loc6_ = _loc3_ / param1;
               _loc7_ = _loc3_ - _loc6_ * param1;
               _loc5_.left = -((_loc7_ - _loc6_) * Isometric.POS_HALF_WIDTH);
               _loc5_.top = -((_loc7_ + _loc6_) * Isometric.POS_HALF_HEIGHT);
               _loc5_.geometryPhase();
               _loc3_++;
            }
         }
      }
      
      public function resetCheck(param1:Boolean = false) : void
      {
         var _loc2_:* = int(this.checkList.length - 1);
         while(_loc2_ >= 0)
         {
            this.checkList[_loc2_] = param1;
            _loc2_--;
         }
      }
      
      public function update() : void
      {
         var _loc3_:uint = 0;
         var _loc4_:VSkin = null;
         var _loc1_:uint = this.checkList.length;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.checkList[_loc2_] ? 1 : 2;
            _loc4_ = this.areaList[_loc2_];
            if(_loc4_.minW != _loc3_)
            {
               SkinManager.applyEmbed(_loc4_,_loc3_ == 1 ? "GreenAreaBg" : "RedAreaBg");
               _loc4_.minW = _loc3_;
            }
            _loc2_++;
         }
      }
   }
}

