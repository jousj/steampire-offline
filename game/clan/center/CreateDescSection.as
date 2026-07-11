package game.clan.center
{
   import ui.Style;
   import ui.vbase.VComponent;
   import ui.vbase.VText;
   
   public class CreateDescSection extends VComponent
   {
      
      public function CreateDescSection(param1:String, param2:int)
      {
         super();
         this.layoutH = param2;
         addStretch(ClanCenterFactory.createFill());
         var _loc3_:uint = 18;
         var _loc4_:VText = new VText(param1,VText.CENTER,Style.darkKhakiRGB,_loc3_);
         _loc4_.left = _loc4_.top = 8;
         param2 -= _loc4_.top + 4;
         _loc4_.setGeometrySize(274,0,true);
         while(_loc3_ > 12 && _loc4_.measuredHeight > param2)
         {
            _loc3_ -= 2;
            if(_loc3_ == 12)
            {
               _loc4_.maxH = param2;
            }
            _loc4_.format.fontSize = _loc3_;
            _loc4_.syncFormat(true);
         }
         add(_loc4_);
      }
   }
}

