package ui.common
{
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class BlockDialog extends BaseDialog
   {
      
      public const topPanel:VComponent = new VComponent();
      
      public const bottomPanel:VComponent = new VComponent();
      
      private var vGap:int;
      
      public function BlockDialog(param1:String, param2:int, param3:int = 22, param4:int = 8, param5:int = 8)
      {
         super();
         layoutW = param2 + 2 * param3;
         if(param3 > 0)
         {
            param3 = -param3;
         }
         this.topPanel.top = 70 + param4;
         param4 += 12;
         this.vGap = param4 + param5;
         param5 += 12;
         this.bottomPanel.add(SkinManager.getEmbed("FeatureSectionBg",VSkin.STRETCH_BG),{
            "left":param3,
            "right":param3,
            "top":-param5,
            "bottom":-param5
         });
         add(this.bottomPanel,{
            "bottom":param5,
            "w":param2,
            "hCenter":0
         });
         this.topPanel.add(SkinManager.getEmbed("FeatureDialogBg",VSkin.STRETCH_BG),{
            "left":param3,
            "right":param3,
            "bottom":-param4,
            "top":-16 - param4
         });
         add(this.topPanel,{
            "w":param2,
            "hCenter":0
         });
         addHeader();
         addDialogTitle(param1);
      }
      
      override protected function calcContentSize() : void
      {
         contentH = this.topPanel.measuredHeight + this.bottomPanel.measuredHeight + this.topPanel.vPadding + this.bottomPanel.vPadding + this.vGap;
      }
   }
}

