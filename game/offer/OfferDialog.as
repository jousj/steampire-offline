package game.offer
{
   import game.radar.RadarDialog;
   import model.QuestProxy;
   import proto.model.PCost;
   import proto.model.POfferGoods;
   import proto.model.PQuest;
   import proto.model.PQuestInfo;
   import proto.model.PQuestTarget;
   import proto.model.PQuestTargetInfo;
   import proto.model.PShopOffer;
   import proto.tuples.str_i;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.DurationPanel;
   import ui.game.ShineClip;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VLabel;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   
   public class OfferDialog extends BaseDialog
   {
      
      public var shop:PShopOffer;
      
      public var isGold:Boolean;
      
      public var startTime:Number;
      
      public var questData:PQuest;
      
      public var questInfo:PQuestInfo;
      
      private var badBox:Boolean;
      
      private var titleComponent:VComponent;
      
      private var bannerSkin:VSkin;
      
      private var durationBg:VSkin;
      
      private var durationPanel:DurationPanel;
      
      private var bt:VButton;
      
      private var box:VBox;
      
      private var btLabel:VLabel;
      
      private var shineClip:ShineClip;
      
      public function OfferDialog(param1:PQuest = null, param2:PQuestInfo = null)
      {
         var _loc3_:VSkin = null;
         super();
         setSize(609,487);
         this.questData = param1;
         this.questInfo = param2;
         _loc3_ = SkinManager.getPack(UIFactory.OFFER_PACK,"DialogBg",VSkin.STRETCH,0,this.onLoad);
         add(_loc3_,{
            "left":1,
            "top":46,
            "bottom":38
         });
         addCloseButton();
         closeBt.top = 14;
         if(_loc3_.isContent)
         {
            this.onLoad(null);
         }
         else
         {
            _loc3_.useCustomLoadClip(UIFactory.createLoadPanel(this,{
               "wP":100,
               "hP":100
            },0));
         }
      }
      
      public static function addGoodItems(param1:Vector.<VComponent>, param2:Array) : void
      {
         var _loc4_:POfferGoods = null;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc7_:POfferGoods = null;
         var _loc3_:uint = 0;
         for each(_loc4_ in param2)
         {
            _loc5_ = 0;
            if(_loc4_.variance == POfferGoods.BUY)
            {
               _loc6_ = int(param2.length - 1);
               while(_loc6_ >= 0)
               {
                  _loc7_ = param2[_loc6_];
                  if(_loc4_.variance == _loc7_.variance)
                  {
                     if(str_i(_loc4_.value).field_1 == str_i(_loc7_.value).field_1 && str_i(_loc4_.value).field_0 == str_i(_loc7_.value).field_0)
                     {
                        if(_loc6_ < _loc3_)
                        {
                           _loc5_ = -1;
                           break;
                        }
                        _loc5_++;
                     }
                  }
                  _loc6_--;
               }
            }
            if(_loc5_ >= 0)
            {
               param1.push(new OfferItemPanel(_loc4_,_loc5_));
            }
            _loc3_++;
         }
      }
      
      private function onLoad(param1:VEvent) : void
      {
         add(SkinManager.getPack(UIFactory.OFFER_PACK,"SectionBg"),null,1);
         add(SkinManager.getPack(UIFactory.OFFER_PACK,"SectionBg"),{"bottom":0});
         add(SkinManager.getEmbed("Bolt"),{"top":46});
         add(SkinManager.getEmbed("Bolt"),{
            "top":46,
            "right":0
         });
         add(SkinManager.getEmbed("Bolt"),{"bottom":48});
         add(SkinManager.getEmbed("Bolt"),{
            "bottom":48,
            "right":0
         });
         this.bt = new VButton();
         this.bt.addStretch(SkinManager.getPack(UIFactory.OFFER_PACK,"BuyBt",VSkin.STRETCH));
         this.btLabel = new VLabel(null,VLabel.CENTER | VLabel.MIDDLE | VLabel.LEADING_BOX);
         Style.applyDefaultFilter(this.btLabel);
         this.bt.setIcon(this.btLabel,{
            "left":17,
            "right":18,
            "top":10,
            "bottom":11
         });
         add(this.bt,{
            "hCenter":0,
            "bottom":16,
            "maxW":240
         });
         this.bt.addVarianceListener(this,0);
         if(this.questData)
         {
            this.useQuestMode();
         }
         else
         {
            this.bannerSkin = new VSkin();
            add(this.bannerSkin,{
               "left":11,
               "top":38
            },1);
            this.box = new VBox(null,20);
            add(this.box,{
               "bottom":110,
               "hCenter":0
            });
            if(this.shop)
            {
               this.assign();
            }
         }
         this.shineClip = new ShineClip();
         add(this.shineClip,null,0);
         this.shineClip.pause = !visible;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(this.shineClip)
         {
            this.shineClip.pause = !param1;
         }
      }
      
      private function useQuestMode() : void
      {
         var _loc1_:String = this.questData.qname;
         if(_loc1_ == QuestProxy.VK_SOCIAL_TANK)
         {
            this.useVKSocialTank();
         }
         else if(_loc1_ == QuestProxy.FB_MOBILE)
         {
            this.useFBMobile();
         }
      }
      
      public function setData(param1:PShopOffer, param2:Boolean, param3:Number) : void
      {
         this.shop = param1;
         this.isGold = param2;
         this.startTime = param3;
         if(this.box)
         {
            this.assign();
         }
      }
      
      private function setTitle(param1:String, param2:int = 36, param3:int = 14) : void
      {
         if(this.titleComponent)
         {
            remove(this.titleComponent);
         }
         this.titleComponent = UIFactory.createDecorText(param1,true,param2,480,false);
         add(this.titleComponent,{
            "top":param3,
            "hCenter":0
         });
      }
      
      private function setBtTitle(param1:String, param2:uint = 20) : void
      {
         this.btLabel.text = "<p fontSize=\"" + param2 + "\"" + Style.yellowColor + ">" + param1 + "</p>";
      }
      
      private function assign() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:VComponent = null;
         var _loc3_:Vector.<VComponent> = null;
         var _loc4_:uint = 0;
         var _loc5_:VBox = null;
         SkinManager.applyExternal(this.bannerSkin,this.shop.offer_icon ? this.shop.offer_icon : this.shop.offer_type,null,SkinManager.JPG);
         this.setTitle(Lang.getStringOrDefault(this.shop.offer_kind + "_title","so_default"));
         if(this.shop.offer_goods[0].variance == POfferGoods.SCOUTING)
         {
            _loc1_ = uint(this.shop.offer_goods[0].value);
            this.badBox = true;
            remove(this.box);
            layoutH = 540;
            this.box = new VBox();
            _loc2_ = new VComponent();
            RadarDialog.createScoutingPanel(_loc2_,0,0);
            this.box.add(_loc2_);
            add(this.box,{
               "hCenter":0,
               "vCenter":15
            });
            geometryPhase();
         }
         else if(this.shop.offer_kind.indexOf("so_starter_pack") != -1)
         {
            this.badBox = true;
            remove(this.box);
            this.box = new VBox(null,10,VBox.VERTICAL);
            this.box.scaleX = this.box.scaleY = 0.75;
            layoutH = 600;
            add(this.box,{
               "bottom":-16,
               "hCenter":70
            });
            _loc3_ = new Vector.<VComponent>();
            addGoodItems(_loc3_,this.shop.offer_goods);
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               if(_loc4_ % 2 == 0)
               {
                  _loc5_ = new VBox(null,15,VBox.CENTER);
                  this.box.add(_loc5_);
               }
               _loc5_.add(_loc3_[_loc4_]);
               _loc4_++;
            }
            geometryPhase();
         }
         else
         {
            if(this.badBox)
            {
               remove(this.box);
               this.badBox = false;
               this.box = new VBox(null,20);
               layoutH = 487;
               add(this.box,{
                  "bottom":110,
                  "hCenter":0
               });
               geometryPhase();
            }
            else
            {
               this.box.removeAll();
            }
            addGoodItems(this.box.list,this.shop.offer_goods);
         }
         if(this.shop.offer_sale1 > 0 && this.box.list.length > 0)
         {
            (this.box.list[0] as OfferItemPanel).showSale(this.shop.offer_sale1);
         }
         if(this.shop.offer_sale2 > 0 && this.box.list.length > 1)
         {
            (this.box.list[1] as OfferItemPanel).showSale(this.shop.offer_sale2);
         }
         this.box.addAll();
         if(_loc1_ > 0)
         {
            this.setBtTitle(_loc1_ + " " + Lang.getTimeString(_loc1_,Lang.DAY) + "\n" + (this.isGold ? CostHelper.get18String(PCost.GOLD,this.shop.offer_gold_price) : (this.shop.caption ? this.shop.offer_social_price + " " + this.shop.caption : Lang.getCurrency(this.shop.offer_social_price))));
         }
         else
         {
            this.setBtTitle(Lang.getPatternString("buy_offer_bt","__PRICE__",this.isGold ? CostHelper.get18String(PCost.GOLD,this.shop.offer_gold_price) : (this.shop.caption ? this.shop.offer_social_price + " " + this.shop.caption : Lang.getCurrency(this.shop.offer_social_price))));
         }
         if(this.shop.offer_duration > 0)
         {
            this.showDurationPanel();
         }
         else
         {
            this.hideDurationPanel();
         }
      }
      
      private function showDurationPanel() : void
      {
         var _loc1_:VText = null;
         var _loc2_:VBox = null;
         if(!this.durationPanel)
         {
            this.durationBg = SkinManager.getPack(UIFactory.OFFER_PACK,"TimeBg");
            this.durationBg.assignLayout({
               "hCenter":0,
               "top":86
            });
            this.durationPanel = new DurationPanel(28,20);
            _loc1_ = UIFactory.createYellowText(Lang.getString("offer_time"),VText.CONTAIN);
            _loc1_.maxW = 290;
            _loc2_ = new VBox(new <VComponent>[_loc1_,this.durationPanel]);
            _loc2_.assignLayout({
               "hCenter":0,
               "top":89
            });
         }
         else
         {
            _loc2_ = this.durationPanel.parent as VBox;
            if(!_loc2_.parent)
            {
               layoutH = 487;
               syncLayout();
            }
         }
         if(!_loc2_.parent)
         {
            add(this.durationBg);
            add(_loc2_);
         }
         this.durationPanel.setTrackTime(this.startTime + this.shop.offer_duration,true);
      }
      
      private function hideDurationPanel() : void
      {
         if(Boolean(this.durationPanel) && Boolean(this.durationPanel.parent.parent))
         {
            this.durationPanel.setTrackTime(0);
            remove(this.durationPanel,false);
            remove(this.durationBg,false);
            layoutH = 430;
            syncLayout();
         }
      }
      
      public function get isQuestComplete() : Boolean
      {
         var _loc1_:* = 0;
         if(Boolean(this.questData) && Boolean(this.questInfo))
         {
            _loc1_ = int(this.questData.qtargets.length - 1);
            while(_loc1_ >= 0)
            {
               if((this.questData.qtargets[_loc1_] as PQuestTarget).value < (this.questInfo.qi_targets[_loc1_] as PQuestTargetInfo).qti_count)
               {
                  return false;
               }
               _loc1_--;
            }
         }
         return true;
      }
      
      private function useFBMobile() : void
      {
         add(SkinManager.getExternal(Lang.locale == Lang.RU ? "fb_mobile_ru" : "fb_mobile_en",SkinManager.JPG | SkinManager.LOAD_CLIP),{
            "w":588,
            "h":460,
            "top":53,
            "left":11
         },1);
         this.setTitle(Lang.getString("fb_mobile_title"),34,15);
         var _loc1_:Boolean = this.isQuestComplete;
         if(_loc1_)
         {
            this.setBtTitle(Lang.getString("fb_get_reward"));
            add(SkinManager.getEmbed("CollectIcon"),{
               "right":80,
               "top":174,
               "h":34
            });
            add(SkinManager.getEmbed("CollectIcon"),{
               "right":80,
               "top":214,
               "h":34
            });
         }
         else
         {
            remove(this.bt);
         }
         layoutH = 572;
         syncLayout();
      }
      
      private function useVKMobile() : void
      {
         add(SkinManager.getExternal("vk_mobile2",SkinManager.JPG | SkinManager.LOAD_CLIP),{
            "w":588,
            "h":460,
            "top":53,
            "left":11
         },1);
         this.setTitle("Играй с любого устройства!",34,15);
         var _loc1_:Boolean = this.isQuestComplete;
         this.setBtTitle(_loc1_ ? "Забрать награду" : "Получить ссылку");
         if(_loc1_)
         {
            add(SkinManager.getEmbed("CollectIcon"),{
               "right":80,
               "top":174,
               "h":34
            });
            add(SkinManager.getEmbed("CollectIcon"),{
               "right":80,
               "top":214,
               "h":34
            });
         }
         layoutH = 572;
         syncLayout();
      }
      
      private function useVKSocialTank() : void
      {
         add(SkinManager.getExternal("sob_gold",SkinManager.JPG),{
            "left":11,
            "top":38
         },1);
         this.setTitle("Бесплатное золото");
         this.setBtTitle("Участвовать в акции");
         add(SkinManager.getPack(UIFactory.OFFER_PACK,"TimeBg",VSkin.STRETCH),{
            "hCenter":0,
            "top":86,
            "w":520
         });
         add(UIFactory.createYellowText("Участвуй в акции и получай золото!",VText.CONTAIN_CENTER,20),{
            "top":94,
            "hCenter":0,
            "w":490
         });
         add(new OfferItemPanel(POfferGoods.create(POfferGoods.COST,PCost.create(PCost.GOLD,0)),0),{
            "bottom":110,
            "hCenter":0
         });
      }
   }
}

