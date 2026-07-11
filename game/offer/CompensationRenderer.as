package game.offer
{
   import proto.model.PCost;
   import proto.tuples.str_i;
   import ui.Style;
   import ui.vbase.SkinManager;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   
   public class CompensationRenderer extends VRenderer
   {
      
      private const bgSkin:VSkin = SkinManager.getEmbed("UnitDropBg");
      
      private var countText:VText;
      
      private var icon:VSkin;
      
      private var fgSkin:VSkin;
      
      public function CompensationRenderer()
      {
         super();
         setSize(80,80);
         mouseChildren = false;
         addStretch(this.bgSkin);
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc2_:Boolean = Boolean(param1);
         if(_loc2_ && !this.icon)
         {
            this.countText = new VText(null,VText.CONTAIN,16777215);
            Style.applyGlowFilter(this.countText,0,8);
            this.icon = new VSkin(VSkin.CONTAIN);
            this.fgSkin = SkinManager.getEmbed("UnitDropFg");
            add(this.icon,{
               "h":60,
               "w":60,
               "hCenter":0,
               "vCenter":0
            });
            add(this.fgSkin,{
               "h":76,
               "w":76,
               "hCenter":0,
               "vCenter":0
            });
            add(this.countText,{
               "right":6,
               "bottom":6,
               "maxW":70
            });
         }
         if(this.icon)
         {
            this.icon.visible = this.countText.visible = this.fgSkin.visible = _loc2_;
         }
         if(_loc2_ != (alpha == 1))
         {
            if(_loc2_)
            {
               alpha = 1;
               this.bgSkin.filters = null;
            }
            else
            {
               alpha = 0.5;
               this.bgSkin.filters = VSkin.GREY_FILTER;
            }
         }
         if(_loc2_)
         {
            if(param1 is str_i)
            {
               _loc3_ = (param1 as str_i).field_0;
               SkinManager.applyExternal(this.icon,_loc3_ + "1_q",null,SkinManager.PNG | SkinManager.LOAD_CLIP);
               this.countText.value = (param1 as str_i).field_1.toString();
            }
            else
            {
               _loc4_ = (param1 as PCost).variance;
               _loc3_ = CostHelper.getKind(_loc4_);
               if(_loc4_ == PCost.RED_ORE || _loc4_ == PCost.GREEN_ORE || _loc4_ == PCost.BLUE_ORE)
               {
                  SkinManager.applyExternal(this.icon,"oreOld",_loc3_,SkinManager.LOAD_CLIP);
               }
               else
               {
                  SkinManager.applyEmbed(this.icon,_loc3_);
               }
               this.countText.value = (param1 as PCost).value;
            }
            hint = Lang.getString(_loc3_);
         }
         else
         {
            hint = null;
         }
      }
   }
}

