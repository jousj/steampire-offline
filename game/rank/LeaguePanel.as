package game.rank
{
   import proto.model.PShopDivision;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class LeaguePanel extends TopUserPanel
   {
      
      private const bg:VSkin;
      
      private const border:VSkin;
      
      public function LeaguePanel(param1:PShopDivision, param2:PShopDivision)
      {
         var _loc5_:PShopDivision = null;
         var _loc6_:VText = null;
         var _loc7_:Array = null;
         var _loc8_:PriceListPanel = null;
         this.bg = SkinManager.getPack("RankDialog","LeagueBg");
         this.border = SkinManager.getEmbed("DialogBorder",VSkin.STRETCH);
         super(6,87,16,17,61,41);
         layoutW = 810;
         add(this.border,{
            "wP":100,
            "top":397
         },0);
         add(this.bg,{
            "wP":100,
            "top":-9
         },0);
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "w":788,
            "h":78,
            "hCenter":0
         });
         add(SkinManager.getEmbed("league" + param1.division_num),{
            "top":5,
            "hCenter":-349,
            "w":70,
            "h":70
         });
         add(UIFactory.createDecorText(Lang.getString("league" + param1.division_num),true,24,194,false),{
            "left":100,
            "top":10
         });
         add(SkinManager.getEmbed("Exp"),{
            "left":98,
            "top":37,
            "w":35,
            "h":35
         });
         if(param1.division_num > 1)
         {
            _loc5_ = Facade.manualProxy.getLeagueShop(param1.division_num - 1,false,true);
         }
         add(UIFactory.createYellowText((_loc5_ ? _loc5_.division_level + 1 : "1") + "-" + param1.division_level),{
            "left":138,
            "top":47
         });
         var _loc3_:RectButton = new RectButton(Lang.getString("leagues_info"),RectButton.h56);
         _loc3_.addVarianceListener(this,4,param1);
         add(_loc3_,{
            "right":24,
            "top":13,
            "maxW":182
         });
         var _loc4_:Vector.<VComponent> = new Vector.<VComponent>();
         if(param1.division_num == param2.division_num)
         {
            _loc5_ = Facade.manualProxy.getLeagueShop(param1.division_num + 1,false,true);
            if(_loc5_)
            {
               _loc6_ = UIFactory.createYellowText(Lang.getString("league_next_prize"),VText.CONTAIN_CENTER);
               _loc7_ = _loc5_.division_reward;
            }
            else
            {
               _loc6_ = UIFactory.createYellowText(Lang.getString("active_league"));
               _loc6_.maxH = 62;
            }
         }
         else if(param2.division_level > param1.division_level)
         {
            _loc4_.push(new VBox(new <VComponent>[SkinManager.getEmbed("CollectIcon"),UIFactory.createDecorText(Lang.getString("league_complete"),true,22,170)]));
         }
         else
         {
            _loc6_ = UIFactory.createYellowText(Lang.getString("league_prize"),VText.CONTAIN_CENTER);
            _loc7_ = param1.division_reward;
            this.bg.filters = VSkin.GREY_FILTER;
            add(SkinManager.getEmbed("LockIcon"),{
               "left":-9,
               "top":98,
               "h":60
            });
         }
         if(_loc6_)
         {
            _loc6_.maxW = 290;
            _loc4_.push(_loc6_);
         }
         if(_loc7_)
         {
            _loc8_ = new PriceListPanel();
            _loc8_.priceMode = 0;
            _loc8_.setStyle(35,20);
            _loc8_.assignList(_loc7_);
            _loc8_.setCustomColor(9157412,1778950,true);
            _loc8_.maxW = 290;
            _loc4_.push(_loc8_);
         }
         add(new VBox(_loc4_,2,VBox.VERTICAL),{
            "hCenter":47,
            "vCenter":-200
         });
      }
      
      public function changeBgTop(param1:int) : void
      {
         this.bg.top += param1;
         this.border.top += param1;
      }
   }
}

