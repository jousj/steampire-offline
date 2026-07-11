package proto.model.clan
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   import proto.model.PRole;
   import proto.model.PUserBase;
   
   public class PMember implements IClientPacket
   {
      
      public var user_base:PUserBase;
      
      public var role:PRole;
      
      public var sended:PSended;
      
      public var full_donate_oil:int;
      
      public var full_donate_crystal:int;
      
      public var full_donate_gold:int;
      
      public var full_donate_call:int;
      
      public var territory_regent:String;
      
      public function PMember()
      {
         super();
      }
      
      public static function create(param1:PUserBase, param2:PRole, param3:PSended, param4:int, param5:int, param6:int, param7:int, param8:String) : PMember
      {
         var _loc9_:PMember = new PMember();
         _loc9_.user_base = param1;
         _loc9_.role = param2;
         _loc9_.sended = param3;
         _loc9_.full_donate_oil = param4;
         _loc9_.full_donate_crystal = param5;
         _loc9_.full_donate_gold = param6;
         _loc9_.full_donate_call = param7;
         _loc9_.territory_regent = param8;
         return _loc9_;
      }
      
      public static function read(param1:IDataInput) : PMember
      {
         var _loc2_:PMember = new PMember();
         _loc2_.user_base = PUserBase.read(param1);
         _loc2_.role = PRole.read(param1);
         _loc2_.sended = PSended.read(param1);
         _loc2_.full_donate_oil = param1.readInt();
         _loc2_.full_donate_crystal = param1.readInt();
         _loc2_.full_donate_gold = param1.readInt();
         _loc2_.full_donate_call = param1.readInt();
         if(param1.readUnsignedByte() == 1)
         {
            _loc2_.territory_regent = param1.readUTF();
         }
         else
         {
            _loc2_.territory_regent = null;
         }
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         this.user_base.write(param1);
         this.role.write(param1);
         this.sended.write(param1);
         param1.writeInt(this.full_donate_oil);
         param1.writeInt(this.full_donate_crystal);
         param1.writeInt(this.full_donate_gold);
         param1.writeInt(this.full_donate_call);
         if(this.territory_regent != null)
         {
            param1.writeByte(1);
            param1.writeUTF(this.territory_regent);
         }
         else
         {
            param1.writeByte(0);
         }
      }
   }
}

