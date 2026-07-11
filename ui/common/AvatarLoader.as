package ui.common
{
   import ESkins.DefaultIcon;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import proto.model.PUserBase;
   import ui.UIFactory;
   import ui.vbase.AssetLoader;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   
   public class AvatarLoader extends VComponent
   {
      
      private var avatarObject:DisplayObject;
      
      private var clip:VSkin;
      
      private var a_loader:AssetLoader;
      
      private var isAllowResize:Boolean;
      
      private var cache_url:String;
      
      public function AvatarLoader(param1:Boolean = false)
      {
         super();
         mouseChildren = false;
         if(param1)
         {
            mask = new VFill(0);
            addStretch(mask as VFill);
         }
      }
      
      public function setClip(param1:Boolean) : void
      {
         if(param1 && Boolean(this.avatarObject))
         {
            return;
         }
         if(param1 != Boolean(this.clip))
         {
            if(param1)
            {
               this.clip = UIFactory.getExternalLoadClip();
               add(this.clip);
            }
            else
            {
               remove(this.clip);
               this.clip = null;
            }
         }
      }
      
      public function reset(param1:Boolean = true) : void
      {
         this.isAllowResize = false;
         this.cache_url = null;
         if(this.a_loader)
         {
            this.a_loader.reset();
            this.a_loader = null;
         }
         if(param1)
         {
            this.setClip(false);
         }
         if(this.avatarObject)
         {
            this.avatarObject.mask = null;
            removeChild(this.avatarObject);
            this.avatarObject = null;
         }
      }
      
      public function load(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:PUserBase = null;
         var _loc4_:int = 0;
         if(param1 is PUserBase)
         {
            _loc3_ = param1 as PUserBase;
            _loc4_ = int(calcAccurateW());
            if(_loc4_ > 0)
            {
               switch(Facade.socialnet)
               {
                  case Facade.VKONTAKTE:
                  case Facade.FACEBOOK:
                     _loc2_ = Math.abs(_loc4_ - 100) < Math.abs(_loc4_ - 50) ? _loc3_.avatar : _loc3_.avatar_small;
                     break;
                  case Facade.ODNOKLASSNIKI:
                     _loc2_ = Math.abs(_loc4_ - 128) < Math.abs(_loc4_ - 50) ? _loc3_.avatar : _loc3_.avatar_small;
                     break;
                  case Facade.MOYMIR:
                     _loc2_ = _loc4_ >= 80 ? _loc3_.avatar : _loc3_.avatar_small;
               }
            }
            if(!_loc2_)
            {
               _loc2_ = _loc3_.avatar_small ? _loc3_.avatar_small : _loc3_.avatar;
            }
         }
         else
         {
            _loc2_ = param1 as String;
         }
         if(Boolean(this.cache_url) && this.cache_url == _loc2_)
         {
            return;
         }
         this.reset(false);
         if(_loc2_)
         {
            this.cache_url = _loc2_;
            this.setClip(true);
            this.a_loader = new AssetLoader();
            this.a_loader.init(this.onLoadHandler);
            this.a_loader.loadEx(_loc2_,this.a_loader.getLoaderContext(false,true));
         }
         else
         {
            this.setClip(false);
            this.useDefaultAvatar();
         }
      }
      
      private function onLoadHandler(param1:AssetLoader) : void
      {
         this.setClip(false);
         this.a_loader = null;
         if(!param1.isError)
         {
            this.isAllowResize = param1.loader.contentLoaderInfo.childAllowsParent;
            if(this.isAllowResize && param1.loader.content is Bitmap)
            {
               (param1.loader.content as Bitmap).smoothing = true;
            }
            this.applyAvatarObject(param1.loader);
         }
         else
         {
            this.useDefaultAvatar();
         }
      }
      
      private function applyAvatarObject(param1:DisplayObject) : void
      {
         this.avatarObject = param1;
         if(param1)
         {
            addChildAt(param1,1);
            this.layoutAvatarObject();
         }
      }
      
      private function layoutAvatarObject() : void
      {
         if(this.isAllowResize)
         {
            if(w / h <= this.avatarObject.width / this.avatarObject.height)
            {
               this.avatarObject.height = h;
               this.avatarObject.scaleX = this.avatarObject.scaleY;
            }
            else
            {
               this.avatarObject.width = w;
               this.avatarObject.scaleY = this.avatarObject.scaleX;
            }
            this.avatarObject.x = 0;
            this.avatarObject.y = 0;
         }
         else
         {
            this.avatarObject.x = Math.round((w - this.avatarObject.width) / 2);
            this.avatarObject.y = this.avatarObject.height > h ? 0 : Math.round((h - this.avatarObject.height) / 2);
         }
      }
      
      override protected function customUpdate() : void
      {
         super.customUpdate();
         if(this.avatarObject)
         {
            this.layoutAvatarObject();
         }
      }
      
      private function useDefaultAvatar() : void
      {
         this.isAllowResize = true;
         this.applyAvatarObject(new DefaultIcon());
      }
      
      override public function dispose() : void
      {
         this.reset();
         super.dispose();
      }
   }
}

