package game.guard
{
   import engine.units.Build;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.common.TabPanel;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class TabPanelGuard extends TabPanel
   {
      
      public function TabPanelGuard(param1:uint = 5, param2:Boolean = true, param3:int = 6)
      {
         super(param1,param2,param3);
      }
      
      protected function createTabBuild(param1:Build) : VButton
      {
         var _loc2_:VButton = null;
         _loc2_ = VButton.create(new VSkin(VSkin.TOP | VSkin.STRETCH),null,new VBox(new <VComponent>[UIFactory.createYellowText(Lang.getString("tower"),VText.CONTAIN_CENTER,16),new LevelPanel(LevelPanel.size28,param1.level)]),{
            "top":13,
            "hCenter":0,
            "h":16
         });
         _loc2_.skin.layoutW = -100;
         _loc2_.layoutH = 45;
         return _loc2_;
      }
      
      public function initList(param1:Vector.<Build>, param2:uint = 0) : void
      {
         var _loc4_:Build = null;
         var _loc5_:VButton = null;
         box.removeAll();
         var _loc3_:uint = 0;
         for each(_loc4_ in param1)
         {
            _loc5_ = this.createTabBuild(_loc4_);
            _loc5_.variance = _loc3_;
            _loc5_.addClickListener(onClick,_loc3_);
            if(_loc3_ == param2)
            {
               activeBt = _loc5_;
               applyActive(_loc5_,true);
            }
            else
            {
               applyActive(_loc5_,false);
            }
            _loc3_++;
            box.list.push(_loc5_);
         }
         box.addAll();
      }
   }
}

