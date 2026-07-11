package game.clan.war
{
   import engine.signal.Signal;
   import game.common.DialogMediator;
   import logic.CoreLogic;
   import logic.DialogLogic;
   import logic.MainLogic;
   import proto.BinaryBuffer;
   import proto.game.family_0002.Packet_0002_01;
   import proto.game.family_0002.Packet_0002_02;
   import proto.model.clan.PTerritoryAttack;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.VComponent;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   
   public class StormTerritoryMediator extends DialogMediator
   {
      
      private const dialog:BaseDialog = new BaseDialog();
      
      private const grid:VGrid = new VGrid(1,3,StormTerritoryRenderer,null,0,5,VGrid.USE_VISIBLE_CALC_LAYOUT | VGrid.H_STRETCH);
      
      public function StormTerritoryMediator()
      {
         super();
      }
      
      override public function onAdd() : BaseDialog
      {
         this.dialog.useDefaultBg(0,Lang.getString("territory_list"));
         var _loc1_:Object = {
            "left":20,
            "right":20,
            "top":84,
            "bottom":30
         };
         this.dialog.add(this.grid,_loc1_);
         UIFactory.useGridControlNav(this.grid,UIFactory.addNavBt30);
         var _loc2_:VComponent = UIFactory.createLoadPanel(this.dialog,_loc1_);
         Facade.protoProxy.request(new Packet_0002_01(Packet_0002_01.CLAN_TERRITORIES_ATTACK,null),this.resultAttackList,2,2,[_loc2_]);
         return this.dialog;
      }
      
      private function resultAttackList(param1:BinaryBuffer, param2:VComponent) : void
      {
         var _loc4_:PTerritoryAttack = null;
         if(!this.dialog.parent)
         {
            return;
         }
         var _loc3_:Packet_0002_02 = new Packet_0002_02(param1);
         if(_loc3_.variance == Packet_0002_02.CLAN_TERRITORIES_ATTACK)
         {
            if(_loc3_.value.length > 0)
            {
               param2.removeFromParent();
               for each(_loc4_ in _loc3_.value)
               {
                  _loc4_.ta_is_my = Boolean(up.clan) && _loc4_.ta_clan_id == up.clan.uc_clan_id;
                  Signal.createRef(_loc4_,this.onSignal,0,0,false).delayEnd(_loc4_.ta_end_time);
               }
               this.grid.setDataProvider(_loc3_.value);
               this.grid.addListener(VEvent.VARIANCE,this.onVariance);
               return;
            }
            if(up.clanData)
            {
               up.clanData.active_territories = false;
               Facade.myMediator.syncStormStatus(up.clanData);
            }
         }
         this.dialog.close();
         Facade.mainMediator.showMessage(Lang.getString("territory_list_error"));
      }
      
      private function onVariance(param1:VEvent) : void
      {
         var _loc2_:uint = param1.variance;
         var _loc3_:PTerritoryAttack = param1.data as PTerritoryAttack;
         if(_loc2_ == StormTerritoryRenderer.GO)
         {
            MainLogic.getTerritoryStorm(_loc3_.ta_kind);
         }
         else if(_loc2_ == StormTerritoryRenderer.TERRITORY)
         {
            DialogLogic.openPoliticalMap(_loc3_.ta_kind);
            this.dialog.close();
         }
      }
      
      override public function onRemove() : void
      {
         var _loc1_:PTerritoryAttack = null;
         for each(_loc1_ in this.grid.getDataProvider())
         {
            Signal.stopRef(_loc1_);
         }
         super.onRemove();
      }
      
      private function onSignal() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:PTerritoryAttack = null;
         var _loc1_:Array = this.grid.getDataProvider();
         if(_loc1_.length > 1)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               _loc3_ = _loc1_[_loc2_];
               if(CoreLogic.serverTime >= _loc3_.ta_end_time)
               {
                  _loc1_.splice(_loc2_,1);
                  break;
               }
               _loc2_++;
            }
            this.grid.sync();
         }
         else
         {
            this.dialog.close();
         }
      }
   }
}

