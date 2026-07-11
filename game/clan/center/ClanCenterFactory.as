package game.clan.center
{
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class ClanCenterFactory
   {
      
      public static const TOP_CLANS:uint = 0;
      
      public static const EDIT_CLAN:uint = 2;
      
      public static const DONATE:uint = 3;
      
      public static const TREASURY:uint = 4;
      
      public static const TO_POLITICAL_MAP:uint = 5;
      
      public static const CLAN_LEAGUE:uint = 6;
      
      public static const MEMBERS:uint = 7;
      
      public static const LEAVE:uint = 8;
      
      public static const JOIN:uint = 9;
      
      public static const TO_WAR_LIST:uint = 10;
      
      public static const TO_CAPITAL:uint = 11;
      
      public static const WAR:uint = 12;
      
      public static const TO_TERRITORY_STORM:uint = 13;
      
      public static const TO_INFO_DIALOG:uint = 14;
      
      public static const SEASONS:uint = 15;
      
      public static const DONATE_ALERT:uint = 16;
      
      public function ClanCenterFactory()
      {
         super();
      }
      
      public static function createFill() : VFill
      {
         var _loc1_:VFill = new VFill(16777215,0.15,8);
         _loc1_.setLine(1,0,0.2);
         return _loc1_;
      }
      
      public static function createResourcePanel(param1:uint, param2:int) : StatPanel
      {
         var _loc4_:StatPanel = null;
         var _loc3_:VSkin = SkinManager.getEmbed(CostHelper.getKind(param1,true),VSkin.LEFT);
         _loc3_.layoutW = 46;
         _loc4_ = new StatPanel(_loc3_,StringHelper.getCurrencyValue(param2),0,0);
         _loc4_.hint = Lang.getString(CostHelper.getKind(param1));
         return _loc4_;
      }
   }
}

