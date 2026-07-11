package game.friends
{
   import proto.model.PAskData;
   import proto.model.PCost;
   import proto.model.PTownhallUnlock;
   import proto.model.PUserBase;
   import ui.UIFactory;
   import ui.common.AvatarLoader;
   import ui.common.DurationPanel;
   import ui.common.LevelPanel;
   import ui.common.RectButton;
   import ui.game.PricePanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VRenderer;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class FriendRenderer extends VRenderer
   {
      
      private const bg:VSkin = new VSkin(VSkin.STRETCH_BG);
      
      private const nameText:VText = UIFactory.createYellowText(null,VText.CENTER | VText.MIDDLE,16);
      
      private const avatar:AvatarLoader = new AvatarLoader(true);
      
      private var type:String;
      
      private var bt:RectButton;
      
      private var levelPanel:LevelPanel;
      
      private var clanSkin:VSkin;
      
      private var isCacheApp:Boolean;
      
      private var requestPanel:VComponent;
      
      public function FriendRenderer(param1:String = null)
      {
         super();
         this.type = param1;
         setSize(184,226);
         add(this.bg,{
            "w":148,
            "h":148,
            "hCenter":0,
            "top":40
         });
         add(this.avatar,{
            "w":140,
            "h":140,
            "hCenter":0,
            "top":44
         });
         add(this.nameText,{
            "left":-2,
            "right":-2,
            "h":36
         });
      }
      
      private function syncBt(param1:Boolean) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1)
         {
            _loc2_ = RectButton.GREEN;
            _loc3_ = "ChBox";
            _loc4_ = this.type ? this.type : "to_friend";
         }
         else
         {
            _loc2_ = RectButton.ORANGE;
            _loc3_ = "ChBoxGold";
            _loc4_ = "call_friend";
         }
         if(!this.bt)
         {
            this.bt = new RectButton(Lang.getString(_loc4_),RectButton.h30,_loc2_);
            this.bt.addVarianceListener(this,0);
            add(this.bt,{
               "bottom":0,
               "hCenter":0,
               "minW":120,
               "maxW":178
            });
         }
         else
         {
            SkinManager.applyEmbed(this.bt.skin as VSkin,_loc2_ + RectButton.H30);
            this.bt.title = Lang.getString(_loc4_);
         }
         SkinManager.applyEmbed(this.bg,_loc3_);
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:PUserBase = param1 as PUserBase;
         this.avatar.load(_loc2_.avatar);
         this.nameText.value = _loc2_.name;
         var _loc3_:Boolean = _loc2_.level > 0;
         if(this.isCacheApp != _loc3_ || !this.bt)
         {
            this.syncBt(_loc3_);
            this.isCacheApp = _loc3_;
         }
         this.bt.data = _loc2_;
         if(_loc3_)
         {
            if(!this.levelPanel)
            {
               this.levelPanel = new LevelPanel(LevelPanel.size34);
               add(this.levelPanel,{
                  "top":48,
                  "right":4
               });
            }
            else
            {
               this.levelPanel.visible = true;
            }
            this.levelPanel.changeSNetwork(_loc2_.snetwork);
            this.levelPanel.value = _loc2_.level;
         }
         else if(this.levelPanel)
         {
            this.levelPanel.visible = false;
         }
         if(_loc2_.clan)
         {
            if(!this.clanSkin)
            {
               this.clanSkin = new VSkin();
               this.clanSkin.mouseEnabled = true;
               add(this.clanSkin,{
                  "w":34,
                  "top":90,
                  "right":4
               });
            }
            else
            {
               this.clanSkin.visible = true;
            }
            SkinManager.applyExternal(this.clanSkin,UIFactory.EMBLEM_PACK,_loc2_.clan.uc_icon);
            this.clanSkin.hint = _loc2_.clan.uc_name;
         }
         else if(this.clanSkin)
         {
            this.clanSkin.visible = false;
         }
         if(this.type == FriendsMediator.REQUEST)
         {
            this.syncRequestData(_loc2_.ratio,_loc2_.units);
         }
      }
      
      private function syncRequestData(param1:uint, param2:Array) : void
      {
         if(param1 == PAskData.ASK_CRYSTAL || param1 == PAskData.ASK_OIL || param1 == PAskData.ASK_CALL)
         {
            if(!this.requestPanel)
            {
               this.requestPanel = new PricePanel(24,16,PricePanel.GLOW_B_FILTER);
               add(this.requestPanel,{
                  "bottom":32,
                  "hCenter":0
               });
            }
            (this.requestPanel as PricePanel).assign(param1 == PAskData.ASK_CRYSTAL ? PCost.CRYSTAL : (param1 == PAskData.ASK_OIL ? PCost.OIL : PCost.CALL),this.getRequestValue(param1,param2));
         }
         else
         {
            if(!this.requestPanel)
            {
               this.requestPanel = new DurationPanel(24,16,3,true);
               add(this.requestPanel,{
                  "bottom":32,
                  "hCenter":0
               });
            }
            (this.requestPanel as DurationPanel).setStaticTime(this.getRequestValue(param1,param2));
         }
      }
      
      private function getRequestValue(param1:uint, param2:Array) : int
      {
         if(param2)
         {
            if(param1 == PAskData.ASK_CRYSTAL)
            {
               param1 = 0;
            }
            else if(param1 == PAskData.ASK_OIL)
            {
               param1 = 1;
            }
            else if(param1 == PAskData.ASK_CALL)
            {
               param1 = 2;
            }
            else
            {
               param1 = 3;
            }
            return param2[param1];
         }
         var _loc3_:PTownhallUnlock = Facade.manualProxy.getTownHallUnlock();
         if(param1 == PAskData.ASK_CRYSTAL)
         {
            return _loc3_.tu_req_crystal;
         }
         if(param1 == PAskData.ASK_OIL)
         {
            return _loc3_.tu_req_oil;
         }
         if(param1 == PAskData.ASK_CALL)
         {
            return _loc3_.tu_req_call;
         }
         return _loc3_.tu_req_time;
      }
   }
}

