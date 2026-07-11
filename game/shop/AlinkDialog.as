package game.shop
{
   import flash.events.MouseEvent;
   import game.friends.FriendsMediator;
   import logic.CoreLogic;
   import logic.ShopLogic;
   import model.UserProxy;
   import model.ui.VOCallback;
   import proto.BinaryBuffer;
   import proto.game.family_0010.Packet_0010_14;
   import proto.game.family_0010.Packet_0010_15;
   import proto.model.PAsk;
   import proto.model.PAskData;
   import proto.model.PAskValue;
   import proto.model.PCost;
   import proto.model.PShopBuilding;
   import proto.model.PShopCall;
   import proto.model.PSign;
   import proto.model.PUserBase;
   import ui.Style;
   import ui.common.BaseDialog;
   import ui.common.DurationPanel;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.game.UnitPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class AlinkDialog extends BaseDialog
   {
      
      private const box:VBox = new VBox(null,9,VBox.VERTICAL);
      
      private const bgSkin:VSkin = SkinManager.getEmbed("FeatureSectionBg",VSkin.STRETCH);
      
      public var buyBt:RectButton;
      
      public function AlinkDialog()
      {
         super();
         layoutW = 494;
         add(SkinManager.getEmbed("FeatureDialogBg",VSkin.STRETCH),{
            "wP":100,
            "top":40,
            "bottom":0
         });
         add(this.box,{
            "top":80,
            "left":20,
            "right":20
         });
         this.bgSkin.assignLayout({
            "left":-this.box.left,
            "right":-this.box.right,
            "top":-40,
            "bottom":-28
         });
         this.bgSkin.useRuledLayout();
         this.box.addChild(this.bgSkin);
         addHeader();
      }
      
      override public function get measuredHeight() : uint
      {
         return this.box.measuredHeight + this.box.vPadding + 230;
      }
      
      public function useResourceMode(param1:PCost, param2:PCost, param3:Function, param4:Array) : void
      {
         var _loc5_:String = CostHelper.getKind(param1.variance).toLowerCase();
         addDialogTitle(Lang.getString("need_" + _loc5_),false);
         var _loc6_:PricePanel = new PricePanel(28,18,PricePanel.GLOW_FILTER);
         _loc6_.assignCost(param1);
         this.box.add(new VBox(new <VComponent>[new VText(Lang.getString("need_resource"),VText.CONTAIN,Style.redRGB).assignMaxW(300),_loc6_]));
         this.box.add(new VText(Lang.getString("get_" + _loc5_),VText.CENTER,Style.metalRGB,16).assignW(450));
         this.addPanel("rs_" + _loc5_ + "1",-108).addClickListener(this.onAlink,PAskData.create(param1.variance == PCost.CRYSTAL ? PAskData.ASK_CRYSTAL : PAskData.ASK_OIL,null));
         this.addPanel("rs_" + _loc5_ + "3",108,0,param2,param1).data = VOCallback.create(param3,param4);
      }
      
      public function useExchangeMode(param1:PCost, param2:PCost, param3:PCost, param4:PCost, param5:VOCallback, param6:VOCallback) : void
      {
         var _loc7_:String = null;
         _loc7_ = CostHelper.getKind(param1.variance).toLowerCase();
         addDialogTitle(Lang.getString("need_" + _loc7_),false);
         this.box.add(new VText(Lang.getString("get_" + _loc7_),VText.CENTER,Style.metalRGB,16).assignW(450));
         this.addPanel("rs_" + _loc7_ + "1",-108,0,param2,param1).data = param5;
         this.addPanel("rs_" + _loc7_ + "2",108,0,param4,param3).data = param6;
      }
      
      public function useEnergyMode(param1:Number, param2:Number, param3:PShopCall, param4:PShopCall) : void
      {
         layoutW = 640;
         addDialogTitle(Lang.getString("need_energy"),false);
         this.box.add(new VText(Lang.getPatternString("ask_energy","__VALUE__",StringHelper.getTimeDesc(param2)),VText.CENTER,Style.metalRGB,16).assignW(580));
         this.addPanel("rs_calls1",-200).addClickListener(this.onAlink,PAskData.create(PAskData.ASK_CALL,null));
         this.addPanel("rs_calls2",0,0,param3.call_price,PCost.create(PCost.CALL,param3.call_effect.value)).data = VOCallback.create(ShopLogic.buyEnergy,[param3]);
         this.addPanel("rs_calls3",200,0,param4.call_price,PCost.create(PCost.CALL,param4.call_effect.value)).data = VOCallback.create(ShopLogic.buyEnergy,[param4]);
         if(param1 > 0)
         {
            this.box.add(new VBox(new <VComponent>[new VText(Lang.getPatternString("energy_recovery","__TIME__",""),VText.CONTAIN,Style.redRGB).assignMaxW(400),new DurationPanel(28,18).setTrackTime(param1)],2));
            addCloseSignal(param1);
         }
      }
      
      public function useSpeedupMode(param1:Boolean, param2:uint, param3:String, param4:uint, param5:Number, param6:Function, param7:Array, param8:PShopBuilding = null, param9:uint = 0) : AlinkDialog
      {
         addDialogTitle(Lang.getString("speedup"),false);
         this.box.left = 98;
         this.bgSkin.left = -this.box.left;
         this.box.add(new VLabel("<div" + Style.metalColor + ">" + Lang.getPatternString(param1 ? "research_run" : "update_run","__NAME__",StringHelper.getUnitName(param3,param4)) + "</div>",VLabel.CONTAIN_CENTER),{"wP":100});
         this.box.add(new VBox(new <VComponent>[new VText(Lang.getString("complete_time"),VText.CONTAIN,Style.redRGB).assignMaxW(240),new DurationPanel(28,18).setTrackTime(param5)],10));
         this.box.add(new VText(Lang.getString(param8 ? "get_speedup_worker" : (param1 ? "get_speedup_research" : "get_speedup_build")),VText.CENTER,Style.metalRGB,16).assignW(370));
         var _loc10_:UnitPanel = new UnitPanel(UnitPanel.FEATURE_MODE);
         UnitPanel.feature(_loc10_,param3);
         add(_loc10_,{
            "left":-72,
            "top":50
         });
         _loc10_.show(param3,param9 > 0 ? param9 : param4);
         if(Boolean(param8) && Facade.userProxy.getConstructionCount("bl_builder") < Facade.userProxy.getConstructionMax("bl_builder"))
         {
            this.box.left = 68;
            this.bgSkin.left = -this.box.left;
            this.addPanel("rs_speedup1",-200).addClickListener(this.onAlink,PAskData.create(param1 ? PAskData.ASK_RESEARCH : PAskData.ASK_SPEED_UP,param2));
            this.addPanel("rs_speedup2",0,param5,null,null,Lang.getString("speedupBt")).data = VOCallback.create(param6,param7);
            this.addWorkerPanel(param8,200).data = VOCallback.create(ShopLogic.buyWorker,[param8]);
            layoutW = 640;
         }
         else
         {
            this.addPanel("rs_speedup1",-108).addClickListener(this.onAlink,PAskData.create(param1 ? PAskData.ASK_RESEARCH : PAskData.ASK_SPEED_UP,param2));
            this.addPanel("rs_speedup2",108,param5).data = VOCallback.create(param6,param7);
         }
         addCloseSignal(param5);
         return this;
      }
      
      private function addWorkerPanel(param1:PShopBuilding, param2:uint) : RectButton
      {
         var _loc3_:VComponent = new VComponent();
         _loc3_.setSize(164,152);
         _loc3_.addStretch(SkinManager.getEmbed("ShopItemBg",VSkin.STRETCH));
         _loc3_.add(SkinManager.getEmbed("ShopDiffusion",VSkin.STRETCH),{
            "left":11,
            "right":11,
            "top":9,
            "bottom":42
         });
         var _loc4_:ShopUnitPanel = new ShopUnitPanel();
         _loc4_.show(param1.sb_kind,param1.sb_level);
         _loc3_.add(_loc4_,{
            "left":18,
            "right":18,
            "top":16,
            "bottom":36
         });
         var _loc5_:PriceListPanel = new PriceListPanel(7,PricePanel.GLOW_FILTER);
         _loc5_.useCostCheck = true;
         _loc5_.setStyle(25,18);
         _loc5_.priceGap = 1;
         _loc5_.assignList(ShopLogic.getCustomPrice("bl_builder",param1.sb_price_list,param1.sb_price));
         var _loc6_:RectButton = this.buyBt = new RectButton(_loc5_,RectButton.h42);
         _loc6_.addClickListener(this.onClick);
         _loc3_.add(_loc6_,{
            "bottom":0,
            "left":-1,
            "right":-2
         });
         _loc3_.hCenter = param2;
         _loc3_.bottom = 30;
         add(_loc3_);
         return _loc6_;
      }
      
      private function addPanel(param1:String, param2:int, param3:Number = 0, param4:PCost = null, param5:PCost = null, param6:String = null) : RectButton
      {
         var _loc8_:VBox = null;
         var _loc9_:PricePanel = null;
         var _loc10_:RectButton = null;
         var _loc11_:VText = null;
         var _loc7_:VComponent = new VComponent();
         _loc7_.setSize(164,152);
         _loc7_.addStretch(SkinManager.getEmbed("ShopItemBg",VSkin.STRETCH));
         _loc7_.add(SkinManager.getEmbed("ShopDiffusion",VSkin.STRETCH),{
            "left":11,
            "right":11,
            "top":9,
            "bottom":42
         });
         _loc7_.add(SkinManager.getExternal(param1,SkinManager.PNG | SkinManager.LOAD_CLIP),{
            "left":18,
            "right":18,
            "top":16,
            "bottom":36
         });
         if(Boolean(param4) || param3 > 0)
         {
            _loc8_ = new VBox(null,5,VBox.CENTER);
            _loc9_ = new PricePanel(25,18,PricePanel.GLOW_FILTER,1);
            _loc8_.add(_loc9_);
            _loc9_.useCheck = true;
            if(param4)
            {
               _loc9_.assignCost(param4);
            }
            else
            {
               _loc9_.runTrackSpeedup(param3);
            }
            if(param6)
            {
               _loc11_ = new VText(param6,VText.MIDDLE);
               Style.applyGlowFormat(_loc11_,18,Style.yellowRGB,Style.grayGlowRGB);
               _loc8_.add(_loc11_,null,0);
            }
            _loc10_ = this.buyBt = new RectButton(_loc8_,RectButton.h42);
         }
         else
         {
            _loc10_ = new RectButton(Lang.getString("requestBt"),RectButton.h42);
         }
         _loc10_.addClickListener(this.onClick);
         _loc7_.add(_loc10_,{
            "bottom":0,
            "left":-1,
            "right":-2
         });
         if(param5)
         {
            _loc9_ = new PricePanel(26,18,PricePanel.GLOW_FILTER,1);
            _loc9_.assignCost(param5);
            _loc7_.add(_loc9_,{
               "hCenter":0,
               "top":-12
            });
         }
         _loc7_.hCenter = param2;
         _loc7_.bottom = 30;
         add(_loc7_);
         return _loc10_;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:Object = (param1.currentTarget as RectButton).data;
         close();
         if(_loc2_ is VOCallback)
         {
            (_loc2_ as VOCallback).apply();
         }
         else if(_loc2_ is Function)
         {
            (_loc2_ as Function)();
         }
      }
      
      private function onAlink(param1:MouseEvent) : void
      {
         var _loc5_:PAskData = null;
         var _loc6_:FriendsMediator = null;
         close();
         var _loc2_:UserProxy = Facade.userProxy;
         var _loc3_:Number = _loc2_.alinkStartTime + Facade.references.request_cooldown - CoreLogic.serverTime;
         var _loc4_:Boolean = _loc3_ > 0;
         if(!_loc4_)
         {
            _loc2_.alinkHistoryList.length = 0;
         }
         if(_loc2_.alinkHistoryList.length >= Facade.references.request_max_count)
         {
            Facade.mainMediator.showMessage(Lang.getPatternString("ask_coldown","__TIME__",StringHelper.getTimeDesc(_loc3_,true)));
         }
         else
         {
            _loc5_ = (param1.currentTarget as RectButton).data as PAskData;
            _loc6_ = new FriendsMediator(FriendsMediator.REQUEST,Lang.getString("friend_mode2"),this.onApplyAlink,[_loc5_],true);
            _loc6_.typeValue = _loc5_.variance;
            if(_loc4_)
            {
               _loc6_.skipList = _loc2_.alinkHistoryList;
            }
            _loc6_.isNoApp = true;
            Facade.mainMediator.showDialog(_loc6_);
         }
      }
      
      private function onApplyAlink(param1:PUserBase, param2:PAskData) : void
      {
         if(Facade.socialnet == Facade.FACEBOOK)
         {
            Facade.callJS("ask",param2.variance,param2.value,param1.account_id,Facade.userProxy.base.name);
         }
         else
         {
            Facade.protoProxy.request(new Packet_0010_14(PAsk.create(param1.user_id,Facade.userProxy.base.name,Facade.userProxy.level,0,param2,false,PAskValue.create(PAskValue.UNKNOWN,null))),this.resultAlinkSign,16,21,[param1.account_id,param2.variance]);
         }
      }
      
      private function resultAlinkSign(param1:BinaryBuffer, param2:String, param3:uint) : void
      {
         var _loc5_:String = null;
         var _loc4_:PSign = new Packet_0010_15(param1).value;
         if(_loc4_)
         {
            if(param3 == PAskData.ASK_CRYSTAL || param3 == PAskData.ASK_OIL)
            {
               Facade.callJS("askResources",param2,_loc4_.sign_key,_loc4_.sign,param3 == PAskData.ASK_CRYSTAL ? "askCrystal" : "askOil");
            }
            else
            {
               switch(param3)
               {
                  case PAskData.ASK_SPEED_UP:
                     _loc5_ = "askSpeedup";
                     break;
                  case PAskData.ASK_RESEARCH:
                     _loc5_ = "askResearch";
                     break;
                  case PAskData.ASK_CALL:
                     _loc5_ = "askCalls";
                     break;
                  default:
                     return;
               }
               Facade.callJS(_loc5_,param2,_loc4_.sign_key,_loc4_.sign);
            }
         }
      }
   }
}

