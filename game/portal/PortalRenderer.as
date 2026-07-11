package game.portal
{
   import engine.signal.Signal;
   import model.ui.VOPortalItem;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.ResourcePanel;
   import ui.game.ShopNewIcon;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class PortalRenderer extends VRenderer
   {
      
      private const titleText:VText = UIFactory.createYellowText(null,VText.MIDDLE,22,true);
      
      private const iconSkin:VSkin = new VSkin(VSkin.NO_STRETCH);
      
      private var newIcon:ShopNewIcon;
      
      private var item:VOPortalItem;
      
      private var descText:VText;
      
      private var panel:VComponent;
      
      private var pricePanel:PriceListPanel;
      
      private var durationText:VText;
      
      private var resPanel:ResourcePanel;
      
      public var bt:RectButton;
      
      public function PortalRenderer()
      {
         super();
         layoutH = 163;
         add(SkinManager.getEmbed("RSeparator"),{"left":81});
         add(SkinManager.getEmbed("TrainCircleBg"),{
            "left":9,
            "top":4,
            "w":144,
            "h":144
         });
         add(SkinManager.getEmbed("Bolt"),{
            "left":83,
            "top":3
         });
         add(this.iconSkin,{
            "left":11,
            "top":8,
            "w":140,
            "h":140
         });
         this.titleText.format.lineHeight = "90%";
         add(this.titleText,{
            "left":170,
            "top":3,
            "w":350,
            "h":44
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:VSkin = null;
         this.item = param1 as VOPortalItem;
         this.titleText.value = Lang.getString(this.item.kind);
         SkinManager.applyExternal(this.iconSkin,this.item.kind,null,SkinManager.PNG | SkinManager.LOAD_CLIP);
         if(this.item.endTime > 0)
         {
            if(this.descText)
            {
               remove(this.panel);
               this.descText = null;
               this.pricePanel = null;
               this.bt = null;
               this.durationText = null;
            }
            if(!this.resPanel)
            {
               this.panel = new VComponent();
               this.panel.add(SkinManager.getEmbed("QGear"),{"top":32});
               this.panel.add(SkinManager.getEmbed("RaidLockBg",VSkin.STRETCH_BG),{
                  "left":39,
                  "right":0,
                  "top":23,
                  "bottom":0
               });
               this.panel.add(UIFactory.createYellowText(Lang.getString("raid_cooldown_run"),0,20),{
                  "left":170,
                  "w":340,
                  "maxH":68,
                  "vCenter":16
               });
               this.resPanel = new ResourcePanel(SkinManager.getEmbed("ClockIcon"),ResourcePanel.BG);
               this.panel.add(this.resPanel,{
                  "right":44,
                  "vCenter":16
               });
               addStretch(this.panel,0);
            }
            Signal.createRef(this,this.onSignal,Signal.ADD_TIMER).run(0,this.item.endTime,true);
         }
         else
         {
            if(this.resPanel)
            {
               Signal.stopRef(this);
               remove(this.panel);
               this.resPanel = null;
            }
            if(!this.descText)
            {
               this.panel = new VComponent();
               this.panel.add(SkinManager.getEmbed("QTargetBg",VSkin.STRETCH_BG),{
                  "top":23,
                  "bottom":0,
                  "wP":100
               });
               this.descText = new VText(null,VText.MIDDLE,Style.anthraciteRGB);
               this.descText.format.lineHeight = "100%";
               this.panel.add(this.descText,{
                  "left":170,
                  "right":212,
                  "top":60,
                  "h":36
               });
               _loc2_ = SkinManager.getEmbed("RaidPartyBg",VSkin.STRETCH);
               _loc2_.alpha = 0.5;
               this.panel.add(_loc2_,{
                  "left":183,
                  "top":103,
                  "w":328,
                  "h":30
               });
               this.panel.add(SkinManager.getEmbed("FeatureIconBg"),{
                  "left":170,
                  "top":99,
                  "w":40,
                  "h":40
               });
               this.panel.add(SkinManager.getEmbed("ClockIcon"),{
                  "left":175,
                  "top":103,
                  "w":30,
                  "h":30
               });
               this.panel.add(new VText(Lang.getString("raid_cooldown"),VText.CONTAIN,Style.anthraciteRGB),{
                  "left":218,
                  "top":110,
                  "w":200
               });
               if(this.item.isNew != Boolean(this.newIcon))
               {
                  if(this.item.isNew)
                  {
                     add(this.newIcon = new ShopNewIcon().launch(),{
                        "left":100,
                        "top":105
                     });
                  }
                  else
                  {
                     remove(this.newIcon);
                     this.newIcon = null;
                  }
               }
               this.panel.add(UIFactory.createDecorText(Lang.getString("prize"),true,28),{
                  "top":8,
                  "hCenter":270
               });
               this.pricePanel = new PriceListPanel();
               this.pricePanel.fontSize = 20;
               this.pricePanel.useVertical(45,68,62);
               this.panel.add(this.pricePanel,{
                  "hCenter":270,
                  "top":45
               });
               this.bt = new RectButton(Lang.getString("btRaid"),null,RectButton.ORANGE + RectButton.H56);
               this.bt.hCustom(48,10,120,18,-1);
               this.panel.add(this.bt,{
                  "bottom":0,
                  "hCenter":270
               });
               this.bt.addVarianceListener(this,0);
               this.durationText = UIFactory.createYellowText(null,VText.CONTAIN,20);
               if(this.item.radar)
               {
                  this.durationText.format.color = Style.lightGreenRGB;
                  this.durationText.syncFormat(true);
                  this.panel.add(SkinManager.getEmbed("PremiumArrowIcon"),{
                     "left":195,
                     "top":117
                  });
               }
               this.panel.add(this.durationText,{
                  "right":264,
                  "top":109,
                  "maxW":78
               });
               addStretch(this.panel,0);
            }
            this.descText.value = Lang.getString(this.item.kind + "_desc");
            this.pricePanel.assignList(this.item.prize);
            this.bt.data = param1;
            this.durationText.value = StringHelper.getTimeDesc(this.item.duration);
         }
      }
      
      public function getStartButton(param1:String) : VButton
      {
         return Boolean(this.bt) && this.item.kind == param1 ? this.bt : null;
      }
      
      private function onSignal(param1:Signal) : void
      {
         if(param1.tail == 0)
         {
            this.item.endTime = -1;
            this.setData(this.item);
            (dispatcher as VComponent).dispatchVarianceEvent(100);
         }
         else
         {
            this.resPanel.setCustom(StringHelper.getTimeDesc(param1.tail));
         }
      }
      
      override public function dispose() : void
      {
         Signal.stopRef(this);
         super.dispose();
      }
   }
}

