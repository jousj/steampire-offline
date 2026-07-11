package game.research
{
   import game.barrack.BarrackDialog;
   import proto.model.PCost;
   import proto.model.PShopUnit;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class ResearchDialog extends BaseDialog
   {
      
      public const grid:VGrid = new VGrid(4,2,ResearchRenderer,null,24,26,VGrid.USE_NULL_DATA);
      
      public const rarDragonPanel:ResourcePanel = new ResourcePanel(PCost.RAR_DRAGON,ResourcePanel.BG | ResourcePanel.PROGRESS);
      
      public const mithrilPanel:ResourcePanel = new ResourcePanel(PCost.MITHRIL,ResourcePanel.BG | ResourcePanel.PROGRESS,UIFactory.INDICATOR_GREEN);
      
      private var component:VComponent;
      
      public function ResearchDialog(param1:String, param2:uint)
      {
         super();
         useSimpleBg(814,638);
         addUnitDialogTitle(param1,param2,false,460);
         this.rarDragonPanel.hint = Lang.getString("rar_dragon_hint");
         this.rarDragonPanel.layoutW = this.mithrilPanel.layoutW = 126;
         add(new VBox(new <VComponent>[this.rarDragonPanel,this.mithrilPanel],8),{
            "top":13,
            "right":68
         });
         add(SkinManager.getEmbed("FeatureSectionBg",VSkin.STRETCH),{
            "wP":100,
            "top":46,
            "h":170
         },1);
         add(SkinManager.getEmbed("TrainGlass"),{
            "hCenter":0,
            "top":210
         });
         add(BarrackDialog.getConnectBg(3,125,186,6),{
            "w":680,
            "hCenter":0,
            "top":283
         });
         add(BarrackDialog.getConnectBg(3,125,186,6),{
            "w":680,
            "hCenter":0,
            "top":472
         });
         this.grid.dispatcher = this;
         add(this.grid,{
            "hCenter":0,
            "top":244
         });
         UIFactory.useGridControlH43(this.grid);
      }
      
      public function setActive(param1:PShopUnit, param2:Number, param3:Number) : void
      {
         if(this.component)
         {
            remove(this.component);
         }
         this.component = new ResearchActivePanel(param1,param2,param3);
         this.component.dispatcher = this;
         add(this.component,{
            "left":70,
            "right":70,
            "top":90
         });
      }
      
      public function setPrompt() : void
      {
         if(this.component)
         {
            remove(this.component);
         }
         this.component = new VText(Lang.getString("research_prompt"),VText.CENTER | VText.MIDDLE,Style.metalRGB);
         add(this.component,{
            "left":40,
            "right":40,
            "top":77,
            "h":118
         });
      }
   }
}

