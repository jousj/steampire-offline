package game.clan.center
{
   import engine.signal.Signal;
   import flash.filters.GlowFilter;
   import game.shop.ShopUnitPanel;
   import logic.CoreLogic;
   import proto.model.PPermission;
   import proto.model.clan.PClan;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class CreateCapitalSection extends VComponent
   {
      
      public var workerSignal:Signal;
      
      public function CreateCapitalSection(param1:PClan, param2:Boolean)
      {
         var _loc6_:VText = null;
         var _loc7_:VButton = null;
         var _loc8_:VButton = null;
         super();
         layoutH = 100;
         add(UIFactory.createYellowText(Lang.getString("news_capital_title"),VText.CONTAIN,15),{
            "left":20,
            "right":2
         });
         add(SkinManager.getEmbed("capital_bg",VSkin.STRETCH),{
            "top":20,
            "h":80,
            "wP":100
         });
         var _loc3_:ShopUnitPanel = new ShopUnitPanel();
         _loc3_.show("bl_town_hall",param1.townhall_level == 0 ? 1 : param1.townhall_level);
         add(_loc3_,{
            "left":6,
            "top":21,
            "w":96,
            "h":80
         });
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "left":91,
            "top":45,
            "w":80,
            "h":28
         });
         add(SkinManager.getEmbed("CapitalFlagIcon"),{
            "left":96,
            "top":36
         });
         add(UIFactory.createYellowText(param1.base.level.toString(),VText.CONTAIN_CENTER,18,true),{
            "left":121,
            "top":51,
            "w":40
         });
         if(param2)
         {
            add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
               "left":185,
               "top":45,
               "w":94
            });
            add(SkinManager.getEmbed("WorkerIcon"),{
               "left":176,
               "top":40,
               "h":36
            });
            add(UIFactory.createYellowText(param1.workers_count - param1.workers_busy + "/" + param1.workers_count,VText.CONTAIN_CENTER,18,true),{
               "left":214,
               "top":51,
               "w":58
            });
            if(!isNaN(param1.finish_build_time) && param1.finish_build_time > CoreLogic.serverTime)
            {
               _loc6_ = UIFactory.createYellowText(null,VText.CONTAIN_CENTER,12);
               _loc6_.alpha = 0.6;
               add(_loc6_,{
                  "left":196,
                  "top":76,
                  "w":94
               });
               if(!this.workerSignal)
               {
                  this.workerSignal = new Signal(this.onWorkerSignal,Signal.ADD_TIMER);
               }
               this.workerSignal.data = _loc6_;
               this.workerSignal.run(0,param1.finish_build_time,true);
            }
         }
         var _loc4_:Boolean = Boolean(Facade.userProxy.clanData) && Facade.userProxy.clanData.base.id == param1.base.id;
         var _loc5_:RectButton = new RectButton(Lang.getString("to_capital"),RectButton.h42);
         _loc5_.addVarianceListener(this,ClanCenterFactory.TO_CAPITAL);
         add(_loc5_,{
            "vCenter":8,
            "right":8,
            "w":125
         });
         if(_loc4_)
         {
            _loc7_ = VButton.create(SkinManager.getEmbed("DonateIcon"),{
               "h":42,
               "vCenter":0,
               "hCenter":0
            });
            _loc7_.hint = Lang.getString("to_treasure");
            _loc7_.addVarianceListener(this,ClanCenterFactory.TREASURY);
            add(_loc7_,{
               "vCenter":8,
               "right":145
            });
            _loc7_.skin.filters = [new GlowFilter(Style.grayGlowRGB,1,4,4,4)];
            if(Facade.userProxy.checkClanRolePermission(PPermission.TREAS_REPORTS))
            {
               _loc8_ = VButton.create(SkinManager.getEmbed("BHornIcon"),{
                  "h":42,
                  "w":42,
                  "vCenter":0,
                  "hCenter":0
               });
               _loc8_.hint = Lang.getString("require_donate");
               _loc8_.addVarianceListener(this,ClanCenterFactory.DONATE_ALERT);
               add(_loc8_,{
                  "vCenter":8,
                  "right":185
               });
               _loc8_.skin.filters = [new GlowFilter(Style.grayGlowRGB,1,4,4,4)];
            }
         }
      }
      
      private function onWorkerSignal() : void
      {
         (this.workerSignal.data as VText).value = "(" + StringHelper.getTimeDesc(this.workerSignal.tail,true) + ")";
      }
      
      override public function dispose() : void
      {
         if(this.workerSignal)
         {
            this.workerSignal.stop();
            this.workerSignal = null;
         }
      }
   }
}

