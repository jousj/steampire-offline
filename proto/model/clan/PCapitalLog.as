package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PCost;
   import proto.model.PRole;
   
   public class PCapitalLog implements IClientPacket
   {
      
      public var cl_id:String;
      
      public var cl_time:Number;
      
      public var cl_name:String;
      
      public var cl_role:PRole;
      
      public var cl_level:int;
      
      public var cl_costs:Array;
      
      public var cl_kind:PCapitalLogKind;
      
      public var cl_snetwork:String;
      
      public function PCapitalLog()
      {
         super();
      }
      
      public static function create(param1:String, param2:Number, param3:String, param4:PRole, param5:int, param6:Array, param7:PCapitalLogKind, param8:String) : PCapitalLog
      {
         var _loc9_:PCapitalLog = new PCapitalLog();
         _loc9_.cl_id = param1;
         _loc9_.cl_time = param2;
         _loc9_.cl_name = param3;
         _loc9_.cl_role = param4;
         _loc9_.cl_level = param5;
         _loc9_.cl_costs = param6;
         _loc9_.cl_kind = param7;
         _loc9_.cl_snetwork = param8;
         return _loc9_;
      }
      
      public static function read(param1:IDataInput) : PCapitalLog
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:PCapitalLog = new PCapitalLog();
         _loc2_.cl_id = param1.readUTF();
         _loc2_.cl_time = param1.readDouble();
         _loc2_.cl_name = param1.readUTF();
         _loc2_.cl_role = PRole.read(param1);
         _loc2_.cl_level = param1.readInt();
         _loc2_.cl_costs = new Array(param1.readUnsignedShort());
         _loc3_ = 0;
         while(_loc3_ < _loc2_.cl_costs.length)
         {
            _loc2_.cl_costs[_loc3_] = _loc4_ = PCost.read(param1);
            _loc3_++;
         }
         _loc2_.cl_kind = PCapitalLogKind.read(param1);
         _loc2_.cl_snetwork = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         var _loc2_:int = 0;
         param1.writeUTF(this.cl_id);
         param1.writeDouble(this.cl_time);
         param1.writeUTF(this.cl_name);
         this.cl_role.write(param1);
         param1.writeInt(this.cl_level);
         if(this.cl_costs == null)
         {
            param1.writeShort(0);
         }
         else
         {
            param1.writeShort(this.cl_costs.length);
            _loc2_ = 0;
            while(_loc2_ < this.cl_costs.length)
            {
               this.cl_costs[_loc2_].write(param1);
               _loc2_++;
            }
         }
         this.cl_kind.write(param1);
         param1.writeUTF(this.cl_snetwork);
      }
   }
}

