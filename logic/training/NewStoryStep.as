package logic.training
{
   import game.quest.NewStoryDialog;
   import ui.vbase.VEvent;
   
   public class NewStoryStep extends AbstractTrainStep
   {
      
      public var storyDialog:NewStoryDialog;
      
      private var isUpperLayer:Boolean;
      
      private var isMultipleSay:Boolean;
      
      public function NewStoryStep(param1:String, param2:String, param3:Boolean = true, param4:String = null, param5:String = null)
      {
         super();
         var _loc6_:* = int(Facade.mainPanel.numChildren - 1);
         while(_loc6_ >= 0)
         {
            this.storyDialog = Facade.mainPanel.getChildAt(_loc6_) as NewStoryDialog;
            if(this.storyDialog)
            {
               break;
            }
            _loc6_--;
         }
         if(!this.storyDialog)
         {
            this.storyDialog = new NewStoryDialog();
            this.storyDialog.addStretch(Facade.mainPanel.createDialogBg(),0);
         }
         this.storyDialog.say(param1,param2,param3,param5,param4);
         this.storyDialog.addListener(VEvent.CLOSE_DIALOG,this.onClose);
      }
      
      public function useMultipleSay() : NewStoryStep
      {
         this.isMultipleSay = true;
         return this;
      }
      
      public function useUpperLayer() : NewStoryStep
      {
         this.isUpperLayer = true;
         return this;
      }
      
      override public function run() : void
      {
         if(!this.storyDialog.parent)
         {
            Facade.mainPanel.layerPanel.visible = false;
            if(this.isUpperLayer)
            {
               Facade.mainPanel.add(this.storyDialog);
            }
            else
            {
               Facade.mainPanel.addInterLayer(this.storyDialog);
            }
         }
      }
      
      private function onClose(param1:VEvent) : void
      {
         if(!this.isMultipleSay)
         {
            this.storyDialog.removeFromParent();
         }
         else
         {
            this.storyDialog.removeListener(VEvent.CLOSE_DIALOG,this.onClose);
            this.storyDialog = null;
         }
         end();
      }
      
      override public function dispose() : void
      {
         if(this.storyDialog)
         {
            this.storyDialog.removeFromParent();
            Facade.mainPanel.layerPanel.visible = true;
         }
      }
   }
}

