package game.guard
{
   import engine.units.Build;
   import game.barrack.BarrackBuyRenderer;
   import game.barrack.BarrackDialog;
   import game.barrack.BarrackProdRenderer;
   import proto.model.PCost;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseTabDialog;
   import ui.common.CircleButton;
   import ui.common.RectButton;
   import ui.game.PricePanel;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   import ui.vbase.VProgressBar;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class GuardDialog extends BaseTabDialog
   {
      
      public const buyGrid:VGrid;
      
      public const configGrid:VGrid;
      
      public const removeBt:CircleButton;
      
      public const oilPanel:ResourcePanel;
      
      public const buyAll:RectButton;
      
      public var addBt:RectButton;
      
      public var tabPanel:TabPanelGuard;
      
      private const capacityText:VText;
      
      private const countText:VText;
      
      private const pricePanel:PricePanel;
      
      private const pb:VProgressBar;
      
      private var helpText:VText;
      
      public function GuardDialog(param1:uint, param2:Build, param3:Vector.<Build>, param4:int)
      {
         var _loc6_:uint = 0;
         this.buyGrid = new VGrid(4,2,BarrackBuyRenderer,null,24,26,VGrid.USE_NULL_DATA);
         this.configGrid = new VGrid(5,1,BarrackProdRenderer,null,4,0,VGrid.USE_END_LIMIT);
         this.removeBt = new CircleButton(null,CircleButton.TEAL,CircleButton.size30);
         this.oilPanel = new ResourcePanel(PCost.OIL,ResourcePanel.BG | ResourcePanel.TWEEN);
         this.buyAll = new RectButton(UIFactory.createYellowText(Lang.getString("guardChargeAll"),VText.CONTAIN),RectButton.h42,RectButton.ORANGE);
         this.tabPanel = new TabPanelGuard();
         this.capacityText = new VText(null,0,Style.metalRGB,14);
         this.countText = new VText(null,VText.CONTAIN_CENTER,Style.metalRGB,14);
         this.pricePanel = new PricePanel(20,18,PricePanel.GLOW_FILTER);
         this.pb = UIFactory.createProgressBar(UIFactory.INDICATOR_GREEN);
         super();
         useSimpleBg(814,658);
         addUnitDialogTitle(param2.kind,param2.level,false,460);
         add(this.oilPanel,{
            "top":13,
            "right":82
         });
         this.createSquad();
         this.tabPanel.initList(param3,param4);
         add(this.tabPanel,{
            "left":2,
            "right":2,
            "top":70
         });
         add(this.pb,{
            "w":280,
            "right":30,
            "top":145,
            "h":32
         });
         if(param1 > 0)
         {
            _loc6_ = 1;
            while(_loc6_ < param1)
            {
               this.pb.add(SkinManager.getEmbed("SeparatorPb",VSkin.STRETCH),{
                  "left":_loc6_ / param1 * this.pb.layoutW - 4,
                  "top":4,
                  "bottom":6
               });
               _loc6_++;
            }
         }
         add(this.countText,{
            "right":25,
            "top":124,
            "w":290
         });
         var _loc5_:VText = UIFactory.createYellowText(Lang.getString("add_squad"),VText.CONTAIN);
         _loc5_.maxW = 140;
         this.addBt = new RectButton(new VBox(new <VComponent>[_loc5_,this.pricePanel]),RectButton.h42);
         add(this.addBt,{
            "top":185,
            "hCenter":240
         });
         _loc5_ = UIFactory.createYellowText("-1",0,16);
         _loc5_.useCenter();
         this.removeBt.setIcon(_loc5_);
         add(this.removeBt,{
            "right":12,
            "top":145
         });
         add(SkinManager.getEmbed("TrainGlass"),{
            "hCenter":0,
            "top":230
         });
         add(BarrackDialog.getConnectBg(3,125,186,6),{
            "w":680,
            "hCenter":0,
            "top":311
         });
         add(BarrackDialog.getConnectBg(3,125,186,6),{
            "w":680,
            "hCenter":0,
            "top":500
         });
         this.buyGrid.dispatcher = this;
         add(this.buyGrid,{
            "hCenter":0,
            "top":266
         });
         UIFactory.useGridControlH43(this.buyGrid);
      }
      
      private function onClick(param1:*) : void
      {
         this.tabPanel.index = this.tabPanel.index + 1 < this.tabPanel.getLen() ? uint(this.tabPanel.index + 1) : 0;
         this.tabPanel.dispatchEvent(new VEvent(VEvent.CHANGE,this.tabPanel.activeBt.data));
      }
      
      private function createSquad() : void
      {
         var _loc1_:VComponent = new VComponent();
         add(_loc1_,{
            "left":20,
            "top":117,
            "w":450,
            "h":115
         });
         _loc1_.add(this.capacityText,{
            "left":120,
            "bottom":0,
            "w":300
         });
         _loc1_.add(SkinManager.getEmbed("TrainArrow",VSkin.FLIP_X | VSkin.STRETCH),{
            "hCenter":0,
            "vCenter":0,
            "w":-100,
            "h":-100
         });
         this.configGrid.dispatcher = this;
         _loc1_.add(this.configGrid,{
            "hCenter":0,
            "vCenter":0
         });
         UIFactory.useGridControlNav(this.configGrid,UIFactory.addNavBt18);
      }
      
      public function updateCount(param1:uint, param2:uint, param3:PCost, param4:uint, param5:uint) : void
      {
         this.capacityText.value = Lang.getPatternString("squad_size","__VALUE__",param1 + "/" + param2);
         this.countText.value = Lang.getPatternString("squad_count","__VALUE__",param4 + "/" + param5);
         this.pricePanel.assignCost(param3);
         this.pb.value = param4 / param5;
         this.addBt.disabled = param4 >= param5 || param1 == 0;
         this.removeBt.visible = param4 > 0;
         if(param1 == 0 != Boolean(this.helpText))
         {
            if(this.helpText)
            {
               remove(this.helpText);
               this.helpText = null;
            }
            else
            {
               this.helpText = new VText(Lang.getString("guard_help"),VText.MIDDLE,16777215,14);
               add(this.helpText,{
                  "left":70,
                  "top":143,
                  "w":384,
                  "h":62
               });
            }
         }
      }
   }
}

