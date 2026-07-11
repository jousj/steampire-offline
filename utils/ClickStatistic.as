package utils
{
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import logic.CoreLogic;
   import model.UserProxy;
   
   public class ClickStatistic
   {
      
      private static var lastTimestamp:Number;
      
      public function ClickStatistic()
      {
         super();
      }
      
      public static function startTime() : void
      {
         lastTimestamp = CoreLogic.serverTime;
      }
      
      public static function request(param1:String) : void
      {
         var _loc2_:Number = CoreLogic.serverTime;
         var _loc3_:UserProxy = Facade.userProxy;
         var _loc4_:String = "http://";
         _loc4_ = _loc4_ + "rstat3.redspell.ru:8089";
         var _loc5_:URLRequest = new URLRequest(_loc4_ + "/behavior?t=" + _loc2_ + "&n=" + _loc3_.base.snetwork + "&u=" + _loc3_.base.account_id + "&l=" + _loc3_.level + "&a=" + param1 + "&d=" + (_loc2_ - lastTimestamp));
         _loc5_.contentType = "application/octet-stream";
         _loc5_.method = URLRequestMethod.GET;
         ULoader.load(_loc5_,null,false);
         lastTimestamp = _loc2_;
      }
      
      public static function clan(param1:uint, param2:Class, param3:String = null) : void
      {
         var _loc4_:String = CommonUtils.getConstantName(param2,param1);
         if(param3)
         {
            _loc4_ = param3 + "_" + _loc4_;
         }
         if(!Facade.userProxy.clan)
         {
            _loc4_ += "_NO";
         }
         request(_loc4_);
      }
   }
}

