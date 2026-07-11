package game.clan.social
{
   import logic.CoreLogic;
   import proto.model.PRole;
   import proto.model.clan.PChatMember;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VInputText;
   import utils.StringHelper;
   
   public class ChatPanel extends MessageListPanel
   {
      
      public const inputText:VInputText = UIFactory.createInputText(16,null,180);
      
      public const sendBt:CircleButton = new CircleButton(SkinManager.getEmbed("SendIcon"),CircleButton.GOLD);
      
      public var messageCount:uint;
      
      public function ChatPanel()
      {
         super(558,155);
         this.inputText.format.fontFamily = "Myriad Pro";
         this.inputText.useEnterEvent();
         add(this.inputText,{
            "left":24,
            "right":38,
            "bottom":-41
         });
         this.sendBt.icon.useCenter(-2,2);
         add(this.sendBt,{
            "bottom":-50,
            "right":-3,
            "w":50,
            "h":51
         });
      }
      
      public function addMessage(param1:PChatMember, param2:String, param3:Number, param4:Boolean, param5:Boolean = false) : void
      {
         var _loc8_:String = null;
         var _loc6_:Date = CoreLogic.getDate(param3);
         if(checkNewDay(_loc6_))
         {
            addText(StringHelper.getDateDesc(_loc6_,true,false),false);
         }
         var _loc7_:uint = param1.cm_role.variance;
         switch(_loc7_)
         {
            case PRole.BEGINNER:
               _loc8_ = "424242";
               break;
            case PRole.SOLDIER:
               _loc8_ = "672C07";
               break;
            case PRole.CREATOR:
               _loc8_ = "B0060F";
               break;
            case PRole.ANCIENT:
               _loc8_ = "AD6417";
               break;
            default:
               _loc8_ = "186A15";
         }
         addText(StringHelper.getDateDesc(_loc6_,false) + "  <span color=\"#" + _loc8_ + "\">" + StringHelper.addCDATA(param1.cm_name) + ":  </span>" + (param2.indexOf("@<sys>@") == 0 ? Lang.getString(param2.substr(7)) : StringHelper.addCDATA(param2)),param4,param5);
         ++this.messageCount;
      }
   }
}

