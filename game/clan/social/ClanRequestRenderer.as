package game.clan.social
{
   import engine.units.Unit;
   import proto.model.PAsk;
   import proto.model.PAskData;
   import proto.model.PClanRequest;
   import proto.model.PCost;
   import proto.model.clan.PCallRequest;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VFill;
   import ui.vbase.VLabel;
   import ui.vbase.VProgressBar;
   import ui.vbase.VRenderer;
   import ui.vbase.VText;
   import utils.CommonUtils;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class ClanRequestRenderer extends VRenderer
   {
      
      public static const LOAD_IMG:uint = 325234;
      
      public static var ratioScoreHash:Object = {};
      
      private const label:VLabel = new VLabel(null,VLabel.MIDDLE | VLabel.LEADING_BOX);
      
      private const contextBox:VBox = new VBox(null,4);
      
      private var labelText:String = "";
      
      private var level:uint = 0;
      
      private var fill:VFill;
      
      public var id:String;
      
      public function ClanRequestRenderer()
      {
         super();
         layoutH = 64;
         add(this.label,{
            "left":15,
            "hP":100
         });
         add(this.contextBox,{
            "right":10,
            "vCenter":0
         });
      }
      
      override public function setData(param1:Object) : void
      {
         this.contextBox.removeAll();
         if(param1 is PCallRequest)
         {
            this.setCallRequest(param1 as PCallRequest);
         }
         else if(param1 is PAsk)
         {
            this.setAsk(param1 as PAsk);
         }
         else if(param1 is PClanRequest)
         {
            this.setClanRequest(param1 as PClanRequest);
         }
         else
         {
            this.label.text = null;
         }
         if(param1 is PAsk != Boolean(this.fill))
         {
            if(this.fill)
            {
               remove(this.fill);
               this.fill = null;
            }
            else
            {
               this.fill = new VFill(16250930,0.4);
               add(this.fill,{
                  "left":2,
                  "right":2,
                  "top":1,
                  "bottom":1
               },0);
            }
         }
      }
      
      private function setCallRequest(param1:PCallRequest) : void
      {
         this.addEnergyProgress(param1.cr_current_count,param1.cr_full_count);
         if(param1.cr_user_id != Preloader.uid && param1.cr_senders.indexOf(Preloader.uid) < 0)
         {
            this.addContextButton("CollectIcon",CircleButton.GOLD,0,param1);
         }
         this.setMessage(param1.cr_user_id,"call_request",param1.member.user_base.name,param1.member.user_base.level);
      }
      
      private function setClanRequest(param1:PClanRequest) : void
      {
         this.addContextButton("ToGuestIcon",CircleButton.TEAL,0,param1);
         this.addContextButton("NoIcon",CircleButton.GOLD,1,param1);
         this.addContextButton("CollectIcon",CircleButton.GOLD,2,param1);
         this.setMessage(param1.cr_user_id,"clan_request",param1.cr_user_name,param1.cr_user_level);
      }
      
      private function setAsk(param1:PAsk) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:Unit = null;
         this.addContextButton("CollectIcon",CircleButton.GOLD,0,param1);
         if(param1.ask_is_help)
         {
            _loc4_ = param1.ask_data.variance;
            switch(_loc4_)
            {
               case PAskData.ASK_CRYSTAL:
                  _loc4_ = PCost.CRYSTAL;
                  break;
               case PAskData.ASK_OIL:
                  _loc4_ = PCost.OIL;
                  break;
               case PAskData.ASK_CALL:
                  _loc4_ = PCost.CALL;
                  break;
               case PAskData.ASK_RESEARCH:
                  _loc3_ = "ask_research";
                  break;
               case PAskData.ASK_SPEED_UP:
                  _loc3_ = "ask_speedup";
                  _loc5_ = Facade.userProxy.constructionHash[param1.ask_data.value] as Unit;
                  _loc2_ = _loc5_ ? Lang.getString(_loc5_.kind) : "";
            }
            if(!_loc3_)
            {
               _loc3_ = "ask_request";
               _loc2_ = CostHelper.get18String(_loc4_,param1.ask_value.value);
            }
         }
         else
         {
            _loc3_ = CommonUtils.getConstantName(PAskData,param1.ask_data.variance).toLowerCase() + "_r";
         }
         this.setMessage(param1.ask_user_id,_loc3_,param1.ask_user_name,param1.ask_user_level,_loc2_);
      }
      
      private function setMessage(param1:String, param2:String, param3:String, param4:uint, param5:String = null) : void
      {
         this.contextBox.addAll();
         this.label.right = this.contextBox.right + this.contextBox.measuredWidth + 10;
         this.labelText = "<p fontSize=\"15\"" + Style.metalColor + ">" + Lang.getReplaceString(param2,{
            "__USER__":"<span" + Style.darkKhakiColor + ">" + StringHelper.addCDATA(param3) + " </span>",
            "__DATA__":param5
         }) + "</p>";
         this.id = param1;
         this.level = param4;
         this.label.text = this.labelText;
         var _loc6_:VEvent = new VEvent(VEvent.VARIANCE,param5);
         _loc6_.variance = LOAD_IMG;
         _loc6_.data = this;
         dispatcher.dispatchEvent(_loc6_);
      }
      
      public function setPoints(param1:Array) : void
      {
         this.label.text = this.labelText + "<p fontSize=\"15\"" + Style.metalColor + ">" + StringHelper.getTLFImage("lib,Exp",22) + this.level + " " + StringHelper.getTLFImage("lib,ClanEmblemIcon",22) + param1[0] + " " + StringHelper.getTLFImage("lib,RatingIcon",22) + param1[1] + "</p>";
      }
      
      private function addContextButton(param1:String, param2:String, param3:uint, param4:*) : void
      {
         var _loc5_:CircleButton = new CircleButton(SkinManager.getEmbed(param1),param2,CircleButton.size42);
         _loc5_.addVarianceListener(this,param3,param4);
         this.contextBox.list.push(_loc5_);
      }
      
      private function addEnergyProgress(param1:uint, param2:uint) : void
      {
         var _loc3_:VComponent = new VComponent();
         var _loc4_:VProgressBar = UIFactory.createProgressBar(UIFactory.INDICATOR_BLUE);
         _loc4_.layoutW = 120;
         _loc4_.value = param1 / param2;
         _loc3_.add(_loc4_,{
            "left":5,
            "top":14,
            "bottom":2
         });
         _loc3_.add(SkinManager.getEmbed("Energy"),{
            "bottom":0,
            "w":24
         });
         _loc3_.add(new VText(param1 + "/" + param2,VText.CONTAIN_CENTER,Style.metalRGB,14),{
            "left":20,
            "right":20
         });
         this.contextBox.list.push(_loc3_);
      }
   }
}

