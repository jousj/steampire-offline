package logic.training
{
   import flash.events.MouseEvent;
   import ui.UIFactory;
   import ui.vbase.VButton;
   import ui.vbase.VSkin;
   
   public class ClickStep extends AbstractTrainStep
   {
      
      private var arrowSkin:VSkin;
      
      private var target:VButton;
      
      public function ClickStep(param1:VButton, param2:Number, param3:Object)
      {
         super();
         this.target = param1;
         this.arrowSkin = UIFactory.createLearnArrow(param2);
         if(param3)
         {
            this.arrowSkin.assignLayout(param3);
         }
         this.arrowSkin.addListener(MouseEvent.CLICK,end,param1);
      }
      
      override public function run() : void
      {
         this.target.add(this.arrowSkin);
      }
      
      override public function dispose() : void
      {
         if(this.arrowSkin)
         {
            this.arrowSkin.removeFromParent();
         }
      }
   }
}

