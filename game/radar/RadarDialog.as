package game.radar
{
   import proto.model.PCost;
   import proto.model.PShopOffer;
   import proto.model.PShopScoutingPack;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.DurationPanel;
   import ui.game.PricePanel;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class RadarDialog extends BaseDialog
   {
      
      public static const BT_PRIME_RESOURCES:uint = 0;
      
      public static const BT_PRIME_VOICE:uint = 1;
      
      public static const BT_PRIME_SUB:uint = 2;
      
      public static const BT_PRIME_UNSUB:uint = 3;
      
      public static const BT_PRIME_RESUB:uint = 4;
      
      public static const OFFER_KIND:String = "so_scout_7days";
      
      public const blueprintPanel:ResourcePanel;
      
      public const goldPanel:ResourcePanel;
      
      private const btBox:VBox;
      
      private var component:VComponent;
      
      public function RadarDialog(param1:Array, param2:Number)
      {
         var _loc6_:PShopScoutingPack = null;
         var _loc7_:PricePanel = null;
         var _loc8_:uint = 0;
         var _loc9_:VButton = null;
         var _loc10_:PShopOffer = null;
         var _loc11_:String = null;
         var _loc12_:uint = 0;
         var _loc13_:String = null;
         var _loc14_:VText = null;
         this.blueprintPanel = new ResourcePanel(PCost.BLUE_PRINT,ResourcePanel.BG | ResourcePanel.PROGRESS,UIFactory.INDICATOR_BLUE);
         this.goldPanel = new ResourcePanel(PCost.GOLD,ResourcePanel.BG);
         this.btBox = new VBox(null,10,VBox.CENTER);
         super();
         setSize(711,470);
         var _loc3_:VSkin = SkinManager.getExternal("ScoutingBg");
         add(_loc3_,{"top":36});
         this.syncTime(param2);
         createScoutingPanel(this);
         var _loc4_:Boolean = Facade.socialnet == Facade.VZ;
         var _loc5_:int = 0;
         while(_loc5_ < (_loc4_ ? param1.length : param1.length - 1))
         {
            _loc6_ = param1[_loc5_];
            _loc7_ = new PricePanel(28,20,PricePanel.GLOW_FILTER);
            _loc7_.useCheck = true;
            _loc7_.assignCost(_loc6_.sp_price[0]);
            _loc8_ = _loc6_.sp_duration / 86400;
            §§push(this);
            §§push("BtRectOrange75");
            §§push(§§findproperty(VBox));
            var _temp_6:* = new <VComponent>[UIFactory.createYellowText((param2 > 0 ? "+" : "") + _loc8_ + " " + Lang.getTimeString(_loc8_,Lang.DAY),20),_loc7_];
            _loc9_ = §§pop().addButton(§§pop(),new §§pop().VBox(new <VComponent>[UIFactory.createYellowText((param2 > 0 ? "+" : "") + _loc8_ + " " + Lang.getTimeString(_loc8_,Lang.DAY),20),_loc7_],8));
            _loc9_.addVarianceListener(this,BT_PRIME_RESOURCES,_loc6_);
            _loc9_.minW = 0;
            this.btBox.add(_loc9_);
            if(_loc5_ == 2)
            {
               break;
            }
            _loc5_++;
         }
         if(!_loc4_)
         {
            _loc8_ = 7;
            _loc10_ = Facade.manualProxy.getOfferShop("so_scout_7days");
            _loc12_ = 0;
            _loc13_ = "BtRectGreen75";
            if(Facade.socialnet != Facade.VKONTAKTE)
            {
               _loc11_ = (param2 > 0 ? "+" : "") + _loc8_ + " " + Lang.getTimeString(_loc8_,Lang.DAY) + "\n" + (_loc10_.caption ? _loc10_.offer_social_price + " " + _loc10_.caption : Lang.getCurrency(_loc10_.offer_social_price));
               _loc12_ = BT_PRIME_VOICE;
            }
            else if(!Facade.userProxy.isActiveSub())
            {
               _loc11_ = Lang.getString("subs") + "\n" + Lang.getReplaceString("subs_desc",{
                  "__DAY__":_loc8_ + " " + Lang.getTimeString(_loc8_,Lang.DAY),
                  "__COST__":(_loc10_.caption ? _loc10_.offer_social_price + " " + _loc10_.caption : Lang.getCurrency(_loc10_.offer_social_price))
               });
               _loc12_ = BT_PRIME_SUB;
            }
            else if(Facade.userProxy.subs.canceled)
            {
               _loc11_ = Lang.getString("resume_unsubscribe");
               _loc12_ = BT_PRIME_RESUB;
            }
            else
            {
               _loc11_ = Lang.getString("unsubscribe");
               _loc12_ = BT_PRIME_UNSUB;
               _loc13_ = "BtRectRed";
            }
            _loc14_ = UIFactory.createYellowText(_loc11_,VText.CENTER | VText.CONTAIN_CENTER,18,true);
            _loc14_.format.lineHeight = "110%";
            _loc14_.left = _loc14_.right = 10;
            _loc9_ = this.addButton(_loc13_,_loc14_);
            _loc9_.addVarianceListener(this,_loc12_,_loc6_);
            _loc9_.minW = 0;
            this.btBox.add(_loc9_);
         }
         add(this.btBox,{
            "hCenter":0,
            "bottom":-28
         });
         if(!_loc3_.isContent)
         {
            _loc3_.useCustomLoadClip(UIFactory.createLoadPanel(this,{
               "wP":100,
               "top":36,
               "bottom":0
            }));
         }
         add(SkinManager.getEmbed("RSeparator",VSkin.STRETCH),{
            "wP":100,
            "h":65
         });
         add(UIFactory.createDecorText(Lang.getString("bl_scouting_hh"),true,32,366,false),{
            "left":30,
            "top":16
         });
         add(SkinManager.getEmbed("Bolt"),{
            "left":2,
            "top":44
         });
         add(SkinManager.getEmbed("Bolt"),{
            "right":2,
            "top":44
         });
         this.goldPanel.layoutW = this.blueprintPanel.layoutW = 114;
         add(new VBox(new <VComponent>[this.goldPanel,this.blueprintPanel],10),{
            "right":64,
            "top":13
         });
         addCloseButton({
            "top":13,
            "right":15
         });
      }
      
      public static function createScoutingPanel(param1:VComponent, param2:uint = 80, param3:uint = 128) : void
      {
         var _loc6_:VComponent = null;
         var _loc4_:Vector.<String> = new <String>["scout_ratio_max_hint","scout_mine_hint","scout_energy_hint","scout_res_victory_hint","scout_raid_hint","scout_ratio_bonus_hint"];
         var _loc5_:uint = 0;
         while(_loc5_ < 6)
         {
            _loc6_ = new VComponent();
            _loc6_.setSize(145,145);
            _loc6_.addStretch(SkinManager.getPack("ScoutingBg","PremiumImgBg",VSkin.STRETCH_BG));
            _loc6_.add(SkinManager.getPack("ScoutingBg","Premium" + (_loc5_ + 1)),{
               "w":140,
               "h":140,
               "vCenter":0,
               "hCenter":0
            });
            _loc6_.hint = "<p" + Style.greenColor + ">" + StringHelper.getTLFImage("lib,PremiumArrowIcon",18) + Lang.getString(_loc4_[_loc5_]) + "</p>";
            param1.add(_loc6_,{
               "left":param3 + 155 * (_loc5_ % 3),
               "top":param2 + Math.floor(_loc5_ / 3) * 155
            });
            _loc5_++;
         }
      }
      
      public function set btLock(param1:Boolean) : void
      {
         var _loc2_:VButton = null;
         for each(_loc2_ in this.btBox.list)
         {
            _loc2_.disabled = param1;
         }
      }
      
      public function syncTime(param1:Number) : void
      {
         var _loc2_:DurationPanel = null;
         var _loc3_:VSkin = null;
         if(param1 > 0)
         {
            if(this.component is VBox)
            {
               _loc2_ = (this.component as VBox).list[2] as DurationPanel;
            }
            else
            {
               if(this.component)
               {
                  remove(this.component.parent as VComponent);
               }
               _loc2_ = new DurationPanel(33);
               _loc2_.addListener(VEvent.CHANGE,this.onEndTime);
               this.component = new VText(Lang.getString("scouting_time"),VText.CONTAIN,Style.darkKhakiRGB,20);
               this.component.maxW = 500;
               _loc3_ = SkinManager.getEmbed("RadarIconAnim",VSkin.PLAY_MOVIE_CLIP);
               _loc3_.layoutW = 35;
               this.component = new VBox(new <VComponent>[_loc3_,this.component,_loc2_]);
               add(this.component,{
                  "hCenter":5,
                  "top":388
               });
            }
            _loc2_.setTrackTime(param1);
         }
         else if(!(this.component is VText))
         {
            if(this.component)
            {
               remove(this.component);
            }
            this.component = new VText(Lang.getString("scouting_start"),VText.CONTAIN_CENTER,Style.darkKhakiRGB,20);
            this.component.maxW = 600;
            _loc3_ = SkinManager.getEmbed("RadarIconAnim");
            _loc3_.layoutW = 35;
            add(new VBox(new <VComponent>[_loc3_,this.component]),{
               "left":65,
               "right":65,
               "top":388
            });
         }
      }
      
      private function addButton(param1:String, param2:VComponent) : VButton
      {
         var _loc3_:VButton = new VButton();
         _loc3_.setSize(190,75);
         _loc3_.bottom = 28;
         _loc3_.addStretch(SkinManager.getEmbed(param1,VSkin.STRETCH));
         _loc3_.add(param2,{
            "hCenter":0,
            "vCenter":0,
            "maxH":55
         });
         addChild(_loc3_);
         return _loc3_;
      }
      
      private function onEndTime(param1:VEvent) : void
      {
         this.syncTime(0);
      }
   }
}

