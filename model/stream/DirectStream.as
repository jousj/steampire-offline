package model.stream
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class DirectStream extends Socket
   {
      
      private var packet:IClientPacket;
      
      private var buffer:BinaryBuffer = new BinaryBuffer();
      
      private var waitLength:int = -1;
      
      private var logicFunc:Function;
      
      private var errorFunc:Function;
      
      public function DirectStream(param1:IClientPacket, param2:Function, param3:Function)
      {
         super();
         endian = this.buffer.endian;
         this.packet = param1;
         this.logicFunc = param2;
         this.errorFunc = param3;
         addEventListener(Event.CLOSE,this.onDirectClose);
         addEventListener(Event.CONNECT,this.onDirectConnect);
         addEventListener(IOErrorEvent.IO_ERROR,this.onDirectError);
         addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onDirectError);
         addEventListener(ProgressEvent.SOCKET_DATA,this.onDirectData);
      }
      
      public function request() : void
      {
         writeBytes(Facade.protoProxy.packetToBinary(this.packet));
         flush();
      }
      
      private function onDirectClose(param1:Event) : void
      {
         this.onError(param1);
      }
      
      private function onDirectConnect(param1:Event) : void
      {
         this.request();
      }
      
      private function onDirectError(param1:Event) : void
      {
         this.onError(param1);
      }
      
      private function onError(param1:Event) : void
      {
         var _loc2_:Function = this.errorFunc;
         this.clear();
         if(_loc2_ != null)
         {
            _loc2_(param1.toString());
         }
      }
      
      private function onDirectData(param1:ProgressEvent) : void
      {
         if(this.waitLength < 0)
         {
            if(bytesAvailable < 8)
            {
               return;
            }
            this.buffer.family = readUnsignedShort();
            this.buffer.subfamily = readUnsignedByte();
            readUnsignedByte();
            this.waitLength = readUnsignedInt();
         }
         if(bytesAvailable >= this.waitLength)
         {
            if(this.waitLength > 0)
            {
               readBytes(this.buffer,0,this.waitLength);
            }
            this.logicFunc(this.buffer);
            this.buffer.length = 0;
            this.waitLength = -1;
         }
      }
      
      public function clear() : void
      {
         if(this.logicFunc != null)
         {
            removeEventListener(Event.CLOSE,this.onDirectClose);
            removeEventListener(Event.CONNECT,this.onDirectConnect);
            removeEventListener(ProgressEvent.SOCKET_DATA,this.onDirectData);
            this.logicFunc = null;
            this.errorFunc = null;
            if(connected)
            {
               try
               {
                  close();
               }
               catch(error:Error)
               {
               }
            }
         }
      }
   }
}

