package ui.vbase
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.text.engine.FontLookup;
   import flash.text.engine.TextBaseline;
   import flash.utils.getDefinitionByName;
   import flashx.textLayout.elements.Configuration;
   import flashx.textLayout.elements.InlineGraphicElement;
   import flashx.textLayout.elements.TextFlow;
   import flashx.textLayout.formats.TextLayoutFormat;
   import flashx.textLayout.formats.WhiteSpaceCollapse;
   
   public class SkinManager
   {
      
      public static var url:String;
      
      public static const LOAD_CLIP:uint = 1;
      
      public static const NO_CACHE:uint = 2;
      
      public static const PNG:uint = 4;
      
      public static const JPG:uint = PNG | 8;
      
      public static const externalDispatcher:EventDispatcher = new EventDispatcher();
      
      private static const swfCache:Object = {};
      
      public static var randomKey:String = "189955";
      
      public function SkinManager()
      {
         super();
      }
      
      public static function init(param1:String) : TextLayoutFormat
      {
         url = param1;
         XML.ignoreProcessingInstructions = false;
         XML.ignoreWhitespace = false;
         var _loc2_:Configuration = TextFlow.defaultConfiguration;
         _loc2_.inlineGraphicResolverFunction = SkinManager.inlineGraphicResolverFunction;
         _loc2_.manageTabKey = false;
         var _loc3_:TextLayoutFormat = _loc2_.textFlowInitialFormat as TextLayoutFormat;
         _loc3_.fontLookup = FontLookup.EMBEDDED_CFF;
         _loc3_.whiteSpaceCollapse = WhiteSpaceCollapse.PRESERVE;
         return _loc3_;
      }
      
      public static function applyEmbed(param1:VSkin, param2:String) : void
      {
         var _loc3_:Class = null;
         var _loc4_:Object = null;
         try
         {
            _loc3_ = getDefinitionByName("ESkins." + param2) as Class;
            _loc4_ = new _loc3_();
         }
         catch(error:ReferenceError)
         {
         }
         param1.applyContent(_loc4_);
      }
      
      public static function getEmbed(param1:String, param2:uint = 0) : VSkin
      {
         var _loc3_:VSkin = new VSkin(param2);
         applyEmbed(_loc3_,param1);
         return _loc3_;
      }
      
      public static function applyExternal(param1:VSkin, param2:String, param3:String = null, param4:uint = 0) : void
      {
         var _loc7_:AssetLoader = null;
         var _loc5_:Boolean = (param4 & PNG) != 0;
         if(_loc5_)
         {
            param2 += (param4 & JPG) == JPG ? ".jpg" : ".png";
         }
         var _loc6_:Object = swfCache[param2];
         if(_loc6_ === false || _loc6_ is Loader)
         {
            param1.applyContent(getCopyExternal(param2,param3));
         }
         else
         {
            param1.setExternalInterest(new VOExternalInfo(param2,param3));
            if(_loc6_ == null)
            {
               _loc7_ = new AssetLoader();
               if((param4 & NO_CACHE) == 0)
               {
                  swfCache[param2] = true;
               }
               _loc7_.packName = param2;
               _loc7_.init(onExternalLoad);
               _loc7_.loadUrl(url + (_loc5_ ? "images/" + param2 : "swfs/" + param2 + ".swf") + "?v=" + randomKey,!_loc5_);
            }
            if((param4 & LOAD_CLIP) != 0)
            {
               param1.useLoadClip();
            }
         }
      }
      
      public static function loadSwf(param1:String) : void
      {
         var _loc2_:AssetLoader = null;
         if(swfCache[param1] == null)
         {
            _loc2_ = new AssetLoader();
            swfCache[param1] = true;
            _loc2_.packName = param1;
            _loc2_.init(onExternalLoad);
            _loc2_.loadUrl(url + "swfs/" + param1 + ".swf?v=" + randomKey,true);
         }
      }
      
      public static function getExternal(param1:String, param2:uint = 0, param3:uint = 0) : VSkin
      {
         var _loc4_:VSkin = new VSkin(param3);
         applyExternal(_loc4_,param1,null,param2);
         return _loc4_;
      }
      
      public static function getPack(param1:String, param2:String, param3:uint = 0, param4:uint = 0, param5:Function = null) : VSkin
      {
         var _loc6_:VSkin = new VSkin(param3);
         applyExternal(_loc6_,param1,param2,param4);
         if(param5 != null && !_loc6_.isContent)
         {
            _loc6_.setMode(_loc6_.getMode() | VSkin.EXTERNAL_EVENT,false);
            _loc6_.addEventListener(VEvent.EXTERNAL_COMPLETE,param5);
         }
         return _loc6_;
      }
      
      public static function addInsideContainer(param1:Sprite, param2:String, param3:DisplayObject) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc4_:* = int(param1.numChildren - 1);
         while(_loc4_ >= 0)
         {
            _loc5_ = param1.getChildAt(_loc4_);
            if(_loc5_.name == param2)
            {
               if(_loc5_ is Sprite)
               {
                  (_loc5_ as Sprite).addChild(param3);
               }
               break;
            }
            _loc4_--;
         }
         if(param3 is VComponent)
         {
            (param3 as VComponent).geometryPhase();
         }
      }
      
      public static function getCopyExternal(param1:String, param2:String) : Object
      {
         var _loc4_:Class = null;
         var _loc3_:Loader = swfCache[param1] as Loader;
         if(_loc3_)
         {
            try
            {
               if(_loc3_.content is Bitmap)
               {
                  return (_loc3_.content as Bitmap).bitmapData;
               }
               _loc4_ = _loc3_.contentLoaderInfo.applicationDomain.getDefinition("Skins." + (param2 ? param2 : param1)) as Class;
               return new _loc4_();
            }
            catch(error:ReferenceError)
            {
            }
         }
         return null;
      }
      
      public static function onExternalLoad(param1:AssetLoader) : void
      {
         swfCache[param1.packName] = param1.isError ? false : param1.loader;
         externalDispatcher.dispatchEvent(new Event(param1.packName));
      }
      
      public static function inlineGraphicResolverFunction(param1:InlineGraphicElement) : VComponent
      {
         var _loc5_:VComponent = null;
         var _loc6_:VSkin = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         param1.dominantBaseline = TextBaseline.IDEOGRAPHIC_CENTER;
         var _loc2_:String = param1.source as String;
         if(param1.width is uint)
         {
            _loc7_ = param1.width as uint;
         }
         if(param1.height is uint)
         {
            _loc8_ = param1.height as uint;
         }
         var _loc3_:Array = _loc2_.split(",");
         var _loc4_:uint = _loc3_.length;
         if(_loc4_ >= 2)
         {
            _loc9_ = _loc3_[1] as String;
            if(_loc9_)
            {
               _loc10_ = _loc3_[0] as String;
               if(_loc10_ == "lib")
               {
                  _loc5_ = getEmbed(_loc9_);
               }
               else
               {
                  _loc5_ = getPack(_loc9_,_loc4_ >= 3 ? _loc3_[2] : null,0,_loc10_ == "png" ? PNG : (_loc10_ == "jpg" ? JPG : 0));
               }
            }
         }
         if(!_loc5_)
         {
            _loc5_ = _loc6_ = new VSkin();
         }
         else
         {
            _loc6_ = _loc5_ as VSkin;
         }
         if(_loc6_)
         {
            _loc6_.setMode(_loc6_.isContent ? VSkin.LEFT : 0,false);
            _loc6_.setGeometrySize(_loc7_,_loc8_,true);
            if(_loc6_.isContent && _loc6_.width < _loc7_)
            {
               _loc7_ = Math.ceil(_loc6_.width);
               param1.width = _loc7_;
            }
            _loc6_.graphics.beginFill(0,0);
            _loc6_.graphics.drawRect(0,0,_loc7_,_loc8_);
         }
         else
         {
            _loc5_.setGeometrySize(_loc7_,_loc8_,true);
         }
         if(param1.locale)
         {
            _loc5_.hint = param1.locale;
            _loc5_.mouseEnabled = true;
            param1.locale = undefined;
         }
         return _loc5_;
      }
      
      public static function getTLFSource(param1:String, param2:int = -1, param3:String = null) : String
      {
         if(param2 >= 0)
         {
            if(param3)
            {
               param1 += "," + param3;
            }
            if((param2 & PNG) != 0)
            {
               return ((param2 & JPG) == JPG ? "jpg," : "png,") + param1;
            }
            return "swf," + param1;
         }
         return "lib," + param1;
      }
   }
}

