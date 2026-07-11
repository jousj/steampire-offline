package model.ui
{
   import proto.model.PShopSpell;
   
   public class VOSpellItem
   {
      
      public var shop:PShopSpell;
      
      public var isSelect:Boolean;
      
      public var isLimit:Boolean;
      
      public var isLock:Boolean;
      
      public var order:uint;
      
      public function VOSpellItem()
      {
         super();
      }
   }
}

