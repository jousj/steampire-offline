package game.barrack
{
   import model.ui.VOBarrackItem;
   import ui.Style;
   import ui.common.CircleButton;
   import ui.game.SquareSoldierPanel;
   import ui.vbase.VRenderer;
   import ui.vbase.VText;
   
   public class BarrackProdRenderer extends VRenderer
   {
      
      private const soldierPanel:SquareSoldierPanel = new SquareSoldierPanel();
      
      private var decBt:CircleButton;
      
      private var decCount:uint;
      
      public function BarrackProdRenderer()
      {
         super();
         setSize(96 * 0.66,92 * 0.66);
         addStretch(this.soldierPanel);
      }
      
      public static function calcDecCount(param1:uint) : uint
      {
         if(param1 >= 50)
         {
            return 10;
         }
         if(param1 >= 20)
         {
            return 5;
         }
         return 1;
      }
      
      private function addDecBt() : void
      {
         this.decBt = new CircleButton(null,CircleButton.TEAL);
         var _loc1_:VText = new VText(null,VText.CONTAIN_CENTER | VText.MIDDLE);
         Style.applyGlowFormat(_loc1_,16,Style.yellowRGB,Style.grayGlowRGB);
         this.decBt.setIcon(_loc1_,{
            "w":26,
            "hCenter":0,
            "vCenter":0
         });
         add(this.decBt,{
            "right":-6,
            "top":-6,
            "w":30,
            "h":30
         });
         this.decBt.addVarianceListener(this,BarrackDialog.DEC);
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc2_:VOBarrackItem = param1 as VOBarrackItem;
         if(_loc2_)
         {
            if(!this.decBt)
            {
               this.addDecBt();
            }
            else
            {
               this.decBt.visible = true;
            }
            this.decBt.data = _loc2_;
            _loc3_ = calcDecCount(_loc2_.count);
            if(_loc3_ != this.decCount)
            {
               this.decCount = _loc3_;
               (this.decBt.icon as VText).value = "-" + _loc3_;
            }
            this.soldierPanel.assignShopUnit(_loc2_.shop,_loc2_.count);
         }
         else if(this.decBt)
         {
            this.decBt.visible = false;
            this.soldierPanel.clear();
         }
      }
   }
}

