package game.missions
{
   import flash.events.MouseEvent;
   import proto.model.PMissionWin;
   import ui.Style;
   import ui.game.UnitPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VEvent;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class MapTargetRenderer extends VRenderer
   {
      
      private const unitPanel:UnitPanel = new UnitPanel(UnitPanel.ORANGE_BG,UnitPanel.winTarget60);
      
      private var cacheKind:String;
      
      private var cacheCount:uint = 10000;
      
      private var text:VText;
      
      private var skin:VSkin;
      
      private var item:PMissionWin;
      
      public function MapTargetRenderer()
      {
         super();
         mouseChildren = false;
         setSize(60,60);
         addChild(this.unitPanel);
         addListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         dispatcher.dispatchEvent(new VEvent(VEvent.SELECT,this.item));
      }
      
      override public function setData(param1:Object) : void
      {
         this.item = param1 as PMissionWin;
         if(this.item.mw_kind != this.cacheKind)
         {
            this.cacheKind = this.item.mw_kind;
            this.unitPanel.show(this.cacheKind,this.item.mw_level);
            hint = Lang.getString(this.cacheKind);
         }
         if(this.item.mw_count != this.cacheCount)
         {
            this.cacheCount = this.item.mw_count;
            if(this.cacheCount > 0)
            {
               if(!this.text)
               {
                  if(this.skin)
                  {
                     remove(this.skin);
                     this.skin = null;
                  }
                  this.text = new VText();
                  Style.applyDefaultFormat(this.text,18);
                  add(this.text,{
                     "right":0,
                     "bottom":0
                  });
               }
               this.text.value = this.item.mw_count.toString();
            }
            else
            {
               if(this.text)
               {
                  remove(this.text);
                  this.text = null;
               }
               this.skin = SkinManager.getEmbed("CollectIcon");
               add(this.skin,{
                  "right":0,
                  "bottom":0,
                  "w":38,
                  "h":33
               });
            }
         }
      }
   }
}

