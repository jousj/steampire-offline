package game.my
{
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.common.ValueBar;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VCheckbox;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import ui.vbase.VSkin;
   
   public class SettingDialog extends BaseDialog
   {
      
      public const audioBar:ValueBar = new ValueBar();
      
      public const themeBar:ValueBar = new ValueBar();
      
      public const qualityCb:VCheckbox = UIFactory.createEasyCheckbox();
      
      public const saveBt:RectButton = new RectButton(Lang.getString("applyBt"),RectButton.h56);
      
      public function SettingDialog()
      {
         super();
         useWhiteBg(535,0,Lang.getString("settingGroup"));
         add(new VBox(new <VComponent>[this.createSection("AudioIcon",Lang.getString("audio"),this.audioBar),this.createSection("ThemeIcon",Lang.getString("melody"),this.themeBar),this.createSection("QualityIcon",Lang.getString("low_quality"),this.qualityCb,Lang.getString("low_quality_desc"))],14,VBox.VERTICAL),{
            "hCenter":0,
            "top":101,
            "bottom":114
         });
         var _loc1_:RectButton = new RectButton(Lang.getString("cancelBt"),RectButton.h56,RectButton.YELLOW);
         _loc1_.addClickListener(close);
         add(new VBox(new <VComponent>[_loc1_,this.saveBt],10),{
            "hCenter":0,
            "bottom":30
         });
      }
      
      private function createSection(param1:String, param2:String, param3:VComponent, param4:String = null) : VComponent
      {
         var _loc5_:VComponent = null;
         _loc5_ = new VComponent();
         _loc5_.layoutW = 440;
         _loc5_.minH = 46;
         var _loc6_:VSkin = SkinManager.getEmbed("StatBg",VSkin.STRETCH);
         _loc6_.alpha = 0.4;
         _loc5_.addStretch(_loc6_);
         _loc5_.add(SkinManager.getEmbed(param1,VSkin.CONTAIN),{
            "w":36,
            "h":36,
            "left":4,
            "top":5
         });
         if(param4)
         {
            param2 += "</p><p fontSize=\"14\" color=\"#808686\" paddingTop=\"2\">" + param4;
         }
         _loc5_.add(new VLabel("<p" + Style.metalColor + " fontSize=\"16\">" + param2 + "</p>",VLabel.MIDDLE),{
            "left":48,
            "w":_loc5_.layoutW - 68 - param3.measuredWidth,
            "top":10,
            "bottom":9
         });
         _loc5_.add(param3,{
            "top":46 - param3.measuredHeight >> 1,
            "right":10
         });
         return _loc5_;
      }
   }
}

