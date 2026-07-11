package game.rank
{
   import proto.model.PUserTop;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VPager;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class TopUserPanel extends VComponent
   {
      
      private const loadText:VText = new VText(Lang.getString("load_title"),VText.CENTER,Style.darkKhakiRGB);
      
      private const pager:VPager = UIFactory.createPager();
      
      private const columnFill1:VFill = new VFill(16777215,0.15);
      
      private const columnFill2:VFill = new VFill(16777215,0.4);
      
      private var nextBt:VButton;
      
      private var prevBt:VButton;
      
      private var pagerCount:uint;
      
      private var myRenderer:TopUserRenderer;
      
      private var isArrowDown:Boolean = true;
      
      protected var grid:VGrid;
      
      public var league:Number;
      
      public function TopUserPanel(param1:uint, param2:int, param3:int, param4:int, param5:int = 0, param6:int = -7)
      {
         super();
         layoutW = 777;
         this.grid = new VGrid(1,param1,TopUserRenderer,null,0,0,VGrid.H_STRETCH);
         if(param5 > 0)
         {
            this.grid.renderList[0].layoutH = param5;
         }
         this.grid.dispatcher = this;
         this.grid.emptyFactory = this.emptyFactory;
         this.grid.add(this.columnFill1,{
            "left":71,
            "w":364,
            "hP":100
         });
         this.grid.add(this.columnFill2,{
            "hCenter":253,
            "w":130,
            "hP":100
         });
         UIFactory.addGridWithBg(this.grid,this,true,param2,param3,param4,false);
         add(this.pager,{
            "hCenter":0,
            "bottom":-38
         });
         this.pager.addListener(VEvent.SELECT,this.onPager);
         this.loadText.assignLayout({
            "left":30,
            "right":30,
            "vCenter":param6
         });
      }
      
      public function change(param1:uint, param2:Array, param3:uint, param4:PUserTop, param5:Boolean) : void
      {
         var _loc8_:int = 0;
         this.loadMode = false;
         var _loc6_:Boolean = Boolean(param4);
         this.pagerCount = this.grid.vCount;
         if(param5)
         {
            --this.pagerCount;
         }
         var _loc7_:Boolean = param1 + this.pagerCount < param3;
         if((_loc7_) || param1 > 1)
         {
            if(!this.nextBt)
            {
               this.nextBt = UIFactory.createNavButton(true);
               this.nextBt.addVarianceListener(this,2);
               this.prevBt = UIFactory.createNavButton(false);
               this.prevBt.addVarianceListener(this,2);
               UIFactory.addNavBt30(this.grid,this.prevBt,this.nextBt);
            }
            else
            {
               this.nextBt.visible = this.prevBt.visible = true;
            }
            this.prevBt.disabled = param1 == 0;
            this.nextBt.disabled = !_loc7_;
            this.prevBt.data = param1 <= this.pagerCount ? 0 : param1 - this.pagerCount;
            this.nextBt.data = param1 + this.pagerCount;
         }
         else if(this.nextBt)
         {
            this.nextBt.visible = this.prevBt.visible = false;
         }
         if(_loc6_)
         {
            if(param2.length > this.pagerCount)
            {
               param2.length = this.pagerCount;
            }
            if(!this.myRenderer)
            {
               this.myRenderer = new TopUserRenderer(true);
               this.myRenderer.dispatcher = this;
               this.myRenderer.layoutW = -100;
               this.grid.addChildAt(this.myRenderer,this.prevBt ? this.grid.getChildIndex(this.prevBt) : this.grid.numChildren);
            }
            if(this.isArrowDown != param4.ut_place > (param2.length > 0 ? (param2[0] as PUserTop).ut_place : 1))
            {
               this.changeToIcon(this.myRenderer.bt.icon as VSkin);
            }
            this.myRenderer.setData(param4);
            _loc8_ = this.grid.renderList[0].measuredHeight * (param2.length >= this.pagerCount ? this.pagerCount : param2.length) + 8;
            if(_loc8_ != this.myRenderer.top)
            {
               this.myRenderer.top = _loc8_;
               this.myRenderer.geometryPhase();
            }
         }
         else if(this.myRenderer)
         {
            this.myRenderer.removeFromParent(true);
            this.myRenderer = null;
         }
         param3 = Math.ceil(param3 / this.pagerCount);
         this.pager.setParam(param1 / this.pagerCount,param3);
         this.grid.setDataProvider(param2);
         this.columnFill1.visible = this.columnFill2.visible = param2.length > 0;
      }
      
      private function changeToIcon(param1:VSkin) : void
      {
         this.isArrowDown = !this.isArrowDown;
         SkinManager.applyEmbed(param1,this.isArrowDown ? "AttackDirection1" : "AttackDirection5");
         param1.vCenter = this.isArrowDown ? 0 : -1;
         param1.syncLayout();
      }
      
      public function set loadMode(param1:Boolean) : void
      {
         if(param1 != Boolean(this.loadText.parent))
         {
            this.pager.visible = this.grid.visible = !param1;
            if(param1)
            {
               add(this.loadText);
            }
            else
            {
               remove(this.loadText,false);
            }
         }
      }
      
      private function onPager(param1:VEvent) : void
      {
         dispatchVarianceEvent(2,param1.data * this.pagerCount);
      }
      
      private function emptyFactory() : VText
      {
         var _loc1_:VText = new VText(Lang.getString("tops_empty"),VText.CENTER,Style.darkKhakiRGB);
         _loc1_.assignLayout({
            "left":10,
            "right":10,
            "vCenter":0
         });
         return _loc1_;
      }
   }
}

