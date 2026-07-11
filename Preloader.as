package
{
   import ESkins.ExternLoadClip;
   import ESkins.PreloadImg;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.filters.GlowFilter;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.getDefinitionByName;
   
   public class Preloader extends MovieClip
   {
      public static var static_url:String;
      public static var dynamic_url:String;
      public static var locale_url:String;
      public static var uid:String = "";
      public static var userStageList:Array = ["t_new_user","t_html_loaded","t_flash_player_ok","t_preloader","t_main_swf_loaded","t_lang_loaded","t_screen_loaded","t_info_obj_loaded","t_map_loaded","t_player_loaded","t_dict_loaded","m0_intro1","m0_victory","m1_victory"];
      
      private const OFFICIAL_LANG_SUBPATH:String = "steam/locale/redspell/LangRU.json";
      private var _langLoader:URLLoader;
      
      public function Preloader()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.tabChildren = stage.stageFocusRect = false;
         stage.color = 1838872;
         stage.frameRate = 30;
         stage.showDefaultContextMenu = false;
         
         static_url = loaderInfo.parameters.static_url || "./";
         dynamic_url = loaderInfo.parameters.dynamic_url || "./";
         locale_url = loaderInfo.parameters.lang_url || static_url;
         uid = loaderInfo.parameters.user_id || "";

         var _loc1_:PreloadImg = new PreloadImg();
         var _loc2_:Bitmap = new Bitmap(_loc1_);
         addChild(_loc2_);
         var _loc3_:ExternLoadClip = new ExternLoadClip();
         _loc3_.filters = [new GlowFilter(2957061,1,2,2,2)];
         addChild(_loc3_);
         var _loc4_:TextField = new TextField();
         _loc4_.defaultTextFormat = new TextFormat("Arial",20,12171705,null,null,null,null,null,TextFormatAlign.CENTER);
         _loc4_.selectable = false;
         _loc4_.multiline = true;
         _loc4_.text = "Loading Language...";
         _loc4_.height = _loc4_.textHeight + 4;
         addChild(_loc4_);
         
         this.onResize(null);
         stage.addEventListener(Event.RESIZE,this.onResize);
         
         loadLanguage();
      }

      private function loadLanguage():void
      {
         var finalLangPath:String = locale_url;
         if (finalLangPath.charAt(finalLangPath.length - 1) != "/") {
            finalLangPath += "/";
         }
         finalLangPath += OFFICIAL_LANG_SUBPATH;

         _langLoader = new URLLoader();
         _langLoader.addEventListener(Event.COMPLETE, onLangLoaded);
         _langLoader.addEventListener(IOErrorEvent.IO_ERROR, onLangError);
         _langLoader.load(new URLRequest(finalLangPath));
      }

      private function onLangLoaded(e:Event):void
      {
         try {
            var data:Object = JSON.parse(_langLoader.data);
            getDefinitionByName("Facade").instance.setupLanguage(data);
            addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            loaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
            loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.setProgressData);
         } catch(err:Error) {
            sendError("Lang parse error: " + err.message);
         }
      }

      private function onLangError(e:IOErrorEvent):void
      {
         sendError("Lang load failed from: " + OFFICIAL_LANG_SUBPATH);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function onResize(param1:Event) : void
      {
         var _loc2_:DisplayObject = getChildAt(0);
         _loc2_.x = Math.round((stage.stageWidth - _loc2_.width) / 2);
         _loc2_.y = Math.round((stage.stageHeight - _loc2_.height) / 2);
         var _loc3_:Number = Math.round(_loc2_.getRect(stage).bottom) + 20;
         _loc2_ = getChildAt(1);
         _loc2_.x = Math.round((stage.stageWidth - _loc2_.width) / 2);
         _loc2_.y = _loc3_;
         _loc3_ = Math.round(_loc2_.getRect(stage).bottom) + 14;
         _loc2_ = getChildAt(2);
         _loc2_.width = stage.stageWidth;
         _loc2_.y = _loc3_;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var event:Event = param1;
         if(currentFrame >= totalFrames)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            stop();
            loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.setProgressData);
            try
            {
               getDefinitionByName("Facade").instance.init(stage);
            }
            catch(error:Error)
            {
               setProgressData(error);
               sendError("Preloader error: " + error);
            }
         }
      }
      
      private function onIOError(param1:IOErrorEvent) : void
      {
      }
      
      private function jsCallback(... rest) : void
      {
      }
      
      public function setProgressData(param1:Object) : void
      {
         var _loc3_:ProgressEvent = null;
         var _loc2_:TextField = getChildAt(2) as TextField;
         if(param1 is ProgressEvent)
         {
            _loc3_ = param1 as ProgressEvent;
            _loc2_.text = "1/8:  " + uint(_loc3_.bytesLoaded / _loc3_.bytesTotal * 100) + "%";
         }
         else
         {
            _loc2_.text = String(param1);
         }
      }
      
      private function sendError(param1:Object) : void
      {
         var _loc3_:URLRequest;
         var _loc2_:URLLoader = new URLLoader();
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,trace,false,0,true);
         _loc2_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,trace,false,0,true);
         _loc3_ = new URLRequest(dynamic_url + "client_errors");
         _loc3_.method = URLRequestMethod.POST;
         _loc3_.contentType = "text/example";
         _loc3_.data = param1;
         try
         {
            _loc2_.load(_loc3_);
         }
         catch(error:Error)
         {
         }
      }
   }
}