package logic.battle
{
   import engine.Isometric;
   import engine.display.AnimClip;
   import engine.display.AnimDisplay;
   import engine.display.Animation;
   import engine.display.EffectClip;
   import engine.spell.AcidSpell;
   import engine.spell.CallSpell;
   import engine.spell.FireSpell;
   import engine.spell.RAASpell;
   import engine.units.AnimObject;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.RadiusUnit;
   import engine.units.Soldier;
   import engine.units.Unit;
   import engine.units.Worker;
   import engine.units.ZObject;
   import flash.geom.Point;
   import logic.ErrorLogic;
   import logic.UnitFactory;
   import logic.sim.SimBoardObj;
   import logic.sim.SimRun;
   import logic.sim.SimUnitT;
   import logic.units.WorkerCureJob;
   import model.BattleProxy;
   import model.vo.VOResourceSpec;
   import model.vo.VOStorageSpec;
   import proto.model.PBtype;
   import proto.model.PCost;
   import proto.model.PShopSpell;
   import proto.model.spell.*;
   import utils.CommonUtils;
   
   public class SimBaseVisual extends SimRun
   {
      
      public var graveHash:Object = {};
      
      public var curTime:int;
      
      protected var isPlayAndSync:Boolean;
      
      public function SimBaseVisual(param1:Array)
      {
         super();
         this.deathSoldierDp = param1;
      }
      
      public static function addCustomBroken(param1:Boolean, param2:String, param3:uint, param4:int, param5:int) : void
      {
         var _loc6_:String = RadiusUnit.getTileName(param3,param1 ? Facade.manualProxy.getCannonMax(param2,param3) : Facade.manualProxy.getBuildMax(param2,param3),AnimClip.resourceProxy.getSize(param2));
         Facade.boardMediator.addTile("broken",(param1 ? "cn_" : "bl_") + _loc6_,param4,param5,CommonUtils.getRangeRandom(0,1) == 1);
         Facade.boardMediator.addTile(param1 ? "tl_cannon" : "tl_build",_loc6_,param4,param5);
      }
      
      public static function syncSpellRadius(param1:PEffect) : void
      {
         var _loc3_:int = 0;
         var _loc2_:uint = param1.variance;
         switch(_loc2_)
         {
            case PEffect.FIREBALL:
               _loc3_ = (param1.value as PFireball).fireball_radius;
               break;
            case PEffect.CURE:
            case PEffect.WORKER:
               _loc3_ = (param1.value as PCure).cure_radius;
               break;
            case PEffect.SHOCK:
               _loc3_ = (param1.value as PShock).shock_radius;
               break;
            case PEffect.MULTIFIREBALL:
               _loc3_ = (param1.value as PMultifireball).mf_radius;
               break;
            case PEffect.LOW_DAMAGE:
               _loc3_ = (param1.value as PLowDamage).low_damage_radius;
               break;
            case PEffect.RAGE:
               _loc3_ = (param1.value as PRage).rage_radius;
               break;
            case PEffect.FOG:
               _loc3_ = (param1.value as PFog).fog_radius;
               break;
            default:
               _loc3_ = -1;
         }
         Facade.boardMediator.spellRadius = _loc3_;
      }
      
      public static function addEffect(param1:String, param2:String, param3:Number, param4:Number, param5:Boolean = false) : void
      {
         var _loc7_:EffectClip = null;
         var _loc6_:Animation = AnimClip.resourceProxy.getAnimation(param1,param2);
         if(_loc6_)
         {
            _loc7_ = EffectClip.create();
            _loc7_.x = param3;
            _loc7_.y = param4;
            if(param5)
            {
               Facade.board.tilePanel.addChild(_loc7_);
            }
            else
            {
               Facade.board.effectPanel.addChild(_loc7_);
            }
            _loc7_.play(_loc6_);
         }
      }
      
      public static function addFlaEffect(param1:String, param2:Unit, param3:Number = 0) : void
      {
         var _loc5_:EffectClip = null;
         var _loc4_:Animation = AnimClip.resourceProxy.getAnimation("fla",param1);
         if(_loc4_)
         {
            _loc5_ = EffectClip.create();
            _loc5_.x = param2.display.x + param2.iconX;
            _loc5_.y = param2.display.y + param2.iconY;
            Facade.board.effectPanel.addChild(_loc5_);
            if(param3 > 0)
            {
               _loc5_.playDelay(_loc4_,param3);
            }
            else
            {
               _loc5_.play(_loc4_);
            }
         }
      }
      
      protected function getConstruction(param1:uint) : Unit
      {
         return Facade.userProxy.constructionHash[param1] as Unit;
      }
      
      protected function getSoldier(param1:uint) : Soldier
      {
         return Facade.userProxy.soldierHash[param1] as Soldier;
      }
      
      protected function getCannon(param1:uint) : Cannon
      {
         return Facade.userProxy.constructionHash[param1] as Cannon;
      }
      
      protected function getUnit(param1:SimBoardObj) : Unit
      {
         return param1.kind == SimBoardObj.UNIT ? this.getSoldier(param1.id) : this.getConstruction(param1.id);
      }
      
      override public function applyDamage(param1:SimBoardObj, param2:int, param3:int, param4:SimUnitT = null) : void
      {
         if(param1.kind != SimBoardObj.UNIT)
         {
            this.applyConstructionDamage(this.getConstruction(param1.id),param2);
         }
      }
      
      protected function applyConstructionDamage(param1:Unit, param2:int) : void
      {
         if(param1 is Build)
         {
            this.steal(param1 as Build,param2);
         }
         if(param2 <= 0)
         {
            this.addBroken(param1);
            UnitFactory.removeConstruction(param1);
         }
      }
      
      private function addBroken(param1:Unit) : void
      {
         var _loc3_:String = null;
         var _loc4_:AnimObject = null;
         var _loc5_:AnimClip = null;
         var _loc2_:uint = param1.size;
         if(_loc2_ > 1)
         {
            if(param1 is Cannon)
            {
               _loc3_ = "cn_" + RadiusUnit.getTileName(param1.level,(param1 as Cannon).updateMax,param1.size);
            }
            else if(param1 is Build)
            {
               _loc3_ = "bl_" + RadiusUnit.getTileName(param1.level,(param1 as Build).updateMax,param1.size);
            }
            if(_loc3_)
            {
               _loc4_ = Facade.boardMediator.addTile("broken",_loc3_,param1.b_x,param1.b_y,CommonUtils.getRangeRandom(0,1) == 1);
               _loc5_ = param1.display.getClip("tile");
               if(_loc5_)
               {
                  param1.display.remove(_loc5_);
                  Facade.board.tilePanel.addChildAt(_loc5_,0);
                  _loc4_.display.add(_loc5_,AnimDisplay.OUTSIDE);
               }
            }
         }
         if(this.isPlayAndSync)
         {
            addEffect("effects",param1.size == 1 ? "fn_boom" : "bl_boom",param1.display.x,param1.display.y - (param1.size - 1) * Isometric.POS_HALF_HEIGHT);
            Facade.audioProxy.play("destroy_build");
         }
      }
      
      override public function unitDeath(param1:SimUnitT) : void
      {
         var _loc5_:Animation = null;
         var _loc6_:ZObject = null;
         var _loc7_:int = 0;
         var _loc8_:Point = null;
         if(param1.is_attacker)
         {
            if(param1.user_num < 2)
            {
               addDeathSoldier(param1.shop);
            }
            Facade.battleMediator.checkFinishBattle(null,param1.user_num);
         }
         else if(param1.kind.indexOf("boss") != -1)
         {
            Facade.battleMediator.checkFinishBattle(param1.kind,0);
         }
         if(!param1.is_kamikaze && (!param1.is_air || Facade.map.getMapCell(param1.pos.x,param1.pos.y).walkType == 0))
         {
            _loc5_ = AnimClip.resourceProxy.getAnimation("effects","un_dead");
         }
         var _loc2_:Soldier = this.isPlayAndSync ? this.getSoldier(param1.id) : null;
         var _loc3_:Boolean = Boolean(_loc2_);
         var _loc4_:Boolean = Facade.isNormalQuality && _loc3_;
         if(_loc3_)
         {
            if(_loc2_.user_num > 0)
            {
               _loc2_.display.removeByName("soldierArea");
            }
            if(!_loc2_.display.parent)
            {
               _loc5_ = null;
            }
         }
         if(_loc5_)
         {
            if(_loc3_)
            {
               _loc7_ = int(_loc2_.z_x / ZObject.POS_WORLD_ONE_SIXTH) * 1000 + int(_loc2_.z_y / ZObject.POS_WORLD_ONE_SIXTH);
            }
            else
            {
               _loc8_ = new Point((CommonUtils.getRangeRandom(0,2) * 2 + 1) / 6,(CommonUtils.getRangeRandom(0,2) * 2 + 1) / 6);
               _loc7_ = int((param1.pos.x + 1 + _loc8_.x) * 6000) + int((param1.pos.y + 1 + _loc8_.y) * 6);
            }
            _loc6_ = this.graveHash[_loc7_] as ZObject;
            if(_loc6_)
            {
               if(_loc3_)
               {
                  UnitFactory.removeSoldier(_loc2_);
               }
               if(!_loc4_)
               {
                  return;
               }
            }
            else
            {
               if(_loc3_)
               {
                  _loc2_.stopWalk();
                  _loc2_.changeMarkerClip(false);
                  _loc2_.setProgress(null);
                  _loc2_.removeShadow();
                  _loc2_.animClip.endHandler = null;
                  if(_loc2_.shop.su_is_air)
                  {
                     Facade.board.airToGround(_loc2_);
                  }
                  else
                  {
                     Facade.board.isNeedZSort = true;
                  }
                  UnitFactory.removeSoldier(_loc2_,true);
                  _loc6_ = _loc2_;
               }
               else
               {
                  _loc6_ = new ZObject();
                  _loc6_.size = 1;
                  _loc6_.setGeometry(param1.pos.x,param1.pos.y,false);
                  Facade.boardMediator.addObject(_loc6_,false,false);
                  _loc6_.z_x += ZObject.POS_WORLD_SIZE * _loc8_.x;
                  _loc6_.z_y += ZObject.POS_WORLD_SIZE * _loc8_.y;
                  Isometric.worldToScreen(_loc6_.z_x,_loc6_.z_y,_loc8_);
                  _loc6_.display.setPos(_loc8_.x,_loc8_.y);
               }
               this.graveHash[_loc7_] = _loc6_;
               _loc6_.t_x = _loc7_;
               _loc6_.kind = "grave";
               _loc6_.z_x += 1;
               _loc6_.z_y += 1;
               _loc6_.z_m = _loc6_.z_x + _loc6_.z_y;
            }
            if(_loc4_ && _loc6_.display.visible)
            {
               _loc6_.playAnim(_loc5_);
               if(_loc2_)
               {
                  Facade.audioProxy.playNum(_loc2_.audioKind + "_death",_loc2_.shop.su_is_hero ? 1 : 5,4);
               }
            }
            else
            {
               _loc6_.goAnim(_loc5_,_loc5_.frameNum - 1);
            }
         }
         else if(_loc3_)
         {
            UnitFactory.removeSoldier(_loc2_);
         }
      }
      
      protected function steal(param1:Build, param2:int) : void
      {
         if(param1.type == PBtype.RESOURCE)
         {
            this.stealResBuild(param1,param2);
         }
         else if(param1.type == PBtype.STORAGE)
         {
            this.stealStorageBuild(param1,param2);
         }
      }
      
      private function stealResBuild(param1:Build, param2:int) : void
      {
         var _loc4_:uint = 0;
         var _loc3_:VOResourceSpec = param1.spec;
         if(_loc3_.prodVariance != PCost.GOLD)
         {
            _loc4_ = _loc3_.capacityCur * (1 - param2 / param1.stamina);
            if(_loc4_ > _loc3_.steal)
            {
               this.applySteal(_loc3_.prodVariance,_loc4_ - _loc3_.steal);
               _loc3_.steal = _loc4_;
               if(this.isPlayAndSync)
               {
                  param1.syncResAnim();
                  if(this.curTime - _loc3_.stealTime > 2000)
                  {
                     _loc3_.stealTime = this.curTime;
                     this.addStealEffect(param1,_loc3_.prodVariance);
                  }
               }
            }
         }
      }
      
      private function stealStorageBuild(param1:Build, param2:int) : void
      {
         var _loc3_:VOStorageSpec = param1.spec;
         var _loc4_:uint = _loc3_.capacityCur * (1 - param2 / param1.stamina);
         if(_loc4_ > _loc3_.steal)
         {
            this.applySteal(_loc3_.costVariance,_loc4_ - _loc3_.steal);
            _loc3_.steal = _loc4_;
            if(this.isPlayAndSync)
            {
               param1.syncResAnim();
               if(this.curTime - _loc3_.stealTime > 2000)
               {
                  _loc3_.stealTime = this.curTime;
                  this.addStealEffect(param1,_loc3_.costVariance);
               }
            }
         }
      }
      
      private function addStealEffect(param1:Build, param2:uint) : void
      {
         SimBaseVisual.addFlaEffect((param2 == PCost.CRYSTAL ? "cry" : "oil") + "Drop2",param1);
      }
      
      private function applySteal(param1:uint, param2:uint) : void
      {
         var _loc3_:BattleProxy = Facade.battleMediator.bp;
         if(param1 == PCost.CRYSTAL)
         {
            if(param2 > _loc3_.crystal)
            {
               if(_loc3_.crystal > 0)
               {
                  ErrorLogic.sendLog("steal","crystal",param2 + "/" + _loc3_.crystal);
                  _loc3_.crystal = 0;
               }
            }
            else
            {
               _loc3_.crystal -= param2;
            }
            _loc3_.stealCrystal += param2;
         }
         else if(param1 == PCost.OIL)
         {
            if(param2 > _loc3_.oil)
            {
               if(_loc3_.oil > 0)
               {
                  ErrorLogic.sendLog("steal","oil",param2 + "/" + _loc3_.oil);
                  _loc3_.oil = 0;
               }
            }
            else
            {
               _loc3_.oil -= param2;
            }
            _loc3_.stealOil += param2;
         }
         if(this.isPlayAndSync)
         {
            Facade.battleMediator.syncResourcePanel(param1);
         }
      }
      
      override public function activateSpell(param1:PShopSpell, param2:Point, param3:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:PEffect = null;
         var _loc6_:Point = null;
         var _loc7_:AnimClip = null;
         _loc4_ = 0;
         _loc5_ = param1.ssp_effect;
         switch(_loc5_.variance)
         {
            case PEffect.CURE:
            case PEffect.WORKER:
               _loc4_ = (_loc5_.value as PCure).cure_duration * (_loc5_.value as PCure).cure_count;
               break;
            case PEffect.CALL:
               _loc4_ = (_loc5_.value as PCall).call_duration;
               break;
            case PEffect.LOW_DAMAGE:
               _loc4_ = (_loc5_.value as PLowDamage).low_damage_duration;
               break;
            case PEffect.MULTIFIREBALL:
               _loc4_ = (_loc5_.value as PMultifireball).mf_period * (_loc5_.value as PMultifireball).mf_count;
               break;
            case PEffect.RAGE:
               _loc4_ = (_loc5_.value as PRage).rage_duration;
         }
         param3 += param1.ssp_attack_time + _loc4_ - this.curTime;
         if(param3 <= 0)
         {
            return;
         }
         _loc6_ = new Point();
         Isometric.posToScreen(param2.x,param2.y,_loc6_);
         _loc4_ = param3 / 1000;
         switch(_loc5_.variance)
         {
            case PEffect.FIREBALL:
               new FireSpell(_loc6_);
               break;
            case PEffect.CURE:
               new RAASpell("sp_cure",_loc6_,_loc4_,(_loc5_.value as PCure).cure_radius,16777215);
               break;
            case PEffect.CALL:
               new CallSpell(_loc6_,_loc4_);
               break;
            case PEffect.WORKER:
               new Worker().assignJob(new WorkerCureJob(param2,(_loc5_.value as PCure).cure_radius,_loc4_));
               break;
            case PEffect.SHOCK:
               addEffect("sp_shock","start",_loc6_.x,_loc6_.y);
               break;
            case PEffect.LOW_DAMAGE:
               new RAASpell("sp_stone_skin",_loc6_,_loc4_);
               break;
            case PEffect.MULTIFIREBALL:
               new AcidSpell(param1.ssp_kind,_loc6_,_loc4_,(_loc5_.value as PMultifireball).mf_radius);
               break;
            case PEffect.FOG:
               new RAASpell("sp_fog",_loc6_,_loc4_);
               break;
            case PEffect.RAGE:
               _loc7_ = new RAASpell("sp_rage",_loc6_,_loc4_,(_loc5_.value as PRage).rage_radius,0,true);
               _loc7_.scaleX = (_loc5_.value as PRage).rage_radius / 1.4;
               _loc7_.scaleY = (_loc5_.value as PRage).rage_radius / 1.25;
         }
      }
   }
}

