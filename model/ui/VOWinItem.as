package model.ui
{
   import proto.model.PMissionWin;
   
   public class VOWinItem
   {
      
      public var info:PMissionWin;
      
      public var count:uint;
      
      public function VOWinItem(param1:PMissionWin, param2:uint)
      {
         super();
         this.info = param1;
         this.count = param2;
      }
   }
}

