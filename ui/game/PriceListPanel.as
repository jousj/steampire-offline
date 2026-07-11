package ui.game
{
   import proto.model.PCost;
   import proto.model.PShopUnit;
   import proto.tuples.str_uint;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.VBox;
   import ui.vbase.VDock;
   import ui.vbase.VText;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class PriceListPanel extends VDock
   {
      
      public var useCostCheck:Boolean;
      
      public var priceMode:uint = 1;
      
      public var priceGap:uint = 2;
      
      public var fontSize:uint = 18;
      
      public const box:VBox = new VBox();
      
      private var iconSize:uint = 24;
      
      private var textMaxW:uint;
      
      private var costLayoutH:uint;
      
      public function PriceListPanel(param1:uint = 7, param2:uint = 0)
      {
         super(param2);
         this.box.gap = param1;
         addChild(this.box);
      }
      
      public function setStyle(param1:uint, param2:uint) : void
      {
         this.iconSize = param1;
         this.fontSize = param2;
      }
      
      public function assignList(param1:Array) : void
      {
         var _loc2_:Object = null;
         this.box.removeAll();
         for each(_loc2_ in param1)
         {
            this.box.list.push(_loc2_ is PCost ? this.getPricePanel(_loc2_ as PCost) : this.getSoldierPanel(_loc2_ as str_uint));
         }
         this.box.addAll();
      }
      
      public function assignCost(param1:PCost) : void
      {
         this.box.removeAll();
         this.box.add(this.getPricePanel(param1));
      }
      
      public function addCost(param1:PCost) : void
      {
         this.box.add(this.getPricePanel(param1));
      }
      
      public function addPricePanel(param1:PricePanel) : void
      {
         this.box.add(param1);
      }
      
      public function assignTime(param1:Number, param2:Boolean = true) : void
      {
         var _loc3_:PricePanel = this.getPricePanel(null);
         _loc3_.assignTime(param1);
         if(param2)
         {
            this.box.removeAll();
         }
         this.box.add(_loc3_);
      }
      
      public function setAdditionalMode(param1:Boolean, param2:Boolean = true) : void
      {
         var _loc3_:PricePanel = null;
         for each(_loc3_ in this.box.list)
         {
            _loc3_.setAdditionalMode(param1,param2);
         }
      }
      
      public function getPricePanel(param1:PCost) : PricePanel
      {
         var _loc2_:PricePanel = new PricePanel(this.iconSize,this.fontSize,this.priceMode,this.priceGap,this.textMaxW);
         _loc2_.useCheck = this.useCostCheck;
         _loc2_.layoutH = this.costLayoutH;
         _loc2_.mouseEnabled = true;
         if(param1)
         {
            _loc2_.assignCost(param1);
            if(param1.variance == PCost.UNKNOWN)
            {
               _loc2_.hint = Lang.getString(param1.value);
               _loc2_.text.value = null;
            }
            else
            {
               _loc2_.hint = Lang.getString(CostHelper.getKind(param1.variance));
            }
         }
         return _loc2_;
      }
      
      private function getSoldierPanel(param1:str_uint) : SquareSoldierPanel
      {
         var _loc2_:SquareSoldierPanel = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:PShopUnit = null;
         _loc2_ = new SquareSoldierPanel();
         _loc2_.setSize(this.costLayoutH,this.costLayoutH);
         if(param1.field_0.indexOf("sp_") == 0)
         {
            _loc3_ = uint(Facade.manualProxy.getSpellShop(param1.field_0).ssp_level);
            _loc4_ = 1;
         }
         else
         {
            _loc5_ = Facade.manualProxy.getSoldierShop(param1.field_0);
            _loc3_ = _loc5_.su_level;
            _loc4_ = _loc5_.su_model_level;
         }
         _loc2_.show(param1.field_0 + _loc4_ + "_m",_loc3_);
         _loc2_.hint = StringHelper.getUnitName(param1.field_0,_loc3_);
         _loc2_.add(UIFactory.createYellowText(param1.field_1.toString(),VText.CONTAIN_CENTER,this.fontSize),{
            "wP":100,
            "bottom":0
         });
         return _loc2_;
      }
      
      public function useVertical(param1:uint = 38, param2:uint = 46, param3:uint = 60) : void
      {
         this.iconSize = param1;
         this.costLayoutH = param2;
         this.textMaxW = param3;
         this.priceGap = 0;
         this.priceMode |= PricePanel.VERTICAL;
      }
      
      public function setCustomColor(param1:uint, param2:uint, param3:Boolean) : void
      {
         var _loc5_:PricePanel = null;
         var _loc4_:* = int(this.box.list.length - 1);
         while(_loc4_ >= 0)
         {
            _loc5_ = this.box.list[_loc4_] as PricePanel;
            if(_loc5_)
            {
               _loc5_.text.setColor(param1);
               _loc5_.text.syncFormat();
               if(param3)
               {
                  Style.applyDefaultFilter(_loc5_.text,this.fontSize,param2);
               }
            }
            _loc4_--;
         }
      }
   }
}

