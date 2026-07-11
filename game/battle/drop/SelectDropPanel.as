package game.battle.drop
{
   import flash.events.MouseEvent;
   import model.ui.VOBattleItem;
   import ui.common.CircleButton;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VEvent;
   
   public class SelectDropPanel extends InfoDropPanel
   {
      
      public var item:VOBattleItem;
      
      private const box:VBox = new VBox(null,3);
      
      private const btList:Vector.<CircleButton> = new Vector.<CircleButton>();
      
      private var default_drop_value:uint = 1;
      
      private var cacheCount:uint;
      
      private var selectBt:CircleButton;
      
      public function SelectDropPanel()
      {
         super(86,86,2,false);
         setSize(94,94);
         bg.mouseEnabled = true;
         bg.addListener(MouseEvent.CLICK,this.onClick);
         this.btList.push(this.createModeButton(1),this.createModeButton(5),this.createModeButton(10),this.createModeButton(25));
         addChild(this.box);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         dispatchEvent(new VEvent(VEvent.SELECT));
      }
      
      private function createModeButton(param1:uint) : CircleButton
      {
         var _loc2_:CircleButton = new CircleButton(null,CircleButton.TEAL);
         _loc2_.cacheAsBitmap = true;
         _loc2_.variance = param1;
         _loc2_.sizeCustom(32);
         _loc2_.applyText(param1.toString(),16,1);
         _loc2_.addClickListener(this.onSelect);
         return _loc2_;
      }
      
      private function onSelect(param1:Object) : void
      {
         var _loc2_:CircleButton = (param1 is MouseEvent ? (param1 as MouseEvent).currentTarget : param1) as CircleButton;
         if(_loc2_ != this.selectBt)
         {
            if(this.selectBt)
            {
               this.selectBt.mouseEnabled = true;
               this.selectBt.changeSkin(CircleButton.TEAL);
            }
            if(_loc2_)
            {
               _loc2_.mouseEnabled = false;
               _loc2_.changeSkin(CircleButton.GOLD);
               this.item.select = _loc2_.variance;
            }
            this.selectBt = _loc2_;
         }
      }
      
      public function setData(param1:VOBattleItem) : void
      {
         var _loc4_:* = 0;
         var _loc5_:CircleButton = null;
         var _loc2_:Boolean = param1 != this.item;
         this.item = param1;
         if(this.cacheCount != param1.count)
         {
            this.cacheCount = param1.count;
            this.box.removeAll(false);
            if(Boolean(param1.shop) && this.cacheCount > 1)
            {
               this.box.add(this.btList[0]);
               if(this.cacheCount > 35)
               {
                  this.box.add(this.btList[2]);
                  this.box.add(this.btList[3]);
               }
               else if(this.cacheCount >= 2)
               {
                  this.box.add(this.btList[1]);
                  if(this.cacheCount >= 6)
                  {
                     this.box.add(this.btList[2]);
                  }
               }
            }
         }
         var _loc3_:uint = this.box.list.length;
         if(_loc3_ > 0)
         {
            if(_loc2_ || Boolean(this.selectBt) && Boolean(!this.selectBt.parent))
            {
               if(param1.select > 0)
               {
                  _loc4_ = int(_loc3_ - 1);
                  while(_loc4_ >= 0)
                  {
                     _loc5_ = this.box.list[_loc4_] as CircleButton;
                     if(param1.select >= _loc5_.variance)
                     {
                        break;
                     }
                     _loc4_--;
                  }
               }
               else
               {
                  _loc5_ = this.box.list[_loc3_ - 1] as CircleButton;
               }
               this.onSelect(_loc5_);
            }
         }
         else if(this.selectBt)
         {
            this.onSelect(null);
         }
         assign(param1,_loc2_,bg);
      }
      
      public function set drop_value(param1:uint) : void
      {
         this.resetSelect();
         this.boxVisible(false);
         this.default_drop_value = param1;
      }
      
      public function getCount() : uint
      {
         return this.selectBt ? this.selectBt.variance : this.default_drop_value;
      }
      
      public function btLock(param1:Boolean) : void
      {
         var _loc2_:CircleButton = null;
         for each(_loc2_ in this.btList)
         {
            _loc2_.disabled = param1;
         }
      }
      
      public function boxVisible(param1:Boolean) : void
      {
         this.box.visible = param1;
      }
      
      public function getButton(param1:uint) : VButton
      {
         var _loc2_:CircleButton = null;
         for each(_loc2_ in this.btList)
         {
            if(_loc2_.variance == param1)
            {
               return _loc2_;
            }
         }
         return this.btList[0];
      }
      
      public function resetSelect() : void
      {
         if(this.selectBt)
         {
            this.onSelect(null);
         }
      }
      
      public function sync() : void
      {
         assign(this.item,false,bg);
      }
      
      public function setScale(param1:Number, param2:Number) : void
      {
         scaleX = scaleY = param1;
         this.box.scaleX = this.box.scaleY = 1 / param1;
         this.box.top = -35 * this.box.scaleY;
         this.box.hCenter = (param1 - 1) * layoutW / 2;
         this.box.syncLayout();
         y = Math.round(-13 * param1 + param2);
      }
   }
}

