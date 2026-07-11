package model
{
   import engine.display.AnimClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.getTimer;
   import model.vo.AudioTrack;
   import model.vo.ChannelControl;
   import ui.vbase.SkinManager;
   import utils.CommonUtils;
   
   public class AudioProxy
   {
      
      private const audioHash:Object = {};
      
      private const channelList:Vector.<ChannelControl> = new Vector.<ChannelControl>(32,true);
      
      private const randomHash:Object = {};
      
      public const themeCC:ChannelControl = new ChannelControl();
      
      public const natureCC:ChannelControl = new ChannelControl();
      
      private var themeVolume:Number = 1;
      
      private var audioVolume:Number = 1;
      
      public var isThemeWait:Boolean;
      
      private const mp3FileList:Vector.<String> = new <String>["ambience","battle","battle_ambience","battle_lose","battle_win","begin_building","button_click","cn_air","cn_ballista","cn_ballista_hit","cn_cannon","cn_dwarf_tower","cn_flamethrower","cn_freezing_tower","cn_gauss_cannon","cn_mortar","cn_mortar_hit","cn_steam_tower","cn_tesla_coil","collect_cry","collect_oil","construction_complete","destroy_build","dialog_close","dialog_open","disconnect_gun","explosion","fight_start","group_un_dwarf1","group_un_dwarf2","group_un_fairy1","group_un_fairy2","group_un_motocycle1","group_un_motocycle2","group_un_sniper1","group_un_sniper2","group_un_troll1","group_un_troll2","group_un_warrior1","group_un_warrior2","main","main_new","new_level","quest_complete","shop_buy","start_construction","study_begin","study_finish","un_dwarf1","un_dwarf2","un_dwarf3","un_dwarf4","un_dwarf5","un_dwarf_death1","un_dwarf_death2","un_dwarf_death3","un_dwarf_death4","un_dwarf_death5","un_fairy1","un_fairy2","un_fairy3","un_fairy4","un_fairy5","un_fairy_death1","un_fairy_death2","un_fairy_death3","un_fairy_death4","un_fairy_death5","un_fairy_run","un_golem_run","un_healer1","un_healer2","un_healer3","un_healer4","un_healer5","un_healer_death1","un_healer_death2","un_healer_death3","un_healer_death4","un_healer_death5","un_healer_run","un_hero1","un_hero_death1","un_motocycle1","un_motocycle2","un_motocycle3","un_motocycle4","un_motocycle5","un_motocycle_death1","un_motocycle_death2","un_motocycle_death3","un_motocycle_death4","un_motocycle_death5","un_motocycle_run","un_sniper1","un_sniper2","un_sniper3","un_sniper4","un_sniper5","un_sniper_death1","un_sniper_death2","un_sniper_death3","un_sniper_death4","un_sniper_death5","un_swarm1","un_swarm2","un_swarm3","un_swarm4","un_swarm5","un_swarm_death1","un_swarm_death2","un_swarm_death3","un_swarm_death4","un_swarm_death5","un_swarm_run","un_tank1","un_tank2","un_tank3","un_tank4","un_tank5","un_tank_run","un_troll1","un_troll2","un_troll3","un_troll4","un_troll5","un_troll_death1","un_troll_death2","un_troll_death3","un_troll_death4","un_troll_death5","un_troll_run","un_warrior1","un_warrior2","un_warrior3","un_warrior4","un_warrior5","un_warrior6","un_warrior_death1","un_warrior_death2","un_warrior_death3","un_warrior_death4","un_warrior_death5","un_warrior_run"];
      
      public function AudioProxy()
      {
         super();
         var _loc1_:* = int(this.channelList.length - 1);
         while(_loc1_ >= 0)
         {
            this.channelList[_loc1_] = new ChannelControl();
            _loc1_--;
         }
      }
      
      public function get isAudio() : Boolean
      {
         return this.audioVolume > 0;
      }
      
      public function changeVolume(param1:Number, param2:Boolean) : void
      {
         var _loc3_:ChannelControl = null;
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > 1)
         {
            param1 = 1;
         }
         if(param2)
         {
            if(this.audioVolume != param1)
            {
               this.audioVolume = param1;
               for each(_loc3_ in this.channelList)
               {
                  if(param1 == 0)
                  {
                     _loc3_.stop();
                  }
                  else
                  {
                     _loc3_.volume = param1;
                  }
               }
            }
         }
         else if(this.themeVolume != param1)
         {
            this.natureCC.volume = this.themeCC.volume = this.themeVolume = param1;
            if(param1 == 0)
            {
               this.stopTheme();
            }
            else
            {
               this.startTheme();
            }
         }
      }
      
      public function getVolume(param1:Boolean) : Number
      {
         return param1 ? this.audioVolume : this.themeVolume;
      }
      
      public function clear(param1:Boolean = true) : void
      {
         var _loc2_:ChannelControl = null;
         if(param1)
         {
            this.stopTheme();
         }
         for each(_loc2_ in this.channelList)
         {
            _loc2_.stop();
         }
      }
      
      public function pause(param1:Boolean) : void
      {
         var _loc2_:ChannelControl = null;
         for each(_loc2_ in this.channelList)
         {
            _loc2_.pause(param1);
         }
      }
      
      private function load(param1:String) : AudioTrack
      {
         var track:AudioTrack = null;
         var kind:String = param1;
         if(this.mp3FileList.indexOf(kind) < 0)
         {
            this.audioHash[kind] = true;
            return null;
         }
         track = new AudioTrack();
         track.kind = kind;
         this.audioHash[kind] = track;
         track.addEventListener(Event.COMPLETE,this.onLoad);
         track.addEventListener(IOErrorEvent.IO_ERROR,this.onLoad);
         try
         {
            track.load(new URLRequest(SkinManager.url + "mp3/" + kind + ".mp3"));
         }
         catch(error:Error)
         {
            onLoad(track);
            track = null;
         }
         return track;
      }
      
      private function onLoad(param1:Object) : void
      {
         var _loc2_:Event = null;
         var _loc3_:AudioTrack = null;
         var _loc4_:Boolean = false;
         var _loc5_:ChannelControl = null;
         var _loc6_:String = null;
         if(param1 is Event)
         {
            _loc2_ = param1 as Event;
            _loc3_ = _loc2_.currentTarget as AudioTrack;
            _loc4_ = _loc2_.type == Event.COMPLETE;
         }
         else
         {
            _loc3_ = param1 as AudioTrack;
         }
         _loc3_.removeEventListener(Event.COMPLETE,this.onLoad);
         _loc3_.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoad);
         if(_loc4_)
         {
            _loc3_.isComplete = true;
         }
         else
         {
            for each(_loc5_ in this.channelList)
            {
               if(_loc5_.audioTrack == _loc3_)
               {
                  _loc5_.stop();
               }
            }
            for(_loc6_ in this.audioHash)
            {
               if(this.audioHash[_loc6_] == _loc3_)
               {
                  this.audioHash[_loc6_] = true;
                  break;
               }
            }
         }
      }
      
      public function playTrack(param1:String, param2:Boolean = false, param3:ChannelControl = null) : ChannelControl
      {
         var _loc5_:AudioTrack = null;
         if(param3)
         {
            param3.stop();
         }
         else if(!this.isAudio)
         {
            return null;
         }
         var _loc4_:Object = this.audioHash[param1];
         if(_loc4_ is AudioTrack)
         {
            _loc5_ = _loc4_ as AudioTrack;
         }
         else if(_loc4_ == null)
         {
            _loc5_ = this.load(param1);
         }
         if(_loc5_)
         {
            if(param3)
            {
               param3.play(_loc5_,param2);
               return param3;
            }
            for each(param3 in this.channelList)
            {
               if(!param3.channel)
               {
                  param3.volume = this.audioVolume;
                  param3.play(_loc5_,param2);
                  return param3;
               }
            }
         }
         return null;
      }
      
      public function checkPlayTrack(param1:String, param2:uint = 1) : Boolean
      {
         var _loc3_:* = int(this.channelList.length - 1);
         while(_loc3_ >= 0)
         {
            if(this.channelList[_loc3_].audioTrack)
            {
               if(this.channelList[_loc3_].audioTrack.kind.indexOf(param1) == 0)
               {
                  param2--;
                  if(param2 == 0)
                  {
                     return false;
                  }
               }
            }
            _loc3_--;
         }
         return true;
      }
      
      public function stopTrack(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:uint = this.channelList.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.channelList[_loc4_].audioTrack)
            {
               if(this.channelList[_loc4_].audioTrack.kind.indexOf(param1) == 0)
               {
                  this.channelList[_loc4_].stop();
                  if(param2)
                  {
                     break;
                  }
               }
            }
            _loc4_++;
         }
      }
      
      public function playNum(param1:String, param2:uint, param3:uint = 0, param4:Boolean = false) : ChannelControl
      {
         if(!this.isAudio)
         {
            return null;
         }
         if(param3 > 0)
         {
            if(!this.checkPlayTrack(param1,param3))
            {
               return null;
            }
         }
         if(param2 > 1)
         {
            param2 = CommonUtils.getRangeRandom(1,param2);
         }
         var _loc5_:String = param1 + param2.toString();
         if(param2 > 1 && this.audioHash[_loc5_] === true)
         {
            param1 += "1";
         }
         else
         {
            param1 = _loc5_;
         }
         return this.playTrack(param1,param4);
      }
      
      public function play(param1:String) : void
      {
         if(!this.isAudio)
         {
            return;
         }
         if(this.randomHash.hasOwnProperty(param1))
         {
            if(getTimer() < this.randomHash[param1])
            {
               return;
            }
         }
         this.randomHash[param1] = getTimer() + CommonUtils.getRangeRandom(0,1000);
         this.playTrack(param1);
      }
      
      public function startTheme() : void
      {
         if(this.themeVolume == 0)
         {
            return;
         }
         var _loc1_:Boolean = Facade.isBattle;
         if(_loc1_ && !Facade.battleMediator.isAudioTheme)
         {
            this.stopTheme();
            return;
         }
         if(this.themeCC.audioTrack)
         {
            if(this.themeCC.audioTrack.kind == (_loc1_ ? "fight_start" : "main_new"))
            {
               return;
            }
            this.stopTheme();
         }
         this.playTheme(true,true);
         this.playTheme(false,true);
      }
      
      public function loadTheme() : void
      {
         this.isThemeWait = false;
         this.playTheme(true);
         this.playTheme(false);
      }
      
      private function playTheme(param1:Boolean, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         var _loc4_:ChannelControl = null;
         var _loc5_:Object = null;
         if(param1)
         {
            _loc3_ = Facade.isBattle ? "fight_start" : "main_new";
            _loc4_ = this.themeCC;
         }
         else
         {
            _loc3_ = Facade.isBattle ? "battle_ambience" : "ambience";
            _loc4_ = this.natureCC;
         }
         if(param2 && AnimClip.resourceProxy.loadCur > 0)
         {
            _loc5_ = this.audioHash[_loc3_];
            if(_loc5_ is AudioTrack)
            {
               _loc4_.play(_loc5_ as AudioTrack,true);
            }
            else
            {
               this.isThemeWait = true;
            }
         }
         else if(!_loc4_.channel)
         {
            this.playTrack(_loc3_,true,_loc4_);
         }
      }
      
      private function stopTheme() : void
      {
         this.isThemeWait = false;
         this.themeCC.stop();
         this.natureCC.stop();
      }
      
      public function init() : void
      {
         var _loc1_:Object = Facade.stage.loaderInfo.parameters;
         var _loc2_:Number = Number(_loc1_.sg_sound);
         if(isNaN(_loc2_) || _loc2_ < 0 || _loc2_ > 100)
         {
            _loc2_ = 100;
         }
         this.audioVolume = _loc2_ / 100;
         _loc2_ = Number(_loc1_.sg_music);
         if(isNaN(_loc2_) || _loc2_ < 0 || _loc2_ > 100)
         {
            _loc2_ = 100;
         }
         this.natureCC.volume = this.themeCC.volume = this.themeVolume = _loc2_ / 100;
      }
   }
}

