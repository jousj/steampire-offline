package utils
{
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.getTimer;
   
   public class ULoader extends URLLoader
   {
      
      private var successFunc:Function;
      
      private var errorFunc:Function;
      
      private var progressFunc:Function;
      
      private var progressTime:int;
      
      private var status:int;
      
      public function ULoader()
      {
         super();
         addEventListener(Event.COMPLETE,this.onCompleteLoad);
         addEventListener(IOErrorEvent.IO_ERROR,this.onCompleteLoad);
         addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onCompleteLoad);
         addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
         Facade.commonHash[this] = true;
      }
      
      public static function load(param1:Object, param2:Function, param3:Boolean = false, param4:Function = null, param5:Function = null) : void
      {
         var loader:ULoader = null;
         var urlOrRequest:Object = param1;
         var successFunc:Function = param2;
         var isBinary:Boolean = param3;
         var errorFunc:Function = param4;
         var progressFunc:Function = param5;
         loader = new ULoader();
         loader.successFunc = successFunc;
         loader.errorFunc = errorFunc;
         if(progressFunc != null)
         {
            loader.progressFunc = progressFunc;
            loader.addEventListener(ProgressEvent.PROGRESS,loader.onProgress);
         }
         if(isBinary)
         {
            loader.dataFormat = URLLoaderDataFormat.BINARY;
         }
         try
         {
            loader.load(urlOrRequest is URLRequest ? urlOrRequest as URLRequest : new URLRequest(String(urlOrRequest)));
         }
         catch(e:Error)
         {
            loader.onCompleteLoad(null);
         }
      }
      
      private function onHttpStatus(param1:HTTPStatusEvent) : void
      {
         this.status = param1.status;
      }
      
      private function onProgress(param1:ProgressEvent) : void
      {
         var _loc2_:int = getTimer();
         if(_loc2_ - this.progressTime >= 50)
         {
            this.progressTime = _loc2_;
            this.progressFunc(param1.bytesTotal > 0 ? param1.bytesLoaded / param1.bytesTotal : 0);
         }
      }
      
      private function onCompleteLoad(param1:Event) : void
      {
         delete Facade.commonHash[this];
         removeEventListener(Event.COMPLETE,this.onCompleteLoad);
         removeEventListener(IOErrorEvent.IO_ERROR,this.onCompleteLoad);
         removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onCompleteLoad);
         removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
         if(this.progressFunc != null)
         {
            this.progressFunc = null;
            removeEventListener(ProgressEvent.PROGRESS,this.onProgress);
         }
         if(param1 != null && param1.type == Event.COMPLETE && (this.status == 0 || this.status == 200))
         {
            if(this.successFunc != null)
            {
               this.successFunc(data);
            }
         }
         else if(this.errorFunc != null)
         {
            this.errorFunc(param1);
         }
         this.successFunc = null;
         this.errorFunc = null;
      }
   }
}

