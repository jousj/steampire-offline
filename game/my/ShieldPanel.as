package game.my
{
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VText;
   
   public class ShieldPanel extends VComponent
   {
      
      public var bt:VButton = new CircleButton(SkinManager.getEmbed("ArmorIcon"),CircleButton.GOLD);
      
      private var text:VText = UIFactory.createYellowText("slon");
      
      public function ShieldPanel()
      {
         super();
         setSize(75,75);
         this.bt.icon.layoutW = 55;
         add(this.bt,{
            "hCenter":0,
            "vCenter":0,
            "w":75,
            "h":75
         });
         add(this.text,{
            "hCenter":0,
            "vCenter":30
         });
         this.text.mouseChildren = this.text.mouseChildren = false;
         this.bt.hint = Lang.getString("shield_help");
      }
      
      public function setCustom(param1:String) : void
      {
         this.text.value = param1;
      }
      
      public function addBuyBt(param1:Function, param2:String) : void
      {
         this.bt.addClickListener(param1);
      }
   }
}

