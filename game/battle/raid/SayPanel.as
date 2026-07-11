package game.battle.raid
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import game.battle.VisitorPanel;
   import model.vo.VORaidMember;
   import ui.Style;
   import ui.common.CircleButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class SayPanel extends VComponent
   {
      
      private const sayBt:CircleButton = new CircleButton(SkinManager.getEmbed("ChatIcon"),CircleButton.GOLD,CircleButton.sizeMenu74);
      
      private const spotPanel:SaySpotPanel = new SaySpotPanel();
      
      private const msg_key:String = "raid_msg";
      
      private var sayBox:VBox;
      
      private var directionPanel:SayDirectionPanel;
      
      public function SayPanel()
      {
         super();
         add(SkinManager.getEmbed("UnitPanelBg",VSkin.STRETCH_BG | VSkin.CACHE_AS_BITMAP),{
            "bottom":0,
            "w":90,
            "h":84
         });
         add(this.sayBt,{
            "left":7,
            "bottom":5
         });
         this.sayBt.addClickListener(this.onSay);
         this.sayBt.hint = Lang.getString("chat_bt");
         this.sayBt.cacheAsBitmap = true;
         this.spotPanel.bottom = 90;
         addChild(this.spotPanel);
      }
      
      private function createSayBox() : void
      {
         var _loc1_:Vector.<VComponent> = null;
         var _loc2_:uint = 0;
         var _loc4_:VButton = null;
         _loc1_ = new Vector.<VComponent>();
         _loc2_ = 0;
         while(_loc2_ <= 5)
         {
            _loc4_ = new VButton();
            _loc4_.addStretch(SkinManager.getEmbed("ChatMsgBg",VSkin.STRETCH_BG));
            _loc4_.setIcon(new VText(_loc2_ == 2 ? Lang.getPatternString(this.msg_key + _loc2_,"__VALUE__","...") : Lang.getString(this.msg_key + _loc2_),VText.CONTAIN_CENTER,Style.metalRGB,15),{
               "maxW":150,
               "left":8,
               "right":8,
               "vCenter":0
            });
            _loc4_.layoutH = 33;
            _loc4_.minW = 81;
            _loc4_.variance = _loc2_;
            _loc4_.addClickListener(this.onSaySelect);
            _loc1_.push(_loc4_);
            _loc2_++;
         }
         this.sayBox = new VBox(_loc1_,4);
         var _loc3_:VSkin = SkinManager.getEmbed("ChatListBg",VSkin.STRETCH);
         _loc3_.useRuledLayout();
         _loc3_.assignLayout({
            "left":-6,
            "right":-6,
            "top":-6,
            "bottom":-16
         });
         this.sayBox.addChildAt(_loc3_,0);
      }
      
      private function onSay(param1:MouseEvent) : void
      {
         if(Boolean(this.sayBox) && Boolean(this.sayBox.parent))
         {
            this.hide();
         }
         else
         {
            if(!this.sayBox)
            {
               this.createSayBox();
            }
            add(this.sayBox,{
               "left":102,
               "bottom":34
            });
            addListener(MouseEvent.MOUSE_DOWN,this.onDown,stage);
         }
      }
      
      private function hide() : void
      {
         if(Boolean(this.directionPanel) && Boolean(this.directionPanel.parent))
         {
            this.sayBox.removeChild(this.directionPanel);
         }
         remove(this.sayBox,false);
         removeListener(MouseEvent.MOUSE_DOWN,this.onDown,stage);
      }
      
      override public function dispose() : void
      {
         if(Boolean(this.directionPanel) && !this.directionPanel.parent)
         {
            this.directionPanel.dispose();
         }
         if(this.sayBox)
         {
            this.sayBox.dispose();
         }
         super.dispose();
      }
      
      private function onSaySelect(param1:MouseEvent) : void
      {
         var _loc2_:VButton = param1.currentTarget as VButton;
         if(_loc2_.variance == 2)
         {
            if(!this.directionPanel)
            {
               this.directionPanel = new SayDirectionPanel();
               this.directionPanel.addListener(VEvent.VARIANCE,this.onDirectionVariance);
               this.directionPanel.useRuledLayout();
               this.directionPanel.assignLayout({
                  "left":_loc2_.x + (_loc2_.measuredWidth - this.directionPanel.measuredHeight) / 2,
                  "top":-104
               });
               this.directionPanel.geometryPhase();
            }
            if(this.directionPanel.parent)
            {
               this.sayBox.removeChild(this.directionPanel);
            }
            else
            {
               this.sayBox.addChild(this.directionPanel);
            }
         }
         else
         {
            this.hide();
            dispatchVarianceEvent(VisitorPanel.MESSAGE,this.msg_key + _loc2_.variance);
         }
      }
      
      private function onDirectionVariance(param1:VEvent) : void
      {
         this.hide();
         dispatchVarianceEvent(VisitorPanel.MESSAGE,param1.variance.toString());
      }
      
      public function addMessage(param1:VORaidMember, param2:String, param3:Boolean = false) : void
      {
         if(Boolean(param1) && Boolean(param2))
         {
            if(param3)
            {
               param2 = param2.length == 1 ? Lang.getPatternString(this.msg_key + "2","__VALUE__",StringHelper.getTLFImage("lib,AttackDirection" + param2,18)) : Lang.getString(param2);
            }
            this.spotPanel.addMessage(param1,param2);
         }
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(_loc2_)
         {
            if(_loc2_ == this)
            {
               return;
            }
            _loc2_ = _loc2_.parent;
         }
         this.hide();
      }
   }
}

