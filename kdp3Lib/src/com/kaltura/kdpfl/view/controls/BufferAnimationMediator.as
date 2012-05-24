package com.kaltura.kdpfl.view.controls
{
	import com.kaltura.kdpfl.controller.media.LiveStreamCommand;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import org.osmf.media.MediaPlayerState;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * Mediator for the buffer indicator animation. Controls the appearance and removal of the animation from the display list. 
	 * @author Hila
	 * 
	 */
	public class BufferAnimationMediator extends Mediator
	{
		public static const NAME:String = "spinnerMediator";
		public static const SPINNER_CLASS : String = "kspin";
		public var applicationLoadStyleName:String = '';
		public var bufferingStyleName:String = '';
		private var zeroPoint : Point = new Point( 0 , 0);
		
		/**
		 * flag indicating whether the active media has reached its end.
		 */		
		private var _reachedEnd:Boolean=false;
		private var _currConfig : ConfigProxy;
		private var _notBuffering : Boolean = true;
		private var _prevStatePaused:Boolean = true;
		private var _lastPlayheadPos:Number;
		
		/**
		 * indicate if "bufferChange" event was sent, we started buffering 
		 */		
		private var _bufferChangeStart:Boolean = false;
		
		/**
		 * Constructor. 
		 * @param viewComponent - the component controlled by the mediator.
		 * 
		 */		
		public function BufferAnimationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			_currConfig = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
		}
		
		override public function handleNotification(note:INotification):void
		{
			var flashvars : Object = _currConfig.vo.flashvars;
			var noteName : String = note.getName();
			switch(noteName)
			{
				case NotificationType.SKIN_LOADED:
					//					spinner.swapLoadingWithAnimation( applicationLoadStyleName == '' ? SPINNER_CLASS : applicationLoadStyleName );
					spinner.visible = false;
					break;
				case NotificationType.LAYOUT_READY:
					if (flashvars.usePreloaderBufferAnimation && flashvars.usePreloaderBufferAnimation=='true' && flashvars.preloader)
					{
						spinner.setBufferingAnimation(getQualifiedClassName(flashvars.preloader));
					}
					else
					{
						spinner.setBufferingAnimation(applicationLoadStyleName == '' ? SPINNER_CLASS : applicationLoadStyleName );					
					}
					break;
				case NotificationType.KDP_READY:
				case NotificationType.READY_TO_PLAY:
					spinner.visible = false;
					_reachedEnd = false;
					if (flashvars.usePreloaderBufferAnimation && flashvars.usePreloaderBufferAnimation=='true' && flashvars.preloader)
					{
						spinner.setBufferingAnimation(getQualifiedClassName(flashvars.preloader));
					}
					else
					{
						spinner.setBufferingAnimation(applicationLoadStyleName == '' ? SPINNER_CLASS : applicationLoadStyleName );					
					}
					break;
				case NotificationType.PLAYER_STATE_CHANGE:
					if( note.getBody() == MediaPlayerState.BUFFERING)
					{
						_notBuffering = false;
						if(_reachedEnd)
							spinner.visible = false;
							//fix OSMF bug: sometimes "buffering" was sent after player paused, the spinner shouldn't be visible in this case
						else if (!_prevStatePaused)
							spinner.visible = true;
						
					}
					else
					{
						//only relevant if not rtmp
						/* if( note.getBody() == MediaPlayerState.READY ){
						spinner.visible = false;
						}
						if(_flashvars.streamerType != StreamerType.RTMP){
						spinner.visible = false;
						} */
						_notBuffering = true;
						if( note.getBody() == MediaPlayerState.PLAYING)
						{
							_reachedEnd = false;
							_prevStatePaused = false;
						//	spinner.visible = false;
						}
						if(note.getBody() == MediaPlayerState.PAUSED)
						{
							spinner.visible = false;
							_prevStatePaused = true;
						}
						if( note.getBody() == MediaPlayerState.READY)
						{
							spinner.visible = false;
						}
					}
					
					break;
				
				/**
				 * Until OSMF for seeking in rtmp is fixed (buffering-wise) 
				 * add a new case for update playhead notification
				 * */
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					//if _bufferChangeStart the next bufferChange event will make the spinner invisible
					if(_notBuffering && !_bufferChangeStart)
					{						
						spinner.visible = false;
					}
					//fix another OSMF bug: we are buffering even though movie plays
					else if (spinner.visible)
					{
						var updateIntervalInSeconds:Number = (facade.retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator).player.currentTimeUpdateInterval / 1000;
						var curPos:Number = parseFloat(Number(note.getBody()).toFixed(2));
						if ((curPos - _lastPlayheadPos)<=updateIntervalInSeconds)
						{
							spinner.visible = false;
						}
						_lastPlayheadPos = curPos;
					}
					
					break;
				case NotificationType.BUFFER_CHANGE:
					_bufferChangeStart = note.getBody();
					spinner.visible = _bufferChangeStart;
					break;
				case NotificationType.PLAYER_PLAY_END:
					_reachedEnd=true;
					spinner.visible = false;
					break;
				case NotificationType.KDP_EMPTY:
				case NotificationType.READY_TO_LOAD:
					spinner.visible = false;
					_reachedEnd=false;
					if (flashvars.usePreloaderBufferAnimation && flashvars.usePreloaderBufferAnimation=='true' && flashvars.preloader)
					{
						spinner.setBufferingAnimation(getQualifiedClassName(flashvars.preloader));
					}
					else
					{
						spinner.setBufferingAnimation(applicationLoadStyleName == '' ? SPINNER_CLASS : applicationLoadStyleName );					
					}
					break;
				case NotificationType.CHANGE_MEDIA:
					//spinner.visible = true;
					
					break;
				
				//in case we are trying to connect to a live stream but it is not on air yet
				case NotificationType.LIVE_ENTRY:
					if (flashvars.hideSpinnerOnOffline=="true")
						spinner.visible = false;
					else
						spinner.visible = true;
					break;
				
				//in case the live stream we are trying to connect to was found to be on air
				case LiveStreamCommand.LIVE_STREAM_READY:
					spinner.visible = false;
					break;
				
				case NotificationType.PRELOADER_LOADED:
					var preObj:Object = note.getBody().preloader;
					if (flashvars.usePreloaderBufferAnimation && flashvars.usePreloaderBufferAnimation=='true' && preObj)
					{
						//save to flashvara, we might need it in the future
						_currConfig.vo.flashvars["preloader"] = preObj;
						spinner.setBufferingAnimation(getQualifiedClassName(preObj));
					}
					break;
				
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				NotificationType.SKIN_LOADED,
				NotificationType.PLAYER_STATE_CHANGE,
				NotificationType.PLAYER_PLAYED,
				NotificationType.PLAYER_UPDATE_PLAYHEAD, //TODO: REMOVE THIS WHEN I FIND A BETTER WORK AROUND TO THE BUG
				NotificationType.ENTRY_FAILED,
				NotificationType.CHANGE_MEDIA,
				NotificationType.PLAYER_PLAY_END,
				NotificationType.KDP_EMPTY,
				NotificationType.KDP_READY,
				NotificationType.LAYOUT_READY,
				NotificationType.LIVE_ENTRY,
				LiveStreamCommand.LIVE_STREAM_READY,
				NotificationType.MEDIA_READY,
				NotificationType.READY_TO_PLAY,
				NotificationType.READY_TO_LOAD,
				NotificationType.ROOT_RESIZE,
				NotificationType.BUFFER_CHANGE,
				NotificationType.PRELOADER_LOADED
			];
		}
		/**
		 * the buffer indicator animation controlled by the mediator. 
		 * @return 
		 * 
		 */		
		public function get spinner():BufferAnimation
		{
			return viewComponent as BufferAnimation;
		}
		
	}
}