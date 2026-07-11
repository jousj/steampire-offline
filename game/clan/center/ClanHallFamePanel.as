package game.clan.center
{
   import flash.events.MouseEvent;
   import proto.model.PHallOfFame;
   import proto.model.PHallSeason;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   import ui.vbase.VPager;
   import ui.vbase.VText;
   import utils.CommonUtils;
   
   public class ClanHallFamePanel extends VComponent
   {
      
      public var grid:VGrid;
      
      public var pager:VPager = UIFactory.createPager();
      
      public var nextBt:VButton = UIFactory.createNavButton(true);
      
      public var prevBt:VButton = UIFactory.createNavButton(false);
      
      public var best:TopClanRendererHallFame = new TopClanRendererHallFame(true);
      
      public var bestSeasonNum:VText = new VText(null,VText.MIDDLE,Style.metalRGB,16);
      
      public function ClanHallFamePanel()
      {
         super();
         this.grid = new VGrid(1,2,HallOfFameRenderer,[],0,5,VGrid.H_STRETCH);
         add(this.grid,{
            "hCenter":0,
            "top":104
         });
         add(this.pager,{
            "bottom":-45,
            "hCenter":0
         });
         this.pager.addListener(VEvent.SELECT,this.onPager);
         this.nextBt.addListener(MouseEvent.CLICK,this.onNext);
         this.prevBt.addListener(MouseEvent.CLICK,this.onNext);
         UIFactory.addNavBt30(this.grid,this.prevBt,this.nextBt);
         this.best.dispatcher = this;
         this.best.layoutW = -100;
         this.grid.dispatcher = this;
         add(this.best,{
            "hCenter":0,
            "w":864,
            "top":30
         });
         add(this.bestSeasonNum,{"hCenter":0});
         this.best.visible = false;
      }
      
      protected function onNext(param1:MouseEvent) : void
      {
         var _loc2_:int = param1.target == this.nextBt ? 1 : -1;
         this.grid.index += this.grid.vCount * _loc2_;
         this.pager.index += _loc2_;
         this.updateBtn();
      }
      
      private function updateBtn() : void
      {
         this.prevBt.disabled = this.pager.index == 0;
         this.nextBt.disabled = this.pager.index + 1 == this.pager.max;
      }
      
      protected function onPager(param1:VEvent) : void
      {
         this.grid.index = this.pager.index * this.grid.vCount;
         this.updateBtn();
      }
      
      public function setData(param1:PHallOfFame) : void
      {
         var _loc2_:PHallSeason = null;
         CommonUtils.sort(param1.seasons,["season"],[Array.NUMERIC | Array.DESCENDING]);
         for each(_loc2_ in param1.seasons)
         {
            CommonUtils.sort(_loc2_.places,["place"],[Array.NUMERIC]);
         }
         this.grid.setDataProvider(param1.seasons,0);
         this.pager.setParam(0,(param1.seasons.length + (this.grid.vCount - 1)) / this.grid.vCount);
         this.updateBtn();
         this.best.setData(param1.record.clan);
         this.bestSeasonNum.value = Lang.getString("record") + " (" + Lang.getString("season") + " " + param1.record.season.toString() + ")";
         this.best.visible = true;
      }
   }
}

