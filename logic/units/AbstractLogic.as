package logic.units
{
   import engine.units.Unit;
   import ui.vbase.VComponent;
   import utils.StringHelper;
   
   public class AbstractLogic extends Facade
   {
      
      public function AbstractLogic()
      {
         super();
      }
      
      public function getMenu(param1:Unit, param2:Vector.<VComponent>) : void
      {
      }
      
      public function changeSelect(param1:Unit, param2:Boolean) : void
      {
      }
      
      public function changeOver(param1:Unit, param2:Boolean) : void
      {
         mainMediator.setHint(param1,param2 ? StringHelper.getUnitName(param1.kind,!isBattle ? param1.level : uint(Math.round(param1.level * battleMediator.staminaKoef))) : null);
      }
      
      public function changeMove(param1:Unit, param2:Boolean, param3:Boolean = false) : void
      {
      }
      
      public function onMove(param1:Unit) : void
      {
      }
   }
}

