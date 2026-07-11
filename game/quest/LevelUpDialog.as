package game.quest
{
   import flash.events.MouseEvent;
   import proto.model.PNewLevelInfo;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.LevelPanel;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.ShineClip;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class LevelUpDialog extends BaseDialog
   {
      
      private var data:PNewLevelInfo;
      
      private const shineClip:ShineClip;
      
      public function LevelUpDialog(param1:PNewLevelInfo, param2:Array)
      {
         var _loc3_:VSkin = null;
         var _loc6_:RectButton = null;
         var _loc7_:VComponent = null;
         this.shineClip = new ShineClip();
         super();
         setSize(572,450);
         addChild(this.shineClip);
         add(SkinManager.getExternal("LevelUpBg"),{"left":-18});
         add(UIFactory.createDecorText(Lang.getString("lvlup"),true,36,560,false),{
            "hCenter":0,
            "top":12
         });
         add(new LevelPanel(LevelPanel.size48,param1.new_level),{
            "top":76,
            "hCenter":0
         });
         _loc3_ = SkinManager.getEmbed("Exp");
         _loc3_.rotation = -30;
         add(_loc3_,{
            "top":101,
            "hCenter":-48,
            "w":36
         });
         _loc3_ = SkinManager.getEmbed("Exp");
         _loc3_.rotation = 30;
         add(_loc3_,{
            "top":84,
            "hCenter":53,
            "w":36
         });
         add(UIFactory.createYellowText(Lang.getString("congratulations"),VText.CONTAIN_CENTER,24),{
            "top":130,
            "hCenter":0,
            "w":360
         });
         add(new VText(Lang.getString("lvlup_desc"),VText.CONTAIN_CENTER,Style.metalRGB,18),{
            "top":156,
            "hCenter":0,
            "w":390
         });
         add(UIFactory.createDecorText(Lang.getString("prize"),true,32,400),{
            "hCenter":0,
            "top":251
         });
         var _loc4_:PriceListPanel = new PriceListPanel(14);
         _loc4_.setStyle(42,24);
         _loc4_.assignList(param2);
         add(_loc4_,{
            "left":60,
            "right":60,
            "top":42 + 251
         });
         var _loc5_:RectButton = new RectButton(Lang.getString("bt_ok"),RectButton.h56,RectButton.ORANGE);
         _loc5_.addClickListener(close);
         if(param1.new_level_sign)
         {
            this.data = param1;
            _loc6_ = new RectButton(Lang.getString("share"),RectButton.h56,RectButton.GREEN);
            _loc6_.addClickListener(this.onShare);
            _loc7_ = new VBox(new <VComponent>[_loc5_,_loc6_],20);
         }
         else
         {
            _loc7_ = _loc5_;
         }
         add(_loc7_,{
            "hCenter":0,
            "bottom":8
         });
         addCloseButton({
            "right":15,
            "top":11
         });
      }
      
      private function onShare(param1:MouseEvent) : void
      {
         close();
         Facade.callJS("shareLevelUp",this.data.new_level,this.data.new_level_sign.sign_key,this.data.new_level_sign.sign);
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         this.shineClip.pause = !param1;
      }
   }
}

