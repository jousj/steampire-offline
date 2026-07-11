package logic.sim
{
   import flash.geom.Point;
   import proto.model.PShopCannon;
   
   public class SimCannonT
   {
      
      public static const INIT:int = 1;
      
      public static const ATTACK:int = 2;
      
      public var id:int;
      
      public var stamina:int;
      
      public var pos:Point;
      
      public var size:Point;
      
      public var radius:int;
      
      public var blind_radius:int;
      
      public var pylons:Vector.<int> = new Vector.<int>();
      
      public var target_type:int;
      
      public var damage:int;
      
      public var armor:int;
      
      public var penetration:Number;
      
      public var aoe_radius:int;
      
      public var state:int = 1;
      
      public var attack_delay:int;
      
      public var attack_time:int;
      
      public var bullet_speed:int;
      
      public var is_finished:Boolean;
      
      public var slowdown:int;
      
      public var slowdown_time:int;
      
      public var max_stamina:int;
      
      public var is_no_target:Boolean = true;
      
      public var favorite_units:Array;
      
      public var favorite_dmg_koef:Number = 1;
      
      public var shop:PShopCannon;
      
      public var disabled_time:int;
      
      public var sort_by_distance:Boolean;
      
      public function SimCannonT()
      {
         super();
      }
      
      public function removePylon(param1:int) : void
      {
         var _loc2_:int = this.pylons.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.pylons.splice(_loc2_,1);
         }
      }
      
      public function canFire(param1:int) : Boolean
      {
         return this.stamina > 0 && this.pylons.length > 0 && this.is_finished && param1 >= this.disabled_time;
      }
      
      public function boardObj() : SimBoardObj
      {
         return new SimBoardObj(SimBoardObj.CANNON,this.id);
      }
   }
}

