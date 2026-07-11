package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PWarTopInfo implements IClientPacket
   {
      
      public var wti_id:String;
      
      public var wti_name:String;
      
      public var wti_icon:String;
      
      public var wti_warpoints:int;
      
      public var wti_damage:int;
      
      public var wti_storm:Boolean;
      
      public function PWarTopInfo()
      {
         super();
      }
      
      public static function create(param1:String, param2:String, param3:String, param4:int, param5:int, param6:Boolean) : PWarTopInfo
      {
         var _loc7_:PWarTopInfo = new PWarTopInfo();
         _loc7_.wti_id = param1;
         _loc7_.wti_name = param2;
         _loc7_.wti_icon = param3;
         _loc7_.wti_warpoints = param4;
         _loc7_.wti_damage = param5;
         _loc7_.wti_storm = param6;
         return _loc7_;
      }
      
      public static function read(param1:IDataInput) : PWarTopInfo
      {
         var _loc2_:PWarTopInfo = new PWarTopInfo();
         _loc2_.wti_id = param1.readUTF();
         _loc2_.wti_name = param1.readUTF();
         _loc2_.wti_icon = param1.readUTF();
         _loc2_.wti_warpoints = param1.readInt();
         _loc2_.wti_damage = param1.readInt();
         _loc2_.wti_storm = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeUTF(this.wti_id);
         param1.writeUTF(this.wti_name);
         param1.writeUTF(this.wti_icon);
         param1.writeInt(this.wti_warpoints);
         param1.writeInt(this.wti_damage);
         param1.writeBoolean(this.wti_storm);
      }
   }
}

