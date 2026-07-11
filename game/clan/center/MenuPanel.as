package game.clan.center
{
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import proto.model.clan.PMember;
   import ui.common.RectButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class MenuPanel extends VComponent
   {
      
      public function MenuPanel(param1:Vector.<VComponent>)
      {
         var _loc2_:VComponent = null;
         var _loc3_:VBox = null;
         super();
         for each(_loc2_ in param1)
         {
            _loc2_.dispatcher = this;
         }
         _loc3_ = new VBox(param1,4,VBox.VERTICAL);
         add(_loc3_,{
            "left":10,
            "right":10,
            "top":11,
            "bottom":26
         });
         Facade.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onHideMenu);
      }
      
      public static function createButton(param1:String, param2:uint, param3:PMember, param4:* = null, param5:String = null) : VButton
      {
         var _loc6_:RectButton = null;
         _loc6_ = new RectButton(param1,RectButton.h30,param5 ? param5 : RectButton.GREEN);
         _loc6_.layoutW = 140;
         _loc6_.addVarianceListener(null,0,[param2,param3,param4]);
         return _loc6_;
      }
      
      public function show(param1:VComponent, param2:VButton, param3:Number, param4:Number) : void
      {
         var _loc5_:Rectangle = null;
         var _loc6_:VSkin = null;
         geometryPhase();
         param1.addChild(this);
         _loc5_ = param2.getRect(param1);
         x = left = _loc5_.x + param2.w - w + param3;
         top = _loc5_.y - h + param4;
         _loc6_ = SkinManager.getEmbed("PopupBg",VSkin.STRETCH_BG);
         var _loc7_:Number = localToGlobal(new Point(0,top)).y;
         if(_loc7_ < 0)
         {
            top = _loc5_.bottom + 15 - param4;
            _loc6_.top = h - 15;
            _loc6_.scaleY = -1;
         }
         y = top;
         addStretch(_loc6_,0);
      }
      
      private function onHideMenu(param1:MouseEvent) : void
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
         removeFromParent();
      }
      
      override public function dispose() : void
      {
         Facade.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHideMenu);
         super.dispose();
      }
   }
}

