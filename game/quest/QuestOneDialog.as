package game.quest
{
   import model.vo.VOQuest;
   import ui.common.BaseDialog;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   
   public class QuestOneDialog extends BaseDialog
   {
      
      public const renderer:QuestRenderer;
      
      public function QuestOneDialog(param1:VOQuest, param2:Boolean = false)
      {
         var _loc3_:VButton = null;
         this.renderer = new QuestRenderer(false);
         super();
         useSimpleBg(800,260,Lang.getString(param1.kind));
         this.renderer.dispatcher = this;
         this.renderer.setData(param1);
         add(this.renderer,{
            "hCenter":0,
            "top":71
         });
         if(param2)
         {
            _loc3_ = VButton.createEmbed("BtArrow",0,SkinManager.getEmbed("AllQuestIcon"),{
               "hCenter":-3,
               "vCenter":-3,
               "h":50
            });
            _loc3_.hint = Lang.getString("bt_allQuest");
            add(_loc3_,{
               "left":64,
               "bottom":-15
            });
            _loc3_.addVarianceListener(this,QuestDialog.SHOW_ALL_QUEST,param1);
         }
      }
   }
}

