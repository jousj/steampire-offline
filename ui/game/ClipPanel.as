package ui.game
{
   import engine.display.AnimClip;
   import engine.display.Animation;
   import ui.vbase.VComponent;
   
   public class ClipPanel extends VComponent
   {
      
      public var clip:AnimClip;
      
      public function ClipPanel(param1:AnimClip = null)
      {
         super();
         setSize(4,4);
         mouseEnabled = mouseChildren = false;
         if(!param1)
         {
            param1 = new AnimClip();
         }
         this.clip = param1;
         addChild(param1);
         param1.setSimulate(true);
      }
      
      override protected function customUpdate() : void
      {
         super.customUpdate();
         this.clip.x = Math.round(w / 2);
         this.clip.y = Math.round(h / 2);
      }
      
      public function play(param1:String, param2:String, param3:Boolean = true) : void
      {
         var _loc4_:Animation = AnimClip.resourceProxy.getAnimation(param1,param2);
         if(_loc4_)
         {
            this.clip.play(_loc4_,param3,_loc4_.getRandomIndex());
         }
         else
         {
            this.clip.clear();
         }
      }
      
      override public function dispose() : void
      {
         this.clip.clear();
         super.dispose();
      }
   }
}

