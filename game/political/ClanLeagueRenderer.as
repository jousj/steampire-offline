package game.political
{
   import proto.model.PClanDivision;
   import proto.model.clan.PClan;
   import ui.Style;
   import ui.UIFactory;
   import ui.common.StatPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VButton;
   import ui.vbase.VComponent;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class ClanLeagueRenderer extends VRenderer
   {
      
      private const skin:VSkin = new VSkin();
      
      private const titleText:VText = UIFactory.createYellowText(null,VText.CENTER | VText.MIDDLE);
      
      private const statusSkin:VSkin = new VSkin();
      
      private const levelPanel:StatPanel = new StatPanel(SkinManager.getEmbed("TerritoryIcon"),null,StatPanel.YELLOW_TEXT,0,39,18);
      
      private const bt:VButton;
      
      private var btFilter:Array;
      
      private var selectList:Vector.<VComponent>;
      
      private var cacheNum:uint;
      
      private var cacheStatus:uint;
      
      public function ClanLeagueRenderer()
      {
         this.bt = VButton.create(SkinManager.getEmbed("ChBox",VSkin.STRETCH),{
            "wP":100,
            "hP":100
         },this.skin,{
            "left":3,
            "top":3
         },this.buttonChangeState);
         super();
         setSize(200,140);
         add(this.bt,{
            "left":5,
            "right":5,
            "hP":100
         });
         addSelectTriger(this.bt);
         add(this.statusSkin,{
            "left":-9,
            "top":20,
            "h":32
         });
         this.titleText.format.lineHeight = "100%";
         add(this.titleText,{
            "left":10,
            "right":10,
            "vCenter":40
         });
         this.levelPanel.useBg();
         this.levelPanel.useBg();
         add(this.levelPanel,{
            "top":10,
            "right":20,
            "w":60
         });
         this.levelPanel.mouseChildren = this.levelPanel.mouseEnabled = true;
         this.levelPanel.hint = Lang.getString("limit_territory");
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PClanDivision = param1 as PClanDivision;
         if(this.cacheNum != _loc2_.cd_num)
         {
            this.cacheNum = _loc2_.cd_num;
            SkinManager.applyExternal(this.skin,UIFactory.POLITICAL_PACK,"League_" + _loc2_.cd_region);
            this.levelPanel.value = Facade.manualProxy.getClanLeagueByNum(_loc2_.cd_num).cd_ter_limit;
            this.titleText.value = Lang.getString(_loc2_.cd_region);
         }
         var _loc3_:uint = 3;
         var _loc4_:PClan = Facade.userProxy.clanData;
         if(_loc4_)
         {
            if(_loc4_.base.division == this.cacheNum || _loc4_.townhall_level == 0 && this.cacheNum == 1)
            {
               _loc3_ = 1;
            }
            else if(_loc4_.base.division > this.cacheNum)
            {
               _loc3_ = 2;
            }
         }
         if(this.cacheStatus != _loc3_)
         {
            this.cacheStatus = _loc3_;
            if(_loc3_ != 1)
            {
               SkinManager.applyEmbed(this.statusSkin,_loc3_ == 3 ? "LockIcon" : "CollectIcon");
            }
            else
            {
               SkinManager.applyExternal(this.statusSkin,UIFactory.EMBLEM_PACK,_loc4_.base.icon);
            }
         }
      }
      
      override public function setSelected(param1:Boolean) : void
      {
         var _loc2_:VComponent = null;
         if(Boolean(this.selectList) != param1)
         {
            if(param1 && !this.bt.disabled)
            {
               this.selectList = new Vector.<VComponent>();
               this.addSelectSkin("RedPanelBg",{
                  "w":200,
                  "h":150,
                  "top":-4
               },0);
               this.addSelectSkin("Bolt",{
                  "w":14,
                  "left":-1,
                  "top":-5
               });
               this.addSelectSkin("Bolt",{
                  "w":14,
                  "right":-2,
                  "top":-5
               });
               this.addSelectSkin("Bolt",{
                  "w":14,
                  "left":-1,
                  "bottom":-6
               });
               this.addSelectSkin("Bolt",{
                  "w":14,
                  "right":-2,
                  "bottom":-6
               });
            }
            else
            {
               for each(_loc2_ in this.selectList)
               {
                  remove(_loc2_);
               }
               this.selectList = null;
            }
            this.bt.mouseEnabled = !param1 && !this.bt.disabled;
         }
      }
      
      private function addSelectSkin(param1:String, param2:Object, param3:int = -1) : void
      {
         var _loc4_:VSkin = SkinManager.getEmbed(param1,param3 < 0 ? 0 : VSkin.STRETCH);
         this.selectList.push(_loc4_);
         add(_loc4_,param2,param3);
      }
      
      private function buttonChangeState(param1:VButton, param2:uint) : void
      {
         VButton.defaultButtonChangeState(param1,param2);
         if(param2 == VButton.OVER)
         {
            if(!this.btFilter)
            {
               this.btFilter = [Style.SELECT_FILTER];
            }
            param1.skin.filters = this.btFilter;
         }
         else
         {
            param1.skin.filters = null;
         }
      }
   }
}

