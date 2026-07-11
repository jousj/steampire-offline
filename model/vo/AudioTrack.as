package model.vo
{
   import flash.media.Sound;
   
   public class AudioTrack extends Sound
   {
      
      public var kind:String;
      
      public var isComplete:Boolean;
      
      public var count:uint;
      
      public function AudioTrack()
      {
         super();
      }
   }
}

