package game.capital
{
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class CapitalPanel extends VComponent
   {
      
      public const clanText:VText = UIFactory.createYellowText(null,VText.CONTAIN_CENTER,18,true);
      
      private var editText:VText;
      
      public function CapitalPanel()
      {
         super();
         add(SkinManager.getEmbed("ResHeaderBg",VSkin.STRETCH | VSkin.FLIP_Y),{
            "left":54,
            "top":94,
            "w":398
         });
         add(this.clanText,{
            "left":60,
            "w":380,
            "top":100
         });
      }
      
      public function assignButtons(param1:Boolean, param2:Boolean) : void
      {
         var _loc4_:Vector.<VComponent> = null;
         var _loc5_:CircleButton = null;
         var _loc7_:VComponent = null;
         var _loc3_:Vector.<int> = new Vector.<int>();
         _loc4_ = new <VComponent>[SkinManager.getEmbed("RearGear",VSkin.STRETCH_BG | VSkin.ZERO_CENTER)];
         _loc5_ = new CircleButton(SkinManager.getEmbed("HomeIcon"),CircleButton.ORANGE,CircleButton.sizeMenu74);
         _loc5_.hint = Lang.getString("to_home");
         _loc5_.addVarianceListener(this,0);
         _loc4_.push(_loc5_);
         if(param1)
         {
            _loc5_ = new CircleButton(SkinManager.getEmbed("ShopIcon"),CircleButton.GOLD,CircleButton.sizeMenu74);
            _loc5_.hint = Lang.getString("shopBt");
            _loc5_.addVarianceListener(this,1);
            _loc4_.push(_loc5_);
         }
         if(param2)
         {
            _loc5_ = new CircleButton(SkinManager.getEmbed("DonateIcon"),CircleButton.GOLD,CircleButton.sizeMenu74);
            _loc5_.icon.layoutH = 42;
            _loc5_.hint = Lang.getString("clan_donate_mobile");
            _loc5_.addVarianceListener(this,2);
            _loc4_.push(_loc5_);
         }
         var _loc6_:uint = _loc4_.length;
         if(_loc6_ == 2)
         {
            _loc3_.push(-140,-131,18,25);
         }
         else if(_loc6_ == 3)
         {
            _loc3_.push(-124,-96,7,74,60,6);
         }
         else
         {
            _loc3_.push(-148,10,4,174,34,94,4,9);
         }
         _loc6_ = 0;
         for each(_loc7_ in _loc4_)
         {
            _loc7_.right = _loc3_[_loc6_];
            _loc7_.bottom = _loc3_[_loc6_ + 1];
            _loc6_ += 2;
            add(_loc7_);
         }
      }
      
      public function showEditInfo(param1:String) : void
      {
         var _loc2_:VComponent = null;
         var _loc3_:VBox = null;
         var _loc4_:VSkin = null;
         if(Facade.fakeResize)
         {
            _loc2_ = new VComponent();
            _loc2_.addStretch(SkinManager.getEmbed("EditorIcon"));
            _loc4_ = SkinManager.getEmbed("DarkPanelBg",VSkin.STRETCH_BG);
            _loc4_.useRuledLayout();
            _loc4_.setPadding(-10);
            _loc2_.addChildAt(_loc4_,0);
            add(_loc2_,{
               "right":20,
               "top":20,
               "h":62
            });
            _loc2_.hint = param1;
         }
         else if(param1)
         {
            if(this.editText)
            {
               this.editText.value = param1;
            }
            else
            {
               this.editText = UIFactory.createYellowText(param1,VText.MIDDLE | VText.CENTER,18,true);
               this.editText.setSize(-100,-100);
               this.editText.maxW = 240;
               _loc3_ = new VBox(new <VComponent>[SkinManager.getEmbed("EditorIcon"),this.editText],8);
               _loc4_ = SkinManager.getEmbed("DarkPanelBg",VSkin.STRETCH_BG);
               _loc4_.useRuledLayout();
               _loc4_.setPadding(-10);
               _loc3_.addChildAt(_loc4_,0);
               add(_loc3_,{
                  "right":20,
                  "top":20,
                  "h":62
               });
            }
         }
         else if(this.editText)
         {
            remove(this.editText.parent as VComponent);
            this.editText = null;
         }
      }
   }
}

