package ui.load
{
   import engine.signal.Signal;
   import logic.MainLogic;
   import proto.BinaryBuffer;
   import proto.game.family_0002.Packet_0002_01;
   import proto.game.family_0002.Packet_0002_02;
   import proto.model.PGetLocationAnswer;
   import proto.model.PLocation;
   import proto.model.PPhfClan;
   import ui.UIFactory;
   import ui.common.DurationPanel;
   import ui.common.StatPanel;
   import ui.game.ClanPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class WaitAttackPanel extends VComponent
   {
      
      private const requestSignal:Signal;
      
      private var isRequest:Boolean;
      
      public function WaitAttackPanel(param1:Number, param2:String, param3:PPhfClan)
      {
         var _loc7_:ClanPanel = null;
         this.requestSignal = new Signal(this.onRequest);
         super();
         if(param1 < 3)
         {
            param1 = 3;
         }
         stretch();
         add(SkinManager.getEmbed("DialogBg",VSkin.STRETCH),{
            "left":-20,
            "right":-20,
            "top":-5,
            "bottom":-18
         });
         var _loc4_:VComponent = new VComponent();
         _loc4_.add(SkinManager.getEmbed("DarkPanelBg",VSkin.STRETCH),{
            "left":0,
            "top":0,
            "right":-20,
            "bottom":0
         });
         _loc4_.add(SkinManager.getExternal("story_un_jaina1",SkinManager.PNG | SkinManager.LOAD_CLIP,VSkin.BOTTOM | VSkin.RIGHT | VSkin.NO_STRETCH),{
            "bottom":2,
            "w":230,
            "h":50
         });
         var _loc5_:Vector.<VComponent> = new <VComponent>[UIFactory.createDecorText(Lang.getString("my_attacked"),false,42)];
         var _loc6_:VText = UIFactory.createYellowText(param2,VText.CENTER,26);
         _loc6_.maxW = 460;
         _loc5_.push(_loc6_);
         if(param3)
         {
            _loc7_ = new ClanPanel(StatPanel.YELLOW_TEXT,5,40);
            _loc7_.assignClan(param3);
            _loc5_.push(_loc7_);
         }
         _loc5_.push(new DurationPanel(49,24).setTrackTime(param1));
         _loc4_.add(new VBox(_loc5_,12,VBox.VERTICAL),{
            "left":220,
            "top":-20
         });
         _loc4_.useCenter(0,20);
         addChild(_loc4_);
         this.requestSignal.delay = param1 < 8 ? param1 : 5;
         this.requestSignal.run(param1);
      }
      
      private function onRequest() : void
      {
         if(this.requestSignal.tail == 0)
         {
            Facade.mainPanel.showLoadPanel();
         }
         if(!this.isRequest)
         {
            this.isRequest = true;
            Facade.protoProxy.request(new Packet_0002_01(Packet_0002_01.GET_LOCATION,null),this.resultRequest,2,2);
         }
      }
      
      private function resultRequest(param1:BinaryBuffer) : void
      {
         var _loc2_:Packet_0002_02 = new Packet_0002_02(param1);
         if(_loc2_.variance == Packet_0002_02.LOCATION && (_loc2_.value as PGetLocationAnswer).location.variance != PLocation.ATTACKED)
         {
            removeFromParent();
            MainLogic.applyMapBuffer(param1);
         }
         else if(this.requestSignal.tail == 0)
         {
            removeFromParent();
            MainLogic.getMyMap();
         }
         else
         {
            this.isRequest = false;
         }
      }
   }
}

