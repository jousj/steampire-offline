package logic.units
{
   import engine.data.MapCell;
   import engine.units.Build;
   import engine.units.Cannon;
   import engine.units.Unit;
   import game.board.UnitMenuButton;
   import game.my.MyMediator;
   import logic.ActionLogic;
   import logic.BoardLogic;
   import logic.CoreLogic;
   import logic.ShopLogic;
   import model.vo.VOPylonSpec;
   import proto.model.PBtype;
   import proto.model.PShopCannon;
   import ui.Style;
   import ui.vbase.VComponent;
   import utils.CommonUtils;
   import utils.StringHelper;
   
   public class CannonLogic extends AbstractLogic
   {
      
      public function CannonLogic()
      {
         super();
      }
      
      public static function checkPylonCannon(param1:Cannon = null) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:MapCell = null;
         var _loc2_:Vector.<MapCell> = new Vector.<MapCell>();
         var _loc3_:Build = userProxy.buildList.head as Build;
         while(_loc3_)
         {
            if(_loc3_.type == PBtype.PYLON && _loc3_.updateLevel == 0)
            {
               BoardLogic.getRadiusPositionList(_loc3_.c_x,_loc3_.c_y,_loc3_.size,(_loc3_.spec as VOPylonSpec).radius,0,_loc2_);
            }
            _loc3_ = _loc3_.link_next as Build;
         }
         var _loc4_:Boolean = param1 != null;
         if(!_loc4_)
         {
            param1 = userProxy.cannonList.head as Cannon;
         }
         while(param1)
         {
            _loc5_ = false;
            for each(_loc6_ in _loc2_)
            {
               if(_loc6_.x >= param1.t_x && _loc6_.x <= param1.b_x && _loc6_.y >= param1.t_y && _loc6_.y <= param1.b_y)
               {
                  _loc5_ = true;
                  break;
               }
            }
            param1.setPylon(_loc5_);
            param1 = _loc4_ ? null : param1.link_next as Cannon;
         }
      }
      
      public static function setSkipPylonAnim() : void
      {
         var _loc1_:Cannon = userProxy.cannonList.head as Cannon;
         while(_loc1_)
         {
            if(_loc1_.isPylon)
            {
               _loc1_.skipPylonAnim = true;
            }
            _loc1_ = _loc1_.link_next as Cannon;
         }
      }
      
      override public function changeOver(param1:Unit, param2:Boolean) : void
      {
         var _loc4_:String = null;
         var _loc3_:Cannon = param1 as Cannon;
         if(param2)
         {
            _loc4_ = StringHelper.getUnitName(param1.kind,param1.level);
            if(!_loc3_.isPylon)
            {
               _loc4_ += "<p" + Style.redColor + ">" + Lang.getString("cannon_need_pylon") + "</p>";
            }
         }
         mainMediator.setHint(param1,_loc4_);
      }
      
      override public function changeSelect(param1:Unit, param2:Boolean) : void
      {
         var _loc3_:Cannon = param1 as Cannon;
         if(param2)
         {
            this.syncRadiusVisible(_loc3_);
            if(_loc3_.isPylon && _loc3_.updateLevel == 0 && _loc3_.env.isRotate)
            {
               _loc3_.rotate(CommonUtils.getRangeRandom(0,360));
            }
         }
         else
         {
            _loc3_.hideRadius();
         }
      }
      
      override public function changeMove(param1:Unit, param2:Boolean, param3:Boolean = false) : void
      {
         this.syncPylonRadiusVisible(param2);
         if(param2)
         {
            (param1 as Cannon).useTopRadius();
         }
         else
         {
            checkPylonCannon(param1 as Cannon);
         }
      }
      
      private function syncPylonRadiusVisible(param1:Boolean, param2:Cannon = null) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Vector.<MapCell> = null;
         var _loc6_:MapCell = null;
         var _loc3_:Build = userProxy.buildList.head as Build;
         while(_loc3_)
         {
            if(_loc3_.type == PBtype.PYLON && _loc3_.updateLevel == 0)
            {
               _loc4_ = param1;
               if(Boolean(param1) && Boolean(param2) && param2.isPylon)
               {
                  _loc5_ = new Vector.<MapCell>();
                  BoardLogic.getRadiusPositionList(_loc3_.c_x,_loc3_.c_y,_loc3_.size,(_loc3_.spec as VOPylonSpec).radius,0,_loc5_);
                  for each(_loc6_ in _loc5_)
                  {
                     if(_loc6_.x >= param2.t_x && _loc6_.x <= param2.b_x && _loc6_.y >= param2.t_y && _loc6_.y <= param2.b_y)
                     {
                        _loc4_ = false;
                        break;
                     }
                  }
               }
               if(_loc4_ != _loc3_.isRadius)
               {
                  if(_loc4_)
                  {
                     _loc3_.showRadius((_loc3_.spec as VOPylonSpec).radius,0);
                  }
                  else
                  {
                     _loc3_.hideRadius();
                  }
               }
            }
            _loc3_ = _loc3_.link_next as Build;
         }
      }
      
      private function syncRadiusVisible(param1:Cannon) : void
      {
         if(param1.isPylon != param1.isRadius)
         {
            if(param1.isPylon)
            {
               param1.showRadius(param1.shop.sc_radius,16777215,param1.shop.sc_blind_radius);
            }
            else
            {
               param1.hideRadius();
            }
         }
      }
      
      override public function onMove(param1:Unit) : void
      {
         var _loc2_:Cannon = param1 as Cannon;
         checkPylonCannon(_loc2_);
         this.syncRadiusVisible(_loc2_);
         this.syncPylonRadiusVisible(true,_loc2_);
      }
      
      override public function getMenu(param1:Unit, param2:Vector.<VComponent>) : void
      {
         var _loc3_:UnitMenuButton = null;
         var _loc5_:PShopCannon = null;
         var _loc4_:Cannon = param1 as Cannon;
         if(_loc4_.updateLevel > 0)
         {
            _loc3_ = MyMediator.cancelBt;
            _loc3_.changeHandler(ShopLogic.showCancelDialog,ActionLogic.FINISH_CONSTRUCTION,_loc4_.updateLevel);
            param2.push(_loc3_);
            _loc3_ = MyMediator.speedupBt;
            if(isCapital)
            {
               _loc3_.trackSpeedup(CoreLogic.getActionTimeLeft(ActionLogic.FINISH_CONSTRUCTION,_loc4_.id));
            }
            else
            {
               _loc3_.trackFree(CoreLogic.getActionTimeLeft(ActionLogic.FINISH_CONSTRUCTION,_loc4_.id));
            }
            _loc3_.changeHandler(ShopLogic.showActionSpeedupDialog,ActionLogic.FINISH_CONSTRUCTION);
            param2.push(_loc3_);
         }
         else
         {
            _loc5_ = manualProxy.getCannonShop(param1.kind,param1.level + 1,true);
            if((Boolean(_loc5_)) && (_loc5_.sc_can_buy || isMissionEditor))
            {
               _loc3_ = MyMediator.updateBt;
               _loc3_.applyPriceList(_loc5_.sc_price);
               _loc3_.handler = BuildLogic.onUpdate;
               param2.push(_loc3_);
            }
         }
      }
   }
}

