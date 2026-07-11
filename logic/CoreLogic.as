package logic
{
   import engine.Board;
   import engine.data.LinkedIterator;
   import engine.display.AnimClip;
   import engine.signal.Signal;
   import flash.events.Event;
   import flash.utils.getTimer;
   import model.vo.MapAction;
   
   public class CoreLogic
   {
      
      public static var time:Number;
      
      public static var serverTime:Number;
      
      private static var board:Board;
      
      private static var lastGetTimer:int;
      
      private static var serverInitTime:Number;
      
      private static var clientInitTime:int;
      
      private static var isRun:Boolean;
      
      private static var isPause:Boolean;
      
      private static var actionList:Vector.<MapAction>;
      
      private static var simulateIterator:LinkedIterator;
      
      private static var commonIterator:LinkedIterator;
      
      private static var date:Date;
      
      private static var startGetTimer:int;
      
      private static var lastCallDiff:int;
      
      private static var passTime:int;
      
      public static var simulateFactor:Number = 1;
      
      public static var correctFactor:Number = 1;
      
      private static var startServerTime:Number = 0;
      
      public function CoreLogic()
      {
         super();
      }
      
      public static function init(param1:Board) : void
      {
         CoreLogic.board = param1;
         actionList = new Vector.<MapAction>();
         simulateIterator = Signal.simulateIterator;
         AnimClip.playList = simulateIterator.getList();
         commonIterator = Signal.commonIterator;
      }
      
      public static function stop() : void
      {
         if(isRun)
         {
            isRun = false;
            isPause = false;
            Facade.stage.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
         }
         clientInitTime = 0;
         time = 0;
         actionList.length = 0;
         simulateFactor = 1;
         Signal.clear();
      }
      
      public static function start(param1:Number, param2:int = -1) : void
      {
         CoreLogic.serverInitTime = param1;
         var _loc3_:int = getTimer();
         if(param2 >= 0)
         {
            passTime = param2;
         }
         clientInitTime = _loc3_ + passTime;
         serverTime = param1 + (_loc3_ - clientInitTime) * correctFactor / 1000;
         date = null;
         if(!isRun)
         {
            lastGetTimer = _loc3_;
            if(param1 > 0 && startServerTime == 0)
            {
               startGetTimer = _loc3_;
               startServerTime = param1;
            }
            isRun = true;
            board.zSort();
            board.lastSortTime = _loc3_ + 100;
            Facade.stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);
         }
      }
      
      public static function changeTime(param1:Number, param2:Boolean = true) : void
      {
         if(!param2 || param1 > time)
         {
            time = param1;
            lastGetTimer = getTimer();
         }
      }
      
      public static function get running() : Boolean
      {
         return isRun;
      }
      
      public static function set pause(param1:Boolean) : void
      {
         if(param1 != isPause)
         {
            if(param1)
            {
               if(isRun)
               {
                  isPause = true;
               }
            }
            else
            {
               lastGetTimer = getTimer();
               isPause = false;
            }
            if(Facade.isBattle)
            {
               Facade.audioProxy.pause(param1);
            }
         }
      }
      
      public static function get pause() : Boolean
      {
         return isPause;
      }
      
      private static function onEnterFrame(param1:Event) : void
      {
         var _loc2_:int = getTimer();
         var _loc3_:Number = serverInitTime + (_loc2_ - clientInitTime) * correctFactor / 1000;
         CoreLogic.serverTime = _loc3_;
         while(actionList.length > 0 && actionList[0].time <= _loc3_)
         {
            actionList.shift().run();
         }
         Signal.updateTime(commonIterator,_loc3_);
         if(!isPause)
         {
            time += (_loc2_ - lastGetTimer) * correctFactor * simulateFactor / 1000;
            lastGetTimer = _loc2_;
            Signal.updateTime(simulateIterator,time);
         }
         if(board.isNeedZSort)
         {
            if(_loc2_ >= board.lastSortTime)
            {
               if(isRun)
               {
                  board.zSort();
                  board.lastSortTime = _loc2_ + 100;
               }
            }
         }
      }
      
      public static function addAction(param1:MapAction, param2:Number) : void
      {
         param1.time = param2;
         var _loc3_:uint = actionList.length;
         if(_loc3_ == 0)
         {
            actionList.push(param1);
         }
         else
         {
            while(_loc3_ > 0)
            {
               _loc3_--;
               if(param2 >= actionList[_loc3_].time)
               {
                  actionList.splice(_loc3_ + 1,0,param1);
                  return;
               }
            }
            actionList.unshift(param1);
         }
      }
      
      public static function createAction(param1:Function, param2:uint, param3:Number, param4:uint = 0, param5:* = null) : MapAction
      {
         var _loc6_:MapAction = new MapAction();
         _loc6_.handler = param1;
         _loc6_.objId = param4;
         _loc6_.variance = param2;
         _loc6_.value = param5;
         addAction(_loc6_,param3);
         return _loc6_;
      }
      
      public static function removeAction(param1:MapAction, param2:Boolean = false) : void
      {
         var _loc3_:int = actionList.indexOf(param1);
         if(_loc3_ >= 0)
         {
            actionList.splice(_loc3_,1);
            if(param2)
            {
               param1.run();
            }
         }
      }
      
      public static function removeFilterActions(param1:uint, param2:uint = 0, param3:Boolean = false) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:Vector.<MapAction> = null;
         var _loc8_:MapAction = null;
         var _loc4_:uint = actionList.length;
         if(_loc4_ > 0)
         {
            _loc5_ = param1 > 0;
            _loc6_ = param2 > 0;
            if(_loc5_ || _loc6_)
            {
               while(_loc4_ > 0)
               {
                  _loc4_--;
                  _loc8_ = actionList[_loc4_];
                  if((!_loc5_ || _loc8_.objId == param1) && (!_loc6_ || _loc8_.variance == param2))
                  {
                     actionList.splice(_loc4_,1);
                     if(param3)
                     {
                        if(_loc7_)
                        {
                           _loc7_.push(_loc8_);
                        }
                        else
                        {
                           _loc7_ = new <MapAction>[_loc8_];
                        }
                     }
                  }
               }
               if(param3)
               {
                  for each(_loc8_ in _loc7_)
                  {
                     _loc8_.run();
                  }
               }
            }
         }
      }
      
      public static function getAction(param1:uint, param2:uint = 0, param3:MapAction = null) : MapAction
      {
         var _loc6_:MapAction = null;
         var _loc4_:uint = actionList.length;
         if(_loc4_ == 0)
         {
            return null;
         }
         var _loc5_:int = 0;
         if(param3)
         {
            _loc5_ = actionList.indexOf(param3);
            if(_loc5_ < 0)
            {
               return null;
            }
         }
         while(_loc5_ < _loc4_)
         {
            _loc6_ = actionList[_loc5_];
            if(_loc6_.variance == param1)
            {
               if(param2 == 0 || _loc6_.objId == param2)
               {
                  return _loc6_;
               }
            }
            _loc5_++;
         }
         return null;
      }
      
      public static function getActionEx(param1:uint, param2:*, param3:Boolean = false, param4:Boolean = false) : MapAction
      {
         var _loc5_:MapAction = null;
         for each(_loc5_ in actionList)
         {
            if(_loc5_.variance == param1 && _loc5_.value == param2)
            {
               if(param3)
               {
                  removeAction(_loc5_,param4);
                  break;
               }
               return _loc5_;
            }
         }
         return null;
      }
      
      public static function getActionList(param1:uint) : Vector.<MapAction>
      {
         var _loc2_:Vector.<MapAction> = null;
         var _loc3_:MapAction = null;
         for each(_loc3_ in actionList)
         {
            if(_loc3_.variance == param1)
            {
               if(_loc2_)
               {
                  _loc2_.push(_loc3_);
               }
               else
               {
                  _loc2_ = new <MapAction>[_loc3_];
               }
            }
         }
         return _loc2_;
      }
      
      public static function getActionTimeLeft(param1:uint, param2:uint = 0) : Number
      {
         var _loc4_:Number = NaN;
         var _loc3_:MapAction = getAction(param1,param2);
         if(_loc3_)
         {
            _loc4_ = serverTime;
            if(_loc3_.time > _loc4_)
            {
               return _loc3_.time - _loc4_;
            }
         }
         return 0;
      }
      
      public static function resetActions() : void
      {
         actionList.length = 0;
      }
      
      public static function get sessionDuration() : Number
      {
         return (getTimer() - clientInitTime) / 1000;
      }
      
      public static function getSignalTime(param1:Boolean) : Number
      {
         if(param1)
         {
            if(isPause)
            {
               return time;
            }
            return time + (getTimer() - lastGetTimer) / 1000;
         }
         return serverInitTime + (getTimer() - clientInitTime) / 1000;
      }
      
      public static function getDate(param1:Number = 0) : Date
      {
         if(!date)
         {
            date = new Date();
         }
         date.time = param1 <= 0 ? serverInitTime + (getTimer() - clientInitTime) : param1 * 1000;
         return date;
      }
      
      public static function getCheckTime() : int
      {
         return clientInitTime;
      }
      
      public static function calcDiff(param1:Number, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         if(isRun && param2 <= 400)
         {
            _loc3_ = (param1 - startServerTime) * 1000;
            lastCallDiff = getTimer();
            _loc4_ = lastCallDiff - startGetTimer - (param2 >> 1);
            param2 = _loc3_ - _loc4_;
            _loc5_ = param1 - CoreLogic.serverTime;
            if(_loc5_ < 0.5 || _loc5_ > 3.5)
            {
               start(param1);
            }
         }
      }
   }
}

