package game.clan.center
{
   import proto.model.PCost;
   import proto.model.clan.PEntryPolicy;
   import ui.UIFactory;
   import ui.common.NumericPanel;
   import ui.common.RectButton;
   import ui.game.PriceButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VCheckbox;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VInputText;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class ClanEditPanel extends VComponent
   {
      
      public static const SAVE:uint = 1;
      
      public static const EDIT_EMBLEM:uint = 2;
      
      public static const CREATE:uint = 3;
      
      public static const CANCEL:uint = 4;
      
      public const descInput:VInputText;
      
      public var titleInput:VInputText;
      
      public var levelReqPanel:NumericPanel;
      
      public var policyCb:VCheckbox;
      
      public var emblem:String;
      
      private const emblemSkin:VSkin;
      
      private const emblemBt:VButton;
      
      public function ClanEditPanel(param1:uint, param2:uint, param3:String)
      {
         var _loc6_:VBox = null;
         var _loc7_:uint = 0;
         var _loc9_:VCheckbox = null;
         this.descInput = UIFactory.createInputText(18,null,160,VInputText.BREAK_LINE);
         this.emblemSkin = new VSkin();
         this.emblemBt = new RectButton(Lang.getString("editBt"),RectButton.h30,RectButton.ORANGE);
         super();
         addStretch(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH_BG));
         add(SkinManager.getEmbed("TrainCircleBg",VSkin.STRETCH),{
            "w":160,
            "h":160,
            "left":30,
            "top":54
         });
         add(UIFactory.createYellowText(Lang.getString("clan_emblem"),VText.CONTAIN_CENTER),{
            "left":18,
            "top":27,
            "w":180
         });
         add(this.emblemSkin,{
            "left":42,
            "top":64,
            "w":138,
            "h":138
         });
         this.setEmblem(param3);
         add(this.emblemBt,{
            "top":206,
            "hCenter":-280
         });
         this.emblemBt.addVarianceListener(this,EDIT_EMBLEM);
         var _loc4_:int = 210;
         var _loc5_:uint = 516;
         add(UIFactory.createYellowText(Lang.getString("clan_title"),VText.CONTAIN_CENTER),{
            "left":_loc4_,
            "top":27,
            "w":_loc5_
         });
         add(UIFactory.createYellowText(Lang.getString("clan_desc"),VText.CONTAIN_CENTER),{
            "left":_loc4_,
            "top":93,
            "w":_loc5_
         });
         add(this.descInput,{
            "left":_loc4_,
            "w":_loc5_,
            "top":116,
            "h":100
         });
         add(SkinManager.getEmbed("LightGreyBg",VSkin.STRETCH),{
            "left":_loc4_,
            "w":_loc5_,
            "top":224,
            "h":106
         });
         add(UIFactory.createYellowText(Lang.getString("clan_policy"),VText.CONTAIN_CENTER),{
            "left":_loc4_,
            "top":243,
            "w":_loc5_
         });
         _loc6_ = new VBox(null,20);
         for each(_loc7_ in new <uint>[PEntryPolicy.FREE,PEntryPolicy.ON_DEMAND,PEntryPolicy.CLOSED])
         {
            _loc9_ = UIFactory.createCheckbox(Lang.getString("clan_policy" + _loc7_),false,15,false);
            _loc9_.data = _loc7_;
            _loc9_.addListener(VEvent.CHANGE,this.onPolicy);
            if(_loc7_ == param2)
            {
               this.policyCb = _loc9_;
            }
            _loc9_.maxW = 146;
            _loc6_.add(_loc9_);
         }
         if(!this.policyCb)
         {
            this.policyCb = _loc6_.list[0] as VCheckbox;
         }
         this.policyCb.checked = true;
         this.policyCb.mouseEnabled = false;
         add(_loc6_,{
            "top":276,
            "hCenter":72
         });
         add(SkinManager.getEmbed("LightGreyBg",VSkin.STRETCH),{
            "left":_loc4_,
            "w":_loc5_,
            "top":341,
            "h":44
         });
         var _loc8_:VText = UIFactory.createYellowText(Lang.getString("clan_min_level_title"),VText.CONTAIN);
         _loc8_.maxW = 386;
         this.levelReqPanel = new NumericPanel(param1);
         add(new VBox(new <VComponent>[_loc8_,this.levelReqPanel],10),{
            "hCenter":72,
            "top":346
         });
      }
      
      private function onPolicy(param1:VEvent) : void
      {
         if(this.policyCb)
         {
            this.policyCb.mouseEnabled = true;
            this.policyCb.checked = false;
         }
         this.policyCb = param1.currentTarget as VCheckbox;
         this.policyCb.mouseEnabled = false;
      }
      
      public function setEmblem(param1:String) : void
      {
         this.emblem = param1;
         SkinManager.applyExternal(this.emblemSkin,UIFactory.EMBLEM_PACK,this.emblem);
      }
      
      public function useNewMode(param1:PCost) : void
      {
         this.titleInput = UIFactory.createInputText(18,null,40);
         add(this.titleInput,{
            "left":this.descInput.left,
            "w":this.descInput.layoutW,
            "top":50
         });
         var _loc2_:PriceButton = new PriceButton();
         _loc2_.assignCost(param1);
         _loc2_.addVarianceListener(this,CREATE,this);
         add(_loc2_,{
            "bottom":20,
            "hCenter":76
         });
      }
      
      public function useEditMode(param1:String, param2:String, param3:uint) : void
      {
         add(UIFactory.createDecorText(param1,true,26,this.descInput.layoutW),{
            "hCenter":72,
            "top":56
         });
         this.descInput.value = param2;
         this.levelReqPanel.value = param3;
         var _loc4_:VButton = new RectButton(Lang.getString("confirmBt"),RectButton.h42);
         _loc4_.addVarianceListener(this,SAVE);
         var _loc5_:VButton = new RectButton(Lang.getString("cancelBt"),RectButton.h42,RectButton.ORANGE);
         _loc5_.addVarianceListener(this,CANCEL);
         add(new VBox(new <VComponent>[_loc5_,_loc4_],8),{
            "bottom":27,
            "hCenter":76
         });
      }
   }
}

