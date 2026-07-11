package ui.vbase
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class AssetLoader
   {
      
      public static var imageContext:LoaderContext;
      
      public static var policyImageContext:LoaderContext = new LoaderContext(true);
      
      private static const instances:Dictionary = new Dictionary();
      
      public var loader:Loader;
      
      public var packName:String;
      
      public var isError:Boolean;
      
      private var finishFunc:Function;
      
      private var progressHandler:Function;
      
      public function AssetLoader()
      {
         super();
      }
      
      public static function load(param1:Object, param2:Boolean, param3:Function = null, param4:Function = null) : AssetLoader
      {
         var _loc5_:AssetLoader = new AssetLoader();
         _loc5_.init(param3,param4);
         if(param1 is ByteArray)
         {
            _loc5_.loadBytes(param1 as ByteArray,param2);
         }
         else
         {
            _loc5_.loadUrl(String(param1),param2);
         }
         return _loc5_;
      }
      
      public function init(param1:Function = null, param2:Function = null) : void
      {
         instances[this] = true;
         this.finishFunc = param1;
         this.loader = new Loader();
         var _loc3_:LoaderInfo = this.loader.contentLoaderInfo;
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.onHandler);
         _loc3_.addEventListener(Event.COMPLETE,this.onHandler);
         if(param2 != null)
         {
            this.progressHandler = param2;
            _loc3_.addEventListener(ProgressEvent.PROGRESS,param2);
         }
      }
      
      public function getLoaderContext(param1:Boolean, param2:Boolean = false) : LoaderContext
      {
         if(param1)
         {
            return new LoaderContext(false,new ApplicationDomain(null));
         }
         return param2 ? policyImageContext : imageContext;
      }
      
      public function loadUrl(param1:String, param2:Boolean) : void
      {
         var url:String = param1;
         var isSWF:Boolean = param2;
         try
         {
            this.loader.load(new URLRequest(url),this.getLoaderContext(isSWF));
         }
         catch(error:Error)
         {
            onHandler(null);
         }
      }
      
      public function loadBytes(param1:ByteArray, param2:Boolean) : void
      {
         var ba:ByteArray = param1;
         var isSWF:Boolean = param2;
         try
         {
            this.loader.loadBytes(ba,this.getLoaderContext(isSWF));
         }
         catch(error:Error)
         {
            onHandler(null);
         }
      }
      
      public function loadEx(param1:String, param2:LoaderContext) : void
      {
         var url:String = param1;
         var context:LoaderContext = param2;
         try
         {
            this.loader.load(new URLRequest(url),context);
         }
         catch(error:Error)
         {
            onHandler(null);
         }
      }
      
      private function onHandler(param1:Event) : void
      {
         this.isError = !param1 || param1.type != Event.COMPLETE;
         var _loc2_:LoaderInfo = this.loader.contentLoaderInfo;
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.onHandler);
         _loc2_.removeEventListener(Event.COMPLETE,this.onHandler);
         if(this.progressHandler != null)
         {
            _loc2_.removeEventListener(ProgressEvent.PROGRESS,this.progressHandler);
            this.progressHandler = null;
         }
         delete instances[this];
         if(this.finishFunc != null)
         {
            this.finishFunc(this);
         }
         this.finishFunc = null;
         this.loader = null;
      }
      
      public function reset() : void
      {
         if(this.loader)
         {
            this.finishFunc = null;
            try
            {
               this.loader.close();
            }
            catch(error:Error)
            {
            }
            if(this.loader)
            {
               this.onHandler(null);
            }
         }
      }
   }
}

