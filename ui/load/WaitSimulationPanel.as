package ui.load
{
   import engine.signal.Signal;
   import logic.MainLogic;
   import proto.BinaryBuffer;
   import proto.game.family_0002.Packet_0002_01;
   import proto.game.family_0002.Packet_0002_02;
   import proto.model.PGetLocationAnswer;
   import proto.model.PLocation;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VBox;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class WaitSimulationPanel extends VComponent
   {
      
      public function WaitSimulationPanel()
      {
         var _loc2_:VText = null;
         super();
         stretch();
         add(SkinManager.getEmbed("DialogBg",VSkin.STRETCH),{
            "left":-20,
            "right":-20,
            "top":-5,
            "bottom":-18
         });
         var _loc1_:VComponent = new VComponent();
         _loc1_.add(SkinManager.getEmbed("DarkPanelBg",VSkin.STRETCH),{
            "left":0,
            "top":0,
            "right":-20,
            "bottom":0
         });
         _loc1_.add(SkinManager.getExternal("story_un_jaina1",SkinManager.PNG | SkinManager.LOAD_CLIP,VSkin.BOTTOM | VSkin.RIGHT | VSkin.NO_STRETCH),{
            "bottom":2,
            "w":230,
            "h":50
         });
         _loc2_ = UIFactory.createYellowText(Lang.getString("wait_simulation_desc"),VText.CENTER | VText.MIDDLE,26);
         _loc2_.maxW = 460;
         _loc2_.minH = 80;
         _loc1_.add(new VBox(new <VComponent>[UIFactory.createDecorText(Lang.getString("wait_simulation_title"),true,42),_loc2_],12,VBox.VERTICAL),{
            "left":220,
            "top":-20
         });
         _loc1_.useCenter(0,40);
         addChild(_loc1_);
         Signal.delayCall(2,this.onRequest);
      }
      
      private function onRequest() : void
      {
         Facade.protoProxy.request(new Packet_0002_01(Packet_0002_01.GET_LOCATION,null),this.resultRequest,2,2);
      }
      
      private function resultRequest(param1:BinaryBuffer) : void
      {
         var _loc2_:Packet_0002_02 = new Packet_0002_02(param1);
         if(_loc2_.variance == Packet_0002_02.LOCATION && (_loc2_.value as PGetLocationAnswer).location.variance != PLocation.SIMULATION)
         {
            removeFromParent();
            MainLogic.applyMapBuffer(param1);
         }
         else
         {
            Signal.delayCall(2,this.onRequest);
         }
      }
   }
}

