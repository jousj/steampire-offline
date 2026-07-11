package proto.game.family_0005
{
   import flash.utils.IDataInput;
   import proto.model.PDict;
   import proto.model.PUser;
   
   public class Packet_0005_02
   {
      
      public var dict:PDict;
      
      public var me:PUser;
      
      public function Packet_0005_02(param1:IDataInput)
      {
         super();
         this.dict = PDict.read(param1);
         this.me = PUser.read(param1);
      }
   }
}

