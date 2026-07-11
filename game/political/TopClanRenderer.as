package game.political
{
   import flash.display.BlendMode;
   import game.clan.center.TopClansDialog;
   import proto.model.clan.PBase;
   import proto.model.clan.PClanTop;
   import ui.Style;
   import ui.common.CircleButton;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class TopClanRenderer extends TopClanRendererBase
   {
      
      protected const ratingStat:StatPanel = new StatPanel(SkinManager.getEmbed("RatingIcon"),null,0,4,32,18);
      
      protected const levelText:VText = new VText(null,VText.CONTAIN_CENTER);
      
      protected const capitalSkin:VSkin = new VSkin();
      
      protected var capitalBt:CircleButton;
      
      protected var isCapital:Boolean;
      
      protected var myFill:VFill;
      
      public function TopClanRenderer(param1:Boolean = false)
      {
         super(param1);
         if(!param1)
         {
            this.capitalBt = new CircleButton(SkinManager.getEmbed("SearchIcon"),CircleButton.GOLD,CircleButton.size42);
            this.capitalBt.icon.setSize(28,28);
            this.capitalBt.addVarianceListener(this,CAPITAL);
            add(this.capitalBt,{
               "right":70,
               "vCenter":0
            });
         }
         this.ratingStat.hint = Lang.getString("rating");
         add(this.ratingStat,{
            "vCenter":0,
            "right":200,
            "w":110
         });
         this.capitalSkin.blendMode = BlendMode.LAYER;
         this.capitalSkin.mouseEnabled = true;
         this.capitalSkin.hint = Lang.getString("capital_level");
         add(this.capitalSkin,{
            "right":155,
            "vCenter":0
         });
         add(this.levelText,{
            "right":119,
            "w":30,
            "vCenter":1
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PClanTop = null;
         var _loc3_:PBase = null;
         if(param1 is PClanTop)
         {
            _loc2_ = param1 as PClanTop;
            setPlace(_loc2_.place,TopClansDialog.searchLineCount);
            this.update2(_loc2_.name,_loc2_.icon,_loc2_.members_count,_loc2_.ratio,_loc2_.level,_loc2_.id);
         }
         else
         {
            _loc3_ = param1 as PBase;
            this.update2(_loc3_.name,_loc3_.icon,_loc3_.members_count,_loc3_.ratio,_loc3_.level,_loc3_.id);
         }
      }
      
      protected function update2(param1:String, param2:String, param3:uint, param4:uint, param5:uint, param6:String) : void
      {
         super.update(param1,param2,param3,param6);
         if(this.isCapital != param5 > 0 || !this.capitalSkin.isContent)
         {
            this.isCapital = param5 > 0;
            SkinManager.applyEmbed(this.capitalSkin,this.isCapital ? "CapitalFlagIcon" : "CapitalIcon");
            this.capitalSkin.alpha = this.levelText.alpha = this.isCapital ? 1 : 0.5;
            this.levelText.setColor(this.isCapital ? Style.redRGB : Style.metalRGB);
            if(this.capitalBt)
            {
               this.capitalBt.disabled = !this.isCapital;
               this.capitalBt.alpha = this.capitalSkin.alpha;
            }
         }
         this.levelText.value = param5.toString();
         this.ratingStat.value = param4;
         if(this.capitalBt)
         {
            this.capitalBt.data = param6;
            if(Boolean(Facade.userProxy.clan && param6 == Facade.userProxy.clan.uc_clan_id) != Boolean(this.myFill))
            {
               if(this.myFill)
               {
                  remove(this.myFill);
                  this.myFill = null;
               }
               else
               {
                  this.myFill = new VFill(16250930,0.4);
                  addStretch(this.myFill,0);
               }
            }
         }
      }
   }
}

