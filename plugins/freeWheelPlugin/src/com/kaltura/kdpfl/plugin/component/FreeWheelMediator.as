package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	
	import org.osmf.events.MetadataEvent;
	import org.osmf.metadata.CuePoint;

	public class FreeWheelMediator extends SequenceMultiMediator implements IFwPlayerModule, IFwContext
	{	
		public static const NAME:String = "freeWheelMediator";
		
		private var _pluginLoadedFlag : Boolean = false;
		private var _waitingToPlayFlag : Boolean = false;
		private var _hasStarted:Boolean = false;
		private var _playheadTime:Number;
		
		public function FreeWheelMediator(viewComponent:Object=null)
		{
			super(viewComponent);
		}
		
		private function loadPlugin():void
		{				
			var pluginResource:IMediaResource = new URLResource(new URL( view.fwPluginLocation ));		
			this.loadPluginFromResource(pluginResource);					
		}
			
		private function loadPluginFromResource(pluginResource:IMediaResource):void
		{
			var mediaVo:Object = facade.retrieveProxy("mediaProxy").vo;
			mediaVo.osmfPluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOADED, plugin_loadedHandler);
			mediaVo.osmfPluginManager.addEventListener(PluginLoadEvent.PLUGIN_LOAD_FAILED, plugin_loadFailHandler);
			mediaVo.osmfPluginManager.loadPlugin(pluginResource);
		}
		
		private function plugin_loadedHandler(e:PluginLoadEvent):void
		{
			_pluginLoadedFlag = true;
			var mediaVo:Object = facade.retrieveProxy("mediaProxy").vo;
			view.fwPlugin = mediaVo.mediaFactory.getMediaInfoById(FW_PLUGIN_ID).mediaElementCreationFunction();
			view.fwPlugin.setContext(this);
				
			//if we are still holding on this plugin in sequnce, continue now...
			if(_waitingToPlayFlag)
				facade.sendNotification("sequenceItemPlayEnd");
		}
		
		private function plugin_loadFailHandler(e:PluginLoadEvent):void
		{
			trace("plugin_loadFailHandler()");
			_pluginLoadedFlag = true; //we set it to true even if it fail to bypass it and continue
			if(_waitingToPlayFlag)
				facade.sendNotification("sequenceItemPlayEnd");
		}
		
		public function loadAndProceed() : void
		{
			_waitingToPlayFlag = true;
			if(_pluginLoadedFlag)
			{
				//if the plugin loaded we will proceed 
				facade.sendNotification("sequenceItemPlayEnd");
			}
		}
		
		override public function listNotificationInterests():Array {
			var notify:Array = 
			[
			 preSequenceNotificationStartName,
			 NotificationType.MEDIA_READY,
			 NotificationType.CHANGE_MEDIA,
			 NotificationType.PLAYER_UPDATE_PLAYHEAD,
			 NotificationType.DURATION_CHANGE,
			 NotificationType.PLAYER_PLAY_END			
			 NotificationType.VOLUME_CHANGED,		
			 NotificationType.PLAYER_PLAYED
			];
				
			return notify;
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				
				case preSequenceNotificationStartName:
					// On pre sequence we will load the freeWheel OSMF plugin and then 
					// we will release the player to continue playing
					
				break;
				case NotificationType.CHANGE_MEDIA:
					this._hasStarted = false;
				break;
				case NotificationType.MEDIA_READY:
					// Reset the has started flag

					var mediaVo:Object = facade.retrieveProxy("mediaProxy").vo;
					
					//listen to FACET_ADD on the current media element
					mediaVo.media.metadata.addEventListener(MetadataEvent.FACET_ADD, videoElement_facetAddHandler);
					
					//TODO: see when to remove the listener for performance optimization
				break;
				
				case NotificationType.PLAYER_UPDATE_PLAYHEAD:
					_playheadTime = data as Number;
				break;
				
				case NotificationType.PLAYER_PLAY_END:
					callFwPluginPostrollCheck();
				break;
				
				case NotificationType.PLAYER_PLAYED:
				case NotificationType.DURATION_CHANGE:
					if(!this._hasStarted)
					{
						this.setVideoToBegin();
					}
				break;
				
			}
		}
		
		private function setVideoToBegin():void
		{
			sendNotification( NotificationType.DO_PAUSE );
			var player : Object = facade.retrieveMediator( "kMediaPlayerMediator" )["player"];
			if(player.duration > 0)
			{	
				this._hasStarted = true;
				
				this.setEnabled(true);
				
				this.addCuePoint({name: "osmfPreroll", type: FwCuePoint.TYPE_EVENT, time: 0});
				this.addCuePoint({name: "osmfPostroll", type: FwCuePoint.TYPE_EVENT, time: player.duration});
				//TODO: extract the 15 sec to uiconf param
				this.addCuePoint({name: "osmfMidroll", type: FwCuePoint.TYPE_EVENT, time: 15});
				
				this.callFwPluginPrerollCheck();
			}
		}
		
		private function callFwPluginPrerollCheck():void
		{
			if(view.fwPlugin != null)
				view.fwPlugin.prerollCheck();		
			else
				this.prerollCheckComplete();
		}
		
		private function callFwPluginPostrollCheck():void
		{
			if(view.fwPlugin != null)
				view.fwPlugin.postrollCheck();
			else
				this.postrollCheckComplete();
		}
					
		private function videoElement_facetAddHandler(e:MetadataEvent):void
		{
			var temporalFacet:TemporalFacet = e.facet as TemporalFacet;
				
			if (temporalFacet)
			{	
				temporalFacet.addEventListener(TemporalFacetEvent.POSITION_REACHED, temporalFacet_positionReachedHandler);
			}
		}
		
		private function temporalFacet_positionReachedHandler(e:TemporalFacetEvent):void
		{
			var cuePoint:CuePoint = e.value as CuePoint;
			if(cuePoint != null)
			{
				var fwCuePoint:FwCuePoint = FwCuePoint.createFwCuePoint(cuePoint);
				this.dispatchEvent(new FwCuePointEvent(fwCuePoint));
			}
		}
		
		public function get view() : FreeWheelComponent
		{
			return viewComponent as FreeWheelComponent;
		}
				
		//IFwPlayerModule
		////////////////////////////////////////////
		public function pause(pauseState:Boolean):void
		{	
			if(pauseState)
				sendNotification( NotificationType.DO_PAUSE );
			else				
				sendNotification( NotificationType.DO_PLAY );		
		}
		
		public function setEnabled(enable:Boolean):void
		{
			facade.sendNotification(NotificationType.ENABLE_GUI, {guiEnabled: enable, enableType: "full"});
		}

		public function getDisplay():Sprite
		{
			return viewComponent;
		}
		
		public function getDisplayRect():Rectangle
		{
			return new Rectangle(0, 0, this.view.width, this.view.height);
		}

		public function getAutoPlay():Boolean
		{
			return facade.retrieveProxy("configProxy").flashvars.autoPlay;
		}
		
		public function getVolume():Number
		{
			var player : Object = facade.retrieveMediator( "kMediaPlayerMediator" )["player"];
			return player.volume;
		}
		
		public function getVideoId():String
		{
			var mediaVo:Object = facade.retrieveProxy("mediaProxy").vo;
			return mediaVo.entry.id;
		}
		
		public function getVideoDuration():Number
		{
			var player : Object = facade.retrieveMediator( "kMediaPlayerMediator" )["player"];
			return player.duration;
		}
		
		public function getVideoPlayheadTime():Number
		{
			return _playheadTime;
		}
		
		public function getVideoUrl():String
		{
			var mediaVo:Object = facade.retrieveProxy("mediaProxy").vo;
			return mediaVo.entry.dataUrl;
		}

		public function getCuePoints(cuePointType:String):Array
		{
			var player : Object = facade.retrieveMediator( "kMediaPlayerMediator" )["player"];
			var cuePoints:Array = new Array();
			if(player.element != null)
			{
				var facet:TemporalFacet = player.element.metadata.getFacet(MetadataNamespaces.TEMPORAL_METADATA_EMBEDDED) as TemporalFacet;
				
				if(facet != null)
				{
					for(var i:int = 0; i < facet.numValues; i++)
					{
						var cuePoint:CuePoint = facet.getValueAt(i) as CuePoint;
						
						if(cuePoint != null && cuePoint.type == CuePointType.fromString(cuePointType))
						{
							cuePoints.push(FwCuePoint.createFwCuePoint(cuePoint));
						}
					}
				}
			}
			
			return cuePoints;
		}
		
		public function clearCuePoints(cuePointType:String):void
		{
			var player : Object = facade.retrieveMediator( "kMediaPlayerMediator" )["player"];
			if(player.element != null)
			{
				var facet:TemporalFacet = player.element.metadata.getFacet(MetadataNamespaces.TEMPORAL_METADATA_EMBEDDED) as TemporalFacet;
				if(facet != null)
				{
					for(var i:int = 0; i < facet.numValues; i++)
					{
						var cuePoint:CuePoint = facet.getValueAt(i) as CuePoint;
						
						if(cuePoint != null && cuePoint.type == CuePointType.fromString(cuePointType))
						{
							cuePoint = null;
						}
					}
				}
			}
		}
		
		public function addCuePoint(cuePoint:Object):void
		{
			var player : Object = facade.retrieveMediator( "kMediaPlayerMediator" )["player"];
			if(player.element != null)
			{
				var facet:TemporalFacet = this._player.element.metadata.getFacet(MetadataNamespaces.TEMPORAL_METADATA_EMBEDDED) as TemporalFacet;
				
				if(facet == null)
				{
					facet = new TemporalFacet(MetadataNamespaces.TEMPORAL_METADATA_EMBEDDED, this._player.element);
					this._player.element.metadata.addFacet(facet);
				}
			
				if(facet != null)
				{
					facet.addValue(new CuePoint(CuePointType.fromString(cuePoint.type), cuePoint.time, cuePoint.name, cuePoint.parameters));
				}
			}
		}
		
		//////////////////////////////////////////////
		
		//IFwContext
		////////////////////////////////////////////
		function getPlayerModule():IFwPlayerModule
		{
			return this;
		}

		function setPluginReady():void
		{
			if(_waitingToPlayFlag)
				facade.sendNotification("sequenceItemPlayEnd");
		}

		function prerollCheckComplete():void
		{
			//release the pause
			sendNotification(NotificationType.DO_PLAY);
		}

		function postrollCheckComplete():void
		{

		}
		//////////////////////////////////////////////
		
	}
}