package game.political
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import proto.model.PClanDivision;
   import proto.model.clan.PClan;
   import ui.UIFactory;
   import ui.common.TabPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class PoliticalMapDialog extends VComponent
   {
      
      public static const TO_TOPS:uint = 1;
      
      public static const TO_DONATE:uint = 2;
      
      public static const TO_LEAGUE:uint = 3;
      
      public static const TO_CLAN:uint = 4;
      
      public var shape:Shape;
      
      public var tabPanel:TabPanel;
      
      public var mapSkin:VSkin;
      
      public var mapPanel:VComponent;
      
      public var curDivision:PClanDivision;
      
      private var minScrollX:Number = 0;
      
      private var minScrollY:Number = 0;
      
      private var movePoint:Point;
      
      private var isListener:Boolean;
      
      private var lockSkin:VSkin;
      
      private var loadMapText:VText;
      
      private var selectSkin:VSkin;
      
      private var controlPanel:VComponent = new VComponent();
      
      public function PoliticalMapDialog()
      {
         super();
      }
      
      public function initStart(param1:Function) : void
      {
         setSize(946,657);
         var _loc2_:VSkin = SkinManager.getPack(UIFactory.POLITICAL_PACK,"Bg",0,0,param1);
         if(_loc2_.isContent)
         {
            param1(null);
         }
      }
      
      public function initEnd(param1:uint) : void
      {
         var _loc2_:Shape = null;
         this.mapPanel = new VComponent();
         this.mapPanel.setSize(100,100);
         add(this.mapPanel,null,0);
         _loc2_ = new Shape();
         _loc2_.graphics.beginFill(16711680);
         _loc2_.graphics.moveTo(10,0);
         _loc2_.graphics.lineTo(725,0);
         _loc2_.graphics.lineTo(725,609);
         _loc2_.graphics.lineTo(12,609);
         _loc2_.graphics.lineTo(0,597);
         _loc2_.graphics.lineTo(0,10);
         _loc2_.graphics.lineTo(10,0);
         _loc2_.graphics.endFill();
         _loc2_.x = 12;
         _loc2_.y = 24;
         addChild(_loc2_);
         this.mapPanel.mask = _loc2_;
         this.shape = new Shape();
         add(this.controlPanel,{
            "right":0,
            "w":250,
            "h":630,
            "top":20
         });
         this.controlPanel.addStretch(SkinManager.getEmbed("DialogBg",VSkin.STRETCH));
         this.tabPanel = new TabPanel(2,true,2);
         this.tabPanel.box.hCenter = 0;
         this.tabPanel.init(new <String>[Lang.getString("clan_my"),Lang.getString("regions")],param1);
         this.tabPanel.getTab(1).layoutW = this.tabPanel.getTab(0).layoutW = 110;
         this.controlPanel.add(this.tabPanel,{
            "top":15,
            "left":2,
            "right":2
         });
         addListener(MouseEvent.MOUSE_DOWN,this.onDown,this.mapPanel);
      }
      
      public function setMap(param1:PClanDivision, param2:Point) : void
      {
         this.curDivision = param1;
         if(this.mapSkin)
         {
            this.mapPanel.remove(this.mapSkin);
         }
         this.mapSkin = SkinManager.getPack(UIFactory.POLITICAL_PACK,"map_" + param1.cd_region);
         this.mapSkin.x = 12;
         this.mapSkin.y = 24;
         this.mapPanel.addChildAt(this.mapSkin,0);
         this.minScrollX = 707 - this.mapSkin.measuredWidth + 1;
         if(this.minScrollX > 0)
         {
            this.minScrollX = 0;
         }
         this.minScrollY = 615 - this.mapSkin.measuredHeight;
         if(this.minScrollY > 0)
         {
            this.minScrollY = 0;
         }
         if(param2)
         {
            this.applyMove(param2.x,param2.y);
         }
         else
         {
            this.mapPanel.x = Math.floor(this.minScrollX / 2);
            this.mapPanel.y = Math.floor(this.minScrollY / 2);
         }
         this.syncLockIcon(param1.cd_num);
         if(!this.loadMapText)
         {
            this.loadMapText = UIFactory.createYellowText(Lang.getString("load_title"),0,22);
            this.loadMapText.maxW = 500;
            this.loadMapText.useCenter(-120);
         }
         if(!this.loadMapText.parent)
         {
            add(this.loadMapText);
            this.shape.graphics.clear();
         }
      }
      
      public function endMapLoad() : void
      {
         if(this.loadMapText)
         {
            remove(this.loadMapText,false);
         }
         this.mapPanel.addChild(this.shape);
         if(!this.selectSkin)
         {
            this.selectSkin = SkinManager.getPack(UIFactory.POLITICAL_PACK,"AreaBorderSelect");
            this.selectSkin.visible = false;
         }
         this.selectSkin.width = TerritoryPanel.cellWidth + 2;
         this.selectSkin.height = TerritoryPanel.cellHeight + 2;
         this.mapPanel.addChild(this.selectSkin);
      }
      
      public function syncLockIcon(param1:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:PClan = Facade.userProxy.clanData;
         if(_loc2_)
         {
            _loc4_ = uint(_loc2_.base.division);
            if(_loc4_ == 0)
            {
               _loc4_ = 1;
            }
         }
         var _loc3_:Boolean = _loc4_ < param1;
         if(_loc3_ != Boolean(this.lockSkin))
         {
            if(_loc3_)
            {
               this.lockSkin = SkinManager.getEmbed("LockIcon");
               add(this.lockSkin,{
                  "left":-26,
                  "top":80,
                  "h":64
               });
            }
            else
            {
               remove(this.lockSkin);
               this.lockSkin = null;
            }
         }
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         if(this.minScrollX != 0 || this.minScrollY != 0)
         {
            if(!this.movePoint)
            {
               this.movePoint = new Point();
            }
            this.movePoint.x = param1.stageX;
            this.movePoint.y = param1.stageY;
            this.setListener(true);
         }
      }
      
      private function onUp(param1:Event) : void
      {
         this.setListener(false);
      }
      
      private function setListener(param1:Boolean) : void
      {
         if(this.isListener != param1)
         {
            this.isListener = param1;
            if(param1)
            {
               Facade.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
               Facade.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUp);
               Facade.stage.addEventListener(Event.MOUSE_LEAVE,this.onUp);
            }
            else
            {
               Facade.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
               Facade.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
               Facade.stage.removeEventListener(Event.MOUSE_LEAVE,this.onUp);
               this.mapPanel.mouseChildren = true;
            }
         }
      }
      
      private function onMove(param1:MouseEvent) : void
      {
         if(this.mapPanel.mouseChildren)
         {
            this.mapPanel.mouseChildren = false;
         }
         var _loc2_:Number = param1.stageX;
         var _loc3_:Number = param1.stageY;
         this.applyMove(this.mapPanel.x + (_loc2_ - this.movePoint.x),this.mapPanel.y + (_loc3_ - this.movePoint.y));
         this.movePoint.x = _loc2_;
         this.movePoint.y = _loc3_;
      }
      
      private function applyMove(param1:Number, param2:Number) : void
      {
         if(param1 > 0)
         {
            param1 = 0;
         }
         else if(param1 < this.minScrollX)
         {
            param1 = this.minScrollX;
         }
         this.mapPanel.x = param1;
         if(param2 > 0)
         {
            param2 = 0;
         }
         else if(param2 < this.minScrollY)
         {
            param2 = this.minScrollY;
         }
         this.mapPanel.y = param2;
      }
      
      public function changeSelect(param1:TerritoryPanel) : void
      {
         if(param1)
         {
            this.selectSkin.visible = true;
            --param1.x;
            --param1.y;
         }
         else
         {
            this.selectSkin.visible = false;
         }
      }
      
      override public function dispose() : void
      {
         this.setListener(false);
         super.dispose();
      }
      
      public function updateMapSize(param1:int, param2:int) : void
      {
         if(this.mapSkin.width / this.mapSkin.height > param1 / param2)
         {
            this.mapSkin.layoutH = param2;
         }
         else
         {
            this.mapSkin.layoutW = param1;
         }
         this.mapSkin.geometryPhase();
         this.minScrollX = 707 - this.mapSkin.measuredWidth + 1;
         if(this.minScrollX > 0)
         {
            this.minScrollX = 0;
         }
         this.minScrollY = 615 - this.mapSkin.measuredHeight;
         if(this.minScrollY > 0)
         {
            this.minScrollY = 0;
         }
         this.mapPanel.x = Math.floor(this.minScrollX / 2);
         this.mapPanel.y = Math.floor(this.minScrollY / 2);
      }
   }
}

