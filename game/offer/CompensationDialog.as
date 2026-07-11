package game.offer
{
   import proto.model.PCost;
   import proto.model.POreSpellCompensation;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class CompensationDialog extends BaseDialog
   {
      
      public function CompensationDialog(param1:POreSpellCompensation)
      {
         var _loc7_:uint = 0;
         super();
         useWhiteBg(0,424,Lang.getString("compensation_title"),false);
         minW = 540;
         var _loc2_:VSkin = SkinManager.getEmbed("StatBg",VSkin.STRETCH_BG);
         _loc2_.alpha = 0.5;
         add(_loc2_,{
            "left":25,
            "right":25,
            "top":85,
            "h":70
         });
         add(SkinManager.getExternal("un_hero_jaina1",SkinManager.PNG | SkinManager.LOAD_CLIP),{
            "left":23,
            "top":70,
            "w":85,
            "h":88
         });
         add(new VText(Lang.getString("compensation_msg"),VComponent.SKIP_CONTENT_SIZE,Style.metalRGB,14),{
            "left":108,
            "right":36,
            "top":96,
            "h":48
         });
         var _loc3_:Array = param1.spells;
         if(param1.blue_ore > 0)
         {
            _loc3_.unshift(PCost.create(PCost.BLUE_ORE,param1.blue_ore));
         }
         if(param1.green_ore > 0)
         {
            _loc3_.unshift(PCost.create(PCost.GREEN_ORE,param1.green_ore));
         }
         if(param1.red_ore > 0)
         {
            _loc3_.unshift(PCost.create(PCost.RED_ORE,param1.red_ore));
         }
         if(_loc3_.length >= 6)
         {
            _loc7_ = 6;
         }
         else if(_loc3_.length <= 4)
         {
            _loc7_ = 4;
         }
         else
         {
            _loc7_ = _loc3_.length;
         }
         var _loc4_:VGrid = new VGrid(_loc7_,1,CompensationRenderer,_loc3_,14,0,VGrid.USE_NULL_DATA);
         UIFactory.useGridControlNav(_loc4_,UIFactory.addNavBt30);
         var _loc5_:CompensationRenderer = new CompensationRenderer();
         _loc5_.setData(PCost.create(PCost.GOLD,param1.gold));
         add(new VBox(new <VComponent>[new VText(Lang.getString("sold"),0,Style.redRGB,16),_loc4_,new VText(Lang.getString("received"),0,Style.greenRGB,16),_loc5_],7,VBox.VERTICAL | VBox.CENTER),{
            "top":166,
            "left":30,
            "right":30
         });
         var _loc6_:RectButton = new RectButton(Lang.getString("bt_ok"),RectButton.h56);
         add(_loc6_,{
            "bottom":-22,
            "hCenter":0
         });
         _loc6_.addClickListener(close);
      }
   }
}

