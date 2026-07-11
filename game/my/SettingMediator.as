package game.my
{
   import engine.display.AnimClip;
   import engine.display.RBitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   import game.common.DialogMediator;
   import logic.UnitFactory;
   import proto.game.family_0005.Packet_0005_07;
   import proto.model.PSettingsGame;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   
   public class SettingMediator extends DialogMediator
   {
      
      public const dialog:SettingDialog = new SettingDialog();
      
      private var oldAudioVolume:uint;
      
      private var oldThemeVolume:uint;
      
      private var isSave:Boolean;
      
      public function SettingMediator()
      {
         super();
      }
      
      public static function save() : void
      {
         Facade.protoProxy.request(new Packet_0005_07(PSettingsGame.create(Facade.audioProxy.getVolume(true) * 100,Facade.audioProxy.getVolume(false) * 100,!Facade.isNormalQuality,Math.round(Facade.board.scaleX * 100),false)));
      }
      
      override public function onAdd() : BaseDialog
      {
         this.dialog.audioBar.value = this.oldAudioVolume = Facade.audioProxy.getVolume(true) * 100;
         this.dialog.audioBar.addListener(VEvent.SCROLL,this.onVolume);
         this.dialog.themeBar.value = this.oldThemeVolume = Facade.audioProxy.getVolume(false) * 100;
         this.dialog.themeBar.addListener(VEvent.SCROLL,this.onVolume);
         this.dialog.qualityCb.checked = !Facade.isNormalQuality;
         this.dialog.saveBt.addClickListener(this.onSave);
         this.dialog.closeBt.addListener(MouseEvent.CLICK,this.onSave,null,1);
         return this.dialog;
      }
      
      private function onSave(param1:MouseEvent) : void
      {
         var _loc5_:RBitmap = null;
         this.isSave = true;
         var _loc2_:uint = this.dialog.audioBar.value;
         var _loc3_:uint = this.dialog.themeBar.value;
         var _loc4_:Boolean = !this.dialog.qualityCb.checked;
         if(Facade.isNormalQuality != _loc4_ || this.oldAudioVolume != _loc2_ || this.oldThemeVolume != _loc3_)
         {
            Facade.protoProxy.request(new Packet_0005_07(PSettingsGame.create(_loc2_,_loc3_,!_loc4_,Math.round(Facade.board.scaleX * 100),false)));
         }
         if(Facade.isNormalQuality != _loc4_)
         {
            Facade.setNormalQuality(_loc4_);
            for each(_loc5_ in AnimClip.resourceProxy.bitmapPool)
            {
               _loc5_.smoothing = _loc4_;
            }
            this.setSmoothing(Facade.board,_loc4_);
            if(Facade.isMyMap)
            {
               if(_loc4_)
               {
                  UnitFactory.useSoldierPatrol();
               }
               else
               {
                  UnitFactory.clearPatrol();
               }
            }
         }
         if(param1.currentTarget == this.dialog.saveBt)
         {
            this.dialog.close();
         }
      }
      
      override public function onRemove() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this.isSave)
         {
            _loc1_ = this.dialog.audioBar.value;
            if(this.oldAudioVolume != _loc1_)
            {
               Facade.audioProxy.changeVolume(this.oldAudioVolume / 100,true);
            }
            _loc2_ = this.dialog.themeBar.value;
            if(this.oldThemeVolume != _loc2_)
            {
               Facade.audioProxy.changeVolume(this.oldThemeVolume / 100,false);
            }
         }
      }
      
      private function setSmoothing(param1:DisplayObjectContainer, param2:Boolean) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:* = int(param1.numChildren - 1);
         while(_loc3_ >= 0)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is RBitmap)
            {
               (_loc4_ as RBitmap).smoothing = param2;
            }
            else if(_loc4_ is DisplayObjectContainer)
            {
               this.setSmoothing(_loc4_ as DisplayObjectContainer,param2);
            }
            _loc3_--;
         }
      }
      
      private function onVolume(param1:VEvent) : void
      {
         Facade.audioProxy.changeVolume(param1.data / 100,param1.currentTarget == this.dialog.audioBar);
      }
   }
}

