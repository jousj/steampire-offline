package utils
{
   import flash.events.AsyncErrorEvent;
   import flash.events.Event;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.net.LocalConnection;
   import logic.ErrorLogic;
   
   public class GameLocalConnection extends LocalConnection
   {
      
      public static const instance:GameLocalConnection = new GameLocalConnection();
      
      private var count:uint = 3;
      
      public function GameLocalConnection()
      {
         super();
         addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onError);
         addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         addEventListener(StatusEvent.STATUS,this.onStatus);
      }
      
      private function onError(param1:Event) : void
      {
      }
      
      private function onStatus(param1:StatusEvent) : void
      {
         if(this.count > 0)
         {
            --this.count;
            this.resume();
         }
      }
      
      public function resume() : void
      {
         var id:String = null;
         id = "Redspell_steampunk";
         try
         {
            connect(id);
         }
         catch(error:Error)
         {
            send(id,"sleep");
         }
      }
      
      public function sleep() : void
      {
         this.count = 3;
         try
         {
            close();
         }
         catch(error:Error)
         {
         }
         ErrorLogic.show(true);
      }
   }
}

