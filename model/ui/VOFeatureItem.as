package model.ui
{
   import proto.model.PShopUpgradeHero;
   
   public class VOFeatureItem
   {
      
      public var skinName:String;
      
      public var kind:String;
      
      public var cur:uint;
      
      public var max:uint;
      
      public var suffix:String;
      
      public var preSuffix:String;
      
      public var isCompare:Boolean;
      
      public var trackPeriod:Number = 0;
      
      public var trackEndTime:Number = 0;
      
      public var trackDuration:Number = 0;
      
      public var isOnlySuffix:Boolean;
      
      public var isTime:Boolean;
      
      public var updateData:PShopUpgradeHero;
      
      public var selected:Boolean;
      
      public function VOFeatureItem()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:uint = 0, param4:uint = 0, param5:String = null, param6:Boolean = false) : VOFeatureItem
      {
         var _loc7_:VOFeatureItem = new VOFeatureItem();
         _loc7_.skinName = param1;
         _loc7_.kind = param2;
         _loc7_.cur = param3;
         _loc7_.max = param4;
         _loc7_.suffix = param5;
         _loc7_.isOnlySuffix = param6;
         return _loc7_;
      }
      
      public function setOnlySuffix(param1:String) : void
      {
         this.isOnlySuffix = true;
         this.suffix = param1;
      }
   }
}

