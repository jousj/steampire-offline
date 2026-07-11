package game.my
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import ui.Style;
   import ui.common.LevelPanel;
   import ui.vbase.SkinManager;
   import ui.vbase.VComponent;
   import ui.vbase.VSkin;
   
   public class ExpPanel extends VComponent
   {
      
      public const levelPanel:LevelPanel = new LevelPanel();
      
      public const shape:Shape = new Shape();
      
      public const leagueSkin:VSkin = new VSkin();
      
      private var cur:uint;
      
      private var max:uint;
      
      private var prev:uint;
      
      private var league:uint;
      
      public function ExpPanel()
      {
         super();
         mouseChildren = false;
         add(SkinManager.getEmbed("MainLvlBg"),{
            "w":70,
            "h":70,
            "top":8,
            "left":8
         });
         addChild(SkinManager.getEmbed("ExpPbBg"));
         var _loc1_:VSkin = SkinManager.getEmbed("ExpPbInd");
         add(_loc1_,{
            "left":1,
            "top":1
         });
         addChild(this.shape);
         _loc1_.mask = this.shape;
         this.levelPanel.setCustomSize(59,56,28,12,10);
         add(this.levelPanel,{
            "left":13,
            "vCenter":-1
         });
         hint = this.getHint;
         add(this.leagueSkin,{
            "bottom":0,
            "right":0,
            "h":30
         });
      }
      
      public function setData(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint) : void
      {
         this.levelPanel.value = param1;
         this.max = param3;
         this.prev = param4;
         this.setCur(param2);
         if(param5 > 0 && this.league != param5)
         {
            this.league = param5;
            SkinManager.applyEmbed(this.leagueSkin,"league" + param5.toString());
         }
      }
      
      public function setCur(param1:uint) : void
      {
         this.cur = param1;
         this.drawMask((param1 - this.prev) / (this.max - this.prev) * 180);
      }
      
      private function drawMask(param1:Number) : void
      {
         var _loc2_:Number = 43;
         var _loc3_:Number = 42;
         var _loc4_:Number = 60;
         var _loc5_:Matrix = new Matrix();
         var _loc6_:Graphics = this.shape.graphics;
         _loc6_.clear();
         _loc6_.beginFill(16711680,0.5);
         _loc6_.moveTo(_loc2_,_loc3_);
         _loc6_.lineTo(_loc2_,_loc3_ + _loc4_);
         var _loc7_:Point = this.getPoint(_loc5_,_loc2_,_loc3_,param1 > 90 ? 90 : param1,_loc4_);
         _loc6_.lineTo(_loc7_.x,_loc7_.y);
         if(param1 > 90)
         {
            _loc7_ = this.getPoint(_loc5_,_loc2_,_loc3_,param1,_loc4_);
            _loc6_.lineTo(_loc7_.x,_loc7_.y);
         }
         _loc6_.endFill();
      }
      
      private function getPoint(param1:Matrix, param2:Number, param3:Number, param4:Number, param5:Number) : Point
      {
         param1.identity();
         param1.rotate(Math.PI / 180 * param4);
         param1.translate(param2,param3);
         return param1.transformPoint(new Point(0,param5));
      }
      
      private function getHint() : String
      {
         return "<p" + Style.metalColor + ">" + Lang.getString("Exp") + "</p><p>" + (this.max != uint.MAX_VALUE ? this.cur + "/" + this.max + "</p><p>" + Lang.getPatternString("exp_next","__VALUE__",String(this.max - this.cur)) : Lang.getString("max_exp")) + (this.leagueSkin.parent ? "</p><p>" + Lang.getPatternString("cur_league","__NAME__","league" + this.league,true) + "</p>" : "</p>");
      }
      
      public function set compactLevelMode(param1:Boolean) : void
      {
         this.levelPanel.resetLayout();
         if(param1)
         {
            this.levelPanel.setCustomSize(32,32,18,2,0);
            this.levelPanel.bottom = this.levelPanel.right = 0;
         }
         else
         {
            this.levelPanel.setCustomSize(59,56,28,12,10);
            this.levelPanel.left = 13;
            this.levelPanel.vCenter = -1;
         }
         this.levelPanel.reset();
         this.levelPanel.syncLayout();
         if(param1 == Boolean(this.leagueSkin.parent))
         {
            if(param1)
            {
               remove(this.leagueSkin,false);
            }
            else
            {
               add(this.leagueSkin);
            }
         }
      }
   }
}

