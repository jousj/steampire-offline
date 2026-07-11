package game.clan.war
{
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VPager;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class TopWarsPanel extends VComponent
   {
      
      public const grid:VGrid;
      
      private var text:VText;
      
      private const panel:VComponent;
      
      public function TopWarsPanel()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:VSkin = null;
         this.grid = new VGrid(1,5,TopWarRenderer,null,0,8,VGrid.H_STRETCH);
         this.panel = new VComponent();
         super();
         add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH),{
            "wP":100,
            "top":0,
            "bottom":0
         });
         _loc1_ = int(this.grid.renderList[0].measuredHeight);
         _loc2_ = 0;
         _loc3_ = 1;
         while(_loc3_ <= 4)
         {
            _loc4_ = SkinManager.getEmbed("GridSeparator",VSkin.STRETCH);
            _loc4_.layoutW = -100;
            _loc2_ += _loc1_;
            _loc4_.top = _loc2_;
            this.panel.addChild(_loc4_);
            _loc2_ += this.grid.vGap;
            if((_loc3_ & 1) != 0)
            {
               this.panel.add(new VFill(12367020),{
                  "left":5,
                  "right":5,
                  "h":_loc1_ - 2,
                  "top":_loc2_ + 2
               });
            }
            _loc3_++;
         }
         add(this.panel,{
            "top":8,
            "left":7,
            "right":6
         });
         this.grid.dispatcher = this;
         add(this.grid,{
            "top":8,
            "left":12,
            "right":11
         });
         UIFactory.useGridControl(this.grid,UIFactory.addNavBt30,this.addPager);
      }
      
      private function addPager(param1:VGrid, param2:VPager) : void
      {
         param1.add(param2,{
            "hCenter":0,
            "bottom":-51
         });
      }
      
      public function assign(param1:String, param2:Array = null, param3:uint = 0) : void
      {
         this.grid.setDataProvider(param2,param3);
         var _loc4_:Boolean = Boolean(param1);
         this.panel.visible = !_loc4_;
         if(_loc4_)
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
   }
}

