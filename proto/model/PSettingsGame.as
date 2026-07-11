package proto.model
{
   import flash.utils.IDataInput;
   import proto.BinaryBuffer;
   import proto.IClientPacket;
   
   public class PSettingsGame implements IClientPacket
   {
      
      public var sg_sound:uint;
      
      public var sg_music:uint;
      
      public var sg_low_quality:Boolean;
      
      public var sg_scale:uint;
      
      public var sg_in_game_alerts:Boolean;
      
      public function PSettingsGame()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:Boolean, param4:uint, param5:Boolean) : PSettingsGame
      {
         var _loc6_:PSettingsGame = new PSettingsGame();
         _loc6_.sg_sound = param1;
         _loc6_.sg_music = param2;
         _loc6_.sg_low_quality = param3;
         _loc6_.sg_scale = param4;
         _loc6_.sg_in_game_alerts = param5;
         return _loc6_;
      }
      
      public static function read(param1:IDataInput) : PSettingsGame
      {
         var _loc2_:PSettingsGame = new PSettingsGame();
         _loc2_.sg_sound = param1.readUnsignedByte();
         _loc2_.sg_music = param1.readUnsignedByte();
         _loc2_.sg_low_quality = param1.readBoolean();
         _loc2_.sg_scale = param1.readUnsignedInt();
         _loc2_.sg_in_game_alerts = param1.readBoolean();
         return _loc2_;
      }
      
      public function write(param1:BinaryBuffer) : void
      {
         param1.writeByte(this.sg_sound);
         param1.writeByte(this.sg_music);
         param1.writeBoolean(this.sg_low_quality);
         param1.writeInt(this.sg_scale);
         param1.writeBoolean(this.sg_in_game_alerts);
      }
   }
}

