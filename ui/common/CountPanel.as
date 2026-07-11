package ui.common
{
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class CountPanel extends VComponent
   {
      
      private const text:VText = new VText(null,VText.CONTAIN_CENTER,6760966,16);
      
      private const bg:VSkin = SkinManager.getEmbed("TipBack",VSkin.STRETCH_BG);
      
      public function CountPanel(param1:int, param2:Boolean = true)
      {
         super();
         mouseEnabled = mouseChildren = false;
         setSize(33,28);
         addStretch(this.bg);
         add(this.text,{
            "left":2,
            "right":4,
            "vCenter":-1
         });
         if(param2)
         {
            this.value = param1;
         }
      }
      
      public function set value(param1:int) : void
      {
         this.text.value = param1.toString();
      }
      
      public function set title(param1:String) : void
      {
         this.text.value = param1;
      }
   }
}

