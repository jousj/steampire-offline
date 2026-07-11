package game.political
{
   import engine.signal.Signal;
   import game.feature.FeatureRenderer;
   import model.ui.VOFeatureItem;
   import proto.model.PCost;
   import proto.model.PShopMine;
   import proto.model.PShopTerritory;
   import proto.model.clan.PRegent;
   import proto.model.clan.PTerritory;
   import proto.model.clan.PTerritoryAttacker;
   import proto.model.clan.PTerritoryState;
   import proto.tuples.time_a_str_a;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.CircleButton;
   import ui.common.DurationPanel;
   import ui.common.LevelPanel;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   import ui.vbase.VProgressBar;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   
   public class TerritoryDialog extends BaseDialog
   {
      
      public var env:PTerritory;
      
      public var shop:PShopTerritory;
      
      public var mineShop:PShopMine;
      
      public var price:Array;
      
      public var leagueNum:uint;
      
      public var kind:String;
      
      private var grid:VGrid;
      
      private const actionPanel:VComponent = new VComponent();
      
      public const CHANGE_REGENT:uint = 0;
      
      public const TO_REGENT:uint = 1;
      
      public const INIT_ATTACK:uint = 2;
      
      public const UPDATE:uint = 3;
      
      public const STORM:uint = 4;
      
      public const TO_OWNER:uint = 5;
      
      public const LEAVE:uint = 6;
      
      public function TerritoryDialog(param1:String, param2:uint)
      {
         super();
         this.kind = param1;
         layoutW = 600;
         add(this.actionPanel,{
            "wP":100,
            "bottom":0
         });
         addHeader();
         addUnitDialogTitle(param1,param2);
         this.actionPanel.layoutH = 300;
         this.actionPanel.add(SkinManager.getEmbed("FeatureSectionBg",VSkin.STRETCH_BG),{
            "wP":100,
            "bottom":0,
            "top":-20
         });
         this.actionPanel.add(new VText(Lang.getString("load_title"),VText.CONTAIN_CENTER,Style.metalRGB),{
            "left":20,
            "right":20,
            "vCenter":-8
         });
      }
      
      public function assign(param1:PTerritory, param2:PShopTerritory, param3:PShopMine, param4:uint, param5:Boolean, param6:uint, param7:Array, param8:String, param9:uint, param10:Boolean) : void
      {
         var _loc13_:PCost = null;
         var _loc14_:VButton = null;
         var _loc15_:VText = null;
         var _loc16_:VSkin = null;
         var _loc17_:VComponent = null;
         var _loc21_:Boolean = false;
         var _loc22_:int = 0;
         var _loc23_:PCost = null;
         var _loc24_:VProgressBar = null;
         var _loc25_:int = 0;
         var _loc26_:DurationPanel = null;
         var _loc27_:PTerritoryAttacker = null;
         var _loc28_:DurationPanel = null;
         this.env = param1;
         this.shop = param2;
         this.mineShop = param3;
         this.price = param7;
         this.leagueNum = param4;
         this.actionPanel.isGeometryPhase = isGeometryPhase = false;
         var _loc11_:uint = param1.state.variance;
         this.actionPanel.layoutH = 0;
         (this.actionPanel.removeChildAt(this.actionPanel.numChildren - 1) as VComponent).dispose();
         var _loc12_:Array = [VOFeatureItem.create("TerritoryIconFlag","clan",0,0,param1.clan_owner ? param1.clan_owner.to_clan_name : Lang.getString("noBt"),true),VOFeatureItem.create("EliteIcon","regent_multiplier",0,0,"x" + param3.mine_stamina_koef,true),VOFeatureItem.create("ClanEmblemIcon","clan_points_text",0,0,param5 ? Facade.references.terra_def.toString() : Facade.references.terra_def.toString(),true)];
         for each(_loc13_ in param2.ter_resource_cost)
         {
            _loc22_ = 0;
            for each(_loc23_ in param3.mine_resource_addition)
            {
               if(_loc23_.variance == _loc13_.variance)
               {
                  _loc22_ = _loc23_.value;
                  break;
               }
            }
            _loc12_.push(VOFeatureItem.create(CostHelper.getKind(_loc13_.variance),CostHelper.getKind(_loc13_.variance).toLowerCase() + "_production",0,0,Lang.getPatternString("mithril_per_day","__VALUE__",int(60 * 60 * 24 / param2.ter_resource_time / param3.mine_time_k * (_loc13_.value + _loc22_)).toString()),true));
         }
         this.grid = new VGrid(1,_loc12_.length,FeatureRenderer,_loc12_,0,10,VGrid.H_STRETCH | VGrid.USE_TOP_LEFT);
         this.grid.add(SkinManager.getEmbed("FrLine",VSkin.ROTATE_270 | VSkin.STRETCH),{
            "left":8,
            "top":24,
            "bottom":24,
            "w":17
         },0);
         this.grid.add(SkinManager.getEmbed("FeatureDialogBg",VSkin.STRETCH),{
            "left":-110,
            "right":-36,
            "top":-40,
            "bottom":-28
         },0);
         add(this.grid,{
            "left":110,
            "right":36,
            "top":86
         },1);
         add(SkinManager.getEmbed("FeatureGear"),{
            "left":-50,
            "top":155
         },0);
         add(SkinManager.getEmbed("TrainCircleBg"),{
            "left":-74,
            "top":44,
            "w":156,
            "h":157
         });
         add(SkinManager.getPack(UIFactory.POLITICAL_PACK,"TerritoryBg" + param4),{
            "left":-60,
            "top":48
         });
         if(param1.clan_owner)
         {
            add(SkinManager.getPack(UIFactory.EMBLEM_PACK,param1.clan_owner.to_clan_icon),{
               "left":17,
               "top":118,
               "w":84,
               "h":90
            });
            _loc17_ = (this.grid.renderList[0] as FeatureRenderer).box;
            _loc17_.right = 32;
            _loc17_.syncLayout();
            _loc14_ = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.TEAL,CircleButton.size30);
            _loc14_.addVarianceListener(this,this.TO_OWNER,param1.clan_owner);
            _loc14_.right = -2;
            this.grid.renderList[0].add(_loc14_);
         }
         var _loc18_:int = 3;
         if(param5 && _loc11_ != PTerritoryState.ATTACK && param3.mine_level < param6)
         {
            _loc24_ = UIFactory.createProgressBar(UIFactory.INDICATOR_YELLOW);
            _loc24_.layoutW = 320;
            _loc25_ = 1;
            while(_loc25_ < param6)
            {
               _loc24_.add(SkinManager.getEmbed("SeparatorPb",VSkin.STRETCH),{
                  "top":4,
                  "bottom":6,
                  "left":(_loc24_.layoutW / param6 - 1) * _loc25_
               });
               _loc25_++;
            }
            _loc24_.value = param3.mine_level / param6;
            _loc17_ = new VComponent();
            _loc17_.setSize(_loc24_.layoutW + 27,58);
            _loc17_.add(_loc24_,{
               "right":0,
               "h":38,
               "bottom":1
            });
            _loc15_ = new VText(Lang.getString("territory_level"),0,Style.metalRGB,14);
            _loc15_.maxW = 224;
            _loc17_.add(new VBox(new <VComponent>[_loc15_,UIFactory.createYellowText(param3.mine_level + "/" + param6,0,16)]),{"hCenter":0});
            _loc17_.add(SkinManager.getEmbed("FeatureIconBg",VSkin.STRETCH),{
               "bottom":0,
               "w":44,
               "h":42
            });
            _loc17_.add(SkinManager.getEmbed("TerritoryIcon"),{
               "left":3,
               "bottom":9,
               "w":41,
               "h":39
            });
            _loc17_.add(SkinManager.getEmbed("Exp"),{
               "left":12,
               "bottom":4,
               "w":28,
               "h":27
            });
            this.actionPanel.add(_loc17_,{
               "top":_loc18_ - 3,
               "left":28
            });
            _loc15_ = UIFactory.createYellowText(Lang.getString("updateBt"),VText.CONTAIN_CENTER,16);
            _loc15_.maxW = 160;
            _loc14_ = new RectButton(new VBox(new <VComponent>[_loc15_,this.getPriceList(param7,18,14)],0,VBox.VERTICAL),RectButton.h56);
            _loc14_.addVarianceListener(this,this.UPDATE);
            this.actionPanel.add(_loc14_,{
               "top":_loc18_,
               "right":22,
               "w":188
            });
            _loc18_ += 63;
         }
         this.actionPanel.add(SkinManager.getEmbed("SectionBg",VSkin.STRETCH),{
            "left":26,
            "w":353,
            "top":_loc18_,
            "h":68
         });
         var _loc19_:VBox = new VBox(null,8,VBox.CENTER);
         var _loc20_:Boolean = Boolean(param1.clan_owner) && Boolean(param1.clan_owner.regent);
         _loc21_ = param5 && _loc11_ != PTerritoryState.ATTACK;
         _loc25_ = _loc21_ ? 200 : 336;
         if(_loc20_)
         {
            _loc19_.add(this.createRegentPanel(param1.clan_owner.regent,_loc25_));
         }
         else
         {
            if(param1.clan_owner)
            {
               _loc16_ = SkinManager.getEmbed("RWait");
               _loc16_.setSize(62,66);
               _loc19_.add(_loc16_);
            }
            else
            {
               _loc17_ = new VComponent();
               _loc17_.layoutH = 66;
               _loc17_.add(SkinManager.getPack(UIFactory.POLITICAL_PACK,"StatusBg1"),{
                  "h":60,
                  "vCenter":0
               });
               _loc17_.add(SkinManager.getEmbed("MapIcon"),{
                  "hCenter":0,
                  "vCenter":-5,
                  "h":32
               });
               _loc19_.add(_loc17_);
            }
            _loc15_ = new VText(Lang.getString(param1.clan_owner ? "empty_regent" : "start_regent"),VText.CENTER | VText.MIDDLE,Style.metalRGB,_loc21_ ? 16 : 18);
            _loc15_.maxW = _loc25_ - 70;
            _loc15_.layoutH = 60;
            _loc19_.add(_loc15_);
         }
         if(_loc21_)
         {
            _loc14_ = RectButton.createIconAndTitle42(SkinManager.getEmbed("GuardIcon"),Lang.getString(_loc20_ ? "changeBt" : "assignBt"),130,RectButton.ORANGE);
            _loc14_.addVarianceListener(this,this.CHANGE_REGENT);
            _loc19_.add(_loc14_);
         }
         this.actionPanel.add(_loc19_,{
            "left":34,
            "top":_loc18_ + 2,
            "w":336
         });
         _loc21_ = _loc11_ == PTerritoryState.ATTACK;
         _loc16_ = SkinManager.getEmbed(_loc21_ ? (param5 ? "ShieldIcon" : "BarrackIcon") : "SearchIcon");
         _loc16_.layoutH = 34;
         _loc15_ = UIFactory.createYellowText(Lang.getString(_loc21_ ? (param5 ? "war_defence_go" : "war_attack_go") : "go_territory"),VText.CENTER,16);
         _loc15_.maxW = 134;
         _loc14_ = new RectButton(new VBox(new <VComponent>[_loc16_,_loc15_],8,VBox.CENTER),RectButton.h56,_loc21_ ? RectButton.ORANGE : RectButton.GREEN);
         _loc14_.addVarianceListener(this,_loc21_ ? this.STORM : this.TO_REGENT);
         this.actionPanel.add(_loc14_,{
            "top":_loc18_ + 7,
            "right":22,
            "w":188
         });
         _loc18_ += 75;
         if(_loc21_ || _loc11_ == PTerritoryState.COOLDOWN)
         {
            this.actionPanel.add(SkinManager.getEmbed("SectionBg",VSkin.STRETCH),{
               "left":26,
               "right":26,
               "top":_loc18_,
               "h":68
            });
            if(_loc21_)
            {
               _loc27_ = param1.state.value;
               this.actionPanel.add(SkinManager.getPack(UIFactory.POLITICAL_PACK,"StatusBg3"),{
                  "left":38,
                  "top":_loc18_ + 6,
                  "w":103,
                  "h":59
               });
               _loc19_ = new VBox(null,2);
               _loc16_ = SkinManager.getPack(UIFactory.EMBLEM_PACK,_loc27_.ta_clan_icon);
               _loc16_.setSize(25,25);
               _loc19_.add(_loc16_);
               _loc19_.add(UIFactory.createDecorText("VS",true,16,0,false));
               _loc16_ = param1.clan_owner ? SkinManager.getPack(UIFactory.EMBLEM_PACK,param1.clan_owner.to_clan_icon) : SkinManager.getEmbed("MapIcon");
               _loc16_.setSize(25,25);
               _loc19_.add(_loc16_);
               this.actionPanel.add(_loc19_,{
                  "left":51,
                  "top":_loc18_ + 18
               });
            }
            else
            {
               this.actionPanel.add(SkinManager.getPack(UIFactory.POLITICAL_PACK,"Shield"),{
                  "left":38,
                  "top":_loc18_ + 8,
                  "w":51,
                  "h":54
               });
               this.actionPanel.add(SkinManager.getEmbed("TerritoryIcon"),{
                  "left":49,
                  "top":_loc18_ + 19,
                  "w":33,
                  "h":31
               });
            }
            _loc15_ = new VText(_loc21_ ? Lang.getPatternString("territory_attack","__CLAN__",_loc27_.ta_clan_name) : Lang.getString("territory_shield"),VText.CENTER | VText.MIDDLE,Style.metalRGB,16);
            this.actionPanel.add(_loc15_,{
               "left":(_loc21_ ? 144 : 96),
               "right":200,
               "h":60,
               "top":_loc18_ + 4
            });
            _loc26_ = new DurationPanel(34);
            _loc26_.useBg(90);
            _loc26_.setTrackTime(_loc21_ ? _loc27_.ta_end_time : Number(param1.state.value),true);
            this.actionPanel.add(_loc26_,{
               "right":63,
               "top":_loc18_ + 15
            });
            if(_loc21_ && param5)
            {
               _loc14_ = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.TEAL,CircleButton.size42);
               _loc14_.addVarianceListener(this,this.TO_OWNER,_loc27_);
               this.actionPanel.add(_loc14_,{
                  "right":37,
                  "top":_loc18_ + 14
               });
               _loc15_.right += 42;
               _loc26_.right += 42;
            }
            _loc18_ += 75;
         }
         else if(Boolean(!param5) && Boolean(param8) && (_loc11_ == PTerritoryState.FREE || _loc11_ == PTerritoryState.REG_ATTACK && param1.state.value.field_1.indexOf(param8) == -1))
         {
            if(param9 > 0)
            {
               this.actionPanel.add(SkinManager.getEmbed("SectionBg",VSkin.STRETCH),{
                  "left":26,
                  "right":26,
                  "top":_loc18_,
                  "h":68
               });
               this.actionPanel.add(new VText(Lang.getString(param9 == 1 ? "territory_league_lock" : "territory_storm_lock"),VText.CENTER | VText.MIDDLE,Style.darkKhakiRGB),{
                  "left":44,
                  "right":44,
                  "top":_loc18_ + 4,
                  "h":61
               });
            }
            else
            {
               this.actionPanel.add(SkinManager.getEmbed("SectionBg",VSkin.STRETCH),{
                  "left":26,
                  "w":353,
                  "top":_loc18_,
                  "h":68
               });
               this.actionPanel.add(UIFactory.createYellowText(Lang.getString("territory_start_attack"),VText.CENTER | VText.MIDDLE),{
                  "left":44,
                  "top":_loc18_ + 4,
                  "h":60,
                  "w":318
               });
               _loc14_ = new RectButton(this.getPriceList(param7,22,18),RectButton.h56);
               _loc14_.addVarianceListener(this,this.INIT_ATTACK);
               this.actionPanel.add(_loc14_,{
                  "right":22,
                  "top":_loc18_ + 7,
                  "w":188
               });
            }
            _loc18_ += 75;
         }
         if(_loc11_ == PTerritoryState.REG_ATTACK)
         {
            _loc28_ = new DurationPanel(34);
            _loc28_.useBg(90);
            _loc28_.setTrackTime((param1.state.value as time_a_str_a).field_0,true);
            this.actionPanel.add(_loc28_,{
               "top":_loc18_ + 20,
               "right":60
            });
            this.actionPanel.add(SkinManager.getEmbed("SectionBg",VSkin.STRETCH),{
               "left":26,
               "w":353,
               "top":_loc18_,
               "h":68
            });
            this.actionPanel.add(UIFactory.createYellowText(Lang.getString("territory_attack_reg"),VText.CENTER | VText.MIDDLE),{
               "left":44,
               "top":_loc18_ + 4,
               "h":60,
               "w":318
            });
            _loc18_ += 75;
         }
         if(param5 && param10 && _loc11_ != PTerritoryState.ATTACK)
         {
            this.actionPanel.add(SkinManager.getEmbed("SectionBg",VSkin.STRETCH),{
               "left":26,
               "w":353,
               "top":_loc18_,
               "h":68
            });
            this.actionPanel.add(UIFactory.createYellowText(Lang.getString("leave_territory_info"),VText.CENTER | VText.MIDDLE,16),{
               "left":20,
               "top":_loc18_ + 4,
               "h":60,
               "w":360
            });
            _loc14_ = new RectButton(Lang.getString("clan_leave"),RectButton.h56,RectButton.RED);
            _loc14_.addVarianceListener(this,this.LEAVE);
            this.actionPanel.add(_loc14_,{
               "right":22,
               "top":_loc18_ + 7,
               "w":188
            });
            _loc18_ += 75;
         }
         this.actionPanel.layoutH = _loc18_ + 12;
         geometryPhase();
         param5 = _loc11_ == PTerritoryState.ATTACK;
         if((param5) || _loc11_ == PTerritoryState.COOLDOWN)
         {
            Signal.createRef(this,this.opReopen,0,0,false).delayEnd(param5 ? _loc27_.ta_end_time : Number(param1.state.value));
         }
         if(_loc11_ == PTerritoryState.REG_ATTACK)
         {
            Signal.createRef(this,this.opReopen,0,0,false).delayEnd((param1.state.value as time_a_str_a).field_0);
         }
      }
      
      private function opReopen() : void
      {
         dispatcher.dispatchEvent(new VEvent(VEvent.CHANGE));
      }
      
      private function getPriceList(param1:Array, param2:uint, param3:uint) : PriceListPanel
      {
         var _loc4_:PriceListPanel = new PriceListPanel();
         _loc4_.maxW = 160;
         _loc4_.priceMode = PricePanel.GLOW_FILTER | PricePanel.CLAN;
         _loc4_.setStyle(param2,param3);
         _loc4_.assignList(param1);
         return _loc4_;
      }
      
      private function createRegentPanel(param1:PRegent, param2:uint) : VComponent
      {
         var _loc3_:VComponent = new VComponent();
         _loc3_.layoutH = 66;
         _loc3_.maxW = param2;
         var _loc4_:LevelPanel = new LevelPanel(LevelPanel.size34);
         _loc4_.changeSNetwork(param1.regent_snetwork);
         _loc4_.value = param1.regent_level;
         _loc3_.add(_loc4_,{"vCenter":0});
         _loc3_.add(new VText(Lang.getString("regent"),VText.CONTAIN,Style.darkKhakiRGB,14),{
            "left":40,
            "right":0,
            "top":6
         });
         _loc3_.add(UIFactory.createYellowText(param1.regent_name,VText.CONTAIN),{
            "left":40,
            "right":0,
            "vCenter":0
         });
         _loc3_.add(new VText(Lang.getString("clan_role" + param1.regent_role.variance),VText.CONTAIN,Style.metalRGB,14),{
            "left":40,
            "right":0,
            "bottom":6
         });
         return _loc3_;
      }
      
      override protected function calcContentSize() : void
      {
         if(this.grid)
         {
            contentH = this.grid.measuredHeight + this.grid.vPadding + this.actionPanel.measuredHeight + 36;
         }
         else
         {
            contentH = this.actionPanel.measuredHeight + 60;
         }
      }
      
      override public function dispose() : void
      {
         Signal.stopRef(this);
         super.dispose();
      }
   }
}

