package model
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
   import model.vo.PacketDesc;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import utils.ULoader;
   
   public class ProtoProxy
   {
      
      public static const PROTOCOL_VERSION:uint = 77;
      
      public static const CLIENT_VERSION:String = "77.0";
      
      public const logs:Vector.<String> = new Vector.<String>();
      
      public var url:String;
      
      public var lastAnswerTime:int;
      
      public var requestTime:int;
      
      public var sleepSignal:Signal;
      
      private const urlStream:URLStream = new URLStream();
      
      private const waitPacketList:Vector.<PacketDesc> = new Vector.<PacketDesc>();
      
      private const freePacketList:Vector.<PacketDesc> = new Vector.<PacketDesc>();
      
      private var startRequestTime:int;
      
      private var httpStatus:int = 200;
      
      private var isRequest:Boolean;
      
      private var isLoad:Boolean;
      
      private var packetDesc:PacketDesc;
      
      private var packetCounter:uint;
      
      public function ProtoProxy()
      {
         super();
         this.urlStream.endian = Endian.LITTLE_ENDIAN;
         this.urlStream.addEventListener(Event.COMPLETE,this.onCompleteLoad);
         this.urlStream.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorLoad);
         this.urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onErrorLoad);
         this.urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onHttpStatus);
      }
      
      public function request(param1:IClientPacket, param2:Function = null, param3:uint = 0, param4:uint = 0, param5:Array = null, param6:String = null) : void
      {
         Facade.log("request" + " " + param1 + "[" + param3 + ":" + param4 + "]");
         var _loc7_:BinaryBuffer = this.packetToBinary(param1);
         var _loc8_:PacketDesc = this.freePacketList.length > 0 ? this.freePacketList.pop() : new PacketDesc();
         _loc8_.id = ++this.packetCounter;
         _loc8_.request_id = Math.random();
         _loc8_.rFamily = _loc7_.family;
         _loc8_.rSubfamily = _loc7_.subfamily;
         _loc8_.logic = param2;
         _loc8_.logicArgs = param5;
         _loc8_.aFamily = param3;
         _loc8_.aSubfamily = param4;
         _loc8_.ba = _loc7_;
         _loc8_.log = param6;
         this.waitPacketList.push(_loc8_);
         if(!this.isRequest)
         {
            this.nextRequest();
         }
      }
      
      public function service_request(param1:IClientPacket) : void
      {
         var _loc2_:URLRequest = new URLRequest(this.url);
         _loc2_.method = URLRequestMethod.POST;
         _loc2_.contentType = "application/octet-stream";
         _loc2_.data = this.packetToBinary(param1);
         ULoader.load(_loc2_,null,true);
      }
      
      public function cancel(param1:uint) : Boolean
      {
         var _loc2_:* = int(this.waitPacketList.length - 1);
         while(_loc2_ >= 0)
         {
            if(this.waitPacketList[_loc2_].id == param1)
            {
               this.waitPacketList[_loc2_].clear();
               this.waitPacketList.splice(_loc2_,1);
               return true;
            }
            _loc2_--;
         }
         return false;
      }
      
      public function packetToBinary(param1:IClientPacket) : BinaryBuffer
      {
         var _loc2_:BinaryBuffer = new BinaryBuffer();
         _loc2_.position = _loc2_.length = 8;
         param1.write(_loc2_);
         _loc2_.position = 0;
         _loc2_.writeShort(_loc2_.family);
         _loc2_.writeByte(_loc2_.subfamily);
         _loc2_.writeByte(PROTOCOL_VERSION);
         _loc2_.writeUnsignedInt(_loc2_.length - 8);
         return _loc2_;
      }
      
      public function clear() : void
      {
         var _loc1_:PacketDesc = null;
         for each(_loc1_ in this.waitPacketList)
         {
            _loc1_.clear();
            if(this.freePacketList.length < 20)
            {
               this.freePacketList.push(_loc1_);
            }
         }
         this.waitPacketList.length = 0;
         if(this.packetDesc)
         {
            this.packetDesc.clear();
            this.packetDesc = null;
         }
         if(this.isLoad)
         {
            this.isLoad = false;
            this.isRequest = false;
            try
            {
               this.urlStream.close();
            }
            catch(error:IOError)
            {
            }
         }
      }
      
      private function nextRequest() : void
      {
         var packetAbout:String;
         var urlRequest:URLRequest;
         if(this.packetDesc)
         {
            this.packetDesc.clear();
            if(this.freePacketList.length < 20)
            {
               this.freePacketList.push(this.packetDesc);
            }
            this.packetDesc = null;
         }
         if(this.waitPacketList.length == 0)
         {
            return;
         }
         this.isRequest = this.isLoad = true;
         this.packetDesc = this.waitPacketList.shift();
         packetAbout = this.packetDesc.rFamily.toString(16) + "x" + this.packetDesc.rSubfamily.toString(16);
         urlRequest = new URLRequest(this.url + "&request_id=" + this.packetDesc.request_id + "&proto=" + packetAbout + "&network=" + Facade.socialnet);
         urlRequest.method = URLRequestMethod.POST;
         urlRequest.contentType = "application/octet-stream";
         urlRequest.data = this.packetDesc.ba;
         this.packetDesc.ba = null;
         this.startRequestTime = getTimer();
         if(this.packetDesc.log)
         {
            packetAbout += "[" + this.packetDesc.log + "]";
         }
         this.logs.unshift(Number(this.startRequestTime / 1000).toFixed(2) + ": " + packetAbout);
         if(this.logs.length > 30)
         {
            this.logs.length = 30;
         }
         if(this.sleepSignal)
         {
            this.sleepSignal.delayCall(this.sleepSignal.delay);
         }
         try
         {
            this.urlStream.load(urlRequest);
         }
         catch(error:Error)
         {
            onErrorLoad(null);
         }
      }
      
      private function onCompleteLoad(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc3_:BinaryBuffer = null;
         var _loc4_:uint = 0;
         this.isLoad = false;
         this.lastAnswerTime = getTimer();
         this.requestTime = this.lastAnswerTime - this.startRequestTime;
         if(this.urlStream.bytesAvailable < 8)
         {
            _loc2_ = "short packet";
         }
         else
         {
            _loc3_ = new BinaryBuffer(this.urlStream.readUnsignedShort(),this.urlStream.readUnsignedByte());
            this.urlStream.readUnsignedByte();
            _loc4_ = this.urlStream.readUnsignedInt();
            if(_loc4_ > 0)
            {
               if(this.urlStream.bytesAvailable >= _loc4_)
               {
                  this.urlStream.readBytes(_loc3_,0,_loc4_);
               }
               else
               {
                  _loc2_ = "bad size packet";
               }
            }
            if(!_loc2_)
            {
               if(this.logs.length > 0)
               {
                  this.logs[0] += " > " + (Number(this.lastAnswerTime / 1000).toFixed(2) + ": " + _loc3_.family.toString(16) + "x" + _loc3_.subfamily.toString(16)) + " (" + this.requestTime + ")";
               }
               if(_loc3_.family == 0 && _loc3_.subfamily == 0)
               {
                  _loc2_ = _loc3_;
               }
               else if((this.packetDesc.aFamily > 0 || this.packetDesc.aSubfamily > 0) && (_loc3_.family != this.packetDesc.aFamily || _loc3_.subfamily != this.packetDesc.aSubfamily))
               {
                  _loc2_ = "bad answer:" + _loc3_.family.toString(16) + "x" + _loc3_.subfamily.toString(16) + "(need:" + this.packetDesc.aFamily.toString(16) + "x" + this.packetDesc.aSubfamily.toString(16) + ")";
               }
               else if(this.packetDesc.logic != null)
               {
                  if(!this.packetDesc.logicArgs)
                  {
                     this.packetDesc.logic(_loc3_);
                  }
                  else
                  {
                     this.packetDesc.logicArgs.unshift(_loc3_);
                     this.packetDesc.logic.apply(null,this.packetDesc.logicArgs);
                  }
               }
            }
         }
         this.isRequest = false;
         if(_loc2_)
         {
            this.clear();
            ErrorLogic.show(_loc2_);
         }
         else
         {
            this.nextRequest();
         }
      }
      
      private function onErrorLoad(param1:Event) : void
      {
         var _loc2_:String = null;
         this.clear();
         if(this.httpStatus == 401)
         {
            _loc2_ = Lang.getString("bad_authorized");
         }
         else
         {
            _loc2_ = Lang.getString("bad_server_answer");
            if(this.httpStatus > 0)
            {
               _loc2_ += " (httpStatus=" + this.httpStatus + ")";
            }
         }
         ErrorLogic.show(_loc2_);
      }
      
      private function onHttpStatus(param1:HTTPStatusEvent) : void
      {
         this.httpStatus = param1.status;
      }
   }
}

