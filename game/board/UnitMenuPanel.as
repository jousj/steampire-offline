package game.board
{
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class UnitMenuPanel extends VComponent
   {
      
      public const text:VText = UIFactory.createYellowText(null,VText.CONTAIN,20);
      
      public const btBox:VBox = new VBox(null,7);
      
      private const box:VBox = new VBox(new <VComponent>[this.text]);
      
      private const levelPanel:LevelPanel = new LevelPanel(LevelPanel.size28);
      
      public var posX:Number;
      
      public var posY:Number;
      
      public function UnitMenuPanel()
      {
         super();
         layoutH = 96;
         minW = 182;
         this.text.maxW = 300;
         add(SkinManager.getEmbed("MenuCircleBorder"),{
            "hCenter":0,
            "top":39
         });
         add(SkinManager.getEmbed("DarkPanelBg",VSkin.STRETCH_BG),{
            "left":-10,
            "right":-8,
            "top":1,
            "h":40
         });
         add(this.box,{
            "hCenter":0,
            "top":7,
            "h":28
         });
         add(this.btBox,{
            "top":33,
            "hCenter":0
         });
      }
      
      public function set level(param1:uint) : void
      {
         if(param1 > 0)
         {
            this.levelPanel.value = param1;
            if(!this.levelPanel.parent)
            {
               this.box.add(this.levelPanel);
            }
         }
         else if(this.levelPanel.parent)
         {
            this.box.remove(this.levelPanel,false);
         }
      }
      
      public function syncPos() : void
      {
         x = this.posX - Math.round(w * scaleX / 2);
         y = this.posY - Math.round(h * scaleY - 2);
      }
      
      override public function geometryPhase() : void
      {
         super.geometryPhase();
         this.syncPos();
      }
      
      public function get isButtons() : Boolean
      {
         return this.btBox.list.length > 0;
      }
   }
}

