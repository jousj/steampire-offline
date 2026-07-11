package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PJainaEventInfo implements IClientPacket
   {
      
      public var jei_id:int;
      
      public var jei_date_start:Number;
      
      public var jei_date_finish:Number;
      
      public var jei_missions_number:int;
      
      public var jei_bg_kind:String;
      
      public function PJainaEventInfo()
      {
         super();
      }
      
      public static function create(param1:int, param2:Number, param3:Number, param4:int, param5:String) : PJainaEventInfo
      {
         var _loc6_:PJainaEventInfo = new PJainaEventInfo();
         _loc6_.jei_id = param1;
         _loc6_.jei_date_start = param2;
         _loc6_.jei_date_finish = param3;
         _loc6_.jei_missions_number = param4;
         _loc6_.jei_bg_kind = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PJainaEventInfo
      {
         var _loc2_:PJainaEventInfo = new PJainaEventInfo();
         _loc2_.jei_id = param1.readInt();
         _loc2_.jei_date_start = param1.readDouble();
         _loc2_.jei_date_finish = param1.readDouble();
         _loc2_.jei_missions_number = param1.readInt();
         _loc2_.jei_bg_kind = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.jei_id);
         param1.writeDouble(this.jei_date_start);
         param1.writeDouble(this.jei_date_finish);
         param1.writeInt(this.jei_missions_number);
         param1.writeUTF(this.jei_bg_kind);
      }
   }
}

