package logic.sim
{
   import flash.geom.Point;
   
   public class Quadrants
   {
      
      public const quas:Vector.<Vector.<QuadrantElt>>;
      
      private const qua_size:int = 3;
      
      private const mega_qua_size:int = 2;
      
      private var size_x:int;
      
      private var size_y:int;
      
      public function Quadrants(param1:int, param2:int)
      {
         var _loc4_:Vector.<QuadrantElt> = null;
         var _loc5_:int = 0;
         this.quas = new Vector.<Vector.<QuadrantElt>>();
         super();
         this.size_x = int(param1 / this.qua_size);
         this.size_y = int(param2 / this.qua_size);
         var _loc3_:int = 0;
         while(_loc3_ <= this.size_x + 1)
         {
            _loc4_ = new Vector.<QuadrantElt>();
            _loc5_ = 0;
            while(_loc5_ <= this.size_y + 1)
            {
               _loc4_.push(new QuadrantElt());
               _loc5_++;
            }
            this.quas.push(_loc4_);
            _loc3_++;
         }
      }
      
      private function validateCoord(param1:int, param2:int) : Boolean
      {
         return param1 >= 0 && param1 <= this.size_x && param2 >= 0 && param2 <= this.size_y;
      }
      
      private function posToQuaPos(param1:Point) : Point
      {
         return new Point(int(param1.x / this.qua_size),int(param1.y / this.qua_size));
      }
      
      private function change(param1:Boolean, param2:Boolean, param3:Point, param4:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Vector.<int> = null;
         var _loc8_:int = 0;
         var _loc9_:Vector.<int> = null;
         var _loc10_:int = 0;
         var _loc5_:int = param3.x - this.mega_qua_size;
         while(_loc5_ <= param3.x + this.mega_qua_size)
         {
            _loc6_ = param3.y - this.mega_qua_size;
            while(_loc6_ <= param3.y + this.mega_qua_size)
            {
               if(this.validateCoord(_loc5_,_loc6_))
               {
                  _loc7_ = this.quas[_loc5_][_loc6_].dmq;
                  if(param2)
                  {
                     _loc7_ = this.quas[_loc5_][_loc6_].amq;
                  }
                  if(param1)
                  {
                     if(_loc7_.indexOf(param4) < 0)
                     {
                        _loc7_.push(param4);
                     }
                  }
                  else
                  {
                     _loc8_ = _loc7_.indexOf(param4);
                     if(_loc8_ >= 0)
                     {
                        _loc7_.splice(_loc8_,1);
                     }
                  }
               }
               _loc6_++;
            }
            _loc5_++;
         }
         if(param2)
         {
            _loc9_ = this.quas[param3.x][param3.y].aq;
            if(param1)
            {
               if(_loc9_.indexOf(param4) < 0)
               {
                  _loc9_.push(param4);
               }
            }
            else
            {
               _loc10_ = _loc9_.indexOf(param4);
               if(_loc10_ >= 0)
               {
                  _loc9_.splice(_loc10_,1);
               }
            }
         }
      }
      
      public function add(param1:Boolean, param2:Point, param3:int) : void
      {
         this.change(true,param1,this.posToQuaPos(param2),param3);
      }
      
      public function remove(param1:Boolean, param2:Point, param3:int) : void
      {
         this.change(false,param1,this.posToQuaPos(param2),param3);
      }
      
      public function move(param1:Point, param2:Point, param3:Boolean, param4:int) : void
      {
         var _loc5_:Point = this.posToQuaPos(param1);
         var _loc6_:Point = this.posToQuaPos(param2);
         if(!_loc6_.equals(_loc5_))
         {
            this.change(false,param3,_loc5_,param4);
            this.change(true,param3,_loc6_,param4);
         }
      }
      
      public function findNeigbours(param1:Boolean, param2:Point) : Vector.<int>
      {
         var _loc3_:Point = this.posToQuaPos(param2);
         var _loc4_:QuadrantElt = this.quas[_loc3_.x][_loc3_.y];
         var _loc5_:Vector.<int> = param1 ? _loc4_.dmq : _loc4_.amq;
         return _loc5_.slice();
      }
      
      public function attackersOnPos(param1:Point) : Vector.<int>
      {
         var _loc2_:Point = this.posToQuaPos(param1);
         var _loc3_:Vector.<int> = this.quas[_loc2_.x][_loc2_.y].aq;
         return _loc3_.slice();
      }
   }
}

