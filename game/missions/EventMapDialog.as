package game.missions
{
   import engine.signal.Signal;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import proto.model.PCost;
   import proto.model.PJainaMissionInfo;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.game.ShopNewIcon;
   import ui.game.UnitClipPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class EventMapDialog extends BaseDialog
   {
      
      private const panel:VComponent = new VComponent();
      
      private const fgSkin:VSkin = new VSkin(VSkin.STRETCH_BG | VSkin.CACHE_AS_BITMAP);
      
      private const bgSkin:VSkin = new VSkin(VSkin.EXTERNAL_EVENT);
      
      private const btLayer:VComponent = new VComponent();
      
      private var titleComponent:VComponent;
      
      private var scrollIndex:uint = 4294967295;
      
      private var messagePanel:VComponent;
      
      private var isCompact:Boolean;
      
      private var isMoveListener:Boolean;
      
      private var lastPoint:Point;
      
      private var timeText:VText;
      
      private var title:String;
      
      public var activeIndex:uint;
      
      public var offset:uint = 0;
      
      public var cellarPanel:JainaCellarPanel;
      
      public const missionList:Array = [];
      
      public function EventMapDialog(param1:String)
      {
         super();
         addChild(this.panel);
         var _loc2_:VFill = new VFill(0);
         this.panel.bottom = _loc2_.bottom = 4;
         addChild(_loc2_);
         this.panel.mask = _loc2_;
         this.panel.addChild(this.bgSkin);
         this.fgSkin.top = -9;
         this.fgSkin.bottom = -7;
         addChild(this.fgSkin);
         this.title = param1;
         addCloseButton();
         this.btLayer.setSize(200,200);
         this.panel.addListener(MouseEvent.MOUSE_DOWN,this.onStartDrag);
         this.panel.addListener(MouseEvent.ROLL_OVER,this.onRollOver);
      }
      
      override public function geometryPhase() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc6_:VComponent = null;
         var _loc7_:uint = 0;
         this.onStopDrag();
         if(parent is VComponent)
         {
            _loc6_ = parent as VComponent;
            _loc1_ = _loc6_.w - 120;
            _loc2_ = _loc6_.h - 120;
         }
         if(_loc1_ < 814)
         {
            _loc1_ = 814;
         }
         else
         {
            if(this.bgSkin)
            {
               _loc7_ = this.bgSkin.measuredWidth;
               if(_loc7_ > 0 && _loc1_ > (_loc7_ = _loc7_ + this.panel.hPadding))
               {
                  _loc1_ = int(_loc7_);
               }
            }
            _loc7_ = 1357 + this.panel.hPadding;
            if(_loc1_ > _loc7_)
            {
               _loc1_ = int(_loc7_);
            }
         }
         if(_loc2_ < 638)
         {
            _loc2_ = 638;
         }
         else
         {
            if(this.bgSkin)
            {
               _loc7_ = this.bgSkin.measuredHeight;
               if(_loc7_ > 0 && _loc2_ > (_loc7_ = _loc7_ + this.panel.vPadding))
               {
                  _loc2_ = int(_loc7_);
               }
            }
            _loc7_ = 1387 + this.panel.vPadding;
            if(_loc2_ > _loc7_)
            {
               _loc2_ = int(_loc7_);
            }
         }
         var _loc3_:Boolean = _loc1_ < 1100 || _loc2_ < 850;
         var _loc4_:Boolean = this.fgSkin.left == VComponent.EMPTY;
         var _loc5_:VFill = this.panel.mask as VFill;
         if(_loc3_)
         {
            if(this.fgSkin.left != -13)
            {
               setSize(814,638);
               this.fgSkin.left = -13;
               this.fgSkin.right = -12;
               this.panel.left = this.panel.right = _loc5_.right = _loc5_.left = 6;
               this.panel.top = _loc5_.top = 29;
               closeBt.right = 0;
               closeBt.top = 2;
            }
         }
         else
         {
            setSize(_loc1_,_loc2_);
            if(this.fgSkin.left != -18)
            {
               this.fgSkin.left = -18;
               this.fgSkin.right = -19;
               this.panel.left = this.panel.right = _loc5_.right = _loc5_.left = 12;
               this.panel.top = _loc5_.top = 42;
               closeBt.top = closeBt.right = 20;
            }
         }
         if(this.isCompact != _loc3_ || _loc4_)
         {
            this.isCompact = _loc3_;
            SkinManager.applyExternal(this.fgSkin,this.isCompact ? "MMapBg1" : "MMapBg2");
            this.syncPanelChildLayout();
            if(this.titleComponent)
            {
               remove(this.titleComponent);
            }
            add(this.titleComponent = UIFactory.createDecorText(this.title,true,36,_loc3_ ? 330 : 578),_loc3_ ? {
               "hCenter":-14,
               "top":2
            } : {
               "hCenter":6,
               "top":12
            });
         }
         super.geometryPhase();
      }
      
      public function init(param1:String, param2:Array) : void
      {
         var _loc3_:uint = param2.length;
         var _loc4_:int = 1;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            this.createButton(_loc4_,param2[_loc5_],param2[_loc5_ + 1]);
            _loc4_++;
            _loc5_ += 2;
         }
         SkinManager.applyExternal(this.bgSkin,param1,null,SkinManager.JPG);
         if(this.bgSkin.isContent)
         {
            this.onMapLoad(null);
         }
         else
         {
            this.bgSkin.addListener(VEvent.EXTERNAL_COMPLETE,this.onMapLoad);
            if(!this.messagePanel)
            {
               this.showMessage();
            }
         }
      }
      
      public function showMessage(param1:String = null) : void
      {
         if(!this.messagePanel)
         {
            this.messagePanel = new VComponent();
            this.messagePanel.addStretch(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH));
            this.messagePanel.add(new VText(null,VText.CENTER,Style.metalRGB),{
               "vCenter":0,
               "left":50,
               "right":50
            });
            add(this.messagePanel,{
               "left":-5,
               "right":-5,
               "top":22,
               "bottom":-6
            },0);
         }
         (this.messagePanel.getChildAt(1) as VText).value = param1 ? param1 : Lang.getString("load_title");
      }
      
      private function onMapLoad(param1:VEvent) : void
      {
         if(this.messagePanel)
         {
            this.messagePanel.removeFromParent();
            this.messagePanel = null;
         }
         this.panel.add(SkinManager.getEmbed("DialogBottomBg"),{"top":this.bgSkin.measuredHeight});
         this.panel.addChild(this.btLayer);
         if(isGeometryPhase)
         {
            this.syncPanelChildLayout();
         }
         this.panel.updatePhase(true);
         if(isGeometryPhase && (w > this.bgSkin.measuredWidth + this.panel.hPadding || h > this.bgSkin.measuredHeight + this.panel.vPadding))
         {
            this.geometryPhase();
         }
         dispatchEvent(new VEvent(VEvent.EXTERNAL_COMPLETE,this));
      }
      
      private function syncPanelChildLayout() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = 0;
         var _loc6_:VComponent = null;
         var _loc1_:int = -13;
         var _loc2_:int = -12;
         if(this.isCompact)
         {
            if(this.bgSkin.left == 0)
            {
               _loc3_ = _loc1_;
               _loc4_ = _loc2_;
            }
         }
         else if(this.bgSkin.left == _loc1_)
         {
            _loc3_ = -_loc1_;
            _loc4_ = -_loc2_;
         }
         if(_loc3_ != 0)
         {
            _loc5_ = int(this.panel.numChildren - 1);
            while(_loc5_ >= 0)
            {
               _loc6_ = this.panel.getChildAt(_loc5_) as VComponent;
               if(_loc6_)
               {
                  _loc6_.left += _loc3_;
                  _loc6_.top += _loc4_;
               }
               _loc5_--;
            }
         }
      }
      
      override public function dispose() : void
      {
         this.onStopDrag();
         Signal.stopRef(this);
         super.dispose();
      }
      
      private function onStartDrag(param1:MouseEvent, param2:Boolean = false) : void
      {
         if(!param2 && param1.target is MissionButton)
         {
            return;
         }
         if(!this.lastPoint)
         {
            this.lastPoint = new Point();
         }
         this.lastPoint.x = param1.stageX;
         this.lastPoint.y = param1.stageY;
         if(!this.isMoveListener)
         {
            this.setMoveListener(true);
         }
      }
      
      private function onStopDrag(param1:MouseEvent = null) : void
      {
         if(this.isMoveListener)
         {
            this.setMoveListener(false);
         }
      }
      
      private function setMoveListener(param1:Boolean) : void
      {
         var _loc3_:MissionButton = null;
         this.isMoveListener = param1;
         if(param1)
         {
            this.panel.addListener(MouseEvent.MOUSE_UP,this.onStopDrag);
            this.panel.addListener(MouseEvent.ROLL_OUT,this.onStopDrag);
            this.panel.addListener(MouseEvent.MOUSE_MOVE,this.onMove);
         }
         else
         {
            this.panel.removeListener(MouseEvent.MOUSE_UP,this.onStopDrag);
            this.panel.removeListener(MouseEvent.ROLL_OUT,this.onStopDrag);
            this.panel.removeListener(MouseEvent.MOUSE_MOVE,this.onMove);
         }
         var _loc2_:* = int(this.btLayer.numChildren - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this.btLayer.getChildAt(_loc2_) as MissionButton;
            if(_loc3_.shineClip)
            {
               _loc3_.shineClip.contentPlay(!param1,true);
            }
            _loc2_--;
         }
         this.btLayer.cacheAsBitmap = param1;
         this.panel.mouseChildren = !param1;
      }
      
      private function onMove(param1:MouseEvent) : void
      {
         var _loc2_:Number = param1.stageX;
         var _loc3_:Number = param1.stageY;
         if(this.lastPoint.x != _loc2_ || this.lastPoint.y != _loc3_)
         {
            this.move((_loc2_ - this.lastPoint.x) * 2,(_loc3_ - this.lastPoint.y) * 2,true);
            this.lastPoint.x = _loc2_;
            this.lastPoint.y = _loc3_;
         }
      }
      
      public function move(param1:Number, param2:Number, param3:Boolean) : void
      {
         var _loc5_:int = 0;
         if(param3)
         {
            param1 += this.panel.x;
            param2 += this.panel.y;
         }
         var _loc4_:int = this.panel.leftOrZero;
         if(param1 > _loc4_)
         {
            param1 = _loc4_;
         }
         else
         {
            _loc5_ = this.bgSkin.measuredWidth + 2 * this.bgSkin.leftOrZero;
            _loc4_ += _loc5_ > this.panel.w ? this.panel.w - _loc5_ : 0;
            if(param1 < _loc4_)
            {
               param1 = _loc4_;
            }
         }
         _loc4_ = this.panel.topOrZero;
         if(param2 > _loc4_)
         {
            param2 = _loc4_;
         }
         else
         {
            _loc5_ = this.bgSkin.measuredHeight + 2 * this.bgSkin.topOrZero;
            _loc4_ += _loc5_ > this.panel.h ? this.panel.h - _loc5_ : 0;
            if(param2 < _loc4_ - this.offset)
            {
               param2 = _loc4_ - this.offset;
            }
         }
         this.panel.x = param1;
         this.panel.y = param2;
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         if(param1.buttonDown)
         {
            this.onStartDrag(param1);
         }
      }
      
      override protected function customUpdate() : void
      {
         var _loc1_:Number = this.panel.x;
         var _loc2_:Number = this.panel.y;
         super.customUpdate();
         if(this.scrollIndex != uint.MAX_VALUE)
         {
            this.scroll(this.scrollIndex);
            this.scrollIndex = uint.MAX_VALUE;
         }
         else
         {
            this.move(_loc1_,_loc2_,false);
         }
      }
      
      public function sync(param1:int) : void
      {
         var _loc3_:MissionButton = null;
         var _loc2_:* = int(this.btLayer.numChildren - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = this.btLayer.getChildAt(_loc2_) as MissionButton;
            if(_loc2_ == this.activeIndex)
            {
               _loc3_.skin.layoutH = 0;
               _loc3_.applyState(MissionButton.M_ACTIVE);
            }
            else
            {
               _loc3_.skin.layoutH = -100;
               if(_loc2_ > this.activeIndex)
               {
                  _loc3_.applyState(MissionButton.M_EX,param1 > 0 ? SkinManager.getPack("Adventure","Mission" + param1) : null);
               }
               else
               {
                  _loc3_.applyState(MissionButton.M_COMPLETE);
               }
               _loc3_.mouseEnabled = false;
            }
            _loc2_--;
         }
         if(isGeometryPhase)
         {
            this.scroll(this.activeIndex);
         }
         else
         {
            this.scrollIndex = this.activeIndex;
         }
      }
      
      private function createButton(param1:uint, param2:int, param3:int) : MissionButton
      {
         var _loc5_:PJainaMissionInfo = null;
         var _loc4_:MissionButton = new MissionButton(param1);
         _loc4_.setSize(76,76);
         _loc4_.addVarianceListener(this,param1);
         if(param2 >= 0)
         {
            _loc4_.left = param2;
            _loc4_.top = param3;
         }
         this.btLayer.addChild(_loc4_);
         for each(_loc5_ in this.missionList)
         {
            if(_loc5_.jmi_number == param1)
            {
               _loc4_.data = _loc5_;
               _loc4_.hint = Lang.getString(_loc5_.jmi_mission);
               break;
            }
         }
         return _loc4_;
      }
      
      private function getButton(param1:uint) : MissionButton
      {
         return param1 < this.btLayer.numChildren ? this.btLayer.getChildAt(param1) as MissionButton : null;
      }
      
      public function scroll(param1:uint) : void
      {
         var _loc2_:MissionButton = null;
         if(isGeometryPhase)
         {
            _loc2_ = this.getButton(param1);
            if(_loc2_)
            {
               this.move(-_loc2_.leftOrZero + (this.panel.w >> 1),-_loc2_.topOrZero + (this.panel.h >> 1) + 70,false);
            }
         }
      }
      
      public function addCellar(param1:Function, param2:PCost, param3:uint) : void
      {
         this.cellarPanel = new JainaCellarPanel(param2,param3);
         add(new VFill(14402207),{
            "w":-100,
            "h":134,
            "bottom":0
         },0);
         add(this.cellarPanel,{
            "bottom":-6,
            "hCenter":0
         });
         this.cellarPanel.battleBt.addClickListener(param1);
         this.offset = 130;
         this.panel.y -= this.offset;
      }
      
      public function checkOverlapCellar(param1:uint) : void
      {
         if(!this.cellarPanel)
         {
            return;
         }
         var _loc2_:MissionButton = this.getButton(param1);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Point = new Point();
         var _loc4_:Number = this.cellarPanel.localToGlobal(_loc3_).y - (_loc2_.localToGlobal(_loc3_).y + 100);
         if(_loc4_ < 0)
         {
            this.move(0,_loc4_,true);
         }
      }
      
      public function showTime(param1:Number, param2:uint, param3:Boolean) : void
      {
         var _loc4_:VComponent = new VComponent();
         _loc4_.mouseChildren = false;
         _loc4_.addStretch(SkinManager.getEmbed("ResBg",VSkin.STRETCH_BG));
         _loc4_.add(param3 ? SkinManager.getEmbed("BtTeal") : SkinManager.getExternal("JEvent" + param2,0,VSkin.NO_STRETCH),{
            "left":6,
            "vCenter":1,
            "w":45,
            "h":45
         });
         if(param3)
         {
            _loc4_.add(SkinManager.getPack("Adventure","Ticket" + param2,VSkin.NO_STRETCH),{
               "left":10,
               "vCenter":0
            });
         }
         _loc4_.add(UIFactory.createYellowText(Lang.getString("adventure_time"),VText.CONTAIN_CENTER,16,true),{
            "left":56,
            "right":36,
            "top":7
         });
         _loc4_.add(SkinManager.getEmbed("InfoIcon"),{
            "right":12,
            "vCenter":0,
            "h":30
         });
         this.timeText = new VText(null,VText.CONTAIN_CENTER);
         Style.applyGlowFormat(this.timeText,18,16777215,3212033);
         _loc4_.add(this.timeText,{
            "left":56,
            "right":36,
            "bottom":6
         });
         add(_loc4_,{
            "w":300,
            "h":50,
            "hCenter":0,
            "top":62
         });
         _loc4_.hint = Lang.getString("adventure_about");
         Signal.createRef(this,this.onSignal,Signal.ADD_TIMER).run(param1,0,true);
      }
      
      private function onSignal(param1:Signal) : void
      {
         if(param1.tail > 0)
         {
            this.timeText.value = StringHelper.getTimeDesc(param1.tail);
         }
         else
         {
            close();
         }
      }
      
      public function showNew(param1:String, param2:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:UnitClipPanel = null;
         var _loc7_:VComponent = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         while(_loc4_ < 2)
         {
            _loc5_ = _loc4_ == 0 ? param1 : param2;
            if(_loc5_)
            {
               _loc6_ = new UnitClipPanel();
               _loc6_.show(_loc5_,1);
               _loc6_.hint = "<p" + Style.metalColor + ">" + Lang.getString(_loc5_) + "</p>" + Lang.getString(_loc4_ == 0 ? "shop_mission_lock" : "unit_mission_lock");
               _loc7_ = new VComponent();
               _loc7_.addStretch(_loc6_);
               Style.applyGlowFilter(_loc7_,16777215,16);
               _loc7_.add(new ShopNewIcon(0).launch(),{
                  "bottom":-24,
                  "left":4
               });
               add(_loc7_,{
                  "left":24,
                  "bottom":182 + _loc3_ * 106,
                  "w":78,
                  "h":76
               });
               _loc3_++;
            }
            _loc4_++;
         }
      }
   }
}

