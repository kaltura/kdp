package
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.baseEntry.BaseEntryList;
	import com.kaltura.commands.playlist.PlaylistExecute;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.ExternalInterfaceProxy;
	import com.kaltura.kdpfl.model.FuncsProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.vo.ExternalInterfaceVO;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.RelatedEntriesMediator;
	import com.kaltura.kdpfl.plugin.component.RelatedEntriesNotificationType;
	import com.kaltura.kdpfl.plugin.component.RelatedEntriesSourceType;
	import com.kaltura.kdpfl.plugin.component.RelatedEntryVO;
	import com.kaltura.kdpfl.plugin.component.RelatedItemActionType;
	import com.kaltura.kdpfl.util.Functor;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.types.KalturaStatsFeatureType;
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.vo.KalturaBaseEntryFilter;
	import com.kaltura.vo.KalturaBaseEntryListResponse;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class relatedEntriesPluginCode extends UIComponent implements IPlugin
	{
		/**
		 * current player's entry 
		 */		
		public var entryId:String;
		/**
		 * source according to RelatedEntriesSourceType 
		 */		
		public var sourceType:String;
		
		//////////////////////////////////////////
		//TODO: the following 3 properties can be replaced with one, but due to appstudio limitaions
		//we will seperate them
		//////////////////////////////////////////
		/**
		 * data for the related entries source.to be used when sourceType is "entryIds" 
		 */		
		public var entryIdsSourceData:String;
		/**
		 * data for the related entries source.to be used when sourceType is "referenceIds" 
		 */		
		public var referenceIdsSourceData:String;
		/**
		 * data for the related entries source.to be used when sourceType is "globalPlaylist" 
		 */
		public var playlistSourceData:String;
		
		[Bindable]
		/**
		 * holds the relatedEntries array
		 * 
		 */		
		public var dataProvider:DataProvider;
		/**
		 * default playlist ID. will be used when sourceType=automatic 
		 */		
		public var automaticPlaylistId:String;
		/**
		 * should start playing related entry after "autoPlayDelay" seconds 
		 */		
		public var autoPlay:Boolean;
		/**
		 * time to wait befre related entry is selected 
		 */		
		public var autoPlayDelay:int = 3;
		/**
		 * action according to RelateditemActionType 
		 */		
		public var itemClickAction:String = RelatedItemActionType.LOAD_IN_PLAYER;
		/**
		 * URL address to navigate to, in case itemClickAction=GO_TO_URL 
		 */		
		public var urlAddress:String;
		/**
		 *JS function to call in case itemClickAction=CALL_JS_FUNC 
		 */		
		public var jsFunc:String;
		/**
		 * parameters of JS Func 
		 */		
		public var jsParams:Object;
		[Bindable]
		/**
		 * Will be used for the countdown display in the next selected related item renderer  
		 */		
		public var timeRemaining:int = 0; 
		[Bindable]
		/**
		 * the current selected relatedEntryVo object 
		 */		
		public var selectedRelatedVo:RelatedEntryVO;
		/**
		 * if true, the next up item will be selected randomally 
		 */		
		public var selectRandomNext:Boolean;
		
		
		//////////////////////////////////////
		// private fields
		/////////////////////////////////////
		/**
		 * timer for the timeRemaining countdown 
		 */		
		private var _timeRemainingTimer:Timer;
		private var _isTimerRunning:Boolean;		
		
		private var _mediator:RelatedEntriesMediator;
		private var _facade:IFacade;
		
		public function relatedEntriesPluginCode()
		{
		}
		

		public function initializePlugin(facade:IFacade):void
		{
			_facade = facade;
			_mediator = new RelatedEntriesMediator(this);
			_facade.registerMediator(_mediator);
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
		
		/**
		 * will send an API call to retrieve entries according to sourceType and sourceData 
		 * 
		 */		
		public function loadEntries():void
		{			
			var kc:KalturaClient = (_facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).vo.kalturaClient;
			var kalturaCall:KalturaCall;
			var sourceData:String;
			switch (sourceType)
			{
				case RelatedEntriesSourceType.AUTOMATIC:
				case RelatedEntriesSourceType.GLOBAL_PLAYLIST:
					if (sourceType == RelatedEntriesSourceType.AUTOMATIC)
						sourceData = automaticPlaylistId;
					else
						sourceData = playlistSourceData;
					kalturaCall = new PlaylistExecute(sourceData);
					break;
				case RelatedEntriesSourceType.ENTRY_IDS:
				case RelatedEntriesSourceType.REFERENCE_IDS:
					if (sourceType == RelatedEntriesSourceType.ENTRY_IDS)
						sourceData = entryIdsSourceData;
					else
						sourceData = referenceIdsSourceData;
					var filter:KalturaBaseEntryFilter = new KalturaBaseEntryFilter();
					if (sourceType == RelatedEntriesSourceType.ENTRY_IDS)
					{
						filter.idIn = sourceData;
					}
					else //reference IDs list
					{
						filter.referenceIdIn = sourceData;
					}
					kalturaCall = new BaseEntryList(filter);
					break;
			}
			
			if (!sourceData || !kalturaCall)
			{
				trace ("cannot retrieve related entries, missing information");
			}
			else
			{
				kalturaCall.addEventListener(KalturaEvent.COMPLETE, onEntriesComplete);
				kalturaCall.addEventListener(KalturaEvent.FAILED, onEntriesFailed);
				kc.post(kalturaCall);
			}	
		}
		
		/**
		 * Handler for the entries API request.
		 * Will populate the data provider 
		 * @param event
		 * 
		 */		
		private function onEntriesComplete(event:KalturaEvent):void 
		{
			var resultArray:Array;
			var dpArray:Array = new Array();
			if (sourceType == RelatedEntriesSourceType.AUTOMATIC || sourceType == RelatedEntriesSourceType.GLOBAL_PLAYLIST)
			{
				resultArray = event.data as Array;
			}
			else
			{
				resultArray = (event.data as KalturaBaseEntryListResponse).objects;
			}
			if (resultArray)
			{
				for each (var entry:KalturaBaseEntry in resultArray)
				{
					if (entry.id != entryId) //current entry shouldn't be part of related entries
					{
						var relatedEntry:RelatedEntryVO = new RelatedEntryVO(entry);
						dpArray.push(relatedEntry);
					}
				}
				
				if (!dpArray.length)
				{
					selectedRelatedVo = null;
				}
				else
				{
					if (selectRandomNext)
					{
						var randomIndex:int = Math.round(Math.random() * dpArray.length);
						//set the next up in the first place in the array
						if (randomIndex != 0)
						{
							var selected:RelatedEntryVO = dpArray.splice(randomIndex,1)[0];
							dpArray.splice(0, 0, selected);						
						}
					}
					selectedRelatedVo = dpArray[0] as RelatedEntryVO;
					selectedRelatedVo.isUpNext = true;
				}
				
			}
			dataProvider = new DataProvider(dpArray);
			
			_facade.sendNotification(RelatedEntriesNotificationType.RELATED_ENTRIES_LOADED);
		}
		
		/**
		 * Entries API request failed 
		 * @param event
		 * 
		 */		
		private function onEntriesFailed(event:KalturaEvent):void 
		{
			trace ("failed to retrieve related entries");
			//fallback to automatic playlist
			if (sourceType!=RelatedEntriesSourceType.AUTOMATIC && automaticPlaylistId)
			{
				trace ("fallback to automtaic playlist:", automaticPlaylistId);
				sourceType = RelatedEntriesSourceType.AUTOMATIC;
				loadEntries();
			}
		}
		
		
		public function setUpNext(index:int):void
		{
			if (dataProvider && index >= 0 && index < dataProvider.length)
			{
				//unselect old selected
				if (selectedRelatedVo)
					selectedRelatedVo.isUpNext = false;
				
				selectedRelatedVo = dataProvider.getItemAt(index) as RelatedEntryVO;
				selectedRelatedVo.isUpNext = true;
			}
			else
			{
				trace ("could not set up next, invalid value:", index);
			}
		}
		
		/**
		 * start action on selectedRelatedVo according to itemClickAction value 
		 * 
		 */		
		public function startAction():void 
		{
			switch (itemClickAction)
			{
				case RelatedItemActionType.LOAD_IN_PLAYER:
					(_facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.singleAutoPlay = true;
					if (!selectedRelatedVo)
					{
						trace ("cannot load related entry, no selected related entry");
					}
					else
					{
						_facade.sendNotification(NotificationType.CHANGE_MEDIA, {entryId: selectedRelatedVo.entry.id, originFeature: KalturaStatsFeatureType.RELATED});
					}
					break;
				case RelatedItemActionType.CALL_JS_FUNC:
					var externalProxy:ExternalInterfaceProxy = _facade.retrieveProxy(ExternalInterfaceProxy.NAME) as ExternalInterfaceProxy;
					if (externalProxy.vo.enabled)
					{
						externalProxy.call(jsFunc, jsParams);
					}
					break;
				case RelatedItemActionType.GO_TO_URL:
					var funcProxy:FuncsProxy = Functor.globalsFunctionsObject as FuncsProxy;
					funcProxy.navigate(urlAddress, "_blank");
					break;
			}
		}
		
		/**
		 * starts remainingTime timer
		 * 
		 */		
		public function startTimer():void
		{
			if (!_timeRemainingTimer)
			{
				_timeRemainingTimer = new Timer(1000, autoPlayDelay);
				_timeRemainingTimer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
				_timeRemainingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete, false, 0, true);
			}
			else
			{
				_timeRemainingTimer.repeatCount = autoPlayDelay;
				_timeRemainingTimer.reset();
			}
			
			timeRemaining = autoPlayDelay;
			_timeRemainingTimer.start();
			isTimerRunning = true;
		}
		
		/**
		 * stops remainingTime timer 
		 * 
		 */		
		public function stopTimer():void
		{
			if (_timeRemainingTimer && _timeRemainingTimer.running)
			{
				_timeRemainingTimer.stop();
				isTimerRunning = false;
			}
		}
		
		/**
		 * resumes remainingTime timer 
		 * 
		 */		
		public function resumeTimer():void
		{
			if (_timeRemainingTimer && !_timeRemainingTimer.running)
			{
				_timeRemainingTimer.start();
				isTimerRunning = true;
			}
		}
		
		private function onTimer(event:TimerEvent):void
		{
			timeRemaining = _timeRemainingTimer.repeatCount - _timeRemainingTimer.currentCount;
		}
		
		private function onTimerComplete(event:TimerEvent):void
		{
			timeRemaining = 0;
			isTimerRunning = false;
			startAction();
		}
		
		[Bindable]
		/**
		 * indicated if timer is currently running 
		 * @return 
		 * 
		 */		
		public function get isTimerRunning():Boolean
		{
			return _isTimerRunning;
		}
		
		public function set isTimerRunning(value:Boolean):void
		{
			_isTimerRunning = value;
		}
	}
	
}