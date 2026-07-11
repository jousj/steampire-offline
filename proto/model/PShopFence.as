package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PShopFence implements IClientPacket
   {
      
      public var sf_kind:String;
      
      public var sf_level:uint;
      
      public var sf_armor:uint;
      
      public var sf_stamina:uint;
      
      public var sf_price:PCost;
      
      public var sf_townhall_req:uint;
      
      public var sf_info_icons:Array;
      
      public var sf_can_buy:Boolean;
      
      public var sf_model_level:int;
      
      public function PShopFence()
      {
         super();
      }
      
      public static function create(param1:String, param2:uint, param3:uint, param4:uint, param5:PCost, param6:uint, param7:Array, param8:Boolean, param9:int) : PShopFence
      {
         var _loc10_:PShopFence = new PShopFence();
         _loc10_.sf_kind = param1;
         _loc10_.sf_level = param2;
         _loc10_.sf_armor = param3;
         _loc10_.sf_stamina = param4;
         _loc10_.sf_price = param5;
         _loc10_.sf_townhall_req = param6;
         _loc10_.sf_info_icons = param7;
         _loc10_.sf_can_buy = param8;
         _loc10_.sf_model_level = param9;
         return _loc10_;
      }
      
      public static function read(param1:IDataInput) : PShopFence
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PShopFence = new PShopFence();
         _loc2_.sf_kind = param1.readUTF();
         _loc2_.sf_level = param1.readUnsignedByte();
         _loc2_.sf_armor = param1.readUnsignedInt();
         _loc2_.sf_stamina = param1.readUnsignedInt();
         _loc2_.sf_price = PCost.read(param1);
         _loc2_.sf_townhall_req = param1.readUnsignedByte();
         _loc2_.sf_info_icons = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.sf_info_icons.length)
         {
            _loc2_.sf_info_icons[_loc3_] = _loc4_ = param1.readUTF();
            _loc3_++;
         }
         _loc2_.sf_can_buy = param1.readBoolean();
         _loc2_.sf_model_level = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.sf_kind);
         param1.writeByte(this.sf_level);
         param1.writeInt(this.sf_armor);
         param1.writeInt(this.sf_stamina);
         this.sf_price.write(param1);
         param1.writeByte(this.sf_townhall_req);
         if(this.sf_info_icons == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.sf_info_icons.length);
            _loc2_ = 0;
            while(_loc2_ < this.sf_info_icons.length)
            {
               param1.writeUTF(this.sf_info_icons[_loc2_]);
               _loc2_++;
            }
         }
         param1.writeBoolean(this.sf_can_buy);
         param1.writeInt(this.sf_model_level);
      }
   }
}

