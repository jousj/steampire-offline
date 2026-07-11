package game.clan.war
{
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VPager;
   import ui.vbase.VText;
   
   public class WarLogsDialog extends BaseDialog
   {
      
      public const panel:VComponent = new VComponent();
      
      public const grid:VGrid = new VGrid(1,8,WarLogRenderer,null,0,0,VGrid.H_STRETCH);
      
      private const logBt:RectButton = new RectButton(Lang.getString("war_log"),RectButton.h30);
      
      private var titleText:VComponent;
      
      private var text:VText;
      
      public function WarLogsDialog()
      {
         super();
         useSimpleBg(814,634);
         add(this.panel,{
            "w":778,
            "top":80,
            "hCenter":0
         });
      }
      
      public function init() : void
      {
         this.logBt.top = 81;
         this.logBt.addVarianceListener(this,WarVariance.LOG);
         this.panel.addChild(this.logBt);
         UIFactory.addGridWithBg(this.grid,this.panel,true,120,8,8,false);
         UIFactory.useGridControl(this.grid,UIFactory.addNavBt30,this.addPager);
         this.grid.add(new VFill(16777215,0.15),{
            "right":0,
            "hP":100,
            "w":121
         });
      }
      
      private function addPager(param1:VGrid, param2:VPager) : void
      {
         param1.add(param2,{
            "hCenter":0,
            "bottom":-57
         });
      }
      
      public function assign(param1:String, param2:Array = null) : void
      {
         this.grid.setDataProvider(param2);
         if(param1)
         {
            if(!this.text)
            {
               this.text = new VText(null,VText.CENTER,Style.darkKhakiRGB);
               this.grid.add(this.text,{
                  "vCenter":1,
                  "left":50,
                  "right":50
               });
            }
            this.text.value = Lang.getString(param1);
         }
         else if(this.text)
         {
            this.grid.remove(this.text);
            this.text = null;
         }
      }
      
      public function setClanType(param1:Boolean, param2:String, param3:Array = null) : void
      {
         if(param1)
         {
            this.logBt.right = 82;
            this.logBt.left = VComponent.EMPTY;
         }
         else
         {
            this.logBt.left = 82;
            this.logBt.right = VComponent.EMPTY;
         }
         this.logBt.data = param3 ? param3 : !param1;
         if(this.titleText)
         {
            remove(this.titleText);
         }
         this.titleText = addDialogTitle(Lang.getPatternString("war_clan_log","__NAME__",param2));
         this.logBt.syncLayout();
      }
   }
}

