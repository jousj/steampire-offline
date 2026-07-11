package model.vo
{
   import engine.signal.Signal;
   import flash.events.Event;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   
   public class ChannelControl
   {
      
      public var audioTrack:AudioTrack;
      
      public var channel:SoundChannel;
      
      private var soundTransform:SoundTransform;
      
      private var fadeSignal:Signal;
      
      private var isListener:Boolean;
      
      private var pauseTime:Number;
      
      public function ChannelControl()
      {
         super();
      }
      
      public function set volume(param1:Number) : void
      {
         if(!this.soundTransform)
         {
            this.soundTransform = new SoundTransform(param1);
         }
         else
         {
            this.soundTransform.volume = param1;
         }
         if(this.channel)
         {
            this.channel.soundTransform = this.soundTransform;
         }
      }
      
      public function get volume() : Number
      {
         return this.channel ? this.channel.soundTransform.volume : 0;
      }
      
      public function pause(param1:Boolean) : void
      {
         var value:Boolean = param1;
         if(this.channel)
         {
            if(value)
            {
               this.pauseTime = this.channel.position;
               this.channel.stop();
            }
            else
            {
               if(this.isListener)
               {
                  this.channel.removeEventListener(Event.SOUND_COMPLETE,this.onTrackComplete);
               }
               try
               {
                  this.channel = this.audioTrack.play(this.pauseTime,this.isListener ? 0 : int.MAX_VALUE,this.soundTransform);
                  if(this.isListener)
                  {
                     this.channel.addEventListener(Event.SOUND_COMPLETE,this.onTrackComplete);
                  }
               }
               catch(error:Error)
               {
                  onTrackComplete();
               }
            }
         }
      }
      
      public function play(param1:AudioTrack, param2:Boolean) : void
      {
         var track:AudioTrack = param1;
         var isLoop:Boolean = param2;
         if(this.channel)
         {
            this.channel.stop();
            this.onTrackComplete();
         }
         this.audioTrack = track;
         ++this.audioTrack.count;
         try
         {
            this.channel = this.audioTrack.play(0,isLoop ? int.MAX_VALUE : 0,this.soundTransform);
            if(!isLoop)
            {
               this.isListener = true;
               this.channel.addEventListener(Event.SOUND_COMPLETE,this.onTrackComplete);
            }
         }
         catch(error:Error)
         {
            onTrackComplete();
         }
      }
      
      private function onTrackComplete(param1:Event = null) : void
      {
         if(this.channel)
         {
            if(this.isListener)
            {
               this.isListener = false;
               this.channel.removeEventListener(Event.SOUND_COMPLETE,this.onTrackComplete);
            }
            this.channel = null;
         }
         if(this.audioTrack)
         {
            --this.audioTrack.count;
            this.audioTrack = null;
         }
         if(this.fadeSignal)
         {
            this.fadeSignal.stop();
            this.volume = this.fadeSignal.data;
            this.fadeSignal = null;
         }
      }
      
      public function fade(param1:Number = 3) : void
      {
         if(Boolean(this.channel) && !this.fadeSignal)
         {
            this.fadeSignal = new Signal(this.onFadeSignal);
            this.fadeSignal.delay = 0.1;
            this.fadeSignal.data = this.volume;
            this.fadeSignal.run(param1);
         }
      }
      
      private function onFadeSignal() : void
      {
         var _loc1_:Number = 1 - this.fadeSignal.passedRate;
         if(_loc1_ == 0)
         {
            this.stop();
         }
         else
         {
            this.volume = this.fadeSignal.data * _loc1_;
         }
      }
      
      public function stop() : void
      {
         if(this.channel)
         {
            this.channel.stop();
            this.onTrackComplete();
         }
      }
   }
}

