package game.quest
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import proto.model.PAction;
   import proto.model.PCost;
   import proto.model.PQuest;
   import proto.model.PQuestInfo;
   import proto.model.PQuestTarget;
   import proto.model.PQuestTargetInfo;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.CommonUtils;
   import utils.CostHelper;
   
   public class LikeDialog extends BaseDialog
   {
      
      public var data:PQuest;
      
      public var info:PQuestInfo;
      
      private var clickDialog:BaseDialog;
      
      private var isMm:Boolean;
      
      private var isOk:Boolean;
      
      public function LikeDialog(param1:PQuest, param2:PQuestInfo)
      {
         var _loc3_:uint = 0;
         var _loc5_:VSkin = null;
         var _loc11_:PQuestTargetInfo = null;
         var _loc12_:String = null;
         var _loc13_:VSkin = null;
         var _loc14_:VText = null;
         var _loc15_:RectButton = null;
         var _loc16_:PricePanel = null;
         var _loc17_:PriceListPanel = null;
         super();
         this.data = param1;
         this.info = param2;
         this.isMm = Facade.socialnet == Facade.MOYMIR;
         this.isOk = Facade.socialnet == Facade.ODNOKLASSNIKI;
         useWhiteBg(500,0,Lang.getString("like_title"));
         _loc3_ = uint(numChildren);
         var _loc4_:String = "LikeDialog";
         _loc5_ = SkinManager.getPack(_loc4_,"LikeBg",0,0,this.onComplete);
         add(_loc5_,{
            "hCenter":0,
            "top":80
         });
         var _loc6_:Vector.<VComponent> = new Vector.<VComponent>();
         var _loc7_:String = this.isMm || this.isOk ? "_ok" : "";
         var _loc8_:Vector.<String> = new <String>[RectButton.GREEN,RectButton.YELLOW,RectButton.ORANGE];
         var _loc9_:Boolean = true;
         var _loc10_:* = int(param2.qi_targets.length - 1);
         while(_loc10_ >= 0)
         {
            _loc11_ = param2.qi_targets[_loc10_];
            _loc12_ = Lang.getString(CommonUtils.getConstantName(PAction,_loc11_.qti_action.variance).toLowerCase() + _loc7_);
            if((param1.qtargets[_loc10_] as PQuestTarget).value >= (param2.qi_targets[_loc10_] as PQuestTargetInfo).qti_count)
            {
               _loc13_ = SkinManager.getEmbed("ChCheck");
               _loc13_.setSize(36,36);
               _loc14_ = UIFactory.createYellowText(_loc12_,VText.CENTER | VText.MIDDLE);
               _loc14_.setSize(290,52);
               _loc6_.unshift(new VBox(new <VComponent>[_loc13_,_loc14_]));
            }
            else
            {
               _loc15_ = new RectButton(_loc12_,null,_loc10_ >= _loc8_.length ? null : _loc8_[_loc10_] + RectButton.H56);
               if(_loc10_ >= _loc8_.length)
               {
                  SkinManager.applyExternal(_loc15_.skin as VSkin,_loc4_,"BtRectOrangeLike");
               }
               _loc15_.hCustom(52,14,0,18,-1);
               _loc15_.layoutW = 350;
               _loc6_.unshift(_loc15_);
               _loc15_.addClickListener(this.onClick,_loc11_.qti_action);
               _loc9_ = false;
            }
            _loc10_--;
         }
         add(new VBox(_loc6_,3,VBox.VERTICAL | VBox.RIGHT),{
            "top":92,
            "hCenter":0,
            "w":350
         });
         add(UIFactory.createDecorText(Lang.getString("prize"),true,30,500),{
            "top":332,
            "hCenter":0
         });
         if(param2.qi_prize.length == 2)
         {
            _loc10_ = 90;
            add(SkinManager.getPack(_loc4_,"DarkBg",VSkin.STRETCH),{
               "top":374,
               "w":160,
               "hCenter":-_loc10_
            });
            add(SkinManager.getPack(_loc4_,"Energy"),{
               "top":372,
               "hCenter":-_loc10_
            });
            _loc16_ = new PricePanel(40,22,PricePanel.GLOW_FILTER);
            _loc16_.assign(PCost.CALL,CostHelper.getValueFromList(param2.qi_prize,PCost.CALL));
            add(_loc16_,{
               "top":500,
               "hCenter":-_loc10_
            });
            add(SkinManager.getPack(_loc4_,"DarkBg",VSkin.STRETCH),{
               "top":374,
               "w":160,
               "hCenter":_loc10_
            });
            add(SkinManager.getPack(_loc4_,"Gold"),{
               "top":372,
               "hCenter":_loc10_
            });
            _loc16_ = new PricePanel(40,22,PricePanel.GLOW_FILTER);
            _loc16_.assign(PCost.GOLD,CostHelper.getValueFromList(param2.qi_prize,PCost.GOLD));
            add(_loc16_,{
               "top":500,
               "hCenter":_loc10_
            });
         }
         else
         {
            _loc17_ = new PriceListPanel(20);
            _loc17_.add(SkinManager.getEmbed("StatBg",VSkin.STRETCH_BG),{
               "left":-20,
               "right":-20,
               "top":-12,
               "bottom":-10
            },0);
            _loc17_.useVertical(90,102,100);
            _loc17_.assignList(param2.qi_prize);
            add(_loc17_,{
               "top":400,
               "hCenter":0
            });
         }
         if(_loc9_)
         {
            layoutH = 620;
            _loc15_ = new RectButton(Lang.getString("collectQuestBt"),RectButton.h56,RectButton.ORANGE);
            _loc15_.addVarianceListener(this,0);
            add(_loc15_,{
               "hCenter":0,
               "bottom":20
            });
         }
         else
         {
            layoutH = 558;
         }
         if(!_loc5_.isContent)
         {
            _loc10_ = int(numChildren - 1);
            while(_loc10_ >= _loc3_)
            {
               getChildAt(_loc10_).visible = false;
               _loc10_--;
            }
            _loc14_ = new VText(Lang.getString("load_title"),VText.CONTAIN_CENTER,Style.metalRGB);
            add(_loc14_,{
               "left":30,
               "right":30,
               "vCenter":0
            });
            _loc5_.useCustomLoadClip(_loc14_);
         }
      }
      
      private function onComplete(param1:VEvent) : void
      {
         var _loc2_:* = int(numChildren - 1);
         while(_loc2_ >= 0)
         {
            getChildAt(_loc2_).visible = true;
            _loc2_--;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = ((param1.currentTarget as VButton).data as PAction).variance;
         switch(_loc2_)
         {
            case PAction.AC_GAME_BOOKMARK:
               Facade.callJS("add_bookmark");
               break;
            case PAction.AC_GAME_ENTER_GROUP:
               Facade.callJS("open_group");
               break;
            case PAction.AC_GAME_LIKE:
               this.showClickDialog(true);
               break;
            case PAction.AC_GAME_SHARE:
               if(this.isMm || this.isOk)
               {
                  Facade.callJS("shareGame");
                  break;
               }
               this.showClickDialog(false);
               break;
            case PAction.AC_HAVE_FRIEND:
               Facade.callJS("addFriends");
         }
      }
      
      private function showClickDialog(param1:Boolean) : void
      {
         this.clickDialog = new BaseDialog();
         this.clickDialog.useWhiteBg(0,0,Lang.getString("like_click"));
         this.clickDialog.add(SkinManager.getPack("LikeDialog",param1 ? (this.isMm ? "MMLike" : (this.isOk ? "OKLike" : "VKLike")) : "VKSave"),{
            "hCenter":0,
            "top":83
         });
         var _loc2_:BitmapData = new BitmapData(331,160,true,0);
         var _loc3_:VComponent = Facade.mainPanel.dialogPanel;
         _loc3_.visible = false;
         _loc2_.draw(Facade.board);
         _loc2_.draw(Facade.mainPanel,param1 ? null : new Matrix(1,0,0,1,_loc2_.width - _loc3_.w),null,null,null);
         _loc3_.visible = true;
         var _loc4_:Bitmap = new Bitmap(_loc2_);
         this.clickDialog.addChild(_loc4_);
         _loc4_.x = param1 ? 40 : 39;
         _loc4_.y = 110;
         this.clickDialog.setSize(410,346);
         if(this.isMm)
         {
            this.clickDialog.add(UIFactory.createLearnArrow(90),{
               "top":96,
               "left":274
            });
         }
         else
         {
            this.clickDialog.add(UIFactory.createLearnArrow(param1 ? 90 : -90),{
               "top":96,
               "left":(param1 ? 155 : 280)
            });
         }
         var _loc5_:RectButton = new RectButton(Lang.getString("closeBt"),RectButton.h42);
         _loc5_.addClickListener(this.clickDialog.close);
         this.clickDialog.add(_loc5_,{
            "hCenter":0,
            "bottom":22
         });
         this.clickDialog.addListener(VEvent.CLOSE_DIALOG,this.onClickDialogClose);
         Facade.mainMediator.showDialog(this.clickDialog);
      }
      
      private function onClickDialogClose(param1:VEvent) : void
      {
         this.clickDialog = null;
      }
      
      override public function close(param1:MouseEvent = null) : void
      {
         if(this.clickDialog)
         {
            this.clickDialog.close();
         }
         super.close(param1);
      }
   }
}

