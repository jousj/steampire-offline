package model.ui
{
   import proto.model.PCost;
   
   public class VOShopItem
   {
      
      public var kind:String;
      
      public var shop:Object;
      
      public var price:PCost;
      
      public var priceList:Array;
      
      public var cur:uint;
      
      public var max:uint;
      
      public var townhall_req:uint;
      
      public var next_townhall_req:uint;
      
      public var duration:uint;
      
      public var order:int;
      
      public var isNew:Boolean;
      
      public function VOShopItem()
      {
         super();
      }
   }
}

