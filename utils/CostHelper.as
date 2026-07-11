package utils
{
   import engine.units.Unit;
   import logic.DialogLogic;
   import model.CommonEvent;
   import proto.model.PCost;
   import proto.model.PCostt;
   import ui.Style;
   import ui.common.MessageDialog;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VSkin;
   
   public class CostHelper
   {
      
      public function CostHelper()
      {
         super();
      }
      
      public static function getString(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint = 1, param6:Boolean = false) : String
      {
         var _loc7_:String = getKind(param1);
         return StringHelper.getTLFImage("lib," + _loc7_,param3,param5,Lang.getString(_loc7_)) + (param6 ? "<span" + Style.redColor + " fontSize=\"" : "<span fontSize=\"") + param4 + "\" breakOpportunity=\"none\">" + StringHelper.getCurrencyValue(param2,true) + "</span>";
      }
      
      public static function get18StringC(param1:PCost, param2:Boolean = false) : String
      {
         return getString(param1.variance,param1.value,22,18,1,param2);
      }
      
      public static function get18String(param1:uint, param2:uint, param3:Boolean = false) : String
      {
         return getString(param1,param2,22,18,1,param3);
      }
      
      public static function getListString(param1:Array, param2:uint, param3:uint, param4:uint, param5:uint = 1, param6:Boolean = false) : String
      {
         var _loc9_:PCost = null;
         var _loc10_:String = null;
         var _loc7_:String = "";
         var _loc8_:uint = 0;
         for each(_loc9_ in param1)
         {
            _loc10_ = getKind(_loc9_.variance);
            _loc7_ += StringHelper.getTLFImage("lib," + _loc10_,param2,param5,Lang.getString(_loc10_),_loc8_ > 0 ? param4 : 0) + (param6 ? "<span" + Style.redColor + " fontSize=\"" : "<span fontSize=\"") + param3 + "\" breakOpportunity=\"none\">" + StringHelper.getCurrencyValue(_loc9_.value,true) + "</span>";
            _loc8_++;
         }
         return _loc7_;
      }
      
      public static function get18ListString(param1:Array, param2:Boolean = false) : String
      {
         return getListString(param1,22,18,3,1,param2);
      }
      
      public static function getClanString(param1:uint, param2:uint, param3:Boolean = false, param4:uint = 22, param5:uint = 18, param6:uint = 1) : String
      {
         return StringHelper.getTLFImage("lib," + CostHelper.getKind(param1,true),param4,param6,Lang.getString(getKind(param1))) + (param3 ? "<span" + Style.redColor + " fontSize=\"" : "<span fontSize=\"") + param5 + "\" breakOpportunity=\"none\">" + StringHelper.getCurrencyValue(param2,true) + "</span>";
      }
      
      public static function getKind(param1:uint, param2:Boolean = false) : String
      {
         switch(param1)
         {
            case PCost.CRYSTAL:
               return param2 ? "CrystalClan" : "Crystal";
            case PCost.OIL:
               return param2 ? "OilClan" : "Oil";
            case PCost.CALL:
               return "Energy";
            case PCost.GOLD:
               return param2 ? "GoldClan" : "Gold";
            case PCost.MITHRIL:
               return param2 ? "MithrilClan" : "Mithril";
            case PCost.EXP:
               return "Exp";
            case PCost.RAR_DRAGON:
               return "rar_dragon";
            case PCost.H_GLORY:
               return "HGlory";
            case PCost.J_GLORY:
               return "JGlory";
            case PCost.TROPHY:
               return "Trophy";
            case PCost.BLUE_PRINT:
               return "Blueprint";
            case PCost.RED_ORE:
               return "OreRed";
            case PCost.GREEN_ORE:
               return "OreGreen";
            case PCost.BLUE_ORE:
               return "OreBlue";
            case PCost.CLAN_POINTS:
               return "ClanEmblemIcon";
            case PCost.RUBY:
               return "Power";
            case PCost.UNKNOWN:
               return "Unknown";
            default:
               throw new Error("getCostKind need variance " + param1);
         }
      }
      
      public static function flightMessage(param1:uint, param2:String, param3:Unit = null) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(param1 == PCost.CRYSTAL)
         {
            _loc4_ = 11265245;
            _loc5_ = 1265558;
         }
         else if(param1 == PCost.OIL)
         {
            _loc4_ = 14204871;
            _loc5_ = 4196651;
         }
         else
         {
            _loc4_ = 16377657;
            _loc5_ = 9056270;
         }
         Facade.mainMediator.flightUnitMessage(param2 + " " + Lang.getString(getKind(param1)),_loc4_,_loc5_,param3);
      }
      
      public static function getVarianceFromType(param1:PCostt) : uint
      {
         var _loc2_:uint = param1.variance;
         switch(_loc2_)
         {
            case PCostt.CRYSTAL:
               return PCost.CRYSTAL;
            case PCostt.OIL:
               return PCost.OIL;
            case PCostt.CALL:
               return PCost.CALL;
            case PCostt.MITHRIL:
               return PCost.MITHRIL;
            case PCostt.GOLD:
               return PCost.GOLD;
            case PCostt.EXP:
               return PCost.EXP;
            case PCostt.H_GLORY:
               return PCost.H_GLORY;
            case PCostt.J_GLORY:
               return PCost.J_GLORY;
            case PCostt.RAR_DRAGON:
               return PCost.RAR_DRAGON;
            case PCostt.TROPHY:
               return PCost.TROPHY;
            case PCostt.BLUE_PRINT:
               return PCost.BLUE_PRINT;
            case PCostt.RED_ORE:
               return PCost.RED_ORE;
            case PCostt.GREEN_ORE:
               return PCost.GREEN_ORE;
            case PCostt.BLUE_ORE:
               return PCost.BLUE_ORE;
            default:
               throw new Error("CostHelper.getVarianceFromType need variance=" + _loc2_);
         }
      }
      
      public static function getEventType(param1:uint) : String
      {
         if(param1 == PCost.CRYSTAL)
         {
            return CommonEvent.CRYSTAL;
         }
         if(param1 == PCost.OIL)
         {
            return CommonEvent.OIL;
         }
         if(param1 == PCost.CALL)
         {
            return CommonEvent.ENERGY;
         }
         if(param1 == PCost.MITHRIL)
         {
            return CommonEvent.MITHRIL;
         }
         if(param1 == PCost.BLUE_PRINT)
         {
            return CommonEvent.BLUEPRINT;
         }
         if(param1 == PCost.H_GLORY)
         {
            return CommonEvent.GLORY;
         }
         if(param1 == PCost.J_GLORY)
         {
            return CommonEvent.J_GLORY;
         }
         if(param1 == PCost.RAR_DRAGON)
         {
            return CommonEvent.RAR_DRAGON;
         }
         if(param1 == PCost.GOLD)
         {
            return CommonEvent.GOLD;
         }
         if(param1 == PCost.RED_ORE || param1 == PCost.GREEN_ORE || param1 == PCost.BLUE_ORE)
         {
            return CommonEvent.ORE;
         }
         return null;
      }
      
      public static function getValueFromList(param1:Array, param2:uint) : uint
      {
         var _loc3_:PCost = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.variance == param2)
            {
               return _loc3_.value;
            }
         }
         return 0;
      }
      
      public static function addCostToList(param1:Array, param2:uint, param3:uint) : void
      {
         var _loc4_:PCost = null;
         for each(_loc4_ in param1)
         {
            if(_loc4_.variance == param2)
            {
               _loc4_.value += param3;
               return;
            }
         }
         param1.push(PCost.create(param2,param3));
      }
      
      public static function mergeCostLists(param1:Array, param2:Array) : Array
      {
         var _loc4_:PCost = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param1)
         {
            _loc3_.push(PCost.create(_loc4_.variance,_loc4_.value));
         }
         for each(_loc4_ in param2)
         {
            addCostToList(_loc3_,_loc4_.variance,_loc4_.value);
         }
         return _loc3_;
      }
      
      public static function getMessageSkin(param1:uint) : VSkin
      {
         var _loc2_:String = null;
         if(param1 == PCost.CRYSTAL)
         {
            _loc2_ = "rs_crystal2";
         }
         else if(param1 == PCost.OIL)
         {
            _loc2_ = "rs_oil2";
         }
         else if(param1 == PCost.CALL)
         {
            _loc2_ = "rs_calls2";
         }
         else if(param1 == PCost.TROPHY)
         {
            _loc2_ = "rs_trophy1";
         }
         else if(param1 == PCost.GOLD)
         {
            _loc2_ = "rs_gold5";
         }
         return _loc2_ ? SkinManager.getExternal(_loc2_,SkinManager.PNG) : null;
      }
      
      public static function showResourceMessage(param1:PCost, param2:String, param3:String = null, param4:int = 0) : void
      {
         var _loc5_:uint = param1.variance;
         var _loc6_:Boolean = _loc5_ == PCost.CRYSTAL || _loc5_ == PCost.OIL || _loc5_ == PCost.GOLD;
         var _loc7_:MessageDialog = new MessageDialog(Lang.getPatternString(param3 ? param3 : (_loc5_ == PCost.TROPHY ? "no_trophy" : "no_clan_resources"),"__COST__",CostHelper.getClanString(_loc5_,param4 > 0 ? uint(param4) : uint(param1.value),true)),Lang.getString(param2),CostHelper.getMessageSkin(_loc5_)).addDelegateRectButton(Lang.getString("closeBt"),null,null,_loc6_ ? RectButton.YELLOW : RectButton.GREEN);
         if(_loc6_)
         {
            _loc7_.addDelegateRectButton(Lang.getString("clan_donate_mobile"),DialogLogic.openDonate);
         }
         Facade.mainMediator.showDialog(_loc7_);
      }
      
      public static function getCostMul(param1:Array, param2:Number) : Array
      {
         var _loc4_:PCost = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param1)
         {
            _loc3_.push(PCost.create(_loc4_.variance,int(param2 * _loc4_.value)));
         }
         return _loc3_;
      }
   }
}

