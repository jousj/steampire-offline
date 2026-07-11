package game.clan.war
{
   import proto.model.clan.PTopRequest;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   import ui.vbase.VInputText;
   import ui.vbase.VPager;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class StartWarPanel extends VComponent
   {
      
      public const inputText:VInputText;
      
      public const grid:VGrid;
      
      private const searchBt:RectButton;
      
      private const loadText:VText;
      
      private const pager:VPager;
      
      private var nextBt:VButton;
      
      private var prevBt:VButton;
      
      public function StartWarPanel(param1:PTopRequest)
      {
         var _loc2_:RectButton = null;
         this.inputText = UIFactory.createInputText(16,null,40);
         this.grid = new VGrid(1,4,StartWarRenderer,null,0,8,VGrid.H_STRETCH);
         this.searchBt = new RectButton(Lang.getString("clan_search"),RectButton.h42);
         this.loadText = new VText(Lang.getString("load_title"),VText.CENTER,Style.darkKhakiRGB);
         this.pager = UIFactory.createPager();
         super();
         setSize(900,594);
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "wP":100,
            "h":53
         });
         _loc2_ = new RectButton(Lang.getString("cur_war_list"),RectButton.h42,RectButton.YELLOW);
         _loc2_.maxW = 180;
         _loc2_.addVarianceListener(this,WarVariance.TO_WAR_LIST);
         this.inputText.value = param1.name;
         this.inputText.layoutW = -100;
         this.searchBt.addVarianceListener(this,WarVariance.SEARCH);
         add(new VBox(new <VComponent>[_loc2_,this.inputText,this.searchBt],8),{
            "left":12,
            "right":12,
            "top":6
         });
         var _loc3_:int = 58;
         this.grid.dispatcher = this;
         this.grid.emptyFactory = this.emptyFactory;
         var _loc4_:int = int(this.grid.renderList[0].measuredHeight);
         add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH),{
            "wP":100,
            "top":_loc3_,
            "h":this.grid.vCount * _loc4_ + this.grid.vGap * (this.grid.vCount - 1) + 20
         });
         _loc3_ += 8;
         add(this.grid,{
            "left":13,
            "right":11,
            "top":_loc3_
         });
         add(SkinManager.getEmbed("GridSeparator",VSkin.STRETCH),{
            "left":7,
            "right":6,
            "top":_loc3_ + _loc4_
         });
         add(SkinManager.getEmbed("GridSeparator",VSkin.STRETCH),{
            "left":7,
            "right":6,
            "top":_loc3_ + 2 * _loc4_ + this.grid.vGap
         });
         add(SkinManager.getEmbed("GridSeparator",VSkin.STRETCH),{
            "left":7,
            "right":6,
            "top":_loc3_ + 3 * _loc4_ + this.grid.vGap * 2
         });
         add(this.pager,{
            "hCenter":0,
            "bottom":-35
         });
         this.pager.addListener(VEvent.SELECT,this.onPager);
         this.loadText.assignLayout({
            "left":30,
            "right":30,
            "vCenter":35
         });
      }
      
      public function change(param1:uint, param2:Array, param3:uint) : void
      {
         this.loadMode = false;
         var _loc4_:uint = this.grid.vCount;
         var _loc5_:Boolean = param1 + _loc4_ <= param3;
         if((_loc5_) || param1 > 1)
         {
            if(!this.nextBt)
            {
               this.nextBt = UIFactory.createNavButton(true);
               this.nextBt.addVarianceListener(this,WarVariance.SEARCH);
               this.prevBt = UIFactory.createNavButton(false);
               this.prevBt.addVarianceListener(this,WarVariance.SEARCH);
               UIFactory.addNavBt30(this.grid,this.prevBt,this.nextBt);
            }
            else
            {
               this.nextBt.visible = this.prevBt.visible = true;
            }
            this.prevBt.disabled = param1 <= 1;
            this.nextBt.disabled = !_loc5_;
            this.prevBt.data = param1 <= _loc4_ ? 1 : param1 - _loc4_;
            this.nextBt.data = param1 + _loc4_;
         }
         else if(this.nextBt)
         {
            this.nextBt.visible = this.prevBt.visible = false;
         }
         this.grid.setDataProvider(param2);
         param3 = Math.ceil(param3 / _loc4_);
         this.pager.setParam((param1 - 1) / _loc4_,param3);
      }
      
      public function set loadMode(param1:Boolean) : void
      {
         this.pager.visible = this.grid.visible = !param1;
         this.searchBt.disabled = param1;
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
            "vCenter":-49,
            "left":50,
            "right":50
         });
         return _loc1_;
      }
      
      private function onPager(param1:VEvent) : void
      {
         dispatchVarianceEvent(WarVariance.SEARCH,param1.data * this.grid.vCount + 1);
      }
   }
}

