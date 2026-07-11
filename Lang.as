package
{
   import utils.CommonUtils;
   
   public class Lang
   {
      
      public static const RU:String = "RU";
      
      public static const EN:String = "EN";
      
      public static const DE:String = "DE";
      
      public static const FR:String = "FR";
      
      public static const PL:String = "PL";
      
      public static const ZH:String = "ZH";
      
      public static const ES:String = "ES";
      
      public static const LT:String = "LT";
      
      public static const LV:String = "LV";
      
      public static const IT:String = "IT";
      
      public static const JA:String = "JA";
      
      public static const VI:String = "VI";
      
      public static const PT:String = "PT";
      
      public static const KO:String = "KO";
      
      public static const TR:String = "TR";
      
      public static const MINUTE:uint = 0;
      
      public static const HOUR:uint = 1;
      
      public static const DAY:uint = 2;
      
      public static const SECOND:uint = 3;
      
      public static var lexicon:Object = {};
      
      public static var _locale:String = Lang.RU;
      
      public static var useAsap:Boolean = false;
      
      public function Lang()
      {
         super();
      }
      
      public static function getString(param1:String) : String
      {
         return lexicon.hasOwnProperty(param1) ? lexicon[param1] : "#" + param1;
      }
      
      public static function getNullString(param1:String) : String
      {
         return lexicon.hasOwnProperty(param1) ? lexicon[param1] : null;
      }
      
      public static function getRangedString(param1:String, param2:uint = 1, param3:uint = 10, param4:Object = null) : String
      {
         var _loc6_:String = null;
         var _loc5_:uint = CommonUtils.getRangeRandom(param2,param3);
         while(!_loc6_)
         {
            _loc6_ = param4 ? getNullReplaceString(param1 + _loc5_,param4) : getNullString(param1 + _loc5_);
            if(--_loc5_ < 1)
            {
               break;
            }
         }
         return _loc6_;
      }
      
      public static function getStringOrDefault(param1:String, param2:String) : String
      {
         return lexicon.hasOwnProperty(param1) ? lexicon[param1] : lexicon[param2];
      }
      
      public static function getReplaceString(param1:String, param2:Object) : String
      {
         var _loc4_:String = null;
         var _loc3_:String = lexicon[param1];
         if(_loc3_ == null)
         {
            return "#" + param1;
         }
         for(_loc4_ in param2)
         {
            _loc3_ = _loc3_.replace(_loc4_,param2[_loc4_]);
         }
         return _loc3_;
      }
      
      public static function getNullReplaceString(param1:String, param2:Object) : String
      {
         var _loc4_:String = null;
         var _loc3_:String = lexicon[param1];
         if(_loc3_)
         {
            for(_loc4_ in param2)
            {
               _loc3_ = _loc3_.replace(_loc4_,param2[_loc4_]);
            }
         }
         return _loc3_;
      }
      
      public static function getPatternString(param1:String, param2:String, param3:String, param4:Boolean = false) : String
      {
         return lexicon.hasOwnProperty(param1) ? String(lexicon[param1]).replace(param2,param4 ? getString(param3) : param3) : "#" + param1;
      }
      
      public static function getRUNumeralWord(param1:String, param2:uint, param3:Array) : String
      {
         var _loc4_:String = param1;
         if(param3 == null)
         {
            return _loc4_;
         }
         param2 = Math.abs(param2) % 100;
         var _loc5_:uint = 2;
         if(param2 < 10 || param2 > 20)
         {
            param2 %= 10;
            if(param2 == 1)
            {
               _loc5_ = 0;
            }
            else if(param2 >= 2 && param2 <= 4)
            {
               _loc5_ = 1;
            }
         }
         return _loc4_ + param3[_loc5_];
      }
      
      public static function getTimeString(param1:uint, param2:uint) : String
      {
         switch(locale)
         {
            case RU:
               switch(param2)
               {
                  case HOUR:
                     return getRUNumeralWord("час",param1,["","а","ов"]);
                  case SECOND:
                     return getRUNumeralWord("секунд",param1,["а","ы",""]);
                  case DAY:
                     return getRUNumeralWord("д",param1,["ень","ня","ней"]);
                  default:
                     return getRUNumeralWord("минут",param1,["а","ы",""]);
               }
               break;
            case EN:
               return ["minute","hour","day","second"][param2] + (param1 > 1 ? "s" : "");
            case FR:
               return ["minute","heure","jour","seconde"][param2] + (param1 > 1 ? "s" : "");
            case DE:
               return ["minute","stunde","tag","sekunde"][param2] + (param1 > 1 ? (param2 == DAY ? "e" : "n") : "");
            case PL:
               if(param2 == DAY)
               {
                  return param1 > 1 ? "dni" : "dzień";
               }
               return ["minut","godzin",null,"sekund"][param2] + (param1 > 1 ? "y" : "a");
               break;
            case ES:
               return ["minuto","hora","dìa","segundo"][param2] + (param1 > 1 ? "s" : "");
            case ZH:
               return ["分鐘","小時","日","秒"][param2];
            case LT:
               return ["min.","val.","d.","s."][param2];
            case LV:
               return ["minūte","stunda","diena","sekunde"][param2] + (param1 > 1 ? "s" : "");
            case IT:
               return ["minuti","ore","giorni","secondi"][param2];
            case JA:
               return ["分","時間","日","秒"][param2];
            case VI:
               return ["phút","giờ","ngày","giây"][param2];
            case PT:
               return ["minuto","hora","dia","segundo"][param2] + (param1 > 1 ? "s" : "");
            case KO:
               return ["분","시간","일","초"][param2];
            case TR:
               return ["dakika","saat","gün","saniye"][param2];
            default:
               return "";
         }
      }
      
      public static function getTimeShortString(param1:uint) : String
      {
         return locale != ZH && locale != JA && locale != KO ? getTimeString(1,param1).substr(0,1) : getTimeString(1,param1);
      }
      
      public static function getCurrency(param1:uint) : String
      {
         var _loc2_:String = null;
         switch(Facade.socialnet)
         {
            case Facade.VKONTAKTE:
               _loc2_ = getRUNumeralWord("голос",param1,["","а","ов"]);
               break;
            case Facade.ODNOKLASSNIKI:
               _loc2_ = "ОК";
               break;
            case Facade.MOYMIR:
               _loc2_ = getRUNumeralWord("МЭЙЛИК",param1,["","А","ОВ"]);
               break;
            case Facade.EXE:
               _loc2_ = getRUNumeralWord("рубл",param1,["ь","я","ей"]);
               break;
            default:
               _loc2_ = "?";
         }
         return param1 + " " + _loc2_;
      }
      
      public static function set locale(param1:String) : void
      {
         useAsap = param1 == ES;
         _locale = param1;
      }
      
      public static function get locale() : String
      {
         return _locale;
      }
   }
}

