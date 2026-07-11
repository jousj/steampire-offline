package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PGlStartWar implements IClientPacket
   {
      
      public var time:Number;
      
      public var war_id:String;
      
      public var a_name:String;
      
      public var a_id:String;
      
      public var t_name:String;
      
      public var t_id:String;
      
      public function PGlStartWar()
      {
         super();
      }
      
      public static function create(param1:Number, param2:String, param3:String, param4:String, param5:String, param6:String) : PGlStartWar
      {
         var _loc7_:PGlStartWar = new PGlStartWar();
         _loc7_.time = param1;
         _loc7_.war_id = param2;
         _loc7_.a_name = param3;
         _loc7_.a_id = param4;
         _loc7_.t_name = param5;
         _loc7_.t_id = param6;
         return _loc7_;
      }
      
      public static function read(param1:IDataInput) : PGlStartWar
      {
         var _loc2_:PGlStartWar = new PGlStartWar();
         _loc2_.time = param1.readDouble();
         _loc2_.war_id = param1.readUTF();
         _loc2_.a_name = param1.readUTF();
         _loc2_.a_id = param1.readUTF();
         _loc2_.t_name = param1.readUTF();
         _loc2_.t_id = param1.readUTF();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeDouble(this.time);
         param1.writeUTF(this.war_id);
         param1.writeUTF(this.a_name);
         param1.writeUTF(this.a_id);
         param1.writeUTF(this.t_name);
         param1.writeUTF(this.t_id);
      }
   }
}

