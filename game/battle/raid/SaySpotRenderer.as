package game.battle.raid
{
   import model.vo.VORaidMember;
   import ui.Style;
   import ui.game.CircleAvatarPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VLabel;
   import ui.vbase.VSkin;
   
   public class SaySpotRenderer extends VComponent
   {
      
      public var index:uint;
      
      public var delay:uint;
      
      public var cacheId:String;
      
      private const avatar:CircleAvatarPanel;
      
      private const label:VLabel;
      
      public function SaySpotRenderer()
      {
         var _loc1_:VSkin = null;
         this.avatar = new CircleAvatarPanel();
         this.label = new VLabel(null,VLabel.MIDDLE | VLabel.LEADING_BOX);
         super();
         layoutH = 44;
         _loc1_ = SkinManager.getEmbed("ChatSayBg",VSkin.STRETCH_BG);
         _loc1_.alpha = 0.8;
         add(_loc1_,{
            "left":40,
            "right":0
         });
         add(this.avatar,{
            "w":40,
            "h":40,
            "bottom":0
         });
         add(this.label,{
            "left":55,
            "right":9,
            "h":34,
            "maxW":220
         });
      }
      
      public function update(param1:VORaidMember, param2:String) : void
      {
         if(this.cacheId != param1.id)
         {
            this.cacheId = param1.id;
            this.avatar.setUser(param1.ub,param1.num);
         }
         this.label.text = "<p" + Style.metalColor + "lineHeight=\"93%\" fontSize=\"14\">" + param2 + "</p>";
      }
   }
}

