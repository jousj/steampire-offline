package game.rank
{
   import proto.model.PShopDivision;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class LeagueRenderer extends VRenderer
   {
      
      private const panel:VComponent = new VComponent();
      
      private const skin:VSkin = new VSkin();
      
      private const titleText:VText = UIFactory.createYellowText(null,VText.CONTAIN,22,true);
      
      private const infoText:VText = UIFactory.createYellowText(null,0,22);
      
      private const toBt:RectButton = new RectButton(Lang.getString("to_league"),RectButton.h56);
      
      private var prizeBox:VBox;
      
      private var prizePanel:PriceListPanel;
      
      private var lockSkin:VSkin;
      
      private var curSkin:VSkin;
      
      private var completeBox:VBox;
      
      private var myInfo:VComponent;
      
      private var myText:VText;
      
      public function LeagueRenderer()
      {
         super();
         setSize(748,154);
         this.panel.add(SkinManager.getEmbed("QTargetBg"),{"top":20});
         this.panel.add(SkinManager.getEmbed("TrainCircleBg",VSkin.STRETCH),{
            "w":113,
            "h":113,
            "left":10,
            "top":6
         });
         this.panel.add(SkinManager.getEmbed("RSeparator",VSkin.STRETCH),{
            "w":424,
            "h":49,
            "left":75
         },1);
         this.panel.add(SkinManager.getEmbed("Bolt"),{
            "left":90,
            "top":6
         });
         this.panel.add(this.titleText,{
            "left":132,
            "top":13,
            "w":350
         });
         add(this.panel);
         add(this.skin,{
            "left":14,
            "top":13,
            "w":106,
            "h":100
         });
         this.toBt.addVarianceListener(this,5);
         add(this.toBt,{
            "hCenter":256,
            "vCenter":6,
            "w":160
         });
         add(SkinManager.getEmbed("Exp"),{
            "left":136,
            "vCenter":13,
            "w":40,
            "h":40
         });
         add(this.infoText,{
            "left":184,
            "vCenter":15
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc8_:PShopDivision = null;
         var _loc9_:VText = null;
         var _loc2_:PShopDivision = param1 as PShopDivision;
         this.titleText.value = Lang.getString("league" + _loc2_.division_num);
         SkinManager.applyEmbed(this.skin,"league" + _loc2_.division_num);
         if(_loc2_.division_num > 1)
         {
            _loc8_ = Facade.manualProxy.getLeagueShop(_loc2_.division_num - 1,false,true);
         }
         var _loc3_:int = _loc8_ ? int(_loc8_.division_level + 1) : 1;
         this.infoText.value = _loc3_ + "-" + _loc2_.division_level;
         this.toBt.data = _loc2_;
         var _loc4_:int = int(Facade.userProxy.level);
         var _loc5_:Boolean = _loc4_ >= _loc3_ && _loc4_ <= _loc2_.division_level;
         var _loc6_:Boolean = _loc4_ > _loc2_.division_level;
         var _loc7_:Boolean = !_loc5_ && !_loc6_;
         if(!_loc6_)
         {
            removeFloat(this.completeBox);
         }
         if(_loc7_)
         {
            if(!this.prizeBox)
            {
               this.prizePanel = new PriceListPanel();
               this.prizePanel.useVertical();
               _loc9_ = new VText(Lang.getString("league_prize"),VText.CONTAIN,Style.metalRGB,16);
               _loc9_.maxW = this.prizePanel.maxW = 190;
               this.prizeBox = new VBox(new <VComponent>[_loc9_,this.prizePanel],3,VBox.VERTICAL);
               this.prizeBox.assignLayout({
                  "hCenter":30,
                  "vCenter":18
               });
            }
            this.panel.addFloat(this.prizeBox);
            this.prizePanel.assignList(_loc2_.division_reward);
         }
         else
         {
            this.panel.removeFloat(this.prizeBox);
            if(_loc6_)
            {
               if(!this.completeBox)
               {
                  this.completeBox = new VBox(new <VComponent>[SkinManager.getEmbed("CollectIcon"),UIFactory.createDecorText(Lang.getString("league_complete"),true,22,170)]);
                  this.completeBox.assignLayout({
                     "hCenter":30,
                     "vCenter":12
                  });
               }
               addFloat(this.completeBox);
            }
         }
         if(_loc5_ != Boolean(this.curSkin))
         {
            if(_loc5_)
            {
               this.curSkin = SkinManager.getEmbed("QTargetFg");
               this.panel.add(this.curSkin,{
                  "left":48,
                  "top":27
               },1);
               this.myInfo = UIFactory.createDecorText(Lang.getString("active_league"),true,24,190);
               add(this.myInfo,{
                  "top":11,
                  "hCenter":256
               });
               this.myText = new VText(Lang.getString("my_league_desc"),VText.CENTER,Style.metalRGB,14);
               add(this.myText,{
                  "hCenter":30,
                  "vCenter":15,
                  "maxW":190,
                  "maxH":65
               });
            }
            else
            {
               this.panel.remove(this.curSkin);
               this.curSkin = null;
               remove(this.myInfo);
               this.myInfo = null;
               remove(this.myText);
               this.myText = null;
            }
         }
         if(_loc7_ != Boolean(this.lockSkin && this.lockSkin.parent))
         {
            this.panel.filters = _loc7_ ? VSkin.GREY_FILTER : null;
            if(_loc7_)
            {
               if(!this.lockSkin)
               {
                  this.lockSkin = SkinManager.getEmbed("LockIcon");
                  this.lockSkin.assignLayout({
                     "left":-15,
                     "top":57,
                     "h":60
                  });
               }
               addFloat(this.lockSkin);
            }
            else
            {
               removeFloat(this.lockSkin);
            }
         }
      }
      
      override public function dispose() : void
      {
         disposeFloat(this.completeBox);
         this.panel.disposeFloat(this.prizeBox);
         disposeFloat(this.lockSkin);
         super.dispose();
      }
   }
}

