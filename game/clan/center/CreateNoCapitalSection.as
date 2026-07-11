package game.clan.center
{
   import engine.display.AnimDisplay;
   import engine.units.Build;
   import flash.filters.GlowFilter;
   import logic.UnitFactory;
   import model.CommonEvent;
   import proto.model.PCost;
   import proto.model.PPermission;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class CreateNoCapitalSection extends VComponent
   {
      
      public var build:Build;
      
      public function CreateNoCapitalSection(param1:uint, param2:Boolean)
      {
         var _loc3_:AnimDisplay = null;
         var _loc5_:RectButton = null;
         var _loc6_:VButton = null;
         super();
         layoutH = 100;
         add(UIFactory.createYellowText(Lang.getString("capital_buy"),VText.CONTAIN,15),{
            "left":20,
            "right":2
         });
         add(ClanCenterFactory.createFill(),{
            "wP":100,
            "top":20,
            "bottom":0
         });
         add(SkinManager.getEmbed("capital_bg",VSkin.STRETCH),{
            "top":20,
            "h":80,
            "wP":100
         });
         this.build = UnitFactory.newBuild(Facade.manualProxy.getBuildShop("bl_town_hall",1));
         this.build.isUseAnim = false;
         this.build.updateLevel = 2;
         this.build.configViewRect(false);
         _loc3_ = this.build.display;
         _loc3_.scaleX = _loc3_.scaleY = 0.34;
         this.build.stand();
         _loc3_.add(_loc3_.getClip("tile"),AnimDisplay.INSIDE,0);
         addChild(_loc3_).x = 61;
         _loc3_.y = 91;
         var _loc4_:ResourcePanel = new ResourcePanel(PCost.GOLD,ResourcePanel.BG | ResourcePanel.PROGRESS | ResourcePanel.COMPARE | ResourcePanel.CLAN,UIFactory.INDICATOR_YELLOW,36,33,16);
         _loc4_.setDataEx(param1,Facade.references.create_capital_price.value);
         add(_loc4_,{
            "left":(param2 ? 120 : 142),
            "bottom":20,
            "w":145,
            "h":36
         });
         Facade.addListenerForComponent(CommonEvent.CLAN_RESOURCE,_loc4_.onTrack,this);
         if(param2)
         {
            _loc5_ = new RectButton(Lang.getString("to_treasure"),RectButton.h42,RectButton.ORANGE);
            _loc5_.addVarianceListener(this,ClanCenterFactory.TREASURY);
            add(_loc5_,{
               "right":8,
               "vCenter":10,
               "w":125
            });
            if(Facade.userProxy.checkClanRolePermission(PPermission.TREAS_REPORTS))
            {
               _loc6_ = VButton.create(SkinManager.getEmbed("BHornIcon"),{
                  "h":42,
                  "w":42,
                  "vCenter":0,
                  "hCenter":0
               });
               _loc6_.hint = Lang.getString("require_donate");
               _loc6_.addVarianceListener(this,ClanCenterFactory.DONATE_ALERT);
               add(_loc6_,{
                  "vCenter":8,
                  "right":145
               });
               _loc6_.skin.filters = [new GlowFilter(Style.grayGlowRGB,1,4,4,4)];
            }
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.build.dispose();
      }
   }
}

