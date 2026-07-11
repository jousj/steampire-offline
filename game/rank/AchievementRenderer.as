package game.rank
{
   import model.ui.VOAchievementItem;
   import model.vo.VOQuest;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VProgressBar;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class AchievementRenderer extends VRenderer
   {
      
      private var titleComponent:VComponent;
      
      private var prizeComponent:VComponent;
      
      private var priceListPanel:PriceListPanel;
      
      private var takeBt:RectButton;
      
      private var takeBg:VSkin;
      
      private var pb:VProgressBar;
      
      private var pbText:VText;
      
      private const descText:VText = new VText(null,VText.CENTER | VText.MIDDLE,Style.metalRGB,16);
      
      private const prizeBox:VBox = new VBox(null,10,VBox.VERTICAL);
      
      private const starsBlock:StarsBlock = new StarsBlock(true);
      
      private const starsBlockAdd:StarsBlock = new StarsBlock(false);
      
      public function AchievementRenderer()
      {
         super();
         layoutH = 134;
         add(SkinManager.getEmbed("WhBlockBg",VSkin.STRETCH),{
            "left":114,
            "top":10,
            "bottom":0,
            "right":0
         });
         add(this.descText,{
            "hCenter":28,
            "w":348,
            "h":42
         });
         add(this.starsBlockAdd,{
            "top":57,
            "hCenter":-260
         });
         add(this.starsBlock,{
            "bottom":2,
            "hCenter":-260
         });
         add(this.prizeBox,{
            "vCenter":1,
            "hCenter":288
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc6_:int = 0;
         var _loc7_:PricePanel = null;
         var _loc2_:VOAchievementItem = param1 as VOAchievementItem;
         if(this.titleComponent)
         {
            remove(this.titleComponent);
         }
         var _loc3_:VOQuest = _loc2_.quest;
         var _loc4_:* = _loc2_.index;
         if(_loc4_ > _loc2_.max_index - 1)
         {
            _loc6_ = 3;
            _loc4_--;
         }
         else if(_loc3_)
         {
            _loc6_ = _loc3_.isComplete ? 2 : 1;
         }
         else
         {
            _loc6_ = 0;
         }
         this.titleComponent = UIFactory.createDecorText(_loc2_.lang + ": " + Lang.getString("achv_title" + _loc4_),true,26,_loc6_ == 2 ? 430 : 530,false);
         this.titleComponent.hCenter = 28;
         if(_loc6_ == 2 && this.titleComponent.layoutW > 340)
         {
            this.titleComponent.hCenter -= (this.titleComponent.layoutW - 340) / 2;
         }
         add(this.titleComponent);
         this.descText.value = Lang.getStringOrDefault(_loc2_.kind + "_" + (_loc4_ + 1) + "_desc",_loc2_.kind + "_desc");
         this.prizeBox.removeAll(false);
         if(this.prizeComponent)
         {
            this.prizeComponent.dispose();
         }
         if(Boolean(this.takeBg) && _loc6_ != 2)
         {
            this.takeBg.removeFromParent(false);
         }
         var _loc5_:Vector.<VComponent> = this.prizeBox.list;
         if(_loc6_ == 1 || _loc6_ == 2)
         {
            this.descText.top = 30;
            this.prizeComponent = UIFactory.createDecorText(Lang.getString("prize"),true,22,150,false);
            if(!this.priceListPanel)
            {
               this.priceListPanel = new PriceListPanel(6);
               this.priceListPanel.maxW = 150;
               this.priceListPanel.setStyle(32,20);
               new VComponent().addChild(this.priceListPanel);
               (this.priceListPanel.parent as VComponent).add(SkinManager.getEmbed("StatBg",VSkin.STRETCH_BG),{
                  "left":-6,
                  "right":-6,
                  "top":-1,
                  "bottom":-2
               },0);
               this.pb = UIFactory.createProgressBar("LightGreenIndicator");
               this.pbText = UIFactory.createYellowText(null,VText.CENTER,18,true);
               this.pb.add(this.pbText,{
                  "left":14,
                  "right":14,
                  "vCenter":1
               });
               this.pb.assignLayout({
                  "hCenter":28,
                  "w":330,
                  "bottom":20,
                  "h":37
               });
            }
            this.priceListPanel.assignList(_loc3_.meta.qi_prize);
            if(_loc2_.pointList[_loc4_] > 0)
            {
               _loc7_ = this.priceListPanel.getPricePanel(null);
               SkinManager.applyEmbed(_loc7_.skin,"AchvPointsIcon");
               _loc7_.setValue(_loc2_.pointList[_loc4_]);
               _loc7_.hint = Lang.getString("achv_points");
               this.priceListPanel.addPricePanel(_loc7_);
            }
            _loc5_.push(this.prizeComponent,this.priceListPanel.parent);
            if(!this.pb.parent)
            {
               add(this.pb);
            }
            this.pb.value = _loc3_.count / _loc3_.target.qti_count;
            this.pbText.value = _loc6_ == 2 ? _loc3_.target.qti_count.toString() : _loc3_.count + "/" + _loc3_.target.qti_count;
            if(_loc6_ == 2)
            {
               if(!this.takeBt)
               {
                  this.takeBt = new RectButton(Lang.getString("collectQuestBt"),RectButton.h56,RectButton.ORANGE);
                  this.takeBt.maxW = 150;
                  this.takeBt.addVarianceListener(this,0);
                  this.takeBg = SkinManager.getPack("RankDialog","CollectBg",VSkin.STRETCH);
                  this.takeBg.assignLayout({
                     "left":124,
                     "right":9,
                     "top":18,
                     "bottom":10
                  });
               }
               this.takeBt.data = _loc2_;
               _loc5_.push(this.takeBt);
               if(!this.takeBg.parent)
               {
                  add(this.takeBg,null,1);
               }
            }
         }
         else
         {
            this.descText.top = 48;
            if(this.pb)
            {
               this.pb.removeFromParent(false);
            }
            this.prizeComponent = new VComponent();
            this.prizeComponent.setSize(132,38);
            this.prizeComponent.addStretch(SkinManager.getEmbed("StatBg",VSkin.STRETCH));
            this.prizeComponent.add(SkinManager.getPack("RankDialog","Collect"),{
               "left":-16,
               "top":-3
            });
            this.prizeComponent.add(UIFactory.createDecorText(Lang.getString("achv_complete"),true,26,120,false),{
               "hCenter":0,
               "vCenter":-1
            });
            _loc5_.push(this.prizeComponent);
         }
         this.prizeBox.addAll();
         this.descText.syncLayout();
         this.starsBlock.syncStars(_loc2_);
         if(_loc2_.index > 2 && _loc2_.max_index > 5)
         {
            this.starsBlockAdd.visible = true;
            this.starsBlockAdd.resetLayout();
            this.starsBlockAdd.assignLayout({
               "bottom":2,
               "hCenter":-260
            });
            this.starsBlock.resetLayout();
            this.starsBlock.assignLayout({
               "top":57,
               "hCenter":-225
            });
            this.starsBlock.scaleX = this.starsBlock.scaleY = 0.7;
            this.starsBlockAdd.geometryPhase();
            this.starsBlock.geometryPhase();
            this.starsBlockAdd.syncStars(_loc2_);
         }
         else
         {
            this.starsBlockAdd.visible = false;
            this.starsBlock.resetLayout();
            this.starsBlock.assignLayout({
               "bottom":2,
               "hCenter":-260
            });
            this.starsBlock.scaleX = this.starsBlock.scaleY = 1;
            this.starsBlock.geometryPhase();
         }
      }
      
      override public function dispose() : void
      {
         if(disposeFloat(this.priceListPanel))
         {
            this.pb.dispose();
         }
         if(disposeFloat(this.takeBt))
         {
            this.takeBg.dispose();
         }
         super.dispose();
      }
   }
}

