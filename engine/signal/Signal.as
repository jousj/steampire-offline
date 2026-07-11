package engine.signal
{
   import engine.data.LinkedItem;
   import engine.data.LinkedIterator;
   import engine.data.LinkedList;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import logic.CoreLogic;
   import model.ui.VOCallback;
   
   public class Signal extends LinkedItem
   {
      
      protected static var refDict:Dictionary;
      
      private static const simulateList:LinkedList = new LinkedList();
      
      private static const commonList:LinkedList = new LinkedList();
      
      private static const globalIterator:LinkedIterator = new LinkedIterator(new LinkedList());
      
      public static const ADD_PERIOD:uint = 1;
      
      public static const ADD_TIMER:uint = 2;
      
      public static const simulateIterator:LinkedIterator = new LinkedIterator(simulateList);
      
      public static const commonIterator:LinkedIterator = new LinkedIterator(commonList);
      
      public var duration:Number;
      
      public var tail:Number;
      
      public var delay:Number = 0;
      
      public var endTime:Number = 0;
      
      public var handlerTime:Number;
      
      public var handler:Function;
      
      public var useThisArg:Boolean;
      
      public var stopHandler:Function;
      
      public var list:LinkedList;
      
      public var addType:uint;
      
      public var data:*;
      
      public function Signal(param1:Function = null, param2:uint = 0, param3:Boolean = false)
      {
         super();
         this.handler = param1;
         this.addType = param2;
         this.useThisArg = param3;
      }
      
      public static function updateTime(param1:LinkedIterator, param2:Number) : void
      {
         var _loc3_:Signal = null;
         param1.toHead();
         while(param1.item)
         {
            _loc3_ = param1.item as Signal;
            param1.next();
            if(param2 >= _loc3_.handlerTime)
            {
               if(param2 >= _loc3_.endTime)
               {
                  _loc3_.tail = 0;
                  _loc3_.list.remove(_loc3_);
                  _loc3_.list = null;
                  if(_loc3_.stopHandler != null)
                  {
                     _loc3_.stopHandler(_loc3_);
                     continue;
                  }
               }
               else
               {
                  _loc3_.handlerTime = param2;
                  _loc3_.addDelay();
               }
               if(_loc3_.useThisArg)
               {
                  _loc3_.handler(_loc3_);
               }
               else
               {
                  _loc3_.handler();
               }
            }
         }
      }
      
      public static function clear() : void
      {
         var _loc1_:Signal = null;
         if(refDict)
         {
            for each(_loc1_ in refDict)
            {
               _loc1_.stopHandler = null;
            }
            refDict = null;
         }
         clearList(simulateIterator);
         clearList(commonIterator);
      }
      
      private static function clearList(param1:LinkedIterator) : void
      {
         var _loc4_:Vector.<Signal> = null;
         var _loc2_:LinkedList = param1.getList();
         var _loc3_:Signal = _loc2_.head as Signal;
         while(_loc3_)
         {
            _loc3_.list = null;
            if(_loc3_.stopHandler != null)
            {
               if(!_loc4_)
               {
                  _loc4_ = new Vector.<Signal>();
               }
               _loc4_.push(_loc3_);
            }
            _loc3_ = _loc3_.link_next as Signal;
         }
         for each(_loc3_ in _loc4_)
         {
            _loc3_.stopHandler(_loc3_);
         }
         _loc2_.clear();
         param1.assign(_loc2_);
      }
      
      public static function createRef(param1:Object, param2:Function, param3:uint = 0, param4:Number = 0, param5:Boolean = true) : Signal
      {
         var _loc6_:Signal = null;
         if(!refDict)
         {
            refDict = new Dictionary(true);
         }
         else
         {
            _loc6_ = refDict[param1] as Signal;
         }
         if(!_loc6_)
         {
            _loc6_ = new Signal();
            _loc6_.data = param1;
            _loc6_.stopHandler = onRefStop;
            refDict[param1] = _loc6_;
         }
         _loc6_.useThisArg = param5;
         _loc6_.addType = param3;
         _loc6_.delay = param4;
         _loc6_.handler = param2;
         return _loc6_;
      }
      
      protected static function onRefStop(param1:Signal) : void
      {
         if(refDict)
         {
            delete refDict[param1.data];
         }
         param1.data = null;
         if(param1.useThisArg)
         {
            param1.handler(param1);
         }
         else
         {
            param1.handler();
         }
      }
      
      public static function stopRef(param1:Object) : void
      {
         var _loc2_:Signal = null;
         if(refDict)
         {
            _loc2_ = refDict[param1] as Signal;
            if(_loc2_)
            {
               delete refDict[param1];
               _loc2_.data = null;
               _loc2_.stopWithoutHandler();
            }
         }
      }
      
      public static function createGlobal(param1:Number, param2:Function, param3:Boolean = false, param4:* = null, param5:Number = 0, param6:uint = 0) : void
      {
         var _loc7_:Signal = new Signal(param2,param6,param3);
         _loc7_.duration = param1;
         _loc7_.data = param4;
         var _loc8_:Number = getTimer() / 1000;
         _loc7_.endTime = _loc8_ + param1;
         if(param5 > 0)
         {
            _loc7_.handlerTime = _loc8_;
            _loc7_.delay = param5;
            _loc7_.addDelay();
         }
         else
         {
            _loc7_.handlerTime = _loc7_.endTime;
         }
         _loc7_.stopHandler = onGlobalStop;
         _loc7_.list = globalIterator.getList();
         _loc7_.list.push(_loc7_);
         if(_loc7_.list.head == _loc7_)
         {
            Facade.stage.addEventListener(Event.ENTER_FRAME,onGlobalEnterFrame);
         }
      }
      
      private static function onGlobalEnterFrame(param1:Event) : void
      {
         Signal.updateTime(globalIterator,getTimer() / 1000);
      }
      
      private static function onGlobalStop(param1:Signal) : void
      {
         if(!globalIterator.getList().head)
         {
            Facade.stage.removeEventListener(Event.ENTER_FRAME,onGlobalEnterFrame);
         }
         if(param1.useThisArg)
         {
            param1.handler(param1);
         }
         else
         {
            param1.handler();
         }
      }
      
      public static function delayCall(param1:Number, param2:Function, param3:Array = null, param4:Boolean = false) : void
      {
         var _loc5_:Signal = null;
         if(param4)
         {
            if(param3)
            {
               createGlobal(param1,onDelayCall,true,new VOCallback(param2,param3));
            }
            else
            {
               createGlobal(param1,param2);
            }
         }
         else
         {
            _loc5_ = new Signal();
            _loc5_.stopHandler = onDelayCall;
            _loc5_.data = param3 ? new VOCallback(param2,param3) : param2;
            _loc5_.delayCall(param1);
         }
      }
      
      private static function onDelayCall(param1:Signal) : void
      {
         if(param1.data is VOCallback)
         {
            (param1.data as VOCallback).apply();
         }
         else
         {
            (param1.data as Function).apply();
         }
      }
      
      public static function delayWeakCall(param1:Number, param2:Function, param3:Array = null) : void
      {
         var _loc4_:Signal = null;
         if(param3)
         {
            _loc4_ = new Signal(onDelayCall,0,true);
            _loc4_.data = new VOCallback(param2,param3);
         }
         else
         {
            _loc4_ = new Signal(param2);
         }
         _loc4_.delayCall(param1);
      }
      
      public function run(param1:Number, param2:Number = 0, param3:Boolean = false, param4:Boolean = false) : void
      {
         this.handlerTime = CoreLogic.getSignalTime(param4);
         this.duration = param1;
         if(param2 <= 0 && param1 > 0)
         {
            this.endTime = this.handlerTime + param1;
         }
         else
         {
            this.endTime = param2 < this.handlerTime ? this.handlerTime : param2;
         }
         this.addDelay();
         this.applyList(param4);
         if(param3)
         {
            if(this.useThisArg)
            {
               this.handler(this);
            }
            else
            {
               this.handler();
            }
         }
      }
      
      private function applyList(param1:Boolean) : void
      {
         var _loc2_:LinkedList = param1 ? simulateList : commonList;
         if(_loc2_ != this.list)
         {
            if(this.list)
            {
               this.list.remove(this);
            }
            this.list = _loc2_;
            _loc2_.push(this);
         }
      }
      
      private function addDelay() : void
      {
         var _loc1_:Number = NaN;
         this.tail = this.endTime - this.handlerTime;
         if(this.addType == 0)
         {
            this.handlerTime += this.delay;
         }
         else if(this.addType == ADD_PERIOD)
         {
            if(this.tail <= this.delay)
            {
               this.handlerTime = this.endTime;
               return;
            }
            _loc1_ = this.tail % this.delay;
            this.handlerTime += _loc1_ == 0 ? this.delay : _loc1_;
         }
         else if(this.tail <= 3600)
         {
            ++this.handlerTime;
         }
         else if(this.tail <= 86400)
         {
            _loc1_ = this.tail % 60;
            this.handlerTime += _loc1_ == 0 ? 60 : _loc1_;
         }
         else if(this.tail > 90000)
         {
            _loc1_ = this.tail % 3600;
            this.handlerTime += _loc1_ == 0 ? 3600 : _loc1_;
         }
         if(this.handlerTime > this.endTime)
         {
            this.handlerTime = this.endTime;
         }
      }
      
      public function delayCall(param1:Number, param2:Boolean = false) : void
      {
         this.handlerTime = this.endTime = CoreLogic.getSignalTime(param2) + param1;
         this.applyList(param2);
      }
      
      public function delayEnd(param1:Number, param2:Boolean = false) : void
      {
         this.handlerTime = this.endTime = param1;
         this.applyList(param2);
      }
      
      public function stop() : void
      {
         if(this.list)
         {
            this.list.remove(this);
            this.list = null;
            if(this.stopHandler != null)
            {
               this.stopHandler(this);
            }
         }
      }
      
      public function stopWithoutHandler() : void
      {
         if(this.list)
         {
            this.list.remove(this);
            this.list = null;
         }
      }
      
      public function get passedRate() : Number
      {
         return this.tail >= this.duration ? 0 : 1 - this.tail / this.duration;
      }
   }
}

