package model.vo
{
   import proto.model.clan.PMember;
   
   public class VOClanMember
   {
      
      public var user:PMember;
      
      public var clan_place:Number;
      
      public var prize:Array;
      
      public var place:int;
      
      public var prize_pct:Number;
      
      public function VOClanMember(param1:PMember)
      {
         super();
         this.user = param1;
         this.clan_place = this.clan_place;
      }
   }
}

