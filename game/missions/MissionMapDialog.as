package game.missions
{
   import engine.signal.Signal;
   import engine.signal.Tween;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.filters.GradientGlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import logic.CoreLogic;
   import logic.ErrorLogic;
   import model.ManualProxy;
   import model.UserProxy;
   import proto.model.PMissionInfo;
   import proto.model.PMissionPercentage;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class MissionMapDialog extends BaseDialog
   {
      
      public static const MISSION_PREFIX:String = "ms_mission";
      
      private const panel:VComponent = new VComponent();
      
      private const fgSkin:VSkin = new VSkin(VSkin.STRETCH_BG | VSkin.CACHE_AS_BITMAP);
      
      private const titleComponent:VComponent = UIFactory.createDecorText(Lang.getString("missionsTitle"),true,36);
      
      private var useBlackView:Boolean;
      
      private var scrollKind:String;
      
      private var foodPathList:Array;
      
      private var exBtLayoutList:Array;
      
      private var dict:Object;
      
      private var tweenDict:Object;
      
      private var mapSkin:VSkin;
      
      private var greyMapMask:VComponent;
      
      private var greyPathMask:VComponent;
      
      private var btLayer:VComponent;
      
      private var packName:String;
      
      private var messagePanel:VComponent;
      
      private var isCompact:Boolean;
      
      private var isMoveListener:Boolean;
      
      private var lastPoint:Point;
      
      public var exMissionStatus:Object;
      
      public var offset:uint = 0;
      
      public var winList:Array;
      
      public var exMissionList:Array;
      
      public var missionList:Array;
      
      public var cellarPanel:CellarPanel;
      
      public function MissionMapDialog()
      {
         super();
         addChild(this.panel);
         var _loc1_:VFill = new VFill(0);
         this.panel.bottom = _loc1_.bottom = 4;
         addChild(_loc1_);
         this.panel.mask = _loc1_;
         this.fgSkin.top = -9;
         this.fgSkin.bottom = -7;
         addChild(this.fgSkin);
         this.titleComponent.hCenter = 0;
         addChild(this.titleComponent);
         addCloseButton();
         this.panel.addListener(MouseEvent.MOUSE_DOWN,this.onStartDrag);
         this.panel.addListener(MouseEvent.ROLL_OVER,this.onRollOver);
      }
      
      override public function geometryPhase() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc6_:VComponent = null;
         this.onStopDrag();
         if(parent is VComponent)
         {
            _loc6_ = parent as VComponent;
            _loc1_ = _loc6_.w - 120;
            _loc2_ = _loc6_.h - 120;
         }
         if(_loc1_ < 885)
         {
            _loc1_ = 885;
         }
         else
         {
            if(Boolean(this.mapSkin) && _loc1_ > this.mapSkin.measuredWidth + this.panel.hPadding)
            {
               _loc1_ = this.mapSkin.measuredWidth + this.panel.hPadding;
            }
            if(_loc1_ > 1357 + this.panel.hPadding)
            {
               _loc1_ = 1357 + this.panel.hPadding;
            }
         }
         if(_loc2_ < 708)
         {
            _loc2_ = 708;
         }
         else
         {
            if(Boolean(this.mapSkin) && _loc2_ > this.mapSkin.measuredHeight + this.panel.vPadding)
            {
               _loc2_ = this.mapSkin.measuredHeight + this.panel.vPadding;
            }
            if(_loc2_ > 1387 + this.panel.vPadding)
            {
               _loc2_ = 1387 + this.panel.vPadding;
            }
         }
         var _loc3_:Boolean = _loc1_ < 1100 || _loc2_ < 850;
         var _loc4_:Boolean = this.fgSkin.left == VComponent.EMPTY;
         var _loc5_:VFill = this.panel.mask as VFill;
         if(_loc3_)
         {
            if(this.fgSkin.left != -13)
            {
               setSize(885,638);
               this.fgSkin.left = -13;
               this.fgSkin.right = -12;
               this.panel.left = this.panel.right = _loc5_.right = _loc5_.left = 6;
               this.panel.top = _loc5_.top = 29;
               closeBt.right = 0;
               closeBt.top = 2;
               this.titleComponent.top = 2;
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
               this.titleComponent.top = 18;
            }
         }
         if(this.isCompact != _loc3_ || _loc4_)
         {
            this.isCompact = _loc3_;
            SkinManager.applyExternal(this.fgSkin,this.isCompact ? "MMapBg1" : "MMapBg2");
            this.syncPanelChildLayout();
         }
         super.geometryPhase();
      }
      
      public function loadMap(param1:uint, param2:Array, param3:Array, param4:Array) : void
      {
         this.tweenClear();
         this.onStopDrag();
         this.panel.removeAllChildren();
         this.foodPathList = param3;
         this.exBtLayoutList = param4;
         this.dict = {};
         this.packName = "MMap" + param1;
         this.greyPathMask = this.greyMapMask = null;
         this.btLayer = new VComponent();
         this.btLayer.setSize(200,200);
         var _loc5_:uint = param2.length;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            this.createButton(param2[_loc6_],param2[_loc6_ + 1],param2[_loc6_ + 2],param2[_loc6_ + 3]);
            _loc6_ += 4;
         }
         this.mapSkin = SkinManager.getPack(this.packName,"mapBg",0,0,this.onMapLoad);
         if(this.mapSkin.isContent)
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
         if(!(this.mapSkin.content is Bitmap))
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
         var _loc2_:VFill = new VFill(0,0.5);
         _loc2_.setSize(1500,1500);
         _loc2_.left = this.mapSkin.left = this.greyMapMask.left = -13;
         _loc2_.top = this.mapSkin.top = this.greyMapMask.top = -12;
         this.panel.addChild(this.mapSkin);
         this.panel.add(SkinManager.getEmbed("DialogBottomBg"),{
            "left":_loc2_.left,
            "top":_loc2_.measuredHeight + _loc2_.top
         });
         this.panel.addChild(_loc2_);
         this.panel.addChild(this.greyMapMask);
         _loc2_.mask = this.greyMapMask;
         _loc2_.cacheAsBitmap = true;
         this.greyMapMask.filters = [new GradientGlowFilter(0,0,[0,0],[0,1],[0,255],64,64,8,1,"outer")];
         var _loc3_:VSkin = SkinManager.getPack(this.packName,"footPath");
         this.addPathFilters(_loc3_);
         this.greyPathMask = new VComponent();
         _loc3_.mask = this.greyPathMask;
         this.btLayer.top = 2 + _loc2_.left;
         this.btLayer.left = 2 + _loc2_.top;
         _loc3_.left = this.greyPathMask.left = 12 + _loc2_.left;
         _loc3_.top = this.greyPathMask.top = 14 + _loc2_.top;
         this.panel.addChild(_loc3_);
         this.panel.addChild(this.greyPathMask);
         this.panel.addChild(this.btLayer);
         if(isGeometryPhase)
         {
            this.syncPanelChildLayout();
         }
         this.panel.updatePhase(true);
         if(isGeometryPhase && (w > this.mapSkin.measuredWidth + this.panel.hPadding || h > this.mapSkin.measuredHeight + this.panel.vPadding))
         {
            this.geometryPhase();
         }
         dispatchEvent(new VEvent(VEvent.EXTERNAL_COMPLETE,this));
      }
      
      private function addPathFilters(param1:VSkin) : void
      {
         param1.alpha = 0.8;
      }
      
      private function syncPanelChildLayout() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = 0;
         var _loc6_:VComponent = null;
         if(!this.mapSkin)
         {
            return;
         }
         var _loc1_:int = -13;
         var _loc2_:int = -12;
         if(this.isCompact)
         {
            if(this.mapSkin.left == 0)
            {
               _loc3_ = _loc1_;
               _loc4_ = _loc2_;
            }
         }
         else if(this.mapSkin.left == _loc1_)
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
         if(Boolean(this.mapSkin) && !this.mapSkin.parent)
         {
            this.mapSkin.dispose();
         }
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
            _loc5_ = this.mapSkin ? int(this.mapSkin.measuredWidth + 2 * this.mapSkin.leftOrZero) : 0;
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
            _loc5_ = this.greyMapMask ? int(this.mapSkin.measuredHeight + 2 * this.mapSkin.topOrZero) : 0;
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
      
      private function checkLock(param1:String) : Boolean
      {
         var _loc2_:PMissionInfo = null;
         for each(_loc2_ in this.missionList)
         {
            if(_loc2_.mi_is_lock && _loc2_.mi_kind == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function getButtonState(param1:String) : uint
      {
         var _loc2_:int = 0;
         if(this.useBlackView)
         {
            return MissionButton.M_DISABLED;
         }
         if(this.checkLock(MISSION_PREFIX + param1))
         {
            return MissionButton.M_DISABLED;
         }
         if(this.winList.indexOf(MISSION_PREFIX + param1) >= 0)
         {
            return MissionButton.M_COMPLETE;
         }
         _loc2_ = this.foodPathList.length - 3;
         while(_loc2_ >= 0)
         {
            if(this.foodPathList[_loc2_] == param1)
            {
               if(this.winList.indexOf(MISSION_PREFIX + this.foodPathList[_loc2_ - 1]) < 0)
               {
                  return MissionButton.M_DISABLED;
               }
            }
            _loc2_ -= 4;
         }
         return MissionButton.M_ACTIVE;
      }
      
      public function set blackView(param1:Boolean) : void
      {
         this.useBlackView = param1;
      }
      
      public function openSingleZone(param1:String) : void
      {
         this.useBlackView = false;
         this.onStopDrag();
         var _loc2_:uint = this.getButtonState(param1);
         var _loc3_:MissionButton = this.getButton(param1);
         var _loc4_:String = "bl" + param1;
         var _loc5_:VSkin = this.dict[_loc4_];
         if(!_loc5_)
         {
            _loc5_ = SkinManager.getPack(this.packName,_loc4_);
            this.greyMapMask.add(_loc5_);
         }
         delete this.dict[_loc4_];
         _loc4_ = "tw" + param1;
         this.createTween(_loc5_,_loc4_,[_loc3_,_loc2_,_loc4_],_loc3_);
      }
      
      public function sync(param1:Boolean = true) : void
      {
         var _loc3_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:MissionButton = null;
         var _loc8_:String = null;
         var _loc9_:VSkin = null;
         var _loc10_:ExtMissionStatus = null;
         var _loc11_:Number = NaN;
         var _loc12_:ExMissionButton = null;
         var _loc2_:uint = this.foodPathList.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this.foodPathList[_loc4_];
            _loc6_ = int(this.getButtonState(_loc5_));
            _loc7_ = this.getButton(_loc5_);
            _loc7_.applyState(_loc6_);
            _loc8_ = "bl" + _loc5_;
            _loc9_ = this.dict[_loc8_] as VSkin;
            if(_loc7_.visible == Boolean(_loc9_))
            {
               if(_loc9_)
               {
                  _loc9_.removeFromParent();
                  delete this.dict[_loc8_];
               }
               else
               {
                  _loc9_ = SkinManager.getPack(this.packName,_loc8_);
                  this.dict[_loc8_] = _loc9_;
                  this.greyMapMask.add(_loc9_);
               }
            }
            _loc8_ = "fp" + _loc5_ + "_" + this.foodPathList[_loc4_ + 1];
            _loc9_ = this.dict[_loc8_] as VSkin;
            if(_loc6_ != MissionButton.M_COMPLETE == Boolean(_loc9_))
            {
               if(_loc9_)
               {
                  _loc9_.removeFromParent();
                  delete this.dict[_loc8_];
               }
               else
               {
                  _loc9_ = SkinManager.getPack(this.packName,_loc8_);
                  this.dict[_loc8_] = _loc9_;
                  this.greyPathMask.add(_loc9_);
               }
            }
            if(param1 && !_loc3_ && _loc6_ != MissionButton.M_COMPLETE)
            {
               _loc3_ = _loc5_;
            }
            _loc4_ += 4;
         }
         _loc2_ = this.exBtLayoutList.length;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this.exBtLayoutList[_loc4_];
            _loc10_ = this.exMissionStatus[MISSION_PREFIX + _loc5_];
            _loc11_ = _loc10_ ? _loc10_.missionTime : -1;
            if(_loc11_ < 0)
            {
               break;
            }
            _loc6_ = CoreLogic.serverTime > _loc11_ ? MissionButton.M_ACTIVE : MissionButton.M_DISABLED;
            _loc12_ = this.getButton(_loc5_,true) as ExMissionButton;
            _loc8_ = "efp" + _loc5_;
            if(_loc12_)
            {
               _loc12_.applyExState(_loc6_,_loc10_.resourceStatus,_loc11_ - CoreLogic.serverTime);
            }
            else
            {
               _loc12_ = this.createButton(_loc5_,0,this.exBtLayoutList[_loc4_ + 1],this.exBtLayoutList[_loc4_ + 2]) as ExMissionButton;
               _loc12_.skin.filters = [new GlowFilter(16777215,1,4,4)];
               _loc12_.applyExState(_loc6_,_loc10_.resourceStatus,_loc11_ - CoreLogic.serverTime);
               _loc9_ = SkinManager.getPack(this.packName,_loc8_,VSkin.NO_STRETCH);
               this.addPathFilters(_loc9_);
               _loc9_.left = this.greyPathMask.left;
               _loc9_.top = this.greyPathMask.top;
               this.dict[_loc8_] = _loc9_;
               this.panel.add(_loc9_,null,this.panel.getChildIndex(this.btLayer));
            }
            _loc4_ += 3;
         }
         if(_loc3_)
         {
            if(isGeometryPhase)
            {
               this.scroll(_loc3_);
            }
            else
            {
               this.scrollKind = _loc3_;
            }
         }
      }
      
      private function getButtonKind(param1:String, param2:Boolean) : String
      {
         return (param2 ? "ex_bt" : "bt") + param1;
      }
      
      private function createButton(param1:String, param2:uint, param3:int, param4:int) : MissionButton
      {
         var _loc6_:MissionButton = null;
         var _loc7_:ManualProxy = null;
         var _loc8_:UserProxy = null;
         var _loc9_:String = null;
         var _loc10_:PMissionInfo = null;
         var _loc11_:PMissionPercentage = null;
         if(param2 == 0)
         {
            _loc6_ = new ExMissionButton(param2);
            _loc6_.addVarianceListener(this,param2,param1);
            this.dict[this.getButtonKind(param1,true)] = _loc6_;
         }
         else
         {
            _loc6_ = new MissionButton(param2,param1);
            _loc6_.addVarianceListener(this,param2,param2);
            this.dict[this.getButtonKind(param2.toString(),false)] = _loc6_;
            if(param1)
            {
               _loc7_ = Facade.manualProxy;
               _loc8_ = Facade.userProxy;
               _loc9_ = "ms_mission" + param2;
               _loc10_ = _loc7_.getMissionInfo(_loc9_);
               if(!_loc10_)
               {
                  throw new Error("no mission info " + _loc9_);
               }
               for each(_loc11_ in _loc8_.missionPercentageList)
               {
                  if(_loc11_.mp_mission_kind == _loc9_)
                  {
                     break;
                  }
               }
               if(Boolean(_loc11_) && _loc11_.mp_mission_kind != _loc9_)
               {
                  _loc11_ = null;
               }
               _loc6_.resourceBossPack = [_loc10_.mi_resources,_loc11_];
            }
         }
         if(param3 >= 0)
         {
            _loc6_.assignLayout({
               "left":param3,
               "top":param4
            });
         }
         this.btLayer.add(_loc6_);
         var _loc5_:String = MISSION_PREFIX + param2;
         if(param2 == 0)
         {
            _loc5_ += "_ex";
         }
         _loc6_.hint = Lang.getString(_loc5_);
         return _loc6_;
      }
      
      public function getButton(param1:String, param2:Boolean = false) : MissionButton
      {
         return this.dict[this.getButtonKind(param1,param2)] as MissionButton;
      }
      
      public function scroll(param1:String) : void
      {
         var _loc2_:MissionButton = null;
         if(isGeometryPhase)
         {
            _loc2_ = this.getButton(param1);
            if(_loc2_)
            {
               this.move(-_loc2_.leftOrZero + (this.panel.w >> 1),-_loc2_.topOrZero + (this.panel.h >> 1),false);
            }
         }
      }
      
      public function getScrollParams(param1:String) : Point
      {
         var _loc2_:MissionButton = this.getButton(param1);
         if(_loc2_)
         {
            return new Point(-_loc2_.leftOrZero + (this.panel.w >> 1),-_loc2_.topOrZero + (this.panel.h >> 1));
         }
         return new Point();
      }
      
      public function addWinIndex(param1:String) : void
      {
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:VSkin = null;
         if(!this.winList || this.winList.indexOf(MISSION_PREFIX + param1) >= 0)
         {
            return;
         }
         this.onStopDrag();
         this.winList.push(MISSION_PREFIX + param1);
         var _loc2_:String = param1;
         var _loc3_:MissionButton = this.getButton(param1);
         if(_loc3_)
         {
            _loc3_.applyState(MissionButton.M_COMPLETE);
         }
         var _loc4_:uint = this.foodPathList.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.foodPathList[_loc5_] == param1)
            {
               _loc6_ = this.foodPathList[_loc5_ + 1];
               _loc7_ = this.getButtonState(_loc6_);
               _loc3_ = this.getButton(_loc6_);
               if(Boolean(_loc3_) && _loc7_ != MissionButton.M_DISABLED)
               {
                  _loc2_ = _loc6_;
                  _loc8_ = "fp" + param1 + "_" + _loc6_;
                  _loc9_ = this.dict[_loc8_] as VSkin;
                  if(!_loc9_)
                  {
                     _loc9_ = SkinManager.getPack(this.packName,_loc8_);
                     this.dict[_loc8_] = _loc9_;
                  }
                  this.greyPathMask.addChild(_loc9_);
                  _loc9_.x = this.foodPathList[_loc5_ + 2];
                  _loc9_.y = this.foodPathList[_loc5_ + 3];
                  _loc8_ = "twp" + _loc6_;
                  this.createPathTween(_loc9_,_loc8_);
                  _loc8_ = "bl" + _loc6_;
                  _loc9_ = this.dict[_loc8_];
                  if(_loc9_)
                  {
                     delete this.dict[_loc8_];
                     _loc8_ = "tw" + _loc6_;
                     this.createTween(_loc9_,_loc8_,[_loc3_,_loc7_,_loc8_],_loc3_);
                  }
                  Signal.delayCall(1.5,this.sync);
               }
            }
            _loc5_ += 4;
         }
         this.scroll(_loc2_);
      }
      
      private function createPathTween(param1:VSkin, param2:String) : void
      {
         var _loc3_:Tween = new Tween(param1);
         if(!this.tweenDict)
         {
            this.tweenDict = {};
         }
         this.tweenDict[param2] = _loc3_;
         _loc3_.play(["x",0,"y",0],1.5);
      }
      
      private function createTween(param1:VSkin, param2:String, param3:Array = null, param4:MissionButton = null) : void
      {
         var _loc5_:Sprite = new Sprite();
         param1.parent.addChild(_loc5_);
         var _loc6_:Rectangle = param1.getRect(null);
         param1.x = -_loc6_.x;
         param1.y = -_loc6_.y;
         _loc5_.addChild(param1);
         _loc5_.x = _loc6_.x;
         _loc5_.y = _loc6_.y;
         var _loc7_:Tween = new Tween(_loc5_,this.onTween);
         _loc7_.data = param3 ? param3 : param2;
         if(!this.tweenDict)
         {
            this.tweenDict = {};
         }
         this.tweenDict[param2] = _loc7_;
         var _loc8_:Array = ["scaleX",1,0,"scaleY",1,0];
         if(param4)
         {
            _loc6_ = param4.getRect(_loc5_.parent);
            _loc8_.push("x",_loc6_.x + _loc6_.width / 2,"y",_loc6_.y + _loc6_.height / 2);
         }
         else
         {
            _loc8_.push("x",_loc5_.x + _loc6_.width / 2,"y",_loc5_.y + _loc6_.height / 2);
         }
         _loc7_.play(_loc8_,1.5);
         if(this.panel.mouseEnabled)
         {
            this.panel.mouseEnabled = this.panel.mouseChildren = false;
         }
      }
      
      private function onTween(param1:Tween) : void
      {
         var sp:Sprite = null;
         var ar:Array = null;
         var bt:MissionButton = null;
         var tween:Tween = param1;
         try
         {
            sp = tween.target as Sprite;
            sp.parent.removeChild(sp);
            (sp.getChildAt(0) as VSkin).dispose();
            if(tween.data is Array)
            {
               ar = tween.data;
               bt = ar[0] as MissionButton;
               bt.applyState(ar[1]);
               delete this.tweenDict[ar[2]];
            }
            else
            {
               delete this.tweenDict[tween.data];
            }
            if(!this.panel.mouseEnabled)
            {
               this.panel.mouseEnabled = this.panel.mouseChildren = true;
            }
         }
         catch(error:Error)
         {
            ErrorLogic.onUncaughtError(error.message + "\n  " + error.getStackTrace() + "\n  isArray=" + (tween.data is Array) + " tweenDict=" + (tweenDict != null));
         }
      }
      
      public function addLoadListener(param1:Function) : void
      {
         if(this.greyMapMask)
         {
            param1(new VEvent(VEvent.EXTERNAL_COMPLETE,this));
         }
         else
         {
            addListener(VEvent.EXTERNAL_COMPLETE,param1);
         }
      }
      
      public function setBtLayerLock(param1:Boolean) : void
      {
         if(this.btLayer)
         {
            this.btLayer.mouseChildren = !param1;
         }
      }
      
      public function addCellar(param1:Function) : void
      {
         this.cellarPanel = new CellarPanel();
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
      
      public function checkOverlapCellar(param1:String, param2:Boolean) : void
      {
         if(!this.cellarPanel)
         {
            return;
         }
         var _loc3_:MissionButton = this.getButton(param1,param2);
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Point = new Point();
         var _loc5_:Number = this.cellarPanel.localToGlobal(_loc4_).y - (_loc3_.localToGlobal(_loc4_).y + 100);
         if(_loc5_ < 0)
         {
            this.move(0,_loc5_,true);
         }
      }
      
      public function getMovePoint(param1:Point) : void
      {
         param1.x = this.panel.x;
         param1.y = this.panel.y;
      }
      
      override public function close(param1:MouseEvent = null) : void
      {
         super.close(param1);
      }
   }
}

