package game.clan.war
{
   import proto.model.PWarTop;
   import proto.model.PWarTopInfo;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.RectButton;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class TopWarRenderer extends VRenderer
   {
      
      private const icon1:VSkin;
      
      private const icon2:VSkin;
      
      private const titleText1:VText;
      
      private const titleText2:VText;
      
      private const infoBt1:CircleButton;
      
      private const infoBt2:CircleButton;
      
      private const logBt1:RectButton;
      
      private const logBt2:RectButton;
      
      private var rp1:ResourcePanel;
      
      private var rp2:ResourcePanel;
      
      private var stormPanel1:StormProgressPanel;
      
      private var stormPanel2:StormProgressPanel;
      
      public function TopWarRenderer()
      {
         var _loc1_:VSkin = null;
         this.icon1 = new VSkin();
         this.icon2 = new VSkin();
         this.titleText1 = UIFactory.createYellowText(null,VText.CONTAIN,22);
         this.titleText2 = UIFactory.createYellowText(null,VText.CONTAIN,22);
         this.infoBt1 = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.GOLD,CircleButton.size30);
         this.infoBt2 = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.GOLD,CircleButton.size30);
         this.logBt1 = new RectButton(Lang.getString("war_log"),RectButton.h30);
         this.logBt2 = new RectButton(Lang.getString("war_log"),RectButton.h30);
         super();
         layoutH = 107;
         _loc1_ = SkinManager.getEmbed("StatBg",VSkin.STRETCH);
         _loc1_.alpha = 0.85;
         add(_loc1_,{
            "left":64,
            "right":64,
            "top":15,
            "h":32
         });
         add(SkinManager.getEmbed("TrainCircleBg",VSkin.STRETCH),{
            "left":2,
            "top":4,
            "w":86,
            "h":86
         });
         add(SkinManager.getEmbed("TrainCircleBg",VSkin.STRETCH),{
            "right":2,
            "top":4,
            "w":86,
            "h":86
         });
         add(this.icon1,{
            "left":7,
            "w":76,
            "h":76,
            "top":9
         });
         this.infoBt1.addVarianceListener(this,WarVariance.INFO);
         this.logBt1.addVarianceListener(this,WarVariance.LOG,[true,null]);
         this.titleText2.maxW = this.titleText1.maxW = 210;
         this.titleText2.layoutH = this.titleText1.layoutH = 22;
         add(new VBox(new <VComponent>[this.infoBt1,this.titleText1]),{
            "hCenter":-158,
            "top":16
         });
         this.logBt1.maxW = this.logBt2.maxW = 120;
         add(this.logBt1,{
            "left":4,
            "bottom":2
         });
         add(this.icon2,{
            "w":76,
            "h":76,
            "right":7,
            "top":9
         });
         this.infoBt2.addVarianceListener(this,WarVariance.INFO);
         this.logBt2.addVarianceListener(this,WarVariance.LOG,[false,null]);
         add(new VBox(new <VComponent>[this.titleText2,this.infoBt2]),{
            "hCenter":158,
            "top":16
         });
         add(this.logBt2,{
            "right":4,
            "bottom":2
         });
         add(UIFactory.createDecorText("VS",true,42),{
            "hCenter":0,
            "top":12
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PWarTop = param1 as PWarTop;
         var _loc3_:PWarTopInfo = _loc2_.wt_attacker;
         SkinManager.applyExternal(this.icon1,UIFactory.EMBLEM_PACK,_loc3_.wti_icon);
         this.titleText1.value = _loc3_.wti_name;
         this.infoBt1.data = _loc3_.wti_id;
         (this.logBt1.data as Array)[1] = _loc2_;
         if(_loc2_.wt_target.wti_storm)
         {
            if(!this.stormPanel1)
            {
               this.stormPanel1 = new StormProgressPanel();
               this.stormPanel1.bt.addVarianceListener(this,WarVariance.TO_STORM);
               this.stormPanel1.bottom = 6;
               this.stormPanel1.hCenter = -154;
            }
            this.stormPanel1.bt.data = _loc2_.wt_target.wti_id;
            this.stormPanel1.text.value = _loc3_.wti_damage + "%";
            if(!this.stormPanel1.parent)
            {
               add(this.stormPanel1);
            }
            if(Boolean(this.rp1) && Boolean(this.rp1.parent))
            {
               remove(this.rp1,false);
            }
         }
         else
         {
            if(!this.rp1)
            {
               this.rp1 = new ResourcePanel(SkinManager.getEmbed("MoralIcon"),ResourcePanel.BG | ResourcePanel.PROGRESS,"LightGreenIndicator");
               this.rp1.assignLayout({
                  "w":142,
                  "h":37,
                  "bottom":9,
                  "hCenter":-154
               });
               this.rp1.setMax(Facade.references.wp_storm_req,false,false);
            }
            this.rp1.cur = _loc3_.wti_warpoints;
            if(!this.rp1.parent)
            {
               add(this.rp1);
            }
            if(Boolean(this.stormPanel1) && Boolean(this.stormPanel1.parent))
            {
               remove(this.stormPanel1,false);
            }
         }
         _loc3_ = _loc2_.wt_target;
         SkinManager.applyExternal(this.icon2,UIFactory.EMBLEM_PACK,_loc3_.wti_icon);
         this.titleText2.value = _loc3_.wti_name;
         this.infoBt2.data = _loc3_.wti_id;
         (this.logBt2.data as Array)[1] = _loc2_;
         if(_loc2_.wt_attacker.wti_storm)
         {
            if(!this.stormPanel2)
            {
               this.stormPanel2 = new StormProgressPanel();
               this.stormPanel2.bt.addVarianceListener(this,WarVariance.TO_STORM);
               this.stormPanel2.bottom = 6;
               this.stormPanel2.hCenter = 154;
            }
            this.stormPanel2.bt.data = _loc2_.wt_attacker.wti_id;
            this.stormPanel2.text.value = _loc3_.wti_damage + "%";
            if(!this.stormPanel2.parent)
            {
               add(this.stormPanel2);
            }
            if(Boolean(this.rp2) && Boolean(this.rp2.parent))
            {
               remove(this.rp2,false);
            }
         }
         else
         {
            if(!this.rp2)
            {
               this.rp2 = new ResourcePanel(SkinManager.getEmbed("MoralIcon"),ResourcePanel.BG | ResourcePanel.PROGRESS,"LightRedIndicator");
               this.rp2.assignLayout({
                  "w":142,
                  "h":37,
                  "bottom":9,
                  "hCenter":154
               });
               this.rp2.setMax(Facade.references.wp_storm_req,false,false);
            }
            this.rp2.cur = _loc3_.wti_warpoints;
            if(!this.rp2.parent)
            {
               add(this.rp2);
            }
            if(Boolean(this.stormPanel2) && Boolean(this.stormPanel2.parent))
            {
               remove(this.stormPanel2,false);
            }
         }
      }
   }
}

