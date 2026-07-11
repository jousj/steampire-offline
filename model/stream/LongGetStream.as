package model.stream
{
   import engine.signal.Signal;
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLStream;
   import flash.utils.Endian;
   import flash.utils.getTimer;
   import logic.ErrorLogic;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class LongGetStream extends URLStream
   {
      
      private var url:String;
      
      private var httpStatus:int;
      
      private var urlRequest:URLRequest;
      
      private var logicFunc:Function;
      
      private var signal:Signal;
      
      private var errorTime:int;
      
      private var errorCount:uint;
      
      public function LongGetStream(param1:String, param2:Function)
      {
         super();
         this.url = param1;
         this.logicFunc = param2;
         endian = Endian.LITTLE_ENDIAN;
         addEventListener(Event.COMPLETE,this.onCompleteLoad);
         addEventListener(IOErrorEvent.IO_ERROR,this.onErrorLoad);
         addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorLoad);
         addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
      }
      
      public function clear() : void
      {
         this.tryClose();
         if(this.signal)
         {
            this.signal.stop();
         }
      }
      
      public function request(param1:IClientPacket, param2:Number = 0) : void
      {
         if(this.signal)
         {
            this.signal.stop();
         }
         var _loc3_:BinaryBuffer = Facade.protoProxy.packetToBinary(param1);
         this.urlRequest = new URLRequest(this.url);
         this.urlRequest.method = URLRequestMethod.POST;
         this.urlRequest.contentType = "application/octet-stream";
         this.urlRequest.data = _loc3_;
         this.errorCount = 0;
         if(param2 > 0)
         {
            this.delayRequest(param2);
         }
         else
         {
            this.applyRequest();
         }
      }
      
      private function tryClose() : void
      {
         if(connected)
         {
            try
            {
               close();
            }
            catch(error:IOError)
            {
            }
         }
      }
      
      private function applyRequest() : void
      {
         this.tryClose();
         this.httpStatus = 0;
         try
         {
            load(this.urlRequest);
         }
         catch(error:Error)
         {
            onErrorLoad(null);
         }
      }
      
      private function readBuffer() : BinaryBuffer
      {
         var _loc1_:BinaryBuffer = null;
         var _loc2_:uint = 0;
         if(connected && bytesAvailable >= 8)
         {
            _loc1_ = new BinaryBuffer(readUnsignedShort(),readUnsignedByte());
            readUnsignedByte();
            _loc2_ = readUnsignedInt();
            if(_loc2_ > 0)
            {
               if(bytesAvailable >= _loc2_)
               {
                  readBytes(_loc1_,0,_loc2_);
                  return _loc1_;
               }
               this.showError("bad size packet");
            }
         }
         return null;
      }
      
      private function onCompleteLoad(param1:Event) : void
      {
         var _loc2_:BinaryBuffer = null;
         if(!connected || bytesAvailable == 0)
         {
            return;
         }
         if(bytesAvailable < 8)
         {
            this.showError("short packet");
         }
         else
         {
            _loc2_ = this.readBuffer();
            if(_loc2_)
            {
               if(_loc2_.family == 0 && _loc2_.subfamily == 0)
               {
                  this.showError(_loc2_);
               }
               else if(_loc2_.family == 0 && _loc2_.subfamily == 2)
               {
                  this.logicFunc(null);
               }
               else
               {
                  this.logicFunc(_loc2_);
               }
            }
         }
      }
      
      private function showError(param1:Object = null) : void
      {
         this.tryClose();
         ErrorLogic.show(param1 ? param1 : Lang.getString("bad_server_answer") + (this.httpStatus > 0 ? " (httpStatus=" + this.httpStatus + ")" : "") + " [LGet]");
      }
      
      private function onErrorLoad(param1:Event) : void
      {
         var _loc2_:int = 0;
         if(param1 is IOErrorEvent && (param1 as IOErrorEvent).text.indexOf("#2032") > -1)
         {
            _loc2_ = getTimer();
            if(_loc2_ - this.errorTime < 10000)
            {
               ++this.errorCount;
               if(this.errorCount == 50)
               {
                  this.showError();
                  return;
               }
            }
            else
            {
               this.errorCount = 0;
            }
            this.errorTime = _loc2_;
            if(this.httpStatus == 504)
            {
               this.applyRequest();
            }
            else
            {
               this.delayRequest(2);
            }
         }
         else
         {
            this.showError();
         }
      }
      
      private function delayRequest(param1:Number) : void
      {
         if(!this.signal)
         {
            this.signal = new Signal(this.applyRequest);
         }
         this.signal.delayCall(param1);
      }
      
      private function onHttpStatus(param1:HTTPStatusEvent) : void
      {
         this.httpStatus = param1.status;
      }
   }
}

