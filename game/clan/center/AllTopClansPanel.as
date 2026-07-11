package game.clan.center
{
   import game.political.TopClanRendererBase;
   import game.political.TopClansPanel;
   import proto.model.clan.PTopRequest;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VCheckbox;
   import ui.vbase.VComponent;
   import ui.vbase.VInputText;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class AllTopClansPanel extends TopClansPanel
   {
      
      public const inputText:VInputText = UIFactory.createInputText(16,null,40);
      
      public const joinCb:VCheckbox = UIFactory.createCheckbox(Lang.getString("clan_search_join"),false,16,false);
      
      private const searchBt:RectButton = new RectButton(Lang.getString("clan_search"),RectButton.h42);
      
      private const infoText:VText = new VText(null,0,Style.metalRGB,14);
      
      public function AllTopClansPanel(param1:PTopRequest, param2:uint)
      {
         super(param2,92,0,0,-48);
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "wP":100,
            "h":53
         });
         this.inputText.value = param1.name;
         this.joinCb.checked = param1.can_invite;
         this.inputText.layoutW = -100;
         this.searchBt.addVarianceListener(this,TopClanRendererBase.SEARCH,-1);
         add(new VBox(new <VComponent>[this.inputText,this.searchBt],8),{
            "left":12,
            "right":12,
            "top":6
         });
         add(this.joinCb,{
            "left":2,
            "top":57,
            "maxW":390
         });
         this.infoText.format.lineHeight = "100%";
         add(this.infoText,{
            "top":59,
            "right":2,
            "maxW":360,
            "h":28
         });
      }
      
      override public function set loadMode(param1:Boolean) : void
      {
         super.loadMode = param1;
         this.infoText.visible = !param1;
         this.searchBt.disabled = param1;
      }
      
      public function setInfo(param1:String) : void
      {
         this.infoText.value = param1 ? Lang.getString("clan_search_result") + "\n" + param1 : null;
      }
   }
}

