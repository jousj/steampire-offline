package ui.load
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VProgressBar;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class StartupLoadPanel extends VComponent
   {
      
      public const pb:VProgressBar = new VProgressBar();
      
      public const valueText:VText = UIFactory.createYellowText(null,0,20);
      
      public function StartupLoadPanel(param1:Loader)
      {
         super();
         var _loc2_:VSkin = new VSkin();
         if(param1.content is Bitmap)
         {
            (param1.content as Bitmap).smoothing = true;
         }
         _loc2_.applyContent(param1.content);
         add(_loc2_,{
            "hCenter":0,
            "vCenter":0
         });
         var _loc3_:VSkin = SkinManager.getEmbed(UIFactory.INDICATOR_YELLOW,VSkin.STRETCH);
         _loc3_.assignLayout({
            "left":7,
            "right":7,
            "top":6,
            "bottom":9
         });
         this.pb.init(_loc3_,null,true);
         this.pb.addStretch(SkinManager.getEmbed("TrackPb2",VSkin.STRETCH));
         add(this.pb,{
            "hCenter":0,
            "vCenter":290,
            "h":40
         });
         add(SkinManager.getExternal("GameTitle_" + (Lang.locale == Lang.RU ? Lang.RU : Lang.EN),SkinManager.NO_CACHE),{
            "vCenter":100,
            "hCenter":0
         });
         add(this.valueText,{
            "hCenter":0,
            "vCenter":290
         });
      }
      
      public function setProgress(param1:Number, param2:String = "") : void
      {
         var _loc3_:Number = Math.ceil(this.pb.value * 100);
         this.pb.value = param1;
         var _loc4_:Number = Math.ceil(param1 * 100);
         if(_loc3_ != _loc4_)
         {
            this.valueText.value = param2 + _loc4_ + "%";
         }
      }
      
      override protected function customUpdate() : void
      {
         graphics.clear();
         graphics.beginFill(4408069);
         graphics.drawRect(0,0,w,h);
         super.customUpdate();
      }
   }
}

