package model.stream
{
   import flash.system.Security;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.game.family_0050.Packet_0050_01;
   import proto.game.family_0050.Packet_0050_02;
   import proto.game.family_0050.Packet_0050_0B;
   import proto.model.PCevent;
   import proto.model.PCeventFrom;
   import proto.model.PEventPlace;
   import proto.model.PPoesd;
   import proto.model.PRaidEvents;
   import proto.model.PRaidFriendEvent;
   
   public class GameStream
   {
      
      private const from:PCeventFrom = new PCeventFrom();
      
      private var packet:Packet_0050_0B;
      
      private var directStream:DirectStream;
      
      private var httpStream:LongGetStream;
      
      private var handler:Function;
      
      private var isDirect:Boolean;
      
      private var directUrl:String;
      
      private var directPort:int;
      
      private var isHttpOld:Boolean;
      
      private var oldPacket:Packet_0050_01;
      
      public function GameStream()
      {
         super();
      }
      
      public function init(param1:String, param2:Object) : void
      {
         var _loc5_:int = 0;
         this.isDirect = param2.poesd_direct_on == "true";
         this.isHttpOld = param2.poesd_simple_on != "true";
         this.directPort = int(param2.poesd_direct_port);
         var _loc3_:int = int(param2.poesd_policy_port);
         var _loc4_:String = param2.sid;
         if(this.isDirect)
         {
            _loc5_ = Preloader.dynamic_url.indexOf("//");
            _loc5_ = _loc5_ > 0 ? int(_loc5_ + 2) : 0;
            if(_loc3_ != 843)
            {
               Security.loadPolicyFile("xmlsocket://" + Preloader.dynamic_url.substr(_loc5_) + ":" + _loc3_);
            }
            this.directUrl = Preloader.dynamic_url.substr(_loc5_) + "/poesd";
         }
         if(this.isDirect || !this.isHttpOld)
         {
            this.packet = new Packet_0050_0B(PPoesd.create(_loc4_,[param1],this.from));
         }
         if(this.isHttpOld)
         {
            this.oldPacket = new Packet_0050_01(PCevent.create(this.from,new PEventPlace()));
         }
      }
      
      public function assign(param1:Number, param2:Function) : GameStream
      {
         this.from.variance = PCeventFrom.TIME;
         this.from.value = param1;
         this.handler = param2;
         return this;
      }
      
      public function run(param1:uint = 0, param2:String = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:PEventPlace = null;
         if(this.isDirect || !this.isHttpOld)
         {
            _loc3_ = this.packet.value.objects;
            _loc3_.length = 1;
            if(param1 == PEventPlace.NOTHING)
            {
               if(param2)
               {
                  _loc3_.push(param2,"chat_" + param2);
               }
            }
            else if(param1 == PEventPlace.MY_CAPITAL)
            {
               _loc3_.push(param2,"capital_" + param2);
            }
            else if(param1 == PEventPlace.ENEMY_CAPITAL || param1 == PEventPlace.OTHER_CAPITAL)
            {
               _loc3_.push("capital_" + param2);
            }
            else if(param1 == PEventPlace.TERRITORY)
            {
               _loc3_.push(param2);
            }
         }
         else
         {
            _loc4_ = this.oldPacket.value.event_place;
            _loc4_.variance = param1;
            _loc4_.value = param2;
         }
         if(this.isDirect)
         {
            this.runDirect();
         }
         else
         {
            this.runHttp();
         }
      }
      
      private function runHttp() : void
      {
         if(this.httpStream)
         {
            this.httpStream.clear();
         }
         this.httpStream = new LongGetStream(this.isHttpOld ? Facade.protoProxy.url.replace("/proto?","/raid?") : Preloader.dynamic_url + "/poesd",this.onHttp);
         this.onHttp(null);
      }
      
      private function onHttp(param1:BinaryBuffer) : void
      {
         var _loc3_:PRaidEvents = null;
         var _loc2_:Number = 0;
         if(Boolean(param1) && this.handler != null)
         {
            if(param1.family != 80 || param1.subfamily != 2)
            {
               return;
            }
            _loc3_ = new Packet_0050_02(param1).value;
            this.from.variance = PCeventFrom.O_ID;
            this.from.value = _loc3_.re_ev_id;
            if(_loc3_.re_evs.length > 0)
            {
               this.applyEvents(_loc3_.re_evs);
            }
            else if(_loc3_.re_ev_id <= 0)
            {
               _loc2_ = 4;
            }
         }
         if(this.handler != null)
         {
            this.httpStream.request(this.isHttpOld ? this.oldPacket : this.packet,_loc2_);
         }
      }
      
      private function applyEvents(param1:Array) : void
      {
         var _loc2_:* = int(param1.length - 1);
         while(_loc2_ >= 0)
         {
            if((param1[_loc2_] as PRaidFriendEvent).rf_friend_id == Preloader.uid)
            {
               param1.splice(_loc2_,1);
            }
            _loc2_--;
         }
         if(param1.length > 0)
         {
            this.handler(param1);
         }
      }
      
      private function runDirect() : void
      {
         if(this.directStream)
         {
            this.directStream.clear();
         }
         this.directStream = new DirectStream(this.packet,this.onDirect,this.onDirectError);
         try
         {
            this.directStream.connect(this.directUrl,this.directPort);
         }
         catch(error:Error)
         {
            onDirectError(error.toString());
         }
      }
      
      private function onDirect(param1:BinaryBuffer) : void
      {
         var _loc2_:PRaidEvents = null;
         if(this.handler != null && param1.family == 80 && param1.subfamily == 2)
         {
            _loc2_ = new Packet_0050_02(param1).value;
            this.from.variance = PCeventFrom.O_ID;
            this.from.value = _loc2_.re_ev_id;
            this.applyEvents(_loc2_.re_evs);
         }
      }
      
      private function onDirectError(param1:String) : void
      {
         this.directStream = null;
         this.isDirect = false;
         this.runHttp();
      }
      
      public function clear() : void
      {
         if(this.directStream)
         {
            this.directStream.clear();
            this.directStream = null;
         }
         if(this.httpStream)
         {
            this.httpStream.clear();
            this.httpStream = null;
         }
         this.handler = null;
      }
   }
}

