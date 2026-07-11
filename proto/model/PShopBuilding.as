package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopBuilding implements IClientPacket
   {
      
      public var sb_kind:String;
      
      public var sb_level:uint;
      
      public var sb_armor:uint;
      
      public var sb_stamina:uint;
      
      public var sb_price:Array;
      
      public var sb_upgrade_time:Number;
      
      public var sb_townhall_req:uint;
      
      public var sb_btype:PBtype;
      
      public var sb_can_buy:Boolean;
      
      public var sb_price_list:Array;
      
      public var sb_requirements:Array;
      
      public var sb_model_level:int;
      
      public function PShopBuilding()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:uint, param4:uint, param5:Array, param6:Number, param7:uint, param8:PBtype, param9:Boolean, param10:Array, param11:Array, param12:int) : PShopBuilding
      {
         var _loc13_:PShopBuilding = new PShopBuilding();
         _loc13_.sb_kind = param1;
         _loc13_.sb_level = param2;
         _loc13_.sb_armor = param3;
         _loc13_.sb_stamina = param4;
         _loc13_.sb_price = param5;
         _loc13_.sb_upgrade_time = param6;
         _loc13_.sb_townhall_req = param7;
         _loc13_.sb_btype = param8;
         _loc13_.sb_can_buy = param9;
         _loc13_.sb_price_list = param10;
         _loc13_.sb_requirements = param11;
         _loc13_.sb_model_level = param12;
         return _loc13_;
      }
      
      public static function read(param1:IDataInput) : PShopBuilding
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc2_:PShopBuilding = new PShopBuilding();
         _loc2_.sb_kind = param1.readUTF();
         _loc2_.sb_level = param1.readUnsignedInt();
         _loc2_.sb_armor = param1.readUnsignedInt();
         _loc2_.sb_stamina = param1.readUnsignedInt();
         _loc2_.sb_price = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.sb_price.length)
         {
            _loc2_.sb_price[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.sb_upgrade_time = param1.readDouble();
         _loc2_.sb_townhall_req = param1.readUnsignedByte();
         _loc2_.sb_btype = PBtype.read(param1);
         _loc2_.sb_can_buy = param1.readBoolean();
         _loc2_.sb_price_list = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.sb_price_list.length)
         {
            _loc2_.sb_price_list[_loc3_] = _loc4_ = new Array(param1.readUnsignedShort());
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc4_[_loc5_] = _loc6_ = PCost.read(param1);
               _loc5_++;
            }
            _loc3_++;
         }
         _loc2_.sb_requirements = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.sb_requirements.length)
         {
            _loc2_.sb_requirements[_loc3_] = _loc4_ = PBuildRequierement.read(param1);
            _loc3_++;
         }
         _loc2_.sb_model_level = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         param1.writeUTF(this.sb_kind);
         param1.writeInt(this.sb_level);
         param1.writeInt(this.sb_armor);
         param1.writeInt(this.sb_stamina);
         if(this.sb_price == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.sb_price.length);
            _loc2_ = 0;
            while(_loc2_ < this.sb_price.length)
            {
               this.sb_price[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeDouble(this.sb_upgrade_time);
         param1.writeByte(this.sb_townhall_req);
         this.sb_btype.write(param1);
         param1.writeBoolean(this.sb_can_buy);
         if(this.sb_price_list == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.sb_price_list.length);
            _loc2_ = 0;
            while(_loc2_ < this.sb_price_list.length)
            {
               if(this.sb_price_list[_loc2_] == null)
               {
                  param1.writeShort(0);
               }
               else
               {
                  param1.writeShort(this.sb_price_list[_loc2_].length);
                  _loc2_ = 0;
                  while(_loc2_ < this.sb_price_list[_loc2_].length)
                  {
                     this.sb_price_list[_loc2_][_loc2_].write(param1);
                     _loc2_++;
                  }
               }
               _loc2_++;
            }
         }
         if(this.sb_requirements == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.sb_requirements.length);
            _loc2_ = 0;
            while(_loc2_ < this.sb_requirements.length)
            {
               this.sb_requirements[_loc2_].write(param1);
               _loc2_++;
            }
         }
         param1.writeInt(this.sb_model_level);
      }
   }
}

