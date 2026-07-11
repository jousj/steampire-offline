package game.clan.war
{
   import clans.ClanDialog;
   import clans.ClanMedialor;
   import game.common.DialogMediator;
   import logic.DialogLogic;
   import logic.MainLogic;
   import model.CommonEvent;
   import proto.BinaryBuffer;
   import proto.game.family_0060.Packet_0060_35;
   import proto.game.family_0060.Packet_0060_36;
   import proto.game.family_0060.Packet_0060_37;
   import proto.model.PClanWarOpponent;
   import proto.model.PClanWarOpponents;
   import proto.model.PFightKind2;
   import proto.model.PWarOpponent;
   import proto.model.clan.PBase;
   import proto.model.clan.PClan;
   import proto.model.clan.PWar;
   import ui.Style;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.game.ResourcePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class WarEnemyMediator extends DialogMediator
   {
      
      private var dialog:BaseDialog;
      
      private var grid:VGrid;
      
      public function WarEnemyMediator()
      {
         super();
      }
      
      override public function onAdd() : BaseDialog
      {
         if(!Facade.userProxy.clan)
         {
            return null;
         }
         this.dialog = new BaseDialog();
         this.dialog.useSimpleBg(734,0);
         this.dialog.addDialogTitle(Lang.getString("search_clan_enemy"),false,244);
         var _loc1_:PClan = Facade.userProxy.clanData;
         if(!_loc1_)
         {
            Facade.addListenerForComponent(CommonEvent.MY_GAME_STREAM,this.onClanData,this.dialog);
            this.dialog.add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH),{
               "left":20,
               "right":20,
               "top":84,
               "bottom":34,
               "h":300
            });
            this.dialog.add(new VText(Lang.getString("load_title"),VText.CENTER,Style.darkKhakiRGB),{
               "left":40,
               "right":40,
               "vCenter":21
            });
         }
         else
         {
            if(!_loc1_.war)
            {
               return null;
            }
            this.onLoad(_loc1_);
         }
         return this.dialog;
      }
      
      private function onClanData(param1:CommonEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:PClan = Facade.userProxy.clanData;
         if(!_loc2_ || !_loc2_.war)
         {
            this.dialog.close();
         }
         else
         {
            _loc3_ = this.dialog.numChildren;
            (this.dialog.removeChildAt(_loc3_ - 1) as VComponent).dispose();
            (this.dialog.removeChildAt(_loc3_ - 2) as VComponent).dispose();
            this.onLoad(_loc2_);
         }
      }
      
      private function onLoad(param1:PClan) : void
      {
         var _loc3_:PBase = null;
         var _loc4_:ResourcePanel = null;
         var _loc2_:PWar = param1.war;
         _loc3_ = param1.base;
         _loc4_ = new ResourcePanel(SkinManager.getEmbed("MoralIcon"),ResourcePanel.BG | ResourcePanel.PROGRESS,"LightGreenIndicator");
         _loc4_.hint = "<p" + Style.metalColor + ">" + Lang.getString("war_points") + "</p>" + _loc2_.war_points + "/" + Facade.references.wp_storm_req;
         _loc4_.setDataEx(_loc2_.war_points,Facade.references.wp_storm_req);
         this.dialog.add(_loc4_,{
            "top":13,
            "right":68
         });
         var _loc5_:VComponent = new VComponent();
         this.dialog.add(_loc5_,{
            "left":20,
            "right":20,
            "top":80
         });
         ClanWarPanel.addVs(_loc5_,_loc3_.name,_loc3_.icon,null,_loc2_.war_enemy_name,_loc2_.war_enemy_icon,null,_loc2_.war_start_time);
         this.dialog.add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH),{
            "top":200,
            "left":18,
            "right":18,
            "bottom":36
         });
         this.grid = new VGrid(1,3,WarEnemyRenderer,null,0,15,VGrid.H_STRETCH | VGrid.USE_VISIBLE_CALC_LAYOUT);
         this.grid.dispatcher = this.dialog;
         this.grid.emptyFactory = this.emptyFactory;
         this.dialog.add(this.grid,{
            "left":45,
            "right":45,
            "top":226,
            "bottom":68
         });
         var _loc6_:RectButton = new RectButton(Lang.getString("to_war_tab"),RectButton.h42);
         _loc6_.addVarianceListener(this.dialog,4,true);
         this.dialog.add(_loc6_,{
            "hCenter":0,
            "bottom":-10
         });
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         this.loadDp();
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc4_:ClanDialog = null;
         var _loc5_:ClanMedialor = null;
         var _loc2_:uint = param1.variance;
         var _loc3_:PWarOpponent = param1.data as PWarOpponent;
         if(_loc2_ == 1)
         {
            Facade.setMapCallback(DialogLogic.openWarEnemy);
            MainLogic.getFriendMap(_loc3_.wo_id);
         }
         else if(_loc2_ == 2)
         {
            Facade.mainMediator.showYesNoDialog(Lang.getPatternString("skip_enemy_prompt","__NAME__","<span" + Style.redColor + ">" + StringHelper.addCDATA(_loc3_.wo_name) + "</span>"),this.confirmSkip,[_loc3_],Lang.getString("skip_clan_enemy"),SkinManager.getEmbed("ArmyCapacityIcon"));
         }
         else if(_loc2_ == 3)
         {
            if(MainLogic.checkArmy())
            {
               Facade.myMediator.checkShieldAndCall(MainLogic.getRivalMap,[PFightKind2.create(PFightKind2.USER_WAR_TARGET,_loc3_.wo_id)]);
            }
         }
         else if(_loc2_ == 4)
         {
            _loc4_ = Facade.mainMediator.searchDialog(ClanDialog);
            if(!_loc4_)
            {
               _loc5_ = new ClanMedialor();
               DialogLogic.open(_loc5_);
               _loc5_.dialog.setTab(ClanDialog.WAR);
            }
            this.dialog.close();
         }
         else if(_loc2_ == 5)
         {
            this.loadDp();
         }
      }
      
      private function loadDp() : void
      {
         this.grid.setDataProvider(null);
         Facade.protoProxy.request(new Packet_0060_35(),this.resultDp,96,54);
      }
      
      private function resultDp(param1:BinaryBuffer) : void
      {
         if(!this.dialog.parent)
         {
            return;
         }
         var _loc2_:PClanWarOpponents = new Packet_0060_36(param1).value;
         var _loc3_:Array = _loc2_.opponents;
         var _loc4_:* = int(_loc3_.length - 1);
         while(_loc4_ >= 0)
         {
            if((_loc3_[_loc4_] as PClanWarOpponent).variance == PClanWarOpponent.NONE)
            {
               if(_loc3_.length == 1)
               {
                  (_loc3_[_loc4_] as PClanWarOpponent).value = _loc2_.new_search_at;
               }
               else
               {
                  _loc3_.splice(_loc4_,1);
               }
            }
            _loc4_--;
         }
         if(_loc3_.length == 0)
         {
            _loc3_.push(PClanWarOpponent.create(PClanWarOpponent.NONE,_loc2_.new_search_at));
         }
         this.grid.setDataProvider(_loc3_);
      }
      
      private function confirmSkip(param1:PWarOpponent) : void
      {
         Facade.protoProxy.request(new Packet_0060_37(param1.wo_id));
         this.loadDp();
      }
      
      private function emptyFactory() : VComponent
      {
         var _loc1_:VText = new VText(Lang.getString("load_title"),VText.CENTER,Style.darkKhakiRGB);
         _loc1_.assignLayout({
            "vCenter":1,
            "left":50,
            "right":50
         });
         return _loc1_;
      }
   }
}

