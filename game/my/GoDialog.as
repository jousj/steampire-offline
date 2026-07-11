package game.my
{
   import engine.signal.Signal;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.feature.CampRenderer;
   import logic.CoreLogic;
   import proto.model.PCost;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.CircleButton;
   import ui.common.DurationPanel;
   import ui.common.RectButton;
   import ui.game.PricePanel;
   import ui.game.ShopNewIcon;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class GoDialog extends BaseDialog
   {
      
      public const missionBt:VButton = new VButton();
      
      public const raidBt:VButton = new VButton();
      
      public const pvpBt:VButton = new VButton();
      
      public const barrackBt:CircleButton = new CircleButton(SkinManager.getEmbed("BarrackIcon"),CircleButton.GOLD,CircleButton.size70);
      
      private const descList:Vector.<VComponent> = new Vector.<VComponent>();
      
      private const descPoint:Point = new Point();
      
      private var addIndex:int;
      
      private var descIndex:int;
      
      private var missionBox:VBox;
      
      private var raidBox:VBox;
      
      private var libraryBt:CircleButton;
      
      private var armyPanel:VComponent;
      
      private var adventureBlock:VComponent;
      
      private var adventureSignal:Signal;
      
      public var visibleCallback:Function;
      
      public function GoDialog(param1:PCost, param2:String)
      {
         super();
         setSize(795,465);
         addStretch(SkinManager.getEmbed("FeatureDialogBg",VSkin.STRETCH));
         add(SkinManager.getEmbed("goBattleBg"),{
            "hCenter":0,
            "vCenter":0
         });
         addCloseButton({
            "top":-13,
            "right":-16
         });
         add(UIFactory.createYellowText(Lang.getString("pve_title"),VText.CENTER | VText.MIDDLE,24,true),{
            "w":225,
            "h":60,
            "top":30,
            "left":26
         });
         add(UIFactory.createYellowText(Lang.getString("raid_title"),VText.CENTER | VText.MIDDLE,24,true),{
            "w":225,
            "h":60,
            "top":30,
            "hCenter":0
         });
         add(UIFactory.createYellowText(Lang.getString("pvp_title"),VText.CENTER | VText.MIDDLE,24,true),{
            "w":225,
            "h":60,
            "top":30,
            "right":26
         });
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "w":225,
            "h":50,
            "bottom":112,
            "hCenter":0
         });
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "w":225,
            "h":50,
            "bottom":112,
            "right":26
         });
         this.addIndex = numChildren;
         this.descList.push(null);
         var _loc3_:VSkin = SkinManager.getEmbed("HGlory");
         _loc3_.setSize(40,40);
         var _loc4_:VBox = new VBox(new <VComponent>[_loc3_,UIFactory.createYellowText(Lang.getString("raid_desc"),VText.CENTER,16).assignW(180)]);
         this.descList.push(_loc4_);
         add(_loc4_,{
            "hCenter":0,
            "bottom":170
         });
         var _loc5_:VText = UIFactory.createYellowText(Lang.getString("pvp_desc"),VText.CENTER,16);
         this.descList.push(_loc5_);
         add(_loc5_,{
            "right":20,
            "bottom":170,
            "w":240
         });
         this.setDescVisible(-1);
         var _loc6_:PricePanel = new PricePanel(20,18,PricePanel.GLOW_B_FILTER);
         _loc6_.useCheck = true;
         _loc6_.assignCost(param1);
         this.addCountBox(_loc6_,551,Lang.getString("pvp_search_price"));
         this.addButton(this.missionBt,"BtRectGreen75","PvEIcon",Lang.getString("to_pve")).left = 43;
         this.addButton(this.raidBt,param2 ? "BtRectGreen75" : "BtRectOrange75","PortalIcon",Lang.getString("to_portal")).hCenter = 0;
         if(!param2)
         {
            this.raidBt.add(new ShopNewIcon(30).launch(),{
               "left":150,
               "bottom":65
            });
         }
         this.addButton(this.pvpBt,"BtRectOrange75","PvPIcon",Lang.getString("find_enemy")).right = 43;
         addListener(MouseEvent.MOUSE_MOVE,this.onMove);
         addListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.barrackBt.hint = Lang.getString("barrackBt");
      }
      
      public function addLibraryButton(param1:Function) : void
      {
         this.libraryBt = new CircleButton(SkinManager.getEmbed("SpellIcon"),CircleButton.GOLD,CircleButton.size70);
         this.libraryBt.hint = Lang.getString("libraryBt");
         this.libraryBt.addClickListener(param1);
      }
      
      public function setMissionData(param1:Number, param2:Boolean, param3:Number, param4:Boolean, param5:Function, param6:uint, param7:Boolean) : void
      {
         var _loc8_:VText = null;
         var _loc9_:VComponent = null;
         if(this.missionBox)
         {
            remove(this.missionBox);
         }
         this.missionBox = param2 ? this.addTimeBox(param1,33,Lang.getString("ext_mission_wait"),108) : this.addCountBox(param1,33,Lang.getString("ext_mission_count"),102);
         if(this.adventureBlock)
         {
            if(this.adventureSignal)
            {
               this.adventureSignal.stopWithoutHandler();
               this.adventureSignal = null;
            }
            remove(this.adventureBlock);
         }
         if(param3 > 0)
         {
            _loc8_ = new VText(null,VText.CONTAIN_CENTER).assignW(116);
            Style.applyGlowFormat(_loc8_,15,16777215,3212033);
            if(param7)
            {
               _loc9_ = new VComponent();
               _loc9_.addStretch(SkinManager.getEmbed("BtTeal",VSkin.STRETCH));
               _loc9_.add(SkinManager.getPack("Adventure","Ticket" + param6,VSkin.NO_STRETCH),{
                  "hCenter":1,
                  "vCenter":0
               });
            }
            else
            {
               _loc9_ = SkinManager.getExternal("JEvent" + param6,0,VSkin.NO_STRETCH);
            }
            _loc9_.setSize(45,45);
            this.adventureBlock = new RectButton(new VBox(new <VComponent>[_loc9_,new VBox(new <VComponent>[UIFactory.createYellowText(Lang.getString("adventure"),VText.CONTAIN_CENTER,15,true).assignW(_loc8_.layoutW),_loc8_],5,VBox.VERTICAL)]),null,"BtRectOrange75");
            (this.adventureBlock as RectButton).addClickListener(param5);
            if(param4 && !param7)
            {
               this.adventureBlock.add(new ShopNewIcon(30).launch(),{
                  "left":160,
                  "top":-14
               });
            }
            add(this.adventureBlock,{
               "w":190,
               "h":62,
               "left":43,
               "bottom":(param2 ? 160 : 142)
            });
            this.adventureSignal = new Signal(this.onAdventureSignal,Signal.ADD_TIMER);
            this.adventureSignal.data = _loc8_;
            this.adventureSignal.run(param3,0,true);
         }
         else
         {
            this.adventureBlock = new VComponent();
            this.adventureBlock.addStretch(SkinManager.getEmbed("StatBg",VSkin.STRETCH));
            this.adventureBlock.add(SkinManager.getExternal("JEvent" + param6,0,VSkin.NO_STRETCH),{
               "left":10,
               "vCenter":0,
               "w":45,
               "h":45
            });
            this.adventureBlock.add(UIFactory.createYellowText(Lang.getString("adventure_empty"),VText.CENTER,16,true),{
               "left":58,
               "right":8,
               "vCenter":1,
               "maxH":36
            });
            this.adventureBlock.mouseChildren = false;
            this.adventureBlock.hint = Lang.getString("adventure_empty_hint");
            add(this.adventureBlock,{
               "w":225,
               "h":50,
               "bottom":(param2 ? 160 : 143),
               "left":26
            });
         }
      }
      
      private function onAdventureSignal() : void
      {
         var _loc1_:Number = this.adventureSignal.tail;
         if(_loc1_ > 0)
         {
            (this.adventureSignal.data as VText).value = StringHelper.getTimeDesc(_loc1_);
         }
         else
         {
            dispatcher.dispatchEvent(new VEvent(VEvent.CHANGE));
         }
      }
      
      public function setRaidData(param1:Number, param2:uint) : void
      {
         if(this.raidBox)
         {
            remove(this.raidBox);
         }
         this.raidBox = param2 == 0 ? this.addTimeBox(param1,292,Lang.getString("raid_start_in")) : this.addCountBox(param1 + "/" + param2,292,Lang.getString("available_raids"));
      }
      
      public function setRaidHeroData(param1:Number) : void
      {
         if(this.raidBox)
         {
            remove(this.raidBox);
         }
         this.raidBox = param1 == 0 ? this.addHeroRaidBox(292) : this.addTimeBox(param1 - CoreLogic.serverTime,292,Lang.getString("hero_raid_speedup_title"));
      }
      
      private function hideArmy() : void
      {
         if(this.armyPanel)
         {
            this.barrackBt.removeFromParent(false);
            if(this.libraryBt)
            {
               this.libraryBt.removeFromParent(false);
            }
            remove(this.armyPanel);
            this.armyPanel = null;
         }
      }
      
      public function showArmy(param1:Array, param2:String) : void
      {
         this.hideArmy();
         var _loc3_:VGrid = new VGrid(10,1,CampRenderer,param1,4,0,VGrid.USE_VISIBLE_CALC_LAYOUT | VGrid.USE_END_LIMIT);
         _loc3_.renderList[0].setSize(64,64);
         UIFactory.useGridControlNav(_loc3_,UIFactory.addNavBt30);
         _loc3_.add(UIFactory.createYellowText(param2),{
            "left":3,
            "top":-30
         });
         var _loc4_:int = -90;
         if(param1.length > _loc3_.maxRenderer)
         {
            _loc4_ -= 26;
         }
         _loc3_.add(this.barrackBt,{
            "vCenter":0,
            "right":_loc4_
         });
         if(this.libraryBt)
         {
            _loc4_ -= 80;
            _loc3_.add(this.libraryBt,{
               "vCenter":0,
               "right":_loc4_
            });
         }
         _loc3_.add(SkinManager.getEmbed("BoardMoveBg",VSkin.STRETCH),{
            "left":-12,
            "right":_loc4_ - 12,
            "top":-12,
            "bottom":-10
         },0);
         _loc3_.hCenter = _loc4_ / 2;
         add(this.armyPanel = _loc3_);
         this.syncArmyY();
      }
      
      public function showEmptyArmy() : void
      {
         this.hideArmy();
         var _loc1_:Boolean = Boolean(this.libraryBt);
         this.armyPanel = new VComponent();
         this.armyPanel.setSize(_loc1_ ? 200 : 120,70);
         this.armyPanel.add(SkinManager.getEmbed("BoardMoveBg",VSkin.STRETCH),{
            "wP":100,
            "top":-9,
            "bottom":-7
         });
         this.armyPanel.add(this.barrackBt,{
            "vCenter":0,
            "hCenter":(_loc1_ ? -45 : 0)
         });
         if(_loc1_)
         {
            this.armyPanel.add(this.libraryBt,{
               "vCenter":0,
               "hCenter":45
            });
         }
         this.armyPanel.hCenter = 0;
         add(this.armyPanel);
         this.syncArmyY();
      }
      
      private function addButton(param1:VButton, param2:String, param3:String, param4:String) : VButton
      {
         param1.setSize(190,75);
         param1.bottom = 28;
         param1.addStretch(SkinManager.getEmbed(param2,VSkin.STRETCH));
         param1.add(SkinManager.getEmbed(param3),{
            "left":9,
            "top":11,
            "w":50,
            "h":50
         });
         var _loc5_:VText = UIFactory.createYellowText(param4,VText.CENTER,18,true);
         _loc5_.format.lineHeight = "110%";
         param1.add(_loc5_,{
            "left":62,
            "vCenter":0,
            "w":116,
            "maxH":55
         });
         addChild(param1);
         return param1;
      }
      
      private function addTimeBox(param1:Number, param2:int, param3:String, param4:int = 116) : VBox
      {
         var _loc5_:DurationPanel = new DurationPanel(24,16,5,16777215);
         Style.applyGlowFilter(_loc5_.text,3212033,6);
         _loc5_.dispatcher = this;
         var _loc6_:VBox = new VBox(new <VComponent>[UIFactory.createYellowText(param3,VText.CONTAIN_CENTER,16,true).assignW(210),_loc5_.setTrackTime(param1)],0,VBox.VERTICAL);
         add(_loc6_,{
            "left":param2,
            "bottom":param4
         },this.addIndex);
         return _loc6_;
      }
      
      private function addHeroRaidBox(param1:int) : VBox
      {
         var _loc3_:VText = null;
         var _loc2_:VBox = new VBox(new <VComponent>[SkinManager.getExternal("un_hero")],5,VBox.BOTTOM);
         _loc3_ = new VText(Lang.getString("hero_raid_available"),VText.MIDDLE);
         Style.applyGlowFormat(_loc3_,18,Style.lightGreenRGB,Style.greenRGB);
         _loc3_.maxW = 156;
         _loc3_.layoutH = 42;
         _loc2_.add(_loc3_);
         add(_loc2_,{
            "left":param1,
            "bottom":116
         },this.addIndex);
         return _loc2_;
      }
      
      private function addCountBox(param1:Object, param2:int, param3:String, param4:int = 119) : VBox
      {
         var _loc5_:VText = UIFactory.createYellowText(param3,VText.CENTER,16,true).assignMaxW(170);
         _loc5_.maxH = 36;
         if(!(param1 is VComponent))
         {
            param1 = UIFactory.createYellowText(String(param1),0,18,true);
         }
         var _loc6_:VBox = new VBox(new <VComponent>[_loc5_,param1 as VComponent],6,VBox.CENTER);
         add(_loc6_,{
            "left":param2,
            "bottom":param4,
            "w":210,
            "h":_loc5_.maxH
         },this.addIndex);
         return _loc6_;
      }
      
      private function onMove(param1:MouseEvent) : void
      {
         this.descPoint.x = param1.stageX;
         this.descPoint.y = param1.stageY;
         var _loc2_:Point = globalToLocal(this.descPoint);
         if(_loc2_.y >= 450)
         {
            return;
         }
         this.setDescVisible(_loc2_.x >= 267 ? (_loc2_.x >= 527 ? 2 : 1) : 0);
      }
      
      private function setDescVisible(param1:int) : void
      {
         if(param1 == this.descIndex)
         {
            return;
         }
         this.descIndex = param1;
         var _loc2_:* = int(this.descList.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.descList[_loc2_])
            {
               this.descList[_loc2_].visible = _loc2_ == param1;
            }
            _loc2_--;
         }
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.setDescVisible(-1);
      }
      
      override public function geometryPhase() : void
      {
         super.geometryPhase();
         if(this.armyPanel)
         {
            this.syncArmyY();
         }
      }
      
      private function syncArmyY() : void
      {
         if(parent)
         {
            this.armyPanel.y = (parent as VComponent).h - y - this.armyPanel.measuredHeight + (Facade.fakeResize ? 30 : -20);
         }
      }
      
      override public function dispose() : void
      {
         if(this.adventureSignal)
         {
            this.adventureSignal.stopWithoutHandler();
         }
         super.dispose();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1 && this.visibleCallback != null)
         {
            this.visibleCallback();
         }
      }
   }
}

