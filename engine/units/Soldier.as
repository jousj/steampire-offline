package engine.units
{
   import engine.data.MapCell;
   import engine.display.AnimClip;
   import engine.display.AnimDisplay;
   import engine.display.Animation;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import proto.model.PShopUnit;
   import utils.CommonUtils;
   
   public class Soldier extends MovementUnit
   {
      
      private static const AS_STAND:uint = 1;
      
      private static const AS_WALK:uint = 2;
      
      private static const AS_ATTACK:uint = 3;
      
      private static const AS_READY:uint = 4;
      
      public var shop:PShopUnit;
      
      public var is_attacker:Boolean;
      
      public var user_num:uint;
      
      public var isAudio:Boolean;
      
      public var isSingleAudio:Boolean;
      
      public var audioKind:String;
      
      public var isWalk:Boolean;
      
      public var walkAudioKind:String;
      
      private var attackAnimNum:uint = 1;
      
      private var attackAnimIndex:uint;
      
      private var animState:uint;
      
      public function Soldier(param1:PShopUnit)
      {
         super();
         animClip.endHandler = this.onAnimEnd;
         this.assignShop(param1);
         calcMoveData(param1.su_kind,param1.su_move_delay / 1000);
         isAllowPhantom = param1.su_kind == "un_healer";
         if(isAllowPhantom || param1.su_is_air)
         {
            isIgnoreFence = true;
         }
         walkAir = param1.su_is_air;
      }
      
      public function assignShop(param1:PShopUnit) : void
      {
         if(param1.su_kind.indexOf("un_raid") != -1)
         {
            applyKind(param1.su_kind.replace("raid","boss") + "_level1");
            size = 5;
         }
         else
         {
            applyKind(param1.su_kind + "_level" + param1.su_model_level);
         }
         this.shop = param1;
         level = param1.su_level;
         stamina = param1.su_stamina;
         armor = param1.su_armor;
         while(animHash.hasOwnProperty("attack" + (this.attackAnimNum + 1).toString()))
         {
            ++this.attackAnimNum;
         }
         this.attackAnimIndex = 1;
         boomList = boomHash[kind];
      }
      
      override public function startWalk(param1:Number, param2:MapCell, param3:Boolean) : void
      {
         this.animState = AS_WALK;
         super.startWalk(param1,param2,param3);
      }
      
      public function playAttack() : void
      {
         if(this.attackAnimNum > 1)
         {
            this.attackAnimIndex = CommonUtils.getRangeRandom(1,this.attackAnimNum);
         }
         var _loc1_:Animation = changeAnimation("attack" + this.attackAnimIndex);
         this.animState = AS_ATTACK;
         animClip.play(_loc1_);
      }
      
      override public function stand() : void
      {
         this.animState = AS_STAND;
         super.stand();
      }
      
      public function get isStand() : Boolean
      {
         return this.animState == AS_STAND;
      }
      
      private function onAnimEnd() : void
      {
         if(this.animState == AS_ATTACK)
         {
            this.animState = AS_READY;
            playAnim("ready" + this.attackAnimIndex.toString());
         }
         else if(this.animState != AS_STAND)
         {
            this.stand();
         }
      }
      
      public function changeMarkerClip(param1:Boolean) : void
      {
         var _loc3_:AnimClip = null;
         var _loc2_:String = "soldierArea";
         if(param1 && this.user_num < 5)
         {
            _loc3_ = new AnimClip();
            _loc3_.name = _loc2_;
            _loc3_.addChild(new (getDefinitionByName("ESkins.SoldierArea" + this.user_num) as Class)() as Sprite).cacheAsBitmap = true;
            display.add(_loc3_,AnimDisplay.OUTSIDE);
            board.tilePanel.addChild(_loc3_);
         }
         else
         {
            display.removeByName(_loc2_);
         }
      }
   }
}

