package game.quest
{
   import model.vo.VOQuest;
   import ui.common.CountPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class QuestBtPanel extends VBox
   {
      
      public const rankBt:QuestButton = new QuestButton();
      
      private var allBt:QuestButton;
      
      private var bgSkin:VSkin;
      
      private var countPanel:CountPanel;
      
      private var dp:Array;
      
      private var btMax:uint = 2;
      
      public var dpMax:uint;
      
      public function QuestBtPanel()
      {
         super(null,8,VBox.VERTICAL | VBox.TOP | VBox.LEFT);
         layoutW = 64;
         mouseEnabled = false;
         SkinManager.applyEmbed(this.rankBt.icon as VSkin,"RankIcon");
         this.rankBt.hint = Lang.getString("rank_title");
         this.rankBt.layoutH = Facade.fakeResize ? 80 : 90;
         this.rankBt.skin.assignLayout({
            "w":74,
            "h":74,
            "hCenter":0,
            "bottom":0
         });
         this.rankBt.icon.assignLayout({
            "w":0,
            "h":0,
            "vCenter":this.rankBt.layoutH - this.rankBt.skin.layoutW >> 1
         });
      }
      
      public function updateAll(param1:Array) : void
      {
         var _loc2_:VOQuest = null;
         this.dp = param1;
         this.dpMax = 0;
         for each(_loc2_ in param1)
         {
            if(!_loc2_.isHidden)
            {
               ++this.dpMax;
            }
         }
         this.sync();
      }
      
      private function sync() : void
      {
         var _loc2_:VOQuest = null;
         var _loc3_:QuestButton = null;
         var _loc4_:* = 0;
         if(!isGeometryPhase || !stage)
         {
            return;
         }
         var _loc1_:Vector.<VComponent> = list.slice();
         removeAll(false);
         for each(_loc2_ in this.dp)
         {
            if(!_loc2_.isHidden)
            {
               _loc3_ = null;
               _loc4_ = int(_loc1_.length - 1);
               while(_loc4_ >= 0)
               {
                  if((_loc1_[_loc4_] as QuestButton).data == _loc2_)
                  {
                     _loc3_ = _loc1_[_loc4_] as QuestButton;
                     _loc1_.splice(_loc4_,1);
                     break;
                  }
                  _loc4_--;
               }
               if(!_loc3_)
               {
                  _loc3_ = new QuestButton();
                  SkinManager.applyExternal(_loc3_.icon as VSkin,_loc2_.meta.qi_icon,null,SkinManager.LOAD_CLIP);
                  _loc3_.addVarianceListener(this,QuestDialog.SHOW_ONE_QUEST,_loc2_);
                  _loc3_.checkQuestCount();
               }
               if(_loc2_.isComplete)
               {
                  this.useCollectStatus(_loc3_);
               }
               else if(_loc2_.isNew)
               {
                  _loc3_.useNewStatus();
               }
               list.push(_loc3_);
               if(this.dpMax > this.btMax && list.length == this.btMax - 1)
               {
                  break;
               }
            }
         }
         if(this.dpMax > this.btMax)
         {
            if(!this.allBt)
            {
               this.allBt = new QuestButton();
               this.allBt.icon.setSize(54,54);
               SkinManager.applyEmbed(this.allBt.icon as VSkin,"AllQuestIcon");
               this.allBt.hint = Lang.getString("bt_allQuest");
               this.allBt.addVarianceListener(this,QuestDialog.SHOW_ALL_QUEST);
               this.countPanel = new CountPanel(0,false);
               this.allBt.add(this.countPanel,{
                  "right":-9,
                  "bottom":-2
               });
            }
            this.countPanel.value = this.dpMax;
            list.push(this.allBt);
         }
         else if(this.allBt)
         {
            this.allBt = null;
            this.countPanel = null;
         }
         list.push(this.rankBt);
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_ != this.allBt && _loc3_ != this.rankBt)
            {
               _loc3_.dispose();
            }
         }
         addAll();
         if(list.length > 2)
         {
            if(!this.bgSkin)
            {
               this.bgSkin = SkinManager.getEmbed("MetalVerticalBg",VSkin.STRETCH);
               addChildAt(this.bgSkin,0);
               this.bgSkin.assignLayout({
                  "hCenter":0,
                  "top":30
               });
            }
            this.bgSkin.layoutH = (list.length - 2) * 72;
            this.bgSkin.geometryPhase();
         }
         else if(this.bgSkin)
         {
            removeChild(this.bgSkin);
            this.bgSkin.dispose();
            this.bgSkin = null;
         }
      }
      
      public function setHighQuestPriority(param1:VOQuest) : void
      {
         var _loc2_:VOQuest = null;
         for each(_loc2_ in this.dp)
         {
            if(param1.kind == _loc2_.kind)
            {
               param1 = _loc2_;
            }
         }
         this.dp.splice(this.dp.indexOf(param1),1);
         param1.isHidden = false;
         this.dp.unshift(param1);
         this.updateAll(this.dp);
      }
      
      public function getButton(param1:String, param2:Boolean = false) : QuestButton
      {
         var _loc3_:QuestButton = null;
         var _loc4_:VOQuest = null;
         for each(_loc3_ in list)
         {
            _loc4_ = _loc3_.data as VOQuest;
            if((Boolean(_loc4_)) && _loc4_.kind == param1)
            {
               return _loc3_;
            }
         }
         return param2 ? this.allBt : null;
      }
      
      public function useProgressStatus(param1:String, param2:String) : void
      {
         this.getButton(param1,true).useProgressStatus(param2);
      }
      
      public function useCollectStatus(param1:Object) : void
      {
         var _loc2_:QuestButton = param1 is QuestButton ? param1 as QuestButton : this.getButton(param1 as String);
         if(_loc2_)
         {
            _loc2_.useCollectStatus();
         }
      }
      
      public function removeStatus(param1:String) : void
      {
         var _loc2_:QuestButton = this.getButton(param1);
         if(_loc2_)
         {
            _loc2_.removeClip();
         }
      }
      
      override public function updatePhase(param1:Boolean = false) : void
      {
         if(layoutH > 0 || isTopBottom)
         {
            this.btMax = Math.floor((h - this.rankBt.layoutH * scaleX) / (72 * scaleX));
            if(this.btMax < 2)
            {
               this.btMax = 2;
            }
         }
         else
         {
            this.btMax = 2;
         }
         var _loc2_:uint = list.length;
         if(_loc2_ > 0 && Boolean(this.rankBt.parent))
         {
            _loc2_--;
         }
         if(this.btMax < _loc2_ || this.btMax > _loc2_ && this.dpMax > _loc2_)
         {
            this.sync();
         }
         else
         {
            super.updatePhase(param1);
         }
      }
      
      public function clear() : void
      {
         var _loc1_:QuestButton = null;
         for each(_loc1_ in list)
         {
            _loc1_.removeClip();
         }
         if(this.allBt)
         {
            this.allBt.removeClip();
         }
      }
      
      public function rankAttention(param1:Boolean) : void
      {
         var _loc2_:CountPanel = null;
         if(this.rankBt.numChildren > 2)
         {
            _loc2_ = this.rankBt.getChildAt(2) as CountPanel;
         }
         if(param1 != Boolean(_loc2_))
         {
            if(param1)
            {
               _loc2_ = new CountPanel(0,false);
               _loc2_.title = "!";
               this.rankBt.add(_loc2_,{
                  "right":-9,
                  "bottom":-2
               },2);
            }
            else
            {
               _loc2_.removeFromParent();
            }
         }
      }
      
      public function setScale(param1:Number) : void
      {
         if(scaleX != param1)
         {
            scaleX = scaleY = param1;
            if(isGeometryPhase && Boolean(stage))
            {
               this.updatePhase();
            }
         }
      }
   }
}

