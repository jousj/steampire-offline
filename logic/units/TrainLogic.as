package logic.units
{
   import engine.units.Unit;
   import ui.vbase.VComponent;
   
   public class TrainLogic extends AbstractLogic
   {
      
      private var baseLogic:AbstractLogic;
      
      public var unit:Unit;
      
      public var changeSelectHandler:Function;
      
      public var changeMoveHandler:Function;
      
      public var getMenuHandler:Function;
      
      public function TrainLogic(param1:Unit)
      {
         super();
         this.unit = param1;
         this.baseLogic = param1.logic;
         param1.logic = this;
      }
      
      override public function getMenu(param1:Unit, param2:Vector.<VComponent>) : void
      {
         this.baseLogic.getMenu(param1,param2);
         if(this.getMenuHandler != null)
         {
            this.getMenuHandler(param2);
         }
      }
      
      override public function changeSelect(param1:Unit, param2:Boolean) : void
      {
         this.baseLogic.changeSelect(param1,param2);
         if(this.changeSelectHandler != null)
         {
            this.changeSelectHandler(param2);
         }
      }
      
      override public function changeOver(param1:Unit, param2:Boolean) : void
      {
         this.baseLogic.changeOver(param1,param2);
      }
      
      override public function changeMove(param1:Unit, param2:Boolean, param3:Boolean = false) : void
      {
         this.baseLogic.changeMove(param1,param2,param3);
         if(this.changeMoveHandler != null)
         {
            this.changeMoveHandler(param2);
         }
      }
      
      override public function onMove(param1:Unit) : void
      {
         this.baseLogic.onMove(param1);
      }
      
      public function dispose() : void
      {
         this.unit.logic = this.baseLogic;
      }
   }
}

