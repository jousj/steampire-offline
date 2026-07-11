package game.clan.war
{
   import engine.signal.Signal;
   import proto.model.PCost;
   import proto.model.PReferences;
   import proto.model.clan.PBase;
   import proto.model.clan.PClan;
   import proto.model.clan.PWar;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.common.DurationPanel;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.game.ResourcePanel;
   import ui.game.UnitClipPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class ClanWarPanel extends VComponent
   {
      
      private var war:PWar;
      
      private var thLevel:uint;
      
      private var mySignal:Signal;
      
      private var enemySignal:Signal;
      
      private var box:VBox;
      
      private var myPb:ResourcePanel;
      
      private var enemyPb:ResourcePanel;
      
      private var myPoints:uint;
      
      private var enemyPoints:uint;
      
      public function ClanWarPanel(param1:PClan, param2:uint, param3:uint)
      {
         super();
         setSize(883,502);
         this.war = param1.war;
         var _loc4_:PBase = param1.base;
         this.thLevel = _loc4_.has_capital ? param1.townhall_level : 0;
         this.myPoints = param2;
         this.enemyPoints = param3;
         addVs(this,_loc4_.name,_loc4_.icon,null,this.war.war_enemy_name,this.war.war_enemy_icon,this.war.war_enemy,this.war.war_start_time);
         var _loc5_:RectButton = new RectButton(Lang.getString("war_log"),RectButton.h30);
         _loc5_.addVarianceListener(this,WarVariance.LOG,true);
         add(_loc5_,{
            "left":82,
            "top":81
         });
         _loc5_ = new RectButton(Lang.getString("war_log"),RectButton.h30);
         _loc5_.addVarianceListener(this,WarVariance.LOG,false);
         add(_loc5_,{
            "right":82,
            "top":81
         });
         var _loc6_:Vector.<VComponent> = new Vector.<VComponent>();
         _loc6_.push(this.createStep1());
         _loc6_.push(this.createStep2());
         _loc6_.push(this.createStep3());
         add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH),{
            "wP":100,
            "top":120,
            "bottom":0
         });
         add(new VFill(12367020),{
            "left":12,
            "right":11,
            "top":250,
            "h":124
         });
         add(SkinManager.getEmbed("GridSeparator",VSkin.STRETCH),{
            "left":7,
            "right":6,
            "top":245
         });
         add(SkinManager.getEmbed("GridSeparator",VSkin.STRETCH),{
            "left":7,
            "right":6,
            "top":372
         });
         this.box = new VBox(_loc6_,15,VBox.VERTICAL | VBox.STRETCH);
         add(this.box,{
            "left":20,
            "right":20,
            "top":134
         });
      }
      
      public static function addVs(param1:VComponent, param2:String, param3:String, param4:String, param5:String, param6:String, param7:String, param8:Number) : void
      {
         var _loc11_:VButton = null;
         var _loc12_:DurationPanel = null;
         param1.add(SkinManager.getEmbed("WarFireImg",VComponent.SKIP_CONTENT_SIZE),param8 > 0 ? (param7 ? {"hCenter":-16} : {
            "w":118,
            "hCenter":-7
         }) : {
            "top":-6,
            "hCenter":0,
            "w":100
         });
         var _loc9_:VComponent = new VComponent();
         _loc9_.add(SkinManager.getEmbed("GreenPanelBg",VSkin.STRETCH),{
            "left":32,
            "right":35,
            "h":48,
            "top":14
         });
         var _loc10_:VText = UIFactory.createYellowText(param2,VText.CONTAIN_CENTER,24);
         if(param4)
         {
            _loc11_ = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.GOLD,CircleButton.size30);
            _loc11_.addVarianceListener(param1,WarVariance.INFO,param4);
            _loc9_.add(new VBox(new <VComponent>[_loc11_,_loc10_.assignW(-100)]),{
               "left":78,
               "right":44,
               "top":22
            });
         }
         else
         {
            _loc9_.add(_loc10_,{
               "left":80,
               "top":25,
               "right":43
            });
         }
         _loc9_.add(SkinManager.getPack(UIFactory.EMBLEM_PACK,param3,0,SkinManager.LOAD_CLIP),{
            "left":-4,
            "w":80,
            "h":90
         });
         param1.add(_loc9_,{
            "wP":50,
            "top":8,
            "h":104
         });
         _loc9_ = new VComponent();
         _loc9_.add(SkinManager.getEmbed("RedPanelBg",VSkin.STRETCH),{
            "left":35,
            "right":32,
            "top":14,
            "h":48
         });
         _loc9_.add(SkinManager.getPack(UIFactory.EMBLEM_PACK,param6,0,SkinManager.LOAD_CLIP),{
            "w":80,
            "h":90,
            "right":-4
         });
         _loc10_ = UIFactory.createYellowText(param5,VText.CONTAIN_CENTER,24);
         if(param7)
         {
            _loc11_ = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.GOLD,CircleButton.size30);
            _loc11_.addVarianceListener(param1,WarVariance.INFO,param7);
            _loc9_.add(new VBox(new <VComponent>[_loc10_.assignW(-100),_loc11_]),{
               "left":44,
               "right":78,
               "top":22
            });
         }
         else
         {
            _loc9_.add(_loc10_,{
               "left":43,
               "top":25,
               "right":80
            });
         }
         param1.add(_loc9_,{
            "wP":50,
            "top":8,
            "h":104,
            "right":0
         });
         param1.add(UIFactory.createDecorText("VS",true,40),{
            "hCenter":0,
            "top":26
         });
         if(param8 > 0)
         {
            param1.add(UIFactory.createYellowText(Lang.getString("war_win_title"),VText.CONTAIN_CENTER),{
               "left":100,
               "right":100
            });
            _loc12_ = new DurationPanel(34);
            _loc12_.useBg(80);
            _loc12_.setTrackTime(param8 + Facade.references.wp_war_duration,true);
            param1.add(_loc12_,{
               "hCenter":-18,
               "top":75
            });
         }
      }
      
      public static function createPrizePanel(param1:Array, param2:uint, param3:uint, param4:Boolean = false) : PriceListPanel
      {
         var _loc5_:PriceListPanel = new PriceListPanel(12);
         _loc5_.priceMode |= PricePanel.CLAN;
         if(param4)
         {
            _loc5_.priceMode |= PricePanel.NEGATIVE;
         }
         _loc5_.minW = 60;
         _loc5_.setStyle(param2,param3);
         _loc5_.assignList(param1);
         _loc5_.add(SkinManager.getEmbed("StatBg",VSkin.STRETCH_BG),{
            "left":-14,
            "right":-14,
            "top":-3,
            "bottom":-3
         },0);
         return _loc5_;
      }
      
      public function sync(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = uint(Facade.references.wp_storm_req);
         var _loc4_:Boolean = param1 != this.myPoints && param1 == _loc3_ || param2 != this.enemyPoints && param2 == _loc3_;
         this.myPoints = param1;
         this.enemyPoints = param2;
         remove(this.box,false);
         this.box.removeAt(0);
         this.box.add(this.createStep1(),null,0);
         if(_loc4_)
         {
            this.box.removeAt(1);
            this.box.add(this.createStep2(),null,1);
         }
         add(this.box);
      }
      
      private function get isCapitalStep() : Boolean
      {
         return this.thLevel > 0 || this.war.war_enemy_townhall_level > 0;
      }
      
      private function createStep1() : VComponent
      {
         var _loc2_:VComponent = null;
         var _loc4_:VText = null;
         var _loc5_:RectButton = null;
         this.clearSignal();
         var _loc1_:PReferences = Facade.references;
         _loc2_ = new VComponent();
         _loc2_.layoutH = 110;
         _loc2_.add(UIFactory.createDecorText(Lang.getPatternString("war_step_number","__STEP__","I"),true,20,96,false));
         if(this.myPoints < _loc1_.wp_storm_req)
         {
            _loc2_.add(new VText(Lang.getPatternString(this.isCapitalStep ? "war_point_need" : "war_point_win","__COUNT__",_loc1_.wp_storm_req.toString()),VText.CONTAIN_CENTER,Style.metalRGB,16),{
               "left":100,
               "right":100,
               "top":5
            });
            _loc4_ = UIFactory.createYellowText(Lang.getString("war_point_go"),VText.CENTER);
            _loc4_.format.lineHeight = "100%";
            _loc5_ = new RectButton(_loc4_,RectButton.h56,RectButton.ORANGE);
            _loc5_.addVarianceListener(this,WarVariance.PVP_SEARCH);
            _loc2_.add(_loc5_,{
               "hCenter":0,
               "bottom":11,
               "w":180
            });
         }
         else
         {
            _loc2_.add(new VText(Lang.getString("war_point_ok"),VText.CENTER | VText.MIDDLE,Style.metalRGB,16),{
               "hCenter":0,
               "w":200,
               "hP":100
            });
         }
         var _loc3_:Number = isNaN(this.war.war_storm) ? _loc1_.wp_generation : _loc1_.wp_generation_during_storm;
         this.myPb = this.createProgressPanel(true,this.myPoints,_loc1_.wp_storm_req,60 / _loc3_);
         _loc2_.add(this.myPb);
         if(this.myPoints < _loc1_.wp_storm_req)
         {
            if(!this.mySignal)
            {
               this.mySignal = new Signal(this.onSignal,Signal.ADD_PERIOD,true);
            }
            this.mySignal.delay = _loc3_;
            this.mySignal.run((_loc1_.wp_storm_req - this.myPoints) * this.mySignal.delay);
         }
         _loc3_ = isNaN(this.war.war_my_storm) ? _loc1_.wp_generation : _loc1_.wp_generation_during_storm;
         this.enemyPb = this.createProgressPanel(false,this.enemyPoints,_loc1_.wp_storm_req,60 / _loc3_);
         _loc2_.add(this.enemyPb);
         if(this.enemyPoints < _loc1_.wp_storm_req)
         {
            if(!this.enemySignal)
            {
               this.enemySignal = new Signal(this.onSignal,Signal.ADD_PERIOD,true);
            }
            this.enemySignal.delay = _loc3_;
            this.enemySignal.run((_loc1_.wp_storm_req - this.enemyPoints) * this.enemySignal.delay);
         }
         return _loc2_;
      }
      
      private function createProgressPanel(param1:Boolean, param2:uint, param3:uint, param4:uint) : ResourcePanel
      {
         var _loc7_:VSkin = null;
         var _loc5_:uint = uint(ResourcePanel.BG | ResourcePanel.PROGRESS);
         if(param2 < param3)
         {
            _loc5_ |= ResourcePanel.COMPARE;
         }
         var _loc6_:ResourcePanel = new ResourcePanel(SkinManager.getEmbed("MoralIcon"),_loc5_,param1 ? "LightGreenIndicator" : "LightRedIndicator");
         _loc6_.layoutW = 230;
         if(param4 > 0 && param2 < param3)
         {
            _loc7_ = SkinManager.getEmbed("ResHeaderBg",VSkin.STRETCH);
            _loc7_.alpha = 0.5;
            _loc6_.add(_loc7_,{
               "left":40,
               "right":20,
               "top":-18,
               "h":18
            },0);
            _loc6_.add(new VText(Lang.getPatternString("war_point_gen","__COUNT__",param4.toString()),VText.CONTAIN_CENTER,Style.metalRGB,14),{
               "left":44,
               "right":24,
               "top":-15
            },1);
            _loc6_.vCenter = 19;
         }
         else
         {
            _loc6_.vCenter = 10;
         }
         _loc6_.setDataEx(param2,param3);
         if(param2 >= param3)
         {
            _loc6_.add(SkinManager.getEmbed("ChCheck"),{
               "w":36,
               "vCenter":0,
               "right":-12
            });
         }
         if(param1)
         {
            _loc6_.left = 22;
         }
         else
         {
            _loc6_.right = 22;
         }
         return _loc6_;
      }
      
      private function onSignal(param1:Signal) : void
      {
         if(param1.tail == 0)
         {
            dispatchEvent(new VEvent(VEvent.CHANGE));
         }
         else if(param1 == this.mySignal)
         {
            ++this.myPoints;
            this.myPb.setData(this.myPoints);
         }
         else
         {
            ++this.enemyPoints;
            this.enemyPb.setData(this.enemyPoints);
         }
      }
      
      private function createStep2() : VComponent
      {
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc1_:VComponent = new VComponent();
         _loc1_.layoutH = 113;
         var _loc2_:uint = uint(this.war.war_enemy_townhall_level);
         var _loc3_:uint = uint(Facade.references.wp_storm_req);
         if(!this.isCapitalStep)
         {
            _loc4_ = true;
            _loc1_.add(new VText(Lang.getString("war_capital_no_both"),VText.CENTER | VText.MIDDLE,Style.metalRGB,16),{
               "left":192,
               "right":192,
               "hP":100
            });
         }
         else
         {
            _loc1_.add(UIFactory.createDecorText(Lang.getPatternString("war_step_number","__STEP__","II"),true,20,96,false));
            _loc4_ = this.myPoints < _loc3_ && this.enemyPoints < _loc3_;
            if(this.thLevel > 0 && _loc2_ > 0)
            {
               _loc5_ = "war_capital_both";
            }
            else if(this.thLevel > 0)
            {
               _loc5_ = "war_capital_defence";
            }
            else
            {
               _loc5_ = "war_capital_attack";
            }
            _loc1_.add(new VText(Lang.getString(_loc5_),VText.CENTER | VText.MIDDLE,Style.metalRGB,16),{
               "left":200,
               "right":200,
               "h":35,
               "top":(_loc4_ ? 34 : 4)
            });
         }
         _loc1_.add(this.createCapitalPanel(_loc4_,this.thLevel,this.war.war_enemy_damage,false,this.enemyPoints < _loc3_ || isNaN(this.war.war_storm)),{
            "left":15,
            "bottom":12
         });
         _loc1_.add(this.createCapitalPanel(_loc4_,_loc2_,this.war.war_damage,true,this.myPoints < _loc3_),{
            "right":15,
            "bottom":12
         });
         if(_loc4_)
         {
            _loc1_.add(SkinManager.getEmbed("LockIcon"),{
               "vCenter":8,
               "left":-43,
               "w":44
            });
         }
         return _loc1_;
      }
      
      private function createCapitalPanel(param1:Boolean, param2:uint, param3:int, param4:Boolean, param5:Boolean) : VComponent
      {
         var _loc9_:VText = null;
         var _loc10_:RectButton = null;
         var _loc11_:* = 0;
         var _loc12_:VComponent = null;
         var _loc6_:VComponent = new VComponent();
         _loc6_.setSize(350,79);
         _loc6_.add(SkinManager.getEmbed("CornerBg",param4 ? 0 : VSkin.FLIP_X),{
            "left":0,
            "bottom":0
         });
         _loc6_.add(SkinManager.getEmbed("GreenPanelBg"),{
            "left":85,
            "bottom":0
         });
         var _loc7_:UnitClipPanel = new UnitClipPanel();
         _loc6_.add(_loc7_,{
            "left":88,
            "bottom":5,
            "w":74,
            "h":72
         });
         _loc7_.show("bl_town_hall",param2 == 0 ? 1 : param2);
         var _loc8_:VSkin = SkinManager.getEmbed("DamageIcon");
         _loc8_.layoutH = 42;
         _loc6_.add(new VBox(new <VComponent>[_loc8_,UIFactory.createYellowText(param3 + "%")],2),{
            "hCenter":(param4 ? 132 : -132),
            "bottom":-3
         });
         if(param2 == 0)
         {
            if(!param1)
            {
               _loc9_ = UIFactory.createYellowText(Lang.getString(param4 ? "war_capital_no_a" : "war_capital_no_d"),VText.CENTER,16);
               _loc9_.format.lineHeight = "100%";
               _loc9_.assignLayout({
                  "left":171,
                  "bottom":2,
                  "maxW":140
               });
               _loc9_.geometryPhase();
               _loc6_.add(SkinManager.getEmbed("CornerBg",VSkin.STRETCH | (param4 ? VSkin.FLIP_X | VSkin.SPLIT_SCALE : 0)),{
                  "left":159,
                  "w":_loc9_.w + 22,
                  "bottom":0
               });
               _loc6_.addChild(_loc9_);
            }
            _loc6_.filters = VSkin.GREY_FILTER;
         }
         else if(!param1)
         {
            if(param4)
            {
               _loc10_ = new RectButton(Lang.getString("war_attack_go"),RectButton.h42,RectButton.ORANGE);
            }
            else
            {
               _loc10_ = new RectButton(Lang.getString("war_defence_go"),RectButton.h42);
            }
            if(param5)
            {
               _loc10_.disabled = true;
            }
            else
            {
               _loc10_.addVarianceListener(this,WarVariance.TO_STORM,param4);
            }
            _loc6_.add(_loc10_,{
               "bottom":-2,
               "left":178
            });
         }
         if(param4)
         {
            _loc11_ = int(_loc6_.numChildren - 1);
            while(_loc11_ >= 0)
            {
               _loc12_ = _loc6_.getChildAt(_loc11_) as VComponent;
               if(_loc12_.left != VComponent.EMPTY)
               {
                  _loc12_.right = _loc12_.left;
                  _loc12_.left = VComponent.EMPTY;
               }
               _loc11_--;
            }
         }
         return _loc6_;
      }
      
      private function createStep3() : VComponent
      {
         var _loc3_:PCost = null;
         var _loc1_:VComponent = new VComponent();
         _loc1_.layoutH = 102;
         _loc1_.add(UIFactory.createDecorText(Lang.getPatternString("war_step_number","__STEP__",this.isCapitalStep ? "III" : "II"),true,20,96,false));
         _loc1_.add(new VText(Lang.getString("war_step3"),VText.CONTAIN_CENTER,Style.metalRGB,16),{
            "left":100,
            "right":100,
            "top":10
         });
         var _loc2_:Array = [PCost.create(PCost.CLAN_POINTS,Facade.references.clan_war_win)];
         for each(_loc3_ in this.war.war_prize)
         {
            _loc2_.push(_loc3_);
         }
         _loc1_.add(createPrizePanel(_loc2_,30,20),{
            "hCenter":0,
            "bottom":18
         });
         _loc1_.add(SkinManager.getEmbed("LockIcon"),{
            "vCenter":8,
            "left":-43,
            "w":44
         });
         return _loc1_;
      }
      
      private function clearSignal() : void
      {
         if(this.mySignal)
         {
            this.mySignal.stop();
         }
         if(this.enemySignal)
         {
            this.enemySignal.stop();
         }
      }
      
      override public function dispose() : void
      {
         this.clearSignal();
         super.dispose();
      }
   }
}

