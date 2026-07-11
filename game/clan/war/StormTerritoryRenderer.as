package game.clan.war
{
   import proto.model.clan.PTerritoryAttack;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.DurationPanel;
   import ui.common.LevelPanel;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class StormTerritoryRenderer extends VRenderer
   {
      
      public static const GO:uint = 1;
      
      public static const TERRITORY:uint = 2;
      
      private const emblem1Skin:VSkin = new VSkin();
      
      private const emblem2Skin:VSkin = new VSkin();
      
      private const durationPanel:DurationPanel = new DurationPanel(34);
      
      private const levelPanel:LevelPanel = new LevelPanel(LevelPanel.size34);
      
      private const nameText:VText = UIFactory.createYellowText(null,VText.CONTAIN);
      
      private const descLabel:VLabel = new VLabel(null,VLabel.CENTER | VLabel.MIDDLE);
      
      private const infoBt:CircleButton = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.TEAL,CircleButton.size30);
      
      private var goBt:RectButton;
      
      public function StormTerritoryRenderer()
      {
         super();
         layoutH = 145;
         addStretch(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH));
         add(SkinManager.getEmbed("WarFireImg"),{
            "left":18,
            "vCenter":0,
            "h":88
         });
         add(this.emblem1Skin,{
            "left":17,
            "top":13,
            "h":60
         });
         add(this.emblem2Skin,{
            "left":55,
            "bottom":17,
            "h":60
         });
         add(UIFactory.createDecorText("VS",true,20),{
            "left":50,
            "vCenter":0
         });
         var _loc1_:VComponent = new VComponent();
         _loc1_.addStretch(SkinManager.getEmbed("StatBg",VSkin.STRETCH_BG));
         this.levelPanel.left = 6;
         _loc1_.add(this.levelPanel);
         _loc1_.add(this.nameText,{
            "left":48,
            "right":42,
            "vCenter":0
         });
         this.infoBt.addVarianceListener(this,TERRITORY);
         _loc1_.add(this.infoBt,{
            "h":30,
            "vCenter":0,
            "right":3
         });
         add(_loc1_,{
            "top":22,
            "left":125,
            "h":34,
            "right":216
         });
         add(this.descLabel,{
            "left":126,
            "right":220,
            "bottom":28,
            "h":44
         });
         this.durationPanel.useBg(120);
         add(this.durationPanel,{
            "top":20,
            "right":45
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PTerritoryAttack = param1 as PTerritoryAttack;
         this.levelPanel.value = _loc2_.ta_level;
         this.nameText.value = Lang.getString(_loc2_.ta_kind);
         this.durationPanel.setTrackTime(_loc2_.ta_end_time,true);
         if(this.goBt)
         {
            remove(this.goBt);
         }
         this.goBt = _loc2_.ta_is_my ? RectButton.createIconAndTitle(SkinManager.getEmbed("ShieldIcon"),Lang.getString("war_defence_go"),18,RectButton.ORANGE,188,8) : RectButton.createIconAndTitle(SkinManager.getEmbed("BarrackIcon"),Lang.getString("war_attack_go"),18,RectButton.GREEN,188,4);
         this.goBt.addVarianceListener(this,GO);
         add(this.goBt,{
            "right":20,
            "bottom":20,
            "w":188
         });
         var _loc3_:Boolean = _loc2_.ta_is_my || !_loc2_.ta_clan_name;
         this.descLabel.text = "<div" + Style.metalColor + ">" + Lang.getPatternString("storm_aclan","__CLAN__","<span" + (_loc3_ ? Style.greenColor : Style.redColor) + ">" + StringHelper.addCDATA(_loc3_ ? _loc2_.ta_aclan_name : _loc2_.ta_clan_name) + "</span>") + "</div>";
         if(_loc2_.ta_clan_icon)
         {
            SkinManager.applyExternal(this.emblem1Skin,UIFactory.EMBLEM_PACK,_loc2_.ta_clan_icon);
         }
         else
         {
            SkinManager.applyEmbed(this.emblem1Skin,"MapIcon");
         }
         SkinManager.applyExternal(this.emblem2Skin,UIFactory.EMBLEM_PACK,_loc2_.ta_aclan_icon);
         this.infoBt.data = this.goBt.data = _loc2_;
      }
   }
}

