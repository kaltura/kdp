package com.kaltura.kdpfl.plugin.component
{
   import flash.events.Event;
   
   public class EZEvent extends Event
   {
      public var string:String;
      public var number:Number;
      
      public function EZEvent(type:String, bubbles:Boolean=true, str:String="", num:Number=0)
      {
         super(type, bubbles);
         string=str;
		 number=num;
      }
      
      public override function clone():Event
      {
         return new EZEvent(type,bubbles,string,number);
      }
   }
}
