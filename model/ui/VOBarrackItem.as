package model.ui
{
   import proto.model.PShopUnit;
   import proto.model.PUnitsPackInfo;
   import ui.vbase.VOGridFilterItem;
   
   public class VOBarrackItem extends VOGridFilterItem
   {
      
      public var specialPack:PUnitsPackInfo;
      
      public var shop:PShopUnit;
      
      public var isResearchLock:Boolean;
      
      public var space:int;
      
      public var isResearchRun:Boolean;
      
      public var flag:Boolean;
      
      public var count:uint;
      
      public function VOBarrackItem()
      {
         super();
      }
   }
}

