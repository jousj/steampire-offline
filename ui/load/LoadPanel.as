package ui.load
{
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class LoadPanel extends VComponent
   {
      
      private const textPanel:VComponent = new VComponent();
      
      public function LoadPanel(param1:String = null)
      {
         super();
         add(SkinManager.getEmbed("DialogBg",VSkin.STRETCH),{
            "left":-20,
            "right":-20,
            "top":-5,
            "bottom":-18
         });
         this.textPanel.add(SkinManager.getEmbed("ClockClip",VSkin.PLAY_MOVIE_CLIP | VComponent.SKIP_CONTENT_SIZE),{
            "hCenter":0,
            "top":-150
         });
         var _loc2_:VText = UIFactory.createYellowText(null,VText.CENTER,22);
         this.textPanel.addStretch(SkinManager.getEmbed("DarkPanelBg",VSkin.STRETCH_BG));
         this.textPanel.add(_loc2_,{
            "left":30,
            "right":30,
            "top":23,
            "bottom":23,
            "maxW":700
         });
         this.textPanel.useCenter(0,55);
         addChild(this.textPanel);
         _loc2_.value = param1 ? param1 + "..." : Lang.getString("load_title");
      }
   }
}

