package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class WatermarkMediator extends Mediator
	{
		public static const NAME:String = "watermarkMediator";
		
		public function WatermarkMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			(viewComponent as DisplayObject).addEventListener(Watermark.WATERMARK_CLICK , onWatermarkClick);
			(viewComponent as DisplayObject).addEventListener(Watermark.WATERMARK_PAUSE , onWatermarkPause);
		}
		
		public function onWatermarkClick(event:Event):void
		{
			facade.sendNotification('watermarkClick',(view as Watermark).watermarkNotification);
		}
		
		/**
		 * If the watermark was clicked - it needs to pause the video 
		 */
		public function onWatermarkPause(event:Event):void
		{
			facade.sendNotification('doPause');
		}
		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
	}
}