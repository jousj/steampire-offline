package game.history
{
   import proto.model.PNewsInfo;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import ui.vbase.VRenderer;
   import ui.vbase.VScrollLabel;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class NewsRenderer extends VRenderer
   {
      
      private const label:VScrollLabel = new VScrollLabel(UIFactory.createScrollBar(20),null,VScrollLabel.USE_BAR_VISIBLE | VLabel.LEADING_BOX,20);
      
      private const dateText:VText = new VText(null,VText.CONTAIN,Style.darkKhakiRGB);
      
      private const skin:VSkin = new VSkin();
      
      private var titleComponent:VComponent;
      
      public function NewsRenderer()
      {
         super();
         setSize(740,400);
         add(SkinManager.getEmbed("WhBlockBg",VSkin.STRETCH),{
            "wP":100,
            "top":44,
            "bottom":0
         });
         add(SkinManager.getExternal("news_header",SkinManager.PNG),{"hCenter":0});
         add(this.skin,{"top":-16});
         add(this.label,{
            "left":16,
            "top":105,
            "bottom":54,
            "right":48
         });
         add(this.label.getScrollBar(),{
            "right":20,
            "top":98,
            "bottom":54
         });
         add(this.dateText,{
            "right":24,
            "bottom":24,
            "maxW":600
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PNewsInfo = param1 as PNewsInfo;
         if(this.titleComponent)
         {
            remove(this.titleComponent);
         }
         SkinManager.applyExternal(this.skin,_loc2_.news_banner ? _loc2_.news_banner : "news_default",null,SkinManager.PNG);
         var _loc3_:String = Lang.getPatternString("news_date","__DATE__",StringHelper.getDateDesc(_loc2_.news_date,true,false));
         var _loc4_:Boolean = Lang.lexicon.hasOwnProperty(_loc2_.news_kind + "_title");
         this.dateText.value = _loc4_ ? _loc3_ : null;
         this.titleComponent = UIFactory.createDecorText(_loc4_ ? Lang.getString(_loc2_.news_kind + "_title") : _loc3_,true,32,540);
         add(this.titleComponent,{
            "hCenter":0,
            "top":28
         });
         this.label.text = "<div fontSize=\"16\"" + Style.metalColor + ">" + Lang.getString(_loc2_.news_kind).replace("<list>","<list paragraphSpaceAfter=\"10\" listStyleType=\"disc\"><listMarkerFormat><ListMarkerFormat fontSize=\"20\" paragraphEndIndent=\"6\"" + Style.darkKhakiColor + "/></listMarkerFormat>") + "</div>";
      }
   }
}

