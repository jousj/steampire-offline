package logic.training
{
   import model.CommonEvent;
   
   public class DamageStep extends AbstractTrainStep
   {
      
      private var kind:String;
      
      private var id:uint;
      
      private var isListener:Boolean;
      
      public function DamageStep(param1:String, param2:uint = 0)
      {
         super();
         this.kind = param1;
         this.id = param2;
      }
      
      override public function run() : void
      {
         this.setListener(true);
      }
      
      private function setListener(param1:Boolean) : void
      {
         if(param1 != this.isListener)
         {
            this.isListener = param1;
            if(param1)
            {
               Facade.addListener(CommonEvent.DAMAGE,this.onDamage);
            }
            else
            {
               Facade.removeListener(CommonEvent.DAMAGE,this.onDamage);
            }
         }
      }
      
      private function onDamage(param1:CommonEvent) : void
      {
         if(param1.data == this.kind || param1.variance == this.id)
         {
            this.setListener(false);
            end();
         }
      }
      
      override public function dispose() : void
      {
         this.setListener(false);
      }
   }
}

