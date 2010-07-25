package com.kaltura.kdpfl.plugin.component
{
   import flash.events.Event;
   
   public class EMLoaderEvent extends Event
   {
      public static const LOAD_PROGRESS:String = "load_progress";
      public var percent:Number;
      
      public function EMLoaderEvent(type:String, bubbles:Boolean=true, pc:Number=0)
      {
         super(type, bubbles);
         percent=pc;
      }
      
      public override function clone():Event
      {
         return new EMLoaderEvent(type,bubbles,percent);
      }
   }
}
