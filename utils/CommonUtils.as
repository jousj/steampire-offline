package utils
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.describeType;
   
   public class CommonUtils
   {
      
      public function CommonUtils()
      {
         super();
      }
      
      public static function getRangeRandom(param1:uint, param2:uint) : uint
      {
         var _loc3_:uint = 0;
         if(param2 > param1)
         {
            _loc3_ = Math.ceil(Math.random() * (param2 - param1 + 1));
            if(_loc3_ > 0)
            {
               _loc3_--;
            }
            return param1 + _loc3_;
         }
         return param1;
      }
      
      public static function getConstantName(param1:Class, param2:*) : String
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         for each(_loc3_ in describeType(param1).constant)
         {
            _loc4_ = _loc3_.@name.toString();
            if(param1[_loc4_] === param2)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public static function getMethodName(param1:Class, param2:Function) : String
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         for each(_loc3_ in describeType(param1).method)
         {
            _loc4_ = _loc3_.@name.toString();
            if(param1[_loc4_] === param2)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public static function getDisplayRect(param1:DisplayObject, param2:DisplayObject) : Rectangle
      {
         if(param1.width > 0 && param1.height > 0)
         {
            return param1.getRect(param2);
         }
         var _loc3_:Rectangle = new Rectangle();
         _loc3_.offsetPoint(param2.globalToLocal(param1.localToGlobal(new Point())));
         return _loc3_;
      }
      
      public static function calcAngle(param1:Number, param2:Number, param3:Number, param4:Number, param5:Boolean = false) : Number
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(param1 == param3)
         {
            if(param4 > param2)
            {
               _loc6_ = 180;
            }
            else
            {
               _loc6_ = 0;
            }
         }
         else
         {
            _loc7_ = -(param2 - param4) / (param3 - param1);
            _loc6_ = Math.atan(_loc7_) * 180 / Math.PI;
            if(param3 > param1)
            {
               _loc6_ += 90;
            }
            else
            {
               _loc6_ += 270;
            }
         }
         if(param5)
         {
            _loc6_ *= Math.PI / 180;
         }
         return _loc6_;
      }
      
      public static function sort(param1:Array, param2:Object, param3:Object = null) : void
      {
         var i:int;
         var ar:Array = param1;
         var fieldName:Object = param2;
         var options:Object = param3;
         if(fieldName is String)
         {
            fieldName = [fieldName];
         }
         i = (fieldName as Array).length - 1;
         while(i >= 0)
         {
            fieldName[i] = (fieldName[i] as String).split(".");
            i--;
         }
         if(options != null && !(options is Array))
         {
            options = [options];
         }
         ar.sort(function(param1:Object, param2:Object):int
         {
            var _loc4_:uint = 0;
            var _loc5_:Boolean = false;
            var _loc6_:* = undefined;
            var _loc7_:* = undefined;
            var _loc8_:String = null;
            var _loc9_:int = 0;
            var _loc3_:int = 0;
            while(_loc3_ < (fieldName as Array).length)
            {
               _loc4_ = options != null && options[_loc3_] != null ? uint(options[_loc3_]) : 0;
               _loc5_ = (_loc4_ & Array.DESCENDING) != 0;
               _loc6_ = param1;
               _loc7_ = param2;
               for each(_loc8_ in fieldName[_loc3_])
               {
                  if(!_loc6_.hasOwnProperty(_loc8_))
                  {
                     return _loc5_ ? -1 : 1;
                  }
                  _loc6_ = _loc6_[_loc8_];
                  if(!_loc7_.hasOwnProperty(_loc8_))
                  {
                     return _loc5_ ? 1 : -1;
                  }
                  _loc7_ = _loc7_[_loc8_];
               }
               if(_loc6_ != _loc7_)
               {
                  if((_loc4_ & Array.NUMERIC) != 0)
                  {
                     _loc9_ = Number(_loc6_) > Number(_loc7_) ? 1 : -1;
                  }
                  else
                  {
                     _loc9_ = (_loc4_ & Array.CASEINSENSITIVE) != 0 ? String(_loc6_).toLowerCase().localeCompare(String(_loc7_).toLowerCase()) : String(_loc6_).localeCompare(String(_loc7_));
                  }
                  if(_loc5_)
                  {
                     _loc9_ *= -1;
                  }
                  return _loc9_;
               }
               _loc3_++;
            }
            return 0;
         });
      }
   }
}

