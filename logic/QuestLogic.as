package logic
{
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Fence;
   import engine.units.Garbage;
   import engine.units.Unit;
   import game.feature.FeatureMediator;
   import game.my.MyMediator;
   import logic.quests.GuardHelpTrain;
   import logic.quests.MissionHelpTrain;
   import logic.quests.RaidHelpTrain;
   import logic.training.AbstractTrain;
   import logic.training.AbstractTrainStep;
   import logic.training.DownStep;
   import model.vo.VOGuardSpec;
   import model.vo.VOQuest;
   import proto.model.PAction;
   import proto.model.PBtype;
   import proto.model.PKindCount;
   import proto.model.PQuestTargetInfo;
   import ui.common.RectButton;
   import ui.vbase.VButton;
   
   public class QuestLogic
   {
      
      private static var kind:String;
      
      private static var train:AbstractTrain;
      
      private static var step:AbstractTrainStep;
      
      private static var additionalInfo:Object;
      
      public static const QH_TO_HERO:uint = 12;
      
      public static const QH_TO_RAID:uint = 11;
      
      public static const QH_TO_SHOP:uint = 10;
      
      public static const QH_TO_BARRACKS:uint = 9;
      
      public static const QH_TO_ACADEMY:uint = 8;
      
      public static const QH_TO_GUARD:uint = 7;
      
      public static const QH_ATTACK:uint = 6;
      
      public static const QH_TO_MISSION:uint = 5;
      
      public static const QH_UPGRADE:uint = 4;
      
      public static const QH_ACCELERATE:uint = 3;
      
      public static const QH_COLLECT:uint = 2;
      
      public static const QH_REMOVE:uint = 1;
      
      public static const QH_NOTHING:uint = 0;
      
      public function QuestLogic()
      {
         super();
      }
      
      public static function defineHelpType(param1:PQuestTargetInfo) : uint
      {
         var _loc2_:Vector.<Fence> = null;
         var _loc3_:Vector.<Cannon> = null;
         var _loc4_:Vector.<Build> = null;
         var _loc5_:Build = null;
         additionalInfo = null;
         switch(param1.qti_action.variance)
         {
            case PAction.AC_HAVE_UNIT:
            case PAction.AC_TRAIN_UNIT:
               return QH_TO_BARRACKS;
            case PAction.AC_START_CAMPAIGN_MISSION:
            case PAction.AC_FINISH_CAMPAIGN_MISSION:
               additionalInfo = param1.qti_kind;
               return QH_TO_MISSION;
            case PAction.AC_START_SIDE_MISSION:
            case PAction.AC_FINISH_SIDE_MISSION:
               additionalInfo = [param1.qti_kind];
               return QH_TO_MISSION;
            case PAction.AC_HIRE_GUARD:
               return QH_TO_GUARD;
            case PAction.AC_REMOVE_STONE:
               additionalInfo = "stone";
               return QH_REMOVE;
            case PAction.AC_REMOVE_TREE:
               additionalInfo = "tree";
               return QH_REMOVE;
            case PAction.AC_REMOVE_GARBAGE:
               return QH_REMOVE;
            case PAction.AC_RESEARCH:
               return QH_TO_ACADEMY;
            case PAction.AC_USE_HERO:
            case PAction.AC_USE_UNIT:
               if(Facade.userProxy.soldierCountHash[param1.qti_kind] == 0)
               {
                  return QH_TO_BARRACKS;
               }
               return QH_ATTACK;
               break;
            case PAction.AC_WIN_ATTACK:
            case PAction.AC_ATTACK:
            case PAction.AC_EARN_RATING:
            case PAction.AC_HAVE_RATING:
            case PAction.AC_ROB_RESOURCE:
            case PAction.AC_DESTROY_BUILDING:
            case PAction.AC_DESTROY_CANNON:
            case PAction.AC_DESTROY_FENCE:
               return QH_ATTACK;
            case PAction.AC_HAVE_RESOURCE:
               if(Facade.userProxy.getBuildEx(param1.qti_kind == "C" ? "bl_crystal_mine" : "bl_oil_tower",true,1))
               {
                  return QH_COLLECT;
               }
               return QH_ATTACK;
               break;
            case PAction.AC_HARVEST_STACK:
            case PAction.AC_HARVEST_RESOURCE:
               return QH_COLLECT;
            case PAction.AC_HAVE_DECOR:
               return QH_TO_SHOP;
            case PAction.AC_FINISH_FENCE:
               _loc2_ = new Vector.<Fence>();
               Facade.userProxy.getFence(param1.qti_kind,0,_loc2_);
               if(_loc2_.length < param1.qti_count)
               {
                  return QH_TO_SHOP;
               }
               if(levelUp(_loc2_,param1.qti_level))
               {
                  return QH_UPGRADE;
               }
               return QH_TO_SHOP;
               break;
            case PAction.AC_FINISH_CANNON:
               _loc3_ = new Vector.<Cannon>();
               Facade.userProxy.getCannon(param1.qti_kind,false,0,_loc3_);
               if(_loc3_.length < param1.qti_count)
               {
                  return QH_TO_SHOP;
               }
               if(levelUp(_loc3_,param1.qti_level))
               {
                  return QH_UPGRADE;
               }
               if(canspeedup(_loc3_))
               {
                  additionalInfo = canspeedup(_loc3_);
                  return QH_ACCELERATE;
               }
               return QH_TO_SHOP;
               break;
            case PAction.AC_FINISH_BUILDING:
               _loc4_ = new Vector.<Build>();
               Facade.userProxy.getBuildEx(param1.qti_kind,false,0,_loc4_);
               if(_loc4_.length < param1.qti_count)
               {
                  return QH_TO_SHOP;
               }
               if(levelUp(_loc4_,param1.qti_level))
               {
                  return QH_UPGRADE;
               }
               if(canspeedup(_loc4_))
               {
                  additionalInfo = canspeedup(_loc4_);
                  return QH_ACCELERATE;
               }
               return QH_TO_SHOP;
               break;
            case PAction.AC_HERO_HAVE_ARMOR:
               additionalInfo = FeatureMediator.HERO_ARMOR;
               return QH_TO_HERO;
            case PAction.AC_HERO_HAVE_DAMAGE:
               additionalInfo = FeatureMediator.HERO_DMG;
               return QH_TO_HERO;
            case PAction.AC_HERO_HAVE_HP:
               additionalInfo = FeatureMediator.HERO_HP;
               return QH_TO_HERO;
            case PAction.AC_UPGRADE_HERO_REGENTIME:
               additionalInfo = FeatureMediator.HERO_REGEN;
               return QH_TO_HERO;
            case PAction.AC_UPGRADE_HERO_ARMOR:
               additionalInfo = FeatureMediator.HERO_ARMOR;
               return QH_TO_HERO;
            case PAction.AC_UPGRADE_HERO_DAMAGE:
               additionalInfo = FeatureMediator.HERO_DMG;
               return QH_TO_HERO;
            case PAction.AC_UPGRADE_HERO_HP:
               additionalInfo = FeatureMediator.HERO_HP;
               return QH_TO_HERO;
            case PAction.AC_UPGRADE_HERO:
               _loc5_ = Facade.userProxy.getBuild(PBtype.HERO,false,0);
               if(_loc5_.updateLevel > 0)
               {
                  additionalInfo = _loc5_;
                  return QH_ACCELERATE;
               }
               return QH_UPGRADE;
               break;
            case PAction.AC_WIN_RAID:
            case PAction.AC_RAID:
               return QH_TO_RAID;
            default:
               return QH_NOTHING;
         }
      }
      
      public static function getHelpButton(param1:VOQuest) : RectButton
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:uint = defineHelpType(param1.target);
         switch(_loc2_)
         {
            case QH_TO_HERO:
               _loc3_ = "help_toHero";
               break;
            case QH_TO_RAID:
               _loc3_ = "help_toRaid";
               break;
            case QH_TO_SHOP:
               _loc3_ = "help_toShop";
               break;
            case QH_TO_BARRACKS:
               _loc3_ = "help_toRax";
               break;
            case QH_TO_ACADEMY:
               _loc3_ = "help_toAcademy";
               break;
            case QH_TO_GUARD:
               _loc3_ = "help_toGuard";
               break;
            case QH_ATTACK:
               _loc3_ = "help_attack";
               break;
            case QH_TO_MISSION:
               _loc3_ = "help_toMission";
               break;
            case QH_UPGRADE:
               _loc3_ = "updateBt";
               break;
            case QH_ACCELERATE:
               _loc3_ = "speedupBt";
               _loc4_ = RectButton.GREEN;
               break;
            case QH_COLLECT:
               _loc3_ = "collectQuestBt";
               break;
            case QH_REMOVE:
               _loc3_ = "garbageBt";
         }
         return _loc3_ ? new RectButton(Lang.getString(_loc3_),RectButton.h42,_loc4_ ? _loc4_ : RectButton.ORANGE) : null;
      }
      
      public static function onHelp(param1:VOQuest) : void
      {
         var _loc4_:Build = null;
         var _loc5_:Garbage = null;
         var _loc6_:Cannon = null;
         Facade.mainMediator.closeAllDialog();
         kind = param1.target.qti_kind;
         var _loc2_:uint = isNaN(param1.target.qti_level) ? 0 : uint(param1.target.qti_level);
         var _loc3_:uint = defineHelpType(param1.target);
         switch(_loc3_)
         {
            case QH_TO_HERO:
               _loc4_ = Facade.userProxy.getBuildEx(Facade.manualProxy.getHeroShop(kind,1).sh_kind,false);
               if((Boolean(_loc4_)) && _loc4_.updateLevel != 1)
               {
                  Facade.mainMediator.showDialog(new FeatureMediator(_loc4_,false,additionalInfo as uint));
                  break;
               }
               throw new Error("no hero build " + kind);
               break;
            case QH_TO_RAID:
               assign(new RaidHelpTrain(kind));
               break;
            case QH_TO_SHOP:
               DialogLogic.openShop(null,kind);
               break;
            case QH_TO_BARRACKS:
               _loc4_ = additionalInfo is Build ? additionalInfo as Build : Facade.userProxy.getBuild(PBtype.BARRACK,false);
               if(!_loc4_)
               {
                  throw new Error("no information about rax " + kind + " " + _loc2_);
               }
               UnitFactory.buildLogic.goInsideBuild(_loc4_,kind);
               break;
            case QH_TO_ACADEMY:
               _loc4_ = additionalInfo is Build ? additionalInfo as Build : Facade.userProxy.getBuild(PBtype.RESEARCH,false);
               if(_loc4_)
               {
                  UnitFactory.buildLogic.goInsideBuild(_loc4_,kind);
                  break;
               }
               Facade.mainMediator.showMessage(Lang.getString("no_academy"));
               break;
            case QH_TO_GUARD:
               toGuard();
               break;
            case QH_ATTACK:
               attackHelp();
               break;
            case QH_TO_MISSION:
               assign(new MissionHelpTrain(additionalInfo));
               break;
            case QH_UPGRADE:
               updateHelp(_loc2_);
               break;
            case QH_ACCELERATE:
               if(kind.substr(0,2) == "cn")
               {
                  _loc6_ = additionalInfo is Cannon ? additionalInfo as Cannon : Facade.userProxy.getCannon(kind,false);
                  if(_loc6_)
                  {
                     Facade.boardMediator.setSelected(_loc6_);
                     Facade.boardMediator.moveBoard(_loc6_.t_x,_loc6_.t_y);
                     assignClickStep(MyMediator.speedupBt);
                     break;
                  }
                  Facade.mainMediator.showMessage(Lang.getString("no_turret"));
                  break;
               }
               _loc4_ = additionalInfo is Build ? additionalInfo as Build : Facade.userProxy.getBuildEx(kind,false);
               if(_loc4_)
               {
                  Facade.boardMediator.setSelected(_loc4_);
                  Facade.boardMediator.moveBoard(_loc4_.t_x,_loc4_.t_y);
                  assignClickStep(MyMediator.speedupBt);
                  break;
               }
               Facade.mainMediator.showMessage(Lang.getString("no_build"));
               break;
            case QH_COLLECT:
               kind = kind == "C" ? "bl_crystal_mine" : "bl_oil_tower";
               _loc4_ = additionalInfo is Build ? additionalInfo as Build : Facade.userProxy.getBuildEx(kind,true,1);
               if(_loc4_)
               {
                  Facade.boardMediator.setSelected(_loc4_);
                  Facade.boardMediator.moveBoard(_loc4_.t_x,_loc4_.t_y);
                  assignClickStep(MyMediator.commonBt);
                  break;
               }
               Facade.mainMediator.showMessage(Lang.getPatternString("no_target_build","__BUILD__",kind,true));
               break;
            case QH_REMOVE:
               _loc5_ = Facade.userProxy.garbageList.head as Garbage;
               while(_loc5_)
               {
                  if(!_loc5_.cleaning && (!additionalInfo || _loc5_.shop.sg_gtype == additionalInfo) && (!kind || _loc5_.kind == kind))
                  {
                     break;
                  }
                  _loc5_ = _loc5_.link_next as Garbage;
               }
               if(_loc5_)
               {
                  Facade.boardMediator.setSelected(_loc5_);
                  Facade.boardMediator.moveBoard(_loc5_.t_x,_loc5_.t_y);
                  assignClickStep(MyMediator.commonBt);
                  break;
               }
               Facade.mainMediator.showMessage(Lang.getString("not_garbage"));
         }
      }
      
      private static function updateHelp(param1:uint) : void
      {
         var _loc2_:Unit = null;
         var _loc3_:Vector.<Build> = null;
         var _loc4_:* = 0;
         var _loc5_:Vector.<Cannon> = null;
         var _loc6_:Vector.<Fence> = null;
         if(!kind)
         {
            return;
         }
         if(kind.substr(0,2) == "bl")
         {
            _loc3_ = new Vector.<Build>();
            Facade.userProxy.getBuildEx(kind,false,0,_loc3_);
            _loc4_ = int(_loc3_.length - 1);
            while(_loc4_ >= 0)
            {
               if(_loc3_[_loc4_].level < param1)
               {
                  _loc2_ = _loc3_[_loc4_];
                  if(_loc3_[_loc4_].updateLevel == 0)
                  {
                     break;
                  }
               }
               _loc4_--;
            }
         }
         else if(kind.substr(0,2) == "cn")
         {
            _loc5_ = new Vector.<Cannon>();
            Facade.userProxy.getCannon(kind,false,0,_loc5_);
            _loc4_ = int(_loc5_.length - 1);
            while(_loc4_ >= 0)
            {
               if(_loc5_[_loc4_].level < param1)
               {
                  _loc2_ = _loc5_[_loc4_];
                  if(_loc5_[_loc4_].updateLevel == 0)
                  {
                     break;
                  }
               }
               _loc4_--;
            }
         }
         else if(kind.substr(0,2) == "fn")
         {
            _loc6_ = new Vector.<Fence>();
            Facade.userProxy.getFence(kind,0,_loc6_);
            _loc4_ = int(_loc6_.length - 1);
            while(_loc4_ >= 0)
            {
               if(_loc6_[_loc4_].level < param1)
               {
                  _loc2_ = _loc6_[_loc4_];
                  break;
               }
               _loc4_--;
            }
         }
         else if(kind.substr(0,2) == "un")
         {
            _loc2_ = Facade.userProxy.getBuild(PBtype.HERO,false);
         }
         if(!_loc2_)
         {
            _loc2_ = additionalInfo as Unit;
         }
         if(_loc2_)
         {
            Facade.boardMediator.setSelected(_loc2_);
            Facade.boardMediator.moveBoard(_loc2_.t_x,_loc2_.t_y);
            assignClickStep(MyMediator.updateBt);
         }
         else
         {
            DialogLogic.openShop(null,kind);
         }
      }
      
      private static function attackHelp() : void
      {
         assign(new DownStep(DialogLogic.openGo().pvpBt,0,{"hCenter":0}));
      }
      
      private static function levelUp(param1:Object, param2:uint) : Boolean
      {
         var _loc4_:Build = null;
         var _loc5_:Cannon = null;
         var _loc6_:Fence = null;
         var _loc3_:Boolean = false;
         if(param1 is Vector.<Build>)
         {
            for each(_loc4_ in param1)
            {
               if(_loc4_.level < param2 && _loc4_.updateLevel != param2)
               {
                  _loc3_ = true;
                  break;
               }
            }
         }
         else if(param1 is Vector.<Cannon>)
         {
            for each(_loc5_ in param1)
            {
               if(_loc5_.level < param2 && _loc5_.updateLevel != param2)
               {
                  _loc3_ = true;
                  break;
               }
            }
         }
         else if(param1 is Vector.<Fence>)
         {
            for each(_loc6_ in param1)
            {
               if(_loc6_.level < param2)
               {
                  _loc3_ = true;
                  break;
               }
            }
         }
         return _loc3_;
      }
      
      private static function canspeedup(param1:Object) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:Build = null;
         var _loc4_:Cannon = null;
         if(param1 is Vector.<Build>)
         {
            for each(_loc3_ in param1)
            {
               if(_loc3_.updateLevel > 0)
               {
                  _loc2_ = _loc3_;
                  break;
               }
            }
         }
         else if(param1 is Vector.<Cannon>)
         {
            for each(_loc4_ in param1)
            {
               if(_loc4_.updateLevel > 0)
               {
                  _loc2_ = _loc4_;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      private static function toGuard() : void
      {
         var _loc2_:Build = null;
         var _loc3_:VOGuardSpec = null;
         var _loc4_:uint = 0;
         var _loc5_:PKindCount = null;
         var _loc1_:Vector.<Build> = new Vector.<Build>();
         Facade.userProxy.getBuild(PBtype.GUARD,true,0,_loc1_);
         for each(_loc2_ in _loc1_)
         {
            _loc3_ = _loc2_.spec as VOGuardSpec;
            _loc4_ = 0;
            for each(_loc5_ in _loc3_.configList)
            {
               _loc4_ += _loc5_.count * Facade.manualProxy.getSoldierShop(_loc5_.kind,1).su_hspace;
            }
            if(_loc4_ < _loc3_.capacity)
            {
               break;
            }
         }
         if(_loc2_)
         {
            assign(new GuardHelpTrain(_loc2_));
         }
      }
      
      private static function assignClickStep(param1:VButton, param2:Number = 0, param3:Object = null) : void
      {
         if(!param1.parent)
         {
            return;
         }
         assign(new DownStep(param1,param2,param3 ? param3 : {
            "hCenter":0,
            "top":0
         }));
      }
      
      private static function assign(param1:Object, param2:Function = null) : void
      {
         if(train)
         {
            train.dispose();
            train = null;
         }
         else if(step)
         {
            step.dispose();
            step = null;
         }
         if(param1)
         {
            if(param1 is AbstractTrainStep)
            {
               step = param1 as AbstractTrainStep;
               step.endFunc = param2 != null ? param2 : clear;
               step.run();
            }
            else
            {
               train = param1 as AbstractTrain;
               train.run();
            }
         }
      }
      
      public static function clear(param1:String = null) : void
      {
         if(!param1 || QuestLogic.kind == param1)
         {
            QuestLogic.kind = null;
            assign(null);
            additionalInfo = null;
         }
      }
   }
}

