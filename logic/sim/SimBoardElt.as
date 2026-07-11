package logic.sim
{
   public class SimBoardElt
   {
      
      public var obj:SimBoardObj = null;
      
      public var passability:Number = 4;
      
      public var units:Vector.<int> = new Vector.<int>();
      
      public var cannons:Vector.<int> = new Vector.<int>();
      
      public var guards:Vector.<int> = new Vector.<int>();
      
      public var landing:Vector.<int> = new Vector.<int>();
      
      public var regs:Vector.<int> = new Vector.<int>();
      
      private var _modifs:Vector.<SimModif> = new Vector.<SimModif>();
      
      public function SimBoardElt()
      {
         super();
      }
      
      public function addModif(param1:int, param2:int, param3:Number) : void
      {
         var _loc4_:SimModif = null;
         var _loc5_:SimModif = null;
         for each(_loc5_ in this._modifs)
         {
            if(_loc5_.kind == param1)
            {
               _loc4_ = _loc5_;
            }
         }
         if(_loc4_)
         {
            if(_loc4_.etime <= param2)
            {
               _loc4_.etime = param2;
               _loc4_.k = param3;
            }
         }
         else
         {
            _loc4_ = new SimModif(param1,param2,param3);
            this._modifs.push(_loc4_);
         }
      }
      
      public function get_modif(param1:int, param2:int) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:SimModif = null;
         for each(_loc4_ in this._modifs)
         {
            if(_loc4_.kind == param1 && _loc4_.etime >= param2)
            {
               _loc3_ = _loc4_.k;
            }
         }
         return _loc3_;
      }
   }
}

