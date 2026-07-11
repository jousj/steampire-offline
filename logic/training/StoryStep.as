package logic.training
{
   import game.quest.StoryDialog;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   
   public class StoryStep extends AbstractTrainStep
   {
      
      public const panel:VComponent = new VComponent();
      
      private var isLayerHide:Boolean;
      
      public function StoryStep(param1:String, param2:String, param3:int, param4:int, param5:Boolean = false, param6:Boolean = true)
      {
         super();
         if(param5)
         {
            this.panel.addStretch(new VFill(0,0.35));
         }
         if(param6)
         {
            this.panel.add(new VFill(0),{
               "wP":100,
               "h":100
            });
            this.panel.add(new VFill(0),{
               "wP":100,
               "h":100,
               "bottom":0
            });
         }
         var _loc7_:StoryDialog = new StoryDialog(param1,param2,true);
         _loc7_.closeBt.addClickListener(end);
         _loc7_.useCenter(param3,param4);
         this.panel.add(_loc7_);
         this.isLayerHide = param6;
      }
      
      override public function run() : void
      {
         if(this.isLayerHide)
         {
            Facade.mainPanel.layerPanel.visible = false;
         }
         Facade.mainPanel.addInterLayer(this.panel);
      }
      
      override public function dispose() : void
      {
         this.panel.removeFromParent();
         if(this.isLayerHide)
         {
            Facade.mainPanel.layerPanel.visible = true;
         }
      }
   }
}

