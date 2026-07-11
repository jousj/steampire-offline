package ui
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import ui.vbase.GridControl;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VCheckbox;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VInputText;
   import ui.vbase.VPager;
   import ui.vbase.VProgressBar;
   import ui.vbase.VScrollBar;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class UIFactory
   {
      
      public static const INDICATOR_GREEN:String = "GreenIndicator";
      
      public static const INDICATOR_BLUE:String = "BlueIndicator";
      
      public static const INDICATOR_PURPLE:String = "PurpleIndicator";
      
      public static const INDICATOR_GREY:String = "GreyIndicator";
      
      public static const INDICATOR_YELLOW:String = "YellowIndicator";
      
      public static const OFFER_PACK:String = "OfferDg7";
      
      public static const POLITICAL_PACK:String = "PoliticalMap3";
      
      public static const EMBLEM_PACK:String = "emblems3";
      
      public function UIFactory()
      {
         super();
      }
      
      public static function createCheckbox(param1:String, param2:Boolean = false, param3:uint = 20, param4:Boolean = true) : VCheckbox
      {
         var _loc5_:VSkin = SkinManager.getEmbed("ChBox");
         var _loc6_:VSkin = SkinManager.getEmbed("ChCheck",VComponent.SKIP_CONTENT_SIZE);
         _loc6_.left = -1;
         _loc5_.vCenter = _loc6_.vCenter = 0;
         var _loc7_:VText = new VText(param1,VText.CONTAIN);
         if(param4)
         {
            Style.applyDefaultFormat(_loc7_,param3);
         }
         else
         {
            _loc7_.setBaseFormat(param3,Style.metalRGB);
         }
         _loc7_.assignLayout({
            "left":41,
            "right":0,
            "vCenter":1
         });
         return new VCheckbox(_loc5_,_loc6_,_loc7_,param2);
      }
      
      public static function createEasyCheckbox(param1:Boolean = false) : VCheckbox
      {
         var _loc2_:VSkin = SkinManager.getEmbed("ChBox");
         var _loc3_:VSkin = SkinManager.getEmbed("ChCheck",VComponent.SKIP_CONTENT_SIZE);
         _loc3_.left = -1;
         _loc2_.vCenter = _loc3_.vCenter = 0;
         return new VCheckbox(_loc2_,_loc3_,null,param1);
      }
      
      public static function createNavButton(param1:Boolean, param2:Boolean = false, param3:uint = 0, param4:String = "NavBt") : VButton
      {
         if(param2)
         {
            param3 |= VSkin.ROTATE_90;
            if(param1)
            {
               param3 |= VSkin.FLIP_Y;
            }
         }
         else if(param1)
         {
            param3 |= VSkin.FLIP_X;
         }
         return VButton.createEmbed(param4,param3);
      }
      
      public static function createProgressBar(param1:String = null, param2:Boolean = true) : VProgressBar
      {
         if(!param1)
         {
            param1 = INDICATOR_GREEN;
         }
         var _loc3_:VSkin = SkinManager.getEmbed(param1,VSkin.STRETCH);
         _loc3_.assignLayout({
            "left":5,
            "right":5,
            "bottom":5,
            "top":6
         });
         var _loc4_:VProgressBar = new VProgressBar();
         _loc4_.init(_loc3_,null,true);
         _loc4_.layoutH = 27;
         _loc4_.addStretch(SkinManager.getEmbed("TrackPb",VSkin.STRETCH));
         if(param2)
         {
            _loc4_.add(SkinManager.getEmbed("blackoutPb",VSkin.STRETCH),{
               "left":2,
               "right":2,
               "top":2,
               "bottom":3
            },0);
         }
         return _loc4_;
      }
      
      public static function createInputText(param1:uint = 16, param2:String = null, param3:uint = 0, param4:uint = 0, param5:int = 7, param6:int = 7) : VInputText
      {
         var _loc7_:VInputText = new VInputText(param4,SkinManager.getEmbed("ChBox",VSkin.STRETCH),param5,param6);
         _loc7_.maxChars = param3;
         _loc7_.setBaseFormat(param1,4018009);
         if(param2)
         {
            _loc7_.setPromptData(param2,11184810);
         }
         _loc7_.format.baselineShift = -1;
         return _loc7_;
      }
      
      public static function createScrollBar(param1:uint = 1) : VScrollBar
      {
         var _loc2_:VSkin = SkinManager.getEmbed("SbTrack",VSkin.STRETCH);
         var _loc3_:VSkin = SkinManager.getEmbed("SbThumb",VSkin.STRETCH);
         var _loc4_:VScrollBar = new VScrollBar(_loc2_,_loc3_,VScrollBar.TRACK_DOWN);
         _loc4_.setSize(_loc2_.measuredWidth,160);
         _loc4_.add(_loc2_,{
            "top":15,
            "bottom":15
         });
         _loc4_.add(_loc3_,{
            "hCenter":0,
            "minH":16,
            "top":18,
            "bottom":18
         });
         var _loc5_:VButton = UIFactory.createNavButton(false,true);
         _loc4_.add(_loc5_,{
            "w":25,
            "h":17,
            "hCenter":-1
         });
         var _loc6_:VButton = UIFactory.createNavButton(true,true);
         _loc4_.add(_loc6_,{
            "w":25,
            "h":17,
            "hCenter":-1,
            "bottom":0
         });
         _loc4_.assignButton(_loc5_,_loc6_,param1);
         return _loc4_;
      }
      
      public static function getExternalLoadClip() : VSkin
      {
         var _loc1_:VSkin = SkinManager.getEmbed("ExternLoadClip",VSkin.CONTAIN | VSkin.PLAY_MOVIE_CLIP);
         _loc1_.minW = _loc1_.minH = 30;
         _loc1_.stretch();
         _loc1_.useCenter();
         return _loc1_;
      }
      
      public static function createPager(param1:uint = 9) : VPager
      {
         var _loc2_:VSkin = SkinManager.getEmbed("PagerBg",VSkin.STRETCH);
         _loc2_.assignLayout({
            "left":-16,
            "right":-16,
            "top":1
         });
         var _loc3_:VPager = new VPager("PagerOnBt","PagerOffBt",6,_loc2_);
         _loc3_.showCountLimit = param1;
         _loc3_.layoutH = _loc2_.measuredHeight;
         return _loc3_;
      }
      
      public static function createLearnArrow(param1:Number = 0, param2:Boolean = false) : VSkin
      {
         var _loc3_:uint = uint(VSkin.PLAY_MOVIE_CLIP | VSkin.NO_STRETCH | VSkin.ZERO_CENTER);
         if(param1 >= 180)
         {
            _loc3_ |= VSkin.FLIP_X;
         }
         var _loc4_:VSkin = SkinManager.getEmbed(param2 ? "ArrowLearnBl" : "ArrowLearn",_loc3_);
         _loc4_.setSize(2,2);
         _loc4_.rotation = param1;
         if(param2)
         {
            _loc4_.scaleX = _loc4_.scaleY = 1.3;
         }
         return _loc4_;
      }
      
      private static function createBaseDecorText(param1:String, param2:uint, param3:uint, param4:Array, param5:Array, param6:Array, param7:Matrix, param8:uint, param9:uint, param10:uint, param11:Object) : VComponent
      {
         var _loc12_:VText = new VText(param1,VText.CONTAIN,0,26);
         _loc12_.maxW = param3;
         _loc12_.geometryPhase();
         var _loc13_:VComponent = new VComponent();
         _loc13_.mouseChildren = false;
         _loc13_.addChild(_loc12_);
         var _loc14_:Number = param2 / 26;
         if(param3 > 0 && _loc12_.w * _loc14_ > param3)
         {
            _loc14_ = param3 / _loc12_.w;
            _loc12_.y = Math.ceil((param2 - _loc12_.h * _loc14_) / 2);
         }
         var _loc15_:Graphics = _loc13_.graphics;
         _loc15_.beginGradientFill(GradientType.LINEAR,param4,param5,param6,param7);
         _loc15_.drawRect(0,_loc12_.y,_loc12_.w,_loc12_.h);
         _loc15_.endFill();
         var _loc16_:Array = [new DropShadowFilter(1,165,param8,1,2,2,2,1,true,false,false),new GlowFilter(param9,1,2,2,6,1,false,false),new DropShadowFilter(1,63,param10,1,2,2,3,1,false,false,false)];
         if(param2 > 22 && param11 is uint)
         {
            _loc16_.push(new DropShadowFilter(2,63,uint(param11),1,2,2,3,1,false,false,false));
         }
         _loc13_.filters = _loc16_;
         _loc13_.scaleX = _loc13_.scaleY = _loc14_;
         _loc13_.mask = _loc12_;
         _loc13_.cacheAsBitmap = _loc12_.cacheAsBitmap = true;
         _loc13_.layoutW = Math.ceil(_loc12_.w * _loc13_.scaleX);
         _loc13_.layoutH = param2;
         return _loc13_;
      }
      
      public static function createDecorText(param1:String, param2:Boolean, param3:uint = 26, param4:uint = 0, param5:Boolean = true) : VComponent
      {
         if(param2)
         {
            return createBaseDecorText(param1,param3,param4,[9263392,14074697],[1,1],[0,255],new Matrix(-0.0000152587890625,-0.007080078125,-0.015411376953125,0.000030517578125,0,14.25),13026887,8080157,4528138,param5 ? 10652805 : null);
         }
         return createBaseDecorText(param1,param3,param4,[15212845,10298150],[1,1],[0,255],new Matrix(0,0.0067138671875,-0.02197265625,0.000030517578125,0,12.25),13523759,7475208,4528138,10652805);
      }
      
      public static function createGrayDecorText(param1:String, param2:uint = 26, param3:uint = 0) : VComponent
      {
         return createBaseDecorText(param1,param2,param3,[10065554,14738397],[1,1],[0,254],new Matrix(0,-0.02587890625,-0.02587890625,0,0,13),14738397,2959400,4018009,12893879);
      }
      
      public static function createEmptyGridMessage(param1:String) : VComponent
      {
         var _loc2_:VComponent = new VComponent();
         _loc2_.addStretch(SkinManager.getEmbed("BoardMoveBg",VSkin.STRETCH_BG));
         _loc2_.add(new VText(param1,VText.CENTER,Style.yellowRGB,22),{
            "left":30,
            "top":14,
            "right":30,
            "bottom":14,
            "maxW":500
         });
         _loc2_.useCenter();
         return _loc2_;
      }
      
      public static function createYellowText(param1:String, param2:uint = 0, param3:uint = 18, param4:Boolean = false) : VText
      {
         var _loc5_:VText = new VText(param1,param2);
         Style.applyDefaultFormat(_loc5_,param3,param4);
         return _loc5_;
      }
      
      public static function useGridControlH43(param1:VGrid, param2:Boolean = true, param3:uint = 0, param4:Function = null) : void
      {
         GridControl.assign(param1,param3 == 0 ? uint(GridControl.PAGER_CALC_COUNT | GridControl.SMART) : param3,createNavButton,param2 ? addNavBt43Brk : addNavBt43,createPager,param4 != null ? param4 : addPager);
      }
      
      public static function useGridControlV33(param1:VGrid) : void
      {
         GridControl.assign(param1,GridControl.NAV_SMART | GridControl.NAV_VERTICAL,createNavButton,addNavVerticalBt33);
      }
      
      public static function useGridControlNav(param1:VGrid, param2:Function) : void
      {
         GridControl.assign(param1,GridControl.NAV_SMART,createNavButton,param2);
      }
      
      public static function useGridControl(param1:VGrid, param2:Function, param3:Function = null) : void
      {
         GridControl.assign(param1,GridControl.PAGER_CALC_COUNT | GridControl.SMART,createNavButton,param2,createPager,param3 != null ? param3 : addPager);
      }
      
      public static function addPager(param1:VGrid, param2:VPager) : void
      {
         (param1.parent as VComponent).add(param2,{
            "hCenter":0,
            "bottom":-8
         });
      }
      
      public static function addNavBt43Brk(param1:VGrid, param2:VButton, param3:VButton) : void
      {
         param1.add(param2,{
            "w":43,
            "h":70,
            "vCenter":0,
            "left":-62
         });
         param1.add(param3,{
            "w":43,
            "h":70,
            "vCenter":0,
            "right":-62
         });
      }
      
      public static function addNavBt43(param1:VGrid, param2:VButton, param3:VButton) : void
      {
         param1.add(param2,{
            "w":43,
            "h":70,
            "vCenter":0,
            "left":-49
         });
         param1.add(param3,{
            "w":43,
            "h":70,
            "vCenter":0,
            "right":-49
         });
      }
      
      public static function addNavVerticalBt33(param1:VGrid, param2:VButton, param3:VButton) : void
      {
         param1.add(param2,{
            "w":52,
            "h":33,
            "hCenter":0,
            "top":-28
         });
         param1.add(param3,{
            "w":52,
            "h":33,
            "hCenter":0,
            "bottom":-28
         });
      }
      
      public static function addNavBt30(param1:VGrid, param2:VButton, param3:VButton) : void
      {
         param1.add(param2,{
            "w":30,
            "h":50,
            "vCenter":0,
            "left":-36
         });
         param1.add(param3,{
            "w":30,
            "h":50,
            "vCenter":0,
            "right":-36
         });
      }
      
      public static function addNavBt18(param1:VGrid, param2:VButton, param3:VButton) : void
      {
         param1.add(param2,{
            "w":18,
            "h":29,
            "vCenter":1,
            "left":-22
         });
         param1.add(param3,{
            "w":18,
            "h":29,
            "vCenter":1,
            "right":-22
         });
      }
      
      public static function addGridWithBg(param1:VGrid, param2:VComponent, param3:Boolean, param4:int, param5:int = 0, param6:int = 0, param7:Boolean = true) : void
      {
         var _loc8_:int = int(param1.renderList[0].measuredHeight);
         param2.add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH),{
            "top":param4,
            "left":param5,
            "right":param6,
            "h":param1.vCount * (_loc8_ + param1.vGap) - param1.vGap + 23
         });
         param5 += 12;
         param6 += 11;
         var _loc9_:int = 1;
         while(_loc9_ < param1.vCount)
         {
            param2.add(new VFill(12893879),{
               "h":_loc8_,
               "top":param4 + 10 + _loc9_ * (_loc8_ + param1.vGap),
               "left":param5,
               "right":param6
            });
            _loc9_ += 2;
         }
         param2.add(param1,{
            "left":param5,
            "right":param6,
            "top":param4 + 10
         });
         if(param3)
         {
            param1.dispatcher = param2;
         }
         if(param7)
         {
            useGridControlNav(param1,addNavBt30);
         }
      }
      
      public static function createLoadPanel(param1:VComponent = null, param2:Object = null, param3:int = -1) : VComponent
      {
         var _loc4_:VComponent = new VComponent();
         _loc4_.addStretch(SkinManager.getEmbed("WhBlockBg",VSkin.STRETCH));
         _loc4_.add(new VText(Lang.getString("load_title"),VText.CONTAIN_CENTER,Style.metalRGB),{
            "left":30,
            "right":30,
            "vCenter":0
         });
         if(param1)
         {
            param1.add(_loc4_,param2,param3);
         }
         return _loc4_;
      }
      
      public static function createPaperSkin() : VSkin
      {
         var _loc1_:VSkin = SkinManager.getEmbed("PaperDialogBg",VSkin.STRETCH_BG);
         _loc1_.filters = [new DropShadowFilter(3,90,0,0.298,8,8,4)];
         return _loc1_;
      }
      
      public static function createBlueShineClip() : VSkin
      {
         var _loc1_:VSkin = null;
         _loc1_ = SkinManager.getEmbed("shineClip",VSkin.PLAY_MOVIE_CLIP | VSkin.ZERO_CENTER);
         _loc1_.filters = [new ColorMatrixFilter([0.37,0,0,0,0,0,0.88,0,0,0,0,0,1,0,0,0,0,0,1,0])];
         return _loc1_;
      }
   }
}

