package model
{
   import engine.display.Animation;
   import engine.display.FrameDescItem;
   import engine.display.Library;
   import engine.display.PngPosition;
   import engine.display.RBitmap;
   import engine.display.RBitmapData;
   import engine.display.RBitmapLoader;
   import engine.signal.Signal;
   import engine.units.Unit;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Endian;
   import logic.ErrorLogic;
   import ui.vbase.AssetLoader;
   import ui.vbase.VEvent;
   
   public class ResourceProxy extends EventDispatcher
   {
      
      public var url:String;
      
      public var loadCur:uint;
      
      public const libList:Vector.<Library> = new Vector.<Library>();
      
      public const animHash:Object = {};
      
      public const bitmapPool:Vector.<RBitmap> = new Vector.<RBitmap>();
      
      private const pngCache:Object = {};
      
      private const loaders:Dictionary = new Dictionary();
      
      private const allocList:Vector.<RBitmapData> = new Vector.<RBitmapData>();
      
      private var waitLoadList:Vector.<Library>;
      
      private var loadMax:uint;
      
      private var badCount:uint;
      
      public function ResourceProxy(param1:uint = 0)
      {
         super();
         this.loadMax = param1;
      }
      
      public function parseMetaData(param1:ByteArray, param2:String = null) : void
      {
         var _loc4_:Library = null;
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Animation = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:uint = 0;
         var _loc12_:Rectangle = null;
         var _loc13_:Vector.<int> = null;
         var _loc14_:uint = 0;
         param1.endian = Endian.LITTLE_ENDIAN;
         param1.inflate();
         var _loc3_:uint = uint(param1.readShort());
         while(_loc3_ > 0)
         {
            _loc4_ = new Library();
            _loc4_.name = param1.readUTF();
            _loc4_.fileSize = param1.readUnsignedInt();
            _loc4_.index = this.libList.length;
            _loc4_.url = param2;
            this.libList.push(_loc4_);
            _loc3_--;
         }
         while(param1.bytesAvailable > 0)
         {
            _loc5_ = {};
            _loc6_ = param1.readUTF();
            this.animHash[_loc6_] = _loc5_;
            _loc3_ = uint(param1.readByte());
            _loc5_["_SIZE_"] = _loc3_;
            if(param1.readByte() != _loc3_ || _loc3_ == 0)
            {
               throw new Error("bad size " + _loc6_);
            }
            _loc7_ = param1.readUTF();
            _loc3_ = uint(param1.readByte());
            while(_loc3_ > 0)
            {
               _loc8_ = new Animation();
               _loc9_ = param1.readUTF();
               _loc8_.name = _loc9_;
               _loc5_[_loc9_] = _loc8_;
               _loc10_ = param1.readUTF();
               if(_loc10_ == "_")
               {
                  _loc10_ = _loc7_;
               }
               for each(_loc4_ in this.libList)
               {
                  if(_loc4_.name == _loc10_)
                  {
                     break;
                  }
               }
               if(_loc4_.name != _loc10_)
               {
                  throw new Error("bad lib " + _loc10_);
               }
               _loc8_.lib = _loc4_;
               _loc8_.frameNum = param1.readByte();
               _loc11_ = param1.readUnsignedInt();
               if(_loc11_ > 24 || _loc11_ == 0)
               {
                  _loc11_ = 24;
               }
               _loc8_.frameDelay = 1 / _loc11_;
               _loc8_.iconX = param1.readShort();
               _loc8_.iconY = param1.readShort();
               _loc12_ = _loc8_.viewRect;
               _loc12_.x = param1.readShort();
               _loc12_.y = param1.readShort();
               _loc12_.width = param1.readShort();
               _loc12_.height = param1.readShort();
               _loc13_ = null;
               _loc14_ = uint(param1.readByte());
               while(_loc14_ > 0)
               {
                  _loc14_--;
                  _loc10_ = param1.readUTF();
                  if(_loc10_ == "boom")
                  {
                     if(!_loc13_)
                     {
                        _loc13_ = new Vector.<int>();
                     }
                     _loc13_.push(param1.readShort(),param1.readShort());
                  }
                  else if(_loc10_ == "point")
                  {
                     Unit.pointHash[_loc6_] = new Point(param1.readShort(),param1.readShort());
                  }
                  else
                  {
                     param1.position += 4;
                  }
               }
               if(_loc13_)
               {
                  Unit.boomHash[_loc6_ + _loc9_] = _loc13_;
               }
               _loc3_--;
            }
         }
      }
      
      public function getAnimation(param1:String, param2:String) : Animation
      {
         var _loc3_:Object = this.animHash[param1];
         if(_loc3_)
         {
            return _loc3_[param2] as Animation;
         }
         return null;
      }
      
      public function load(param1:Library) : void
      {
         if(param1.loadMode == Library.EMPTY)
         {
            param1.loadMode = Library.LOAD;
            if(this.loadMax > 0)
            {
               if(this.loadCur >= this.loadMax)
               {
                  if(!this.waitLoadList)
                  {
                     this.waitLoadList = new Vector.<Library>();
                  }
                  this.waitLoadList.push(param1);
                  return;
               }
               ++this.loadCur;
            }
            else
            {
               ++this.loadCur;
            }
            this.rawLoad(param1,true);
         }
      }
      
      private function rawLoad(param1:Library, param2:Boolean = false) : void
      {
         var loader:URLLoader = null;
         var lib:Library = param1;
         var useP2P:Boolean = param2;
         var url:String = (lib.url ? lib.url : this.url) + lib.name + ".swf";
         loader = new URLLoader();
         this.loaders[loader] = lib;
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         loader.addEventListener(Event.COMPLETE,this.onLoadLib);
         loader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadLib);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadLib);
         try
         {
            loader.load(new URLRequest(url));
         }
         catch(error:Error)
         {
            onLoadLib(loader);
         }
      }
      
      private function onLoadLib(param1:Object, param2:Library = null) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:URLLoader = null;
         if(param2)
         {
            _loc3_ = param1 as ByteArray;
         }
         else
         {
            _loc4_ = (param1 is Event ? (param1 as Event).currentTarget : param1) as URLLoader;
            param2 = this.loaders[_loc4_];
            if(param1 is Event && (param1 as Event).type == Event.COMPLETE)
            {
               _loc3_ = _loc4_.data as ByteArray;
               if(param2.fileSize != _loc3_.length)
               {
                  if(!param2.isSecondLoad)
                  {
                     param2.isSecondLoad = true;
                     param2.loadMode = Library.LOAD;
                     try
                     {
                        _loc4_.load(new URLRequest((param2.url ? param2.url : this.url) + param2.name + ".swf?random=" + ProtoProxy.CLIENT_VERSION));
                        return;
                     }
                     catch(error:Error)
                     {
                     }
                  }
                  _loc3_ = null;
               }
            }
            delete this.loaders[_loc4_];
            _loc4_.removeEventListener(Event.COMPLETE,this.onLoadLib);
            _loc4_.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadLib);
            _loc4_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadLib);
            param2.url = null;
         }
         param2.loadMode = Library.BAD;
         if(_loc3_)
         {
            try
            {
               this.parseLibraryData(param2,_loc3_);
            }
            catch(error:Error)
            {
            }
         }
         if(param2.loadMode == Library.BAD)
         {
            Signal.delayCall(0.4,ErrorLogic.sendLog,["bad parse lib",param2.name,this.url + "\nlibSize=" + param2.fileSize + ", baLen=" + (_loc3_ ? _loc3_.length : "-") + ", isSecond=" + param2.isSecondLoad + (param1 is Event ? "\n  " + param1 : "")],true);
            param2.clear();
            ++this.badCount;
            if(this.badCount == 1)
            {
               Facade.mainMediator.showMessage(Lang.getString("bad_library"));
            }
         }
         dispatchEvent(new VEvent(param2.name,param2));
         if(this.loadMax > 0)
         {
            if(this.waitLoadList)
            {
               param2 = this.waitLoadList.shift();
               if(this.waitLoadList.length == 0)
               {
                  this.waitLoadList = null;
               }
               this.rawLoad(param2,true);
            }
            else
            {
               --this.loadCur;
            }
         }
         else
         {
            --this.loadCur;
         }
         if(this.loadCur == 0)
         {
            if(Facade.audioProxy.isThemeWait)
            {
               Facade.audioProxy.loadTheme();
            }
         }
      }
      
      public function setLoadLibListener(param1:Animation, param2:Function, param3:Boolean) : void
      {
         if(param3)
         {
            addEventListener(param1.lib.name,param2,false,1);
         }
         else
         {
            removeEventListener(param1.lib.name,param2);
         }
      }
      
      private function parseLibraryData(param1:Library, param2:ByteArray) : void
      {
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc10_:PngPosition = null;
         var _loc11_:Vector.<FrameDescItem> = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:FrameDescItem = null;
         var _loc16_:uint = 0;
         var _loc17_:Object = null;
         var _loc18_:Object = null;
         var _loc19_:String = null;
         var _loc20_:Animation = null;
         var _loc21_:Array = null;
         var _loc22_:int = 0;
         param2.endian = Endian.LITTLE_ENDIAN;
         var _loc3_:uint = param2.readUnsignedInt();
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.endian = Endian.LITTLE_ENDIAN;
         param2.readBytes(_loc4_,0,_loc3_);
         param1.pngs = _loc4_;
         while(_loc4_.bytesAvailable > 0)
         {
            _loc9_ = uint(_loc4_.readInt());
            _loc10_ = new PngPosition(_loc4_.position,_loc9_);
            _loc4_.position += _loc9_;
            param1.pngIndexs.push(_loc10_);
         }
         _loc3_ = uint(param2.readShort());
         var _loc5_:uint = param1.index;
         while(_loc3_ > 0)
         {
            _loc11_ = new Vector.<FrameDescItem>();
            _loc12_ = uint(param2.readByte());
            _loc13_ = 0;
            while(_loc13_ < _loc12_)
            {
               _loc14_ = uint(param2.readInt());
               _loc15_ = new FrameDescItem(param2.readShort(),param2.readShort());
               _loc16_ = uint(param2.readByte());
               _loc15_.pid = this.getPID(_loc5_,_loc14_,(_loc16_ & 1) != 0);
               if((_loc16_ & 1) != 0)
               {
                  _loc15_.isFlipX = true;
               }
               if((_loc16_ & 2) != 0)
               {
                  _loc15_.alpha = param2.readByte() / 100;
               }
               if((_loc16_ & 4) != 0)
               {
                  _loc15_.scale = param2.readFloat();
               }
               if((_loc16_ & 8) != 0)
               {
                  param2.readFloat();
               }
               if(_loc15_.alpha != 1 || _loc15_.scale != 1 || _loc15_.isFlipX)
               {
                  _loc15_.isEffect = true;
               }
               _loc11_.push(_loc15_);
               _loc13_++;
            }
            param1.frames.push(_loc11_);
            _loc3_--;
         }
         var _loc6_:Object = Facade.jsonDecode(param2.readUTFBytes(param2.bytesAvailable));
         var _loc7_:uint = param1.frames.length;
         for(_loc8_ in _loc6_)
         {
            _loc17_ = this.animHash[_loc8_];
            if(_loc17_)
            {
               _loc18_ = _loc6_[_loc8_];
               for(_loc19_ in _loc18_)
               {
                  _loc20_ = _loc17_[_loc19_] as Animation;
                  if(_loc20_)
                  {
                     _loc21_ = _loc18_[_loc19_] as Array;
                     if(_loc21_)
                     {
                        _loc22_ = int(_loc21_.length);
                        if(_loc22_ != 0)
                        {
                           _loc13_ = 0;
                           while(_loc13_ < _loc22_)
                           {
                              if(_loc21_[_loc13_] >= _loc7_)
                              {
                                 _loc21_ = null;
                                 break;
                              }
                              _loc13_++;
                           }
                           if(_loc21_)
                           {
                              if(_loc22_ == 1)
                              {
                                 _loc20_.frame = param1.frames[_loc21_[0]];
                              }
                              else
                              {
                                 _loc20_.frames = new Vector.<Vector.<FrameDescItem>>();
                                 _loc13_ = 0;
                                 while(_loc13_ < _loc22_)
                                 {
                                    _loc20_.frames.push(param1.frames[_loc21_[_loc13_]]);
                                    _loc13_++;
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         for each(_loc17_ in this.animHash)
         {
            for(_loc19_ in _loc17_)
            {
               _loc20_ = _loc17_[_loc19_] as Animation;
               if(Boolean((_loc20_) && _loc20_.lib == param1) && Boolean(!_loc20_.frame) && !_loc20_.frames)
               {
                  return;
               }
            }
         }
         param1.loadMode = Library.FULL;
      }
      
      private function createPNG(param1:uint) : RBitmapData
      {
         var bd:RBitmapData = null;
         var pngPosition:PngPosition = null;
         var ba:ByteArray = null;
         var w:int = 0;
         var h:int = 0;
         var loader:RBitmapLoader = null;
         var pid:uint = param1;
         var lib:Library = this.libList[this.getLibIndex(pid)];
         var id:uint = this.getPngId(pid);
         if(id < lib.pngIndexs.length)
         {
            pngPosition = lib.pngIndexs[id];
            if(pngPosition.length > 24 && lib.pngs.length >= pngPosition.offset + pngPosition.length)
            {
               lib.pngs.position = pngPosition.offset;
               ba = new ByteArray();
               lib.pngs.readBytes(ba,0,pngPosition.length);
               ba.position = 16;
               w = ba.readInt();
               h = ba.readInt();
               if(w > 0 && h > 0 && w <= 2000 && h <= 2000)
               {
                  ba.position = 0;
                  bd = new RBitmapData(w,h);
                  loader = new RBitmapLoader();
                  loader.bd = bd;
                  loader.isFlip = this.getPngFlip(pid);
                  this.loaders[loader] = true;
                  loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onPngLoaded);
                  loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onPngLoaded);
                  try
                  {
                     loader.loadBytes(ba,AssetLoader.imageContext);
                  }
                  catch(error:Error)
                  {
                     onPngLoaded(loader);
                  }
               }
            }
         }
         if(!bd)
         {
            bd = new RBitmapData(3,3,false,16711680);
            bd.loaded = true;
         }
         this.pngCache[pid] = bd;
         return bd;
      }
      
      private function onPngLoaded(param1:Object) : void
      {
         var _loc2_:Event = null;
         var _loc3_:RBitmapLoader = null;
         var _loc4_:Bitmap = null;
         var _loc5_:Matrix = null;
         if(param1 is Event)
         {
            _loc2_ = param1 as Event;
            _loc3_ = (_loc2_.currentTarget as LoaderInfo).loader as RBitmapLoader;
         }
         else
         {
            _loc3_ = param1 as RBitmapLoader;
         }
         _loc3_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onPngLoaded);
         _loc3_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onPngLoaded);
         _loc3_.bd.loaded = true;
         if(Boolean(_loc2_) && _loc2_.type == Event.COMPLETE)
         {
            _loc4_ = _loc3_.content as Bitmap;
            if(_loc3_.isFlip)
            {
               _loc5_ = new Matrix();
               _loc5_.translate(-_loc3_.bd.width,0);
               _loc5_.scale(-1,1);
            }
            _loc3_.bd.draw(_loc4_.bitmapData,_loc5_);
         }
         _loc3_.unload();
         delete this.loaders[_loc3_];
      }
      
      public function createFrame(param1:Sprite, param2:Vector.<FrameDescItem>, param3:Boolean, param4:Boolean = false) : void
      {
         var _loc7_:RBitmapData = null;
         var _loc8_:Boolean = false;
         var _loc9_:RBitmap = null;
         var _loc10_:FrameDescItem = null;
         var _loc11_:uint = 0;
         var _loc5_:uint = param2.length;
         if(_loc5_ > this.allocList.length)
         {
            this.allocList.length = _loc5_;
         }
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = this.pngCache[uint(param3 ? param2[_loc6_].pid | 0x80000000 : param2[_loc6_].pid)] as RBitmapData;
            if(!_loc7_)
            {
               _loc7_ = this.createPNG(param3 ? uint(param2[_loc6_].pid | 0x80000000) : param2[_loc6_].pid);
            }
            this.allocList[_loc6_] = _loc7_;
            if(!_loc7_.loaded)
            {
               _loc8_ = true;
            }
            _loc6_++;
         }
         _loc6_ = uint(param1.numChildren);
         if(!param4 && _loc8_ && _loc6_ > 0)
         {
            return;
         }
         if(_loc6_ != _loc5_)
         {
            if(_loc6_ > _loc5_)
            {
               while(_loc6_ > _loc5_)
               {
                  this.bitmapPool.push(param1.removeChildAt(_loc5_));
                  _loc6_--;
               }
            }
            else
            {
               while(_loc6_ < _loc5_)
               {
                  param1.addChildAt(this.bitmapPool.length != 0 ? this.bitmapPool.pop() : new RBitmap(),_loc6_);
                  _loc6_++;
               }
            }
         }
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc9_ = param1.getChildAt(_loc6_) as RBitmap;
            _loc10_ = param2[_loc6_];
            _loc11_ = param3 ? uint(_loc10_.pid | 0x80000000) : _loc10_.pid;
            if(_loc9_.pid != _loc11_)
            {
               _loc9_.bitmapData = this.allocList[_loc6_];
               if(Facade.isNormalQuality)
               {
                  _loc9_.smoothing = true;
               }
               _loc9_.pixelSnapping = "always";
               _loc9_.pid = _loc11_;
            }
            if(_loc10_.isEffect || _loc9_.isEffect != _loc10_.isEffect)
            {
               _loc9_.isEffect = _loc10_.isEffect;
               _loc9_.alpha = _loc10_.alpha;
               _loc9_.scaleX = _loc9_.scaleY = _loc10_.scale;
               if(_loc10_.isFlipX && param3)
               {
                  _loc9_.scaleX = -_loc9_.scaleX;
               }
            }
            _loc9_.x = param3 ? -(_loc10_.x + _loc9_.width) : _loc10_.x;
            if(_loc10_.isFlipX && param3)
            {
               _loc9_.x += _loc9_.width;
            }
            _loc9_.y = _loc10_.y;
            _loc6_++;
         }
      }
      
      public function clearFrame(param1:Sprite) : void
      {
         while(param1.numChildren > 0)
         {
            this.bitmapPool.push(param1.removeChildAt(0));
         }
      }
      
      public function cacheFrames(param1:Vector.<Vector.<FrameDescItem>>, param2:Boolean) : void
      {
         var _loc3_:Vector.<FrameDescItem> = null;
         var _loc4_:FrameDescItem = null;
         var _loc5_:uint = 0;
         for each(_loc3_ in param1)
         {
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = param2 ? uint(_loc4_.pid | 0x80000000) : _loc4_.pid;
               if(!this.pngCache[_loc5_])
               {
                  this.createPNG(_loc5_);
               }
            }
         }
      }
      
      private function getPID(param1:uint, param2:uint, param3:Boolean = false) : uint
      {
         var _loc4_:uint = (param1 << 18 | param2) + 1;
         if(param3)
         {
            _loc4_ |= 2147483648;
         }
         return _loc4_;
      }
      
      private function getLibIndex(param1:uint) : uint
      {
         return (param1 & 0x7FFC0000) >> 18;
      }
      
      private function getPngId(param1:uint) : uint
      {
         return (param1 & 0x03FFFF) - 1;
      }
      
      private function getPngFlip(param1:uint) : Boolean
      {
         return uint(param1 & 0x80000000) != 0;
      }
      
      public function getSize(param1:String) : uint
      {
         var _loc2_:Object = this.animHash[param1];
         if(_loc2_)
         {
            return _loc2_["_SIZE_"];
         }
         return 1;
      }
   }
}

