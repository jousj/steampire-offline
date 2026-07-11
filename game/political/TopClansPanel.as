package game.political
{
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VPager;
   import ui.vbase.VText;
   
   public class TopClansPanel extends VComponent
   {
      
      public const loadText:VText = new VText(Lang.getString("load_title"),VText.CENTER,Style.darkKhakiRGB);
      
      public const pager:VPager = UIFactory.createPager();
      
      public const columnFill:VFill = new VFill(16777215,0.15);
      
      private var grid:VGrid;
      
      private var nextBt:VButton;
      
      private var prevBt:VButton;
      
      private var funRnd:Object = null;
      
      private var lineCount:uint;
      
      protected var pagerCount:uint;
      
      protected var myRenderer:TopClanRendererBase;
      
      public var myPlace:uint;
      
      public function TopClansPanel(param1:uint, param2:int, param3:int, param4:int, param5:int = -45, param6:Object = null)
      {
         super();
         this.funRnd = param6 ? param6 : TopClanRenderer;
         add(this.pager,{
            "hCenter":0,
            "bottom":param5
         });
         this.pager.addListener(VEvent.SELECT,this.onPager);
         this.grid = new VGrid(1,param1,this.funRnd,null,0,0,VGrid.H_STRETCH);
         this.grid.add(this.columnFill,{
            "left":51,
            "w":58,
            "hP":100
         });
         this.grid.add(new VFill(16777215,0.15),{
            "right":320,
            "w":72,
            "hP":100
         });
         this.grid.add(new VFill(16777215,0.15),{
            "right":65,
            "w":122,
            "hP":100
         });
         this.grid.emptyFactory = this.emptyFactory;
         UIFactory.addGridWithBg(this.grid,this,true,param2,param3,param4,false);
         this.loadText.assignLayout({
            "left":30,
            "right":30,
            "top":this.grid.top + (this.grid.measuredHeight >> 1) - 8
         });
         this.lineCount = param1;
      }
      
      public function change(param1:uint, param2:Array, param3:Boolean, param4:*, param5:uint) : void
      {
         var _loc6_:int = 0;
         this.loadMode = false;
         this.pagerCount = this.grid.vCount - 1;
         if(param5 >= this.pagerCount)
         {
            if(!this.nextBt)
            {
               this.nextBt = UIFactory.createNavButton(true);
               this.nextBt.addVarianceListener(this,TopClanRendererBase.PAGER);
               this.prevBt = UIFactory.createNavButton(false);
               this.prevBt.addVarianceListener(this,TopClanRendererBase.PAGER);
               UIFactory.addNavBt30(this.grid,this.prevBt,this.nextBt);
            }
            else
            {
               this.nextBt.visible = this.prevBt.visible = true;
            }
            this.prevBt.data = (int(param1 / this.pagerCount) - 1) * this.pagerCount;
            this.nextBt.data = (int(param1 / this.pagerCount) + 1) * this.pagerCount;
         }
         else if(this.nextBt)
         {
            this.nextBt.visible = this.prevBt.visible = false;
         }
         if(param3)
         {
            if(param2.length > this.pagerCount)
            {
               param2.length = this.pagerCount;
            }
            if(!this.myRenderer)
            {
               this.myRenderer = new (this.funRnd as Class)(true);
               this.myRenderer.dispatcher = this;
               this.myRenderer.layoutW = -100;
               this.grid.addChildAt(this.myRenderer,this.prevBt ? this.grid.getChildIndex(this.prevBt) : this.grid.numChildren);
               this.myRenderer.setData(param4);
            }
            this.myRenderer.setPlace(this.myPlace,this.lineCount);
            _loc6_ = this.grid.renderList[0].measuredHeight * (param2.length >= this.pagerCount ? this.pagerCount : param2.length) + 8;
            if(_loc6_ != this.myRenderer.top)
            {
               this.myRenderer.top = _loc6_;
               this.myRenderer.geometryPhase();
            }
         }
         else if(this.myRenderer)
         {
            this.myRenderer.removeFromParent(true);
            this.myRenderer = null;
         }
         this.grid.setDataProvider(param2);
         param5 = uint(int((param5 + this.pagerCount - 1) / this.pagerCount));
         this.pager.setParam(param1 / this.pagerCount,param5);
         if(this.nextBt)
         {
            this.prevBt.disabled = this.pager.index == 0;
            this.nextBt.disabled = this.pager.index == this.pager.max - 1;
         }
         param1 = uint(this.grid.getChildIndex(this.columnFill));
         param5 = param1 + param5 - 1;
      }
      
      public function set loadMode(param1:Boolean) : void
      {
         this.pager.visible = this.grid.visible = !param1;
         if(param1 != Boolean(this.loadText.parent))
         {
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
      
      private function emptyFactory() : VComponent
      {
         var _loc1_:VText = new VText(Lang.getString("clan_empty"),VText.CENTER,Style.darkKhakiRGB);
         _loc1_.assignLayout({
            "vCenter":1,
            "left":50,
            "right":50
         });
         return _loc1_;
      }
      
      protected function onPager(param1:VEvent) : void
      {
         dispatchVarianceEvent(TopClanRendererBase.PAGER,param1.data * this.pagerCount);
      }
   }
}

