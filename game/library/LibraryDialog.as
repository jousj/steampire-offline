package game.library
{
   import game.barrack.BarrackDialog;
   import proto.model.PCost;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class LibraryDialog extends BaseDialog
   {
      
      public const buyGrid:VGrid = new VGrid(4,2,SpellBuyRenderer,null,24,22,VGrid.USE_NULL_DATA);
      
      public const prodGrid:VGrid = new VGrid(5,1,SpellProdRenderer,null,20,0,VGrid.USE_NULL_DATA);
      
      public const rubyPanel:ResourcePanel = new ResourcePanel(PCost.RUBY,ResourcePanel.BG);
      
      public function LibraryDialog(param1:String, param2:uint)
      {
         super();
         useSimpleBg(814,638);
         addUnitDialogTitle(param1,param2,false);
         add(SkinManager.getEmbed("FeatureSectionBg",VSkin.STRETCH),{
            "wP":100,
            "top":46,
            "h":184
         },1);
         add(new VText(Lang.getString("spell_stack"),VText.CONTAIN_CENTER,Style.metalRGB,16),{
            "left":20,
            "right":20,
            "top":84
         });
         add(this.prodGrid,{
            "top":110,
            "hCenter":0
         });
         this.prodGrid.dispatcher = this;
         UIFactory.useGridControlNav(this.prodGrid,UIFactory.addNavBt18);
         add(SkinManager.getEmbed("TrainGlass",VSkin.STRETCH),{
            "hCenter":0,
            "top":224,
            "h":396
         });
         add(BarrackDialog.getConnectBg(3,125,186,6),{
            "w":680,
            "hCenter":0,
            "bottom":266
         });
         add(BarrackDialog.getConnectBg(3,125,186,6),{
            "w":680,
            "hCenter":0,
            "bottom":84
         });
         this.buyGrid.dispatcher = this;
         add(this.buyGrid,{
            "hCenter":0,
            "bottom":42
         });
         UIFactory.useGridControlH43(this.buyGrid,false);
         add(this.rubyPanel,{
            "top":13,
            "right":68
         });
         this.rubyPanel.setData(Facade.userProxy.ruby);
      }
   }
}

