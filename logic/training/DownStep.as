package logic.training
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import ui.UIFactory;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class DownStep extends AbstractTrainStep
   {
      
      private var arrowSkin:VSkin;
      
      private var target:Sprite;
      
      public function DownStep(param1:Sprite, param2:Number, param3:Object = null)
      {
         super();
         this.target = param1;
         this.arrowSkin = UIFactory.createLearnArrow(param2);
         if(param3)
         {
            this.arrowSkin.assignLayout(param3);
         }
         this.arrowSkin.addListener(MouseEvent.MOUSE_DOWN,this.onDown,Facade.stage);
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         end();
      }
      
      override public function run() : void
      {
         if(this.target is VComponent)
         {
            (this.target as VComponent).add(this.arrowSkin);
         }
         else
         {
            this.target.addChild(this.arrowSkin);
            this.arrowSkin.geometryPhase();
         }
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

