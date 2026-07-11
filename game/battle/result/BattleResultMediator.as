package game.battle.result
{
   import game.battle.RaidMembersProxy;
   import game.common.DialogMediator;
   import game.portal.PortalMediator;
   import model.ui.VOBattleItem;
   import model.vo.VORaidMember;
   import proto.model.PCost;
   import proto.model.PCurrentAdventure;
   import proto.model.PFightType;
   import proto.model.PGroupFightInfo;
   import proto.model.PMissionInfo;
   import proto.model.PRaidPrePrize;
   import proto.model.PShareFight;
   import proto.model.PShopBuilding;
   import proto.model.PTargetInfo;
   import proto.tuples.str_i;
   import ui.vbase.VEvent;
   import utils.CostHelper;
   
   public class BattleResultMediator extends DialogMediator
   {
      
      private var targetList:Array;
      
      private var targetInfo:PTargetInfo;
      
      private var isWin:Boolean;
      
      private var deathSoldierDp:Array;
      
      private var membersProxy:RaidMembersProxy;
      
      private var damage:uint;
      
      private var heroRaid:Boolean;
      
      public function BattleResultMediator(param1:PTargetInfo, param2:uint, param3:Boolean, param4:Array, param5:RaidMembersProxy, param6:Array, param7:Boolean)
      {
         super();
         this.targetInfo = param1;
         this.isWin = param3;
         this.deathSoldierDp = param4;
         this.membersProxy = param5;
         this.damage = param2;
         this.targetList = param6;
         this.heroRaid = param7;
      }
      
      public function assign(param1:Boolean, param2:Array, param3:int, param4:PMissionInfo, param5:Boolean, param6:PCurrentAdventure) : BattleResultDialog
      {
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:String = null;
         if(this.isWin)
         {
            _loc8_ = 0;
            if(param5)
            {
               _loc8_ = Facade.references.mission_win;
            }
            else if(!this.heroRaid)
            {
               if(!param1)
               {
                  if(!param4)
                  {
                     if(!this.targetInfo.ti_is_revenge && !this.targetInfo.ti_war_attack)
                     {
                        _loc8_ = Facade.references.pvp_win;
                     }
                  }
               }
            }
            if(_loc8_ > 0)
            {
               param2.push(PCost.create(PCost.CLAN_POINTS,_loc8_));
            }
         }
         if(!param2)
         {
            _loc9_ = true;
            param2 = [];
            if(param5)
            {
               param2.push(PCost.create(param4.mi_jglory > 0 ? PCost.J_GLORY : (param4.mi_rar_dragon > 0 ? PCost.RAR_DRAGON : (param4.mi_mithril > 0 ? PCost.MITHRIL : PCost.CRYSTAL)),0));
            }
            else
            {
               param2.push(PCost.create(PCost.CRYSTAL,0),PCost.create(PCost.OIL,0));
            }
         }
         if(param1)
         {
            _loc10_ = Lang.getString((this.targetInfo.ti_fight_type.value as PGroupFightInfo).fgi_raid_kind);
         }
         else if(this.targetInfo.ti_fight_type.variance == PFightType.SINGLE)
         {
            _loc10_ = this.targetInfo.ti_user_base.name;
         }
         var _loc7_:BattleResultDialog = new BattleResultDialog(this.isWin,_loc9_ || param5 ? null : this.targetInfo.ti_share,this.targetInfo.ti_fight_type.variance,_loc10_);
         if(param1)
         {
            if(_loc9_)
            {
               _loc7_.initRaid(null,this.deathSoldierDp,null,this.damage,this.targetList);
            }
            else
            {
               this.initResultRaid(_loc7_,param2,this.targetInfo);
            }
         }
         else
         {
            if(param5)
            {
               _loc7_.initJaina(this.damage,param2,this.deathSoldierDp,this.isWin && (!param6 || !param6.is_jaina_mission_finished) ? mp.getJainaBuild(param4.mi_kind) : null);
            }
            else
            {
               if(this.isWin)
               {
                  _loc7_.addBonus(param3,this.getBonusPrize(this.damage,param2,this.targetInfo,param4),this.targetInfo.ti_warpoints,this.targetInfo.ti_ticket);
               }
               else
               {
                  _loc7_.addBonus(param3,null,0,NaN);
               }
               _loc7_.init(param2,this.damage,this.deathSoldierDp,this.targetList);
            }
            if(this.targetInfo.ti_fight_type.value == "ms_mission3")
            {
               _loc7_.addListener(VEvent.CLOSE_DIALOG,this.onResultMs3Close);
            }
         }
         _loc7_.mediator = this;
         Facade.mainMediator.showDialog(_loc7_);
         Facade.audioProxy.play(this.isWin ? "battle_win" : "battle_lose");
         return _loc7_;
      }
      
      private function getBonusPrize(param1:uint, param2:Array, param3:PTargetInfo, param4:PMissionInfo) : Array
      {
         var _loc6_:* = 0;
         var _loc7_:PCost = null;
         var _loc5_:Array = param4 ? param4.mi_win_prize.costs : (param1 >= Facade.references.pvp_ore_min_perc * 100 ? param3.ti_prize : null);
         if(_loc5_)
         {
            _loc6_ = int(_loc5_.length - 1);
            while(_loc6_ >= 0)
            {
               _loc7_ = _loc5_[_loc6_] as PCost;
               if((Boolean(_loc7_)) && (_loc7_.variance == PCost.CRYSTAL || _loc7_.variance == PCost.OIL))
               {
                  _loc5_.splice(_loc6_,1);
                  CostHelper.addCostToList(param2,_loc7_.variance,_loc7_.value);
               }
               _loc6_--;
            }
         }
         return _loc5_;
      }
      
      private function initResultRaid(param1:BattleResultDialog, param2:Array, param3:PTargetInfo) : void
      {
         var _loc4_:Array = null;
         var _loc7_:VORaidMember = null;
         var _loc8_:str_i = null;
         var _loc9_:Number = NaN;
         var _loc10_:String = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:PRaidPrePrize = null;
         var _loc14_:PCost = null;
         this.membersProxy.list.sort(this.membersProxy.resultSort);
         var _loc5_:uint = 0;
         var _loc6_:PGroupFightInfo = param3.ti_fight_type.value as PGroupFightInfo;
         for each(_loc7_ in this.membersProxy.list)
         {
            _loc5_ += _loc7_.dropCapacity;
            if(!_loc7_.isBot)
            {
               if(!this.heroRaid)
               {
                  for each(_loc8_ in _loc6_.fgi_hspaces)
                  {
                     if(_loc8_.field_0 == _loc7_.id)
                     {
                        _loc7_.maxCapacity = _loc8_.field_1;
                     }
                  }
               }
               else
               {
                  _loc7_.maxCapacity = _loc7_.dropCapacity;
               }
            }
            _loc7_.heroList = null;
         }
         if(_loc5_ > 0)
         {
            _loc9_ = this.heroRaid ? 0 : Facade.references.raid_min_hspace_landing / 100;
            _loc10_ = _loc6_.fgi_raid_kind;
            for each(_loc7_ in this.membersProxy.list)
            {
               if(!_loc7_.losing)
               {
                  _loc7_.heroList = [];
                  _loc11_ = _loc7_.dropCapacity / _loc7_.maxCapacity;
                  if(_loc11_ >= _loc9_)
                  {
                     _loc12_ = _loc7_.dropCapacity / _loc5_;
                     if(this.heroRaid && this.isWin)
                     {
                        for each(_loc13_ in (param3.ti_fight_type.value as PGroupFightInfo).fgi_pre_prize)
                        {
                           if(_loc7_.id == _loc13_.user_id)
                           {
                              for each(_loc14_ in _loc13_.pre_prize)
                              {
                                 _loc7_.heroList.push(PCost.create(_loc14_.variance,Math.round(_loc14_.value)));
                              }
                           }
                        }
                     }
                     else
                     {
                        for each(_loc14_ in param2)
                        {
                           _loc7_.heroList.push(PCost.create(_loc14_.variance,Math.round(_loc14_.value * (_loc14_.variance == PCost.CLAN_POINTS ? 1 : _loc12_))));
                        }
                     }
                     if(this.isWin)
                     {
                        for each(_loc14_ in PortalMediator.getRaidReward(_loc10_,_loc7_.soldierLevelHash,_loc11_ > 1 ? 1 : _loc11_))
                        {
                           _loc7_.heroList.unshift(_loc14_);
                        }
                     }
                  }
                  if(_loc7_.id == Preloader.uid)
                  {
                     _loc4_ = _loc7_.heroList;
                  }
               }
            }
         }
         param1.initRaid(_loc4_,this.deathSoldierDp,this.membersProxy.list,this.damage,this.targetList,this.heroRaid);
      }
      
      private function onResultMs3Close(param1:VEvent) : void
      {
         Facade.changeUserStage("tryCampaignMission3_reward_close");
      }
      
      public function assignStorm(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean = false) : StormResultDialog
      {
         var _loc8_:VOBattleItem = null;
         var _loc9_:String = null;
         var _loc6_:uint = 0;
         if(!param2)
         {
            if(param3)
            {
               for each(_loc8_ in this.deathSoldierDp)
               {
                  _loc6_ += _loc8_.count;
               }
            }
         }
         if(param1)
         {
            _loc9_ = "war_attack_go";
         }
         else if(param3)
         {
            _loc9_ = "war_defence_go";
         }
         else
         {
            _loc9_ = "rd_storm";
         }
         var _loc7_:StormResultDialog = new StormResultDialog(param4,this.damage,this.deathSoldierDp,_loc6_,_loc9_,param5,param1);
         _loc7_.mediator = this;
         Facade.mainMediator.showDialog(_loc7_);
         return _loc7_;
      }
   }
}

