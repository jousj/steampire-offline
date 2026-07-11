package
{
   import ESkins.DefaultIcon;
   import com.adobe.serialization.json.JSONDecoder;
   import engine.Board;
   import engine.Map;
   import engine.display.AnimClip;
   import engine.signal.Signal;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.UncaughtErrorEvent;
   import flash.external.ExternalInterface;
   import flash.system.Security;
   import flash.text.Font;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import flashx.textLayout.formats.TextLayoutFormat;
   import game.battle.BattleMediator;
   import game.board.BoardMediator;
   import game.common.MainMediator;
   import game.destruction.DestructionMediator;
   import game.destruction.VODestruction;
   import game.my.MyMediator;
   import game.quest.QuestMediator;
   import logic.ErrorLogic;
   import logic.MainLogic;
   import model.AudioProxy;
   import model.CommonEvent;
   import model.ManualProxy;
   import model.ProtoProxy;
   import model.QuestProxy;
   import model.ResourceProxy;
   import model.UserProxy;
   import model.ba.FlaMetaBA;
   import model.stream.GameStream;
   import model.ui.VOCallback;
   import model.vo.FileLoadDesc;
   import proto.game.family_0005.Packet_0005_04;
   import proto.game.family_0005.Packet_0005_08;
   import proto.model.PReferences;
   import ui.MainPanel;
   import ui.UIFactory;
   import ui.common.MessageDialog;
   import ui.load.StartupLoadPanel;
   import ui.vbase.AssetLoader;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   import utils.ULoader;
   
   public class Facade extends EventDispatcher
   {
      public static var destructionMediator:DestructionMediator;
      public static var mainMediator:MainMediator;
      public static var boardMediator:BoardMediator;
      public static var myMediator:MyMediator;
      public static var questMediator:QuestMediator;
      public static var battleMediator:BattleMediator;
      public static var myMapCallback:VOCallback;
      public static var isMyMap:Boolean;
      public static var isBattle:Boolean;
      public static var isMissionEditor:Boolean;
      public static var isCapital:Boolean;
      public static var fakeResize:Boolean;
      public static var socialnet:String;
      public static var isHttps:Boolean;
      public static var stage:Stage;
      public static var userStage:String;
      public static var references:PReferences;
      public static const VKONTAKTE:String = "vkontakte";
      public static const ODNOKLASSNIKI:String = "odnoklassniki";
      public static const MOYMIR:String = "moymir";
      public static const FACEBOOK:String = "facebook";
      public static const EXE:String = "exe";
      public static const VZ:String = "vz";
      public static const map_sx:int = 44;
      public static const map_sy:int = 44;
      public static const map:Map = new Map(map_sx,map_sy);
      public static const instance:Facade = new Facade();
      public static const manualProxy:ManualProxy = new ManualProxy();
      public static const protoProxy:ProtoProxy = new ProtoProxy();
      public static const questProxy:QuestProxy = new QuestProxy();
      public static const userProxy:UserProxy = new UserProxy();
      public static const audioProxy:AudioProxy = new AudioProxy();
      public static const gameStream:GameStream = new GameStream();
      public static const mainPanel:MainPanel = new MainPanel();
      public static const board:Board = new Board();
      public static const logList:Vector.<String> = new Vector.<String>();
      public static const commonHash:Dictionary = new Dictionary();
      public static const fpsControl:FPSControl = new FPSControl();
      public static var isNormalQuality:Boolean = true;
      
      public function Facade()
      {
         super();
      }
      
      public static function addListener(param1:String, param2:Function) : void
      {
         instance.addEventListener(param1,param2);
      }
      
      public static function removeListener(param1:String, param2:Function) : void
      {
         instance.removeEventListener(param1,param2);
      }
      
      public static function dispatchCommonEvent(param1:String, param2:* = null, param3:uint = 0) : void
      {
         instance.dispatchEvent(new CommonEvent(param1,param2,param3));
      }
      
      public static function addListenerForComponent(param1:String, param2:Function, param3:VComponent) : void
      {
         param3.addListener(param1,param2,instance);
      }
      
      public static function log(param1:String) : void
      {
         logList.unshift((getTimer() / 1000).toFixed(2) + ": " + param1);
         if(logList.length > 30)
         {
            logList.length = 30;
         }
      }
      
      public static function callJS(... rest) : void
      {
         var _loc3_:* = undefined;
         if(stage.displayState != StageDisplayState.NORMAL)
         {
            stage.displayState = StageDisplayState.NORMAL;
         }
         var _loc2_:String = "";
         for each(_loc3_ in rest)
         {
            _loc2_ += _loc3_ + " ";
         }
         log(_loc2_);
         useHideJS.apply(null,rest);
      }
      
      public static function useHideJS(... rest) : void
      {
         if(ExternalInterface.available)
         {
            try
            {
               ExternalInterface.call.apply(null,rest);
            }
            catch(error:Error)
            {
            }
         }
      }
      
      public static function addJSCallback(param1:String, param2:Function) : void
      {
         if(ExternalInterface.available)
         {
            try
            {
               ExternalInterface.addCallback(param1,param2);
            }
            catch(error:Error)
            {
            }
         }
      }
      
      public static function jsonDecode(param1:String) : Object
      {
         return new JSONDecoder(param1,true).getValue();
      }
      
      public static function changeUserStage(param1:String) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = Preloader.userStageList;
         var _loc3_:int = _loc2_.indexOf(param1);
         if(_loc3_ >= 0)
         {
            _loc4_ = _loc2_.indexOf(userStage);
            if(_loc4_ >= 0 && _loc3_ > _loc4_)
            {
               userStage = param1;
               Facade.protoProxy.service_request(new Packet_0005_04(param1));
            }
         }
      }
      
      public static function checkUserStage(param1:String) : Boolean
      {
         var _loc4_:int = 0;
         var _loc2_:Array = Preloader.userStageList;
         var _loc3_:int = _loc2_.indexOf(param1);
         if(_loc3_ >= 0)
         {
            _loc4_ = _loc2_.indexOf(userStage);
            if(_loc4_ >= 0 && _loc3_ <= _loc4_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function fact(param1:uint) : void
      {
         Facade.protoProxy.service_request(new Packet_0005_08(param1));
      }
      
      public static function showDestruction(param1:VODestruction) : void
      {
         destructionMediator = new DestructionMediator(param1);
         Facade.mainMediator.showDialog(destructionMediator);
      }
      
      public static function endOfDestruction() : void
      {
         destructionMediator = null;
      }
      
      public static function setMapCallback(param1:Function, param2:Array = null) : void
      {
         myMapCallback = VOCallback.create(param1,param2);
      }
      
      public static function setNormalQuality(param1:Boolean) : void
      {
         if(param1 != isNormalQuality)
         {
            isNormalQuality = param1;
            if(param1)
            {
               fpsControl.stop();
            }
            else
            {
               fpsControl.start();
            }
         }
      }
      
      private function onResize(param1:Event) : void
      {
         if(boardMediator)
         {
            board.setSize(stage.stageWidth,stage.stageHeight);
            boardMediator.changeViewPort();
         }
         fakeResize = stage.stageWidth <= 800 || stage.stageHeight <= 550;
         mainPanel.setGeometrySize(stage.stageWidth,stage.stageHeight,true);
      }
      
      public function init(param1:Stage) : void
      {
         Facade.stage = param1;
         param1.loaderInfo.content.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,ErrorLogic.onUncaughtError);
         if(param1.loaderInfo.url.indexOf("https") >= 0)
         {
            isHttps = true;
         }
         AnimClip.resourceProxy = new ResourceProxy(getTimer() >= 14000 ? 3 : 0);
         AnimClip.resourceProxy.url = Preloader.static_url + "library/";
         Security.allowDomain("*");
         var _loc2_:Object = param1.loaderInfo.parameters;
         if(!Facade.protoProxy.url)
         {
            Facade.protoProxy.url = Preloader.dynamic_url + "/proto?sid=" + _loc2_.sid;
            Preloader.locale_url = _loc2_.lang_url;
            Lang.locale = _loc2_.lang != null ? (_loc2_.lang as String).toUpperCase() : Lang.RU;
            socialnet = _loc2_.socialnet;
         }
         else
         {
            Lang.locale = Lang.locale;
         }
         userStage = _loc2_.stage as String;
         if(userStage == null)
         {
            Facade.userStage = "m1_clip_start";
         }
         else
         {
            changeUserStage("t_main_swf_loaded");
         }

         var langBase:String = Preloader.locale_url;
         if (langBase.charAt(langBase.length - 1) != "/") {
            langBase += "/";
         }
         var officialLangPath:String = langBase + "steam/locale/redspell/Lang" + Lang.locale + ".json";

         this.getLoadList().push(new FileLoadDesc(officialLangPath,this.completeLocale,true),new FileLoadDesc(Preloader.static_url + "images/startup2.jpg",AssetLoader.load,false,[false,this.completeStartupImage]));
         this.onSuccessLoadFile(null,true);
      }
      
      private function completeLocale(param1:Object) : void
      {
         changeUserStage("t_lang_loaded");
         Lang.lexicon = param1;
         Font.registerFont(AGPresquire);
         Font.registerFont(MyriadProFont);
         Font.registerFont(Asap);
         var _loc2_:TextLayoutFormat = SkinManager.init(Preloader.static_url);
         _loc2_.fontFamily = Lang.useAsap ? "Asap" : "AGPresquire";
         _loc2_.fontSize = 18;
         _loc2_.color = 0;
         VSkin.defaultIconClass = DefaultIcon;
         VSkin.loadClipFactory = UIFactory.getExternalLoadClip;
      }
      
      private function completeStartupImage(param1:AssetLoader) : void
      {
         var _loc2_:Preloader = null;
         changeUserStage("t_screen_loaded");
         if(stage.numChildren > 0)
         {
            _loc2_ = stage.getChildAt(0) as Preloader;
            _loc2_.stop();
            stage.removeEventListener(Event.RESIZE,_loc2_.onResize);
            stage.removeChild(_loc2_);
            stage.addChild(mainPanel);
            stage.color = 2961716;
            this.onResize(null);
            stage.addEventListener(Event.RESIZE,this.onResize);
            this.getLoadList().push(new FileLoadDesc(AnimClip.resourceProxy.url + "meta.data?random=" + ProtoProxy.CLIENT_VERSION,this.completeMetadataLib),new FileLoadDesc(Preloader.static_url + "images/map_bg_winter.jpg",this.completeMapImage));
            mainPanel.loadPanel = new StartupLoadPanel(param1.loader);
            mainPanel.addStretch(mainPanel.loadPanel);
            this.onSuccessLoadFile(null,true);
            return;
         }
         throw new Error("bad load game");
      }
      
      private function getLoadList() : Vector.<FileLoadDesc>
      {
         var _loc1_:Vector.<FileLoadDesc> = commonHash[instance] as Vector.<FileLoadDesc>;
         if(!_loc1_)
         {
            _loc1_ = new Vector.<FileLoadDesc>();
            commonHash[instance] = _loc1_;
         }
         return _loc1_;
      }
      
      private function completeMetadataLib(param1:ByteArray) : void
      {
         changeUserStage("t_info_obj_loaded");
         AnimClip.resourceProxy.parseMetaData(param1);
         AnimClip.resourceProxy.parseMetaData(new FlaMetaBA(),Preloader.static_url + "fla_library/");
      }
      
      private function completeMapImage(param1:ByteArray) : void
      {
         delete commonHash[instance];
         changeUserStage("t_map_loaded");
         fpsControl.init(stage);
         MainLogic.run(AssetLoader.load(param1,false).loader);
      }
      
      private function setProgress(param1:Number) : void
      {
         var _loc2_:String = 8 - this.getLoadList().length + "/8:  ";
         if(mainPanel.parent)
         {
            (mainPanel.loadPanel as StartupLoadPanel).setProgress(param1,_loc2_);
         }
         else
         {
            (stage.getChildAt(0) as Preloader).setProgressData(_loc2_ + Math.floor(param1 * 100) + "%");
         }
      }
      
      private function showError(param1:String, param2:String, param3:Boolean = false) : void
      {
         if(mainPanel.parent)
         {
            mainPanel.add(new MessageDialog(param2,Lang.getString("error")),{
               "hCenter":0,
               "vCenter":0
            });
         }
         else
         {
            (stage.getChildAt(0) as Preloader).setProgressData(param2);
         }
         param2 = param2 + " (time=" + getTimer() + ")\n  " + stage.loaderInfo.loaderURL;
         if(param3)
         {
            Signal.delayCall(0.4,ErrorLogic.sendLog,["Facade",param1,param2],true);
         }
         else
         {
            ErrorLogic.sendLog("Facade",param1,param2);
         }
      }
      
      private function onSuccessLoadFile(param1:*, param2:Boolean = false) : void
      {
         var desc:FileLoadDesc = null;
         var data:* = param1;
         var onlyRun:Boolean = param2;
         var list:Vector.<FileLoadDesc> = this.getLoadList();
         if(!onlyRun && list.length > 0)
         {
            desc = list.shift();
            if(desc.isJson)
            {
               try
               {
                  data = jsonDecode(data);
               }
               catch(error:Error)
               {
                  showError("error parse",desc.url);
                  return;
               }
            }
            if(desc.callFunc != null)
            {
               if(desc.callArgs != null)
               {
                  (desc.callArgs as Array).unshift(data);
               }
               else
               {
                  desc.callArgs = [data];
               }
               try
               {
                  desc.callFunc.apply(null,desc.callArgs);
               }
               catch(error:Error)
               {
                  showError("callFunc error",desc.url);
               }
            }
         }
         if(list.length > 0)
         {
            desc = list[0];
            if(desc.isJson)
            {
               desc.url += "?v=" + ProtoProxy.CLIENT_VERSION;
            }
            this.setProgress(0);
            ULoader.load(desc.url,this.onSuccessLoadFile,!desc.isJson,this.onErrorLoadFile,this.setProgress);
         }
      }
      
      private function onErrorLoadFile(param1:Event) : void
      {
         var _loc2_:Vector.<FileLoadDesc> = this.getLoadList();
         this.showError("error load",(_loc2_.length > 0 ? _loc2_[0].url : "?") + "\n  " + param1,true);
      }
   }
}