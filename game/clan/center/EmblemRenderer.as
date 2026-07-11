package game.clan.center
{
   import proto.model.PShopClanIcon;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   
   public class EmblemRenderer extends VRenderer
   {
      
      public const bt:VButton = new VButton();
      
      private var buySkin:VSkin;
      
      private var buyText:VComponent;
      
      public function EmblemRenderer()
      {
         super();
         setSize(165,125);
         this.bt.setIcon(new VSkin(VSkin.CONTAIN),{
            "w":108,
            "h":108,
            "hCenter":1,
            "vCenter":2
         });
         this.bt.addVarianceListener(this,0);
         addStretch(this.bt);
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc2_:Boolean = false;
         if(param1 is PShopClanIcon)
         {
            _loc3_ = (param1 as PShopClanIcon).sci_kind;
            if(!(param1 as PShopClanIcon).sci_price)
            {
               _loc2_ = true;
            }
            if(!(this.bt.skin is VSkin))
            {
               this.bt.setSkin(SkinManager.getEmbed("ShopBg4",VSkin.STRETCH),{
                  "wP":100,
                  "hP":100
               });
               this.buyText = UIFactory.createDecorText(Lang.getString("premium"),true,16,150,false);
               this.bt.add(this.buyText,{
                  "hCenter":0,
                  "bottom":18
               });
            }
         }
         else
         {
            if(param1 is String)
            {
               _loc3_ = String(param1);
            }
            if(!(this.bt.skin is VFill))
            {
               this.bt.setSkin(new VFill(14932428,1,8),{
                  "wP":100,
                  "hP":100
               });
               if(this.buyText)
               {
                  this.bt.remove(this.buyText);
                  this.buyText = null;
               }
            }
         }
         if(_loc2_ != Boolean(this.buySkin))
         {
            if(_loc2_)
            {
               this.buySkin = SkinManager.getEmbed("CollectIcon");
               add(this.buySkin,{
                  "right":7,
                  "top":7,
                  "w":35
               });
            }
            else
            {
               remove(this.buySkin);
               this.buySkin = null;
            }
         }
         _loc4_ = Boolean(_loc3_);
         this.bt.mouseEnabled = _loc4_;
         if(_loc4_)
         {
            SkinManager.applyExternal(this.bt.icon as VSkin,UIFactory.EMBLEM_PACK,_loc3_);
            this.bt.data = param1;
         }
         else
         {
            (this.bt.icon as VSkin).resetContent();
            this.bt.data = null;
         }
      }
   }
}

