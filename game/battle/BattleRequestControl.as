package game.battle
{
   import engine.signal.Signal;
   import logic.CoreLogic;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.game.family_0010.POkUserAction;
   import proto.game.family_0010.Packet_0010_02;
   import proto.game.family_0050.Packet_0050_04;
   
   public class BattleRequestControl
   {
      
      private const signal:Signal;
      
      private const waitList:Vector.<IClientPacket> = new Vector.<IClientPacket>();
      
      public function BattleRequestControl()
      {
         this.signal = new Signal(this.onSignal);
         super();
      }
      
      public function setSimulationPause(param1:Boolean) : void
      {
         if(CoreLogic.pause != param1)
         {
            CoreLogic.pause = param1;
            Facade.battleMediator.visitorPanel.setClockVisible(param1);
         }
      }
      
      private function onSignal() : void
      {
         if(this.signal.data == 1)
         {
            this.request(false);
         }
         else
         {
            this.setSimulationPause(true);
         }
      }
      
      public function add(param1:IClientPacket) : void
      {
         this.waitList.push(param1);
         if(this.waitList.length == 1)
         {
            this.request();
         }
      }
      
      private function next() : void
      {
         this.waitList.shift();
         if(this.waitList.length > 0)
         {
            this.request();
         }
      }
      
      private function request(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.signal.data = 0;
            this.signal.delayCall(1.5);
         }
         Facade.protoProxy.request(this.waitList[0],this.resultRequest,0,0,null,"battle_request");
      }
      
      private function resultRequest(param1:BinaryBuffer) : void
      {
         if(this.waitList.length == 0)
         {
            return;
         }
         this.signal.stop();
         if(param1.family == 16 && param1.subfamily == 2)
         {
            this.resultSingleRequest(param1);
         }
         else
         {
            this.setSimulationPause(false);
            if(!(param1.family == 80 && param1.subfamily == 4))
            {
               throw new Error("battle result not supported " + param1.family.toString(16) + "x" + param1.subfamily.toString(16));
            }
            Facade.battleMediator.addMyCommand(new Packet_0050_04(param1).value,this.waitList.length <= 1);
            this.next();
         }
      }
      
      private function resultSingleRequest(param1:BinaryBuffer) : void
      {
         var _loc2_:Packet_0010_02 = new Packet_0010_02(param1);
         var _loc3_:Boolean = _loc2_.variance == Packet_0010_02.ERROR;
         this.setSimulationPause(_loc3_);
         if(_loc3_)
         {
            this.signal.data = 1;
            this.signal.delayCall(1.5);
         }
         else
         {
            if(_loc2_.variance == Packet_0010_02.OK)
            {
               CoreLogic.calcDiff((_loc2_.value as POkUserAction).server_time,Facade.protoProxy.requestTime);
            }
            this.next();
         }
      }
      
      public function clear() : void
      {
         this.signal.stop();
         this.waitList.length = 0;
      }
   }
}

