package game.clan.war
{
   import game.common.DialogMediator;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import model.CommonEvent;
   import proto.BinaryBuffer;
   import proto.game.family_0002.Packet_0002_01;
   import proto.game.family_0060.Packet_0060_1D;
   import proto.game.family_0060.Packet_0060_1E;
   import proto.game.family_0060.Packet_0060_20;
   import proto.game.family_0060.Packet_0060_21;
   import proto.model.PCost;
   import proto.model.PPermission;
   import proto.model.PRaidEvent;
   import proto.model.PReferences;
   import proto.model.clan.PCapitalLogKind;
   import proto.model.clan.PClanTop;
   import proto.model.clan.PTopRequest;
   import proto.model.clan.PWar;
   import proto.tuples.i_i;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.MessageDialog;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class WarMediator extends DialogMediator
   {
      
      public const dialog:VComponent = new VComponent();
      
      private var page:VComponent;
      
      private var isWarLoad:Boolean;
      
      private var warRequest:PTopRequest;
      
      public function WarMediator()
      {
         super();
      }
      
      public static function getCurWarPoints(param1:PWar) : i_i
      {
         return i_i.create(calcWarPoints(param1.war_points,param1.war_points_lat,param1.war_storm),calcWarPoints(param1.war_enemy_points,param1.war_points_lat,param1.war_my_storm));
      }
      
      private static function calcWarPoints(param1:int, param2:Number, param3:Number) : int
      {
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc4_:PReferences = Facade.references;
         if(param1 < _loc4_.wp_storm_req)
         {
            _loc5_ = !isNaN(param3);
            if((_loc5_) && param2 < param3)
            {
               _loc6_ = Math.floor((param3 - param2) / _loc4_.wp_generation);
               if(_loc6_ > 0)
               {
                  param1 += _loc6_;
                  param2 += _loc6_ * _loc4_.wp_generation;
               }
            }
            _loc6_ = Math.floor((CoreLogic.serverTime - param2) / (_loc5_ ? _loc4_.wp_generation_during_storm : _loc4_.wp_generation));
            if(_loc6_ > 0)
            {
               param1 += _loc6_;
            }
         }
         return param1 > _loc4_.wp_storm_req ? _loc4_.wp_storm_req : param1;
      }
      
      override public function onAdd() : BaseDialog
      {
         this.assign();
         Facade.addListenerForComponent(CommonEvent.MY_GAME_STREAM,this.onGameStream,this.dialog);
         return null;
      }
      
      private function setPage(param1:VComponent) : void
      {
         if(this.page)
         {
            this.dialog.remove(this.page);
         }
         this.page = param1;
         this.page.addListener(VEvent.VARIANCE,this.onVariance);
         this.dialog.add(this.page,{
            "hCenter":0,
            "top":0
         });
      }
      
      private function getWarDp(param1:int) : void
      {
         var _loc3_:String = null;
         var _loc2_:StartWarPanel = this.page as StartWarPanel;
         if(this.isWarLoad)
         {
            _loc2_.loadMode = true;
            return;
         }
         if(param1 < 0)
         {
            _loc3_ = StringHelper.trim(_loc2_.inputText.value);
            if(_loc3_ != null)
            {
               _loc3_ = _loc3_.replace(/ {2,}/g," ").toLowerCase();
            }
            else
            {
               _loc3_ = "";
            }
            if(_loc3_ == this.warRequest.name)
            {
               return;
            }
            this.warRequest.name = _loc3_;
            this.warRequest.from_place = 0;
         }
         else
         {
            this.warRequest.from_place = param1;
         }
         _loc2_.loadMode = this.isWarLoad = true;
         if(Facade.userProxy.clanData)
         {
            this.warRequest.division = Facade.userProxy.clanData.base.division;
         }
         else
         {
            this.warRequest.division = NaN;
         }
         Facade.protoProxy.request(new Packet_0060_1D(this.warRequest),this.resultWarDp,96,30);
      }
      
      private function resultWarDp(param1:BinaryBuffer) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc5_:PClanTop = null;
         this.isWarLoad = false;
         if(!up.clanData.war && this.page is StartWarPanel && Boolean(this.dialog.parent))
         {
            _loc2_ = new Packet_0060_1E(param1).value;
            _loc3_ = Facade.userProxy.clan.uc_clan_id;
            _loc4_ = int(_loc2_.length - 1);
            while(_loc4_ >= 0)
            {
               _loc5_ = _loc2_[_loc4_] as PClanTop;
               if(_loc5_.id == _loc3_)
               {
                  _loc2_.splice(_loc4_,1);
               }
               else if(_loc5_.name == "RedSpell")
               {
                  (_loc5_.war_params.wp_price[0] as PCost).value = 50000000;
               }
               _loc4_--;
            }
            _loc4_ = _loc2_.length > 0 ? int((_loc2_[0] as PClanTop).full_cnt) : 0;
            if(_loc4_ > 0)
            {
               _loc4_--;
            }
            (this.page as StartWarPanel).change(this.warRequest.from_place,_loc2_,_loc4_);
         }
      }
      
      private function startWar(param1:PClanTop, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:PCost = null;
         if(up.checkClanRolePermission(PPermission.INIT_WAR))
         {
            _loc3_ = Math.floor(Facade.manualProxy.getClanCapacity(up.clanData.clanhall_level) * 0.4);
            if(up.clanData.base.members_count < _loc3_)
            {
               Facade.mainMediator.showMessage(Lang.getPatternString("bad_war_members","__VALUE__",StringHelper.getTLFImage("lib,MembersIcon",22) + _loc3_.toString()),Lang.getString("start_war_title"),this.getWarIconPanel(param1));
               return;
            }
            _loc4_ = param1.war_params.wp_price[0];
            _loc3_ = up.checkClanCost(_loc4_);
            if(_loc3_ > 0)
            {
               CostHelper.showResourceMessage(_loc4_,"start_war_title","bad_war_price",_loc3_);
            }
            else if(param2)
            {
               up.changeClanResource(_loc4_,true,PCapitalLogKind.START_WAR);
               Facade.protoProxy.request(new Packet_0060_20(param1.id),this.resultWar,0,0,[param1]);
            }
            else
            {
               Facade.mainMediator.showDialog(new MessageDialog(Lang.getReplaceString("start_war_prompt",{
                  "__NAME__":"<span" + Style.redColor + ">" + StringHelper.addCDATA(param1.name) + "</span>",
                  "__COST__":CostHelper.getClanString(_loc4_.variance,_loc4_.value,true)
               }),Lang.getString("start_war_title"),this.getWarIconPanel(param1,false)).addDelegateRectButton(Lang.getString("cancelBt")).addDelegateRectButton(Lang.getString("start_war"),this.startWar,[param1,true],RectButton.ORANGE));
            }
         }
         else
         {
            Facade.mainMediator.showMessage(Lang.getString("start_war_permission"),Lang.getString("start_war_title"),this.getWarIconPanel(param1));
         }
      }
      
      private function getWarIconPanel(param1:PClanTop, param2:Boolean = true) : VComponent
      {
         var _loc3_:VComponent = new VComponent();
         _loc3_.add(SkinManager.getEmbed("WarFireImg"),{
            "hCenter":0,
            "vCenter":0,
            "w":140
         });
         _loc3_.add(SkinManager.getPack(UIFactory.EMBLEM_PACK,up.clan.uc_icon),{
            "w":94,
            "h":94,
            "left":-8,
            "top":-8
         });
         _loc3_.add(SkinManager.getPack(UIFactory.EMBLEM_PACK,param1.icon),{
            "w":94,
            "h":94,
            "bottom":-8,
            "right":-8
         });
         _loc3_.add(UIFactory.createDecorText("VS",true,34,0,false),{
            "hCenter":0,
            "vCenter":0
         });
         if(param2)
         {
            _loc3_.filters = VSkin.GREY_FILTER;
         }
         return _loc3_;
      }
      
      private function resultWar(param1:BinaryBuffer, param2:PClanTop) : void
      {
         if(param1.family == 96 && param1.subfamily == 33)
         {
            Facade.myMediator.changeWar(new Packet_0060_21(param1).value);
         }
         else if(Facade.isMyMap)
         {
            Facade.mainMediator.showMessage(Lang.getPatternString("start_war_bad","__NAME__","<span" + Style.redColor + ">" + StringHelper.addCDATA(param2.name) + "</span>"));
         }
         if(this.dialog.parent)
         {
            this.assign();
         }
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:uint = param1.variance;
         switch(_loc2_)
         {
            case WarVariance.PVP_SEARCH:
               DialogLogic.openWarEnemy();
               break;
            case WarVariance.INFO:
               DialogLogic.openClanAbout(String(param1.data));
               break;
            case WarVariance.TO_STORM:
               Facade.setMapCallback(DialogLogic.openWar);
               Facade.myMediator.toStorm(param1.data);
               break;
            case WarVariance.TO_WAR_LIST:
               DialogLogic.openWarList();
               break;
            case WarVariance.LOG:
               Facade.mainMediator.showDialog(param1.data is Array ? new WarLogsMediator(param1.data[0],param1.data[1]) : new WarLogsMediator(param1.data));
               break;
            case WarVariance.SEARCH:
               this.getWarDp(param1.data is uint ? int(param1.data) : -1);
               break;
            case WarVariance.START:
               this.startWar(param1.data as PClanTop,false);
         }
      }
      
      private function assign(param1:VEvent = null) : void
      {
         var _loc3_:i_i = null;
         var _loc4_:int = 0;
         var _loc2_:PWar = up.clanData.war;
         if(_loc2_)
         {
            _loc3_ = getCurWarPoints(_loc2_);
            _loc4_ = Facade.references.wp_storm_req;
            if(_loc2_.war_enemy_townhall_level == 0 && _loc3_.field_0 == _loc4_ || !up.clanData.base.has_capital && _loc3_.field_1 == _loc4_)
            {
               Facade.protoProxy.request(new Packet_0002_01(Packet_0002_01.CHECK_FINISH_WAR,null));
               Facade.myMediator.changeWar(null);
               this.assign();
               return;
            }
            if(this.page is ClanWarPanel)
            {
               (this.page as ClanWarPanel).sync(_loc3_.field_0,_loc3_.field_1);
            }
            else
            {
               this.setPage(new ClanWarPanel(up.clanData,_loc3_.field_0,_loc3_.field_1));
               this.page.addListener(VEvent.CHANGE,this.assign);
            }
         }
         else
         {
            if(!this.warRequest)
            {
               this.warRequest = getDialogSetting() as PTopRequest;
               if(!this.warRequest)
               {
                  this.warRequest = PTopRequest.create("",0,4,false,true,NaN);
                  setDialogSetting(this.warRequest);
               }
            }
            if(!(this.page is StartWarPanel))
            {
               this.setPage(new StartWarPanel(this.warRequest));
            }
            this.getWarDp(this.warRequest.from_place);
         }
      }
      
      private function onGameStream(param1:CommonEvent) : void
      {
         var _loc2_:PRaidEvent = param1.data;
         switch(_loc2_.variance)
         {
            case PRaidEvent.INC_WARPOINTS:
            case PRaidEvent.START_WAR:
            case PRaidEvent.FINISH_WAR:
               this.assign();
               break;
            case PRaidEvent.DEL_CLAN_MEMBER:
               if(_loc2_.value == Preloader.uid)
               {
               }
         }
      }
   }
}

