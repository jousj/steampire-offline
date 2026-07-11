package game.barrack
{
   import game.my.MyPanel;
   import proto.model.PCost;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseTabDialog;
   import ui.common.RectButton;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VPager;
   import ui.vbase.VProgressBar;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class BarrackDialog extends BaseTabDialog
   {
      
      public static const INC:uint = 1;
      
      public static const INC_5:uint = 2;
      
      public static const DEC:uint = 3;
      
      public static const SPEEDUP:uint = 4;
      
      public static const INFO:uint = 5;
      
      public static const CLEAR:uint = 6;
      
      public const oilPanel:ResourcePanel = new ResourcePanel(PCost.OIL,ResourcePanel.BG | ResourcePanel.PROGRESS);
      
      public const mithrilPanel:ResourcePanel = new ResourcePanel(PCost.MITHRIL,ResourcePanel.BG | ResourcePanel.PROGRESS,UIFactory.INDICATOR_GREEN);
      
      public const goldPanel:ResourcePanel = new ResourcePanel(PCost.GOLD,ResourcePanel.BG | ResourcePanel.PROGRESS);
      
      public const buyGrid:VGrid = new VGrid(4,2,BarrackBuyRenderer,null,24,22,VGrid.USE_NULL_DATA | VGrid.FILTER_MODE);
      
      public const prodGrid:VGrid = new VGrid(0,1,BarrackProdRenderer,null,12,0,VGrid.USE_NULL_DATA);
      
      public const armyBar:VProgressBar = UIFactory.createProgressBar(UIFactory.INDICATOR_GREEN);
      
      public const capacityText:VText = UIFactory.createYellowText(null,0,20);
      
      public var goldTab:VButton;
      
      public var lockPanel:VComponent;
      
      public function BarrackDialog(param1:String, param2:uint, param3:uint = 0, param4:Boolean = false)
      {
         super();
         setSize(814,638);
         add(SkinManager.getEmbed("HintBg",VSkin.STRETCH),{
            "left":25,
            "right":7,
            "top":46,
            "h":192
         },2);
         addUnitDialogTitle(param1,param2,false,344);
         this.mithrilPanel.layoutW = 126;
         this.goldPanel.layoutW = 140;
         add(new VBox(new <VComponent>[this.mithrilPanel,this.oilPanel,this.goldPanel],8),{
            "top":13,
            "right":68
         });
         add(SkinManager.getEmbed("TrainGlass",VSkin.STRETCH),{
            "left":24,
            "right":8,
            "bottom":14,
            "h":390
         });
         add(this.armyBar,{
            "left":72,
            "top":96,
            "right":40,
            "h":36
         });
         add(SkinManager.getEmbed("FeatureIconBg"),{
            "left":45,
            "top":91,
            "w":48
         });
         add(SkinManager.getEmbed("ArmyCapacityIcon"),{
            "left":48,
            "top":89,
            "w":40
         });
         add(new VText(Lang.getString("camp_capacity") + ":",VText.CONTAIN_CENTER,Style.metalRGB),{
            "hCenter":10,
            "top":77
         });
         add(this.capacityText,{
            "hCenter":10,
            "top":104
         });
         this.prodGrid.dispatcher = this;
         this.prodGrid.renderList[0].setSize(78,76);
         add(this.prodGrid,{
            "top":146,
            "left":52,
            "right":36
         });
         UIFactory.useGridControlNav(this.prodGrid,UIFactory.addNavBt18);
         this.buyGrid.add(getConnectBg(3,125,186,6),{
            "w":680,
            "hCenter":0,
            "top":41
         });
         this.buyGrid.add(getConnectBg(3,125,186,6),{
            "w":680,
            "hCenter":0,
            "top":227
         });
         this.buyGrid.dispatcher = this;
         add(this.buyGrid,{
            "hCenter":10,
            "bottom":32
         });
         UIFactory.useGridControlH43(this.buyGrid,true,0,this.addPager);
         add(new VFill(4348000),{
            "left":25,
            "top":230,
            "w":2,
            "h":140
         });
         addTab("BarrackIcon",Lang.getString("common_army"),param3);
         addTab("EliteIcon",Lang.getString("elite_army"),param3);
         var _loc5_:VButton = addTab("GoldIcon",Lang.getString("gold_army"),param3);
         if(param4)
         {
            MyPanel.changeButtonCount(_loc5_,-1);
            this.goldTab = _loc5_;
         }
      }
      
      public static function getConnectBg(param1:uint, param2:int, param3:int, param4:int) : VComponent
      {
         var _loc5_:VComponent = new VComponent();
         _loc5_.addStretch(SkinManager.getEmbed("ConnectBg",VSkin.STRETCH));
         var _loc6_:uint = 0;
         while(_loc6_ < param1)
         {
            _loc5_.add(SkinManager.getEmbed("MetalCorrosion"),{
               "left":param2 + _loc6_ * param3,
               "top":param4
            });
            _loc6_++;
         }
         return _loc5_;
      }
      
      private function addPager(param1:VGrid, param2:VPager) : void
      {
         param1.add(param2,{
            "hCenter":0,
            "bottom":-44
         });
      }
      
      public function createClanLock(param1:String, param2:String, param3:Function, param4:Object) : void
      {
         this.lockPanel = new VComponent();
         this.lockPanel.addStretch(SkinManager.getEmbed("RaidLockBg",VSkin.STRETCH));
         this.lockPanel.add(SkinManager.getEmbed("LockIcon"),{
            "left":-36,
            "vCenter":0
         });
         this.lockPanel.add(UIFactory.createYellowText(Lang.getString(param2),VText.CENTER | VText.MIDDLE,20),{
            "left":50,
            "right":36,
            "vCenter":-2,
            "h":83
         });
         var _loc5_:RectButton = new RectButton(Lang.getString(param1),RectButton.h42);
         _loc5_.addClickListener(param3,param4);
         this.lockPanel.add(_loc5_,{
            "hCenter":0,
            "bottom":-17
         });
         this.lockPanel.assignLayout({
            "left":76,
            "right":30,
            "vCenter":106,
            "h":140
         });
      }
      
      public function set lockPanelVisible(param1:Boolean) : void
      {
         if(Boolean(this.lockPanel) && param1 != Boolean(this.lockPanel.parent))
         {
            if(param1)
            {
               add(this.lockPanel);
            }
            else
            {
               remove(this.lockPanel,false);
            }
         }
      }
   }
}

