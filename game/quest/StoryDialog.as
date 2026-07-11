package game.quest
{
   import engine.signal.Signal;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class StoryDialog extends BaseDialog
   {
      
      private const component:VComponent = new VComponent();
      
      private const skin:VSkin = new VSkin(VSkin.NO_STRETCH | VSkin.BOTTOM);
      
      public var data:String;
      
      public function StoryDialog(param1:String, param2:String, param3:Boolean = false)
      {
         super();
         layoutW = 500;
         SkinManager.applyExternal(this.skin,"story_" + param1,null,SkinManager.PNG | SkinManager.LOAD_CLIP);
         this.skin.hCenter = 0;
         if(param3)
         {
            this.skin.layoutH = 10;
         }
         addChild(this.skin);
         this.component.addStretch(SkinManager.getEmbed("StoryMsgBg",VSkin.STRETCH_BG));
         this.component.add(new VText(param2,0,Style.metalRGB),{
            "top":50,
            "bottom":40,
            "w":440,
            "hCenter":0
         });
         add(this.component,{
            "wP":100,
            "bottom":0
         });
         closeBt = new RectButton(Lang.getString("bt_next"),RectButton.h56);
         closeBt.addClickListener(close);
         add(closeBt,{
            "hCenter":0,
            "bottom":-25
         });
         Signal.createRef(this,this.onLearn,0,0,false).delayCall(3);
      }
      
      private function onLearn() : void
      {
         closeBt.add(UIFactory.createLearnArrow(90),{
            "right":4,
            "vCenter":0
         });
      }
      
      override protected function calcContentSize() : void
      {
         contentH = this.component.measuredHeight;
         if(this.skin.isContent)
         {
            contentH += this.skin.measuredHeight - 26;
         }
      }
      
      override public function dispose() : void
      {
         Signal.stopRef(this);
         super.dispose();
      }
   }
}

