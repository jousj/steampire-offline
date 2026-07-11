package game.friends
{
   import flash.display.BlendMode;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.TabPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VInputText;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class FriendsDialog extends BaseDialog
   {
      
      public var tabPanel:TabPanel;
      
      public var grid:VGrid;
      
      public var type:String;
      
      public const input:VInputText;
      
      private var separatorFill:VFill;
      
      public function FriendsDialog(param1:Boolean, param2:String = null, param3:String = null)
      {
         var _loc4_:VSkin = null;
         this.input = UIFactory.createInputText(16,Lang.getString("friend_search"));
         super();
         useDefaultBg(638,param3 ? param3 : Lang.getString("friends"));
         add(SkinManager.getEmbed("DialogGears3",VSkin.FLIP_Y | VSkin.FLIP_X),{
            "right":2,
            "bottom":17
         });
         if(param1)
         {
            add(SkinManager.getEmbed("DialogGears2"),{
               "top":64,
               "right":22
            });
            if(param2)
            {
               add(SkinManager.getEmbed("InfoIcon"),{
                  "left":48,
                  "top":82,
                  "h":35
               });
               _loc4_ = SkinManager.getEmbed("ChatSayBg",VSkin.STRETCH);
               _loc4_.blendMode = BlendMode.LAYER;
               _loc4_.alpha = 0.25;
               add(_loc4_,{
                  "left":74,
                  "top":78,
                  "w":460,
                  "h":40
               });
               add(new VText(Lang.getString(param2 + "_help"),VText.MIDDLE,Style.metalRGB,14),{
                  "left":90,
                  "top":82,
                  "w":436,
                  "h":31
               });
            }
         }
         else
         {
            add(new VFill(12235690),{
               "left":2,
               "right":2,
               "top":40,
               "h":70
            },1);
            this.tabPanel = new TabPanel();
            this.tabPanel.init(new <String>[Lang.getString("friends"),Lang.getString("clan_my")],0);
            add(this.tabPanel,{
               "left":2,
               "right":2,
               "top":76
            });
         }
         add(this.input,{
            "right":16,
            "top":(param1 ? 82 : 74),
            "w":220
         });
         this.type = param2;
         this.grid = new VGrid(4,2,this.createRenderer,null,11,21);
         this.grid.dispatcher = this;
         this.grid.emptyFactory = this.emptyFactory;
         add(this.grid,{
            "top":124,
            "hCenter":0
         });
         UIFactory.useGridControlH43(this.grid,false);
      }
      
      private function createRenderer() : FriendRenderer
      {
         return new FriendRenderer(this.type);
      }
      
      private function emptyFactory() : VComponent
      {
         return UIFactory.createEmptyGridMessage("");
      }
      
      public function set emptyText(param1:String) : void
      {
         var _loc3_:VText = null;
         var _loc2_:VComponent = this.grid.getEmptyComponent();
         if(Boolean(_loc2_) && _loc2_.numChildren > 0)
         {
            _loc3_ = _loc2_.getChildAt(_loc2_.numChildren - 1) as VText;
            if(_loc3_)
            {
               _loc3_.value = param1;
            }
         }
         if(this.separatorFill)
         {
            this.grid.remove(this.separatorFill);
            this.separatorFill = null;
         }
      }
      
      public function syncDp(param1:uint) : void
      {
         this.grid.sync(param1);
         if(this.grid.length > 0 && !this.separatorFill)
         {
            this.separatorFill = new VFill(6255476,1);
            this.grid.add(this.separatorFill,{
               "left":10,
               "right":10,
               "h":1,
               "vCenter":3
            });
         }
      }
   }
}

