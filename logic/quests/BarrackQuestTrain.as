package logic.quests
{
   import engine.units.Build;
   import game.barrack.BarrackBuyRenderer;
   import game.barrack.BarrackDialog;
   import game.my.MyMediator;
   import logic.training.BlackoutClickStep;
   import logic.training.GetPrizeTrain;
   import model.UserProxy;
   import model.ui.VOBarrackItem;
   import proto.model.PBtype;
   import proto.model.PShopUnit;
   import ui.vbase.VComponent;
   
   public class BarrackQuestTrain extends QuestTrain
   {
      
      public function BarrackQuestTrain()
      {
         super();
      }
      
      override public function run() : void
      {
         var _loc1_:Build = null;
         if(item.isComplete)
         {
            if(step != 2)
            {
               this.updateUserStage();
               Facade.mainMediator.searchDialog(BarrackDialog,true);
               assignTrain(new GetPrizeTrain(item.kind),2);
            }
         }
         else if(step != 1)
         {
            step = 1;
            _loc1_ = Facade.userProxy.getBuild(PBtype.BARRACK,false);
            if(_loc1_)
            {
               Facade.boardMediator.setSelected(_loc1_);
               Facade.boardMediator.moveBoard(_loc1_.t_x,_loc1_.t_y);
               assignStep(new BlackoutClickStep(MyMediator.commonBt,180,{
                  "hCenter":0,
                  "bottom":0
               }),this.onBarrackFirstOpen);
            }
         }
      }
      
      private function onBarrackFirstOpen() : void
      {
         Facade.changeUserStage(item.kind + "_barrack");
         this.onBarrackOpen();
      }
      
      private function updateUserStage() : void
      {
         var _loc1_:uint = uint(Facade.userProxy.soldierCountHash[item.target.qti_kind] / 5) * 5;
         if(_loc1_ > 0)
         {
            Facade.changeUserStage(item.kind + "_" + _loc1_);
         }
      }
      
      private function onBarrackOpen() : void
      {
         var _loc3_:BarrackBuyRenderer = null;
         var _loc4_:PShopUnit = null;
         this.updateUserStage();
         var _loc1_:BarrackDialog = Facade.mainMediator.searchDialog(BarrackDialog);
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:UserProxy = Facade.userProxy;
         for each(_loc3_ in _loc1_.buyGrid.renderList)
         {
            if(_loc3_.checkBuyBt(item.target.qti_kind))
            {
               _loc4_ = (_loc3_.buyBt.data as VOBarrackItem).shop;
               if(_loc2_.checkCost(_loc4_.su_price.variance,_loc4_.su_price.value) > 0 || _loc2_.energy < _loc4_.su_hspace)
               {
                  return;
               }
               assignStep(new BlackoutClickStep(Boolean(_loc3_.buy5Bt) && _loc3_.buy5Bt.visible ? _loc3_.buy5Bt : _loc3_.buyBt,0,{"hCenter":0}),this.onBarrackOpen);
               return;
            }
         }
      }
   }
}

