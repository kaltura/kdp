package com.kaltura.kdpfl
{
	import com.kaltura.kdpfl.controller.InitMacroCommand;
	import com.kaltura.kdpfl.controller.LayoutReadyCommand;
	import com.kaltura.kdpfl.controller.PlaybackCompleteCommand;
	import com.kaltura.kdpfl.controller.SequenceItemPlayEndCommand;
	import com.kaltura.kdpfl.controller.SequenceSkipNextCommand;
	import com.kaltura.kdpfl.controller.StartupCommand;
	import com.kaltura.kdpfl.controller.media.InitChangeMediaMacroCommand;
	import com.kaltura.kdpfl.controller.media.LiveStreamCommand;
	import com.kaltura.kdpfl.controller.media.MediaReadyCommand;
	import com.kaltura.kdpfl.events.DynamicEvent;
	import com.kaltura.kdpfl.model.ExternalInterfaceProxy;
	import com.kaltura.kdpfl.model.type.DebugLevel;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.controls.KTrace;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.puremvc.as3.core.KView;
	
	import flash.display.DisplayObject;
	
	import mx.utils.ObjectProxy;
	
	import org.osmf.media.MediaPlayerState;
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade implements IFacade
	{
		/**
		 * The current version of the KDP.
		 */		
		public var kdpVersion : String = "v3.9.9";


		/**
		 * save any mediator name that is registered to this array in order to delete at any time
		 * (the pure mvc don't support it as built-in function)
		 */		
		private var _mediatorNameArray : Array = new Array();
		/**
		 * save any proxy name that is registered to this array in order to delete at any time
		 * (the pure mvc don't support it as built-in function)
		 */	
		private var _proxyNameArray : Array = new Array();
		/**
		 * save any notification that create a command name that is registered to this array in order to delete at any time
		 * (the pure mvc don't support it as built-in function)
		 */	
		private var _commandNameArray : Array = new Array();
		
		/**
		 * The bindObject create dynamicly all attributes that need to be binded on it 
		 */		
		public var bindObject:ObjectProxy = new ObjectProxy();	
		/**
		 * a reference to KDP3 main application
		 */		
		private var _app : DisplayObject;
		
		/**
		 * the url of the kdp 
		 */
		public var appFolder : String;
		public var debugMode : Boolean = false;
		/**
		 * 
		 * will affect the traces that will be sent. See DebugLevel enum
		 */		
		public var debugLevel:int;
		
		
		
		private var externalInterface : ExternalInterfaceProxy;
			 	
		/**
		 * return the one and only instance of the ApplicationFacade, 
		 * if not exist it will be created.
		 * @return 
		 * 
		 */		
		public static function getInstance() : ApplicationFacade
		{
			if (instance == null) instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		/**
		 * All this simply does is fire a notification which is routed to 
		 * "StartupCommand" via the "registerCommand" handlers 
		 * @param app
		 * 
		 */		
		public function start(app:DisplayObject):void
		{
			CONFIG::isSDK46 {
				kdpVersion += ".sdk46";
			}
			
			_app = app;
			appFolder = app.root.loaderInfo.url;
			appFolder = appFolder.substr(0, appFolder.lastIndexOf('/') + 1);

			sendNotification(NotificationType.STARTUP, app);
			externalInterface = retrieveProxy(ExternalInterfaceProxy.NAME) as ExternalInterfaceProxy;
		}


		/**
		 * Created to trace all notifications for debug
		 * @param notificationName
		 * @param body
		 * @param type
		 *
		 */
		override public function sendNotification(notificationName:String, body:Object = null, type:String = null):void {
			if (debugMode) {
				var s:String;
				if ((notificationName == NotificationType.BYTES_DOWNLOADED_CHANGE && debugLevel == DebugLevel.HIGH) ||
					(notificationName == NotificationType.PLAYER_UPDATE_PLAYHEAD && (debugLevel == DebugLevel.HIGH || debugLevel == DebugLevel.MEDIUM)) ||
					(notificationName != NotificationType.PLAYER_UPDATE_PLAYHEAD && notificationName != NotificationType.BYTES_DOWNLOADED_CHANGE))
				 {
					if (notificationName == NotificationType.PLAYER_STATE_CHANGE)
						s = 'Sent ' + notificationName + ' ==> ' + body.toString();
					else {
						s = 'Sent ' + notificationName;
						if (body) {
							var found:Boolean = false;
							for (var o:* in body) {
								s += ", " + o + ":" + body[o];
								found = true;
							}
							if (!found) {
								s += ", " + body.toString();
							}
						}
					}
				}
			
				if (s && s != "null") {
					var curTime:Number = 0;
					var kmediaPlayerMediator:KMediaPlayerMediator = retrieveMediator(KMediaPlayerMediator.NAME) as KMediaPlayerMediator;
					if (kmediaPlayerMediator && 
						kmediaPlayerMediator.player && 
						kmediaPlayerMediator.player.state!=MediaPlayerState.LOADING &&
						kmediaPlayerMediator.player.state!=MediaPlayerState.UNINITIALIZED &&
						kmediaPlayerMediator.player.state!=MediaPlayerState.PLAYBACK_ERROR)
					{
						curTime = kmediaPlayerMediator.getCurrentTime();
					}
					var date:Date = new Date();
					
					KTrace.getInstance().log(date.toTimeString(), ":", s, ", playhead position:", curTime);
				}

			}

			super.sendNotification(notificationName, body, type);
			//For external Flash/Flex application application listening to the KDP events
			_app.dispatchEvent(new DynamicEvent(notificationName, body));

			//For external Javascript application listening to the KDP events
			if (externalInterface)
				externalInterface.notifyJs(notificationName, body);

		}
		
		/**
		 * controls the routing of notifications to our controllers, 
		 * we all know them as commands
		 * 
		 */		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(NotificationType.STARTUP, StartupCommand);
			
			// we do both init start KDP life cycle, and start to load the entry simultaneously 
			registerCommand(NotificationType.INITIATE_APP, InitMacroCommand);
			
			//There are several things that need to be done as soon as the layout of the kdp is ready.
			registerCommand(NotificationType.LAYOUT_READY, LayoutReadyCommand );
			//when one call change media we fire the load media command again
			registerCommand(NotificationType.CHANGE_MEDIA, InitChangeMediaMacroCommand);
			
			registerCommand (NotificationType.LIVE_ENTRY, LiveStreamCommand );
			
			registerCommand (NotificationType.MEDIA_LOADED, MediaReadyCommand );
			
			registerCommand (NotificationType.PLAYBACK_COMPLETE, PlaybackCompleteCommand);
			
			registerCommand(NotificationType.SEQUENCE_ITEM_PLAY_END, SequenceItemPlayEndCommand);
			
			registerCommand(NotificationType.SEQUENCE_SKIP_NEXT, SequenceSkipNextCommand);
		}
		
		override protected function initializeView():void
		{
			if ( view != null ) return;
			view = KView.getInstance();
		}
		
		override protected function initializeFacade():void
		{
			initializeView();
			initializeModel();
			initializeController();
		}
		
		/**
		 * Help to remove all commands, mediator, proxies from the facade
		 * 
		 */		
		public function dispose() : void
		{
			var i:int =0;
			
			for(i=0; i<_commandNameArray.length; i++)
				this.removeCommand( _commandNameArray[i] );
			
			for(i=0; i<_mediatorNameArray.length; i++)
				this.removeMediator( _mediatorNameArray[i] );
				
			for(i=0; i<_proxyNameArray.length; i++)
				this.removeProxy( _proxyNameArray[i] );
				
			_commandNameArray = new Array();
			_mediatorNameArray = new Array();
			_proxyNameArray = new Array();
		}
		
		/**
		 * after registartion add the notification name to a  
		 * @param notificationName
		 * @param commandClassRef
		 * 
		 */		
		override public function registerCommand(notificationName:String, commandClassRef:Class):void
		{
			super.registerCommand(notificationName, commandClassRef);

			//save the notification name so we can delete it later
			_commandNameArray.push( notificationName );
		}
		
		override public function registerMediator(mediator:IMediator):void
		{
			super.registerMediator(mediator);
			
			//save the mediator name so we can delete it later
			_mediatorNameArray.push( mediator.getMediatorName() ); 
		}
		
		override public function registerProxy(proxy:IProxy):void
		{
			bindObject[proxy.getProxyName()] = proxy.getData();
			
			super.registerProxy(proxy);
			
			//save the proxy name so we can delete it later
			_proxyNameArray.push( proxy.getProxyName() );
		}
		
		/**
		 * add notification observer for a given mediator 
		 * @param notification the notification to listen for
		 * @param notificationHandler handler to be called
		 * @param mediator
		 * 
		 */		
		public function addNotificationInterest(notification:String, notificationHandler:Function, mediator:IMediator):void {
			(view as KView).addNotificationInterest(notification, notificationHandler, mediator);
		}
		
		public function get app () : DisplayObject
		{
			return _app;
		}
		
		public function set app (disObj : DisplayObject) : void
		{
			_app = disObj;
		}
		
	}
}