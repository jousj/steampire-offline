package game.clan.center
{
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VText;
   
   public class CupPanel extends VComponent
   {
      
      private var box:VBox = new VBox(null,0);
      
      private var lst:Array = [new VText(null,VText.MIDDLE | VText.CONTAIN,Style.metalRGB,14),new VText(null,VText.MIDDLE | VText.CONTAIN,Style.metalRGB,14),new VText(null,VText.MIDDLE | VText.CONTAIN,Style.metalRGB,14)];
      
      public function CupPanel()
      {
         super();
         add(this.box,{
            "hCenter":0,
            "vCenter":0
         });
         this.box.add(SkinManager.getEmbed("CupIconGold"),{
            "hCenter":0,
            "vCenter":0,
            "w":27,
            "h":20
         });
         this.box.add(this.lst[0],{
            "hCenter":0,
            "vCenter":0,
            "w":15
         });
         this.box.add(SkinManager.getEmbed("CupIconSilver"),{
            "hCenter":0,
            "vCenter":0,
            "w":27,
            "h":20
         });
         this.box.add(this.lst[1],{
            "hCenter":0,
            "vCenter":0,
            "w":15
         });
         this.box.add(SkinManager.getEmbed("CupIconBronze"),{
            "hCenter":0,
            "vCenter":0,
            "w":27,
            "h":20
         });
         this.box.add(this.lst[2],{
            "hCenter":0,
            "vCenter":0,
            "w":15
         });
      }
      
      public function setData(param1:Array) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            (this.lst[_loc2_] as VText).value = param1[_loc2_];
            _loc2_++;
         }
      }
   }
}

