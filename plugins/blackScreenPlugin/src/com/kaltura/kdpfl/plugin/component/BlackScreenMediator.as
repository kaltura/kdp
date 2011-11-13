package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.media.KMediaPlayer;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.observer.Notification;
	
	public class BlackScreenMediator extends Mediator
	{
		public static const NAME : String = "BlackScreenMediator";
		private var _lastVolume:Number = 1;
		private var _wasMuted:Boolean = false;
		private var _playerMediator:KMediaPlayerMediator;
		
		public function BlackScreenMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
			
		}
		
		override public function listNotificationInterests():Array
		{
			var returnArray : Array = [
				NotificationType.PLAYER_UPDATE_PLAYHEAD, 
				NotificationType.LAYOUT_READY];
			
			return returnArray;
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
				switch (notification.getName())
				{
					case NotificationType.LAYOUT_READY:
						_playerMediator = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator);
						_lastVolume = _playerMediator.player.volume;
						break;
					case NotificationType.PLAYER_UPDATE_PLAYHEAD:
						var currentTime : Number = notification.getBody() as Number;
						
						if (((viewComponent as BlackScreenPluginCode).clipStartTime && (viewComponent as BlackScreenPluginCode).clipStartTime != -1 && isNaN(currentTime)) ||
							(((viewComponent as BlackScreenPluginCode).clipStartTime != -1 && currentTime < (viewComponent as BlackScreenPluginCode).clipStartTime) || (((viewComponent as BlackScreenPluginCode).clipEndTime != -1) && currentTime > (viewComponent as BlackScreenPluginCode).clipEndTime)))
						{
							if (!_wasMuted) {
								_lastVolume = _playerMediator.player.volume;
								sendNotification( NotificationType.CHANGE_VOLUME, 0 );
								_wasMuted = true;
								(viewComponent as BlackScreenPluginCode).showBlackLayer();
							}					
						}		
						else if (_wasMuted)
						{
							sendNotification( NotificationType.CHANGE_VOLUME, _lastVolume);
							_wasMuted = false;
							(viewComponent as BlackScreenPluginCode).hideBlackLayer();
						}
						break;

				}
		}
	}
}