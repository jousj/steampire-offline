package game.clan.center
{
   import game.political.TopClansPanel;
   import proto.model.PHallSeason;
   import ui.Style;
   import ui.vbase.VRenderer;
   import ui.vbase.VText;
   
   public class HallOfFameRenderer extends VRenderer
   {
      
      private var pan:TopClansPanel = new TopClansPanel(3,0,0,0,20,TopClanRendererHallFame);
      
      private var seasonNum:VText = new VText(null,VText.MIDDLE,Style.metalRGB,16);
      
      public function HallOfFameRenderer()
      {
         super();
         setSize(900,215);
         add(this.pan,{
            "hCenter":0,
            "w":-100,
            "top":16
         });
         add(this.seasonNum,{"hCenter":0});
         this.pan.dispatcher = this;
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PHallSeason = param1 as PHallSeason;
         this.pan.change(0,_loc2_.places,false,null,0);
         this.seasonNum.value = Lang.getString("season") + " " + _loc2_.season.toString();
      }
   }
}

