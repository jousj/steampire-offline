package ui.game
{
   import engine.signal.Tween;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class ShineClip extends VComponent
   {
      
      private var tween1:Tween;
      
      private var tween2:Tween;
      
      public function ShineClip(param1:String = null)
      {
         super();
         setSize(10,10);
         if(!param1)
         {
            useCenter();
         }
         var _loc2_:VSkin = this.getSkin(param1);
         var _loc3_:Object = {
            "w":2,
            "h":2,
            "hCenter":0,
            "vCenter":0
         };
         add(_loc2_,_loc3_);
         this.tween1 = new Tween(_loc2_,Tween.cyclically);
         this.tween1.play(["rotation",null,360],12,null,0.03);
         _loc2_ = this.getSkin(param1);
         add(_loc2_,_loc3_);
         this.tween2 = new Tween(_loc2_,Tween.cyclically);
         this.tween2.play(["rotation",null,-360],12,null,0.03);
      }
      
      private function getSkin(param1:String) : VSkin
      {
         return param1 ? SkinManager.getExternal(param1,SkinManager.PNG,VSkin.NO_STRETCH) : SkinManager.getPack("BattleResultDialog","ShineClip",VSkin.NO_STRETCH | VSkin.ZERO_CENTER);
      }
      
      public function set pause(param1:Boolean) : void
      {
         if(param1)
         {
            this.tween1.stopWithoutHandler();
            this.tween2.stopWithoutHandler();
         }
         else
         {
            this.tween1.repeat();
            this.tween2.repeat();
         }
      }
      
      override public function dispose() : void
      {
         this.tween1.stopWithoutHandler();
         this.tween2.stopWithoutHandler();
         super.dispose();
      }
   }
}

