package game.battle.raid
{
   import engine.units.Unit;
   import flash.events.MouseEvent;
   import game.board.DamageProgressBar;
   import game.history.SoldierHistoryRenderer;
   import model.vo.VORaidMember;
   import ui.UIFactory;
   import ui.common.StatPanel;
   import ui.game.CircleAvatarPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VGrid;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import utils.StringHelper;
   
   public class RaidMemberRenderer extends VRenderer
   {
      
      private const avatar:CircleAvatarPanel = new CircleAvatarPanel();
      
      private var arrowSkin:VSkin;
      
      private var soldierGrid:VGrid;
      
      private var soldierBg:VSkin;
      
      private var capacityStat:StatPanel;
      
      private var icon:VSkin;
      
      private var cacheId:String;
      
      private var cacheIconId:uint;
      
      private var cacheSoldierDp:Array;
      
      public var damageProgresBar:DamageProgressBar;
      
      public var item:VORaidMember;
      
      public function RaidMemberRenderer()
      {
         super();
         addChild(this.avatar);
         this.avatar.hCenter = 0;
         this.avatar.setSize(68,68);
         layoutW = this.avatar.layoutW;
         layoutH = this.avatar.layoutH + 23;
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:int = 0;
         this.item = param1 as VORaidMember;
         if(this.cacheId != this.item.id)
         {
            this.cacheId = this.item.id;
            this.avatar.setUser(this.item.ub,this.item.num);
            this.avatar.hint = StringHelper.addCDATA(this.item.ub.name) + StringHelper.getTLFImage("lib,Exp",20,1,null,6) + this.item.ub.level;
         }
         if(this.item.losing || this.item.sim)
         {
            if(!this.icon)
            {
               this.icon = new VSkin(VSkin.BOTTOM);
               add(this.icon,{
                  "bottom":0,
                  "hCenter":0,
                  "w":40,
                  "h":36
               });
            }
            if(this.item.losing)
            {
               if(this.cacheIconId != 1)
               {
                  SkinManager.applyEmbed(this.icon,"SurrenderIcon");
                  this.cacheIconId = 1;
               }
            }
            else if(this.cacheIconId != 2)
            {
               SkinManager.applyEmbed(this.icon,"BattleSimIcon");
               this.cacheIconId = 2;
            }
            if(this.capacityStat)
            {
               remove(this.capacityStat);
               this.capacityStat = null;
            }
            if(this.arrowSkin)
            {
               this.hideArrow();
            }
         }
         else
         {
            if(this.icon)
            {
               remove(this.icon);
               this.icon = null;
            }
            if(!this.capacityStat && !this.damageProgresBar)
            {
               this.capacityStat = new StatPanel(SkinManager.getEmbed("HumanIcon"),null,StatPanel.YELLOW_TEXT,2,22,16);
               add(this.capacityStat,{
                  "hCenter":0,
                  "bottom":12
               });
            }
            _loc2_ = this.item.maxCapacity - this.item.dropCapacity;
            if((this.item.num >= 2 && (_loc2_ > 0 || this.item.spellCount > 0)) != Boolean(this.arrowSkin))
            {
               if(this.arrowSkin)
               {
                  this.hideArrow();
               }
               else
               {
                  this.showArrow();
               }
            }
            if(Boolean(this.capacityStat) && Boolean(this.capacityStat.cacheValue != _loc2_) || this.item.soldierDp != this.cacheSoldierDp)
            {
               if(this.soldierGrid)
               {
                  if(this.item.soldierDp != this.cacheSoldierDp)
                  {
                     this.soldierGrid.setDataProvider(this.item.soldierDp);
                  }
                  else
                  {
                     this.soldierGrid.sync();
                  }
                  if(this.soldierBg.layoutH != this.soldierGrid.measuredHeight + 10)
                  {
                     this.soldierBg.layoutH = this.soldierGrid.measuredHeight + 10;
                     this.soldierBg.syncLayout();
                  }
               }
               this.capacityStat.value = _loc2_;
               this.cacheSoldierDp = this.item.soldierDp;
            }
         }
      }
      
      private function hideArrow() : void
      {
         removeListener(MouseEvent.CLICK,this.onClick);
         remove(this.arrowSkin);
         this.arrowSkin = null;
         buttonMode = false;
         if(this.soldierGrid)
         {
            this.onClick();
         }
      }
      
      public function initDamageProgress(param1:Unit) : void
      {
         this.damageProgresBar = new DamageProgressBar();
         this.damageProgresBar.assignHeroState(param1);
         add(this.damageProgresBar,{
            "bottom":15,
            "hCenter":0,
            "h":15
         });
         if(this.capacityStat)
         {
            remove(this.capacityStat);
            this.capacityStat = null;
         }
      }
      
      private function showArrow() : void
      {
         this.arrowSkin = SkinManager.getEmbed("GreenArrow",VSkin.FLIP_Y);
         add(this.arrowSkin,{
            "bottom":0,
            "hCenter":0
         });
         addListener(MouseEvent.CLICK,this.onClick);
         buttonMode = true;
      }
      
      private function onClick(param1:MouseEvent = null) : void
      {
         if(Boolean(param1) && param1.target is VButton)
         {
            return;
         }
         if(this.soldierGrid)
         {
            remove(this.soldierGrid);
            this.soldierGrid = null;
            remove(this.soldierBg);
            this.soldierBg = null;
         }
         else
         {
            this.soldierBg = SkinManager.getEmbed("RaidPartyBg",VSkin.STRETCH | VSkin.ROTATE_90);
            this.soldierGrid = new VGrid(1,4,SoldierHistoryRenderer,this.cacheSoldierDp,0,0,VGrid.USE_VISIBLE_CALC_LAYOUT | VGrid.USE_END_LIMIT);
            UIFactory.useGridControlNav(this.soldierGrid,this.addNavBt);
            add(this.soldierBg,{
               "w":78,
               "h":this.soldierGrid.measuredHeight + 10,
               "top":h,
               "hCenter":0
            });
            add(this.soldierGrid,{
               "top":h + 6,
               "hCenter":0
            });
         }
         if(this.arrowSkin)
         {
            this.arrowSkin.setMode(this.soldierGrid ? 0 : VSkin.FLIP_Y);
         }
      }
      
      private function addNavBt(param1:VGrid, param2:VButton, param3:VButton) : void
      {
         param1.add(param2,{
            "w":16,
            "h":25,
            "bottom":-30,
            "hCenter":-10
         });
         param1.add(param3,{
            "w":16,
            "h":25,
            "bottom":-30,
            "hCenter":10
         });
      }
   }
}

