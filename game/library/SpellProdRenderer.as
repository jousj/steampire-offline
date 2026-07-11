package game.library
{
   import flash.events.MouseEvent;
   import game.barrack.BarrackDialog;
   import proto.model.PRequirement;
   import proto.model.PShopSpell;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class SpellProdRenderer extends VRenderer
   {
      
      private const bgSkin:VSkin = SkinManager.getEmbed("UnitDropBg",VSkin.STRETCH);
      
      private var iconSkin:VSkin;
      
      private var removeBt:CircleButton;
      
      private var cacheState:uint;
      
      private var isClickListener:Boolean;
      
      private var lockLabel:VLabel;
      
      public function SpellProdRenderer()
      {
         super();
         setSize(95,95);
         this.bgSkin.mouseEnabled = true;
         addStretch(this.bgSkin);
      }
      
      private function clear() : void
      {
         var _loc1_:VComponent = null;
         if(this.isClickListener)
         {
            this.isClickListener = false;
            this.bgSkin.removeListener(MouseEvent.CLICK,this.onClick);
         }
         while(numChildren > 1)
         {
            _loc1_ = removeChildAt(1) as VComponent;
            if(_loc1_)
            {
               _loc1_.dispose();
            }
         }
         this.iconSkin = null;
         this.removeBt = null;
         this.lockLabel = null;
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:uint = 0;
         if(param1 is PShopSpell)
         {
            _loc2_ = 1;
         }
         else if(param1 == 0)
         {
            _loc2_ = 2;
         }
         else if(param1 is PRequirement)
         {
            _loc2_ = 3;
         }
         else
         {
            _loc2_ = 4;
         }
         var _loc3_:Boolean = this.cacheState != _loc2_;
         if(_loc3_)
         {
            this.clear();
            this.cacheState = _loc2_;
         }
         var _loc4_:Boolean = false;
         switch(_loc2_)
         {
            case 1:
               this.assignShop(param1 as PShopSpell,_loc3_);
               break;
            case 2:
               if(_loc3_)
               {
                  this.assignEmpty();
               }
               break;
            case 3:
               this.assignLock(param1 as PRequirement,_loc3_);
               _loc4_ = true;
               break;
            default:
               _loc4_ = true;
         }
         if(_loc4_ != (this.bgSkin.alpha != 1))
         {
            if(_loc4_)
            {
               this.bgSkin.filters = VSkin.GREY_FILTER;
               this.bgSkin.alpha = 0.5;
            }
            else
            {
               this.bgSkin.filters = null;
               this.bgSkin.alpha = 1;
            }
         }
      }
      
      private function assignShop(param1:PShopSpell, param2:Boolean) : void
      {
         if(param2)
         {
            this.iconSkin = new VSkin(VSkin.CONTAIN);
            add(this.iconSkin,{
               "hCenter":0,
               "vCenter":0,
               "w":80,
               "h":80
            });
            add(SkinManager.getEmbed("UnitDropFg",VSkin.STRETCH),{
               "left":2,
               "top":2,
               "right":2,
               "bottom":2
            });
            this.removeBt = new CircleButton(null,CircleButton.TEAL);
            this.removeBt.applyText("-1",16,0);
            add(this.removeBt,{
               "right":-6,
               "top":-6,
               "w":30,
               "h":30
            });
            this.removeBt.addVarianceListener(this,BarrackDialog.DEC);
         }
         SkinManager.applyExternal(this.iconSkin,param1.ssp_kind + "1_q",null,SkinManager.PNG | SkinManager.LOAD_CLIP);
         this.removeBt.data = param1;
      }
      
      private function assignEmpty() : void
      {
         add(UIFactory.createYellowText(Lang.getString("spell_empty"),VText.CENTER),{
            "left":4,
            "right":4,
            "vCenter":0,
            "maxH":80
         });
         this.isClickListener = true;
         this.bgSkin.addListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         dispatchVarianceEvent(BarrackDialog.CLEAR);
      }
      
      private function assignLock(param1:PRequirement, param2:Boolean) : void
      {
         if(param2)
         {
            this.lockLabel = new VLabel(null,VLabel.LEADING_BOX);
            add(this.lockLabel,{
               "left":4,
               "right":4,
               "vCenter":0,
               "maxH":80
            });
         }
         this.lockLabel.text = "<p fontSize=\"13\" color=\"#666666\" textAlign=\"center\">" + Lang.getPatternString("required_build","__BUILD__",StringHelper.getUnitName(param1.req_building_kind,param1.req_building_level,14,"")) + "</p>";
      }
   }
}

