package logic.sim
{
   import flash.geom.Point;
   import proto.model.PShopUnit;
   
   public class SimUnitT
   {
      
      public static const GO_TO_TARGET:int = 1;
      
      public static const INIT:int = 2;
      
      public static const WAIT_ATTACKER:int = 3;
      
      public static const WAIT_INIT:int = 4;
      
      public static const EFFECT_SLOWDOWN:int = 5;
      
      public var id:int;
      
      public var stamina:int;
      
      public var max_stamina:int;
      
      public var pos:Point;
      
      public var is_air:Boolean;
      
      public var damage:int;
      
      public var armor:int;
      
      public var penetration:Number;
      
      public var is_attacker:Boolean;
      
      public var is_active:Boolean;
      
      public var priority_type:int;
      
      public var priority_factor:Number;
      
      public var aoe_radius:int;
      
      public var radius:int;
      
      public var state:int = 2;
      
      public var path:Vector.<Point> = null;
      
      public var target_id:SimBoardObj = null;
      
      public var recalc_path:Boolean = false;
      
      public var size:Point = new Point(1,1);
      
      public var building_id:int;
      
      public var move_delay:int;
      
      public var attack_delay:int;
      
      public var attack_time:int;
      
      public var bullet_speed:int;
      
      public var is_kamikaze:Boolean;
      
      public var is_healer:Boolean;
      
      public var find_unit:Boolean = false;
      
      public var target_type:int;
      
      public var reg_pos:Point = null;
      
      public var group:Number;
      
      public var fences_wish:Vector.<int>;
      
      public var prev_pos:Point;
      
      public var effects:Vector.<Object> = new Vector.<Object>();
      
      public var user_num:uint;
      
      public var kind:String;
      
      public var level:int;
      
      private var _spell_call:Array = [];
      
      public var attacked_by:Array;
      
      public var max_cure_stamina:int = 0;
      
      public var cure_count:int = 0;
      
      public var shop:PShopUnit;
      
      public function SimUnitT()
      {
         super();
      }
      
      public function boardObj() : SimBoardObj
      {
         return new SimBoardObj(SimBoardObj.UNIT,this.id);
      }
      
      public function setInitState() : void
      {
         this.state = INIT;
         this.target_id = null;
         this.path = null;
      }
      
      public function addEffect(param1:Object) : void
      {
         this.effects.push(param1);
      }
      
      public function speed(param1:int, param2:int) : int
      {
         var _loc4_:Object = null;
         var _loc3_:int = param1;
         for each(_loc4_ in this.effects)
         {
            if(_loc4_.kind == EFFECT_SLOWDOWN && _loc4_.end_time > param2)
            {
               _loc3_ += int(Number(param1) / 100 * Number(_loc4_.value));
            }
         }
         return _loc3_;
      }
      
      public function setSpellCall(param1:Point, param2:int) : void
      {
         this.setInitState();
         this._spell_call = [param1.clone(),param2];
      }
      
      public function spellCall(param1:int) : Point
      {
         var _loc2_:Point = null;
         if(Boolean(this._spell_call.length > 0) && Boolean(this._spell_call[1]) && (this._spell_call[1] <= param1 || this.pos.equals(this._spell_call[0])))
         {
            this.setInitState();
            this._spell_call = [];
         }
         else if(Boolean(this._spell_call) && Boolean(this._spell_call[1]) && this._spell_call[1] > param1)
         {
            _loc2_ = this._spell_call[0];
         }
         return _loc2_;
      }
      
      public function isSpellCallPath(param1:int) : Boolean
      {
         var _loc2_:Point = this.spellCall(param1);
         return Boolean(_loc2_) && this.path.length > 0 && _loc2_.equals(this.path[this.path.length - 1]);
      }
   }
}

