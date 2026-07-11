package engine
{
   import engine.units.ZObject;
   import flash.geom.Point;
   
   public class Isometric
   {
      
      public static var POS_WIDTH:uint;
      
      public static var POS_HEIGHT:uint;
      
      public static var POS_HALF_WIDTH:uint;
      
      public static var POS_HALF_HEIGHT:uint;
      
      public static var POS_WORLD_SIZE:Number;
      
      public static var POS_DIAG:Number;
      
      public static var POS_WORLD_DIAG:Number;
      
      private static var sinAlpha:Number;
      
      private static var cosAlpha:Number;
      
      private static var m:Number;
      
      private static var n:Number;
      
      public function Isometric()
      {
         super();
      }
      
      public static function init(param1:uint, param2:uint, param3:Number, param4:Number) : void
      {
         POS_WIDTH = param1;
         POS_HEIGHT = param2;
         POS_HALF_WIDTH = param1 >> 1;
         POS_HALF_HEIGHT = param2 >> 1;
         POS_DIAG = Math.sqrt(POS_HALF_WIDTH * POS_HALF_WIDTH + POS_HALF_HEIGHT * POS_HALF_HEIGHT);
         sinAlpha = Math.sin(param3);
         cosAlpha = Math.cos(param3);
         m = 1 / (cosAlpha / sinAlpha + sinAlpha / cosAlpha);
         n = sinAlpha * Math.sin(param4);
         POS_WORLD_SIZE = (param1 - param1 / cosAlpha * m * sinAlpha) / cosAlpha;
         POS_WORLD_DIAG = Math.sqrt(2 * (POS_WORLD_SIZE * POS_WORLD_SIZE));
      }
      
      public static function screenToPos(param1:Number, param2:Number, param3:Position) : void
      {
         var _loc4_:Number = (param2 / n - param1 / cosAlpha) * m;
         param3.x = Math.floor((param1 + _loc4_ * sinAlpha) / cosAlpha / POS_WORLD_SIZE);
         param3.y = Math.floor(_loc4_ / POS_WORLD_SIZE);
      }
      
      public static function posToScreen(param1:int, param2:int, param3:Point) : void
      {
         var _loc4_:Number = (param2 + 0.5) * POS_WORLD_SIZE;
         var _loc5_:Number = (param1 + 0.5) * POS_WORLD_SIZE * cosAlpha - _loc4_ * sinAlpha;
         param3.x = Math.round(_loc5_);
         param3.y = Math.round((_loc4_ / m + _loc5_ / cosAlpha) * n);
      }
      
      public static function screenToWorld(param1:Number, param2:Number, param3:Point) : void
      {
         var _loc4_:Number = (param2 / n - param1 / cosAlpha) * m;
         param3.x = (param1 + _loc4_ * sinAlpha) / cosAlpha;
         param3.y = _loc4_;
      }
      
      public static function worldToScreen(param1:Number, param2:Number, param3:Point) : void
      {
         var _loc4_:Number = param1 * cosAlpha - param2 * sinAlpha;
         param3.x = Math.round(_loc4_);
         param3.y = Math.round((param2 / m + _loc4_ / cosAlpha) * n);
      }
      
      public static function posToWorld(param1:int, param2:int, param3:Point) : void
      {
         param3.x = (param1 + 0.5) * POS_WORLD_SIZE;
         param3.y = (param2 + 0.5) * POS_WORLD_SIZE;
      }
      
      public static function worldToPos(param1:Number, param2:Number, param3:Position) : void
      {
         param3.x = Math.floor(param1 / POS_WORLD_SIZE);
         param3.y = Math.floor(param2 / POS_WORLD_SIZE);
      }
      
      public static function applyScreenPoint(param1:ZObject) : void
      {
         var _loc2_:Number = (param1.b_y + 0.5) * POS_WORLD_SIZE;
         var _loc3_:Number = (param1.b_x + 0.5) * POS_WORLD_SIZE * cosAlpha - _loc2_ * sinAlpha;
         param1.display.setPos(_loc3_,(_loc2_ / m + _loc3_ / cosAlpha) * n);
      }
   }
}

