package game.common
{
   import flash.utils.getQualifiedClassName;
   import model.ManualProxy;
   import model.UserProxy;
   import ui.common.BaseDialog;
   
   public class DialogMediator
   {
      
      public static const settingHash:Object = {};
      
      protected const up:UserProxy = Facade.userProxy;
      
      protected const mp:ManualProxy = Facade.manualProxy;
      
      public function DialogMediator()
      {
         super();
      }
      
      public function getDialogSetting() : Object
      {
         return settingHash[getQualifiedClassName(this)];
      }
      
      public function setDialogSetting(param1:Object) : void
      {
         settingHash[getQualifiedClassName(this)] = param1;
      }
      
      public function onAdd() : BaseDialog
      {
         return null;
      }
      
      public function onRemove() : void
      {
      }
   }
}

