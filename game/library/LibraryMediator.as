package game.library
{
   import engine.signal.Signal;
   import engine.units.Build;
   import game.barrack.BarrackDialog;
   import game.common.DialogMediator;
   import game.feature.FeatureMediator;
   import logic.ActionLogic;
   import logic.UnitFactory;
   import model.ui.VOSpellItem;
   import proto.game.family_0010.PUserAction;
   import proto.model.PRequirement;
   import proto.model.PShopLibrary;
   import proto.model.PShopSpell;
   import ui.UIFactory;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   import ui.vbase.VGrid;
   import ui.vbase.VSkin;
   
   public class LibraryMediator extends DialogMediator
   {
      
      public var dialog:LibraryDialog;
      
      public var build:Build;
      
      private var spellList:Array;
      
      private var bookSize:uint;
      
      private var learnArrow:VSkin;
      
      private var isChange:Boolean;
      
      public function LibraryMediator(param1:Build)
      {
         super();
         this.build = param1;
      }
      
      override public function onAdd() : BaseDialog
      {
         var _loc2_:PShopSpell = null;
         var _loc3_:Array = null;
         var _loc4_:PShopLibrary = null;
         var _loc5_:VOSpellItem = null;
         var _loc6_:uint = 0;
         this.spellList = up.spellList;
         this.bookSize = mp.getLibraryShop(this.build.level).sl_book_size;
         var _loc1_:Array = [];
         for each(_loc2_ in mp.spellShopList)
         {
            if(_loc2_.ssp_level == 1 && _loc2_.ssp_can_buy)
            {
               _loc5_ = new VOSpellItem();
               _loc6_ = uint(up.soldierLevelHash[_loc2_.ssp_kind]);
               _loc5_.isLock = _loc6_ == 0;
               _loc5_.shop = _loc6_ > 1 ? mp.getSpellShop(_loc2_.ssp_kind,_loc6_) : _loc2_;
               _loc5_.order = _loc2_.ssp_upgrade_requirement.req_building_level;
               _loc1_.push(_loc5_);
            }
         }
         _loc1_.sort(this.buySort);
         _loc3_ = new Array(this.bookSize);
         for each(_loc4_ in mp.libraryShopList)
         {
            if(_loc4_.sl_level > this.build.level)
            {
               while(_loc3_.length < _loc4_.sl_book_size)
               {
                  _loc3_.push(PRequirement.create(this.build.shop.sb_kind,_loc4_.sl_level));
               }
            }
         }
         this.syncDp(_loc1_,_loc3_);
         this.dialog = new LibraryDialog(this.build.kind,this.build.level);
         this.dialog.buyGrid.setDataProvider(_loc1_);
         this.dialog.prodGrid.setDataProvider(_loc3_);
         this.dialog.prodGrid.addListener(VEvent.CHANGE,this.onProdChange);
         this.dialog.addListener(VEvent.VARIANCE,this.onVariance);
         return this.dialog;
      }
      
      override public function onRemove() : void
      {
         if(this.isChange)
         {
            UnitFactory.buildLogic.syncStatus(this.build);
         }
      }
      
      private function buySort(param1:VOSpellItem, param2:VOSpellItem) : Number
      {
         return param1.order - param2.order;
      }
      
      private function syncDp(param1:Array, param2:Array) : void
      {
         var _loc4_:VOSpellItem = null;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc3_:Boolean = this.spellList.length >= this.bookSize;
         for each(_loc4_ in param1)
         {
            _loc4_.isSelect = this.spellList.indexOf(_loc4_.shop.ssp_kind) >= 0;
            _loc4_.isLimit = _loc3_;
         }
         _loc5_ = 0;
         while(_loc5_ < this.bookSize)
         {
            param2[_loc5_] = 0;
            if(_loc5_ < this.spellList.length)
            {
               _loc6_ = this.spellList[_loc5_];
               for each(_loc4_ in param1)
               {
                  if(_loc4_.shop.ssp_kind == _loc6_)
                  {
                     param2[_loc5_] = _loc4_.shop;
                     break;
                  }
               }
            }
            _loc5_++;
         }
      }
      
      private function onVariance(param1:VEvent) : void
      {
         switch(param1.variance)
         {
            case BarrackDialog.INC:
               this.inc(param1.data);
               break;
            case BarrackDialog.DEC:
               this.removeSpell(param1.data);
               break;
            case BarrackDialog.INFO:
               Facade.mainMediator.showDialog(new FeatureMediator(param1.data));
               break;
            case BarrackDialog.CLEAR:
               this.help();
         }
      }
      
      private function inc(param1:VOSpellItem) : void
      {
         if(param1.isSelect)
         {
            this.removeSpell(param1.shop);
         }
         else
         {
            this.addSpell(param1.shop);
         }
      }
      
      private function addSpell(param1:PShopSpell) : void
      {
         if(this.spellList.length < this.bookSize && this.spellList.indexOf(param1.ssp_kind) < 0)
         {
            this.spellList.push(param1.ssp_kind);
            this.save();
         }
      }
      
      private function removeSpell(param1:PShopSpell) : void
      {
         var _loc2_:int = this.spellList.indexOf(param1.ssp_kind);
         if(_loc2_ >= 0)
         {
            this.spellList.splice(_loc2_,1);
            this.save();
         }
      }
      
      private function save() : void
      {
         this.isChange = true;
         this.syncDp(this.dialog.buyGrid.getDataProvider(),this.dialog.prodGrid.getDataProvider());
         this.dialog.buyGrid.sync();
         this.dialog.prodGrid.sync();
         this.removeLearnArrow();
         ActionLogic.request(PUserAction.SET_SPELLS,this.spellList);
      }
      
      private function help() : void
      {
         var _loc3_:VOSpellItem = null;
         if(this.learnArrow)
         {
            return;
         }
         var _loc1_:uint = 0;
         var _loc2_:VGrid = this.dialog.buyGrid;
         for each(_loc3_ in _loc2_.getDataProvider())
         {
            if(!_loc3_.isSelect && !_loc3_.isLock)
            {
               if(!_loc2_.checkShowIndex(_loc1_))
               {
                  _loc2_.sync(_loc1_);
               }
               this.learnArrow = UIFactory.createLearnArrow(0);
               this.learnArrow.useCenter(0,-40);
               _loc2_.renderList[_loc1_].add(this.learnArrow);
               Signal.delayCall(2,this.removeLearnArrow);
               break;
            }
            _loc1_++;
         }
      }
      
      private function removeLearnArrow() : void
      {
         if(this.learnArrow)
         {
            this.learnArrow.removeFromParent();
            this.learnArrow = null;
         }
      }
      
      private function onProdChange(param1:VEvent) : void
      {
         this.removeLearnArrow();
      }
   }
}

