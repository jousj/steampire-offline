package logic
{
   import clans.ClanDialog;
   import clans.ClanMedialor;
   import engine.units.Build;
   import game.barrack.BarrackMediator;
   import game.capital.CapitalMediator;
   import game.clan.center.ClanCenterMediator;
   import game.clan.center.TopClansMediator;
   import game.clan.donate.DonateMediator;
   import game.clan.war.WarEnemyMediator;
   import game.common.MainMediator;
   import game.friends.FriendsMediator;
   import game.history.HistoryMediator;
   import game.missions.MissionMapMediator;
   import game.my.GoDialog;
   import game.my.GoMediator;
   import game.political.PoliticalMapMediator;
   import game.rank.RankMediator;
   import game.shop.ShopMediator;
   import proto.model.PBtype;
   import ui.common.BaseDialog;
   
   public class DialogLogic
   {
      
      public function DialogLogic()
      {
         super();
      }
      
      public static function open(param1:Object) : BaseDialog
      {
         return Facade.mainMediator.showDialog(param1);
      }
      
      public static function openGo() : GoDialog
      {
         return open(new GoMediator()) as GoDialog;
      }
      
      public static function openClanCenter(param1:Boolean = true) : void
      {
         if(Facade.userProxy.getBuild(PBtype.CLAN,false))
         {
            open(new ClanMedialor());
            if(param1)
            {
               Facade.userProxy.updateClanData();
            }
         }
         else
         {
            Facade.myMediator.showBuildNeed("clan_center_need","bl_clan_center","ClanEmblemIcon","bl_clan_center");
         }
      }
      
      public static function openClanAbout(param1:String, param2:Boolean = false) : void
      {
         if(Boolean(Facade.userProxy.clan) && param1 == Facade.userProxy.clan.uc_clan_id)
         {
            param1 = null;
         }
         if(param1)
         {
            open(new ClanCenterMediator(param1,param2));
         }
         else
         {
            openClanCenter();
         }
      }
      
      public static function openDonate(param1:Vector.<uint> = null) : BaseDialog
      {
         return open(new DonateMediator(param1));
      }
      
      public static function openHistory(param1:Boolean = false, param2:uint = 0, param3:Boolean = false) : void
      {
         open(new HistoryMediator(param1,param2,param3));
      }
      
      public static function openFriends(param1:uint = 0, param2:Boolean = false) : void
      {
         var _loc3_:FriendsMediator = new FriendsMediator();
         _loc3_.useClan = true;
         if(param2)
         {
            _loc3_.dialog.tabPanel.index = 1;
         }
         _loc3_.saveIndex = param1;
         open(_loc3_);
      }
      
      public static function openTopClans() : void
      {
         var _loc2_:ClanMedialor = null;
         var _loc1_:ClanDialog = Facade.mainMediator.searchDialog(ClanDialog);
         if(!_loc1_)
         {
            _loc2_ = new ClanMedialor();
            open(_loc2_);
            _loc1_ = _loc2_.dialog;
         }
         _loc1_.setTab(ClanDialog.TOPS,3);
      }
      
      public static function openPoliticalMap(param1:* = null, param2:int = -1) : void
      {
         open(new PoliticalMapMediator(param1,param2));
      }
      
      public static function openShop(param1:String = null, param2:String = null, param3:Boolean = true) : void
      {
         if(Facade.isCapital)
         {
            CapitalMediator.instance.toShop(param1,param2);
         }
         else
         {
            open(new ShopMediator(param1,param2,param3));
         }
      }
      
      public static function toMissionMap() : void
      {
         open(new MissionMapMediator());
      }
      
      public static function openRank(param1:int = -1, param2:* = null) : void
      {
         open(new RankMediator(param1,param2));
      }
      
      public static function openWar() : void
      {
         var _loc2_:ClanMedialor = null;
         var _loc1_:ClanDialog = Facade.mainMediator.searchDialog(ClanDialog);
         if(!_loc1_)
         {
            _loc2_ = new ClanMedialor();
            open(_loc2_);
            _loc1_ = _loc2_.dialog;
         }
         _loc1_.setTab(ClanDialog.WAR,0);
      }
      
      public static function openWarEnemy() : void
      {
         open(new WarEnemyMediator());
      }
      
      public static function openWarList(param1:String = null) : void
      {
         var _loc3_:ClanMedialor = null;
         var _loc2_:ClanDialog = Facade.mainMediator.searchDialog(ClanDialog);
         if(!_loc2_)
         {
            _loc3_ = new ClanMedialor();
            open(_loc3_);
            _loc2_ = _loc3_.dialog;
         }
         _loc2_.setTab(ClanDialog.WAR,1);
      }
      
      public static function insideBuild(param1:uint) : void
      {
         var _loc2_:Build = Facade.userProxy.getBuild(param1,false);
         if(_loc2_)
         {
            UnitFactory.buildLogic.goInsideBuild(_loc2_);
         }
      }
      
      public static function sleepReOpen() : void
      {
         var _loc1_:MainMediator = Facade.mainMediator;
         var _loc2_:Function = null;
         var _loc3_:Array = null;
         if(_loc1_.searchDialog(BarrackMediator))
         {
            _loc2_ = insideBuild;
            _loc3_ = [PBtype.BARRACK];
         }
         else if(_loc1_.searchDialog(TopClansMediator))
         {
            _loc2_ = openTopClans;
         }
         else if(_loc1_.searchDialog(ClanCenterMediator))
         {
            _loc2_ = openClanCenter;
         }
         else if(_loc1_.searchDialog(ShopMediator))
         {
            _loc2_ = openShop;
         }
         else if(_loc1_.searchDialog(RankMediator))
         {
            _loc2_ = openRank;
         }
         if(_loc2_ != null)
         {
            Facade.setMapCallback(_loc2_,_loc3_);
         }
      }
   }
}

