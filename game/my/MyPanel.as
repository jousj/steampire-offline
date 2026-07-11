package game.my
{
   import ESkins.ArmorIcon;
   import engine.units.Build;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import game.barrack.BarrackMediator;
   import game.offer.OfferButton;
   import game.quest.QuestBtPanel;
   import proto.model.PBtype;
   import proto.model.PCost;
   import proto.model.PCurrentAdventure;
   import ui.common.CircleButton;
   import ui.common.CountPanel;
   import ui.game.ResourcePanel;
   import ui.game.ShopNewIcon;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class MyPanel extends VComponent
   {
      
      public static const GO:uint = 1;
      
      public static const SHOP:uint = 2;
      
      public static const CLAN:uint = 3;
      
      public static const SOCIAL:uint = 4;
      
      public static const CHAT:uint = 5;
      
      public static const HISTORY:uint = 6;
      
      public static const BARRACK:uint = 7;
      
      public static const DEAD_TROOPS:uint = 8;
      
      private static const lo:Array = [[[8,8]],[[8,71],[64,8]],[[8,110],[70,70],[110,8]]];
      
      private const energySkin:VSkin;
      
      private const gearPanel:VComponent;
      
      public const leftPanel:VComponent;
      
      public const expPanel:ExpPanel;
      
      public const oilPanel:ResourcePanel;
      
      public const crystalPanel:ResourcePanel;
      
      public const goldPanel:ResourcePanel;
      
      public const onyxPanel:ResourcePanel;
      
      public const energyPanel:ResourcePanel;
      
      public const workerPanel:ResourcePanel;
      
      public const ratingPanel:ResourcePanel;
      
      public const shieldPanel:ShieldPanel;
      
      public const questBtPanel:QuestBtPanel;
      
      public const goBt:CircleButton;
      
      public const shopBt:CircleButton;
      
      public var lbPanel:VComponent;
      
      public var chatBt:VButton;
      
      public var barrackBt:VComponent;
      
      public var troopsCnt:VComponent;
      
      public var offerBt:OfferButton;
      
      public var radarTimer:ResourcePanel;
      
      public var offerList:Vector.<String>;
      
      public var adventureBt:VButton;
      
      public var armorButton:ArmorIcon;
      
      private var historyBt:VButton;
      
      private var editBt:CircleButton;
      
      private var radarBt:VButton;
      
      public function MyPanel()
      {
         var _loc1_:VSkin = null;
         var _loc2_:Shape = null;
         var _loc3_:VComponent = null;
         this.energySkin = new VSkin();
         this.gearPanel = new VComponent();
         this.leftPanel = new VComponent();
         this.expPanel = new ExpPanel();
         this.oilPanel = new ResourcePanel(PCost.OIL,ResourcePanel.PROGRESS | ResourcePanel.TWEEN | ResourcePanel.CACHE_AS_BITMAP);
         this.crystalPanel = new ResourcePanel(PCost.CRYSTAL,ResourcePanel.PROGRESS | ResourcePanel.TWEEN | ResourcePanel.CACHE_AS_BITMAP);
         this.goldPanel = new ResourcePanel(PCost.GOLD,ResourcePanel.TWEEN | ResourcePanel.CACHE_AS_BITMAP);
         this.onyxPanel = new ResourcePanel(PCost.MITHRIL,ResourcePanel.PROGRESS | ResourcePanel.TWEEN | ResourcePanel.CACHE_AS_BITMAP);
         this.energyPanel = new ResourcePanel(this.energySkin,ResourcePanel.BG | ResourcePanel.PROGRESS | ResourcePanel.SKIP_HINT,"BlueIndicatorS");
         this.workerPanel = new ResourcePanel(SkinManager.getEmbed("WorkerIcon"),ResourcePanel.CACHE_AS_BITMAP);
         this.ratingPanel = new ResourcePanel(SkinManager.getEmbed("RatingIcon"),ResourcePanel.TWEEN | ResourcePanel.CACHE_AS_BITMAP);
         this.shieldPanel = new ShieldPanel();
         this.questBtPanel = new QuestBtPanel();
         this.goBt = this.addButton(GO,100,"GoIcon",CircleButton.ORANGE,144,10,Lang.getString("battleGroup"));
         this.shopBt = this.addButton(SHOP,100,"ShopIcon",CircleButton.GOLD,42,10,Lang.getString("shopBt"));
         super();
         add(this.questBtPanel,{
            "left":12,
            "top":120,
            "bottom":80
         });
         this.addButton(CLAN,100,"ClanEmblemIcon",CircleButton.GOLD,84,110,Lang.getString("bl_clan_center")).icon.layoutH = 68;
         this.addButton(SOCIAL,70,"FriendsIcon",CircleButton.GOLD,4,120,Lang.getString("friends"));
         _loc1_ = SkinManager.getEmbed("FrontGear");
         this.gearPanel.add(_loc1_,{
            "right":-25,
            "bottom":0
         },0);
         _loc2_ = new Shape();
         _loc2_.graphics.beginFill(0,0);
         _loc2_.graphics.drawCircle(0,0,120);
         this.gearPanel.addChild(_loc2_).x = 148;
         _loc2_.y = 144;
         _loc1_.mask = _loc2_;
         add(this.gearPanel,{
            "w":242,
            "h":200,
            "bottom":0
         });
         this.leftPanel.setSize(454,84);
         this.leftPanel.add(SkinManager.getEmbed("LeftMainBg",VSkin.CACHE_AS_BITMAP),{"left":44});
         this.leftPanel.addChild(this.expPanel).cacheAsBitmap = true;
         this.onyxPanel.layoutW = this.goldPanel.layoutW = 150;
         this.leftPanel.add(this.onyxPanel,{
            "left":90,
            "bottom":0
         });
         this.leftPanel.add(this.goldPanel,{"left":90});
         this.oilPanel.right = 0;
         this.oilPanel.layoutW = this.crystalPanel.layoutW = 197;
         this.leftPanel.addChild(this.oilPanel);
         this.leftPanel.add(this.crystalPanel,{
            "right":0,
            "bottom":0
         });
         add(this.leftPanel,{
            "left":10,
            "top":10
         });
         _loc3_ = new VComponent();
         _loc3_.add(SkinManager.getEmbed("RightMainBg"),{
            "left":12,
            "top":4
         });
         _loc3_.addChild(this.workerPanel).cacheAsBitmap = true;
         this.energyPanel.top = 45;
         _loc3_.addChild(this.energyPanel);
         this.ratingPanel.top = 90;
         _loc3_.addChild(this.ratingPanel);
         add(_loc3_,{
            "right":10,
            "top":10
         });
      }
      
      public static function changeButtonCount(param1:VButton, param2:int, param3:Object = null) : void
      {
         var _loc4_:CountPanel = null;
         if(Boolean(param1) && param1.numChildren > 0)
         {
            _loc4_ = param1.getChildAt(param1.numChildren - 1) as CountPanel;
            if(param2 != 0)
            {
               if(!_loc4_)
               {
                  _loc4_ = new CountPanel(0,false);
                  param1.add(_loc4_,param3 ? param3 : {
                     "right":-4,
                     "bottom":0
                  });
               }
               if(param2 < 0)
               {
                  _loc4_.title = "!";
               }
               else
               {
                  _loc4_.value = param2;
               }
            }
            else if(_loc4_)
            {
               _loc4_.removeFromParent();
            }
         }
      }
      
      private function addButton(param1:uint, param2:uint, param3:String, param4:String, param5:int, param6:int, param7:String) : CircleButton
      {
         var _loc8_:CircleButton = new CircleButton(SkinManager.getEmbed(param3),param4);
         _loc8_.cacheAsBitmap = true;
         _loc8_.sizeCustom(param2);
         _loc8_.right = param5;
         _loc8_.bottom = param6;
         _loc8_.hint = param7;
         _loc8_.addVarianceListener(this,param1);
         this.gearPanel.addChild(_loc8_);
         return _loc8_;
      }
      
      override protected function customUpdate() : void
      {
         super.customUpdate();
         var _loc1_:uint = 1460;
         if(w >= _loc1_)
         {
            this.gearPanel.x = (w + _loc1_ >> 1) - this.gearPanel.w;
         }
         else
         {
            this.gearPanel.x = w - this.gearPanel.w;
         }
      }
      
      public function setCompactMode(param1:Boolean) : void
      {
         param1 = !param1;
         this.gearPanel.visible = this.questBtPanel.visible = param1;
         if(this.lbPanel)
         {
            this.lbPanel.visible = param1;
         }
         if(this.editBt)
         {
            this.editBt.visible = param1;
         }
         if(this.offerBt)
         {
            this.offerBt.visible = param1;
         }
      }
      
      public function changeNewIcon(param1:VButton, param2:Boolean) : void
      {
         var _loc3_:ShopNewIcon = null;
         if(Boolean(param1) && param1.numChildren > 0)
         {
            _loc3_ = param1.getChildAt(param1.numChildren - 1) as ShopNewIcon;
            if(param2)
            {
               if(!_loc3_)
               {
                  param1.add(new ShopNewIcon().launch(),{
                     "left":param1.measuredWidth / 2,
                     "bottom":15
                  });
               }
            }
            else if(_loc3_)
            {
               _loc3_.removeFromParent();
            }
         }
      }
      
      public function syncHistoryButton(param1:int, param2:int = -1) : void
      {
         if(!this.historyBt)
         {
            this.historyBt = new CircleButton(SkinManager.getEmbed("HistoryIcon"),CircleButton.TEAL);
            this.historyBt.setSize(70,70);
            this.historyBt.cacheAsBitmap = true;
            this.historyBt.addVarianceListener(this,HISTORY);
         }
         this.historyBt.disabled = param2 == 0;
         this.syncLBPanel();
         changeButtonCount(this.historyBt,param1);
      }
      
      public function syncClanButton(param1:Boolean, param2:Boolean = false) : void
      {
         if(!this.chatBt)
         {
            this.chatBt = new CircleButton(SkinManager.getEmbed("ChatIcon"),CircleButton.GOLD);
            this.chatBt.setSize(70,70);
            this.chatBt.cacheAsBitmap = true;
            this.chatBt.addVarianceListener(this,CHAT);
         }
         this.chatBt.disabled = !param1;
         if(!param1)
         {
            this.chatBt.hint = Lang.getString("chat_info");
            this.chatBt.mouseEnabled = true;
         }
         else
         {
            this.chatBt.hint = null;
         }
         if(param2 && Boolean(this.historyBt))
         {
            this.historyBt.disabled = true;
         }
         this.syncLBPanel();
         changeButtonCount(this.chatBt,0);
      }
      
      public function syncLBPanel() : void
      {
         var _loc3_:String = null;
         var _loc4_:VComponent = null;
         var _loc1_:Array = [];
         this.checkCreateBarrackBt();
         if(this.barrackBt)
         {
            _loc1_.push(this.barrackBt);
         }
         if(this.historyBt)
         {
            _loc1_.push(this.historyBt);
         }
         if(this.chatBt)
         {
            _loc1_.push(this.chatBt);
         }
         if(_loc1_.length == 0)
         {
            if(this.lbPanel)
            {
               remove(this.lbPanel);
               this.lbPanel = null;
            }
         }
         else
         {
            if(!this.lbPanel)
            {
               this.lbPanel = new VComponent();
               this.lbPanel.visible = this.gearPanel.visible;
               this.lbPanel.add(new VSkin(VSkin.CACHE_AS_BITMAP),{"bottom":0});
               this.lbPanel.add(new VSkin(VSkin.CACHE_AS_BITMAP),{"bottom":0});
               add(this.lbPanel,{
                  "left":0,
                  "bottom":0,
                  "w":100,
                  "h":100
               });
               this.lbPanel.add(this.shieldPanel,{
                  "hCenter":2,
                  "vCenter":-2
               });
            }
            this.shieldPanel.visible = _loc1_.length == 3;
            switch(_loc1_.length)
            {
               case 1:
                  _loc3_ = "GearLBPart";
                  (this.lbPanel.getChildAt(0) as VSkin).layoutW = 0;
                  (this.lbPanel.getChildAt(1) as VSkin).layoutW = 0;
                  break;
               case 2:
                  _loc3_ = "ChatGear";
                  (this.lbPanel.getChildAt(0) as VSkin).layoutW = 0;
                  (this.lbPanel.getChildAt(1) as VSkin).layoutW = 0;
                  break;
               case 3:
                  (this.lbPanel.getChildAt(0) as VSkin).layoutW = 150;
                  (this.lbPanel.getChildAt(1) as VSkin).layoutW = 150;
                  _loc3_ = "ChatGear";
            }
            SkinManager.applyEmbed(this.lbPanel.getChildAt(0) as VSkin,_loc3_);
            SkinManager.applyEmbed(this.lbPanel.getChildAt(1) as VSkin,_loc3_);
            (this.lbPanel.getChildAt(0) as VSkin).syncLayout();
            (this.lbPanel.getChildAt(1) as VSkin).syncLayout();
         }
         this.questBtPanel.bottom = _loc1_.length > 1 ? 150 : 80;
         this.questBtPanel.syncLayout();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc4_ = _loc1_[_loc2_];
            if(!_loc4_.parent)
            {
               this.lbPanel.add(_loc4_);
            }
            _loc4_.left = lo[_loc1_.length - 1][_loc2_][0];
            _loc4_.bottom = lo[_loc1_.length - 1][_loc2_][1];
            _loc4_.syncLayout();
            _loc2_++;
         }
      }
      
      private function checkCreateBarrackBt() : void
      {
         var _loc1_:Build = null;
         var _loc2_:VButton = null;
         var _loc3_:VButton = null;
         if(!this.barrackBt && Facade.isMyMap)
         {
            _loc1_ = Facade.userProxy.getBuild(PBtype.BARRACK,false,1);
            if(_loc1_)
            {
               this.barrackBt = new VComponent();
               this.barrackBt.setSize(70,70);
               this.troopsCnt = new VComponent();
               this.barrackBt.add(this.troopsCnt,{
                  "hCenter":0,
                  "vCenter":0,
                  "w":70,
                  "h":70
               });
               _loc2_ = new CircleButton(SkinManager.getEmbed("TombIcon"),CircleButton.GOLD);
               _loc2_.addVarianceListener(this,DEAD_TROOPS,_loc1_);
               _loc2_.hint = Lang.getString("dead_troops");
               this.troopsCnt.add(_loc2_,{
                  "right":-25,
                  "top":-25,
                  "w":50,
                  "h":50
               });
               this.barrackBt.addListener(MouseEvent.ROLL_OVER,this.onMouseBarrackBtOver);
               this.barrackBt.addListener(MouseEvent.ROLL_OUT,this.onMouseBarrackBtOut);
               _loc3_ = new CircleButton(SkinManager.getEmbed("BarrackIcon"),CircleButton.GOLD);
               _loc3_.cacheAsBitmap = true;
               _loc3_.addVarianceListener(this,BARRACK,_loc1_);
               this.barrackBt.add(_loc3_,{
                  "w":70,
                  "h":70
               });
               this.troopsCnt.visible = false;
               _loc2_.disabled = _loc3_.disabled = _loc1_.level < 3;
               this.barrackBt.hint = Lang.getString("barracks_info");
            }
         }
         else if(!Facade.isMyMap)
         {
            if(this.barrackBt)
            {
               this.barrackBt.removeFromParent();
               this.barrackBt = null;
            }
         }
      }
      
      private function onMouseBarrackBtOver(param1:*) : void
      {
         this.troopsCnt.visible = BarrackMediator.checkLastArmy();
      }
      
      private function onMouseBarrackBtOut(param1:*) : void
      {
         this.troopsCnt.visible = false;
      }
      
      public function setCapitalMode(param1:Boolean) : void
      {
         this.onyxPanel.cur = this.crystalPanel.cur = this.oilPanel.cur = this.goldPanel.cur = 0;
         this.crystalPanel.changeClanMode(param1);
         this.oilPanel.changeClanMode(param1);
         this.goldPanel.changeClanMode(param1);
         this.onyxPanel.changeClanMode(param1);
         this.goldPanel.hint = this.goldPanel.getCostHint();
         this.expPanel.compactLevelMode = param1;
         if(param1)
         {
            this.leftPanel.add(this.workerPanel,{
               "left":470,
               "w":150
            });
            remove(this.leftPanel,false);
            this.leftPanel.top = 10;
            if(this.lbPanel)
            {
               remove(this.lbPanel,false);
            }
            if(this.radarBt)
            {
               this.leftPanel.remove(this.radarBt);
               this.radarBt = null;
            }
         }
         else
         {
            (this.energyPanel.parent as VComponent).add(this.workerPanel,{
               "left":0,
               "w":163
            });
            this.leftPanel.top = 10;
            add(this.leftPanel);
            if(this.lbPanel)
            {
               add(this.lbPanel);
            }
         }
         if(this.goldPanel.buyBt)
         {
            this.goldPanel.buyBt.visible = !param1;
            this.goldPanel.useBuyBtLayout(!param1);
         }
      }
      
      public function addOffer(param1:String) : void
      {
         var _loc2_:int = 0;
         if(!this.offerList)
         {
            this.offerList = new Vector.<String>();
            this.offerBt = new OfferButton();
            this.offerBt.left = 8;
            this.offerBt.top = 100;
            if(Facade.fakeResize)
            {
               this.offerBt.scaleX = this.offerBt.scaleY = 0.8;
               _loc2_ = -20;
            }
            if(this.radarTimer)
            {
               this.questBtPanel.top = 165 + this.offerBt.layoutH + _loc2_;
               this.radarTimer.top = 200 + _loc2_;
               this.radarTimer.syncLayout();
            }
            else
            {
               this.questBtPanel.top = 105 + this.offerBt.layoutH + _loc2_;
            }
            this.questBtPanel.syncLayout();
            add(this.offerBt);
            this.offerBt.visible = this.gearPanel.visible;
         }
         this.offerList.push(param1);
         if(this.offerList.length == 2)
         {
            this.offerBt.swipe = true;
         }
      }
      
      public function setRadarTimer(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         if(Facade.fakeResize)
         {
            _loc2_ = -20;
         }
         if(param1 != Boolean(this.radarTimer))
         {
            if(param1)
            {
               this.radarTimer = new ResourcePanel(SkinManager.getEmbed("RadarIconAnim"));
               SkinManager.applyEmbed(this.radarTimer.getChildAt(0) as VSkin,"PremiumTimerBg");
               if(this.offerList)
               {
                  this.questBtPanel.top = 165 + this.offerBt.layoutH + _loc2_;
                  add(this.radarTimer,{
                     "left":12,
                     "top":200 + _loc2_
                  },0);
               }
               else
               {
                  this.questBtPanel.top = 180 + _loc2_;
                  add(this.radarTimer,{
                     "left":12,
                     "top":120 + _loc2_
                  },0);
               }
               this.questBtPanel.syncLayout();
            }
            else
            {
               this.questBtPanel.top = (this.offerList ? 105 : 120) + _loc2_;
               this.questBtPanel.syncLayout();
               remove(this.radarTimer);
               this.radarTimer = null;
            }
         }
      }
      
      public function removeOffer(param1:String) : void
      {
         var _loc2_:int = 0;
         if(this.offerList)
         {
            _loc2_ = this.offerList.indexOf(param1);
            if(_loc2_ >= 0)
            {
               if(this.offerList.length == 1)
               {
                  this.resetOffer();
               }
               else
               {
                  this.offerList.splice(_loc2_,1);
                  if(this.offerList.length == 1)
                  {
                     this.offerBt.swipe = false;
                  }
                  if(param1 == this.offerBt.data)
                  {
                     this.offerBt.change();
                  }
               }
            }
         }
      }
      
      public function resetOffer() : void
      {
         if(this.offerList)
         {
            this.offerList = null;
            this.offerBt.removeFromParent();
            this.offerBt = null;
            if(this.radarTimer)
            {
               this.questBtPanel.top = 180;
               this.radarTimer.top = 120;
               this.radarTimer.syncLayout();
            }
            else
            {
               this.questBtPanel.top = 120;
            }
            this.questBtPanel.syncLayout();
         }
      }
      
      public function getOfferKind(param1:String, param2:int) : String
      {
         if(!this.offerList)
         {
            return null;
         }
         param2 += this.offerList.indexOf(param1);
         if(param2 >= this.offerList.length)
         {
            param2 = 0;
         }
         else if(param2 < 0)
         {
            param2 = this.offerList.length - 1;
         }
         return this.offerList[param2];
      }
      
      public function useEditButton(param1:Function, param2:int = -1) : void
      {
         if(param1 != null != Boolean(this.editBt))
         {
            if(this.editBt)
            {
               remove(this.editBt);
               this.editBt = null;
            }
            else
            {
               this.editBt = new CircleButton(SkinManager.getEmbed("EditorIcon"),CircleButton.GOLD,CircleButton.size70);
               this.editBt.hint = Lang.getString("editor_mode");
               this.editBt.addClickListener(param1);
               this.editBt.skin.filters = [new GlowFilter(16776960,1,8,8,3)];
               changeButtonCount(this.editBt,param2);
               add(this.editBt,{
                  "hCenter":-50,
                  "bottom":8
               },0);
            }
         }
      }
      
      public function useRadarButton(param1:Function) : void
      {
         if(param1 != null != Boolean(this.radarBt))
         {
            if(this.radarBt)
            {
               this.leftPanel.remove(this.radarBt);
               this.radarBt = null;
            }
            else
            {
               this.radarBt = VButton.create(SkinManager.getEmbed("RadarIconAnim",VSkin.PLAY_MOVIE_CLIP));
               this.radarBt.hint = Lang.getString("bl_scouting_hh");
               this.radarBt.addClickListener(param1);
               this.radarBt.left = 55;
               this.leftPanel.add(this.radarBt);
            }
         }
         this.setRadarTimer(param1 != null);
      }
      
      public function useEnergyPlay(param1:Boolean) : void
      {
         if(!this.energySkin.isContent || param1 != this.energySkin.content is MovieClip)
         {
            this.energySkin.resetContent();
            this.energySkin.resetLayout();
            this.energySkin.cacheAsBitmap = !param1;
            if(param1)
            {
               this.energySkin.setMode(VSkin.PLAY_MOVIE_CLIP | VSkin.RANDOM_FRAME | VSkin.NO_STRETCH,false);
               SkinManager.applyEmbed(this.energySkin,"EnergyRecoveryClip");
               this.energySkin.assignLayout({
                  "left":4,
                  "top":-2
               });
            }
            else
            {
               this.energySkin.setMode(0,false);
               SkinManager.applyEmbed(this.energySkin,"Energy");
               this.energySkin.assignLayout({
                  "bottom":1,
                  "w":42,
                  "h":40,
                  "left":-1
               });
            }
            this.energySkin.syncLayout();
         }
         else if(param1 && !(this.energySkin.content as MovieClip).isPlaying)
         {
            (this.energySkin.content as MovieClip).play();
         }
      }
      
      public function clear() : void
      {
         this.resetOffer();
         this.setRadarTimer(false);
         this.useEditButton(null);
         if(this.energySkin.content is MovieClip)
         {
            (this.energySkin.content as MovieClip).stop();
         }
      }
      
      public function useAdventureButton(param1:uint, param2:Function, param3:PCurrentAdventure = null) : void
      {
         if(param1 > 0 != Boolean(this.adventureBt))
         {
            if(this.adventureBt)
            {
               this.gearPanel.remove(this.adventureBt);
               this.adventureBt = null;
            }
            else
            {
               if(Boolean(param3) && param3.event_id == param1)
               {
                  this.adventureBt = new CircleButton(SkinManager.getPack("Adventure","Ticket" + param1,VSkin.NO_STRETCH),CircleButton.TEAL);
               }
               else
               {
                  this.adventureBt = VButton.create(SkinManager.getExternal("JEvent" + param1,0,VSkin.NO_STRETCH));
               }
               this.adventureBt.hint = Lang.getString("adventure");
               this.adventureBt.addClickListener(param2);
               this.gearPanel.add(this.adventureBt,{
                  "top":78,
                  "w":45,
                  "h":45
               });
            }
         }
      }
   }
}

