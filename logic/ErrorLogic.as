package logic
{
   import com.adobe.serialization.json.JSONEncoder;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.system.Capabilities;
   import flash.system.System;
   import model.ProtoProxy;
   import model.UserProxy;
   import proto.BinaryBuffer;
   import proto.game.family_0000.Packet_0000_00;
   import ui.Style;
   import ui.common.MessageDialog;
   import ui.common.RectButton;
   import ui.load.LoadPanel;
   import ui.vbase.VButton;
   import utils.CommonUtils;
   import utils.GameLocalConnection;
   import utils.ULoader;
   
   public class ErrorLogic
   {
      
      private static var errorRequestMax:uint = 2;
      
      public function ErrorLogic()
      {
         super();
      }
      
      public static function show(param1:Object, param2:String = null, param3:String = null, param4:Boolean = true) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc10_:Packet_0000_00 = null;
         var _loc11_:RectButton = null;
         Facade.mainPanel.hideLoadPanel();
         MainLogic.free(false,null,true);
         if(param1 === true)
         {
            _loc5_ = Lang.getString("one_client_title");
            _loc6_ = Lang.getString("one_client_prompt");
            _loc7_ = true;
            _loc8_ = true;
         }
         else
         {
            if(param1 is BinaryBuffer)
            {
               _loc10_ = new Packet_0000_00(param1 as BinaryBuffer);
               switch(_loc10_.variance)
               {
                  case Packet_0000_00.OLD_CLIENT:
                     _loc6_ = Lang.getString("old_client");
                     _loc8_ = true;
                     break;
                  case Packet_0000_00.CLIENT_ERROR:
                     _loc6_ = "Packet_0000_00.SERVER_ERROR " + _loc10_.value;
                     param4 = false;
                     break;
                  case Packet_0000_00.ATTACKED:
                     MainLogic.waitUserAttack(_loc10_.value);
                     return;
                  case Packet_0000_00.SOCIAL_ERROR:
                     _loc6_ = _loc10_.value;
                     break;
                  default:
                     _loc6_ = "INTERNAL_SERVER_ERROR";
               }
            }
            else
            {
               _loc6_ = param1 as String;
            }
            if(Boolean(_loc10_) || _loc6_ != "client error")
            {
               if(_loc10_)
               {
                  param2 = CommonUtils.getConstantName(Packet_0000_00,_loc10_.variance);
               }
               else if(!param2)
               {
                  param2 = "client";
               }
               sendLog(param2,param3,getUserInfo() + "\n" + _loc6_);
            }
         }
         var _loc9_:MessageDialog = new MessageDialog(_loc8_ ? _loc6_ : Lang.getPatternString("error_msg","__CODE__","<span fontWeight=\"bold\"" + Style.redColor + ">" + _loc6_ + "</span>"),_loc5_ ? _loc5_ : Lang.getString("error_title"),null,MessageDialog.HIDE_CLOSE_BUTTON);
         if(!_loc8_)
         {
            _loc11_ = new RectButton("Copy",RectButton.h56,RectButton.YELLOW);
            _loc11_.addClickListener(onCopy,_loc6_);
            _loc9_.addButton(_loc11_);
         }
         _loc9_.addDelegateRectButton("OK",onReload,[param4,_loc7_]);
         Facade.mainMediator.showDialog(_loc9_);
      }
      
      public static function onReload(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(param1)
         {
            Facade.mainPanel.addStretch(new LoadPanel(Lang.getString("js_reload_page")));
            Facade.useHideJS("reload_page");
         }
         else
         {
            if(param2)
            {
               GameLocalConnection.instance.resume();
            }
            Facade.mainPanel.showLoadPanel();
            MainLogic.getDict();
         }
      }
      
      private static function onCopy(param1:MouseEvent) : void
      {
         System.setClipboard(String((param1.currentTarget as VButton).data));
      }
      
      private static function getUserInfo() : String
      {
         var _loc1_:String = "";
         if(ExternalInterface.available)
         {
            try
            {
               _loc1_ = ExternalInterface.call("window.navigator.userAgent.toString");
               _loc1_ = "\n" + _loc1_;
            }
            catch(error:Error)
            {
            }
         }
         var _loc2_:UserProxy = Facade.userProxy;
         return Facade.socialnet + " uid=" + Preloader.uid + " lvl=" + _loc2_.level + " time=" + CoreLogic.sessionDuration.toFixed(2) + " f=" + CoreLogic.correctFactor.toFixed(3) + " cry=" + _loc2_.crystal + " oil=" + _loc2_.oil + " gold=" + _loc2_.gold + getMem() + _loc1_;
      }
      
      public static function onUncaughtError(param1:Object, param2:Boolean = false) : void
      {
         var isRequest:Boolean;
         var log:String;
         var error:Error = null;
         var data:Object = param1;
         var isOnlyRequest:Boolean = param2;
         if(isOnlyRequest && errorRequestMax == 0)
         {
            return;
         }
         isRequest = true;
         log = "?";
         try
         {
            if(data is Error || data is Event && data.hasOwnProperty("error"))
            {
               if(data is Error || data.error is Error)
               {
                  error = (data is Error ? data : data.error) as Error;
                  log = error.message + "\n  " + error.getStackTrace();
               }
               else if(data.error is ErrorEvent)
               {
                  log = "errorEvent=" + (data.error as ErrorEvent).type + "_" + (data.error as ErrorEvent).text;
               }
               else
               {
                  log = "otherError=" + String(data.error);
               }
            }
            else
            {
               log = String(data);
            }
         }
         catch(logError:Error)
         {
            isRequest = true;
            log = "log_error=" + logError;
         }
         if(isRequest && errorRequestMax > 0)
         {
            --errorRequestMax;
            sendError(log);
         }
         if(!isOnlyRequest)
         {
            show("client error" + log);
         }
      }
      
      public static function sendError(param1:String) : void
      {
         var _loc2_:URLRequest = new URLRequest(Preloader.dynamic_url + "/client_errors");
         _loc2_.method = URLRequestMethod.POST;
         _loc2_.contentType = "text/example";
         _loc2_.data = "v=" + ProtoProxy.PROTOCOL_VERSION + "/" + ProtoProxy.CLIENT_VERSION + " (" + Capabilities.version + ")  " + getUserInfo() + "\n  " + param1 + "\n";
         ULoader.load(_loc2_,null);
      }
      
      public static function getMem() : String
      {
         var _loc1_:String = Number(System.totalMemory / 1048576).toFixed(2) + "Mb";
         if(System["privateMemory"])
         {
            _loc1_ += "/" + Number(System["privateMemory"] / 1048576).toFixed(2) + "Mb";
         }
         return " mem=" + _loc1_;
      }
      
      public static function sendLog(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:String = "steam";
         var _loc5_:URLRequest = new URLRequest("http://errors.redspell.ru/submit?app_name=" + _loc4_);
         _loc5_.method = URLRequestMethod.POST;
         _loc5_.contentType = "application/json";
         var _loc6_:Object = {
            "date":(new Date().time / 1000).toFixed(),
            "device":Capabilities.version,
            "vers":ProtoProxy.CLIENT_VERSION,
            "exception":param1,
            "errorcode":param2,
            "data":param3 + "\n" + Facade.protoProxy.logs.join("\n"),
            "network":Facade.socialnet,
            "uid":Preloader.uid
         };
         _loc5_.data = new JSONEncoder(_loc6_).getString();
         ULoader.load(_loc5_,null);
      }
   }
}

