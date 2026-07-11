package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PMithrilEvent implements IClientPacket
   {
      
      public var cnt_by_ter:int;
      
      public var cnt_by_clan:int;
      
      public var cnt_by_capital:int;
      
      public function PMithrilEvent()
      {
         super();
      }
      
      public static function create(param1:int, param2:int, param3:int) : PMithrilEvent
      {
         var _loc4_:PMithrilEvent = new PMithrilEvent();
         _loc4_.cnt_by_ter = param1;
         _loc4_.cnt_by_clan = param2;
         _loc4_.cnt_by_capital = param3;
         return _loc4_;
      }
      
      public static function read(param1:IDataInput) : PMithrilEvent
      {
         var _loc2_:PMithrilEvent = new PMithrilEvent();
         _loc2_.cnt_by_ter = param1.readInt();
         _loc2_.cnt_by_clan = param1.readInt();
         _loc2_.cnt_by_capital = param1.readInt();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeInt(this.cnt_by_ter);
         param1.writeInt(this.cnt_by_clan);
         param1.writeInt(this.cnt_by_capital);
      }
   }
}

