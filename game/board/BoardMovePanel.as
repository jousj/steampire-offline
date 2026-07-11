package game.board
{
   import ui.Style;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.LevelPanel;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class BoardMovePanel extends VComponent
   {
      
      public var titleBox:VBox;
      
      private var box:VBox;
      
      private var infoLabel:VLabel;
      
      private var isBuyCheck:Boolean;
      
      public function BoardMovePanel(param1:Boolean, param2:String, param3:uint, param4:Function)
      {
         var _loc7_:RectButton = null;
         super();
         addStretch(SkinManager.getEmbed("BoardMoveBg",VSkin.STRETCH_BG));
         var _loc5_:VComponent = SkinManager.getEmbed(param1 ? "ShopIcon" : "MoveMode");
         Style.applyGlowFilter(_loc5_,Style.yellowRGB,4);
         add(_loc5_,{
            "h":(param1 ? 30 : 28),
            "top":-15,
            "hCenter":0
         });
         var _loc6_:LevelPanel = new LevelPanel(LevelPanel.size28,param3);
         _loc7_ = new RectButton(Lang.getString("move_cancel"),RectButton.h30,RectButton.ORANGE);
         _loc7_.addClickListener(param4);
         this.titleBox = new VBox(new <VComponent>[UIFactory.createYellowText(Lang.getString(param2),VText.CONTAIN_CENTER),_loc6_],1);
         this.titleBox.layoutH = _loc6_.layoutH;
         this.box = new VBox(new <VComponent>[this.titleBox,_loc7_],5,VBox.VERTICAL);
         this.box.setPadding(12);
         addChild(this.box);
      }
      
      public function showBuyInfo(param1:uint, param2:uint, param3:String, param4:Boolean = true) : void
      {
         if(!this.infoLabel)
         {
            this.infoLabel = new VLabel(null,VLabel.CENTER);
            this.infoLabel.layoutH = 24;
            this.box.add(this.infoLabel,null,this.box.list.length - 1);
            this.isBuyCheck = !param4;
         }
         if(this.isBuyCheck != param4)
         {
            this.isBuyCheck = param4;
            Style.applyGlowFilter(this.infoLabel,param4 ? Style.grayGlowRGB : 16777215,8);
         }
         this.infoLabel.text = "<p" + (param4 ? Style.yellowColor : " color=\"#AA0000\"") + ">" + param1 + "/" + param2 + "   " + param3 + "</p>";
      }
      
      public function useEditorButton(param1:Function) : void
      {
         var _loc2_:CircleButton = new CircleButton(SkinManager.getEmbed("EditorIcon"),CircleButton.GOLD,CircleButton.size70);
         _loc2_.hint = Lang.getString("editor_mode");
         add(_loc2_,{
            "vCenter":0,
            "right":-80
         });
         _loc2_.addClickListener(param1);
      }
   }
}

