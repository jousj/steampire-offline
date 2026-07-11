package game.my
{
   import engine.signal.Signal;
   import flash.events.MouseEvent;
   import proto.model.clan.PWar;
   import ui.UIFactory;
   import ui.common.CircleButton;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class StormStatusPanel extends VComponent
   {
      
      public static const CLAN_WAR:int = 0;
      
      public static const TERRITORY:int = 1;
      
      public static const MY_STORM:int = 2;
      
      public static const ENEMY_STORM:int = 3;
      
      private const bt:CircleButton = new CircleButton(new VSkin(VSkin.CACHE_AS_BITMAP),"BtOrange2");
      
      private const stateList:Vector.<int> = new Vector.<int>();
      
      private var decorText:VComponent;
      
      private var signal:Signal;
      
      private var curStatus:int = -1;
      
      private var damageText:VText;
      
      public function StormStatusPanel()
      {
         super();
         layoutH = 77;
         addStretch(SkinManager.getEmbed("StatusBg",VSkin.STRETCH_BG));
         this.bt.icon.setSize(46,46);
         this.bt.addVarianceListener(this,0);
         add(this.bt,{
            "right":5,
            "vCenter":0,
            "w":67,
            "h":68
         });
      }
      
      private function setStatusMode(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         this.curStatus = param1;
         switch(param1)
         {
            case TERRITORY:
               _loc2_ = "storm_list";
               _loc3_ = "storm_list_go";
               _loc4_ = "MapIcon";
               break;
            case MY_STORM:
               _loc2_ = "help_attack";
               _loc3_ = "war_attack_go";
               _loc4_ = "EliteIcon";
               break;
            case ENEMY_STORM:
               _loc2_ = "war_defence_go";
               _loc3_ = "war_defence_go";
               _loc4_ = "DamageIcon";
               break;
            default:
               _loc2_ = "war_begin";
               _loc3_ = "to_war_tab";
               _loc4_ = "MoralIcon";
         }
         if(this.decorText)
         {
            remove(this.decorText);
         }
         this.decorText = UIFactory.createDecorText(Lang.getString(_loc2_),true,22,180);
         add(this.decorText,{
            "left":12,
            "right":83,
            "vCenter":3
         });
         SkinManager.applyEmbed(this.bt.icon as VSkin,_loc4_);
         this.bt.variance = param1;
         this.bt.hint = Lang.getString(_loc3_);
         if(Boolean(this.damageText) && param1 == ENEMY_STORM != Boolean(this.damageText.parent))
         {
            if(param1 == ENEMY_STORM)
            {
               this.bt.add(this.damageText);
            }
            else
            {
               this.bt.remove(this.damageText,false);
            }
         }
      }
      
      public function sync(param1:PWar, param2:Boolean, param3:int) : void
      {
         var _loc5_:Boolean = false;
         this.stateList.length = 0;
         if(param2)
         {
            this.stateList.push(TERRITORY);
         }
         if(param1)
         {
            this.stateList.push(CLAN_WAR);
            if(!isNaN(param1.war_my_storm) || param1.war_points == Facade.references.wp_storm_req)
            {
               this.stateList.push(MY_STORM);
            }
            _loc5_ = !isNaN(param1.war_storm);
         }
         else if(!param2)
         {
            this.stateList.push(CLAN_WAR);
         }
         if(_loc5_ != Boolean(this.damageText))
         {
            if(_loc5_)
            {
               this.damageText = UIFactory.createYellowText(null);
               this.damageText.hCenter = 0;
               this.damageText.bottom = 8;
            }
            else
            {
               this.damageText.removeFromParent();
               this.damageText = null;
            }
         }
         if(_loc5_)
         {
            this.stateList.push(ENEMY_STORM);
            this.damageText.value = param1.war_enemy_damage + "%";
         }
         if(param3 < 0)
         {
            param3 = param2 ? TERRITORY : CLAN_WAR;
         }
         if(this.curStatus != param3)
         {
            this.setStatusMode(param3);
         }
         var _loc4_:Boolean = this.stateList.length > 0;
         if(_loc4_)
         {
            if(!this.signal)
            {
               this.signal = new Signal(this.onSignal);
               this.signal.delay = 15;
            }
            this.signal.data = this.stateList.indexOf(this.curStatus);
            this.signal.run(0,Number.MAX_VALUE);
         }
         else
         {
            this.clear();
         }
         if(_loc4_ != hasEventListener(MouseEvent.ROLL_OVER))
         {
            if(_loc4_)
            {
               addListener(MouseEvent.ROLL_OVER,this.onRoll);
               addListener(MouseEvent.ROLL_OUT,this.onRoll);
            }
            else
            {
               removeListener(MouseEvent.ROLL_OVER,this.onRoll);
               removeListener(MouseEvent.ROLL_OUT,this.onRoll);
            }
         }
      }
      
      private function onSignal() : void
      {
         var _loc1_:int = this.signal.data + 1;
         if(_loc1_ >= this.stateList.length)
         {
            _loc1_ = 0;
         }
         this.signal.data = _loc1_;
         this.setStatusMode(this.stateList[_loc1_]);
      }
      
      public function clear() : void
      {
         if(this.signal)
         {
            this.signal.stop();
         }
      }
      
      override public function dispose() : void
      {
         this.clear();
         super.dispose();
      }
      
      private function onRoll(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            this.signal.stop();
         }
         else
         {
            this.signal.run(0,Number.MAX_VALUE);
         }
      }
   }
}

