package logic.training
{
   import engine.Position;
   import engine.units.Unit;
   import game.my.MyMediator;
   import game.shop.AlinkDialog;
   import game.shop.ShopDialog;
   import game.shop.ShopRenderer;
   import logic.ActionLogic;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import logic.ShopLogic;
   import logic.units.TrainLogic;
   import model.ui.VOCallback;
   import model.ui.VOShopItem;
   import model.vo.MapAction;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   
   public class BuyTrain extends AbstractTrain
   {
      
      protected var kind:String;
      
      protected var pos:Position;
      
      protected var trainLogic:TrainLogic;
      
      protected var qkind:String;
      
      public function BuyTrain(param1:String, param2:Position, param3:String = null)
      {
         super();
         this.kind = param1;
         this.pos = param2;
         this.qkind = param3;
      }
      
      public static function getShopBt(param1:String) : VButton
      {
         var _loc3_:ShopRenderer = null;
         var _loc2_:ShopDialog = Facade.mainMediator.searchDialog(ShopDialog) as ShopDialog;
         if(_loc2_)
         {
            for each(_loc3_ in _loc2_.grid.renderList)
            {
               if(Boolean(_loc3_.parent) && (_loc3_.bt.data as VOShopItem).kind == param1)
               {
                  return _loc3_.bt;
               }
            }
         }
         return null;
      }
      
      override public function run() : void
      {
         var _loc1_:MapAction = null;
         var _loc2_:Unit = null;
         for each(_loc1_ in CoreLogic.getActionList(ActionLogic.FINISH_CONSTRUCTION))
         {
            _loc2_ = Facade.userProxy.constructionHash[_loc1_.objId];
            if(_loc2_.kind.indexOf(this.kind) >= 0)
            {
               this.showUnit(_loc2_);
               return;
            }
         }
         this.showShopButton();
      }
      
      protected function showShopButton() : void
      {
         assignStep(new BlackoutClickStep(Facade.myMediator.myPanel.shopBt,315,{
            "hCenter":-20,
            "vCenter":-20
         },null,false),this.onShopOpen);
      }
      
      protected function onShopOpen() : void
      {
         if(this.qkind)
         {
            Facade.changeUserStage(this.qkind + "_shop");
         }
         Facade.boardMediator.resetSelected();
         DialogLogic.openShop(null,this.kind,false);
         var _loc1_:VButton = getShopBt(this.kind);
         if(_loc1_)
         {
            assignStep(new BlackoutClickStep(_loc1_,-60,{
               "left":74,
               "top":90
            }),this.onShopSelect);
         }
      }
      
      protected function onShopSelect() : void
      {
         if(this.qkind)
         {
            Facade.changeUserStage(this.qkind + "_choice");
         }
         assignStep(new PlaceStep(this.pos),this.onPlace);
      }
      
      protected function onPlace() : void
      {
         var _loc1_:Unit = Facade.boardMediator.getSelected();
         if(_loc1_)
         {
            if(this.qkind)
            {
               Facade.changeUserStage(this.qkind + "_placed");
            }
            this.showUnit(_loc1_);
         }
         else
         {
            this.showShopButton();
         }
      }
      
      protected function showUnit(param1:Unit) : void
      {
         if(this.trainLogic)
         {
            this.trainLogic.dispose();
         }
         this.trainLogic = new TrainLogic(param1);
         this.trainLogic.getMenuHandler = this.onTrainMenu;
         this.trainLogic.changeSelectHandler = this.onTrainSelect;
         if(param1 != Facade.boardMediator.getSelected())
         {
            Facade.boardMediator.moveBoard(param1.c_x,param1.c_y);
            Facade.boardMediator.setSelected(param1);
         }
      }
      
      private function onTrainMenu(param1:Vector.<VComponent>) : void
      {
         if(param1.indexOf(MyMediator.speedupBt) >= 0)
         {
            assignStep(new BlackoutClickStep(MyMediator.speedupBt,180,{
               "hCenter":0,
               "bottom":0
            },new VOCallback(this.checkSpeedupNow)),this.onSpeedUp);
         }
      }
      
      protected function checkSpeedupNow() : void
      {
         var _loc1_:Unit = Facade.boardMediator.getSelected();
         if(Boolean(_loc1_) && ShopLogic.getSpeedupGold(CoreLogic.getActionTimeLeft(ActionLogic.FINISH_CONSTRUCTION,_loc1_.id)) == 0)
         {
            this.useSpeedupStage();
         }
      }
      
      private function onTrainSelect(param1:Boolean) : void
      {
         if(!param1)
         {
            if(this.trainLogic)
            {
               this.trainLogic.dispose();
               this.trainLogic = null;
            }
         }
      }
      
      protected function onSpeedUp() : void
      {
         var _loc1_:AlinkDialog = Facade.mainMediator.searchDialog(AlinkDialog);
         if(Boolean(_loc1_) && Boolean(_loc1_.buyBt))
         {
            assignStep(new BlackoutClickStep(_loc1_.buyBt,0,{
               "hCenter":0,
               "top":0
            },new VOCallback(this.useSpeedupStage)));
         }
      }
      
      protected function useSpeedupStage() : void
      {
         if(this.qkind)
         {
            Facade.changeUserStage(this.qkind + "_speedup");
         }
      }
      
      override public function dispose() : void
      {
         this.onTrainSelect(false);
         super.dispose();
      }
   }
}

