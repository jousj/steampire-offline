package game.battle.common
{
   import flash.events.MouseEvent;
   import logic.CoreLogic;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class TimerPanel extends VComponent
   {
      
      private const text:VText = UIFactory.createYellowText(null,VText.CENTER,26,true);
      
      private var replayBox:VBox;
      
      public function TimerPanel()
      {
         super();
         setSize(154,50);
         var _loc1_:Object = {
            "left":20,
            "right":0,
            "vCenter":0,
            "h":44
         };
         add(SkinManager.getEmbed("ResBg",VSkin.STRETCH),_loc1_);
         add(SkinManager.getEmbed("ResFg",VSkin.STRETCH),_loc1_);
         add(SkinManager.getEmbed("ClockIcon",VSkin.CACHE_AS_BITMAP),{
            "w":50,
            "h":50
         });
         add(this.text,{
            "left":46,
            "w":100,
            "vCenter":1
         });
      }
      
      public function set value(param1:String) : void
      {
         this.text.value = param1;
      }
      
      public function set useReplayButtons(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:VButton = null;
         var _loc5_:int = 0;
         if(param1 != Boolean(this.replayBox))
         {
            if(param1)
            {
               this.replayBox = new VBox(null,0);
               _loc2_ = -1;
               for each(_loc3_ in new <String>[RectButton.YELLOW,RectButton.ORANGE,RectButton.YELLOW,RectButton.GREEN])
               {
                  _loc4_ = VButton.createEmbed(_loc3_,VSkin.STRETCH);
                  _loc4_.setSize(40,33);
                  if(_loc2_ == -1)
                  {
                     _loc4_.setIcon(SkinManager.getEmbed("PauseIcon"),{
                        "vCenter":0,
                        "hCenter":0
                     });
                     _loc4_.hint = Lang.getString("pauseBt");
                  }
                  else
                  {
                     _loc5_ = 0;
                     while(_loc5_ <= _loc2_)
                     {
                        _loc4_.add(SkinManager.getEmbed("PlayIcon"),{
                           "vCenter":0,
                           "hCenter":_loc2_ * 4 - _loc5_ * 8
                        });
                        _loc5_++;
                     }
                     _loc4_.hint = "x" + _loc5_;
                  }
                  this.replayBox.add(_loc4_);
                  _loc4_.addClickListener(this.onPlay,++_loc2_);
               }
               (this.replayBox.list[1] as VButton).disabled = true;
               this.replayBox.vCenter = 0;
               this.replayBox.right = 5;
               add(this.replayBox,1);
               layoutW += this.replayBox.measuredWidth - 7;
            }
            else
            {
               remove(this.replayBox);
               this.replayBox = null;
               layoutW = 154;
            }
            syncLayout();
         }
      }
      
      private function onPlay(param1:MouseEvent) : void
      {
         var _loc2_:VButton = null;
         var _loc3_:Number = NaN;
         for each(_loc2_ in this.replayBox.list)
         {
            _loc2_.disabled = _loc2_ == param1.currentTarget;
         }
         _loc3_ = Number((param1.currentTarget as VButton).data);
         if(_loc3_ > 0)
         {
            CoreLogic.simulateFactor = _loc3_;
            CoreLogic.pause = false;
         }
         else
         {
            CoreLogic.pause = true;
         }
      }
   }
}

