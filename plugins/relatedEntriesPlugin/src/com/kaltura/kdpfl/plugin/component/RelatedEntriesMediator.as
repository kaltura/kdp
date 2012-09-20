package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class RelatedEntriesMediator extends Mediator
	{
		
		public static const NAME:String = "relatedEntriesMediator";
		
		private var _pluginCode:relatedEntriesPluginCode;
		
		public function RelatedEntriesMediator( viewComponent:Object=null)
		{
			_pluginCode = viewComponent as relatedEntriesPluginCode;
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return 	[
				NotificationType.ENTRY_READY,
				RelatedEntriesNotificationType.LOAD_RELATED_ENTRIES,
				RelatedEntriesNotificationType.RELATED_ITEM_CLICKED,
				RelatedEntriesNotificationType.NEXT_UP_ITEM_CHANGED,
				"relatedVisibilityChanged",
				RelatedEntriesNotificationType.PAUSE_RESUME_RELATED_TIMER,
				];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case NotificationType.ENTRY_READY:
				case RelatedEntriesNotificationType.LOAD_RELATED_ENTRIES:
					_pluginCode.loadEntries();
					break;
				case RelatedEntriesNotificationType.NEXT_UP_ITEM_CHANGED:
				case RelatedEntriesNotificationType.RELATED_ITEM_CLICKED:
					var newIndex:int = notification.getBody().index;
					_pluginCode.setUpNext(newIndex);
					if (notification.getName()==RelatedEntriesNotificationType.RELATED_ITEM_CLICKED)
						_pluginCode.startAction();
					break;
				case "relatedVisibilityChanged":
					if (_pluginCode.autoPlay)
					{
						if (notification.getBody().visible)
						{
							_pluginCode.startTimer();
						}
						else
						{
							_pluginCode.stopTimer();							
						}
					}
					break;
				case RelatedEntriesNotificationType.PAUSE_RESUME_RELATED_TIMER:
					if (_pluginCode.isTimerRunning)
					{
						_pluginCode.stopTimer();						
					}
					else
					{
						_pluginCode.resumeTimer();						
					}
					break;
			}
		}
	}
}