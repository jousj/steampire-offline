package game.battle.raid
{
   import engine.signal.Signal;
   import model.vo.VORaidMember;
   import ui.vbase.VBox;
   
   public class SaySpotPanel extends VBox
   {
      
      private const waitList:Array = [];
      
      private const cacheList:Vector.<SaySpotRenderer> = new Vector.<SaySpotRenderer>();
      
      private const signal:Signal;
      
      private const waitTime:Number = 3.5;
      
      private const countHash:Object = {};
      
      public function SaySpotPanel()
      {
         this.signal = new Signal(this.onHide);
         super(null,0,VBox.VERTICAL | VBox.LEFT);
      }
      
      public function addMessage(param1:VORaidMember, param2:String) : void
      {
         var _loc4_:uint = 0;
         var _loc3_:Boolean = list.length >= 4;
         if(_loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < list.length)
            {
               if(this.countHash[(list[_loc4_] as SaySpotRenderer).cacheId] > 1)
               {
                  this.cacheList.push(list[_loc4_]);
                  list.splice(_loc4_,1);
                  _loc3_ = false;
                  break;
               }
               _loc4_++;
            }
            if(_loc3_)
            {
               _loc4_ = 0;
               while(_loc4_ < list.length)
               {
                  if((list[_loc4_] as SaySpotRenderer).cacheId == param1.id)
                  {
                     this.cacheList.push(list[_loc4_]);
                     list.splice(_loc4_,1);
                     _loc3_ = false;
                     break;
                  }
                  _loc4_++;
               }
            }
         }
         if(_loc3_)
         {
            this.waitList.push(param1,param2);
         }
         else
         {
            this.show(param1,param2);
            if(list.length == 1)
            {
               this.signal.delayCall(this.waitTime);
            }
         }
      }
      
      private function show(param1:VORaidMember, param2:String) : void
      {
         var _loc3_:SaySpotRenderer = null;
         if(this.cacheList.length == 0)
         {
            _loc3_ = new SaySpotRenderer();
         }
         else
         {
            _loc3_ = this.cacheList.pop();
         }
         add(_loc3_);
         _loc3_.update(param1,param2);
         if(this.countHash.hasOwnProperty(param1.id))
         {
            ++this.countHash[param1.id];
         }
         else
         {
            this.countHash[param1.id] = 1;
         }
      }
      
      private function onHide() : void
      {
         --this.countHash[(list[0] as SaySpotRenderer).cacheId];
         this.cacheList.push(list[0]);
         if(this.waitList.length == 0)
         {
            removeAt(0,false);
         }
         else
         {
            list.shift();
            this.show(this.waitList.shift(),this.waitList.shift());
         }
         if(list.length > 0)
         {
            this.signal.delayCall(this.waitTime);
         }
      }
      
      override public function dispose() : void
      {
         var _loc1_:SaySpotRenderer = null;
         this.signal.stop();
         for each(_loc1_ in this.cacheList)
         {
            _loc1_.dispose();
         }
         super.dispose();
      }
   }
}

