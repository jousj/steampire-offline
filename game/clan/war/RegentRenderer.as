package game.clan.war
{
   import proto.model.PUserBase;
   import proto.model.clan.PMember;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VFill;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class RegentRenderer extends VRenderer
   {
      
      private const levelPanel:LevelPanel = new LevelPanel(LevelPanel.size28);
      
      private const nameText:VText = UIFactory.createYellowText(null,VText.CONTAIN);
      
      private const statusText:VText = new VText(null,VText.CONTAIN,Style.metalRGB,14);
      
      private const ratingStat:StatPanel = new StatPanel(SkinManager.getEmbed("RatingIcon"));
      
      private const toBt:VButton = VButton.createEmbed(RectButton.GREEN,VSkin.STRETCH,SkinManager.getEmbed("SearchIcon"),{
         "hCenter":0,
         "vCenter":0,
         "w":25
      });
      
      private var setBt:VButton;
      
      private var fill:VFill;
      
      public function RegentRenderer()
      {
         super();
         layoutH = 55;
         add(this.levelPanel,{
            "vCenter":0,
            "left":8
         });
         add(this.nameText,{
            "left":48,
            "w":264,
            "top":10
         });
         add(this.statusText,{
            "left":48,
            "w":264,
            "bottom":8
         });
         add(this.ratingStat,{
            "hCenter":1,
            "vCenter":1,
            "maxW":100
         });
         this.addSetBt(0);
         this.toBt.hint = Lang.getString("to_friend");
         this.toBt.setSize(44,30);
         this.toBt.addVarianceListener(this,2,[null,null]);
         add(this.toBt,{
            "vCenter":0,
            "right":20
         });
      }
      
      private function addSetBt(param1:uint) : void
      {
         if(this.setBt)
         {
            remove(this.setBt);
         }
         this.setBt = RectButton.createIconAndTitle(SkinManager.getEmbed(param1 == 0 ? "GuardIcon" : "NoIcon"),Lang.getString(param1 == 0 ? "select" : "resetBt"),18,RectButton.ORANGE,204,4,RectButton.h30);
         this.setBt.addVarianceListener(this,param1);
         add(this.setBt,{
            "vCenter":0,
            "right":74,
            "minW":160
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PMember = param1 as PMember;
         var _loc3_:PUserBase = _loc2_.user_base;
         if(_loc3_.th_level == 1 != Boolean(this.fill))
         {
            if(this.fill)
            {
               remove(this.fill);
               this.fill = null;
               this.addSetBt(0);
            }
            else
            {
               this.fill = new VFill(16250930,0.4);
               addStretch(this.fill,0);
               this.addSetBt(1);
            }
         }
         this.levelPanel.changeSNetwork(_loc3_.snetwork);
         this.levelPanel.value = _loc3_.level;
         this.nameText.value = _loc3_.name;
         this.statusText.value = Lang.getString("clan_role" + _loc2_.role.variance);
         this.ratingStat.value = _loc3_.ratio;
         this.setBt.data = _loc2_;
         this.toBt.data[0] = _loc3_.user_id;
         this.toBt.data[1] = dataIndex;
      }
   }
}

