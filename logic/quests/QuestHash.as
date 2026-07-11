package logic.quests
{
   import logic.training.AbstractTrain;
   import logic.training.firstsession.BallistaTrain;
   import logic.training.firstsession.BuyQuestFreePosTrain;
   import logic.training.firstsession.HardRewardTrain;
   import logic.training.firstsession.HeroTrain;
   import logic.training.firstsession.TownTrain;
   import logic.training.firstsession.WarriorTrain;
   
   public class QuestHash
   {
      
      public static const learn:Object = {
         "tryCampaignMission2":HardRewardTrain,
         "buildTownhallLvl2":TownTrain,
         "buildSteamTower1Lvl1":BuyQuestFreePosTrain,
         "firstTrainWarrior":BarrackQuestTrain,
         "buildLibraryLvl1":BuyQuestTrain,
         "tryCampaignMission3":LibraryTrain,
         "buildCrystalMine1Lvl1":PlacedQuestTrain,
         "buildOilTower1Lvl1":PlacedQuestTrain,
         "buildPortal":HelpQuestTrain
      };
      
      public function QuestHash()
      {
         super();
      }
      
      public static function checkTrain() : void
      {
         if(!Facade.checkUserStage("home4_hero_click"))
         {
            if(compareStages("m1_fireball_use1","home1_jaina5_click"))
            {
               AbstractTrain.assign(new BallistaTrain());
            }
            else if(compareStages("boss_ruby_shop_free","map3_mission2_attack_click"))
            {
               AbstractTrain.assign(new WarriorTrain());
            }
            else if(compareStages("raid_win_dialog","home4_increase_armor_click"))
            {
               AbstractTrain.assign(new HeroTrain());
            }
         }
      }
      
      private static function compareStages(param1:String, param2:String) : Boolean
      {
         return Facade.checkUserStage(param1) && !Facade.checkUserStage(param2);
      }
   }
}

