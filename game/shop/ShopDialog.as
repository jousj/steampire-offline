package game.shop
{
   import flash.events.MouseEvent;
   import proto.model.PCost;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.TabPanel;
   import ui.game.ResourcePanel;
   import ui.vbase.GridControl;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   
   public class ShopDialog extends BaseDialog
   {
      
      public const grid:VGrid = new VGrid(3,2,ShopRenderer,null,10,6);
      
      public const tabPanel:TabPanel = new TabPanel();
      
      public var oilPanel:ResourcePanel;
      
      public var crystalPanel:ResourcePanel;
      
      public var goldPanel:ResourcePanel;
      
      public function ShopDialog(param1:Vector.<String>, param2:uint = 0)
      {
         super();
         useDefaultBg(638,Lang.getString("shop_title"),546);
         var _loc3_:uint = ResourcePanel.BG;
         if(Facade.isCapital)
         {
            _loc3_ |= ResourcePanel.CLAN;
         }
         this.oilPanel = new ResourcePanel(PCost.OIL,_loc3_);
         this.crystalPanel = new ResourcePanel(PCost.CRYSTAL,_loc3_);
         this.goldPanel = new ResourcePanel(PCost.GOLD,_loc3_);
         this.oilPanel.layoutW = 150;
         this.crystalPanel.layoutW = 150;
         this.goldPanel.layoutW = 126;
         add(new VBox(new <VComponent>[this.oilPanel,this.crystalPanel,this.goldPanel],8),{
            "top":13,
            "right":68
         });
         add(new VFill(12235690),{
            "left":2,
            "right":2,
            "top":40,
            "h":70
         },1);
         param1 = param1.slice();
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            param1[_loc3_] = Lang.getString("shop_" + param1[_loc3_]);
            _loc3_++;
         }
         this.tabPanel.init(param1,param2);
         add(this.tabPanel,{
            "left":2,
            "right":2,
            "top":76
         });
         this.grid.dispatcher = this;
         add(this.grid,{
            "hCenter":0,
            "top":126
         });
         UIFactory.useGridControlH43(this.grid,false,GridControl.PAGER_CALC_COUNT | GridControl.NAV_BT_DISABLED);
      }
      
      override public function close(param1:MouseEvent = null) : void
      {
         if(!param1)
         {
            Facade.audioProxy.play("shop_buy");
         }
         super.close(param1);
      }
   }
}

