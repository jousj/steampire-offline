package game.board
{
   import engine.signal.Signal;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import logic.ShopLogic;
   import model.vo.VOResourceSpec;
   import proto.model.PCost;
   import ui.Style;
   import ui.common.CircleButton;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class UnitMenuButton extends CircleButton
   {
      
      public var handler:Function;
      
      public var isWeak:Boolean;
      
      public var argList:Array = [null];
      
      private var component:VComponent;
      
      private var signal:Signal;
      
      public function UnitMenuButton(param1:Boolean = true)
      {
         super(new VSkin(),CircleButton.GOLD);
         this.isWeak = param1;
         sizeCustom(60,36);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public static function createPricePanel(param1:PCost, param2:uint, param3:uint, param4:uint = 0) : PricePanel
      {
         var _loc5_:PricePanel = new PricePanel(param2,param3,PricePanel.GLOW_FILTER,1,param4);
         _loc5_.skin.filters = [new GlowFilter(Style.yellowRGB,1,2,2,2)];
         if(param1)
         {
            _loc5_.assignCost(param1);
         }
         return _loc5_;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.handler != null)
         {
            this.handler.apply(null,this.argList);
         }
      }
      
      public function changeView(param1:String, param2:String, param3:Boolean = true) : void
      {
         this.hint = param2;
         var _loc4_:VSkin = icon as VSkin;
         if(param3)
         {
            SkinManager.applyEmbed(_loc4_,param1);
         }
         else
         {
            SkinManager.applyExternal(_loc4_,param1,null,SkinManager.LOAD_CLIP);
         }
      }
      
      public function change(param1:String, param2:Boolean, param3:String, param4:Function, ... rest) : void
      {
         var _loc6_:* = undefined;
         this.changeView(param1,param3,param2);
         this.handler = param4;
         for each(_loc6_ in rest)
         {
            this.argList.push(_loc6_);
         }
      }
      
      public function changeHandler(param1:Function, ... rest) : void
      {
         var _loc3_:* = undefined;
         this.handler = param1;
         for each(_loc3_ in rest)
         {
            this.argList.push(_loc3_);
         }
      }
      
      public function applyPrice(param1:PCost) : void
      {
         if(this.component is PricePanel)
         {
            (this.component as PricePanel).assignCost(param1);
         }
         else
         {
            this.removeComponent();
            this.component = createPricePanel(param1,16,14,layoutW - 10);
            add(this.component,{
               "hCenter":0,
               "bottom":2
            });
         }
      }
      
      public function applyPriceList(param1:Array) : void
      {
         var _loc2_:PCost = null;
         if(param1.length == 1)
         {
            this.applyPrice(param1[0]);
         }
         else
         {
            this.removeComponent();
            this.component = new VBox(null,0,VBox.VERTICAL);
            for each(_loc2_ in param1)
            {
               this.component.add(createPricePanel(_loc2_,16,14,layoutW - 10));
            }
            add(this.component,{
               "hCenter":0,
               "top":42
            });
         }
      }
      
      private function removeComponent() : void
      {
         if(this.signal)
         {
            this.signal.stop();
            this.signal = null;
         }
         if(this.component)
         {
            remove(this.component);
            this.component = null;
         }
      }
      
      public function deactivation() : void
      {
         this.removeComponent();
         if(icon.layoutW == 0)
         {
            icon.setSize(36,36);
         }
         this.handler = null;
         this.argList.length = 1;
         this.argList[0] = null;
      }
      
      public function trackSpeedup(param1:Number, param2:uint = 0) : void
      {
         var _loc3_:PricePanel = null;
         if(param1 > 0)
         {
            if(!(this.component is PricePanel))
            {
               this.applyPrice(null);
            }
            _loc3_ = this.component as PricePanel;
            _loc3_.useCheck = true;
            _loc3_.runTrackSpeedup(param1,0,0,param2);
         }
      }
      
      private function get resTrackText() : ResTrackText
      {
         if(!(this.component is ResTrackText))
         {
            this.removeComponent();
            this.component = new ResTrackText(VText.CONTAIN_CENTER);
            add(this.component,{
               "wP":100,
               "bottom":0
            });
         }
         return this.component as ResTrackText;
      }
      
      public function trackResource(param1:VOResourceSpec, param2:Boolean = false) : void
      {
         if(param2)
         {
            this.resTrackText.value = String(param1.capacityCur);
         }
         else
         {
            this.resTrackText.track(this,param1);
         }
      }
      
      public function applyResource(param1:uint) : void
      {
         this.resTrackText.value = param1.toString();
      }
      
      public function trackFree(param1:Number) : void
      {
         param1 -= ShopLogic.getSpeedupFreeTime();
         if(param1 > 0)
         {
            if(!this.signal)
            {
               this.signal = new Signal();
            }
            this.signal.handler = this.onFree;
            this.signal.delayCall(param1);
         }
         else
         {
            this.onFree();
         }
      }
      
      private function onFree() : void
      {
         this.applyPrice(PCost.create(PCost.GOLD,0));
      }
      
      override public function dispose() : void
      {
         if(this.signal)
         {
            this.signal.stop();
            this.signal = null;
         }
         removeEventListener(MouseEvent.CLICK,this.onClick);
         this.handler = null;
         this.argList = null;
         super.dispose();
      }
   }
}

