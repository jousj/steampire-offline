package game.clan.donate
{
   import proto.model.PClanTownhallUnlock;
   import proto.model.PCost;
   import proto.model.PCostt;
   import proto.model.clan.PBase;
   import proto.model.clan.PClan;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class DonatePanel extends VComponent
   {
      
      public var goldBar:DonateProgressBar;
      
      public var oilBar:DonateProgressBar;
      
      public var cryBar:DonateProgressBar;
      
      public var mithrilBar:DonateProgressBar;
      
      public var box:VBox;
      
      public function DonatePanel(param1:PClan, param2:PClanTownhallUnlock, param3:uint, param4:uint, param5:uint, param6:uint, param7:uint, param8:uint, param9:Boolean = false)
      {
         super();
         addStretch(SkinManager.getEmbed("StatBg",VSkin.STRETCH));
         var _loc10_:PBase = param1.base;
         this.goldBar = new DonateProgressBar(PCost.GOLD,0,_loc10_.gold,0,param2.ctu_donate_min_gold,false,param7,param9);
         this.goldBar.bt.addVarianceListener(this,PCostt.GOLD,this);
         this.mithrilBar = new DonateProgressBar(PCost.MITHRIL,Facade.references.mithril_limit,_loc10_.mithril,Facade.references.clan_mithril_limit,param2.ctu_donate_min_mithril,true,param8,param9);
         this.mithrilBar.bt.addVarianceListener(this,PCostt.MITHRIL,this);
         this.oilBar = new DonateProgressBar(PCost.OIL,param3,_loc10_.oil,param1.storage_max_oil,param2.ctu_donate_min_oil,true,param5,param9);
         this.oilBar.bt.addVarianceListener(this,PCostt.OIL,this);
         this.cryBar = new DonateProgressBar(PCost.CRYSTAL,param4,_loc10_.crystal,param1.storage_max_crystal,param2.ctu_donate_min_crystal,true,param6,param9);
         this.cryBar.bt.addVarianceListener(this,PCostt.CRYSTAL,this);
         this.box = new VBox(new <VComponent>[this.goldBar,this.mithrilBar,this.oilBar,this.cryBar],14,VBox.VERTICAL);
         add(this.box,{
            "hCenter":0,
            "vCenter":15
         });
         top += 14;
         add(UIFactory.createYellowText(Lang.getString("my_resources"),VText.CONTAIN_CENTER),{
            "hCenter":-140,
            "vCenter":-150,
            "w":200
         });
         add(UIFactory.createYellowText(Lang.getString("clan_resources"),VText.CONTAIN_CENTER),{
            "hCenter":140,
            "vCenter":-150,
            "w":200
         });
      }
   }
}

