package engine.data
{
   import engine.units.Unit;
   
   public class MapCell
   {
      
      public var x:int;
      
      public var y:int;
      
      public var walkFactor:uint;
      
      public var walkType:uint;
      
      public var unit:Unit;
      
      public var landing:Boolean;
      
      public var f:int;
      
      public var g:int;
      
      public var parent:MapCell;
      
      public var isClosed:Boolean;
      
      public function MapCell()
      {
         super();
      }
      
      public function bind(param1:Unit, param2:uint, param3:uint) : void
      {
         if(this.unit)
         {
            throw new Error("pos (" + this.x + "," + this.y + ") bad bind " + param1 + ", old bind " + this.unit);
         }
         this.unit = param1;
         this.walkFactor = param2;
         this.walkType = param3;
      }
      
      public function unbind(param1:Unit) : void
      {
         if(param1 == this.unit)
         {
            this.unit = null;
            this.walkFactor = 1;
            this.walkType = 0;
         }
      }
      
      public function get occupied() : Boolean
      {
         return this.walkFactor != 1 || Boolean(this.unit);
      }
      
      public function toString() : String
      {
         return "(" + this.x + "," + this.y + ")";
      }
   }
}

