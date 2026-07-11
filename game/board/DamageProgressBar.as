package game.board
{
   import engine.signal.Signal;
   import engine.units.Unit;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VProgressBar;
   import ui.vbase.VSkin;
   
   public class DamageProgressBar extends VProgressBar
   {
      
      private const signal:Signal;
      
      private var cur:int;
      
      private var isWait:Boolean;
      
      private var unit:Unit;
      
      private var stamina:int;
      
      private var armor:int;
      
      private var armorIndicator:VSkin;
      
      private var isMy:Boolean;
      
      public var poolList:Vector.<DamageProgressBar>;
      
      public var max_stamina:int;
      
      public function DamageProgressBar()
      {
         this.signal = new Signal(this.onSignal);
         super();
         layoutH = 10;
         addStretch(SkinManager.getEmbed("TrackSPb",VSkin.STRETCH));
         var _loc1_:VSkin = new VSkin(VSkin.STRETCH);
         _loc1_.setPadding(1);
         init(_loc1_);
      }
      
      public function assign(param1:Unit, param2:Boolean) : void
      {
         this.unit = param1;
         if(this.isMy != param2 || !indicator.isContent)
         {
            this.isMy = param2;
            SkinManager.applyEmbed(indicator,param2 ? UIFactory.INDICATOR_GREEN : UIFactory.INDICATOR_BLUE);
         }
         layoutW = param1.size >= 5 ? 100 : (param1.size >= 3 ? 50 : 30);
         this.stamina = param1.stamina;
         this.armor = param1.armor;
         this.max_stamina = this.stamina + this.armor;
         if(this.armor > 0)
         {
            if(!this.armorIndicator)
            {
               this.armorIndicator = SkinManager.getEmbed(UIFactory.INDICATOR_GREY,VSkin.STRETCH);
               this.armorIndicator.setPadding(1);
            }
            if(!this.armorIndicator.parent)
            {
               addChild(this.armorIndicator);
            }
            _value = 1;
         }
         else if(Boolean(this.armorIndicator) && Boolean(this.armorIndicator.parent))
         {
            removeChild(this.armorIndicator);
         }
         param1.setProgress(this);
      }
      
      public function assignHeroState(param1:Unit) : void
      {
         this.isMy = true;
         SkinManager.applyEmbed(indicator,UIFactory.INDICATOR_GREEN);
         layoutW = 65;
         this.stamina = param1.stamina;
         this.armor = param1.armor;
         this.max_stamina = this.stamina + this.armor;
         if(this.armor > 0)
         {
            if(!this.armorIndicator)
            {
               this.armorIndicator = SkinManager.getEmbed(UIFactory.INDICATOR_GREY,VSkin.STRETCH);
               this.armorIndicator.setPadding(1);
            }
            if(!this.armorIndicator.parent)
            {
               addChild(this.armorIndicator);
            }
            _value = 1;
         }
         else if(Boolean(this.armorIndicator) && Boolean(this.armorIndicator.parent))
         {
            removeChild(this.armorIndicator);
         }
      }
      
      public function sync(param1:uint) : void
      {
         this.cur = param1;
         if(!this.isWait)
         {
            this.applyCur();
            this.isWait = true;
            this.signal.delayCall(0.05,true);
         }
      }
      
      private function applyCur() : void
      {
         if(this.armor > 0)
         {
            if(this.cur > this.stamina)
            {
               this.updateArmorIndicator();
            }
            else
            {
               this.armor = 0;
               remove(this.armorIndicator);
               this.armorIndicator = null;
               value = this.cur / this.stamina;
            }
         }
         else
         {
            value = this.cur / this.stamina;
         }
         this.cur = -1;
      }
      
      private function onSignal() : void
      {
         if(this.isWait)
         {
            this.isWait = false;
            this.signal.delayCall(2.5);
            if(this.cur >= 0)
            {
               this.applyCur();
            }
         }
         else if(this.poolList)
         {
            this.unit.clearProgress(false);
            this.unit = null;
            this.poolList.push(this);
         }
      }
      
      private function updateArmorIndicator() : void
      {
         var _loc1_:int = this.cur - this.stamina;
         if(_loc1_ > this.armor)
         {
            _loc1_ = this.armor;
         }
         this.armorIndicator.width = Math.round(indicator.w * (_loc1_ / this.armor));
      }
      
      override protected function updateIndicator() : void
      {
         super.updateIndicator();
         if(this.armorIndicator)
         {
            this.updateArmorIndicator();
         }
      }
      
      public function clear() : void
      {
         this.unit = null;
         this.signal.stop();
         this.isWait = false;
         this.poolList = null;
      }
      
      override public function dispose() : void
      {
         this.clear();
         super.dispose();
      }
   }
}

