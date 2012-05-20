package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class RelatedViewMediator extends Mediator
	{
		
		public static const NAME:String = "relatedViewMediator";
		
		/**
		 * should the view be visible on "playerPlayEnd" notification 
		 */		
		public var showAfterPlayEnd:Boolean;
		/**
		 * last visible state of viewComponent 
		 */		
		private var _isRelatedShown:Boolean = true;

		
		public function RelatedViewMediator(viewComponent: Object = null)
		{
			super (NAME, viewComponent);
		}
		

		override public function listNotificationInterests():Array {
			return [
				NotificationType.PLAYER_PLAY_END,
				NotificationType.CHANGE_MEDIA,
				NotificationType.DO_PLAY,
				RelatedViewNotificationType.SHOW_HIDE_RELATED
			];
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName())
			{
				case NotificationType.PLAYER_PLAY_END:
					if (showAfterPlayEnd)
					{
						viewComponent.visible = true;
					}
					(viewComponent as relatedViewPluginCode).showReplayBtn = true;
					break;
				case NotificationType.CHANGE_MEDIA:
				case NotificationType.DO_PLAY: // in case we clicked replay
					viewComponent.visible = false;
					(viewComponent as relatedViewPluginCode).showReplayBtn = false;
					break;
				case RelatedViewNotificationType.SHOW_HIDE_RELATED:
					viewComponent.visible = !viewComponent.visible;
					if (viewComponent.visible)
						facade.sendNotification(NotificationType.DO_PAUSE);
					break;
			}
			
			if (_isRelatedShown != viewComponent.visible)
			{
				_isRelatedShown = viewComponent.visible;
				facade.sendNotification(RelatedViewNotificationType.RELATED_VISIBILITY_CHANGED, {visible: _isRelatedShown});
			}
		}
	}
}