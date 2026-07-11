package game.battle.drop
{
   import flash.events.MouseEvent;
   import model.ui.VOBattleItem;
   import ui.vbase.VButton;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VRenderer;
   
   public class DropRenderer extends VRenderer
   {
      
      public var item:VOBattleItem;
      
      private const infoPanel:InfoDropPanel = new InfoDropPanel(74,70,2,true);
      
      private const bt:VButton = VButton.create(this.infoPanel,{
         "wP":100,
         "hP":100
      });
      
      private var isBlackout:Boolean;
      
      private var blackoutFill:VFill;
      
      public function DropRenderer()
      {
         super();
         mouseEnabled = false;
         setSize(80,80);
         addStretch(this.bt);
         this.bt.cacheAsBitmap = true;
         this.bt.addClickListener(this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.item.isLock)
         {
            dispatchVarianceEvent(0,this.item);
         }
         else
         {
            dispatcher.dispatchEvent(new VEvent(VEvent.SELECT,this));
         }
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:Boolean = this.item != param1;
         this.item = param1 as VOBattleItem;
         this.infoPanel.assign(this.item,_loc2_,this.bt);
         var _loc3_:Boolean = this.item.count <= 0 || this.item.isLock && !this.item.isWorker;
         if(_loc3_ != this.bt.disabled)
         {
            this.bt.disabled = _loc3_;
            this.applyBlackout(false);
            if(this.isBlackout || _loc3_)
            {
               this.applyBlackout(true);
            }
         }
      }
      
      public function useBlackout(param1:Boolean) : void
      {
         if(this.isBlackout != param1)
         {
            this.isBlackout = param1;
            if(!this.bt.disabled)
            {
               this.applyBlackout(param1);
            }
         }
      }
      
      private function applyBlackout(param1:Boolean) : void
      {
         if(param1 != Boolean(this.blackoutFill))
         {
            if(param1)
            {
               this.blackoutFill = this.bt.disabled ? new VFill(8158332,0.3) : new VFill(0,0.2,4);
               this.bt.add(this.blackoutFill,{
                  "left":2,
                  "top":2,
                  "right":2,
                  "bottom":2
               });
            }
            else
            {
               this.bt.remove(this.blackoutFill);
               this.blackoutFill = null;
            }
         }
      }
   }
}

