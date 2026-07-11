package game.rank
{
   import proto.model.PShopDivision;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.ShineClip;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class LeagueUpDialog extends BaseDialog
   {
      
      public var league:PShopDivision;
      
      private const shineClip:ShineClip;
      
      public function LeagueUpDialog(param1:PShopDivision)
      {
         var _loc5_:RectButton = null;
         var _loc6_:PShopDivision = null;
         this.shineClip = new ShineClip();
         super();
         this.league = param1;
         useSimpleBg(572,376,Lang.getString("league_up"));
         add(SkinManager.getPack("RankDialog","LeagueBg"),{
            "left":2,
            "right":2,
            "top":37
         },1);
         if(param1.division_num > 1)
         {
            _loc6_ = Facade.manualProxy.getLeagueShop(param1.division_num - 1,false,true);
         }
         add(SkinManager.getEmbed("StatBg",VSkin.STRETCH),{
            "left":10,
            "right":10,
            "top":80,
            "h":96
         });
         add(SkinManager.getEmbed("league" + param1.division_num),{
            "left":20,
            "top":84,
            "w":90,
            "h":90
         });
         add(UIFactory.createYellowText(Lang.getString("league_up_desc"),VText.CONTAIN_CENTER),{
            "left":118,
            "right":30,
            "top":102
         });
         var _loc2_:VSkin = SkinManager.getEmbed("Exp",VSkin.RIGHT);
         _loc2_.setSize(45,35);
         §§push(§§findproperty(add));
         §§push(§§findproperty(VBox));
         var _temp_3:* = new <VComponent>[UIFactory.createDecorText(Lang.getString("league" + param1.division_num),true,26,340,false),_loc2_,UIFactory.createYellowText((_loc6_ ? _loc6_.division_level + 1 : "1") + "-" + param1.division_level,0,22)];
         §§pop().add(new §§pop().VBox(new <VComponent>[UIFactory.createDecorText(Lang.getString("league" + param1.division_num),true,26,340,false),_loc2_,UIFactory.createYellowText((_loc6_ ? _loc6_.division_level + 1 : "1") + "-" + param1.division_level,0,22)]),{
            "top":126,
            "hCenter":45
         });
         add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH),{
            "left":0,
            "right":0,
            "top":188,
            "h":140
         });
         add(new VText(Lang.getString("league_prize"),VText.CONTAIN_CENTER,Style.metalRGB),{
            "left":30,
            "right":30,
            "top":210
         });
         var _loc3_:PriceListPanel = new PriceListPanel(12);
         _loc3_.useVertical(50,60,80);
         _loc3_.assignList(param1.division_reward);
         add(_loc3_,{
            "top":240,
            "hCenter":0
         });
         var _loc4_:RectButton = new RectButton(Lang.getString("bt_ok"),RectButton.h56,RectButton.ORANGE);
         _loc4_.addClickListener(close);
         _loc5_ = new RectButton(Lang.getString("to_league"),RectButton.h56,RectButton.GREEN);
         _loc5_.data = true;
         _loc5_.addClickListener(onBtClose);
         add(new VBox(new <VComponent>[_loc4_,_loc5_],20),{
            "hCenter":0,
            "bottom":-17
         });
         add(this.shineClip,null,0);
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         this.shineClip.pause = !param1;
      }
   }
}

