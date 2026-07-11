package game.my
{
   import game.feature.TownHallRenderer;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class EditorPanel extends VComponent
   {
      
      public const grid:VGrid;
      
      public const saveBt:RectButton;
      
      public const eraseAllBt:RectButton;
      
      public const eraseFenceBt:RectButton;
      
      public const exitBt:RectButton;
      
      public function EditorPanel()
      {
         var _loc1_:VComponent = null;
         this.grid = new VGrid(0,1,this.createRenderer,null,5,0,VGrid.USE_VISIBLE_CALC_LAYOUT | VGrid.SELECTED_MODE | VGrid.USE_INVERT_SELECT);
         this.saveBt = new RectButton(Lang.getString("save_and_exit"),RectButton.h30);
         this.eraseAllBt = new RectButton(Lang.getString("erase_all"),RectButton.h30,RectButton.ORANGE);
         this.eraseFenceBt = new RectButton(Lang.getString("erase_fence"),RectButton.h30,RectButton.ORANGE);
         this.exitBt = new RectButton(Lang.getString("exit"),RectButton.h30);
         super();
         _loc1_ = new VComponent();
         _loc1_.mouseChildren = _loc1_.mouseEnabled = false;
         _loc1_.addStretch(SkinManager.getEmbed("BoardMoveBg",VSkin.STRETCH_BG));
         _loc1_.add(new VText(Lang.getString("editor_mode"),0,Style.yellowRGB,16),{
            "left":6,
            "top":7,
            "right":6,
            "bottom":7
         });
         add(_loc1_,{
            "left":10,
            "top":10
         });
         this.grid.emptyFactory = this.emptyFactory;
         add(this.grid,{
            "left":40,
            "right":40,
            "bottom":50
         });
         UIFactory.useGridControlNav(this.grid,UIFactory.addNavBt30);
         add(new VBox(new <VComponent>[this.exitBt,this.saveBt,this.eraseFenceBt,this.eraseAllBt],10),{
            "hCenter":0,
            "bottom":10
         });
      }
      
      private function emptyFactory() : VComponent
      {
         var _loc1_:VComponent = new VComponent();
         _loc1_.addStretch(SkinManager.getEmbed("DarkPanelBg",VSkin.STRETCH));
         _loc1_.add(UIFactory.createYellowText(Lang.getString("editor_prompt"),VText.CENTER),{
            "vCenter":0,
            "left":16,
            "right":16
         });
         _loc1_.useCenter();
         _loc1_.setSize(500,100);
         return _loc1_;
      }
      
      private function createRenderer() : TownHallRenderer
      {
         var _loc1_:TownHallRenderer = new TownHallRenderer();
         _loc1_.buttonMode = true;
         _loc1_.addSelectTriger(_loc1_);
         return _loc1_;
      }
   }
}

