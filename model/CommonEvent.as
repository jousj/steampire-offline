package model
{
   import flash.events.Event;
   
   public class CommonEvent extends Event
   {
      
      public static const SOCIAL:String = "social";
      
      public static const GOLD:String = "goldChange";
      
      public static const RUBY:String = "rubyChange";
      
      public static const OIL:String = "oilChange";
      
      public static const CRYSTAL:String = "crystalChange";
      
      public static const EXP:String = "expChange";
      
      public static const ENERGY:String = "energyChange";
      
      public static const GLORY:String = "gloryChange";
      
      public static const J_GLORY:String = "jGloryChange";
      
      public static const ORE:String = "oreChange";
      
      public static const RAR_DRAGON:String = "rarDragonChange";
      
      public static const MITHRIL:String = "mithrilChange";
      
      public static const BLUEPRINT:String = "blueprintChange";
      
      public static const RATING:String = "ratingChange";
      
      public static const LEVEL:String = "levelChange";
      
      public static const WORKER:String = "workerChange";
      
      public static const FINISH_RESEARCH:String = "finishResearch";
      
      public static const DAMAGE:String = "damageChange";
      
      public static const BOARD_SCALE:String = "boardScale";
      
      public static const SHOW_DIALOG:String = "showDialog";
      
      public static const BOARD_RESET_DOWN:String = "boardResetDown";
      
      public static const NEW_UNIT:String = "newUnit";
      
      public static const CONSTRUCTION_UP:String = "constructionUp";
      
      public static const BOARD_NOT_PUT:String = "boardNoPut";
      
      public static const MY_GAME_STREAM:String = "myGameStream";
      
      public static const CLAN_RESOURCE:String = "clanResChange";
      
      public var variance:uint;
      
      public var data:*;
      
      public function CommonEvent(param1:String, param2:* = null, param3:uint = 0)
      {
         super(param1);
         this.data = param2;
         this.variance = param3;
      }
   }
}

