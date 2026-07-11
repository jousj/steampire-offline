package utils
{
   import logic.CoreLogic;
   import ui.Style;
   
   public class StringHelper
   {
      
      public function StringHelper()
      {
         super();
      }
      
      public static function addCDATA(param1:String) : String
      {
         return "<![CDATA[" + param1 + "]]>";
      }
      
      public static function getTLFImage(param1:String, param2:uint, param3:uint = 1, param4:String = null, param5:uint = 0) : String
      {
         var _loc6_:String = "<img source=\"" + param1 + "\" width=\"" + param2 + "\" height=\"" + param2 + "\"  breakOpportunity=\"none\"";
         if(param3 > 0)
         {
            _loc6_ += " paddingRight=\"" + param3 + "\"";
         }
         if(param5 > 0)
         {
            _loc6_ += " paddingLeft=\"" + param5 + "\"";
         }
         if(param4)
         {
            _loc6_ += " locale=\"" + param4 + "\"";
         }
         return _loc6_ + "/>";
      }
      
      public static function getRomanFromArab(param1:uint) : String
      {
         var _loc5_:uint = 0;
         var _loc2_:Array = [1000,"M",900,"CM",500,"D",400,"CD",100,"C",90,"XC",50,"L",40,"XL",10,"X",9,"IX",5,"V",4,"IV",1,"I"];
         var _loc3_:String = "";
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = uint(_loc2_[_loc4_]);
            while(param1 >= _loc5_)
            {
               _loc3_ += _loc2_[_loc4_ + 1];
               param1 -= _loc5_;
            }
            _loc4_ += 2;
         }
         return _loc3_;
      }
      
      public static function getTimeDesc(param1:Number, param2:Boolean = false) : String
      {
         if(param1 < 1)
         {
            param1 = 1;
         }
         var _loc3_:int = -1;
         var _loc4_:int = -1;
         var _loc5_:int = -1;
         var _loc6_:int = -1;
         if(param1 >= 86400)
         {
            _loc3_ = param1 / 86400;
            _loc4_ = (param1 - _loc3_ * 86400) / 3600;
         }
         else if(param1 >= 3600)
         {
            _loc4_ = param1 / 3600;
            _loc5_ = (param1 - _loc4_ * 3600) / 60;
         }
         else
         {
            _loc5_ = param1 / 60;
            _loc6_ = param1 % 60;
            if(param2)
            {
               if(_loc6_ > 0 || _loc5_ == 0)
               {
                  _loc5_++;
               }
               _loc6_ = 0;
            }
         }
         var _loc7_:String = "";
         if(_loc3_ > 0)
         {
            _loc7_ += _loc3_ + Lang.getTimeShortString(Lang.DAY);
         }
         if(_loc4_ > 0)
         {
            if(_loc3_ > 0)
            {
               _loc7_ += " ";
            }
            _loc7_ += _loc4_ + Lang.getTimeShortString(Lang.HOUR);
         }
         if(_loc5_ > 0)
         {
            if(_loc4_ > 0)
            {
               _loc7_ += " ";
            }
            _loc7_ += _loc5_ + Lang.getTimeShortString(Lang.MINUTE);
         }
         if(_loc6_ > 0)
         {
            if(_loc5_ > 0)
            {
               _loc7_ += " ";
            }
            _loc7_ += _loc6_ + Lang.getTimeShortString(Lang.SECOND);
         }
         return _loc7_;
      }
      
      public static function getTimeFormat(param1:int, param2:Boolean = false) : String
      {
         if(param2)
         {
            param1 /= 1000;
         }
         var _loc3_:uint = param1 / 3600;
         var _loc4_:String = "";
         if(_loc3_ > 0)
         {
            if(_loc3_ <= 9)
            {
               _loc4_ = "0";
            }
            _loc4_ += _loc3_ + ":";
            param1 -= _loc3_ * 3600;
         }
         _loc3_ = param1 / 60;
         if(_loc3_ > 0)
         {
            if(_loc3_ <= 9)
            {
               _loc4_ += "0";
            }
            _loc4_ += _loc3_;
            param1 -= _loc3_ * 60;
         }
         else
         {
            _loc4_ += "00";
         }
         _loc4_ += ":";
         if(param1 <= 9)
         {
            _loc4_ += "0";
         }
         return _loc4_ + param1;
      }
      
      public static function getDateDesc(param1:Object, param2:Boolean = true, param3:Boolean = true) : String
      {
         var _loc4_:String = "";
         var _loc5_:Date = (param1 is Date ? param1 : CoreLogic.getDate(Number(param1))) as Date;
         if(param2 || !param3)
         {
            if(_loc5_.date < 10)
            {
               _loc4_ += "0";
            }
            _loc4_ += _loc5_.date + ".";
            if(_loc5_.month < 9)
            {
               _loc4_ += "0";
            }
            _loc4_ += _loc5_.month + 1 + "." + _loc5_.fullYear % 100;
         }
         if(param3)
         {
            if(_loc4_.length > 0)
            {
               _loc4_ += " ";
            }
            if(_loc5_.hours < 10)
            {
               _loc4_ += "0";
            }
            _loc4_ += _loc5_.hours + ":";
            if(_loc5_.minutes < 10)
            {
               _loc4_ += "0";
            }
            _loc4_ += _loc5_.minutes.toString();
         }
         return _loc4_;
      }
      
      public static function getUnitName(param1:String, param2:uint, param3:uint = 22, param4:String = null, param5:Boolean = true) : String
      {
         if(param4 == null)
         {
            param4 = Style.darkKhakiColor;
         }
         if(param2 == 0)
         {
            return "<span" + param4 + ">" + (param5 ? Lang.getString(param1) : addCDATA(param1)) + "</span>";
         }
         if(param5)
         {
            param1 = Lang.getString(param1);
         }
         var _loc6_:int = param1.lastIndexOf(" ");
         if(_loc6_ > 0)
         {
            _loc6_++;
            param1 = "<span" + param4 + ">" + param1.substr(0,_loc6_) + "</span><span breakOpportunity=\"none\"" + param4 + ">" + param1.substr(_loc6_);
         }
         else
         {
            param1 = "<span breakOpportunity=\"none\"" + param4 + ">" + param1;
         }
         return param1 + " </span>" + getTLFImage("lib,Exp",param3) + "<span " + param4 + ">" + param2.toString() + "</span>";
      }
      
      public static function trim(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         if(param1.length > 0)
         {
            _loc2_ = 0;
            while(param1.charCodeAt(_loc2_) == 32)
            {
               _loc2_++;
            }
            _loc3_ = int(param1.length - 1);
            while(param1.charCodeAt(_loc3_) == 32)
            {
               _loc3_--;
            }
            if(_loc3_ >= _loc2_)
            {
               return param1.substring(_loc2_,_loc3_ + 1);
            }
         }
         return null;
      }
      
      public static function getCurrencyValue(param1:int, param2:Boolean = false, param3:Boolean = false) : String
      {
         var _loc6_:String = null;
         if(param1 < 0)
         {
            param3 = true;
            param1 = -param1;
         }
         var _loc4_:String = param1.toString();
         var _loc5_:int = _loc4_.length - 3;
         if(_loc5_ > 0)
         {
            _loc6_ = "";
            while(_loc5_ > 0)
            {
               _loc6_ = (param2 ? " " : " ") + _loc4_.substr(_loc5_,3) + _loc6_;
               _loc5_ -= 3;
            }
            _loc5_ += 3;
            _loc4_ = _loc5_ > 0 ? _loc4_.substr(0,_loc5_) + _loc6_ : _loc6_;
         }
         return param3 && param1 > 0 ? "-" + _loc4_ : _loc4_;
      }
   }
}

