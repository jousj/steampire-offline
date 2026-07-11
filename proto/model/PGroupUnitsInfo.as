package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PGroupUnitsInfo implements IClientPacket
   {
      
      public var gui_user_id:String;
      
      public var gui_units_levels:Array;
      
      public var giu_heroes:Array;
      
      public function PGroupUnitsInfo()
      {
         super();
      }
      
      public static function create(param1:String, param2:Array, param3:Array) : PGroupUnitsInfo
      {
         var _loc4_:PGroupUnitsInfo = new PGroupUnitsInfo();
         _loc4_.gui_user_id = param1;
         _loc4_.gui_units_levels = param2;
         _loc4_.giu_heroes = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PGroupUnitsInfo
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PGroupUnitsInfo = new PGroupUnitsInfo();
         _loc2_.gui_user_id = param1.readUTF();
         _loc2_.gui_units_levels = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.gui_units_levels.length)
         {
            _loc2_.gui_units_levels[_loc3_] = _loc4_ = PUnitsLevel.read(param1);
            _loc3_++;
         }
         _loc2_.giu_heroes = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.giu_heroes.length)
         {
            _loc2_.giu_heroes[_loc3_] = _loc4_ = PHero.read(param1);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.gui_user_id);
         if(this.gui_units_levels == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.gui_units_levels.length);
            _loc2_ = 0;
            while(_loc2_ < this.gui_units_levels.length)
            {
               this.gui_units_levels[_loc2_].write(param1);
               _loc2_++;
            }
         }
         if(this.giu_heroes == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.giu_heroes.length);
            _loc2_ = 0;
            while(_loc2_ < this.giu_heroes.length)
            {
               this.giu_heroes[_loc2_].write(param1);
               _loc2_++;
            }
         }
      }
   }
}

