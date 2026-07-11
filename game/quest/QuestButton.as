package game.quest
{
   import engine.signal.Signal;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import model.vo.VOQuest;
   import ui.Style;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class QuestButton extends VButton
   {
      
      private const countText:VText = new VText(null,VText.CONTAIN);
      
      private var statusSkin:VSkin;
      
      private var statusId:uint;
      
      private var signal:Signal;
      
      public function QuestButton()
      {
         super();
         setSize(64,64);
         skin = SkinManager.getPack(UIFactory.OFFER_PACK,"QuestBtBg",VSkin.STRETCH);
         addStretch(skin);
         setIcon(new VSkin(VSkin.CACHE_AS_BITMAP),{
            "w":64,
            "h":64,
            "vCenter":0,
            "hCenter":0
         });
         Style.applyDefaultFormat(this.countText,18,true);
         add(this.countText,{
            "hCenter":0,
            "bottom":5,
            "maxW":75
         });
         hint = this.getHint;
      }
      
      private function useSignal(param1:Number, param2:Function) : void
      {
         if(!this.signal)
         {
            this.signal = new Signal();
         }
         this.signal.handler = param2;
         this.signal.delayCall(param1);
      }
      
      public function useNewStatus() : void
      {
         if(this.statusId != 1)
         {
            this.statusId = 1;
            this.addClip("NewQuestClip");
            addListener(MouseEvent.ROLL_OVER,this.onRoll);
            this.useSignal(3,this.stopClip);
            this.checkQuestCount();
         }
      }
      
      public function useProgressStatus(param1:String) : void
      {
         var _loc2_:VText = new VText(param1,VText.CONTAIN_CENTER,9328397,22);
         Style.applyShadowFilter(_loc2_,16771004,3415810,2,90);
         this.addClip("ProgressQuestClip",_loc2_);
         this.useSignal(3,this.removeClip);
         this.checkQuestCount();
      }
      
      public function useCollectStatus(param1:Boolean = true) : void
      {
         if(this.statusId != 2)
         {
            if(this.statusSkin)
            {
               this.removeClip();
            }
            this.statusId = 2;
            this.addClip("CollectQuestClip");
            this.useSignal(3,param1 ? this.stopClip : this.removeClip);
            this.countText.value = "";
         }
      }
      
      private function addClip(param1:String, param2:VText = null) : void
      {
         var _loc3_:Sprite = null;
         if(this.statusSkin)
         {
            this.removeClip();
         }
         this.statusSkin = SkinManager.getEmbed(param1,VSkin.PLAY_MOVIE_CLIP);
         if(param2)
         {
            _loc3_ = this.statusSkin.content as Sprite;
            if(Boolean(_loc3_) && _loc3_.numChildren > 0)
            {
               _loc3_ = _loc3_.getChildAt(0) as Sprite;
               if(_loc3_)
               {
                  param2.layoutW = 76;
                  SkinManager.addInsideContainer(_loc3_,"target_info_box",param2);
               }
            }
         }
         add(this.statusSkin,{
            "right":6 - this.statusSkin.measuredWidth,
            "vCenter":0
         });
      }
      
      public function removeClip() : void
      {
         if(this.statusId > 0)
         {
            if(this.statusId == 1)
            {
               removeListener(MouseEvent.ROLL_OVER,this.onRoll);
            }
            this.statusId = 0;
         }
         if(this.statusSkin)
         {
            remove(this.statusSkin);
            this.statusSkin = null;
         }
      }
      
      private function stopClip() : void
      {
         if(this.statusSkin)
         {
            this.statusSkin.contentPlay(false);
         }
      }
      
      public function loopClip() : void
      {
         if(this.statusSkin)
         {
            if(this.signal)
            {
               this.signal.stopWithoutHandler();
            }
            this.statusSkin.contentPlay(true);
         }
      }
      
      private function onRoll(param1:MouseEvent) : void
      {
         if(this.statusSkin)
         {
            this.removeClip();
         }
         var _loc2_:VOQuest = data as VOQuest;
         if(Boolean(_loc2_) && _loc2_.isNew)
         {
            _loc2_.isNew = false;
         }
      }
      
      public function checkQuestCount() : void
      {
         var _loc1_:VOQuest = data as VOQuest;
         if(Boolean(_loc1_) && Boolean(_loc1_.target))
         {
            this.countText.value = _loc1_.count + "/" + _loc1_.target.qti_count;
         }
      }
      
      private function getHint() : String
      {
         var _loc1_:VOQuest = data as VOQuest;
         if(!_loc1_)
         {
            return null;
         }
         var _loc2_:String = "<p><span" + Style.metalColor + ">" + Lang.getString("bt_quest") + ": </span>" + Lang.getString(_loc1_.kind) + "</p>" + QuestRenderer.getDesc(_loc1_,true);
         if(_loc1_.isComplete)
         {
            _loc2_ += "<p" + Style.greenColor + " fontSize=\"12\">" + Lang.getString("quest_click_prize") + "</p>";
         }
         return _loc2_;
      }
   }
}

