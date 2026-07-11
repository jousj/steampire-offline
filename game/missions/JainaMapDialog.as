package game.missions
{
   import engine.signal.Signal;
   import engine.signal.Tween;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.filters.GradientGlowFilter;
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
   
   public class JainaMapDialog extends BaseDialog
   {
      
      private const panel:VComponent = new VComponent();
      
      private const fgSkin:VSkin = new VSkin(VSkin.STRETCH_BG | VSkin.CACHE_AS_BITMAP);
      
      private var scrollKind:String;
      
      private var foodPathList:Vector.<String>;
      
      private var dict:Object;
      
      private var tweenDict:Object;
      
      private var greyMapSkin:VSkin;
      
      private var greyMapMask:VComponent;
      
      private var greyPathMask:VComponent;
      
      private var btLayer:VComponent;
      
      private var packName:String;
      
      private var messagePanel:VComponent;
      
      private var isCompact:Boolean;
      
      private var isMoveListener:Boolean;
      
      private var lastPoint:Point;
      
      private var timeText:VText;
      
      private var titleComponent:VComponent;
      
      private var title:String;
      
      public var offset:uint = 0;
      
      public var cellarPanel:JainaCellarPanel;
      
      public const missionList:Array = [];
      
      public const winList:Array = [];
      
      public function JainaMapDialog(param1:String)
      {
         super();
         addChild(this.panel);
         var _loc2_:VFill = new VFill(0);
         this.panel.bottom = _loc2_.bottom = 4;
         addChild(_loc2_);
         this.panel.mask = _loc2_;
         this.fgSkin.top = -9;
         this.fgSkin.bottom = -7;
         addChild(this.fgSkin);
         this.title = param1;
         addCloseButton();
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
            if(this.greyMapSkin)
            {
               _loc7_ = this.greyMapSkin.measuredWidth;
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
            if(this.greyMapSkin)
            {
               _loc7_ = this.greyMapSkin.measuredHeight;
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
      
      public function loadMap(param1:Array, param2:Vector.<String>) : void
      {
         this.tweenClear();
         this.onStopDrag();
         this.panel.removeAllChildren();
         this.foodPathList = param2;
         this.dict = {};
         this.packName = "MMapJaina";
         this.greyPathMask = this.greyMapMask = null;
         this.btLayer = new VComponent();
         this.btLayer.setSize(200,200);
         var _loc3_:uint = param1.length;
         var _loc4_:int = 1;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            this.createButton(_loc4_,param1[_loc5_],param1[_loc5_ + 1]);
            _loc4_++;
            _loc5_ += 2;
         }
         this.greyMapSkin = SkinManager.getPack(this.packName,"mapBg",0,0,this.onMapLoad);
         if(this.greyMapSkin.isContent)
         {
            this.onMapLoad(null);
         }
         else if(!this.messagePanel)
         {
            this.showMessage();
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
         if(!(this.greyMapSkin.content is Bitmap))
         {
            this.showMessage("Error loading: " + this.packName);
            return;
         }
         if(this.messagePanel)
         {
            this.messagePanel.removeFromParent();
            this.messagePanel = null;
         }
         this.greyMapMask = new VComponent();
         this.greyMapMask.setSize(200,200);
         var _loc2_:VSkin = SkinManager.getPack(this.packName,"mapBg");
         this.panel.addChild(_loc2_);
         this.panel.add(SkinManager.getEmbed("DialogBottomBg"),{
            "left":_loc2_.left,
            "top":_loc2_.measuredHeight + _loc2_.top
         });
         this.panel.addChild(this.greyMapSkin);
         this.panel.addChild(this.greyMapMask);
         this.greyMapSkin.mask = this.greyMapMask;
         this.greyMapSkin.filters = VSkin.GREY_FILTER;
         this.greyMapMask.filters = [new GradientGlowFilter(0,0,[0,0],[0,1],[0,255],64,64,2,1,"outer")];
         var _loc3_:VSkin = SkinManager.getPack(this.packName,"footPath");
         _loc3_.alpha = 0.8;
         _loc3_.left = 237;
         _loc3_.top = 109;
         _loc3_.mask = this.greyPathMask = new VComponent();
         this.greyPathMask.left = 213;
         this.greyPathMask.top = 93;
         this.panel.addChild(_loc3_);
         this.panel.addChild(this.greyPathMask);
         this.panel.addChild(this.btLayer);
         if(isGeometryPhase)
         {
            this.syncPanelChildLayout();
         }
         this.panel.updatePhase(true);
         if(isGeometryPhase && (w > this.greyMapSkin.measuredWidth + this.panel.hPadding || h > this.greyMapSkin.measuredHeight + this.panel.vPadding))
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
         if(!this.greyMapSkin)
         {
            return;
         }
         var _loc1_:int = -13;
         var _loc2_:int = -12;
         if(this.isCompact)
         {
            if(this.greyMapSkin.left == 0)
            {
               _loc3_ = _loc1_;
               _loc4_ = _loc2_;
            }
         }
         else if(this.greyMapSkin.left == _loc1_)
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
      
      private function tweenClear() : void
      {
         var _loc1_:Tween = null;
         for each(_loc1_ in this.tweenDict)
         {
            _loc1_.stop();
         }
         this.tweenDict = null;
      }
      
      override public function dispose() : void
      {
         this.tweenClear();
         this.onStopDrag();
         if(Boolean(this.greyMapSkin) && !this.greyMapSkin.parent)
         {
            this.greyMapSkin.dispose();
         }
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
            _loc5_ = this.greyMapSkin ? int(this.greyMapSkin.measuredWidth + 2 * this.greyMapSkin.leftOrZero) : 0;
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
            _loc5_ = this.greyMapMask ? int(this.greyMapSkin.measuredHeight + 2 * this.greyMapSkin.topOrZero) : 0;
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
         if(this.scrollKind)
         {
            this.scroll(this.scrollKind);
            this.scrollKind = null;
         }
         else
         {
            this.move(_loc1_,_loc2_,false);
         }
      }
      
      private function getButtonState(param1:String) : uint
      {
         var _loc2_:int = 0;
         if(this.winList.indexOf(param1) >= 0)
         {
            return MissionButton.M_COMPLETE;
         }
         _loc2_ = this.foodPathList.length - 1;
         while(_loc2_ >= 0)
         {
            if(this.foodPathList[_loc2_] == param1)
            {
               if(this.winList.indexOf(this.foodPathList[_loc2_ - 1]) < 0)
               {
                  return MissionButton.M_DISABLED;
               }
            }
            _loc2_ -= 2;
         }
         return MissionButton.M_ACTIVE;
      }
      
      public function sync(param1:Boolean, param2:int) : void
      {
         var _loc4_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:MissionButton = null;
         var _loc9_:String = null;
         var _loc10_:VSkin = null;
         var _loc3_:uint = this.foodPathList.length;
         var _loc5_:uint = 0;
         while(_loc5_ <= _loc3_)
         {
            _loc6_ = this.foodPathList[_loc5_ < _loc3_ ? _loc5_ : _loc3_ - 1];
            _loc7_ = int(this.getButtonState(_loc6_));
            _loc8_ = this.getButton(_loc6_);
            _loc8_.applyState(_loc7_,param2 > 0 && _loc7_ == MissionButton.M_DISABLED ? SkinManager.getPack("Adventure","Mission" + param2) : null);
            if(_loc5_ < _loc3_)
            {
               _loc9_ = "bl" + _loc6_;
               _loc10_ = this.dict[_loc9_] as VSkin;
               if(_loc8_.mouseEnabled == Boolean(_loc10_))
               {
                  if(_loc10_)
                  {
                     _loc10_.removeFromParent();
                     delete this.dict[_loc9_];
                  }
                  else
                  {
                     _loc10_ = SkinManager.getPack(this.packName,_loc9_);
                     this.dict[_loc9_] = _loc10_;
                     this.greyMapMask.add(_loc10_);
                  }
               }
               _loc9_ = "fp" + _loc6_ + "_" + this.foodPathList[_loc5_ + 1];
               _loc10_ = this.dict[_loc9_] as VSkin;
               if(_loc7_ != MissionButton.M_COMPLETE == Boolean(_loc10_))
               {
                  if(_loc10_)
                  {
                     _loc10_.removeFromParent();
                     delete this.dict[_loc9_];
                  }
                  else
                  {
                     _loc10_ = SkinManager.getPack(this.packName,_loc9_);
                     this.dict[_loc9_] = _loc10_;
                     this.greyPathMask.add(_loc10_);
                  }
               }
            }
            if(param1 && !_loc4_ && _loc7_ != MissionButton.M_COMPLETE)
            {
               _loc4_ = _loc6_;
            }
            if(_loc7_ == MissionButton.M_COMPLETE)
            {
               _loc8_.disabled = true;
            }
            _loc5_ += 2;
         }
         if(_loc4_)
         {
            if(isGeometryPhase)
            {
               this.scroll(_loc4_);
            }
            else
            {
               this.scrollKind = _loc4_;
            }
         }
      }
      
      private function getButtonKind(param1:String) : String
      {
         return "bt" + param1;
      }
      
      private function createButton(param1:uint, param2:int, param3:int) : MissionButton
      {
         var _loc6_:PJainaMissionInfo = null;
         var _loc4_:MissionButton = new MissionButton(param1);
         var _loc5_:String = param1.toString();
         _loc4_.addVarianceListener(this,param1);
         this.dict[this.getButtonKind(_loc5_)] = _loc4_;
         if(param2 >= 0)
         {
            _loc4_.left = param2;
            _loc4_.top = param3;
         }
         this.btLayer.add(_loc4_);
         for each(_loc6_ in this.missionList)
         {
            if(_loc6_.jmi_number == param1)
            {
               _loc4_.data = _loc6_;
               _loc4_.hint = Lang.getString(_loc6_.jmi_mission);
               break;
            }
         }
         return _loc4_;
      }
      
      public function getButton(param1:String) : MissionButton
      {
         return this.dict[this.getButtonKind(param1)] as MissionButton;
      }
      
      public function scroll(param1:String) : void
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
      
      public function addCellar(param1:Function, param2:PCost) : void
      {
         this.cellarPanel = new JainaCellarPanel(param2,PCost.J_GLORY);
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
      
      public function checkOverlapCellar(param1:String) : void
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
      
      public function showTime(param1:Number, param2:Boolean) : void
      {
         var _loc3_:VComponent = new VComponent();
         _loc3_.mouseChildren = false;
         _loc3_.addStretch(SkinManager.getEmbed("ResBg",VSkin.STRETCH_BG));
         if(param2)
         {
            _loc3_.add(SkinManager.getEmbed("BtTeal"),{
               "left":6,
               "vCenter":1,
               "w":45,
               "h":45
            });
            _loc3_.add(SkinManager.getPack("Adventure","Ticket1",VSkin.NO_STRETCH),{
               "left":10,
               "vCenter":0
            });
         }
         else
         {
            _loc3_.add(SkinManager.getExternal("JEvent1"),{
               "left":6,
               "vCenter":1
            });
         }
         _loc3_.add(UIFactory.createYellowText(Lang.getString("adventure_time"),VText.CONTAIN_CENTER,16,true),{
            "left":56,
            "right":36,
            "top":7
         });
         _loc3_.add(SkinManager.getEmbed("InfoIcon"),{
            "right":12,
            "vCenter":0,
            "h":30
         });
         this.timeText = new VText(null,VText.CONTAIN_CENTER);
         Style.applyGlowFormat(this.timeText,18,16777215,3212033);
         _loc3_.add(this.timeText,{
            "left":56,
            "right":36,
            "bottom":6
         });
         add(_loc3_,{
            "w":300,
            "h":50,
            "hCenter":0,
            "top":62
         });
         _loc3_.hint = Lang.getString("adventure_about");
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
      
      public function showNewBuild(param1:String) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:UnitClipPanel = new UnitClipPanel();
         _loc2_.show(param1,1);
         _loc2_.hint = "<p" + Style.metalColor + ">" + Lang.getString(param1) + "</p>" + Lang.getString("shop_mission_lock");
         var _loc3_:VComponent = new VComponent();
         _loc3_.addStretch(_loc2_);
         Style.applyGlowFilter(_loc3_,16777215,16);
         _loc3_.add(new ShopNewIcon(0).launch(),{
            "bottom":0,
            "left":60
         });
         add(_loc3_,{
            "left":24,
            "bottom":153,
            "w":78,
            "h":76
         });
      }
   }
}

