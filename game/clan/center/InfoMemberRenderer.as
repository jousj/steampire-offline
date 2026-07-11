package game.clan.center
{
   import proto.model.PUserBase;
   import proto.model.clan.PMember;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.vbase.VFill;
   import ui.vbase.VRenderer;
   import ui.vbase.VText;
   
   public class InfoMemberRenderer extends VRenderer
   {
      
      private const levelPanel:LevelPanel = new LevelPanel(LevelPanel.size28);
      
      private const nameText:VText = UIFactory.createYellowText(null,VText.CONTAIN);
      
      private const statusText:VText = new VText(null,VText.CONTAIN,Style.grayGlowRGB,14);
      
      private var fill:VFill;
      
      public function InfoMemberRenderer()
      {
         super();
         layoutH = 48;
         add(this.levelPanel,{
            "vCenter":0,
            "left":10
         });
         add(this.nameText,{
            "left":50,
            "right":10,
            "top":8
         });
         add(this.statusText,{
            "left":50,
            "right":10,
            "bottom":5
         });
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PMember = param1 as PMember;
         var _loc3_:PUserBase = _loc2_.user_base;
         this.levelPanel.changeSNetwork(_loc3_.snetwork);
         this.levelPanel.value = _loc3_.level;
         this.nameText.value = _loc3_.name;
         this.statusText.value = Lang.getString("clan_role" + _loc2_.role.variance);
         var _loc4_:Boolean = _loc3_.user_id == Preloader.uid;
         if(_loc4_ != Boolean(this.fill))
         {
            if(_loc4_)
            {
               this.fill = new VFill(16250930,0.4);
               addStretch(this.fill,0);
            }
            else
            {
               remove(this.fill);
               this.fill = null;
            }
         }
      }
   }
}

