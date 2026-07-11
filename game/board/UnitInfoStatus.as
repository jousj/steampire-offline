package game.board
{
   import engine.signal.Tween;
   import engine.units.Unit;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   
   public class UnitInfoStatus extends VSkin
   {
      
      private var unit:Unit;
      
      public function UnitInfoStatus(param1:String)
      {
         super();
         SkinManager.applyEmbed(this,param1);
         Tween.createRef(this,this.onTween,true).play(["alpha",0.2,1],0.6);
      }
      
      public function assign(param1:Unit) : void
      {
         this.unit = param1;
         param1.setStatus(this);
      }
      
      private function onTween(param1:Tween) : void
      {
         if(param1.step < 4)
         {
            param1.revert();
         }
         else if(this.unit)
         {
            this.unit.setStatus(null);
         }
         else
         {
            removeFromParent();
         }
      }
      
      override public function dispose() : void
      {
         Tween.stopRef(this);
         this.unit = null;
         super.dispose();
      }
   }
}

