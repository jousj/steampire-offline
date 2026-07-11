package logic.training
{
   import engine.signal.Signal;
   import engine.units.AnimObject;
   import engine.units.Soldier;
   import game.battle.BattleMediator;
   import logic.DialogLogic;
   import logic.UnitFactory;
   import model.CommonEvent;
   import proto.model.PShopSpell;
   import proto.model.PShopUnit;
   import ui.game.BubblePanel;
   import ui.vbase.VEvent;
   
   public class BossRegularTrain extends AbstractTrain
   {
      
      public var bossKind:String;
      
      private const controlSignal:Signal = new Signal();
      
      private const bm:BattleMediator = Facade.battleMediator;
      
      private var allow_say:Boolean;
      
      private var boss:Soldier;
      
      public function BossRegularTrain(param1:String)
      {
         super();
         this.bossKind = param1;
      }
      
      override public function run() : void
      {
         Facade.myMediator.changeZoom(0.65);
         this.bm.battlePanel.hideWinTargetPanel();
         var _loc1_:PShopUnit = getShop(this.bossKind,1);
         this.boss = UnitFactory.createSoldier(_loc1_,10001);
         this.boss.direction = AnimObject.LEFT_UP;
         this.boss.setGeometry(44,22,true);
         Facade.boardMediator.addObject(this.boss,true);
         assignStep(new NewStoryStep(this.bossKind,Lang.getRangedString(this.bossKind + "_attack"),false),this.onBossSay);
         this.controlSignal.handler = this.onBossSay;
         this.controlSignal.delay = 5;
         this.controlSignal.run(5);
         Facade.addListener(CommonEvent.DAMAGE,this.onDamage);
      }
      
      private function onBossSay() : void
      {
         this.controlSignal.stopWithoutHandler();
         this.controlSignal.handler = this.onBubbleCooldown;
         this.controlSignal.delay = 10;
         wait(5,this.clearBossBubble);
         UnitFactory.useBubble(this.boss,Lang.getRangedString(this.bossKind + "_bubble"),{
            "w":175,
            "h":100,
            "right":46,
            "vCenter":22
         },BubblePanel.TAIL_RIGHT);
         Facade.boardMediator.moveBoard(44,22);
         assignStep(new SoftHintStep(this.bm.dropPanel.spellGrid.renderList[0]),this.onHint);
      }
      
      private function onHint() : void
      {
         assignStep(new SoftDropStep(),this.onSpellDrop);
         this.bm.dropPanel.addListener(VEvent.SELECT,this.onSelect);
      }
      
      private function onSelect(param1:VEvent) : void
      {
         if(this.bm.dropPanel.selectPanel)
         {
            assignStep(new SoftDropStep(),this.onSpellDrop);
         }
         else
         {
            assignStep(new SoftHintStep(this.bm.dropPanel.spellGrid,2,true),this.onHint);
         }
      }
      
      private function onSpellDrop() : void
      {
         assignStep(new SoftDropStep(),this.onSpellDrop);
         var _loc1_:PShopSpell = this.bm.dropPanel.selectPanel.item.spellShop;
         if(this.bm.sim.data.power > _loc1_.ssp_power_price)
         {
            this.trySay(Lang.getRangedString(this.bossKind + "_spell_reaction",1,10,{"__SPELL__":Lang.getString(_loc1_.ssp_kind)}));
         }
      }
      
      private function trySay(param1:String) : void
      {
         if(this.allow_say)
         {
            this.allow_say = false;
            UnitFactory.useBubble(this.boss,param1,{
               "w":175,
               "h":100,
               "right":46,
               "vCenter":22
            },BubblePanel.TAIL_RIGHT);
            wait(5,this.clearBossBubble);
         }
      }
      
      private function clearBossBubble() : void
      {
         this.boss.setStatus(null);
         this.controlSignal.run(1);
      }
      
      private function onBubbleCooldown() : void
      {
         this.allow_say = true;
      }
      
      private function onDamage(param1:CommonEvent) : void
      {
         this.trySay(Lang.getRangedString(this.bossKind + "_build_reaction",1,10,{"__BUILD__":Lang.getString(param1.data)}));
      }
      
      override public function dispose() : void
      {
         Facade.setMapCallback(DialogLogic.openHistory,[false,0,true]);
         this.controlSignal.stopWithoutHandler();
         this.bm.dropPanel.removeListener(VEvent.SELECT,this.onSelect);
         Facade.removeListener(CommonEvent.DAMAGE,this.onDamage);
         super.dispose();
      }
   }
}

