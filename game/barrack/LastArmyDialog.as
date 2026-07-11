package game.barrack
{
   import engine.units.Build;
   import flash.events.MouseEvent;
   import game.feature.CampRenderer;
   import logic.ActionLogic;
   import logic.ShopLogic;
   import model.UserProxy;
   import model.ui.VOBattleItem;
   import proto.game.family_0010.PMakeUnit;
   import proto.game.family_0010.PUserAction;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.common.RectButton;
   import ui.game.PriceListPanel;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VGrid;
   import ui.vbase.VText;
   
   public class LastArmyDialog extends BaseDialog
   {
      
      private var dp:Array;
      
      private var price:Array;
      
      private var build:Build;
      
      public function LastArmyDialog(param1:Array, param2:Array, param3:Build)
      {
         var _loc4_:VGrid = null;
         super();
         this.dp = param1;
         this.price = param2;
         this.build = param3;
         useWhiteBg(522,0,Lang.getString("dead_troops"));
         _loc4_ = new VGrid(param1.length < 5 ? 4 : 5,1,CampRenderer,param1,14,0,VGrid.USE_NULL_DATA);
         _loc4_.layoutH = 114;
         UIFactory.useGridControlNav(_loc4_,UIFactory.addNavBt30);
         var _loc5_:PriceListPanel = new PriceListPanel();
         _loc5_.useCostCheck = true;
         _loc5_.assignList(param2);
         var _loc6_:RectButton = new RectButton(_loc5_,RectButton.h56);
         _loc6_.addClickListener(this.onClick);
         add(new VBox(new <VComponent>[new VText(Lang.getString("buy_last_army"),VText.CENTER,Style.metalRGB,16).assignW(410),_loc4_,new VText(Lang.getString("buy_army"),VText.CENTER,Style.darkKhakiRGB,16).assignW(410),_loc6_],3,VBox.VERTICAL | VBox.CENTER),{
            "top":84,
            "hCenter":0,
            "bottom":26
         });
      }
      
      private function onClick(param1:MouseEvent = null) : void
      {
         var _loc2_:UserProxy = null;
         var _loc3_:VOBattleItem = null;
         if(ShopLogic.checkPrice(this.price,this.onClick))
         {
            ShopLogic.applyCostList(this.price,true);
            _loc2_ = Facade.userProxy;
            for each(_loc3_ in this.dp)
            {
               ActionLogic.request(PUserAction.MAKE_UNIT,PMakeUnit.create(_loc3_.shop.su_kind,_loc3_.count));
               _loc2_.soldierCountHash[_loc3_.shop.su_kind] += _loc3_.count;
               _loc2_.soldierCapacityCur += _loc3_.shop.su_hspace * _loc3_.count;
            }
            close();
            Facade.boardMediator.syncSelected(this.build);
         }
      }
   }
}

