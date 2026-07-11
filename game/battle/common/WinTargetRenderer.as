package game.battle.common
{
   import flash.events.MouseEvent;
   import model.ui.VOWinItem;
   import proto.model.PMissionWin;
   import ui.Style;
   import ui.UIFactory;
   import ui.game.UnitClipPanel;
   import ui.game.UnitPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VEvent;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class WinTargetRenderer extends VRenderer
   {
      
      private var unitPanel:UnitPanel;
      
      private var text:VText;
      
      private var bgSkin:VSkin;
      
      private var cacheCount:uint = 10000;
      
      private var cacheCollect:uint;
      
      private var collectSkin:VSkin;
      
      private var clipPanel:UnitClipPanel;
      
      private var item:VOWinItem;
      
      public function WinTargetRenderer()
      {
         super();
         mouseChildren = false;
         setSize(80,80);
         addListener(MouseEvent.CLICK,this.onClick);
         cacheAsBitmap = true;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         dispatcher.dispatchEvent(new VEvent(VEvent.SELECT,this.item));
      }
      
      override public function setData(param1:Object) : void
      {
         if(this.item != param1)
         {
            this.item = param1 as VOWinItem;
            if(this.item.info.mw_kind.indexOf("un_") == 0 && !(this is WinTargetAfterRenderer))
            {
               this.useSoldierMode(this.item.info);
            }
            else
            {
               this.useConstructionMode(this.item.info);
               this.cacheCount = uint.MAX_VALUE;
            }
            hint = Lang.getString(this.item.info.mw_kind);
         }
         var _loc2_:Boolean = this.item.count == 0;
         if(_loc2_ != Boolean(this.collectSkin))
         {
            if(_loc2_)
            {
               this.collectSkin = SkinManager.getEmbed("CollectIcon");
               add(this.collectSkin,{
                  "top":2,
                  "right":-4,
                  "w":38,
                  "h":33
               });
            }
            else
            {
               remove(this.collectSkin);
               this.collectSkin = null;
            }
         }
         var _loc3_:uint = _loc2_ ? 1 : 2;
         if(_loc3_ != this.cacheCollect)
         {
            this.cacheCollect = _loc3_;
            mouseEnabled = buttonMode = !_loc2_;
            if(this.bgSkin)
            {
               SkinManager.applyEmbed(this.bgSkin,_loc2_ ? "TargetBgCleared" : "TargetBg");
            }
         }
         if(Boolean(this.text) && this.item.count != this.cacheCount)
         {
            this.cacheCount = this.item.count;
            this.text.value = this.item.info.mw_count - this.cacheCount + "/" + this.item.info.mw_count;
         }
      }
      
      private function useConstructionMode(param1:PMissionWin) : void
      {
         if(this.clipPanel)
         {
            remove(this.clipPanel);
            this.clipPanel = null;
         }
         if(!this.unitPanel)
         {
            this.bgSkin = new VSkin();
            add(this.bgSkin,{
               "hCenter":0,
               "vCenter":0
            });
            this.unitPanel = new UnitPanel(UnitPanel.SKIP_BG,this.item.info.mw_kind.indexOf("un_") == 0 ? UnitPanel.winTarget80W : UnitPanel.winTarget80);
            addChild(this.unitPanel);
            this.text = UIFactory.createYellowText(null,VText.CONTAIN_CENTER,20,true);
            add(this.text,{
               "wP":100,
               "bottom":4
            });
         }
         this.unitPanel.show(param1.mw_kind,param1.mw_level);
      }
      
      private function useSoldierMode(param1:PMissionWin) : void
      {
         if(this.unitPanel)
         {
            remove(this.unitPanel);
            this.unitPanel = null;
            remove(this.bgSkin);
            this.bgSkin = null;
            if(this.item.info.mw_count < 2)
            {
               remove(this.text);
               this.text = null;
            }
            this.cacheCollect = 0;
         }
         if(!this.clipPanel)
         {
            this.clipPanel = new UnitClipPanel();
            this.clipPanel.filters = [Style.CONFLICT_FILTER];
            addStretch(this.clipPanel);
         }
         if(param1.mw_kind.indexOf("un_raid") != -1)
         {
            this.clipPanel.show(param1.mw_kind.replace("raid","boss"),1);
         }
         else
         {
            this.clipPanel.show(param1.mw_kind,Facade.manualProxy.getSoldierShop(param1.mw_kind,param1.mw_level).su_model_level);
         }
      }
   }
}

