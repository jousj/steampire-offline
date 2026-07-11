package logic.training.firstsession
{
   import engine.Position;
   import engine.units.Build;
   import engine.units.Cannon;
   import flash.filters.GlowFilter;
   import game.battle.BattleMediator;
   import logic.BoardLogic;
   import logic.CoreLogic;
   import logic.MainLogic;
   import logic.UnitFactory;
   import logic.training.*;
   import model.ui.VOBattleItem;
   import proto.model.PBtype;
   import proto.model.PBuildState;
   import proto.model.PBuilding;
   import proto.model.PBuildingSpec;
   import proto.model.PCannon;
   import proto.model.PFence;
   import proto.model.PGuard;
   import proto.model.PKindCount;
   import proto.model.PShopCannon;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   
   public class Mission1NewTrain extends AbstractTrain
   {
      
      private const bm:BattleMediator = Facade.battleMediator;
      
      public function Mission1NewTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc8_:Cannon = null;
         var _loc9_:VOBattleItem = null;
         var _loc1_:PBuildState = PBuildState.create(PBuildState.FINISHED,null);
         var _loc2_:PBuilding = PBuilding.create(20001,"bl_guard_tower",1,new Position(31,21),_loc1_,PBuildingSpec.create(PBuildingSpec.GUARD,PGuard.create([PKindCount.create("un_warrior_mithril",3)],1)));
         this.bm.targetInfo.ti_um.buildings.push(_loc2_);
         UnitFactory.createConstruction(Facade.manualProxy.getBuildShop(_loc2_.building_kind,_loc2_.building_level),_loc2_.building_id,_loc2_.building_pos);
         var _loc3_:PFence = PFence.create(20002,"fn_wall",1,new Position(28,22));
         UnitFactory.createConstruction(Facade.manualProxy.getFenceShop(_loc3_.fence_kind,_loc3_.fence_level),_loc3_.fence_id,_loc3_.fence_pos);
         this.bm.targetInfo.ti_um.fences.push(_loc3_);
         _loc3_ = PFence.create(20003,"fn_wall",1,new Position(29,22));
         UnitFactory.createConstruction(Facade.manualProxy.getFenceShop(_loc3_.fence_kind,_loc3_.fence_level),_loc3_.fence_id,_loc3_.fence_pos);
         this.bm.targetInfo.ti_um.fences.push(_loc3_);
         _loc3_ = PFence.create(20004,"fn_wall",1,new Position(30,22));
         UnitFactory.createConstruction(Facade.manualProxy.getFenceShop(_loc3_.fence_kind,_loc3_.fence_level),_loc3_.fence_id,_loc3_.fence_pos);
         this.bm.targetInfo.ti_um.fences.push(_loc3_);
         _loc3_ = PFence.create(20005,"fn_wall",1,new Position(31,22));
         UnitFactory.createConstruction(Facade.manualProxy.getFenceShop(_loc3_.fence_kind,_loc3_.fence_level),_loc3_.fence_id,_loc3_.fence_pos);
         this.bm.targetInfo.ti_um.fences.push(_loc3_);
         _loc3_ = PFence.create(20006,"fn_wall",1,new Position(32,20));
         UnitFactory.createConstruction(Facade.manualProxy.getFenceShop(_loc3_.fence_kind,_loc3_.fence_level),_loc3_.fence_id,_loc3_.fence_pos);
         this.bm.targetInfo.ti_um.fences.push(_loc3_);
         _loc3_ = PFence.create(20007,"fn_wall",1,new Position(32,19));
         UnitFactory.createConstruction(Facade.manualProxy.getFenceShop(_loc3_.fence_kind,_loc3_.fence_level),_loc3_.fence_id,_loc3_.fence_pos);
         this.bm.targetInfo.ti_um.fences.push(_loc3_);
         var _loc4_:PShopCannon = Facade.manualProxy.getCannonShop("cn_ballista",5);
         var _loc5_:PCannon = PCannon.create(20008,_loc4_.sc_kind,_loc4_.sc_level,new Position(28,21),_loc1_);
         UnitFactory.createConstruction(_loc4_,_loc5_.cannon_id,_loc5_.cannon_pos);
         this.bm.targetInfo.ti_um.cannons.push(_loc5_);
         BoardLogic.updateLanding();
         var _loc6_:Build = Facade.userProxy.getBuild(PBtype.GUARD,true);
         _loc6_.setStatus(SkinManager.getEmbed("TargetStatus",VSkin.CACHE_AS_BITMAP));
         _loc6_.display.addFilter(new GlowFilter(16711680,1,6,6));
         var _loc7_:Vector.<Cannon> = new Vector.<Cannon>();
         Facade.userProxy.getCannon("cn_ballista",true,0,_loc7_);
         for each(_loc8_ in _loc7_)
         {
            _loc8_.setStatus(SkinManager.getEmbed("TargetStatus",VSkin.CACHE_AS_BITMAP));
            _loc8_.display.addFilter(new GlowFilter(16711680,1,6,6));
         }
         this.bm.dropPanel.mouseLock = true;
         this.bm.rivalPanel.visible = false;
         this.bm.battlePanel.visible = false;
         this.bm.soldierDp.length = 0;
         _loc9_ = new VOBattleItem();
         _loc9_.shop = getShop("un_warrior",1);
         _loc9_.count = 5;
         this.bm.soldierDp.push(_loc9_);
         this.bm.dropPanel.setSpellDp(null);
         this.bm.dropPanel.update(this.bm.soldierDp);
         boardLock = true;
         Facade.myMediator.changeZoom(0.75);
         Facade.boardMediator.moveBoard(50,20);
         this.onStart();
      }
      
      private function onStart() : void
      {
         Facade.boardMediator.smoothMoveBoard(30,20,1.2);
         wait(1.3,this.onJaina1);
      }
      
      private function onJaina1() : void
      {
         assignStep(new NewStoryStep("un_jaina1",Lang.getString("jaina_mission1_1")).useMultipleSay(),this.onJaina2);
      }
      
      private function onJaina2() : void
      {
         Facade.changeUserStage("m1_jaina1_click");
         assignStep(new NewStoryStep("un_jaina1",Lang.getString("jaina_mission1_2"),true,Lang.getString("btn_help")),this.onJaina3);
      }
      
      private function onJaina3() : void
      {
         Facade.changeUserStage("m1_jaina2_click");
         assignStep(new NewStoryStep("un_hero1",Lang.getString("hero2_mission1"),true,null,"_1"),this.onWarrior);
      }
      
      private function onWarrior() : void
      {
         Facade.changeUserStage("m1_hero1_click");
         this.bm.battlePanel.visible = true;
         this.bm.dropPanel.mouseLock = false;
         Mission1Train.assignSelectDropStep(this,"un_warrior",this.onWarriorChoice);
      }
      
      private function onWarriorChoice() : void
      {
         Facade.changeUserStage("m1_warrior_choice");
         boardLock = false;
         Facade.myMediator.prefPanel.useDamageBt(true);
         Facade.myMediator.prefPanel.damageBt.visible = false;
         this.bm.onDamageVisible(null);
         assignStep(new CmdStep(new Position(36,24),new Position(26,20),"m1_warrior_vector_click"),this.onWarriorDrop);
      }
      
      private function onWarriorDrop() : void
      {
         Facade.changeUserStage("m1_warrior_vector_success");
         this.bm.dropPanel.mouseLock = true;
         this.bm.dropPanel.reset();
         wait(6,this.onSteamStart);
      }
      
      private function onSteamStart() : void
      {
         this.bm.soldierDp.length = 0;
         var _loc1_:VOBattleItem = new VOBattleItem();
         _loc1_.shop = getShop("un_hero",1);
         _loc1_.shop.su_damage *= 2;
         _loc1_.shop.su_stamina -= 600;
         _loc1_.count = 1;
         this.bm.soldierDp.push(_loc1_);
         this.bm.syncDropDp();
         CoreLogic.pause = true;
         this.bm.dropPanel.mouseLock = false;
         Mission1Train.assignSelectDropStep(this,"un_hero",this.onSteamChoice);
      }
      
      private function onSteamChoice() : void
      {
         Facade.changeUserStage("m1_hero_choice");
         CoreLogic.pause = false;
         assignStep(new CmdStep(new Position(36,24),new Position(26,20),"m1_hero_vector_click"),this.onSteamDrop);
      }
      
      private function onSteamDrop() : void
      {
         Facade.changeUserStage("m1_hero_vector_success");
         assignStep(new DamageStep("bl_guard_tower"),this.continueSteam);
      }
      
      private function continueSteam() : void
      {
         CoreLogic.pause = true;
         assignStep(new NewStoryStep("un_jaina1",Lang.getString("jaina_mission1_spell_1")).useMultipleSay(),this.onSpell1);
      }
      
      private function onSpell1() : void
      {
         Facade.changeUserStage("m1_jaina3_click");
         assignStep(new NewStoryStep("un_jaina1",Lang.getString("jaina_mission1_spell_2")),this.onSpell2);
      }
      
      private function onSpell2() : void
      {
         Facade.changeUserStage("m1_jaina4_click");
         var _loc1_:VOBattleItem = new VOBattleItem();
         var _loc2_:String = "sp_fireball";
         _loc1_.spellShop = Facade.manualProxy.getSpellShop(_loc2_,1);
         _loc1_.count = 1;
         this.bm.battlePanel.useDropPanel(true);
         this.bm.dropPanel.setSpellDp([_loc1_]);
         this.bm.dropPanel.update();
         this.bm.dropPanel.usePower = true;
         Mission1Train.assignSelectDropStep(this,_loc2_,this.onSpell3);
      }
      
      private function onSpell3() : void
      {
         Facade.changeUserStage("m1_fireball_choice");
         assignStep(new DropSpellStep(27,20,100,40,1),this.onSpell4);
      }
      
      private function onSpell4() : void
      {
         if(!Facade.checkUserStage("m1_fireball_use1"))
         {
            Facade.changeUserStage("m1_fireball_use1");
            Facade.fact(21);
         }
         CoreLogic.pause = false;
         this.bm.dropPanel.reset();
         this.bm.dropPanel.mouseLock = true;
         assignStep(new DamageStep("cn_ballista"),this.onSecondBallistaFall);
      }
      
      private function onSecondBallistaFall() : void
      {
         wait(0.8,MainLogic.checkTrainMission);
      }
   }
}

