package game.research
{
   import engine.units.Build;
   import flash.events.MouseEvent;
   import game.barrack.BarrackBuyRenderer;
   import game.barrack.BarrackDialog;
   import game.common.DialogMediator;
   import game.feature.FeatureMediator;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.ShopLogic;
   import model.CommonEvent;
   import model.ui.VOBarrackItem;
   import model.vo.MapAction;
   import proto.game.family_0010.PUserAction;
   import proto.model.PRequirement;
   import proto.model.PShopSpell;
   import proto.model.PShopUnit;
   import proto.model.PStartStudy;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   import ui.vbase.VSkin;
   
   public class ResearchMediator extends DialogMediator
   {
      
      public var dialog:ResearchDialog;
      
      public var build:Build;
      
      private var toKind:String;
      
      private var isArrow:Boolean;
      
      private var arrowSkin:VSkin;
      
      public function ResearchMediator(param1:Build, param2:String = null)
      {
         super();
         this.build = param1;
         this.toKind = param2;
         this.isArrow = Boolean(param2);
      }
      
      override public function onAdd() : BaseDialog
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:VOBarrackItem = null;
         var _loc8_:PShopUnit = null;
         var _loc9_:PShopSpell = null;
         var _loc10_:* = 0;
         this.dialog = new ResearchDialog(this.build.kind,this.build.level);
         this.dialog.rarDragonPanel.useTrack();
         this.dialog.mithrilPanel.setMax(Facade.references.mithril_limit,false);
         this.dialog.mithrilPanel.useTrack();
         var _loc1_:MapAction = CoreLogic.getAction(ActionLogic.FINISH_RESEARCH,this.build.id);
         if(!_loc1_)
         {
            this.dialog.setPrompt();
         }
         var _loc2_:Array = [];
         for(_loc3_ in up.soldierLevelHash)
         {
            _loc4_ = uint(up.soldierLevelHash[_loc3_]);
            _loc5_ = _loc3_.indexOf("un_") == 0;
            if(_loc5_)
            {
               if(mp.getHeroShop(_loc3_,1,true))
               {
                  continue;
               }
               _loc8_ = mp.getSoldierShop(_loc3_,_loc4_ + 1,true);
               if(_loc8_)
               {
                  if(_loc8_.su_is_clan != Facade.isCapital)
                  {
                     continue;
                  }
                  if(Boolean(_loc8_.su_event_requirement) && !ShopLogic.checkRequierement(_loc8_.su_event_requirement))
                  {
                     continue;
                  }
                  if(!_loc8_.su_can_buy || _loc8_.su_kind == "un_zombie")
                  {
                     if(_loc8_.su_level == 1 || _loc8_.su_level == 2 && !mp.getSoldierShop(_loc3_,1).su_can_buy)
                     {
                        continue;
                     }
                  }
               }
            }
            else
            {
               _loc9_ = mp.getSpellShop(_loc3_,_loc4_ + 1,true);
               if((Boolean(_loc9_)) && !_loc9_.ssp_can_buy)
               {
                  if(_loc9_.ssp_level == 1 || _loc9_.ssp_level == 2 && !mp.getSpellShop(_loc3_,1).ssp_can_buy)
                  {
                     continue;
                  }
               }
            }
            _loc6_ = false;
            if(_loc5_)
            {
               if(!_loc8_ || !_loc8_.su_can_buy)
               {
                  _loc8_ = mp.getSoldierShop(_loc3_,_loc4_);
                  if(_loc8_.su_is_clan != Facade.isCapital || !_loc8_.su_can_buy && _loc4_ == 1)
                  {
                     continue;
                  }
                  _loc6_ = true;
               }
            }
            else
            {
               if(!_loc9_ || !_loc9_.ssp_can_buy)
               {
                  _loc9_ = mp.getSpellShop(_loc3_,_loc4_);
                  if(!_loc9_.ssp_can_buy && _loc4_ == 1)
                  {
                     continue;
                  }
                  _loc6_ = true;
               }
               _loc8_ = mp.convertSpellShop(_loc9_);
            }
            _loc7_ = new VOBarrackItem();
            _loc7_.shop = _loc8_;
            _loc7_.flag = _loc6_;
            if(!_loc6_)
            {
               _loc7_.isResearchLock = !up.checkBuild(_loc8_.su_upgrade_requirement.req_building_kind,_loc8_.su_upgrade_requirement.req_building_level);
            }
            if(Boolean(_loc1_) && _loc8_.su_kind == (_loc1_.value as PShopUnit).su_kind)
            {
               _loc7_.isResearchRun = true;
               this.dialog.setActive(_loc8_,_loc1_.time,_loc1_.time - CoreLogic.serverTime);
            }
            _loc2_.push(_loc7_);
         }
         _loc2_.sort(this.researchSort);
         _loc4_ = 0;
         if(this.toKind)
         {
            _loc10_ = int(_loc2_.length - 1);
            while(_loc10_ >= 0)
            {
               if((_loc2_[_loc10_] as VOBarrackItem).shop.su_kind == this.toKind)
               {
                  _loc4_ = _loc10_;
                  break;
               }
               _loc10_--;
            }
         }
         this.dialog.grid.setDataProvider(_loc2_,_loc4_);
         if(this.isArrow)
         {
            this.dialog.grid.addListener(VEvent.CHANGE,this.onChangeIndex);
            this.onChangeIndex();
         }
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         Facade.addListenerForComponent(CommonEvent.FINISH_RESEARCH,this.onFinish,this.dialog);
         return this.dialog;
      }
      
      private function researchSort(param1:VOBarrackItem, param2:VOBarrackItem) : Number
      {
         var _loc3_:Boolean = param1.flag || param1.isResearchLock;
         if(_loc3_ != (param2.flag || param2.isResearchLock))
         {
            return _loc3_ ? 1 : -1;
         }
         return param1.shop.order - param2.shop.order;
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:PShopUnit = null;
         var _loc3_:VOBarrackItem = null;
         if(param1.variance == BarrackDialog.SPEEDUP)
         {
            this.speedup();
         }
         else if(param1.variance == BarrackDialog.CLEAR)
         {
            _loc2_ = param1.data as PShopUnit;
            ShopLogic.showCancelDialog(this.build,ActionLogic.FINISH_RESEARCH,_loc2_.su_model_level,_loc2_.su_kind);
         }
         else
         {
            _loc3_ = param1.data as VOBarrackItem;
            if(_loc3_.isResearchRun)
            {
               this.speedup();
            }
            else
            {
               Facade.mainMediator.showDialog(new FeatureMediator(_loc3_.shop,true));
            }
         }
      }
      
      private function getItem(param1:String) : VOBarrackItem
      {
         var _loc2_:VOBarrackItem = null;
         for each(_loc2_ in this.dialog.grid.getDataProvider())
         {
            if(_loc2_.shop.su_kind == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function start(param1:PShopUnit) : void
      {
         ShopLogic.applyCostList(param1.su_upgrade_price,true);
         this.getItem(param1.su_kind).isResearchRun = true;
         this.dialog.grid.sync();
         var _loc2_:Number = CoreLogic.serverTime;
         this.dialog.setActive(param1,_loc2_ + param1.su_upgrade_time,param1.su_upgrade_time);
         ActionLogic.addResearch(this.build.id,param1,_loc2_);
         ActionLogic.request(PUserAction.START_STUDY,PStartStudy.create(this.build.id,param1.su_kind));
         Facade.audioProxy.play("study_begin");
      }
      
      private function onFinish(param1:CommonEvent) : void
      {
         var _loc3_:PShopUnit = null;
         var _loc4_:PRequirement = null;
         if(param1.variance > 0 && param1.variance != this.build.id)
         {
            return;
         }
         var _loc2_:VOBarrackItem = this.getItem(param1.data);
         if(_loc2_)
         {
            _loc2_.isResearchRun = false;
            _loc3_ = mp.getResearchSoldierShop(_loc2_.shop.su_kind,true);
            if(Boolean(_loc3_) && _loc3_.su_can_buy)
            {
               _loc2_.shop = _loc3_;
               _loc4_ = _loc3_.su_upgrade_requirement;
               _loc2_.isResearchLock = !up.checkBuild(_loc4_.req_building_kind,_loc4_.req_building_level);
            }
            else
            {
               _loc2_.flag = true;
            }
            this.dialog.grid.sync();
            this.dialog.setPrompt();
         }
      }
      
      public function speedup(param1:Function = null, param2:Array = null) : void
      {
         ShopLogic.showActionSpeedupDialog(this.build,ActionLogic.FINISH_RESEARCH,null,param1,param2);
      }
      
      private function onChangeIndex(param1:VEvent = null) : void
      {
         var _loc2_:BarrackBuyRenderer = null;
         if(this.arrowSkin)
         {
            this.arrowSkin.removeFromParent();
            this.arrowSkin = null;
         }
         for each(_loc2_ in this.dialog.grid.renderList)
         {
            if(_loc2_.checkBuyBt(this.toKind))
            {
               this.arrowSkin = UIFactory.createLearnArrow(0);
               this.arrowSkin.addListener(MouseEvent.CLICK,this.onClick,_loc2_);
               _loc2_.add(this.arrowSkin,{
                  "hCenter":0,
                  "top":0
               });
               break;
            }
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.dialog.grid.removeListener(VEvent.CHANGE,this.onChangeIndex);
         this.arrowSkin.removeFromParent();
         this.arrowSkin = null;
      }
   }
}

