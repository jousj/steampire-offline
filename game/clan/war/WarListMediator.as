package game.clan.war
{
   import game.common.DialogMediator;
   import logic.DialogLogic;
   import logic.MainLogic;
   import proto.BinaryBuffer;
   import proto.game.family_0060.Packet_0060_2B;
   import proto.game.family_0060.Packet_0060_2C;
   import proto.model.PWarTop;
   import ui.common.BaseDialog;
   import ui.vbase.VEvent;
   
   public class WarListMediator extends DialogMediator
   {
      
      public const panel:TopWarsPanel = new TopWarsPanel();
      
      private var toClanId:String;
      
      public function WarListMediator(param1:String)
      {
         super();
         this.toClanId = param1;
      }
      
      override public function onAdd() : BaseDialog
      {
         this.panel.assignLayout({
            "w":860,
            "h":580,
            "hCenter":0,
            "vCenter":0
         });
         this.panel.addListener(VEvent.VARIANCE,this.onVariance);
         this.panel.assign("load_title");
         Facade.protoProxy.request(new Packet_0060_2B(),this.resultTopWarsDp,96,44);
         return null;
      }
      
      private function resultTopWarsDp(param1:BinaryBuffer) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:* = 0;
         var _loc6_:PWarTop = null;
         if(!this.panel.stage)
         {
            return;
         }
         var _loc2_:Array = new Packet_0060_2C(param1).value;
         if(_loc2_.length == 0)
         {
            this.panel.assign("top_wars_empty");
         }
         else
         {
            if(Boolean(up.clanData) && Boolean(up.clanData.war))
            {
               _loc4_ = up.clanData.base.id;
               _loc5_ = int(_loc2_.length - 1);
               while(_loc5_ >= 0)
               {
                  _loc6_ = _loc2_[_loc5_];
                  if(_loc6_.wt_attacker.wti_id == _loc4_ || _loc6_.wt_target.wti_id == _loc4_)
                  {
                     _loc2_.splice(_loc5_,1);
                     break;
                  }
                  _loc5_--;
               }
            }
            _loc2_.sort(this.topWarsSort);
            _loc3_ = 0;
            if(this.toClanId)
            {
               _loc3_ = 0;
               _loc5_ = int(_loc2_.length - 1);
               while(_loc5_ >= 0)
               {
                  _loc6_ = _loc2_[_loc5_];
                  if(_loc6_.wt_attacker.wti_id == this.toClanId || _loc6_.wt_target.wti_id == this.toClanId)
                  {
                     _loc3_ = _loc5_;
                     break;
                  }
                  _loc5_--;
               }
               this.toClanId = null;
            }
            this.panel.assign(null,_loc2_,_loc3_);
         }
      }
      
      private function topWarsSort(param1:PWarTop, param2:PWarTop) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:Boolean = param1.wt_attacker.wti_storm || param1.wt_target.wti_storm;
         if(_loc3_ != (param2.wt_attacker.wti_storm || param2.wt_target.wti_storm))
         {
            return _loc3_ ? -1 : 1;
         }
         if(!_loc3_)
         {
            _loc4_ = param1.wt_attacker.wti_warpoints > param1.wt_target.wti_warpoints ? param1.wt_attacker.wti_warpoints : param1.wt_target.wti_warpoints;
            _loc5_ = param2.wt_attacker.wti_warpoints > param2.wt_target.wti_warpoints ? param2.wt_attacker.wti_warpoints : param2.wt_target.wti_warpoints;
         }
         else
         {
            _loc4_ = param1.wt_attacker.wti_damage + param1.wt_target.wti_damage;
            _loc5_ = param2.wt_attacker.wti_damage + param2.wt_target.wti_damage;
         }
         return _loc5_ - _loc4_;
      }
      
      private function onVariance(param1:VEvent) : void
      {
         switch(param1.variance)
         {
            case WarVariance.INFO:
               DialogLogic.openClanAbout(param1.data);
               break;
            case WarVariance.LOG:
               Facade.mainMediator.showDialog(new WarLogsMediator(param1.data[0],param1.data[1]));
               break;
            case WarVariance.TO_STORM:
               Facade.setMapCallback(DialogLogic.openWarList,[param1.data]);
               MainLogic.getWatchStorm(param1.data);
         }
      }
   }
}

