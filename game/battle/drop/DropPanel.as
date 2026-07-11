package game.battle.drop
{
   import engine.signal.Signal;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import model.ui.VOBattleItem;
   import proto.model.PCost;
   import ui.UIFactory;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   
   public class DropPanel extends VComponent
   {
      
      public const soldierGrid:VGrid = new VGrid(1,1,DropRenderer,null,8,0,VGrid.FLOAT_INDEX | VGrid.USE_END_LIMIT);
      
      public const spellGrid:VGrid = new VGrid(1,1,DropRenderer,null,8);
      
      public const powerPanel:ResourcePanel = new ResourcePanel(SkinManager.getEmbed("Power"),ResourcePanel.BG | ResourcePanel.CACHE_AS_BITMAP);
      
      public var selectPanel:SelectDropPanel;
      
      public var crystalPanel:ResourcePanel;
      
      public var goldPanel:ResourcePanel;
      
      private var selectIndex:uint;
      
      private var limiterPanel:LimiterPanel;
      
      private var focusSignal:Signal;
      
      private var focusFilter:Array;
      
      private const bg:VSkin = SkinManager.getEmbed("BattleBlock",VSkin.STRETCH);
      
      private const bg2:VSkin = SkinManager.getEmbed("BattleBlock",VSkin.STRETCH);
      
      public function DropPanel()
      {
         super();
         layoutH = 90;
         minW = 200;
         addChild(this.bg);
         this.soldierGrid.addListener(VEvent.SELECT,this.onSelect);
         this.soldierGrid.addListener(VEvent.CHANGE,this.onGridChange);
         UIFactory.useGridControlNav(this.soldierGrid,addNavBt);
         this.spellGrid.addListener(VEvent.SELECT,this.onSelect);
         this.spellGrid.addListener(VEvent.CHANGE,this.onGridChange);
         this.powerPanel.layoutW = 120;
         this.powerPanel.hint = Lang.getString("power");
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public static function addNavBt(param1:VGrid, param2:VButton, param3:VButton) : void
      {
         param1.add(param2,{
            "w":35,
            "h":58,
            "vCenter":2,
            "left":-40
         });
         param1.add(param3,{
            "w":35,
            "h":58,
            "vCenter":2,
            "right":-40
         });
      }
      
      private function onGridChange(param1:VEvent = null) : void
      {
         var _loc2_:VGrid = null;
         if(this.selectPanel)
         {
            _loc2_ = this.selectPanel.item.spellShop ? this.spellGrid : this.soldierGrid;
            if(!(this.selectIndex >= _loc2_.index && this.selectIndex < _loc2_.index + _loc2_.maxRenderer))
            {
               this.selectPanel.visible = false;
               return;
            }
            this.selectPanel.x = _loc2_.x + Math.round(((this.selectIndex - _loc2_.index) * (_loc2_.renderList[0].layoutW + _loc2_.hGap) - 7) * _loc2_.scaleX);
            this.selectPanel.visible = true;
         }
      }
      
      public function select(param1:DropRenderer) : void
      {
         this.onSelect(null,param1);
      }
      
      private function onSelect(param1:VEvent, param2:DropRenderer = null) : void
      {
         var _loc3_:VOBattleItem = null;
         var _loc4_:Boolean = false;
         if(param1)
         {
            param2 = param1.data;
         }
         if(!this.selectPanel || param2.item != this.selectPanel.item)
         {
            _loc3_ = param2.item;
            _loc4_ = false;
            if(Boolean(this.selectPanel) && (Boolean(_loc3_.shop || this.selectPanel.item.shop)) && this.removeZeroSoldier())
            {
               _loc4_ = true;
               this.soldierGrid.sync();
               if(_loc3_.shop)
               {
                  for each(param2 in this.soldierGrid.renderList)
                  {
                     if(param2.item == _loc3_)
                     {
                        break;
                     }
                  }
               }
            }
            this.selectIndex = param2.dataIndex;
            if(!this.selectPanel)
            {
               this.selectPanel = new SelectDropPanel();
               this.selectPanel.addListener(VEvent.SELECT,this.reset);
               add(this.selectPanel);
               this.selectPanel.setScale(this.soldierGrid.scaleX,this.spellGrid.y);
            }
            this.selectPanel.setData(_loc3_);
            if(_loc4_)
            {
               this.update();
            }
            else
            {
               this.onGridChange();
            }
            this.setBlackout(true);
            dispatchEvent(new VEvent(VEvent.SELECT,_loc3_));
         }
      }
      
      private function setBlackout(param1:Boolean) : void
      {
         var _loc2_:DropRenderer = null;
         for each(_loc2_ in this.soldierGrid.renderList)
         {
            _loc2_.useBlackout(param1);
         }
         for each(_loc2_ in this.spellGrid.renderList)
         {
            _loc2_.useBlackout(param1);
         }
      }
      
      public function drop(param1:uint) : void
      {
         var _loc2_:VOBattleItem = null;
         if(this.selectPanel)
         {
            _loc2_ = this.selectPanel.item;
            if(_loc2_.shop)
            {
               _loc2_.count = _loc2_.count > param1 ? uint(_loc2_.count - param1) : 0;
               if(_loc2_.count == 0 && this.soldierGrid.length == 1)
               {
                  this.reset();
                  return;
               }
            }
            this.selectPanel.setData(_loc2_);
            if(_loc2_.shop)
            {
               this.soldierGrid.sync();
            }
            else
            {
               this.spellGrid.sync();
            }
         }
      }
      
      private function removeZeroSoldier() : Boolean
      {
         if(Boolean(this.selectPanel.item.shop) && this.selectPanel.item.count == 0)
         {
            if(this.selectIndex < this.soldierGrid.getDataProvider().length)
            {
               this.soldierGrid.getDataProvider().splice(this.selectIndex,1);
               return true;
            }
         }
         return false;
      }
      
      public function reset(param1:Event = null) : void
      {
         var _loc2_:Boolean = false;
         if(this.selectPanel)
         {
            _loc2_ = this.removeZeroSoldier();
            remove(this.selectPanel);
            this.selectPanel = null;
            Facade.boardMediator.resetDown();
            if(_loc2_)
            {
               this.soldierGrid.sync();
               this.update();
            }
            this.setBlackout(false);
            dispatchEvent(new VEvent(VEvent.SELECT));
         }
      }
      
      public function setSpellDp(param1:Array) : void
      {
         var _loc2_:uint = param1 ? param1.length : 0;
         this.spellGrid.changeRendererCount(_loc2_,1,param1);
         if(_loc2_ == 0)
         {
            this.spellGrid.setDataProvider(null);
            if(this.spellGrid.parent)
            {
               removeChild(this.spellGrid);
            }
         }
         else if(!this.spellGrid.parent)
         {
            add(this.spellGrid);
         }
         this.syncPowerVisible();
      }
      
      public function set usePower(param1:Boolean) : void
      {
         this.powerPanel.visible = param1;
         this.syncPowerVisible();
      }
      
      private function syncPowerVisible() : void
      {
         var _loc1_:Boolean = this.powerPanel.visible && Boolean(this.spellGrid.parent);
         if(_loc1_ != Boolean(this.powerPanel.parent))
         {
            if(_loc1_)
            {
               add(this.powerPanel);
            }
            else
            {
               removeChild(this.powerPanel);
            }
         }
      }
      
      public function useResource(param1:Boolean) : Boolean
      {
         var _loc2_:Boolean = !this.goldPanel;
         if(_loc2_)
         {
            this.goldPanel = new ResourcePanel(PCost.GOLD,ResourcePanel.BG | ResourcePanel.CACHE_AS_BITMAP);
            this.crystalPanel = new ResourcePanel(PCost.CRYSTAL,ResourcePanel.BG | ResourcePanel.CACHE_AS_BITMAP);
            this.goldPanel.layoutW = this.crystalPanel.layoutW = 160;
         }
         addChild(this.goldPanel);
         this.goldPanel.useTrack();
         if(param1)
         {
            addChild(this.crystalPanel);
            this.crystalPanel.useTrack();
         }
         return _loc2_;
      }
      
      public function update(param1:Array = null) : void
      {
         var _loc7_:int = 0;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc17_:VSkin = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc2_:int = param1 ? int(param1.length) : int(this.soldierGrid.length);
         var _loc3_:int = 10;
         var _loc4_:int = 18;
         var _loc5_:Boolean = Boolean(this.limiterPanel);
         var _loc6_:int = this.soldierGrid.renderList[0].layoutW;
         _loc7_ = int(this.soldierGrid.measuredHeight);
         var _loc8_:Number = (layoutH - _loc7_) / 2;
         var _loc9_:int = 0;
         var _loc10_:Number = 1;
         var _loc11_:Boolean = Boolean(this.spellGrid.parent);
         if(_loc11_)
         {
            _loc18_ = int(this.spellGrid.measuredWidth);
            _loc19_ = 40;
         }
         var _loc12_:uint = _loc3_ * 2 + _loc18_;
         if(_loc5_)
         {
            _loc12_ += this.limiterPanel.layoutW + _loc4_;
         }
         if(_loc2_ > 0)
         {
            _loc12_ += _loc19_;
         }
         var _loc13_:int = _loc12_ + _loc2_ * _loc6_;
         if(_loc2_ > 1)
         {
            _loc13_ += this.soldierGrid.hGap * (_loc2_ - 1);
         }
         if(_loc13_ > w)
         {
            _loc10_ = w / _loc13_;
            if(_loc10_ < 0.6)
            {
               _loc10_ = 0.6;
               _loc9_ = 35;
               _loc12_ += _loc9_ * 2;
            }
         }
         _loc14_ = Math.round(layoutH - (_loc7_ + _loc8_) * _loc10_);
         if(_loc10_ != this.soldierGrid.scaleX)
         {
            this.spellGrid.scaleX = this.spellGrid.scaleY = this.soldierGrid.scaleX = this.soldierGrid.scaleY = _loc10_;
            if(_loc5_)
            {
               this.limiterPanel.scaleX = this.limiterPanel.scaleY = _loc10_;
            }
            if(this.selectPanel)
            {
               this.selectPanel.setScale(_loc10_,_loc14_);
            }
         }
         if(_loc2_ > 1)
         {
            if(_loc9_ > 0)
            {
               _loc20_ = (w - _loc12_ * _loc10_) / ((_loc6_ + this.soldierGrid.hGap) * _loc10_);
               if(_loc20_ <= 0)
               {
                  _loc20_ = 1;
               }
               else if(_loc20_ > _loc2_)
               {
                  _loc20_ = _loc2_;
               }
            }
            else
            {
               _loc20_ = _loc2_;
            }
         }
         else
         {
            _loc20_ = 1;
         }
         if(_loc20_ != this.soldierGrid.maxRenderer || Boolean(param1))
         {
            if(_loc2_ > 0 != Boolean(this.soldierGrid.parent))
            {
               if(_loc2_ > 0)
               {
                  add(this.soldierGrid);
               }
               else
               {
                  removeChild(this.soldierGrid);
               }
            }
            this.soldierGrid.changeRendererCount(_loc20_,1,param1);
         }
         this.spellGrid.y = _loc14_;
         this.bg.y = this.bg2.y = Math.round(_loc14_ - _loc8_ * _loc10_);
         _loc15_ = _loc3_ * _loc10_;
         var _loc16_:Number = w - _loc15_;
         if(_loc5_)
         {
            this.limiterPanel.x = _loc15_;
            this.limiterPanel.y = this.bg.y;
            _loc15_ += (this.limiterPanel.layoutW + _loc4_) * _loc10_;
         }
         _loc18_ = Math.round(_loc18_ * _loc10_);
         this.spellGrid.x = Math.round(_loc16_ - _loc18_);
         _loc7_ = layoutH * _loc10_;
         _loc6_ = 40;
         if(_loc2_ > 0)
         {
            _loc13_ = this.soldierGrid.measuredWidth + _loc19_;
            if(_loc20_ < _loc2_)
            {
               _loc13_ += _loc9_ * 2;
            }
            this.soldierGrid.x = Math.round(_loc15_ + (_loc16_ - _loc15_ - (_loc13_ * _loc10_ + _loc18_)) / 2);
            if(_loc20_ < _loc2_)
            {
               this.soldierGrid.x += Math.round(_loc9_ * _loc10_);
            }
            this.soldierGrid.y = _loc14_;
            _loc13_ = this.soldierGrid.measuredWidth * _loc10_;
            if(_loc11_)
            {
               if(this.spellGrid.x - this.soldierGrid.x - _loc13_ <= 50)
               {
                  _loc13_ = _loc16_ - this.soldierGrid.x;
               }
               _loc17_ = this.bg2;
            }
            this.bg.setGeometrySize(_loc13_ + _loc6_ * 2,_loc7_,false);
            this.bg.x = this.soldierGrid.x - _loc6_;
         }
         else
         {
            _loc17_ = this.bg;
         }
         if(_loc17_ == this.bg2 != Boolean(this.bg2.parent))
         {
            if(_loc17_ == this.bg2)
            {
               addChildAt(this.bg2,0);
            }
            else
            {
               removeChild(this.bg2);
            }
         }
         if(_loc17_)
         {
            _loc17_.setGeometrySize(_loc18_ + _loc6_ * 2,_loc7_,false);
            _loc17_.x = this.spellGrid.x - _loc6_;
         }
         this.powerPanel.x = w - this.powerPanel.layoutW;
         this.powerPanel.y = _loc14_ - this.powerPanel.layoutH - 20;
         if(this.goldPanel)
         {
            this.crystalPanel.x = this.goldPanel.x = w - this.goldPanel.layoutW;
            this.goldPanel.y = this.powerPanel.y;
            this.crystalPanel.y = this.goldPanel.y - this.crystalPanel.measuredHeight - 8;
         }
         if(this.selectPanel)
         {
            if(this.selectPanel.item.isLock || !this.selectPanel.item.spellShop && this.soldierGrid.getDataProvider().indexOf(this.selectPanel.item) < 0)
            {
               this.reset();
            }
            else
            {
               this.onGridChange();
            }
         }
         if(param1)
         {
            this.setBlackout(Boolean(this.selectPanel));
         }
      }
      
      override protected function customUpdate() : void
      {
         super.customUpdate();
         this.update();
      }
      
      public function getSelectCount() : uint
      {
         return this.selectPanel ? this.selectPanel.getCount() : 0;
      }
      
      public function set soldierLock(param1:Boolean) : void
      {
         if(Boolean(param1) && Boolean(this.selectPanel) && Boolean(this.selectPanel.item.shop))
         {
            this.reset();
         }
         this.soldierGrid.mouseChildren = !param1;
         this.soldierGrid.filters = param1 ? VSkin.GREY_FILTER : null;
      }
      
      public function useLimiter(param1:uint, param2:uint) : void
      {
         if(!this.limiterPanel)
         {
            this.limiterPanel = new LimiterPanel();
            this.limiterPanel.setMax(param2);
            add(this.limiterPanel);
            this.limiterPanel.scaleY = this.limiterPanel.scaleX = this.soldierGrid.scaleX;
         }
         this.limiterPanel.value = param1;
      }
      
      public function removeLimiter() : void
      {
         var _loc1_:LimiterPanel = null;
         if(this.limiterPanel)
         {
            _loc1_ = this.limiterPanel;
            this.limiterPanel = null;
            remove(_loc1_);
         }
      }
      
      public function setLimit(param1:uint) : void
      {
         if(this.limiterPanel)
         {
            this.limiterPanel.value = param1;
         }
         if(this.soldierGrid.mouseChildren == (param1 == 0))
         {
            this.soldierLock = param1 == 0;
         }
      }
      
      public function clear() : void
      {
         if(this.selectPanel)
         {
            remove(this.selectPanel);
            this.selectPanel = null;
         }
         this.powerPanel.removeBuyBt();
         this.powerPanel.filters = null;
         this.soldierLock = false;
         this.removeLimiter();
         if(Boolean(this.goldPanel) && Boolean(this.goldPanel.parent))
         {
            removeChild(this.goldPanel);
            this.goldPanel.removeTrack();
            if(this.crystalPanel.parent)
            {
               removeChild(this.crystalPanel);
               this.crystalPanel.removeTrack();
            }
         }
      }
      
      public function get isEmpty() : Boolean
      {
         return this.spellGrid.length == 0 && this.soldierGrid.length == 0;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.target == this)
         {
            this.reset();
         }
      }
      
      public function focusPanel(param1:VComponent, param2:uint = 15764012) : void
      {
         if(!param1.parent)
         {
            return;
         }
         if(!this.focusSignal)
         {
            this.focusSignal = new Signal(this.onFocusSignal);
            this.focusSignal.delay = 0.2;
            this.focusFilter = [new GlowFilter(param2,1,8,8,8)];
         }
         this.focusSignal.data = param1;
         this.focusSignal.run(1,0,true);
      }
      
      private function onFocusSignal() : void
      {
         var _loc1_:VComponent = this.focusSignal.data;
         if(_loc1_.filters.length == 0 && this.focusSignal.tail > 0)
         {
            _loc1_.filters = this.focusFilter;
         }
         else
         {
            _loc1_.filters = null;
         }
      }
      
      public function set mouseLock(param1:Boolean) : void
      {
         mouseChildren = mouseEnabled = !param1;
      }
   }
}

