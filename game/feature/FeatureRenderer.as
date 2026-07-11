package game.feature
{
   import engine.signal.Signal;
   import flash.events.MouseEvent;
   import model.ui.VOFeatureItem;
   import ui.Style;
   import ui.common.RectButton;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VLabel;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class FeatureRenderer extends VRenderer
   {
      
      public const box:VBox = new VBox();
      
      private const skin:VSkin = new VSkin();
      
      private const titleText:VText = new VText(null,VText.CONTAIN,Style.metalRGB).assignW(-100);
      
      private const valueLb:VLabel = new VLabel(null,VText.CONTAIN);
      
      private const arrowSkin:VSkin = SkinManager.getEmbed("ArrowLearn",VSkin.ROTATE_90 | VSkin.PLAY_MOVIE_CLIP);
      
      public var item:VOFeatureItem;
      
      public var kind:String;
      
      public var updateBt:VButton;
      
      public function FeatureRenderer()
      {
         super();
         layoutH = 30;
         add(SkinManager.getEmbed("FeatureItemBg",VSkin.STRETCH),{
            "left":20,
            "right":0
         });
         addChild(SkinManager.getEmbed("FeatureIconBg"));
         add(this.skin,{
            "w":30,
            "h":30,
            "bottom":2,
            "left":1
         });
         this.box.add(this.titleText);
         this.valueLb.maxW = 200;
         this.valueLb.maxH = 36;
         Style.applyGlowFilter(this.valueLb,0,3);
         this.box.add(this.valueLb);
         add(this.box,{
            "left":38,
            "vCenter":1,
            "right":10
         });
      }
      
      public static function addUpdateStyle(param1:String) : String
      {
         return "<span color=\"#8CBC28\" fontSize=\"20\">" + param1 + "</span>";
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         this.item = param1 as VOFeatureItem;
         if(this.kind != this.item.kind)
         {
            this.kind = this.item.kind;
            SkinManager.applyEmbed(this.skin,this.item.skinName);
            this.titleText.value = Lang.getString(this.item.kind);
         }
         if(this.item.isOnlySuffix)
         {
            _loc2_ = "";
         }
         else
         {
            _loc2_ = this.item.isTime ? this.getTimeString(this.item.cur) : this.item.cur.toString();
            _loc2_ += this.item.preSuffix ? this.item.preSuffix : "";
            if(this.item.isCompare)
            {
               _loc2_ += "/";
               if(this.item.isTime)
               {
                  _loc2_ += this.getTimeString(this.item.max);
               }
               else
               {
                  _loc2_ += this.item.max.toString();
               }
            }
            else if(this.item.max > 0 && this.item.cur != this.item.max)
            {
               _loc3_ = Math.abs(this.item.max - this.item.cur);
               _loc2_ += addUpdateStyle((this.item.max > this.item.cur ? "+" : "-") + (this.item.isTime ? this.getTimeString(_loc3_) : _loc3_));
            }
         }
         if(this.item.suffix)
         {
            _loc2_ += this.item.suffix;
         }
         this.valueLb.text = this.addValueStyle(_loc2_);
         if(this.item.cur < this.item.max && this.item.trackEndTime > 0)
         {
            Signal.createRef(this,this.onTrack,Signal.ADD_PERIOD,this.item.trackPeriod).run(this.item.trackDuration,this.item.trackEndTime,true);
         }
         else
         {
            Signal.stopRef(this);
         }
         if(this.item.updateData)
         {
            if(!this.updateBt)
            {
               this.createUpdateBt();
            }
            (this.updateBt.icon as PricePanel).assignCost(this.item.updateData.shu_price);
            if(this.item.updateData.shu_upgrade_requirement.req_building_level > 0)
            {
               (this.updateBt.icon as PricePanel).setCheckState(false,true);
            }
            this.updateBt.data = this.item;
            if(this.item.selected)
            {
               this.updateBt.add(this.arrowSkin,{
                  "vCenter":17,
                  "right":-10
               });
               this.updateBt.addClickListener(this.removeArrowSkin);
            }
         }
         else if(this.updateBt)
         {
            this.box.remove(this.updateBt);
            this.updateBt = null;
         }
      }
      
      private function getTimeString(param1:uint) : String
      {
         if(param1 < 60000)
         {
            return param1 / 1000 + Lang.getTimeShortString(Lang.SECOND);
         }
         return StringHelper.getTimeDesc(param1 / 1000);
      }
      
      private function createUpdateBt() : void
      {
         var _loc1_:PricePanel = null;
         _loc1_ = new PricePanel(21,18,PricePanel.GLOW_FILTER);
         _loc1_.useCheck = true;
         _loc1_.left = _loc1_.right = 10;
         this.updateBt = new RectButton(_loc1_);
         this.updateBt.layoutH = 33;
         this.updateBt.minW = 92;
         _loc1_.vCenter = -1;
         this.updateBt.hint = Lang.getString("updateBt");
         this.updateBt.addVarianceListener(this,0);
         this.box.add(this.updateBt);
      }
      
      private function removeArrowSkin(param1:MouseEvent) : void
      {
         this.updateBt.remove(this.arrowSkin);
         this.updateBt.removeListener(MouseEvent.CLICK,this.removeArrowSkin);
         this.item.selected = false;
      }
      
      private function addValueStyle(param1:String) : String
      {
         return "<div fontSize=\"" + (param1.length > 18 ? "16" : "18") + "\" textAlign=\"right\"" + Style.yellowColor + " lineHeight=\"100%\">" + param1 + "</div>";
      }
      
      private function onTrack(param1:Signal) : void
      {
         this.item.cur = this.item.max * param1.passedRate;
         this.valueLb.text = this.addValueStyle(this.item.cur + "/" + this.item.max);
      }
      
      override public function dispose() : void
      {
         Signal.stopRef(this);
         super.dispose();
      }
   }
}

