package game.destruction
{
   import proto.model.PCost;
   import ui.Style;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CostHelper;
   
   public class DestructionDialog extends BaseDialog
   {
      
      private const ratingStat:StatPanel;
      
      public function DestructionDialog(param1:VODestruction)
      {
         var _loc3_:Vector.<VComponent> = null;
         var _loc4_:PCost = null;
         var _loc5_:RectButton = null;
         var _loc6_:VComponent = null;
         var _loc7_:StatPanel = null;
         this.ratingStat = new StatPanel(SkinManager.getEmbed("RatingIcon"),null,StatPanel.RED_TEXT,3,40,18);
         super();
         setSize(539,328);
         add(SkinManager.getEmbed("FeatureSectionBg",VSkin.STRETCH_BG),{
            "wP":100,
            "top":40,
            "bottom":0
         });
         add(SkinManager.getExternal("sob_cannons",SkinManager.JPG),{
            "left":10,
            "top":56,
            "w":520
         });
         add(SkinManager.getEmbed("DialogTop",VSkin.STRETCH_BG),{"wP":100});
         addDialogTitle(Lang.getString("attack_my_base"),true,40);
         add(SkinManager.getEmbed("ResBeigeBg",VSkin.STRETCH),{
            "bottom":190,
            "left":80,
            "right":80,
            "h":33
         });
         add(new VText(Lang.getString("count_attacks"),VText.CONTAIN_CENTER,Style.metalRGB,18),{
            "left":80,
            "right":100,
            "top":113
         });
         add(new VText(param1.humiliationCount.toString(),VText.CONTAIN_CENTER,Style.redRGB,20),{
            "maxW":50,
            "top":112,
            "left":374
         });
         var _loc2_:VComponent = new VComponent();
         _loc2_.addStretch(SkinManager.getEmbed("ResBeigeBg",VSkin.STRETCH));
         _loc2_.add(this.ratingStat,{
            "left":-10,
            "right":15,
            "vCenter":0
         });
         _loc2_.layoutH = this.ratingStat.measuredHeight - 10;
         this.ratingStat.text.value = param1.ratioCount.toString();
         _loc3_ = new Vector.<VComponent>();
         for each(_loc4_ in param1.resourceSteal)
         {
            _loc6_ = new VComponent();
            _loc6_.addStretch(SkinManager.getEmbed("ResBeigeBg",VSkin.STRETCH));
            _loc7_ = new StatPanel(SkinManager.getEmbed(CostHelper.getKind(_loc4_.variance,false)),null,StatPanel.RED_TEXT,3,40,18);
            _loc6_.add(_loc7_,{
               "left":-10,
               "right":15,
               "vCenter":0
            });
            _loc6_.layoutH = _loc7_.measuredHeight - 10;
            _loc7_.text.value = _loc4_.value.toString();
            _loc3_.push(_loc6_);
         }
         _loc3_.push(_loc2_);
         add(new VBox(_loc3_,25),{
            "bottom":125,
            "hCenter":0
         });
         _loc5_ = new RectButton(Lang.getString("repair_base"),RectButton.h56);
         add(_loc5_,{
            "bottom":40,
            "hCenter":0
         });
         _loc5_.addClickListener(onBtClose);
      }
   }
}

