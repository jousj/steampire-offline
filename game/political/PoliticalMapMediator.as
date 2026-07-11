package game.political
{
   import clans.ClanDialog;
   import flash.display.Graphics;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import game.clan.war.RegentRenderer;
   import game.common.DialogMediator;
   import logic.ActionLogic;
   import logic.DialogLogic;
   import logic.MainLogic;
   import model.CommonEvent;
   import proto.BinaryBuffer;
   import proto.game.family_0000.Packet_0000_03;
   import proto.game.family_0002.Packet_0002_01;
   import proto.game.family_0002.Packet_0002_02;
   import proto.game.family_0060.Packet_0060_2D;
   import proto.game.family_0060.Packet_0060_2E;
   import proto.game.family_0060.Packet_0060_2F;
   import proto.game.family_0060.Packet_0060_33;
   import proto.game.family_0060.Packet_0060_34;
   import proto.game.family_0060.Packet_0060_41;
   import proto.model.PClanDivision;
   import proto.model.PCost;
   import proto.model.PPermission;
   import proto.model.PRaidEvent;
   import proto.model.PShopMine;
   import proto.model.PShopTerritory;
   import proto.model.clan.PCapitalLogKind;
   import proto.model.clan.PMember;
   import proto.model.clan.PRegion;
   import proto.model.clan.PSetRegent;
   import proto.model.clan.PTerritory;
   import proto.model.clan.PTerritoryAttacker;
   import proto.model.clan.PTerritoryOwner;
   import proto.model.clan.PTerritoryState;
   import proto.tuples.time_a_str_a;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.MessageDialog;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import utils.CommonUtils;
   import utils.CostHelper;
   
   public class PoliticalMapMediator extends DialogMediator
   {
      
      public const dialog:PoliticalMapDialog = new PoliticalMapDialog();
      
      public const territoryList:Vector.<TerritoryPanel> = new Vector.<TerritoryPanel>();
      
      public const waitTerritoryList:Vector.<TerritoryPanel> = new Vector.<TerritoryPanel>();
      
      private var openArgs:Array;
      
      private var myClanMode:uint;
      
      private var myPanel:PoliticalMyPanel = new PoliticalMyPanel();
      
      private var grid:VGrid;
      
      private var curLeague:PClanDivision;
      
      private var x_max:uint;
      
      private var y_max:uint;
      
      private var posLeagueHash:Object;
      
      private var myTerritoryCount:uint;
      
      private var leagueDialog:BaseDialog;
      
      public function PoliticalMapMediator(param1:* = null, param2:int = -1)
      {
         super();
         if(param1 !== null || param2 >= 0)
         {
            this.openArgs = arguments;
         }
      }
      
      public static function checkClanPrice(param1:Array, param2:String = null) : Boolean
      {
         var _loc3_:PCost = Facade.userProxy.checkClanPrice(param1);
         if(_loc3_)
         {
            CostHelper.showResourceMessage(_loc3_,param2);
            return false;
         }
         return true;
      }
      
      public static function showLeagueDialog(param1:PClanDivision, param2:Number = -1, param3:String = null, param4:Boolean = true) : BaseDialog
      {
         var _loc5_:BaseDialog = new BaseDialog();
         _loc5_.useSimpleBg(814,592,param3 ? param3 : Lang.getString("league_about"));
         var _loc6_:ClanLeaguePanel = new ClanLeaguePanel(35,param4);
         if(param4)
         {
            _loc6_.toMapBt.addClickListener(onToPoliticalMap,_loc5_);
         }
         _loc5_.add(_loc6_,{
            "left":2,
            "right":2,
            "top":46,
            "bottom":36
         },1);
         _loc6_.assign(param1,Facade.userProxy.clanData ? int(Facade.userProxy.clanData.townhall_level) : 0);
         Facade.mainMediator.showDialog(_loc5_);
         _loc6_.request(param2 < 0 ? (param1.cd_num == Facade.userProxy.getClanLeagueNum() ? NaN : 0) : param2);
         return _loc5_;
      }
      
      private static function onToPoliticalMap(param1:MouseEvent) : void
      {
         if(!Facade.mainMediator.searchDialog(PoliticalMapMediator))
         {
            DialogLogic.openPoliticalMap();
         }
         ((param1.currentTarget as VButton).data as BaseDialog).close();
      }
      
      override public function onAdd() : BaseDialog
      {
         this.myPanel.assignLayout({
            "right":3,
            "top":80,
            "h":550,
            "w":246
         });
         this.myPanel.dispatcher = this.dialog;
         this.dialog.initStart(this.onPackComplete);
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         Facade.addListener(CommonEvent.MY_GAME_STREAM,this.onGameStream);
         return null;
      }
      
      override public function onRemove() : void
      {
         Facade.removeListener(CommonEvent.MY_GAME_STREAM,this.onGameStream);
         var _loc1_:* = int(this.waitTerritoryList.length - 1);
         while(_loc1_ >= 0)
         {
            this.waitTerritoryList[_loc1_].dispose();
            _loc1_--;
         }
         this.dialog.disposeFloat(this.myPanel);
         this.dialog.disposeFloat(this.grid);
         if(this.leagueDialog)
         {
            this.leagueDialog.close();
         }
      }
      
      private function onTabChange(param1:VEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:PClanDivision = null;
         var _loc6_:uint = 0;
         this.dialog.removeFloat(this.myPanel);
         this.dialog.removeFloat(this.grid);
         if(this.dialog.tabPanel.index == 1)
         {
            if(!this.grid)
            {
               _loc2_ = {};
               _loc3_ = Facade.userProxy.clanData ? int(Facade.userProxy.clanData.townhall_level) : 0;
               _loc4_ = [];
               for each(_loc5_ in mp.clanLeagueList)
               {
                  if(!_loc2_[_loc5_.cd_region] || _loc3_ == _loc5_.cd_num)
                  {
                     _loc2_[_loc5_.cd_region] = _loc5_;
                  }
               }
               for each(_loc5_ in _loc2_)
               {
                  _loc4_.push(_loc5_);
               }
               CommonUtils.sort(_loc4_,["cd_num"],[Array.NUMERIC | Array.DESCENDING]);
               _loc6_ = uint(_loc4_.indexOf(this.curLeague));
               this.grid = new VGrid(1,3,ClanLeagueRenderer,_loc4_,0,26,VGrid.SELECTED_MODE | VGrid.FLOAT_INDEX | VGrid.USE_END_LIMIT,_loc6_ - 2 > 0 ? uint(_loc6_ - 2) : 0);
               this.grid.assignLayout({
                  "right":25,
                  "vCenter":25
               });
               UIFactory.useGridControlV33(this.grid);
               this.grid.setSelected(_loc6_);
               this.grid.addListener(VEvent.SELECT,this.changeLeague);
            }
            this.dialog.add(this.grid);
         }
         else
         {
            this.dialog.add(this.myPanel);
         }
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:uint = param1.variance;
         switch(_loc2_)
         {
            case PoliticalMapDialog.TO_TOPS:
               DialogLogic.openTopClans();
               break;
            case PoliticalMapDialog.TO_CLAN:
               DialogLogic.openClanCenter();
               break;
            case PoliticalMapDialog.TO_DONATE:
               break;
            case PoliticalMapDialog.TO_LEAGUE:
               this.openLeague();
         }
      }
      
      private function onPackComplete(param1:VEvent) : void
      {
         var _loc3_:PClanDivision = null;
         var _loc4_:PShopTerritory = null;
         if(Boolean(param1) && !this.dialog.parent)
         {
            return;
         }
         this.posLeagueHash = {};
         var _loc2_:uint = 0;
         if(this.openArgs)
         {
            if(this.openArgs[0] is String)
            {
               _loc4_ = mp.getTerritoryShop(this.openArgs[0],true);
               if(_loc4_)
               {
                  _loc3_ = this.getLeagueByKind(_loc4_.ter_region);
               }
            }
            else if(this.openArgs[0] != null)
            {
               _loc3_ = Facade.manualProxy.getClanLeagueByNum(uint(this.openArgs[0]),true);
               this.openArgs = null;
               _loc2_ = 1;
            }
         }
         if(!_loc3_)
         {
            this.openArgs = null;
            _loc3_ = mp.getClanLeagueByNum(up.clanData ? uint(up.clanData.base.division) : 0);
         }
         this.dialog.initEnd(_loc2_);
         this.changeLeague(_loc3_);
         this.dialog.tabPanel.addListener(VEvent.CHANGE,this.onTabChange);
         this.onTabChange(null);
         this.syncClanInfo();
      }
      
      private function changeLeague(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:PClanDivision = null;
         var _loc4_:TerritoryPanel = null;
         var _loc5_:Point = null;
         if(param1 is VEvent)
         {
            _loc3_ = this.grid.getData((param1 as VEvent).variance) as PClanDivision;
         }
         else
         {
            _loc3_ = param1 as PClanDivision;
            if(this.grid)
            {
               this.grid.setSelected(this.grid.getDataProvider().indexOf(_loc3_));
            }
         }
         if(this.curLeague != _loc3_ || param2)
         {
            if(this.curLeague)
            {
               _loc5_ = this.posLeagueHash[this.curLeague.cd_num] as Point;
               if(!_loc5_)
               {
                  _loc5_ = new Point();
                  this.posLeagueHash[this.curLeague.cd_num] = _loc5_;
               }
               _loc5_.x = this.dialog.mapPanel.x;
               _loc5_.y = this.dialog.mapPanel.y;
            }
            for each(_loc4_ in this.territoryList)
            {
               _loc4_.removeFromParent(false);
               this.waitTerritoryList.push(_loc4_);
            }
            this.territoryList.length = 0;
            this.dialog.setMap(_loc3_,this.posLeagueHash[_loc3_.cd_num] as Point);
            this.curLeague = _loc3_;
            Facade.protoProxy.request(new Packet_0060_2D(_loc3_.cd_region),this.resultLeagueInfo,96,46,[_loc3_]);
         }
      }
      
      private function resultLeagueInfo(param1:BinaryBuffer, param2:PClanDivision) : void
      {
         var region:PRegion;
         var count:uint;
         var maxY:int;
         var maxX:int;
         var terrPanel:TerritoryPanel = null;
         var terr:PTerritory = null;
         var num:int = 0;
         var terrShop:PShopTerritory = null;
         var x:int = 0;
         var y:int = 0;
         var time:Number = NaN;
         var reg:Array = null;
         var buffer:BinaryBuffer = param1;
         var item:PClanDivision = param2;
         if(!this.dialog.parent || item != this.curLeague)
         {
            return;
         }
         region = new Packet_0060_2E(buffer).value;
         count = 0;
         maxY = 0;
         maxX = 0;
         region.territories.sort(function(param1:PTerritory, param2:PTerritory):int
         {
            var _loc3_:PShopTerritory = Facade.manualProxy.getTerritoryShop(param1.kind);
            var _loc4_:PShopTerritory = Facade.manualProxy.getTerritoryShop(param2.kind);
            return _loc3_.ter_resource_cost.length < _loc4_.ter_resource_cost.length ? -1 : 1;
         });
         for each(terr in region.territories)
         {
            terrShop = Facade.manualProxy.getTerritoryShop(terr.kind);
            x = terrShop.ter_position_0;
            y = terrShop.ter_position_1;
            if(count >= region.territories.length)
            {
               break;
            }
            if(this.territoryList.length <= count)
            {
               if(this.waitTerritoryList.length > 0)
               {
                  terrPanel = this.waitTerritoryList.pop();
               }
               else
               {
                  terrPanel = new TerritoryPanel();
                  terrPanel.addClickListener(this.onTerritorySelect);
                  terrPanel.changeStateFunc = this.onTerritoryStateChange;
               }
               this.territoryList.push(terrPanel);
            }
            else
            {
               terrPanel = this.territoryList[count];
            }
            terrPanel.geomX = x;
            terrPanel.geomY = y;
            terrPanel.left = TerritoryPanel.cellWidth * (x + 0.5 * y) + 65;
            terrPanel.top = 105 * y * TerritoryPanel.factor + 50;
            maxY = Math.max(maxY,terrPanel.top);
            maxX = Math.max(maxX,terrPanel.left);
            if(!terrPanel.parent)
            {
               this.dialog.mapPanel.add(terrPanel);
            }
            else
            {
               terrPanel.syncLayout();
            }
            terrPanel.assign(region.territories[count]);
            if(up.clanData)
            {
               this.syncRegentInfo(terrPanel.env,up.clanData.members);
            }
            count++;
            if(terr.state.variance == PTerritoryState.REG_ATTACK)
            {
               time = (terr.state.value as time_a_str_a).field_0;
               reg = (terr.state.value as time_a_str_a).field_1;
               if(Facade.userProxy.clanData)
               {
                  if(reg.indexOf(Facade.userProxy.clanData.base.id) >= 0)
                  {
                     ActionLogic.territiryWarsRegEnd(time,terr.kind);
                  }
               }
            }
         }
         this.dialog.updateMapSize(maxX + 150,maxY + 225);
         num = int(count);
         while(num < this.territoryList.length)
         {
            terrPanel = this.territoryList[num];
            terrPanel.removeFromParent(false);
            terrPanel.env = null;
            this.waitTerritoryList.push(terrPanel);
            num++;
         }
         this.territoryList.length = count;
         this.dialog.endMapLoad();
         this.syncOwners();
         this.syncBorderLines();
         if(this.openArgs)
         {
            for each(terrPanel in this.territoryList)
            {
               if(terrPanel.env.kind === this.openArgs[0])
               {
                  this.onTerritorySelect(null,terrPanel);
                  if(this.openArgs[1] >= 0 && up.checkClanRolePermission(PPermission.REGENT_ASSIGNER))
                  {
                     this.showRegentDialog(terrPanel.env,this.openArgs[1]);
                  }
                  break;
               }
            }
            this.openArgs = null;
         }
      }
      
      private function onTerritoryStateChange(param1:TerritoryPanel, param2:uint) : void
      {
         VButton.defaultButtonChangeState(param1,param2);
         this.dialog.changeSelect(param2 == VButton.DOWN || param2 == VButton.OVER ? param1 : null);
      }
      
      private function syncOwners() : void
      {
         var _loc4_:TerritoryPanel = null;
         var _loc5_:uint = 0;
         var _loc6_:TerritoryPanel = null;
         var _loc7_:int = 0;
         var _loc8_:PTerritoryOwner = null;
         var _loc9_:Boolean = false;
         var _loc10_:uint = 0;
         var _loc11_:TerritoryPanel = null;
         var _loc12_:PShopTerritory = null;
         var _loc13_:int = 0;
         var _loc14_:TerritoryPanel = null;
         var _loc15_:int = 0;
         var _loc16_:PShopTerritory = null;
         this.myTerritoryCount = 0;
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         var _loc3_:String = up.clan ? up.clan.uc_clan_id : null;
         for each(_loc4_ in this.territoryList)
         {
            _loc8_ = _loc4_.env.clan_owner;
            if(_loc8_)
            {
               if(_loc8_.to_clan_id == _loc3_)
               {
                  _loc4_.setOwnerIndex(2);
                  ++this.myTerritoryCount;
               }
               else
               {
                  _loc9_ = true;
                  _loc10_ = 0;
                  while(_loc10_ < _loc2_)
                  {
                     if(_loc1_[_loc10_] == _loc8_.to_clan_id)
                     {
                        ++_loc1_[_loc10_ + 1];
                        _loc9_ = false;
                        break;
                     }
                     _loc10_ += 2;
                  }
                  if(_loc9_)
                  {
                     _loc1_.push(_loc8_.to_clan_id,1);
                     _loc2_ += 2;
                  }
               }
            }
            else
            {
               _loc4_.setOwnerIndex(1);
            }
         }
         _loc5_ = 3;
         _loc10_ = 1;
         while(_loc10_ < _loc2_)
         {
            if(_loc1_[_loc10_] > 1)
            {
               _loc1_[_loc10_] = _loc5_;
               _loc5_++;
            }
            _loc10_ += 2;
         }
         for each(_loc4_ in this.territoryList)
         {
            _loc8_ = _loc4_.env.clan_owner;
            if(_loc8_)
            {
               _loc5_ = 0;
               _loc10_ = 0;
               while(_loc10_ < _loc2_)
               {
                  if(_loc1_[_loc10_] == _loc8_.to_clan_id)
                  {
                     _loc5_ = uint(_loc1_[_loc10_ + 1]);
                     break;
                  }
                  _loc10_ += 2;
               }
               if(_loc5_ > 0)
               {
                  _loc4_.setOwnerIndex(_loc5_);
               }
            }
         }
         if(this.myPanel.territoryCountText)
         {
            this.myPanel.territoryCountText.value = this.myTerritoryCount.toString();
         }
         for each(_loc6_ in this.territoryList)
         {
            _loc6_.resetBorder();
         }
         _loc7_ = 0;
         while(_loc7_ < this.territoryList.length)
         {
            _loc11_ = this.territoryList[_loc7_];
            _loc12_ = Facade.manualProxy.getTerritoryShop(_loc11_.env.kind);
            _loc13_ = _loc7_ + 1;
            while(_loc13_ < this.territoryList.length)
            {
               _loc14_ = this.territoryList[_loc13_];
               _loc15_ = this.checkNeighbour(_loc11_.geomX,_loc11_.geomY,_loc14_.geomX,_loc14_.geomY);
               if(_loc15_ != -1)
               {
                  _loc16_ = Facade.manualProxy.getTerritoryShop(_loc14_.env.kind);
                  if(_loc12_.ter_resource_cost.length != _loc16_.ter_resource_cost.length)
                  {
                     _loc14_.setBorder(_loc15_);
                  }
               }
               _loc13_++;
            }
            _loc7_++;
         }
      }
      
      private function syncClanInfo() : void
      {
         var _loc1_:uint = 0;
         if(up.clan)
         {
            _loc1_ = up.clanData ? 1 : 2;
         }
         else
         {
            _loc1_ = 3;
         }
         if(this.myClanMode > 1 && _loc1_ == 1)
         {
            if(!Facade.mainMediator.searchDialog(TerritoryDialog))
            {
               this.changeLeague(mp.getClanLeagueByNum(up.clanData.base.division));
            }
            if(this.grid)
            {
               this.grid.sync();
            }
         }
         if(this.myClanMode != _loc1_)
         {
            this.myClanMode = _loc1_;
            this.myPanel.clearMode();
            if(_loc1_ == 1)
            {
               this.myPanel.clanMode(up.clanData);
               this.myPanel.territoryCountText.value = this.myTerritoryCount.toString();
            }
            else if(_loc1_ == 3)
            {
               this.myPanel.searchMode();
            }
            else
            {
               this.myPanel.loadMode();
            }
         }
         if(this.curLeague)
         {
            this.dialog.syncLockIcon(this.curLeague.cd_num);
         }
      }
      
      private function syncBorderLines() : void
      {
         var _loc14_:Vector.<int> = null;
         var _loc15_:int = 0;
         var _loc16_:PTerritory = null;
         var _loc17_:TerritoryPanel = null;
         var _loc18_:int = 0;
         var _loc19_:PTerritory = null;
         var _loc1_:Graphics = this.dialog.shape.graphics;
         _loc1_.clear();
         if(!up.clan)
         {
            return;
         }
         _loc1_.lineStyle(3,16777215,1,true);
         var _loc2_:String = up.clan.uc_clan_id;
         var _loc3_:Vector.<int> = new <int>[-1,0,1,0,-1,-1,0,-1,-1,1,0,1];
         var _loc4_:Vector.<int> = new <int>[-1,0,1,0,0,-1,1,-1,0,1,1,1];
         var _loc5_:Number = TerritoryPanel.factor;
         var _loc6_:Point = new Point(1 * _loc5_,35 * _loc5_);
         var _loc7_:Point = new Point(1 * _loc5_,106 * _loc5_);
         var _loc8_:Point = new Point(120 * _loc5_,35 * _loc5_);
         var _loc9_:Point = new Point(120 * _loc5_,106 * _loc5_);
         var _loc10_:Point = new Point(60 * _loc5_,1 * _loc5_);
         var _loc11_:Point = new Point(60 * _loc5_,140 * _loc5_);
         var _loc12_:Vector.<Point> = new <Point>[_loc6_,_loc7_,_loc8_,_loc9_,_loc10_,_loc6_,_loc10_,_loc8_,_loc11_,_loc7_,_loc11_,_loc9_];
         var _loc13_:int = 0;
         while(_loc13_ < this.y_max)
         {
            _loc14_ = (_loc13_ & 1) == 0 ? _loc3_ : _loc4_;
            _loc15_ = 0;
            while(_loc15_ < this.x_max)
            {
               _loc16_ = this.getTerritoryEnv(_loc15_,_loc13_);
               if((Boolean(_loc16_)) && Boolean(_loc16_.clan_owner) && _loc16_.clan_owner.to_clan_id == _loc2_)
               {
                  _loc17_ = this.getTerritoryPanel(_loc15_,_loc13_);
                  _loc18_ = _loc14_.length - 2;
                  while(_loc18_ >= 0)
                  {
                     _loc19_ = this.getTerritoryEnv(_loc15_ + _loc14_[_loc18_],_loc13_ + _loc14_[_loc18_ + 1]);
                     if(!_loc19_ || !_loc19_.clan_owner || _loc19_.clan_owner.to_clan_id != _loc2_)
                     {
                        _loc6_ = _loc12_[_loc18_];
                        _loc7_ = _loc12_[_loc18_ + 1];
                        _loc1_.moveTo(_loc17_.x + _loc6_.x,_loc17_.y + _loc6_.y);
                        _loc1_.lineTo(_loc17_.x + _loc7_.x,_loc17_.y + _loc7_.y);
                     }
                     _loc18_ -= 2;
                  }
               }
               _loc15_++;
            }
            _loc13_++;
         }
         _loc1_.endFill();
      }
      
      private function reopenTerritoryDialog(param1:TerritoryDialog) : void
      {
         var _loc2_:TerritoryPanel = null;
         param1.close();
         for each(_loc2_ in this.territoryList)
         {
            if(_loc2_.env == param1.env)
            {
               this.onTerritorySelect(null,_loc2_);
               break;
            }
         }
      }
      
      private function onTerritorySelect(param1:MouseEvent, param2:TerritoryPanel = null) : void
      {
         if(param1)
         {
            param2 = param1.currentTarget as TerritoryPanel;
         }
         var _loc3_:PTerritory = param2.env;
         var _loc4_:TerritoryDialog = new TerritoryDialog(_loc3_.kind,_loc3_.level);
         Facade.mainMediator.showDialog(_loc4_);
         Facade.protoProxy.request(new Packet_0002_01(Packet_0002_01.TERRITORY_INFO,_loc3_.kind),this.resultTerritoryInfo,2,2,[_loc4_,param2]);
      }
      
      private function getLeagueByKind(param1:String) : PClanDivision
      {
         var _loc2_:PClanDivision = null;
         for each(_loc2_ in mp.clanLeagueList)
         {
            if(_loc2_.cd_region == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function resultTerritoryInfo(param1:BinaryBuffer, param2:TerritoryDialog, param3:TerritoryPanel) : void
      {
         var _loc5_:PTerritory = null;
         var _loc6_:Boolean = false;
         var _loc7_:PShopTerritory = null;
         var _loc8_:PShopMine = null;
         var _loc9_:PShopTerritory = null;
         var _loc10_:PClanDivision = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:Array = null;
         var _loc15_:PCost = null;
         var _loc4_:Packet_0002_02 = new Packet_0002_02(param1);
         if(_loc4_.variance == Packet_0002_02.TERRITORY_INFO)
         {
            _loc5_ = _loc4_.value;
            if(up.clanData)
            {
               this.syncRegentInfo(_loc5_,up.clanData.members);
            }
            if(Boolean(this.dialog.parent) && param3.env.kind == _loc5_.kind)
            {
               param3.assign(_loc5_);
            }
            if(!param2.parent)
            {
               return;
            }
            _loc6_ = Boolean(_loc5_.clan_owner) && Boolean(up.clan) && _loc5_.clan_owner.to_clan_id == up.clan.uc_clan_id;
            _loc7_ = Facade.manualProxy.getTerritoryShop(_loc5_.kind);
            _loc8_ = mp.getMineShop(_loc7_.ter_region,_loc5_.level);
            _loc9_ = mp.getTerritoryShop(_loc5_.kind);
            _loc10_ = this.getLeagueByKind(_loc9_.ter_region);
            _loc11_ = _loc5_.state.variance;
            if(_loc6_ && _loc11_ != PTerritoryState.ATTACK)
            {
               _loc13_ = uint((mp.mineShopList[mp.mineShopList.length - 1] as PShopMine).mine_level);
               if(_loc8_.mine_level < _loc13_)
               {
                  _loc14_ = mp.getMineShop(_loc7_.ter_region,_loc5_.level + 1).mine_price;
               }
            }
            else if(_loc11_ == PTerritoryState.FREE || _loc11_ == PTerritoryState.REG_ATTACK)
            {
               _loc14_ = [];
               for each(_loc15_ in _loc9_.ter_attack_price)
               {
                  CostHelper.addCostToList(_loc14_,_loc15_.variance,_loc15_.value);
               }
               for each(_loc15_ in _loc8_.mine_attack_price_addition)
               {
                  CostHelper.addCostToList(_loc14_,_loc15_.variance,_loc15_.value);
               }
            }
            _loc12_ = 1;
            if(Boolean(_loc10_) && _loc10_.cd_num == up.getClanLeagueNum())
            {
               _loc12_ = up.checkClanRolePermission(PPermission.INIT_WAR) ? 0 : 2;
            }
            param2.assign(_loc5_,_loc9_,_loc8_,_loc10_ ? _loc10_.cd_num : 1,_loc6_,_loc13_,_loc14_,up.clanData ? up.clanData.base.id : null,_loc12_,up.checkClanRolePermission(PPermission.REGENT_ASSIGNER));
            param2.addListener(VEvent.VARIANCE,this.onTerritoryVariance);
            param2.addListener(VEvent.CHANGE,this.onTerritoryChange);
         }
         else
         {
            param2.close();
         }
      }
      
      private function onTerritoryChange(param1:VEvent) : void
      {
         this.reopenTerritoryDialog(param1.currentTarget as TerritoryDialog);
      }
      
      private function onTerritoryVariance(param1:VEvent) : void
      {
         var _loc2_:TerritoryDialog = param1.currentTarget as TerritoryDialog;
         switch(param1.variance)
         {
            case _loc2_.INIT_ATTACK:
               this.startOccupied(_loc2_);
               break;
            case _loc2_.STORM:
               MainLogic.getTerritoryStorm(_loc2_.env.kind);
               break;
            case _loc2_.TO_REGENT:
               this.toRegent(_loc2_.env);
               break;
            case _loc2_.TO_OWNER:
               this.toClan(param1.data);
               break;
            case _loc2_.CHANGE_REGENT:
               this.showRegentDialog(_loc2_.env);
               break;
            case _loc2_.UPDATE:
               this.startUpdate(_loc2_);
               break;
            case _loc2_.LEAVE:
               this.leaveTerritory(_loc2_);
         }
      }
      
      private function checkNeighbour(param1:int, param2:int, param3:int, param4:int) : int
      {
         var _loc5_:Array = [1,-1,1,0,0,1,-1,1,-1,0,0,-1];
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            if(param1 == param3 + _loc5_[_loc6_] && param2 == param4 + _loc5_[_loc6_ + 1])
            {
               return _loc6_ / 2;
            }
            _loc6_ += 2;
         }
         return -1;
      }
      
      private function startOccupied(param1:TerritoryDialog, param2:Boolean = false) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc11_:PTerritory = null;
         var _loc12_:PShopTerritory = null;
         if(mp.territoryDeny)
         {
            Facade.mainMediator.showMessage(Lang.getString("territory_deny"));
            return;
         }
         var _loc3_:Boolean = param1.leagueNum != up.getClanLeagueNum();
         if(_loc3_ || !up.checkClanRolePermission(PPermission.INIT_WAR))
         {
            Facade.mainMediator.showMessage(Lang.getString(_loc3_ ? "territory_league_lock" : "territory_storm_lock"),Lang.getString("territory_storm"),SkinManager.getEmbed("CannonIcon"));
            return;
         }
         var _loc4_:String = up.clan.uc_clan_id;
         var _loc8_:PShopTerritory = mp.getTerritoryShop(param1.env.kind);
         var _loc9_:* = int(this.territoryList.length - 1);
         while(_loc9_ >= 0)
         {
            _loc11_ = this.territoryList[_loc9_].env;
            if(Boolean(!_loc5_) && Boolean(_loc11_.clan_owner) && _loc11_.clan_owner.to_clan_id == _loc4_)
            {
               _loc6_ = true;
               if(!_loc5_)
               {
                  _loc12_ = mp.getTerritoryShop(_loc11_.kind);
                  _loc5_ = this.checkNeighbour(_loc8_.ter_position_0,_loc8_.ter_position_1,_loc12_.ter_position_0,_loc12_.ter_position_1) != -1;
               }
            }
            if(!_loc7_ && _loc11_.state.variance == PTerritoryState.ATTACK && (_loc11_.state.value as PTerritoryAttacker).ta_clan_id == _loc4_)
            {
               _loc7_ = true;
            }
            _loc9_--;
         }
         if(_loc7_ || !_loc5_ && _loc6_)
         {
            Facade.mainMediator.showMessage(Lang.getString(_loc7_ ? "territory_one_attack" : "territory_neighbours"),Lang.getString("territory_storm"),SkinManager.getEmbed("CannonIcon"));
            return;
         }
         if(_loc7_ || !_loc5_ && _loc6_)
         {
            Facade.mainMediator.showMessage(Lang.getString(_loc7_ ? "territory_one_attack" : "territory_neighbours"),Lang.getString("territory_storm"),SkinManager.getEmbed("CannonIcon"));
            return;
         }
         var _loc10_:Boolean = Boolean(up.clanData) && up.clanData.territories_count >= Facade.manualProxy.getClanLeagueByNum(up.clanData.base.division).cd_ter_limit;
         if(_loc10_)
         {
            Facade.mainMediator.showMessage(Lang.getString("territory_limit"),Lang.getString("territory_storm"),SkinManager.getEmbed("CannonIcon"));
            return;
         }
         if(checkClanPrice(param1.price,"territory_storm"))
         {
            if(!param2)
            {
               Facade.mainMediator.showYesNoDialog(Lang.getReplaceString("territory_storm_prompt",{
                  "__NAME__":Lang.getString(param1.env.kind),
                  "__PRICE__":CostHelper.get18ListString(param1.price,true)
               }),this.startOccupied,[param1,true],Lang.getString("territory_storm"),SkinManager.getEmbed("CannonIcon"));
               return;
            }
            Facade.protoProxy.request(new Packet_0060_2F(param1.shop.ter_kind),this.resultOccupied,0,0,[param1]);
         }
      }
      
      private function checkAnswer(param1:BinaryBuffer) : void
      {
         if(param1.family == 0 && param1.subfamily == 3)
         {
            Facade.mainMediator.showMessage(Lang.getString("territory_error" + (up.syncClanResource(new Packet_0000_03(param1).value) ? "1" : "2"))).addListener(VEvent.CLOSE_DIALOG,this.onReopen);
         }
      }
      
      private function onReopen(param1:VEvent = null) : void
      {
         var _loc2_:TerritoryDialog = Facade.mainMediator.searchDialog(TerritoryDialog);
         if(_loc2_)
         {
            _loc2_.close();
         }
         this.changeLeague(this.dialog.curDivision,true);
      }
      
      private function resultOccupied(param1:BinaryBuffer, param2:TerritoryDialog) : void
      {
         if(param1.family == 0 && param1.subfamily == 1)
         {
            this.onReopen();
         }
         else
         {
            this.onReopen();
         }
      }
      
      private function leaveTerritory(param1:TerritoryDialog) : void
      {
         var _loc2_:Boolean = Boolean(Facade.userProxy.clanData) && Facade.userProxy.clanData.territories_count >= Facade.manualProxy.getClanLeagueByNum(Facade.userProxy.clanData.base.division).cd_ter_limit;
         if(!_loc2_)
         {
            Facade.mainMediator.showMessage(Lang.getString("territory_limit_leave"),Lang.getString("territory_leave_title"),SkinManager.getEmbed("CannonIcon"));
            return;
         }
         Facade.mainMediator.showYesNoDialog(Lang.getString("leave_territory_confirm"),this.leaveTerritoryConfirm,[param1]);
      }
      
      private function leaveTerritoryConfirm(param1:TerritoryDialog) : void
      {
         param1.close();
         --Facade.userProxy.clanData.territories_count;
         try
         {
            Facade.userProxy.clanData.territories.removeAt(Facade.userProxy.clanData.territories.indexOf(param1.env.kind));
         }
         catch(error:Error)
         {
         }
         Facade.protoProxy.request(new Packet_0060_41(param1.env.kind),this.resultLeave);
         this.changeLeague(this.dialog.curDivision,true);
      }
      
      private function resultLeave(param1:BinaryBuffer) : void
      {
         this.changeLeague(this.dialog.curDivision,true);
         var _loc2_:ClanDialog = Facade.mainMediator.searchDialog(ClanDialog);
         if(_loc2_)
         {
            _loc2_.infoPanel = null;
         }
      }
      
      private function showRegentDialog(param1:PTerritory, param2:uint = 0) : void
      {
         var _loc4_:PMember = null;
         var _loc5_:PMember = null;
         if(!up.checkClanRolePermission(PPermission.REGENT_ASSIGNER))
         {
            Facade.mainMediator.showMessage(Lang.getString("regent_permission"),Lang.getString("regent_select"),SkinManager.getEmbed("GuardIcon"));
            return;
         }
         var _loc3_:Array = [];
         for each(_loc5_ in up.clanData.members)
         {
            if(_loc5_.territory_regent == param1.kind)
            {
               _loc4_ = _loc5_;
            }
            else
            {
               _loc3_.push(_loc5_);
            }
         }
         if(_loc3_.length == 0 && !_loc4_)
         {
            Facade.mainMediator.showMessage(Lang.getString("regent_select_empty"),Lang.getString("regent_select"),SkinManager.getEmbed("GuardIcon"));
            return;
         }
         _loc3_.sort(this.regentSort);
         var _loc6_:* = int(_loc3_.length - 1);
         while(_loc6_ >= 0)
         {
            (_loc3_[_loc6_] as PMember).user_base.th_level = 0;
            _loc6_--;
         }
         if(_loc4_)
         {
            _loc4_.user_base.th_level = 1;
            _loc3_.unshift(_loc4_);
         }
         var _loc7_:BaseDialog = new BaseDialog();
         _loc7_.layoutW = 814;
         _loc7_.addBg(false);
         _loc7_.addDialogTitle(Lang.getString("regent_select"));
         _loc7_.addCloseButton();
         var _loc8_:VGrid = new VGrid(1,7,RegentRenderer,_loc3_,0,0,VGrid.H_STRETCH,param2);
         _loc8_.add(new VFill(16777215,0.15),{
            "left":319,
            "w":112,
            "hP":100
         },0);
         UIFactory.addGridWithBg(_loc8_,_loc7_,true,80,20,20);
         _loc8_.bottom = 44;
         _loc7_.addListener(VEvent.VARIANCE,this.onRegentVariance);
         Facade.mainMediator.showDialog(_loc7_);
      }
      
      private function regentSort(param1:PMember, param2:PMember) : Number
      {
         return param2.user_base.exp - param1.user_base.exp;
      }
      
      private function onRegentVariance(param1:VEvent) : void
      {
         var _loc2_:TerritoryDialog = Facade.mainMediator.searchDialog(TerritoryDialog);
         if(param1.variance < 2)
         {
            (param1.currentTarget as BaseDialog).close();
            if(_loc2_)
            {
               Facade.protoProxy.request(new Packet_0060_33(PSetRegent.create(_loc2_.env.kind,param1.variance == 0 ? (param1.data as PMember).user_base.user_id : null)));
               this.reopenTerritoryDialog(_loc2_);
               if(param1.variance == 0 && Boolean((param1.data as PMember).territory_regent))
               {
                  Facade.mainMediator.showMessage(Lang.getString("set_user_territory_message"),null,null,MessageDialog.HIDE_CLOSE_BUTTON);
               }
            }
         }
         else if(param1.variance == 2)
         {
            if(_loc2_)
            {
               Facade.setMapCallback(DialogLogic.openPoliticalMap,[_loc2_.env.kind,param1.data[1]]);
            }
            MainLogic.getFriendMap(param1.data[0],false,true);
         }
      }
      
      private function startUpdate(param1:TerritoryDialog) : void
      {
         var _loc2_:TerritoryUpdateDialog = new TerritoryUpdateDialog(param1.env,param1.shop,param1.mineShop,mp.getMineShop(param1.shop.ter_region,param1.env.level + 1),param1.leagueNum);
         _loc2_.addListener(VEvent.VARIANCE,this.confirmUpdate);
         Facade.mainMediator.showDialog(_loc2_);
      }
      
      private function confirmUpdate(param1:VEvent) : void
      {
         var _loc3_:TerritoryDialog = null;
         var _loc2_:TerritoryUpdateDialog = param1.currentTarget as TerritoryUpdateDialog;
         if(!up.checkClanRolePermission(PPermission.REGENT_ASSIGNER))
         {
            Facade.mainMediator.showMessage(Lang.getString("territory_update_lock"),Lang.getString("territory_update"),SkinManager.getEmbed("UpdateIcon"));
            return;
         }
         if(checkClanPrice(_loc2_.mineShop.mine_price,"territory_update"))
         {
            _loc2_.close();
            up.applyClanPrice(_loc2_.mineShop.mine_price,true,PCapitalLogKind.UPGRADE_TERRITORY);
            Facade.protoProxy.request(new Packet_0060_34(_loc2_.shop.ter_kind),this.checkAnswer);
            _loc3_ = Facade.mainMediator.searchDialog(TerritoryDialog);
            if(_loc3_)
            {
               this.reopenTerritoryDialog(_loc3_);
            }
         }
      }
      
      private function toRegent(param1:PTerritory) : void
      {
         Facade.setMapCallback(DialogLogic.openPoliticalMap,[param1.kind]);
         if(Boolean(param1.clan_owner) && Boolean(param1.clan_owner.regent))
         {
            MainLogic.getFriendMap(param1.clan_owner.regent.regent_id,false,true);
         }
         else
         {
            MainLogic.getFriendMap(mp.getTerritoryShop(param1.kind).ter_mission_kind,true,true);
         }
      }
      
      private function onGameStream(param1:CommonEvent) : void
      {
         var _loc2_:PRaidEvent = param1.data;
         var _loc3_:uint = _loc2_ ? _loc2_.variance : PRaidEvent.UNKNOWN;
         if(!_loc2_ || _loc3_ == PRaidEvent.DEL_CLAN_MEMBER && _loc2_.value == Preloader.uid || _loc3_ == PRaidEvent.NEW_CLAN_MEMBER && (_loc2_.value as PMember).user_base.user_id == Preloader.uid)
         {
            this.syncClanInfo();
         }
         else if(_loc3_ == PRaidEvent.TERRITORY_REGENT)
         {
            this.onRegentChange(_loc2_.value);
         }
      }
      
      private function onRegentChange(param1:PSetRegent) : void
      {
         var _loc2_:TerritoryDialog = Facade.mainMediator.searchDialog(TerritoryDialog);
         if(Boolean(_loc2_) && Boolean(_loc2_.visible) && _loc2_.env.kind == param1.sr_ter_kind)
         {
            this.reopenTerritoryDialog(_loc2_);
         }
      }
      
      private function getTerritoryPanel(param1:int, param2:int) : TerritoryPanel
      {
         var _loc5_:TerritoryPanel = null;
         var _loc3_:uint = this.territoryList.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.territoryList[_loc4_];
            if(_loc5_.geomX == param1 && _loc5_.geomY == param2)
            {
               return _loc5_.parent ? _loc5_ : null;
            }
            _loc4_++;
         }
         return null;
      }
      
      private function getTerritoryEnv(param1:int, param2:int) : PTerritory
      {
         var _loc3_:TerritoryPanel = this.getTerritoryPanel(param1,param2);
         return _loc3_ ? _loc3_.env : null;
      }
      
      private function syncRegentInfo(param1:PTerritory, param2:Array) : void
      {
         var _loc3_:PMember = null;
         var _loc4_:Boolean = false;
         for each(_loc3_ in param2)
         {
            _loc4_ = (Boolean(param1.clan_owner) && Boolean(param1.clan_owner.regent) ? param1.clan_owner.regent.regent_id : null) == _loc3_.user_base.user_id;
            if(_loc3_.territory_regent == param1.kind)
            {
               if(!_loc4_)
               {
                  _loc3_.territory_regent = null;
               }
            }
            else if(_loc4_)
            {
               _loc3_.territory_regent = param1.kind;
            }
         }
      }
      
      private function toClan(param1:Object) : void
      {
         if(param1 is PTerritoryOwner)
         {
            DialogLogic.openClanAbout((param1 as PTerritoryOwner).to_clan_id);
         }
         else if(param1 is PTerritoryAttacker)
         {
            DialogLogic.openClanAbout((param1 as PTerritoryAttacker).ta_clan_id);
         }
      }
      
      private function openLeague() : void
      {
      }
      
      private function onLeagueClose(param1:VEvent) : void
      {
         this.leagueDialog = null;
      }
   }
}

