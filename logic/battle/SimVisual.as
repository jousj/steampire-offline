package logic.battle
{
   import engine.Isometric;
   import engine.Position;
   import engine.data.LinkedList;
   import engine.data.MapCell;
   import engine.display.AnimClip;
   import engine.display.Animation;
   import engine.display.EffectClip;
   import engine.signal.Tween;
   import engine.units.*;
   import flash.display.BlendMode;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.battle.drop.DropPanel;
   import game.board.DamageProgressBar;
   import logic.UnitFactory;
   import logic.sim.SimBoardObj;
   import logic.sim.SimCannonT;
   import logic.sim.SimData;
   import logic.sim.SimGroup;
   import logic.sim.SimUnitT;
   import model.UserProxy;
   import model.ui.VOBattleItem;
   import model.vo.ChannelControl;
   import proto.model.PBtype;
   import proto.model.PCost;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import utils.CommonUtils;
   
   public class SimVisual extends SimBaseVisual
   {
      
      public var isBoss:Boolean;
      
      public var heroRaid:Boolean;
      
      public var useDefenderMarker:Boolean;
      
      public var isDamageVisible:Boolean;
      
      public var usePower:Boolean;
      
      public var damageCount:int;
      
      public var jglory:int;
      
      public var rar_dragon:int;
      
      public var onyx:int;
      
      private const damageBarList:Vector.<DamageProgressBar>;
      
      private const rocketPoint:Point;
      
      private const trackCountHash:Object;
      
      private const trackGroupHash:Object;
      
      private const ATTACK:uint = 1;
      
      private const MOVE:uint = 2;
      
      private const singleAudioList:Vector.<String>;
      
      private const cloneAudioHash:Object;
      
      private const walkAudioHash:Object;
      
      private var trackWalkCountHash:Object;
      
      private var trackWalkHash:Object;
      
      public function SimVisual(param1:Array)
      {
         var _loc2_:VOBattleItem = null;
         this.damageBarList = new Vector.<DamageProgressBar>();
         this.rocketPoint = new Point();
         this.trackCountHash = {};
         this.trackGroupHash = {};
         this.singleAudioList = new <String>["un_healer","un_tank","un_swarm"];
         this.cloneAudioHash = {
            "un_golem":"un_troll",
            "un_warrior_elite":"un_warrior",
            "un_warrior_mithril":"un_warrior",
            "un_sniper_elite":"un_sniper",
            "un_sniper_mithril":"un_sniper",
            "un_copter":"un_sniper",
            "un_motocycle_elite":"un_motocycle",
            "un_motocycle_mithril":"un_motocycle",
            "un_troll_elite":"un_troll",
            "un_troll_mithril":"un_troll",
            "un_swarm_elite":"un_swarm",
            "un_swarm_mithril":"un_swarm",
            "un_zombie":"un_warrior"
         };
         this.walkAudioHash = {
            "un_sniper":"un_warrior",
            "un_sniper_elite":"un_warrior",
            "un_sniper_mithril":"un_warrior",
            "un_dwarf":"un_warrior",
            "un_golem":"un_golem",
            "un_disinfector":"un_fairy"
         };
         this.trackWalkCountHash = {};
         this.trackWalkHash = {};
         super([]);
         isPlayAndSync = true;
         for each(_loc2_ in param1)
         {
            if(_loc2_.shop)
            {
               this.trackCountHash[_loc2_.shop.su_kind] = 0;
               this.trackWalkCountHash[_loc2_.shop.su_kind] = 0;
            }
         }
      }
      
      public static function createCannonRocket(param1:Cannon, param2:Number, param3:Soldier, param4:Point) : void
      {
         var _loc5_:uint = param1.env.rocketMode;
         var _loc6_:Rocket = Rocket.create(param1.kind,_loc5_);
         if(param3)
         {
            _loc6_.target = param3;
            _loc6_.targetIconFactor = param3.shop.su_is_air ? 0.8 : 0.4;
            param4.x = param3.display.x;
            param4.y = param3.display.y + param3.iconY * _loc6_.targetIconFactor;
         }
         param1.calcBarrelPoint();
         if((_loc5_ & Rocket.TRACK) != 0 && Facade.isNormalQuality)
         {
            _loc6_.assignArea(Facade.board.tilePanel,param4.x,param4.y,param1.shop.sc_aoe_radius);
         }
         if((_loc5_ & Rocket.MASK) != 0)
         {
            _loc6_.radiant(param1.display.x + param1.barrelPoint.x,param1.display.y + param1.barrelPoint.y,param4.x,param4.y,param2);
         }
         else
         {
            _loc6_.flight(param1.display.x + param1.barrelPoint.x,param1.display.y + param1.barrelPoint.y,param4.x,param4.y,param2,param1.shop.sc_is_porabols ? (param1.shop.sc_kind == "cn_mortar" ? 0.8 : 0.125) : 0);
         }
      }
      
      override public function activateUnit(param1:SimUnitT, param2:SimGroup = null, param3:int = 0) : void
      {
         var _loc5_:String = null;
         var _loc4_:Soldier = getSoldier(param1.id) || UnitFactory.createSoldier(param1.shop,param1.id);
         if(!_loc4_.audioKind)
         {
            _loc4_.is_attacker = param1.is_attacker;
            _loc4_.stamina = param1.max_stamina - param1.armor;
            _loc4_.armor = param1.armor;
            if(!param1.is_attacker)
            {
               _loc4_.isIgnoreFence = true;
            }
            _loc4_.user_num = param1.user_num;
            _loc5_ = _loc4_.shop.su_kind;
            _loc4_.audioKind = _loc5_;
            if(this.cloneAudioHash.hasOwnProperty(_loc5_))
            {
               _loc4_.audioKind = this.cloneAudioHash[_loc5_];
            }
            _loc4_.walkAudioKind = this.walkAudioHash.hasOwnProperty(_loc5_) ? this.walkAudioHash[_loc5_] : _loc4_.audioKind;
            _loc4_.isSingleAudio = this.singleAudioList.indexOf(_loc4_.audioKind) >= 0;
         }
         else
         {
            _loc4_.display.pauseAll(false);
         }
         if(_loc4_.user_num > 0 || !_loc4_.is_attacker && this.useDefenderMarker && !this.isBoss || _loc4_.is_attacker && this.isBoss)
         {
            _loc4_.changeMarkerClip(true);
         }
         if(!_loc4_.display.parent)
         {
            _loc4_.setGeometry(param1.pos.x,param1.pos.y,false);
            _loc4_.updateZSize();
            if(param2)
            {
               _loc4_.calcDirection(ZObject.POS_WORLD_SIZE * param2.goal_pos.x,ZObject.POS_WORLD_SIZE * param2.goal_pos.y);
            }
            else
            {
               _loc4_.direction = AnimObject.LEFT_DOWN;
            }
            Facade.boardMediator.addObject(_loc4_,_loc4_.shop.su_is_air);
            if(Boolean(param1.is_attacker && param2) && Boolean(Facade.isNormalQuality) && curTime <= param3 + 300)
            {
               addEffect("effects","un_create",_loc4_.display.x,_loc4_.display.y);
               Tween.createRef(_loc4_.display,null,true).play(["alpha",0,1],0.3);
            }
         }
      }
      
      override public function deactivateUnit(param1:int) : void
      {
         var _loc2_:Soldier = getSoldier(param1);
         _loc2_.stopWalk();
         _loc2_.changeMarkerClip(false);
         _loc2_.display.pauseAll(true);
         Facade.boardMediator.removeObject(_loc2_);
      }
      
      override public function unitPrepareMove(param1:int, param2:Point, param3:int, param4:Boolean) : void
      {
         var _loc6_:MapCell = null;
         var _loc5_:Soldier = getSoldier(param1);
         if(param3 > curTime)
         {
            _loc6_ = Facade.map.getMapCell(param2.x,param2.y);
            if(!param4)
            {
               if(_loc5_.isAllowPhantom)
               {
                  if(!_loc5_.isPhantom && _loc6_.unit is Fence)
                  {
                     _loc5_.isPhantom = true;
                  }
               }
            }
            _loc5_.startWalk((param3 - curTime) / 1000,_loc6_,param4);
         }
         this.changeTrackCount(_loc5_,this.MOVE);
      }
      
      override public function unitMove(param1:int, param2:Point) : void
      {
         var _loc4_:MapCell = null;
         var _loc3_:Soldier = getSoldier(param1);
         if(_loc3_.isPhantom)
         {
            _loc4_ = Facade.map.getMapCell(param2.x,param2.y);
            if(!(_loc4_.unit is Fence))
            {
               _loc3_.isPhantom = false;
            }
         }
         _loc3_.setGeometry(param2.x,param2.y,true);
      }
      
      override public function unitPrepareAttack(param1:int, param2:SimBoardObj, param3:int) : void
      {
         var _loc4_:Soldier = getSoldier(param1);
         var _loc5_:Unit = getUnit(param2);
         _loc4_.calcDirection(_loc5_.z_x,_loc5_.z_y);
         _loc4_.playAttack();
         if(_loc4_.shop.su_kind == "un_boss_healer" || _loc4_.shop.su_kind == "un_raid_healer")
         {
            activateSpell(Facade.manualProxy.getSpellShop("sp_fireball",1),new Point(_loc5_.b_x,_loc5_.b_y),param3);
         }
         this.changeTrackCount(_loc4_,this.ATTACK);
      }
      
      private function changeTrackCount(param1:Soldier, param2:uint = 0) : void
      {
         if(param2 == this.MOVE != param1.isWalk)
         {
            param1.isWalk = param2 == this.MOVE;
            this.syncWalkTrack(param1.walkAudioKind,param1.isWalk);
         }
         if(param1.isSingleAudio)
         {
            if(param2 == this.ATTACK)
            {
               Facade.audioProxy.playNum(param1.audioKind,5,3);
               return;
            }
         }
         if(param2 == this.ATTACK)
         {
            if(!param1.isAudio)
            {
               param1.isAudio = true;
               ++this.trackCountHash[param1.audioKind];
            }
         }
         else
         {
            if(!param1.isAudio)
            {
               return;
            }
            param1.isAudio = false;
            --this.trackCountHash[param1.audioKind];
         }
         this.syncSoldierTrack(param1.audioKind,param2 == this.ATTACK);
      }
      
      private function syncSoldierTrack(param1:String, param2:Boolean) : void
      {
         var _loc3_:uint = uint(this.trackCountHash[param1]);
         if(_loc3_ == 3 && !param2)
         {
            this.stopGroupTrack(param1);
         }
         if(param2)
         {
            if(_loc3_ >= 4)
            {
               if(!this.trackGroupHash[param1])
               {
                  this.trackGroupHash[param1] = Facade.audioProxy.playNum("group_" + param1,2,0,true);
               }
            }
            else if(!this.trackGroupHash[param1])
            {
               Facade.audioProxy.playNum(param1,5,3);
            }
         }
      }
      
      private function stopGroupTrack(param1:String) : void
      {
         var _loc2_:* = this.trackGroupHash[param1];
         if(_loc2_)
         {
            this.trackGroupHash[param1] = null;
            if(_loc2_ is ChannelControl)
            {
               (_loc2_ as ChannelControl).stop();
            }
         }
      }
      
      private function syncWalkTrack(param1:String, param2:Boolean) : void
      {
         var _loc4_:ChannelControl = null;
         var _loc3_:uint = uint(this.trackWalkCountHash[param1]);
         _loc3_ += param2 ? 1 : -1;
         this.trackWalkCountHash[param1] = _loc3_;
         if(param2)
         {
            if(_loc3_ == 5)
            {
               this.trackWalkHash[param1] = Facade.audioProxy.playTrack(param1 + "_run",true);
            }
         }
         else if(_loc3_ == 4)
         {
            _loc4_ = this.trackWalkHash[param1] as ChannelControl;
            if(_loc4_)
            {
               _loc4_.stop();
               this.trackWalkHash[param1] = null;
            }
         }
      }
      
      override public function unitFireAttack(param1:SimUnitT, param2:Point, param3:int, param4:SimBoardObj) : void
      {
         if(param1.bullet_speed > 0 && param1.is_air)
         {
            this.createSoldierRocket(param1,param2,param3,param4);
         }
      }
      
      private function createSoldierRocket(param1:SimUnitT, param2:Point, param3:int, param4:SimBoardObj) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:Unit = null;
         if(param3 > curTime)
         {
            _loc5_ = 0;
            if(param1.kind == "un_fairy" || param1.kind == "un_copter")
            {
               _loc5_ = 1;
            }
            else if(param1.kind == "un_disinfector")
            {
               _loc5_ = 2;
            }
            else if(param1.kind == "un_dragon")
            {
               _loc5_ = 3;
            }
            if(_loc5_ > 0)
            {
               param3 -= curTime;
               _loc6_ = getUnit(param4);
               if(_loc6_)
               {
                  this.calcSoldierRocketPoint(_loc6_,_loc5_ != 3);
               }
               else
               {
                  Isometric.posToScreen(param2.x,param2.y,this.rocketPoint);
               }
               if(_loc5_ == 1)
               {
                  this.createFairyRocket(getSoldier(param1.id),param3 / 1000);
               }
               else if(_loc5_ == 2)
               {
                  this.createDisinfectorRocket(getSoldier(param1.id),param3 / 1000);
               }
               else if(_loc5_ == 3)
               {
                  this.createDragonRocket(getSoldier(param1.id),param3 / 1000);
               }
            }
         }
      }
      
      private function createFairyRocket(param1:Soldier, param2:Number) : void
      {
         Rocket.create(param1.kind,Rocket.BOOM).flight(param1.display.x,param1.display.y + (param1.display.viewRect ? param1.display.viewRect.y : 0),this.rocketPoint.x,this.rocketPoint.y,param2,0.125);
      }
      
      private function createDisinfectorRocket(param1:Soldier, param2:Number) : void
      {
         var _loc3_:Vector.<int> = Unit.boomHash[param1.kind + "attack1" + param1.getAnimSufix()] as Vector.<int>;
         if(!_loc3_)
         {
            return;
         }
         Rocket.create(param1.kind,Rocket.BOOM | Rocket.PRE_ROTATE).flight(param1.display.x + (param1.animClip.isFlip ? -_loc3_[0] : _loc3_[0]),param1.display.y + _loc3_[1],this.rocketPoint.x,this.rocketPoint.y,param2,0.125);
      }
      
      private function createDragonRocket(param1:Soldier, param2:Number) : void
      {
         var _loc3_:Vector.<int> = Unit.boomHash[param1.kind + "attack1" + param1.getAnimSufix()] as Vector.<int>;
         if(!_loc3_)
         {
            return;
         }
         Rocket.create(param1.kind,Rocket.BOOM | Rocket.PRE_ROTATE | Rocket.MASK).radiant(param1.display.x + (param1.animClip.isFlip ? -_loc3_[0] : _loc3_[0]),param1.display.y + _loc3_[1],this.rocketPoint.x,this.rocketPoint.y,param2);
      }
      
      private function showDamage(param1:Unit, param2:int, param3:DamageProgressBar, param4:Boolean) : void
      {
         if(!param3)
         {
            if(this.damageBarList.length > 0)
            {
               param3 = this.damageBarList.pop();
            }
            else
            {
               param3 = new DamageProgressBar();
            }
            param3.assign(param1,param4 && (param1 as Soldier).is_attacker);
            param3.poolList = !this.isDamageVisible || param4 || param2 == param3.max_stamina ? this.damageBarList : null;
         }
         else if(this.isDamageVisible && param2 == param3.max_stamina)
         {
            param3.poolList = this.damageBarList;
         }
         param3.sync(param2);
      }
      
      override public function applyDamage(param1:SimBoardObj, param2:int, param3:int, param4:SimUnitT = null) : void
      {
         var _loc5_:Unit = getUnit(param1);
         var _loc6_:Boolean = param1.kind == SimBoardObj.CANNON || param1.kind == SimBoardObj.BUILDING;
         if(param1.kind != SimBoardObj.UNIT)
         {
            if(param2 <= 0 && _loc6_)
            {
               if(this.jglory > 0)
               {
                  this.useRewardEffect(param1.id,this.jglory,PCost.J_GLORY);
               }
               if(this.rar_dragon > 0)
               {
                  this.useRewardEffect(param1.id,this.rar_dragon,PCost.RAR_DRAGON);
               }
               if(this.onyx > 0)
               {
                  this.useRewardEffect(param1.id,this.onyx,PCost.MITHRIL);
               }
            }
            applyConstructionDamage(_loc5_,param2);
         }
         if(param2 > 0)
         {
            this.showDamage(_loc5_,param2,_loc5_.getProgress() as DamageProgressBar,param1.kind == SimBoardObj.UNIT);
            if(this.heroRaid)
            {
               Facade.battleMediator.changeHeroHp(_loc5_ as Soldier,param2);
            }
            if(Boolean(param4) && !param4.is_air)
            {
               if(Facade.isNormalQuality || param4.is_healer)
               {
                  if(_loc5_.display.visible && curTime - param3 <= 150)
                  {
                     this.unitRocketBoom(_loc5_,param4);
                  }
               }
            }
            if(_loc6_)
            {
               ++this.damageCount;
            }
         }
         else if(_loc6_)
         {
            Facade.battleMediator.changeDamage(_loc5_.kind,_loc5_.id);
         }
      }
      
      override public function unitDeath(param1:SimUnitT) : void
      {
         var _loc2_:Soldier = getSoldier(param1.id);
         if(_loc2_)
         {
            this.changeTrackCount(_loc2_);
         }
         super.unitDeath(param1);
      }
      
      private function calcSoldierRocketPoint(param1:Unit, param2:Boolean) : void
      {
         var _loc3_:uint = 0;
         this.rocketPoint.x = param1.display.x;
         this.rocketPoint.y = param1.display.y;
         if(Boolean(param1.boomList) && param2)
         {
            _loc3_ = param1.boomList.length > 2 ? uint(CommonUtils.getRangeRandom(1,param1.boomList.length >> 1) - 1 << 1) : 0;
            this.rocketPoint.x += param1.boomList[_loc3_];
            this.rocketPoint.y += param1.boomList[_loc3_ + 1];
         }
         else if(param1 is Soldier && (param1 as Soldier).shop.su_is_air)
         {
            this.rocketPoint.y += param1.iconY * 0.7;
         }
         else
         {
            this.rocketPoint.y -= (param1.size - 1) * Isometric.POS_HALF_HEIGHT;
         }
      }
      
      private function unitRocketBoom(param1:Unit, param2:SimUnitT) : void
      {
         var _loc3_:Soldier = getSoldier(param2.id);
         if(_loc3_)
         {
            this.calcSoldierRocketPoint(param1,true);
            if(param2.is_healer)
            {
               addEffect(_loc3_.kind,"boom_tile",this.rocketPoint.x,this.rocketPoint.y,true);
               addEffect(_loc3_.kind,"boom_light",this.rocketPoint.x,this.rocketPoint.y);
            }
            else
            {
               addEffect(_loc3_.kind,"boom",this.rocketPoint.x,this.rocketPoint.y);
            }
         }
      }
      
      override public function stand(param1:int) : void
      {
         var _loc2_:Soldier = getSoldier(param1);
         if(_loc2_)
         {
            if(!_loc2_.isStand)
            {
               _loc2_.stand();
            }
            this.changeTrackCount(_loc2_);
         }
      }
      
      override public function cannonPrepareAttack(param1:int, param2:Point, param3:int, param4:int) : void
      {
         var _loc6_:Soldier = null;
         var _loc5_:Cannon = getCannon(param1);
         if(_loc5_.env.isRotate)
         {
            if(_loc5_.shop.sc_aoe_radius == 0)
            {
               _loc6_ = getSoldier(param4);
               if(_loc6_)
               {
                  _loc5_.rotate(CommonUtils.calcAngle(_loc5_.z_x,_loc5_.z_y,_loc6_.z_x,_loc6_.z_y));
                  return;
               }
            }
            _loc5_.rotate(CommonUtils.calcAngle(_loc5_.c_x,_loc5_.c_y,param2.x,param2.y));
         }
      }
      
      override public function cannonFireAttack(param1:int, param2:Point, param3:int, param4:int) : void
      {
         var _loc5_:Cannon = null;
         var _loc6_:Soldier = null;
         param3 -= curTime;
         if(param3 > -150)
         {
            _loc5_ = getCannon(param1);
            if(param3 > 0 && (_loc5_.env.rocketMode & Rocket.SKIP) == 0)
            {
               if(_loc5_.shop.sc_aoe_radius == 0)
               {
                  _loc6_ = getSoldier(param4);
               }
               if(_loc6_)
               {
                  if(_loc5_.env.isRotate)
                  {
                     _loc5_.rotate(CommonUtils.calcAngle(_loc5_.z_x,_loc5_.z_y,_loc6_.z_x,_loc6_.z_y),false,true);
                  }
                  createCannonRocket(_loc5_,param3 / 1000,_loc6_,this.rocketPoint);
               }
               else
               {
                  Isometric.posToScreen(param2.x,param2.y,this.rocketPoint);
                  createCannonRocket(_loc5_,param3 / 1000,null,this.rocketPoint);
               }
            }
            else if((_loc5_.env.rocketMode & Rocket.BOOM) != 0)
            {
               this.createCannonBoom(_loc5_,param2,getSoldier(param4),param3 / 1000);
            }
            if(_loc5_.display.visible)
            {
               _loc5_.playAttack();
               Facade.audioProxy.play(_loc5_.kind);
            }
         }
      }
      
      private function createCannonBoom(param1:Cannon, param2:Point, param3:Soldier, param4:Number) : void
      {
         var _loc5_:Animation = param1.getAnimation("boom",false);
         if(!_loc5_)
         {
            return;
         }
         var _loc6_:EffectClip = EffectClip.create();
         Facade.board.effectPanel.addChild(_loc6_);
         if(param3)
         {
            _loc6_.x = param3.display.x;
            _loc6_.y = param3.display.y + param3.iconY * (param3.shop.su_is_air ? 0.8 : 0.4);
         }
         else
         {
            Isometric.posToScreen(param2.x,param2.y,this.rocketPoint);
            _loc6_.x = this.rocketPoint.x;
            _loc6_.y = this.rocketPoint.y;
         }
         if(param4 > 0)
         {
            AnimClip.resourceProxy.clearFrame(_loc6_);
            _loc6_.playDelay(_loc5_,param4);
         }
         else
         {
            _loc6_.play(_loc5_);
         }
      }
      
      override public function attention(param1:int) : void
      {
         var _loc2_:Unit = getConstruction(param1);
         if(Boolean(_loc2_) && !_loc2_.isStatus)
         {
            UnitFactory.attentionStatus(_loc2_);
         }
      }
      
      override public function changePower(param1:int, param2:int, param3:int = 0, param4:Boolean = false) : void
      {
         if(!this.usePower)
         {
            return;
         }
         param4 = true;
         var _loc5_:DropPanel = Facade.battleMediator.dropPanel;
         _loc5_.powerPanel.setData(param1);
         if(param3 > 0 && param2 != 0)
         {
            this.usePowerEffect(param3,param2,param4);
         }
      }
      
      private function usePowerEffect(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc5_:VComponent = null;
         var _loc6_:Point = null;
         var _loc7_:Tween = null;
         var _loc4_:Unit = param3 ? getSoldier(param1) : getConstruction(param1);
         if((Boolean(_loc4_)) && _loc4_.display.visible)
         {
            if(!param3)
            {
               SimBaseVisual.addFlaEffect("powerDrop",_loc4_);
               this.flightPowerMessage(param2,_loc4_);
            }
            _loc5_ = new VComponent();
            _loc5_.add(SkinManager.getEmbed("Power"),{
               "w":23,
               "h":23,
               "vCenter":0,
               "hCenter":0
            });
            _loc5_.layoutH = _loc5_.layoutW = _loc5_.w = _loc5_.h = _loc5_.width = _loc5_.height = 1;
            _loc5_.updatePhase(true);
            _loc5_.geometryPhase();
            _loc6_ = _loc4_.display.localToGlobal(new Point(0,_loc4_.iconY + 40));
            _loc5_.x = _loc6_.x;
            _loc5_.y = _loc6_.y;
            Facade.mainPanel.infoPanel.addChild(_loc5_);
            _loc7_ = new Tween(_loc5_,this.onTweenPower1);
            _loc7_.play(["scaleX",0,1,"scaleY",0,1],0.55,Tween.backOut,0.02);
         }
      }
      
      private function onTweenPower1(param1:Tween) : void
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc2_:VComponent = param1.target as VComponent;
         if(Boolean(Facade.battleMediator.dropPanel.parent) && Boolean(Facade.battleMediator.dropPanel.powerPanel.parent))
         {
            _loc3_ = Facade.battleMediator.dropPanel.powerPanel.getRect(_loc2_.parent);
            _loc4_ = _loc3_.x + 21;
            _loc5_ = _loc3_.y + 20;
            _loc6_ = ["x",_loc4_,"y",_loc5_];
            _loc4_ -= _loc2_.x;
            _loc5_ -= _loc2_.y;
            param1.completeFunc = this.onTweenPower2;
            param1.play(_loc6_,0.2 * (Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_) / 200),null,0.02);
         }
         else
         {
            param1.completeFunc = this.onTweenPower2;
            param1.play(["scaleX",0,0,"scaleY",0,0],0.55,Tween.backOut,0.02);
         }
      }
      
      private function onTweenPower2(param1:Tween) : void
      {
         if(param1.step == 2)
         {
            param1.play(["scaleX",2,0,"scaleY",2,0],0.35,Tween.backIn,0.02);
         }
         else
         {
            (param1.target as VComponent).removeFromParent();
         }
      }
      
      public function flightPowerMessage(param1:int, param2:Unit) : void
      {
         Facade.mainMediator.flightUnitMessage((param1 > 0 ? "+" + param1 : param1) + " " + Lang.getString("power"),16742520,7995392,param2);
      }
      
      private function useRewardEffect(param1:int, param2:int, param3:uint) : void
      {
         var _loc5_:VSkin = null;
         var _loc6_:Point = null;
         var _loc7_:Tween = null;
         var _loc4_:Unit = getConstruction(param1);
         if((Boolean(_loc4_)) && _loc4_.display.visible)
         {
            if(param3 == PCost.RAR_DRAGON)
            {
               Facade.mainMediator.flightUnitMessage("+" + param2 + " " + Lang.getString("rar_dragon"),16764226,9581056,_loc4_);
               _loc5_ = SkinManager.getEmbed("rar_dragonLoot");
            }
            else if(param3 == PCost.J_GLORY)
            {
               Facade.mainMediator.flightUnitMessage("+" + param2 + " " + Lang.getString("JGlory"),8820000,30278,_loc4_);
               _loc5_ = SkinManager.getEmbed("JGloryLoot");
            }
            else
            {
               Facade.mainMediator.flightUnitMessage("+" + param2 + " " + Lang.getString("Mithril"),16759353,9769984,_loc4_);
               _loc5_ = SkinManager.getEmbed("OnyxLoot");
            }
            _loc5_.geometryPhase();
            _loc6_ = _loc4_.display.localToGlobal(new Point(0,_loc4_.iconY + 10));
            _loc5_.x = _loc6_.x;
            _loc5_.y = _loc6_.y;
            Facade.mainPanel.infoPanel.addChild(_loc5_);
            _loc7_ = new Tween(_loc5_,this.onTweenReward1);
            _loc7_.play(["scaleX",0,1,"scaleY",0,1],0.5,Tween.backOut);
         }
      }
      
      private function onTweenReward1(param1:Tween) : void
      {
         param1.completeFunc = this.onTweenReward2;
         (param1.target as VSkin).blendMode = BlendMode.LAYER;
         param1.play(["alpha",1,0],0.3);
      }
      
      private function onTweenReward2(param1:Tween) : void
      {
         (param1.target as VSkin).removeFromParent();
      }
      
      override public function drawVector(param1:Position, param2:Position, param3:Boolean, param4:uint) : void
      {
         var _loc5_:Point = new Point();
         var _loc6_:Point = new Point();
         Isometric.posToScreen(param1.x,param1.y,_loc5_);
         Isometric.posToScreen(param2.x,param2.y,_loc6_);
         Facade.boardMediator.battleDrop.tweenVector(_loc5_,_loc6_,param3,param4);
      }
      
      public function clear() : void
      {
         var _loc1_:DamageProgressBar = null;
         for each(_loc1_ in this.damageBarList)
         {
            _loc1_.dispose();
         }
         this.damageBarList.length = 0;
      }
      
      private function changeDamageVisible(param1:Unit, param2:Boolean, param3:int) : void
      {
         if(param2 && param3 == param1.stamina + param1.armor)
         {
            return;
         }
         var _loc4_:DamageProgressBar = param1.getProgress() as DamageProgressBar;
         if(param2)
         {
            if(!_loc4_)
            {
               this.showDamage(param1,param3,null,false);
            }
            else
            {
               _loc4_.poolList = null;
            }
         }
         else if(_loc4_)
         {
            param1.clearProgress(false);
            _loc4_.clear();
            this.damageBarList.push(_loc4_);
         }
      }
      
      public function revertDamageVisible(param1:SimData) : void
      {
         var _loc2_:int = 0;
         var _loc6_:Unit = null;
         var _loc7_:Object = null;
         this.isDamageVisible = !this.isDamageVisible;
         var _loc3_:UserProxy = Facade.userProxy;
         var _loc4_:Array = [_loc3_.cannonList,param1.cannons,_loc3_.buildList,param1.buildings,_loc3_.fenceList,param1.fences];
         var _loc5_:int = _loc4_.length - 2;
         while(_loc5_ >= 0)
         {
            _loc6_ = (_loc4_[_loc5_] as LinkedList).head as Unit;
            _loc7_ = _loc4_[_loc5_ + 1];
            while(_loc6_)
            {
               if(this.isDamageVisible)
               {
                  _loc2_ = int(_loc7_[_loc6_.id].stamina);
               }
               this.changeDamageVisible(_loc6_,this.isDamageVisible,_loc2_);
               _loc6_ = _loc6_.link_next as Unit;
            }
            _loc5_ -= 2;
         }
         Facade.myMediator.prefPanel.setDamageMode(this.isDamageVisible);
      }
      
      override public function cannonDisable(param1:int, param2:Boolean) : void
      {
         var _loc3_:Cannon = getConstruction(param1) as Cannon;
         if(Boolean(_loc3_) && _loc3_.isPylon)
         {
            _loc3_.setStatus(param2 ? SkinManager.getEmbed("NoPylonStatus",VSkin.CACHE_AS_BITMAP) : null);
         }
      }
      
      public function applyResume(param1:Build, param2:SimData) : void
      {
         var _loc3_:SimUnitT = null;
         var _loc4_:SimCannonT = null;
         while(param1)
         {
            if(param1.type == PBtype.RESOURCE || param1.type == PBtype.STORAGE)
            {
               param1.syncResAnim();
            }
            param1 = param1.link_next as Build;
         }
         for each(_loc3_ in param2.units)
         {
            if(_loc3_.is_active)
            {
               this.activateUnit(_loc3_);
            }
         }
         for each(_loc4_ in param2.cannons)
         {
            if(_loc4_.disabled_time != 0)
            {
               this.cannonDisable(_loc4_.id,true);
            }
         }
      }
   }
}

