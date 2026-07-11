package game.offer
{
   import game.radar.RadarDialog;
   import proto.model.POfferGoods;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VText;
   
   public class OfferResultDialog extends BaseDialog
   {
      
      public function OfferResultDialog(param1:Array, param2:String)
      {
         var _loc3_:Vector.<VComponent> = null;
         var _loc4_:VBox = null;
         var _loc5_:uint = 0;
         var _loc6_:RectButton = null;
         var _loc7_:POfferGoods = null;
         var _loc8_:VBox = null;
         var _loc9_:Object = null;
         super();
         minW = 567;
         addStretch(UIFactory.createPaperSkin());
         add(UIFactory.createDecorText(Lang.getString("congratulations"),true,42),{
            "hCenter":10,
            "top":30
         });
         add(new VText(Lang.getString(param2),VText.CENTER | VText.MIDDLE | VComponent.SKIP_CONTENT_SIZE,Style.metalRGB,16),{
            "left":88,
            "right":72,
            "top":80,
            "h":35
         });
         if(param1)
         {
            _loc3_ = new Vector.<VComponent>();
            OfferDialog.addGoodItems(_loc3_,param1);
            _loc4_ = new VBox(null,5,VBox.VERTICAL);
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               if(_loc5_ % 2 == 0)
               {
                  _loc8_ = new VBox(null,20,VBox.CENTER);
                  _loc4_.add(_loc8_);
               }
               _loc8_.add(_loc3_[_loc5_]);
               _loc5_++;
            }
            if(_loc3_.length > 2)
            {
               layoutH = 700;
               _loc9_ = {
                  "top":122,
                  "left":120,
                  "right":110
               };
            }
            else
            {
               layoutH = 473;
               _loc9_ = _loc3_.length > 1 ? {
                  "top":122,
                  "left":100,
                  "right":90
               } : {
                  "top":122,
                  "hCenter":10
               };
            }
            add(_loc4_,_loc9_);
            _loc3_ = new Vector.<VComponent>();
            _loc6_ = new RectButton(Lang.getString("bt_ok"),RectButton.h56,RectButton.ORANGE);
            _loc6_.addClickListener(close);
            _loc3_.push(_loc6_);
            for each(_loc7_ in param1)
            {
               if(_loc7_.variance == POfferGoods.BUY)
               {
                  _loc6_ = new RectButton(Lang.getString("to_editor"),RectButton.h56);
                  _loc6_.addClickListener(Facade.boardMediator.useEditorMode);
                  _loc6_.addClickListener(close);
                  _loc3_.push(_loc6_);
                  break;
               }
            }
            add(new VBox(_loc3_,10),{
               "hCenter":10,
               "bottom":42
            });
         }
         else
         {
            layoutW = 695;
            layoutH = 500;
            RadarDialog.createScoutingPanel(this,120);
            _loc6_ = new RectButton(Lang.getString("bt_ok"),RectButton.h56,RectButton.ORANGE);
            _loc6_.addClickListener(close);
            add(_loc6_,{
               "bottom":0,
               "hCenter":0
            });
         }
      }
   }
}

