package logic.training
{
   import engine.signal.Signal;
   import proto.model.PShopUnit;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   
   public class AbstractTrain
   {
      
      public static var instance:AbstractTrain;
      
      private var step:AbstractTrainStep;
      
      private var stepHandler:Function;
      
      private var cinemaPanel:VComponent;
      
      public function AbstractTrain()
      {
         super();
      }
      
      public static function assign(param1:AbstractTrain) : void
      {
         clear();
         instance = param1;
         param1.run();
      }
      
      public static function assignStep(param1:AbstractTrainStep) : void
      {
         var _loc2_:AbstractTrain = new AbstractTrain();
         assign(_loc2_);
         _loc2_.assignStep(param1);
      }
      
      public static function clear() : void
      {
         if(instance)
         {
            instance.dispose();
            instance = null;
         }
      }
      
      public function run() : void
      {
      }
      
      public function dispose() : void
      {
         if(this.cinemaPanel)
         {
            this.cinemaPanel.removeFromParent();
         }
         Signal.stopRef(this);
         this.boardLock = false;
         this.clearStep();
      }
      
      protected function clearStep() : void
      {
         if(this.step)
         {
            this.step.endFunc = null;
            this.step.dispose();
            this.step = null;
         }
      }
      
      public function assignStep(param1:AbstractTrainStep, param2:Function = null) : void
      {
         this.clearStep();
         this.stepHandler = param2;
         this.step = param1;
         param1.endFunc = this.endStep;
         param1.run();
      }
      
      private function endStep() : void
      {
         var _loc1_:Function = null;
         this.clearStep();
         if(this.stepHandler != null)
         {
            _loc1_ = this.stepHandler;
            this.stepHandler = null;
            _loc1_();
         }
      }
      
      public function wait(param1:Number, param2:Function, param3:Boolean = false) : void
      {
         Signal.createRef(this,param2,0,0,false).delayCall(param1,param3);
      }
      
      public function set cinemaStrips(param1:Boolean) : void
      {
         if(param1 != Boolean(this.cinemaPanel))
         {
            if(param1)
            {
               this.cinemaPanel = new VComponent();
               this.cinemaPanel.mouseChildren = this.cinemaPanel.mouseEnabled = false;
               this.cinemaPanel.add(new VFill(0),{
                  "wP":100,
                  "h":100
               });
               this.cinemaPanel.add(new VFill(0),{
                  "wP":100,
                  "h":100,
                  "bottom":0
               });
               Facade.mainPanel.addInterLayer(this.cinemaPanel);
            }
            else
            {
               this.cinemaPanel.removeFromParent();
               this.cinemaPanel = null;
            }
         }
      }
      
      protected function getShop(param1:String, param2:uint = 0, param3:Boolean = false) : PShopUnit
      {
         var _loc4_:PShopUnit = Facade.manualProxy.getSoldierShop(param1,param2,param3);
         return PShopUnit.create(_loc4_.su_kind,_loc4_.su_level,_loc4_.su_radius,_loc4_.su_damage,_loc4_.su_stamina,_loc4_.su_armor,_loc4_.su_penetration,_loc4_.su_is_air,_loc4_.su_is_healer,_loc4_.su_is_kamikaze,_loc4_.su_move_delay,_loc4_.su_priority_type,_loc4_.su_priority_factor,_loc4_.su_attack_time,_loc4_.su_attack_delay,_loc4_.su_bullet_speed,_loc4_.su_aoe_radius,_loc4_.su_price,_loc4_.su_hspace,_loc4_.su_upgrade_price,_loc4_.su_upgrade_time,_loc4_.su_upgrade_requirement,_loc4_.su_can_buy,_loc4_.su_target_type,_loc4_.su_info_icons,_loc4_.su_model_level,_loc4_.su_is_hero,_loc4_.su_attacked_by,_loc4_.su_is_clan,_loc4_.su_max_cure_stamina,_loc4_.su_eff,null,_loc4_.su_power_points);
      }
      
      public function set boardLock(param1:Boolean) : void
      {
         if(param1)
         {
            Facade.boardMediator.resetDown();
         }
         Facade.board.mouseEnabled = !param1;
      }
   }
}

