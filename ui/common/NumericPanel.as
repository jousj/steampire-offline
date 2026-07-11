package ui.common
{
   import flash.events.MouseEvent;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class NumericPanel extends VComponent
   {
      
      private var $min:uint = 1;
      
      private var $max:uint;
      
      private var $value:uint;
      
      private var text:VText = new VText(null,VText.CONTAIN_CENTER,Style.metalRGB,18);
      
      public function NumericPanel(param1:uint, param2:uint = 1, param3:uint = 1, param4:String = null, param5:uint = 0)
      {
         super();
         var _loc6_:int = param5 > 0 ? 28 : 0;
         setSize(96 + _loc6_ * 2,34);
         if(param2 == 0)
         {
            param2 = 1;
         }
         var _loc7_:VSkin = SkinManager.getEmbed("ChBox",VSkin.STRETCH);
         add(_loc7_,{
            "left":18 + _loc6_,
            "right":18 + _loc6_,
            "hP":100
         });
         if(param4)
         {
            _loc7_.hint = param4;
            _loc7_.mouseEnabled = true;
         }
         var _loc8_:VButton = UIFactory.createNavButton(false);
         if(param2 > 1)
         {
            _loc8_.hint = -param2;
         }
         _loc8_.addClickListener(this.onChange,-param2);
         add(_loc8_,{
            "left":_loc6_,
            "w":20,
            "h":32,
            "vCenter":1
         });
         _loc8_ = UIFactory.createNavButton(true);
         if(param2 > 1)
         {
            _loc8_.hint = "+" + param2;
         }
         _loc8_.addClickListener(this.onChange,param2);
         add(_loc8_,{
            "right":_loc6_,
            "w":20,
            "h":32,
            "vCenter":1
         });
         this.$min = param3 == 0 ? 1 : param3;
         this.$max = param1 == 0 ? 1 : param1;
         add(this.text,{
            "left":20 + _loc6_,
            "right":20 + _loc6_,
            "vCenter":1
         });
         this.value = 1;
         if(param5 > 0)
         {
            _loc6_ = (_loc6_ >> 1) + 1;
            add(SkinManager.getEmbed("FrLine",VSkin.STRETCH),{
               "left":_loc6_,
               "right":_loc6_,
               "h":23,
               "vCenter":0
            },0);
            addChild(this.createExButton(param5));
            _loc8_ = this.createExButton(param5,VSkin.FLIP_X);
            _loc8_.right = 0;
            addChild(_loc8_);
         }
      }
      
      private function createExButton(param1:uint, param2:uint = 0) : VButton
      {
         var _loc3_:VButton = new VButton();
         _loc3_.add(SkinManager.getEmbed("NavBt",param2),{
            "w":16,
            "h":26
         });
         _loc3_.add(SkinManager.getEmbed("NavBt",param2),{
            "w":16,
            "h":26,
            "left":10
         },param2 == 0 ? 1 : 0);
         _loc3_.vCenter = 0;
         _loc3_.addClickListener(this.onChange);
         if(param2 != 0)
         {
            _loc3_.data = param1;
            _loc3_.hint = "+" + param1;
         }
         else
         {
            _loc3_.hint = _loc3_.data = -param1;
         }
         return _loc3_;
      }
      
      public function set value(param1:uint) : void
      {
         if(param1 > this.$max)
         {
            param1 = this.$max;
         }
         else if(param1 < this.$min)
         {
            param1 = this.$min;
         }
         if(this.$value != param1)
         {
            this.$value = param1;
            this.text.value = param1.toString();
         }
      }
      
      public function get value() : uint
      {
         return this.$value;
      }
      
      public function set min(param1:uint) : void
      {
         if(param1 > 0 && param1 <= this.$max)
         {
            this.$min = param1;
            if(this.$value < param1)
            {
               this.value = param1;
            }
         }
      }
      
      public function set max(param1:uint) : void
      {
         if(param1 > 0 && param1 >= this.$min)
         {
            this.$max = param1;
            if(this.$value > param1)
            {
               this.value = param1;
            }
         }
      }
      
      public function get max() : uint
      {
         return this.$max;
      }
      
      private function onChange(param1:MouseEvent) : void
      {
         var _loc2_:uint = this.$value;
         var _loc3_:int = this.$value + (param1.currentTarget as VButton).data;
         if(_loc3_ <= 0)
         {
            _loc3_ = 1;
         }
         this.value = _loc3_;
         if(_loc2_ != this.$value)
         {
            dispatcher.dispatchEvent(new VEvent(VEvent.CHANGE,this.$value));
         }
      }
   }
}

