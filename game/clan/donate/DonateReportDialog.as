package game.clan.donate
{
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VFill;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   import utils.StringHelper;
   
   public class DonateReportDialog extends BaseDialog
   {
      
      public const grid:VGrid = new VGrid(1,10,DonateReportRenderer,null,0,0,VGrid.H_STRETCH);
      
      public var sortField:String;
      
      public var isDescending:Boolean;
      
      public var memberList:Array;
      
      private const arrowSkin:VSkin = SkinManager.getEmbed("GreenArrow");
      
      public function DonateReportDialog(param1:uint, param2:Number, param3:Array, param4:uint)
      {
         super();
         useDefaultBg(638,Lang.getString("report_" + param1));
         var _loc5_:int = 82;
         var _loc6_:int = 18;
         var _loc7_:int = int(this.grid.renderList[0].measuredHeight);
         var _loc8_:int = _loc7_ * (this.grid.vCount + 1);
         add(SkinManager.getEmbed("WSectionBg",VSkin.STRETCH),{
            "top":_loc5_,
            "left":_loc6_,
            "right":_loc6_,
            "h":_loc8_ + 21
         });
         _loc5_ += 8;
         var _loc9_:int = 0;
         while(_loc9_ <= this.grid.vCount)
         {
            add(new VFill(12893879),{
               "h":_loc7_,
               "top":_loc5_ + _loc7_ * _loc9_,
               "left":_loc6_ + 13,
               "right":_loc6_ + 11
            });
            _loc9_ += 2;
         }
         _loc8_ -= 2;
         add(new VFill(16777215,0.15),{
            "left":_loc6_ + 286,
            "top":_loc5_ + 2,
            "w":118,
            "h":_loc8_
         });
         add(new VFill(16777215,0.15),{
            "left":_loc6_ + 510,
            "top":_loc5_ + 2,
            "w":87,
            "h":_loc8_
         });
         add(new VFill(16777215,0.15),{
            "right":_loc6_ + 9,
            "top":_loc5_ + 2,
            "w":88,
            "h":_loc8_
         });
         var _loc10_:VButton = VButton.create(new VText(Lang.getString("clan_member"),VText.MIDDLE | VText.CENTER,Style.darkKhakiRGB,16),{
            "w":268,
            "h":_loc7_
         });
         _loc10_.addVarianceListener(this,0,"exp");
         add(_loc10_,{
            "left":_loc6_ + 13,
            "top":_loc5_
         });
         _loc10_ = VButton.create(new VText(Lang.getString("all_donate"),VText.MIDDLE | VText.CENTER,Style.darkKhakiRGB,16),{
            "w":113,
            "h":_loc7_
         });
         _loc10_.addVarianceListener(this,0,"all");
         add(_loc10_,{
            "left":_loc6_ + 288,
            "top":_loc5_
         });
         _loc10_ = VButton.create(new VText(Lang.getString("week_donate"),VText.MIDDLE | VText.CENTER,Style.darkKhakiRGB,16),{
            "w":96,
            "h":_loc7_
         });
         _loc10_.addVarianceListener(this,0,"week");
         add(_loc10_,{
            "left":426,
            "top":_loc5_
         });
         _loc10_ = VButton.create(new VText(StringHelper.getDateDesc(param2,true,false),VText.MIDDLE | VText.CENTER,Style.darkKhakiRGB,14),{"w":82});
         _loc10_.addVarianceListener(this,0,"day1");
         add(_loc10_,{
            "left":_loc6_ + 512,
            "top":_loc5_ + 17
         });
         _loc10_ = VButton.create(new VText(StringHelper.getDateDesc(param2 - 86400,true,false),VText.MIDDLE | VText.CENTER,Style.darkKhakiRGB,14),{"w":82});
         _loc10_.addVarianceListener(this,0,"day2");
         add(_loc10_,{
            "left":_loc6_ + 598,
            "top":_loc5_ + 17
         });
         _loc10_ = VButton.create(new VText(StringHelper.getDateDesc(param2 - 172800,true,false),VText.MIDDLE | VText.CENTER,Style.darkKhakiRGB,14),{"w":82});
         _loc10_.addVarianceListener(this,0,"day3");
         add(_loc10_,{
            "left":_loc6_ + 683,
            "top":_loc5_ + 17
         });
         this.grid.dispatcher = this;
         add(this.grid,{
            "left":_loc6_ + 13,
            "right":_loc6_ + 11,
            "top":_loc5_ + _loc7_ - 1
         });
         UIFactory.useGridControlNav(this.grid,UIFactory.addNavBt30);
         this.grid.setDataProvider(param3,param4);
         this.arrowSkin.top = 83;
         addChild(this.arrowSkin);
      }
      
      public function syncSortArrow() : void
      {
         var _loc2_:VButton = null;
         var _loc1_:* = int(numChildren - 1);
         while(_loc1_ >= 0)
         {
            _loc2_ = getChildAt(_loc1_) as VButton;
            if(Boolean(_loc2_) && _loc2_.data == this.sortField)
            {
               this.arrowSkin.left = _loc2_.left + (_loc2_.measuredWidth - this.arrowSkin.measuredWidth >> 1);
               break;
            }
            _loc1_--;
         }
         this.arrowSkin.setMode(this.isDescending ? VSkin.FLIP_Y : 0);
      }
   }
}

