package model.vo
{
   import flash.utils.ByteArray;
   
   public class PacketDesc
   {
      
      public var id:uint;
      
      public var rFamily:uint;
      
      public var rSubfamily:uint;
      
      public var ba:ByteArray;
      
      public var logic:Function;
      
      public var logicArgs:Array;
      
      public var aFamily:uint;
      
      public var aSubfamily:uint;
      
      public var log:String;
      
      public var request_id:Number;
      
      public function PacketDesc()
      {
         super();
      }
      
      public function clear() : void
      {
         this.ba = null;
         this.logic = null;
         this.logicArgs = null;
         this.log = null;
      }
   }
}

