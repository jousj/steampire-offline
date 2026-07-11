package game.political
{
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.DropShadowFilter;
   import logic.CoreLogic;
   import proto.model.PShopMine;
   import proto.model.PShopTerritory;
   import proto.model.clan.PTerritory;
   import proto.model.clan.PTerritoryAttacker;
   import proto.model.clan.PTerritoryState;
   import ui.UIFactory;
   import ui.common.LevelPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import utils.CostHelper;
   import utils.StringHelper;
   
   public class TerritoryPanel extends VButton
   {
      
      public static const factor:Number = 100 / 122;
      
      public static const cellWidth:Number = 122 * factor;
      
      public static const cellHeight:Number = 142 * factor;
      
      public var geomX:int;
      
      public var geomY:int;
      
      public var env:PTerritory;
      
      private const bg:VSkin = new VSkin();
      
      private var levelPanel:LevelPanel;
      
      private var emblemComponent:VComponent;
      
      private var shieldSkin:VSkin;
      
      private var clockSkin:VSkin;
      
      private var bgSuperBorder:Shape;
      
      private var border:VSkin = SkinManager.getPack(UIFactory.POLITICAL_PACK,"AreaBorder");
      
      private var maskShape:Shape = new Shape();
      
      public function TerritoryPanel()
      {
         super();
         mouseChildren = false;
         buttonMode = true;
         cacheAsBitmap = true;
         setSize(cellWidth,cellHeight);
         add(this.bg,{
            "left":0,
            "top":0,
            "right":0,
            "bottom":0
         });
         SkinManager.applyExternal(this.bg,UIFactory.POLITICAL_PACK,"AreaBg");
         addChild(this.maskShape);
         this.maskShape.x = cellWidth / 2;
         this.maskShape.y = cellHeight / 2;
      }
      
      public function set level(param1:uint) : void
      {
         var _loc2_:Boolean = param1 > 1;
         if(_loc2_ != Boolean(this.levelPanel))
         {
            if(_loc2_)
            {
               this.levelPanel = new LevelPanel(LevelPanel.size34);
               add(this.levelPanel,{
                  "right":16,
                  "top":22
               });
            }
            else
            {
               remove(this.levelPanel);
               this.levelPanel = null;
            }
         }
         if(_loc2_)
         {
            this.levelPanel.value = param1;
         }
      }
      
      private function getEmblemSkin(param1:String) : VSkin
      {
         var _loc2_:VSkin = new VSkin();
         _loc2_.setSize(56,56);
         if(param1)
         {
            SkinManager.applyExternal(_loc2_,UIFactory.EMBLEM_PACK,param1,SkinManager.LOAD_CLIP);
         }
         else
         {
            SkinManager.applyEmbed(_loc2_,"MapIcon");
         }
         return _loc2_;
      }
      
      public function assign(param1:PTerritory) : void
      {
         var _loc11_:PTerritoryAttacker = null;
         this.env = param1;
         this.level = param1.level;
         var _loc2_:PShopTerritory = Facade.manualProxy.getTerritoryShop(param1.kind);
         var _loc3_:PShopMine = Facade.manualProxy.getMineShop(_loc2_.ter_region,param1.level);
         var _loc4_:Array = _loc2_.ter_resource_cost;
         _loc4_ = CostHelper.getCostMul(_loc4_,60 * 60 * 24 / _loc2_.ter_resource_time / _loc3_.mine_time_k);
         hint = StringHelper.getUnitName(param1.kind,param1.level);
         if(param1.clan_owner)
         {
            hint += "\n" + Lang.getPatternString("clan_owner","__CLAN__",StringHelper.getTLFImage(SkinManager.getTLFSource(UIFactory.EMBLEM_PACK,0,param1.clan_owner.to_clan_icon),22) + " " + StringHelper.addCDATA(param1.clan_owner.to_clan_name));
         }
         var _loc5_:uint = param1.state.variance;
         if(this.emblemComponent)
         {
            remove(this.emblemComponent);
         }
         var _loc6_:VSkin = this.getEmblemSkin(param1.clan_owner ? param1.clan_owner.to_clan_icon : null);
         if(_loc5_ == PTerritoryState.ATTACK)
         {
            _loc11_ = param1.state.value as PTerritoryAttacker;
            this.emblemComponent = new VComponent();
            this.emblemComponent.stretch();
            this.emblemComponent.setSize(84,84);
            this.emblemComponent.add(_loc6_);
            this.emblemComponent.add(this.getEmblemSkin(_loc11_.ta_clan_icon),{
               "right":0,
               "bottom":0
            });
            this.emblemComponent.add(UIFactory.createDecorText("VS",true,20),{
               "hCenter":0,
               "vCenter":0
            });
            hint += "\n" + Lang.getPatternString("clan_attacker","__CLAN__",StringHelper.getTLFImage(SkinManager.getTLFSource(UIFactory.EMBLEM_PACK,0,_loc11_.ta_clan_icon),22) + " " + StringHelper.addCDATA(_loc11_.ta_clan_name));
         }
         else
         {
            this.emblemComponent = _loc6_;
         }
         var _loc7_:int = getChildIndex(this.bg) + 1;
         add(this.emblemComponent,{
            "hCenter":0,
            "vCenter":0
         },_loc7_);
         this.emblemComponent.filters = [new DropShadowFilter(4,45,2233375,1.7,5,5,1,BitmapFilterQuality.HIGH)];
         hint += "<div> " + CostHelper.get18ListString(_loc4_,true) + "</div>";
         if(this.shieldSkin)
         {
            this.shieldSkin.visible = false;
         }
         if(this.clockSkin)
         {
            this.clockSkin.visible = false;
         }
         switch(_loc5_)
         {
            case PTerritoryState.COOLDOWN:
               if(_loc5_ == PTerritoryState.COOLDOWN)
               {
                  if(param1.state.value > CoreLogic.serverTime)
                  {
                     hint += "<div>" + Lang.getString("territory_shield_info") + StringHelper.getTimeDesc(param1.state.value - CoreLogic.serverTime) + "</div>";
                  }
               }
               if(this.shieldSkin)
               {
                  this.shieldSkin.visible = true;
                  break;
               }
               this.shieldSkin = SkinManager.getPack(UIFactory.POLITICAL_PACK,"Shield");
               add(this.shieldSkin,{
                  "right":16,
                  "bottom":30
               });
               break;
            case PTerritoryState.REG_ATTACK:
               if(this.clockSkin)
               {
                  this.clockSkin.visible = true;
                  break;
               }
               this.clockSkin = SkinManager.getEmbed("ClockIcon");
               add(this.clockSkin,{
                  "right":16,
                  "bottom":30
               });
         }
         hint += Lang.getString("tap_for_more");
         var _loc8_:Array = [1,3,4,3,2,4,0,5,3,5];
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         while(_loc10_ < _loc8_.length)
         {
            if(_loc2_.ter_position_0 == _loc8_[_loc10_] && _loc2_.ter_position_1 == _loc8_[_loc10_ + 1])
            {
               _loc9_ = true;
            }
            _loc10_ += 2;
         }
         if(_loc9_)
         {
            if(!this.bgSuperBorder)
            {
               this.bgSuperBorder = new Shape();
               this.createSuperBorder();
               addChildAt(this.bgSuperBorder,2);
            }
            this.bgSuperBorder.visible = true;
         }
         else if(this.bgSuperBorder)
         {
            this.bgSuperBorder.visible = false;
         }
      }
      
      public function setOwnerIndex(param1:int) : void
      {
         var _loc2_:MovieClip = this.bg.content as MovieClip;
         if(Boolean(_loc2_) && _loc2_.totalFrames > 0)
         {
            _loc2_.gotoAndStop(param1 <= _loc2_.totalFrames ? param1 : _loc2_.totalFrames);
         }
      }
      
      public function createSuperBorder() : void
      {
         this.bgSuperBorder.graphics.clear();
         var _loc1_:Number = cellHeight / 2 * Math.sin(Math.PI / 6);
         this.bgSuperBorder.graphics.lineStyle(5,15911452);
         this.bgSuperBorder.graphics.moveTo(0,-cellHeight / 2);
         this.bgSuperBorder.graphics.lineTo(cellWidth / 2,-_loc1_);
         this.bgSuperBorder.graphics.lineTo(cellWidth / 2,_loc1_);
         this.bgSuperBorder.graphics.lineTo(0,cellHeight / 2);
         this.bgSuperBorder.graphics.lineTo(-cellWidth / 2,_loc1_);
         this.bgSuperBorder.graphics.lineTo(-cellWidth / 2,-_loc1_);
         this.bgSuperBorder.graphics.lineTo(0,-cellHeight / 2);
         this.bgSuperBorder.scaleX = this.bgSuperBorder.scaleY = 0.8;
         this.bgSuperBorder.x = cellWidth / 2;
         this.bgSuperBorder.y = cellHeight / 2;
      }
      
      public function resetBorder() : void
      {
         this.maskShape.graphics.clear();
         var _loc1_:Number = cellHeight / 2 * Math.sin(Math.PI / 6);
         this.maskShape.graphics.lineStyle(2,0);
         this.maskShape.graphics.moveTo(0,-cellHeight / 2);
         this.maskShape.graphics.lineTo(cellWidth / 2,-_loc1_);
         this.maskShape.graphics.lineTo(cellWidth / 2,_loc1_);
         this.maskShape.graphics.lineTo(0,cellHeight / 2);
         this.maskShape.graphics.lineTo(-cellWidth / 2,_loc1_);
         this.maskShape.graphics.lineTo(-cellWidth / 2,-_loc1_);
         this.maskShape.graphics.lineTo(0,-cellHeight / 2);
      }
      
      public function setBorder(param1:int) : void
      {
         var _loc2_:Number = cellHeight / 2 * Math.sin(Math.PI / 6);
         this.maskShape.graphics.lineStyle(4,0);
         var _loc3_:Array = [0,-cellHeight / 2,cellWidth / 2,-_loc2_,cellWidth / 2,_loc2_,0,cellHeight / 2,-cellWidth / 2,_loc2_,-cellWidth / 2,-_loc2_,0,-cellHeight / 2];
         this.maskShape.graphics.moveTo(_loc3_[param1 * 2],_loc3_[param1 * 2 + 1]);
         this.maskShape.graphics.lineTo(_loc3_[param1 * 2 + 2],_loc3_[param1 * 2 + 3]);
      }
   }
}

