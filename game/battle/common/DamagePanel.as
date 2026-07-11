package game.battle.common
{
   import engine.signal.Tween;
   import ui.UIFactory;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VFill;
   import ui.vbase.VSkin;
   import ui.vbase.VText;
   
   public class DamagePanel extends VComponent
   {
      
      private var text:VText;
      
      private var tween:Tween;
      
      private var last:uint = 4294967295;
      
      public function DamagePanel(param1:Boolean = true)
      {
         super();
         mouseChildren = false;
         layoutH = 34;
         addStretch(new VFill(0,0));
         add(SkinManager.getEmbed("FeatureIconBg",VSkin.BOTTOM),{"h":34});
         add(SkinManager.getEmbed("DamageIcon",VSkin.CACHE_AS_BITMAP),{
            "left":5,
            "h":40,
            "vCenter":0
         });
         this.text = UIFactory.createYellowText(null,0,22,param1);
         add(this.text,{
            "left":42,
            "right":0,
            "vCenter":1
         });
         this.tween = new Tween(this);
         this.tween.propertyList = ["value",0,0];
         this.tween.stopHandler = this.onTweenKill;
         this.tween.duration = 1.2;
      }
      
      public function set value(param1:uint) : void
      {
         if(this.last != param1)
         {
            this.last = param1;
            this.text.value = param1 + "%";
         }
      }
      
      public function get value() : uint
      {
         return this.last;
      }
      
      public function setTweenValue(param1:int) : void
      {
         if(this.tween.propertyList[2] != param1)
         {
            this.tween.propertyList[2] = param1;
            if(this.last == param1)
            {
               this.tween.stop();
            }
            else
            {
               this.tween.propertyList[1] = this.last;
               this.tween.repeat();
            }
         }
      }
      
      private function onTweenKill(param1:Tween) : void
      {
         this.value = param1.propertyList[2];
      }
   }
}

