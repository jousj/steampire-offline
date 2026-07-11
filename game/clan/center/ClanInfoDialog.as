package game.clan.center
{
   import proto.model.clan.PClan;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.CircleButton;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class ClanInfoDialog extends BaseDialog
   {
      
      private const pagerSkin:VSkin = SkinManager.getEmbed("PaperBg",VSkin.STRETCH);
      
      public function ClanInfoDialog(param1:PClan, param2:uint, param3:Boolean, param4:uint, param5:Boolean)
      {
         super();
         setSize(675,528);
         addBg(false);
         addDialogTitle(Lang.getString("clan_about"));
         addCloseButton();
         add(this.pagerSkin,{
            "left":-24,
            "top":44,
            "bottom":-7
         },1);
         var _loc6_:ResourcePanel = new ResourcePanel("ClanEmblemIcon",ResourcePanel.BG | ResourcePanel.PROGRESS,UIFactory.INDICATOR_GREEN);
         _loc6_.setSize(130,39);
         add(_loc6_,{
            "right":100,
            "top":15
         });
         _loc6_.hint = Lang.getString("ClanEmblemIcon");
         _loc6_.cur = ClanMembersMediator.getCurRating(Facade.userProxy.base.clan_points);
         var _loc7_:CircleButton = new CircleButton(SkinManager.getEmbed("InfoIcon"),CircleButton.TEAL,CircleButton.size42);
         add(_loc7_,{
            "right":58,
            "top":13
         });
         _loc7_.addVarianceListener(this,ClanCenterFactory.TO_INFO_DIALOG);
         this.pagerSkin.layoutW = 345;
         this.pagerSkin.syncLayout();
         add(new VBox(new <VComponent>[this.cr(new CreateCaptionSection(param1.base,param1.clan_comp_place_opt,0,false,param5,param1.wins)),this.cr(new CreateDescSection(param1.base.description,95)),this.cr(new CreateMemberSection(null,param1.members.length,param2,false)),this.cr(new CreateJoinClanSection(param1,param3,param2,param4))],12,VBox.STRETCH | VBox.VERTICAL),{
            "left":13,
            "top":80,
            "w":290
         });
         §§push(§§findproperty(add));
         §§push(§§findproperty(VBox));
         var _temp_7:* = new <VComponent>[this.cr(new CreateResourceSection(param1.base,false)),this.cr(param1.base.has_capital ? new CreateCapitalSection(param1,false) : new CreateNoCapitalSection(param1.base.gold,false)),this.cr(new CreateDomainSection(param1,false,ClanCenterDialog.getResPerDay(param1))),this.cr(new CreateSimpleWarSection(param1.war))];
         §§pop().add(new §§pop().VBox(new <VComponent>[this.cr(new CreateResourceSection(param1.base,false)),this.cr(param1.base.has_capital ? new CreateCapitalSection(param1,false) : new CreateNoCapitalSection(param1.base.gold,false)),this.cr(new CreateDomainSection(param1,false,ClanCenterDialog.getResPerDay(param1))),this.cr(new CreateSimpleWarSection(param1.war))],6,VBox.STRETCH | VBox.VERTICAL),{
            "left":326,
            "top":74,
            "w":337
         });
      }
      
      private function cr(param1:VComponent) : VComponent
      {
         param1.dispatcher = this;
         return param1;
      }
   }
}

