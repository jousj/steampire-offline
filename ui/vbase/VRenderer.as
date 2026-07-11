package ui.vbase
{
   import flash.events.MouseEvent;
   
   public class VRenderer extends VComponent
   {
      
      public var dataIndex:uint;
      
      public function VRenderer()
      {
         super();
      }
      
      public function setData(param1:Object) : void
      {
      }
      
      public function setSelected(param1:Boolean) : void
      {
      }
      
      public function addSelectTriger(param1:VComponent) : void
      {
         param1.addListener(MouseEvent.CLICK,this.onSelectTriger);
      }
      
      private function onSelectTriger(param1:MouseEvent) : void
      {
         dispatcher.dispatchEvent(new VEvent(VEvent.SELECT,param1.currentTarget is VButton ? (param1.currentTarget as VButton).data : null,this.dataIndex));
      }
   }
}

