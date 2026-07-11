package game.clan.war
{
   import game.offer.OfferItemPanel;
   import logic.EventLogic;
   import proto.model.PCost;
   import proto.model.POfferGoods;
   import proto.model.PWarEvent;
   import ui.UIFactory;
   import ui.common.BlockDialog;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class WarStatusDialog extends BlockDialog
   {
      
      public function WarStatusDialog(param1:PWarEvent)
      {
         var _loc5_:PCost = null;
         var _loc7_:Array = null;
         super(Lang.getString(param1.is_end ? "war_result" : (param1.my_clan_attacker ? "you_war_start" : "they_war_start")),634,22,26,44);
         var _loc2_:VComponent = new VComponent();
         topPanel.layoutH = 106;
         if(param1.my_clan_attacker)
         {
            ClanWarPanel.addVs(_loc2_,param1.a_clan_name,param1.a_clan_icon,null,param1.t_clan_name,param1.t_clan_icon,null,param1.is_end ? 0 : param1.w_start_time);
         }
         else
         {
            ClanWarPanel.addVs(_loc2_,param1.t_clan_name,param1.t_clan_icon,null,param1.a_clan_name,param1.a_clan_icon,null,param1.is_end ? 0 : param1.w_start_time);
         }
         _loc2_.scaleX = _loc2_.scaleY = 0.8;
         topPanel.add(_loc2_,{
            "left":5,
            "w":778
         });
         if(param1.is_end)
         {
            _loc2_.top = 16;
            topPanel.add(UIFactory.createDecorText(Lang.getString(param1.is_win ? "war_win" : "war_fail"),param1.is_win,26,280,false),{"hCenter":-133});
            topPanel.add(UIFactory.createDecorText(Lang.getString(param1.is_win ? "war_fail" : "war_win"),!param1.is_win,26,280,false),{"hCenter":133});
         }
         topPanel.add(SkinManager.getEmbed("RSeparator",VSkin.STRETCH_BG),{
            "left":-22,
            "right":-22,
            "bottom":-57
         });
         var _loc3_:Boolean = !param1.is_end || param1.is_win;
         topPanel.add(UIFactory.createDecorText(Lang.getString(_loc3_ ? "war_spoils" : "war_loss"),true,24,740),{
            "hCenter":0,
            "bottom":-41
         });
         if(param1.my_clan_attacker && _loc3_ || !param1.my_clan_attacker && !_loc3_)
         {
            _loc7_ = param1.a_win_prize;
         }
         else
         {
            _loc7_ = param1.t_win_prize;
         }
         var _loc4_:Array = param1.is_end ? [] : [PCost.create(PCost.CLAN_POINTS,Facade.references.clan_war_win)];
         for each(_loc5_ in _loc7_)
         {
            _loc4_.push(_loc5_);
         }
         if(param1.is_end && param1.is_win)
         {
            this.showWinPrize(param1);
         }
         else
         {
            bottomPanel.add(ClanWarPanel.createPrizePanel(_loc4_,32,22,param1.is_end && !param1.is_win),{
               "top":6,
               "hCenter":0
            });
         }
         var _loc6_:RectButton = new RectButton(Lang.getString(param1.is_end ? "bt_good" : "to_war_tab"),RectButton.h42);
         _loc6_.addClickListener(onBtClose,!param1.is_end);
         add(_loc6_,{
            "bottom":-15,
            "hCenter":0
         });
      }
      
      private function showWinPrize(param1:PWarEvent) : void
      {
         var _loc3_:PCost = null;
         EventLogic.addClanPoint(0);
         bottomPanel.add(SkinManager.getExternal("war_win_banner",SkinManager.JPG,VComponent.SKIP_CONTENT_SIZE),{
            "left":-13,
            "top":-31,
            "w":661
         });
         var _loc2_:VBox = new VBox(null,20);
         for each(_loc3_ in param1.a_win_prize)
         {
            _loc2_.add(new OfferItemPanel(POfferGoods.create(OfferItemPanel.CLAN_COST,_loc3_),0,36));
         }
         _loc2_.add(new OfferItemPanel(POfferGoods.create(OfferItemPanel.CLAN_COST,PCost.create(PCost.CLAN_POINTS,Facade.references.clan_war_win)),0,36));
         bottomPanel.layoutH = 115;
         _loc2_.scaleX = _loc2_.scaleY = 0.55;
         bottomPanel.add(_loc2_,{
            "hCenter":0,
            "top":-2,
            "w":_loc2_.measuredWidth * _loc2_.scaleX
         });
      }
   }
}

