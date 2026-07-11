package game.quest
{
   import logic.QuestLogic;
   import model.vo.VOQuest;
   import proto.model.PAction;
   import proto.model.PQuestTargetInfo;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.game.ShineClip;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CommonUtils;
   import utils.StringHelper;
   
   public class QuestRenderer extends VRenderer
   {
      
      private const descLabel:VLabel = new VLabel(null,VLabel.MIDDLE | VLabel.CENTER | VLabel.LEADING_BOX);
      
      private const goalText:VText = new VText(null,VText.CONTAIN_CENTER,16777216,20);
      
      private const skin:VSkin = new VSkin();
      
      private const prizePanel:PriceListPanel = new PriceListPanel();
      
      private const prizeBox:VBox = new VBox(null,5,VBox.VERTICAL);
      
      public var rewardBt:RectButton;
      
      public var cacheItem:VOQuest;
      
      public var helpBt:RectButton;
      
      private var titleText:VText;
      
      private var completeSkin:VSkin;
      
      private var speedupBt:RectButton;
      
      public function QuestRenderer(param1:Boolean = true)
      {
         super();
         setSize(748,154);
         add(SkinManager.getEmbed("QTargetBg"),{"top":20});
         add(SkinManager.getEmbed("TrainCircleBg",VSkin.STRETCH),{
            "w":113,
            "h":113,
            "left":10,
            "top":6
         });
         if(param1)
         {
            add(SkinManager.getEmbed("RSeparator",VSkin.STRETCH),{
               "w":424,
               "h":49,
               "left":75
            },1);
            add(SkinManager.getEmbed("Bolt"),{
               "left":90,
               "top":6
            });
            this.titleText = UIFactory.createYellowText(null,VText.MIDDLE,22,true);
            this.titleText.format.lineHeight = "90%";
            add(this.titleText,{
               "left":132,
               "top":2,
               "w":350,
               "h":44
            });
         }
         add(this.skin,{
            "left":15,
            "top":11,
            "w":102,
            "h":100
         });
         add(this.descLabel,{
            "left":128,
            "top":(param1 ? 54 : 38),
            "w":300,
            "h":(param1 ? 72 : 88)
         });
         add(this.goalText,{
            "left":432,
            "w":88,
            "vCenter":(param1 ? 15 : 6)
         });
         this.prizeBox.add(UIFactory.createDecorText(Lang.getString("prize"),true,22,226));
         this.prizePanel.useVertical();
         this.prizeBox.add(this.prizePanel);
         add(this.prizeBox,{
            "w":210,
            "right":12,
            "vCenter":0
         });
      }
      
      public static function getDesc(param1:VOQuest, param2:Boolean = false) : String
      {
         var _loc3_:PQuestTargetInfo = null;
         var _loc6_:Boolean = false;
         _loc3_ = param1.target;
         var _loc4_:uint = _loc3_.qti_action.variance;
         var _loc5_:String = "qt" + CommonUtils.getConstantName(PAction,_loc4_).toLowerCase();
         if(_loc3_.qti_kind)
         {
            _loc6_ = !isNaN(_loc3_.qti_level);
            if((_loc6_) && _loc3_.qti_level > 1)
            {
               if(_loc4_ == PAction.AC_FINISH_BUILDING || _loc4_ == PAction.AC_FINISH_CANNON || _loc4_ == PAction.AC_FINISH_FENCE)
               {
                  _loc5_ += "_hl";
               }
            }
            _loc5_ = Lang.getPatternString(_loc5_,"__KIND__",_loc6_ ? StringHelper.getUnitName(_loc3_.qti_kind,_loc3_.qti_level,22,Style.darkKhakiColor) : "<span" + Style.darkKhakiColor + ">" + Lang.getString(_loc3_.qti_kind) + "</span>");
         }
         else
         {
            _loc5_ = Lang.getString(_loc5_ + "_nk");
         }
         if(param2)
         {
            _loc5_ += " <span" + (param1.isComplete ? Style.greenColor : Style.redColor) + ">" + param1.count + "/" + _loc3_.qti_count + "</span>";
         }
         return "<p" + Style.metalColor + ">" + _loc5_ + "</p>";
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:VOQuest = param1 as VOQuest;
         var _loc3_:Boolean = this.cacheItem != _loc2_;
         if(_loc3_)
         {
            this.cacheItem = _loc2_;
            SkinManager.applyExternal(this.skin,_loc2_.meta.qi_icon,null,SkinManager.LOAD_CLIP);
            if(this.titleText)
            {
               this.titleText.value = Lang.getString(_loc2_.kind);
            }
            this.descLabel.text = getDesc(_loc2_);
            this.prizePanel.assignList(_loc2_.meta.qi_prize_units.length > 0 ? _loc2_.meta.qi_prize.concat(_loc2_.meta.qi_prize_units) : _loc2_.meta.qi_prize);
         }
         this.goalText.setColor(_loc2_.isComplete ? Style.greenRGB : Style.redRGB);
         this.goalText.value = _loc2_.count + "/" + _loc2_.target.qti_count;
         var _loc4_:Boolean = !_loc2_.isComplete;
         if((_loc4_) && _loc2_.target.qti_buy_finish.length == 0)
         {
            _loc4_ = false;
         }
         if(Boolean(this.speedupBt) && (!_loc4_ || _loc3_))
         {
            remove(this.speedupBt);
            this.speedupBt = null;
         }
         if(_loc4_ && !this.speedupBt)
         {
            this.addSpeedupButton();
         }
         if(this.helpBt)
         {
            this.helpBt.removeFromParent(true);
            this.helpBt = null;
         }
         if(_loc2_.isComplete)
         {
            if(!this.rewardBt)
            {
               this.rewardBt = new RectButton(Lang.getString("collectQuestBt"),RectButton.h42,RectButton.GREEN);
               this.rewardBt.addVarianceListener(this,QuestDialog.REWARD_BT);
               add(this.rewardBt,{
                  "hCenter":255,
                  "bottom":-6
               });
            }
            else
            {
               this.rewardBt.visible = true;
            }
            this.rewardBt.data = _loc2_;
            if(!this.completeSkin)
            {
               this.completeSkin = SkinManager.getEmbed("QTargetFg");
               add(new ShineClip("glow_yellow_small"),{
                  "right":110,
                  "top":70
               },1);
               add(this.completeSkin,{
                  "left":48,
                  "bottom":19
               },1);
            }
         }
         else
         {
            if(this.rewardBt)
            {
               this.rewardBt.visible = false;
            }
            if(this.completeSkin)
            {
               remove(this.completeSkin);
               this.completeSkin = null;
            }
            this.helpBt = QuestLogic.getHelpButton(_loc2_);
            if(this.helpBt)
            {
               this.helpBt.addVarianceListener(this,QuestDialog.HELP_BT,_loc2_);
               add(this.helpBt,{
                  "hCenter":-95,
                  "bottom":-6
               });
            }
         }
         var _loc5_:int = Boolean(this.speedupBt) || Boolean(this.rewardBt) && Boolean(this.rewardBt.visible) ? 0 : 6;
         if(_loc5_ != this.prizeBox.vCenter)
         {
            this.prizeBox.vCenter = _loc5_;
            this.prizeBox.syncLayout();
         }
      }
      
      private function addSpeedupButton() : void
      {
         var _loc2_:VComponent = null;
         var _loc4_:PricePanel = null;
         var _loc1_:VText = UIFactory.createYellowText(null,VText.CONTAIN,16);
         _loc1_.maxW = 140;
         var _loc3_:Array = this.cacheItem.target.qti_buy_finish;
         if(_loc3_.length == 0)
         {
            _loc2_ = _loc1_;
            _loc1_.value = "admin complete";
         }
         else
         {
            _loc1_.value = Lang.getString("finish_bt");
            _loc4_ = new PricePanel(20,16,PricePanel.GLOW_FILTER);
            _loc4_.assignCost(_loc3_[0]);
            _loc2_ = new VBox(new <VComponent>[_loc1_,_loc4_]);
         }
         this.speedupBt = new RectButton(_loc2_,RectButton.h42);
         this.speedupBt.addVarianceListener(this,QuestDialog.SPEEDUP_BT,this.cacheItem);
         add(this.speedupBt,{
            "hCenter":258,
            "bottom":-6
         });
      }
   }
}

