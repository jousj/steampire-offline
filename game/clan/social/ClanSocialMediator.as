package game.clan.social
{
   import engine.units.Unit;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import game.clan.center.ClanMembersMediator;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.MainLogic;
   import logic.ShopLogic;
   import model.CommonEvent;
   import model.UserProxy;
   import model.vo.MapAction;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.game.family_0010.Packet_0010_16;
   import proto.game.family_0010.Packet_0010_17;
   import proto.game.family_0060.Packet_0060_08;
   import proto.game.family_0060.Packet_0060_09;
   import proto.game.family_0060.Packet_0060_12;
   import proto.game.family_0060.Packet_0060_14;
   import proto.game.family_0060.Packet_0060_17;
   import proto.game.family_0060.Packet_0060_1C;
   import proto.game.family_0060.Packet_0060_3D;
   import proto.game.family_0060.Packet_0060_3E;
   import proto.model.PAction;
   import proto.model.PAsk;
   import proto.model.PAskData;
   import proto.model.PClanRequest;
   import proto.model.PPermission;
   import proto.model.PRaidEvent;
   import proto.model.clan.PApprove;
   import proto.model.clan.PApproveAnswer;
   import proto.model.clan.PCallRequest;
   import proto.model.clan.PChatMember;
   import proto.model.clan.PClan;
   import proto.model.clan.PMessage;
   import proto.model.clan.PSendMessage;
   import proto.model.clan.PSetRole;
   import ui.Style;
   import ui.UIFactory;
   import ui.game.UnitProgressBar;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CommonUtils;
   import utils.StringHelper;
   
   public class ClanSocialMediator
   {
      
      private var clanPanel:ClanSocialPanel;
      
      private var assignBt:VButton;
      
      private var cacheInput:String;
      
      private var isApprove:Boolean;
      
      private var isClan:Boolean;
      
      private var requestIndex:uint;
      
      private var scoreCache:Object;
      
      public function ClanSocialMediator(param1:VButton, param2:Boolean = false, param3:uint = 0)
      {
         var _loc5_:uint = 0;
         this.scoreCache = {};
         super();
         this.isClan = Boolean(Facade.userProxy.clan);
         this.clanPanel = new ClanSocialPanel(this.isClan);
         this.assignBt = param1;
         param1.data = this;
         param1.mouseEnabled = false;
         var _loc4_:VComponent = param1.parent as VComponent;
         _loc4_.add(this.clanPanel,{
            "left":(param1.left == 8 ? 43 : (param1.left > 100 ? 145 : 99)),
            "bottom":18
         },_loc4_.getChildIndex(param1));
         this.clanPanel.closeBt.addClickListener(this.onClose);
         this.requestIndex = param3;
         if(this.isClan)
         {
            if(Facade.isCapital)
            {
               this.clanPanel.tabPanel.getTab(1).disabled = true;
            }
            else
            {
               this.checkApprove();
               this.clanPanel.tabPanel.addListener(VEvent.CHANGE,this.onTabChange);
               if(!param2)
               {
                  _loc5_ = Facade.userProxy.checkReadClanTime(this.isApprove);
                  param2 = (_loc5_ & 2) != 0 && (_loc5_ & 1) == 0;
               }
               if(param2)
               {
                  this.clanPanel.tabPanel.index = 1;
               }
            }
         }
         this.onTabChange();
         Facade.addListenerForComponent(CommonEvent.MY_GAME_STREAM,this.onGameStream,this.clanPanel);
      }
      
      public static function addChatMessage(param1:String, param2:Boolean = false, param3:ChatPanel = null) : void
      {
         var _loc4_:UserProxy = Facade.userProxy;
         var _loc5_:PChatMember = PChatMember.create(Preloader.uid,_loc4_.base.name,_loc4_.clan.uc_role);
         var _loc6_:Number = CoreLogic.serverTime;
         _loc4_.chatList.push(PMessage.create(_loc5_,null,_loc6_,param1));
         if(param3)
         {
            param3.addMessage(_loc5_,param1,_loc6_,true,true);
         }
         Facade.protoProxy.request(new Packet_0060_12(PSendMessage.create(null,param1)),param2 ? resultAddChatMessage : null,96,28);
         if(param2)
         {
            Facade.protoProxy.request(new Packet_0060_17());
         }
      }
      
      private static function resultAddChatMessage(param1:BinaryBuffer) : void
      {
         Facade.userProxy.readClanTime = new Packet_0060_1C(param1).value;
      }
      
      public function toRequestsTab() : void
      {
         if(this.isClan && !Facade.isCapital && this.clanPanel.tabPanel.index == 0)
         {
            this.clanPanel.tabPanel.index = 1;
            this.onTabChange();
         }
      }
      
      private function checkApprove() : void
      {
         this.isApprove = Facade.userProxy.checkClanRolePermission(PPermission.APPROVE);
      }
      
      public function onClose(param1:MouseEvent = null) : void
      {
         this.clanPanel.removeFromParent();
         this.assignBt.data = null;
         this.assignBt.mouseEnabled = true;
         if(Boolean(param1) && Facade.userProxy.checkReadClanTime(this.isApprove) > 0)
         {
            Facade.myMediator.showMyClanNotify();
         }
      }
      
      private function onTabChange(param1:Object = null) : void
      {
         var _loc4_:uint = 0;
         if(this.clanPanel.tabPage is VGrid)
         {
            this.requestIndex = param1 is VEvent ? (this.clanPanel.tabPage as VGrid).index : 0;
         }
         var _loc2_:UserProxy = Facade.userProxy;
         var _loc3_:uint = _loc2_.checkReadClanTime(this.isApprove);
         if(this.isClan)
         {
            _loc4_ = this.clanPanel.tabPanel.index;
            if(param1 is VEvent)
            {
               this.clanPanel.resetNotify();
            }
            else
            {
               if(_loc4_ == 0 && (_loc3_ & 2) != 0)
               {
                  this.clanPanel.setTabNotify(1);
               }
               else if(_loc4_ == 1 && (_loc3_ & 1) != 0)
               {
                  this.clanPanel.setTabNotify(0);
               }
               if(param1 is uint && _loc4_ != uint(param1))
               {
                  return;
               }
            }
            if(_loc4_ == 1 && this.clanPanel.tabPage is ChatPanel)
            {
               this.cacheInput = (this.clanPanel.tabPage as ChatPanel).inputText.value;
            }
            if(!_loc2_.energyRequestList)
            {
               this.useLoadPanel(Lang.getString(_loc4_ == 0 ? "chat_load" : "requests_load"));
               return;
            }
            if(_loc4_ == 0)
            {
               this.showChat();
            }
            else if(_loc4_ == 1)
            {
               this.showRequests();
            }
         }
         else
         {
            this.showRequests();
         }
         if(_loc3_ > 0)
         {
            if(!this.isClan || param1 is VEvent || _loc4_ == 0 && (_loc3_ & 2) == 0 || _loc4_ == 1 && (_loc3_ & 1) == 0)
            {
               if(!(this.clanPanel.tabPage is ChatPanel) || (this.clanPanel.tabPage as ChatPanel).isScrollDown)
               {
                  _loc2_.syncReadClanTime(this.isApprove);
                  Facade.protoProxy.request(new Packet_0060_17());
               }
            }
         }
      }
      
      private function showRequests() : void
      {
         var _loc3_:Object = null;
         var _loc4_:VGrid = null;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc1_:UserProxy = Facade.userProxy;
         var _loc2_:Array = this.clanPanel.tabPage is VGrid ? (this.clanPanel.tabPage as VGrid).getDataProvider() : [];
         _loc2_.length = 0;
         for each(_loc3_ in _loc1_.alinkRequestList)
         {
            _loc2_.push(_loc3_);
         }
         for each(_loc3_ in _loc1_.energyRequestList)
         {
            _loc2_.push(_loc3_);
         }
         if(this.isApprove)
         {
            for each(_loc3_ in _loc1_.clanData.requests)
            {
               _loc2_.push(_loc3_);
            }
         }
         if(this.clanPanel.tabPage is VGrid)
         {
            (this.clanPanel.tabPage as VGrid).sync(this.requestIndex);
         }
         else
         {
            _loc4_ = new VGrid(1,3,ClanRequestRenderer,null,0,0,VGrid.H_STRETCH | VGrid.USE_TOP_LEFT);
            _loc4_.add(SkinManager.getEmbed("ChBox",VSkin.STRETCH),{
               "left":-3,
               "right":-3,
               "top":-4,
               "bottom":-4
            },0);
            _loc4_.emptyFactory = this.emptyRequestsFactory;
            _loc5_ = int(_loc4_.renderList[0].measuredHeight);
            _loc6_ = int(_loc4_.vCount - 1);
            while(_loc6_ >= 0)
            {
               _loc4_.add(new VFill(12893879),{
                  "h":_loc5_ - 2,
                  "top":_loc5_ * _loc6_ + 1,
                  "left":2,
                  "right":2
               },1);
               _loc6_--;
            }
            _loc4_.addListener(VEvent.VARIANCE,this.onRequestVariance);
            UIFactory.useGridControlNav(_loc4_,UIFactory.addNavBt18);
            _loc4_.setDataProvider(_loc2_,this.requestIndex);
            this.clanPanel.setTabPage(_loc4_,{
               "left":18,
               "right":16,
               "top":49
            });
         }
      }
      
      private function emptyRequestsFactory() : VComponent
      {
         var _loc1_:VText = new VText(Lang.getString("requests_empty"),VText.CENTER,Style.darkKhakiRGB);
         _loc1_.assignLayout({
            "left":50,
            "right":50,
            "vCenter":0
         });
         return _loc1_;
      }
      
      private function onRequestVariance(param1:VEvent) : void
      {
         var _loc2_:ClanRequestRenderer = null;
         var _loc3_:Object = null;
         if(param1.variance == ClanRequestRenderer.LOAD_IMG)
         {
            _loc2_ = param1.data;
            if(this.scoreCache[_loc2_.id])
            {
               _loc2_.setPoints(this.scoreCache[_loc2_.id]);
            }
            else
            {
               Facade.protoProxy.request(new Packet_0060_3D(_loc2_.id),this.userDataRes,96,62,[_loc2_.id,_loc2_]);
            }
         }
         else
         {
            _loc3_ = param1.data;
            if(_loc3_ is PCallRequest)
            {
               this.energyRequest(_loc3_ as PCallRequest);
            }
            else if(_loc3_ is PAsk)
            {
               this.askRequest(_loc3_ as PAsk);
            }
            else if(_loc3_ is PClanRequest)
            {
               this.clanRequest(_loc3_ as PClanRequest,param1.variance);
            }
         }
      }
      
      private function userDataRes(param1:BinaryBuffer, param2:String, param3:ClanRequestRenderer) : void
      {
         var _loc4_:Packet_0060_3E = new Packet_0060_3E(param1);
         this.scoreCache[param2] = [ClanMembersMediator.getCurRating(_loc4_.value.clan_points),_loc4_.value.ratio];
         if(param3.id == param2)
         {
            param3.setPoints(this.scoreCache[param2]);
         }
      }
      
      private function removeRequest(param1:*, param2:Array) : void
      {
         param2.splice(param2.indexOf(param1),1);
         var _loc3_:VGrid = this.clanPanel.tabPage as VGrid;
         param2 = _loc3_.getDataProvider();
         param2.splice(param2.indexOf(param1),1);
         _loc3_.sync();
      }
      
      private function energyRequest(param1:PCallRequest) : void
      {
         this.removeRequest(param1,Facade.userProxy.energyRequestList);
         Facade.protoProxy.request(new Packet_0060_14(param1.cr_user_id));
      }
      
      private function askRequest(param1:PAsk) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:* = undefined;
         var _loc4_:MapAction = null;
         var _loc5_:Unit = null;
         var _loc6_:UnitProgressBar = null;
         this.removeRequest(param1,Facade.userProxy.alinkRequestList);
         Facade.protoProxy.request(param1.ask_is_help ? new Packet_0010_17(param1.ask_user_id) : new Packet_0010_16(param1.ask_user_id));
         if(param1.ask_is_help)
         {
            Facade.userProxy.alinkHistoryList.push(param1.ask_user_id);
            _loc2_ = param1.ask_data.variance;
            _loc3_ = param1.ask_value.value;
            switch(_loc2_)
            {
               case PAskData.ASK_SPEED_UP:
               case PAskData.ASK_RESEARCH:
                  _loc4_ = CoreLogic.getAction(_loc2_ == PAskData.ASK_SPEED_UP ? ActionLogic.FINISH_CONSTRUCTION : ActionLogic.FINISH_RESEARCH,param1.ask_data.value);
                  if(_loc4_)
                  {
                     CoreLogic.removeAction(_loc4_);
                     _loc4_.time -= _loc3_;
                     _loc5_ = Facade.userProxy.constructionHash[param1.ask_data.value] as Unit;
                     if(_loc5_)
                     {
                        _loc6_ = _loc5_.getProgress() as UnitProgressBar;
                        if(_loc6_)
                        {
                           _loc6_.setEndTime(_loc4_.time);
                        }
                     }
                     CoreLogic.addAction(_loc4_,_loc4_.time);
                  }
                  break;
               case PAskData.ASK_CRYSTAL:
                  Facade.userProxy.setCrystal(_loc3_,true,true);
                  break;
               case PAskData.ASK_OIL:
                  Facade.userProxy.setOil(_loc3_,true,true);
                  break;
               case PAskData.ASK_CALL:
                  ShopLogic.setEnergy(_loc3_);
            }
            Facade.questMediator.changeQuest(PAction.AC_FRIEND_HELP,1);
         }
      }
      
      private function clanRequest(param1:PClanRequest, param2:uint) : void
      {
         var _loc3_:PClan = null;
         if(param2 == 0)
         {
            if(this.clanPanel.tabPage is VGrid)
            {
               Facade.commonHash[Facade.myMediator] = (this.clanPanel.tabPage as VGrid).index;
            }
            MainLogic.getFriendMap(param1.cr_user_id);
         }
         else
         {
            _loc3_ = Facade.userProxy.clanData;
            if(param2 == 2 && _loc3_.members.length >= Facade.manualProxy.getClanCapacity(_loc3_.clanhall_level))
            {
               Facade.mainMediator.showMessage(Lang.getString("clan_join_NO_FREE_PLACE"));
               return;
            }
            this.removeRequest(param1,_loc3_.requests);
            Facade.protoProxy.request(new Packet_0060_08(PApprove.create(param1.cr_user_id,param2 == 2)),this.resultApproveRequest,96,9);
         }
      }
      
      private function resultApproveRequest(param1:BinaryBuffer) : void
      {
         if(!Facade.userProxy.clanData)
         {
            return;
         }
         var _loc2_:PApproveAnswer = new Packet_0060_09(param1).value;
         if(_loc2_.variance == PApproveAnswer.NEW_MEMBER)
         {
            Facade.userProxy.clanData.members.push(_loc2_.value);
         }
         else if(_loc2_.variance != PApproveAnswer.REMOVE_REQUEST)
         {
            Facade.mainMediator.showMessage(Lang.getString("approve_" + CommonUtils.getConstantName(PApproveAnswer,_loc2_.variance)));
         }
      }
      
      private function showChat() : void
      {
         var _loc2_:ChatPanel = null;
         var _loc3_:PMessage = null;
         var _loc1_:Vector.<PMessage> = Facade.userProxy.chatList;
         if(this.clanPanel.tabPage is ChatPanel)
         {
            _loc2_ = this.clanPanel.tabPage as ChatPanel;
            while(_loc2_.messageCount < _loc1_.length)
            {
               _loc3_ = _loc1_[_loc2_.messageCount] as PMessage;
               _loc2_.addMessage(_loc3_.m_from,_loc3_.m_data,_loc3_.m_time,false);
            }
            _loc2_.syncScroll(false);
         }
         else
         {
            _loc2_ = new ChatPanel();
            _loc2_.inputText.value = this.cacheInput;
            _loc2_.inputText.addListener(VEvent.SELECT,this.onChatEnter);
            _loc2_.sendBt.addClickListener(this.onChatEnter);
            if(Boolean(_loc1_) && _loc1_.length > 0)
            {
               for each(_loc3_ in _loc1_)
               {
                  _loc2_.addMessage(_loc3_.m_from,_loc3_.m_data,_loc3_.m_time,false);
               }
               _loc2_.syncScroll();
            }
            else
            {
               _loc2_.useEmptyMessage(Lang.getString("chat_empty"));
            }
            this.clanPanel.setTabPage(_loc2_,{
               "left":15,
               "top":45
            });
            _loc2_.inputText.setSelection();
         }
      }
      
      private function onChatEnter(param1:Event) : void
      {
         var _loc2_:ChatPanel = this.clanPanel.tabPage as ChatPanel;
         var _loc3_:String = StringHelper.trim(_loc2_.inputText.value);
         if(_loc3_)
         {
            if(_loc3_.indexOf("@<sys>@") == 0)
            {
               return;
            }
            addChatMessage(_loc3_,(Facade.userProxy.checkReadClanTime(this.isApprove) & 2) == 0,_loc2_);
            if(param1 is MouseEvent)
            {
               _loc2_.inputText.setSelection();
            }
         }
         _loc2_.inputText.value = null;
      }
      
      private function useLoadPanel(param1:String) : void
      {
         var _loc2_:VComponent = new VComponent();
         _loc2_.addStretch(SkinManager.getEmbed("ChBox",VSkin.STRETCH));
         _loc2_.add(new VText(param1 + "...",VText.CENTER,Style.darkKhakiRGB),{
            "left":30,
            "right":30,
            "vCenter":0
         });
         this.clanPanel.setTabPage(_loc2_,{
            "left":15,
            "right":13,
            "top":45,
            "h":200
         });
      }
      
      private function onGameStream(param1:CommonEvent) : void
      {
         var _loc2_:PRaidEvent = param1.data;
         if(!_loc2_)
         {
            this.onTabChange();
            return;
         }
         switch(_loc2_.variance)
         {
            case PRaidEvent.UPDATE_CALL_REQUEST:
            case PRaidEvent.DEL_CLAN_MEMBER:
               this.onTabChange(1);
               break;
            case PRaidEvent.ASK:
            case PRaidEvent.HELP:
               this.onTabChange(this.isClan ? 1 : 0);
               break;
            case PRaidEvent.CHAT_MESSAGE:
               this.onTabChange(0);
               break;
            case PRaidEvent.SET_CLAN_ROLE:
               if((_loc2_.value as PSetRole).sr_user_id == Preloader.uid)
               {
                  this.checkApprove();
                  this.onTabChange(1);
               }
               break;
            case PRaidEvent.NEW_CLAN_REQUEST:
            case PRaidEvent.DEL_CLAN_REQUEST:
               if(this.isApprove)
               {
                  this.onTabChange(1);
               }
         }
      }
   }
}

