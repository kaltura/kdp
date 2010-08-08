package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class WatermarkMediator extends Mediator
	{
		public static const NAME:String = "watermarkMediator";
		
		public function WatermarkMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return  [NotificationType.ROOT_RESIZE];
		}
		
		override public function handleNotification(note:INotification):void
		{
			switch(note.getName())
			{
				case NotificationType.ROOT_RESIZE:
				if(view)
				{
					(view as Watermark).updateWaterMarkPosition();
				}
				break;
			}
		}
		
		public function get view() : DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
	}
}