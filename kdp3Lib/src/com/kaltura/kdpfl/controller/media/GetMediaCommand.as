package com.kaltura.kdpfl.controller.media
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.MultiRequest;
	import com.kaltura.commands.baseEntry.BaseEntryGet;
	import com.kaltura.commands.baseEntry.BaseEntryGetContextData;
	import com.kaltura.commands.flavorAsset.FlavorAssetGetWebPlayableByEntryId;
	import com.kaltura.errors.KalturaError;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.strings.MessageStrings;
	import com.kaltura.kdpfl.model.type.SourceType;
	import com.kaltura.types.KalturaEntryModerationStatus;
	import com.kaltura.types.KalturaEntryStatus;
	import com.kaltura.vo.KalturaBaseEntry;
	import com.kaltura.vo.KalturaEntryContextDataParams;
	import com.kaltura.vo.KalturaLiveStreamEntry;KalturaLiveStreamEntry;
	import com.kaltura.vo.KalturaLiveStreamAdminEntry; KalturaLiveStreamAdminEntry;
	import com.kaltura.vo.KalturaLiveStreamBitrate; KalturaLiveStreamBitrate;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	import com.kaltura.vo.KalturaFlavorAsset;
	import com.kaltura.kdpfl.model.type.StreamerType;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.view.media.KMediaPlayer;
	import com.kaltura.kdpfl.view.media.KMediaPlayerMediator;
	import com.kaltura.kdpfl.model.type.EnableType;
	import flash.events.Event;
	import com.kaltura.vo.KalturaMetadataListResponse;
	import com.kaltura.vo.KalturaMetadataFilter;
	import com.kaltura.types.KalturaMetadataObjectType;
	import com.kaltura.commands.metadata.MetadataList;
	import com.kaltura.net.KalturaCall;
	import com.kaltura.commands.metadata.MetadataGet;
	import com.kaltura.kdpfl.model.PlayerStatusProxy;
	import com.kaltura.kdpfl.model.SequenceProxy;
	import com.kaltura.types.KalturaMetadataOrderBy;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.vo.KalturaCuePointFilter;
	import com.kaltura.commands.cuePoint.CuePointList;
	import com.kaltura.vo.KalturaCuePointListResponse;
	import com.kaltura.vo.KalturaCuePoint;
	import com.kaltura.vo.KalturaAdCuePoint;KalturaAdCuePoint;
	import com.kaltura.vo.KalturaCodeCuePoint;KalturaCodeCuePoint;
	import com.kaltura.vo.KalturaCaptionAsset;
	import com.kaltura.types.KalturaAdProtocolType;
	import com.kaltura.types.KalturaAdType;
	import com.kaltura.vo.KalturaAnnotation; KalturaAnnotation;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import com.kaltura.vo.BaseFlexVo;
	import com.kaltura.vo.KalturaMetadata;
	import org.osmf.net.StreamType;
	import com.kaltura.kdpfl.model.vo.StorageProfileVO;
	import com.kaltura.kdpfl.view.controls.KTrace;
	import com.kaltura.commands.baseEntry.BaseEntryList;
	import com.kaltura.vo.KalturaBaseEntryFilter;
	import com.kaltura.vo.KalturaEntryContextDataResult;
	import com.kaltura.commands.baseEntry.BaseEntryListByReferenceId;
	import com.kaltura.commands.metadataProfile.MetadataProfileGet;

 


	/**
	 * This is the class for the command used to retrieve the entry object and its related data from the Kaltura CMS. 
	 * @author Hila
	 * 
	 */	
	public class GetMediaCommand extends AsyncCommand
	{
		
		private var _mediaProxy : MediaProxy;
		private var _sequenceProxy : SequenceProxy;
		private var _flashvars : Object;
		
		/**
		 * a flag to distinguish between getting an entry by 
		 * entry id and getting an entry by reference id
		 */
		private var _isRefid:Boolean;
		
		/**
		 * The command's execution involves using the Kaltura Client to construct a multi-tiered call to the
		 * Kaltura CMS (a MultiRequest) and populating it with single-tier calls to get the Entry object, the Flavors array,
		 * the Entry Context Data and the Custom Metadata.
		 * @param notification - the notifcation which triggered the command.
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			_mediaProxy = (facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy);
			_sequenceProxy = (facade.retrieveProxy( SequenceProxy.NAME ) as SequenceProxy);
			var configProxy : ConfigProxy = facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy;
			_flashvars = configProxy.vo.flashvars;
			_mediaProxy.vo.isMediaDisabled = false;
			// for urls dont fetch entry from kaltura;
			if (_flashvars.sourceType == SourceType.URL || _flashvars.sourceType == SourceType.F4M)
			{
				if (!_mediaProxy.vo.entry.id || _mediaProxy.vo.entry.id == "" || _mediaProxy.vo.entry.id== "-1" )
				{
					_mediaProxy.vo.isMediaDisabled = true;
				}
				
				
				commandComplete();
			}
			else if( _mediaProxy.vo.entryLoadedBeforeChangeMedia) 
			{
				_mediaProxy.vo.entryLoadedBeforeChangeMedia = false;
				_mediaProxy.vo.selectedFlavorId = _flashvars.flavorId;
				
				//If this is the first time that the player is running WITHOUT A KDP3WRAPPER, bypass this call, as the entry was retrieved in the LoadConfigCommand stage.
				result({data:[_mediaProxy.vo.entry,_mediaProxy.vo.kalturaMediaFlavorArray,_mediaProxy.vo.entryExtraData, (_flashvars.requiredMetadataFields ? _mediaProxy.vo.entryMetadata : null)]});
			}
			else //else call to the get entry service again
			{
				//To do : make multirequest just fetching a new entryId .
				
				var kc : KalturaClient = ( facade.retrieveProxy( ServicesProxy.NAME ) as ServicesProxy ).kalturaClient;
				var entryId : String = _mediaProxy.vo.entry.id;	// assuming InitMediaChangeProcessCommand put it there
				var refid : String = notification.getBody().referenceId;
				
				if( (entryId && entryId != "-1") || refid )
				{
					var ind:int =  1;
					var mr : MultiRequest = new MultiRequest();
					// get entry by refid / entryid
					if (refid) {
						_isRefid = true;
						var getEntryByRefid:BaseEntryListByReferenceId = new BaseEntryListByReferenceId(refid);
						mr.addAction(getEntryByRefid);
					}
					else {
						_isRefid = false;	
						var getEntry : BaseEntryGet = new BaseEntryGet( entryId );
						mr.addAction( getEntry );
						ind ++;
					}
					
					var getFlavors:FlavorAssetGetWebPlayableByEntryId = new FlavorAssetGetWebPlayableByEntryId(_mediaProxy.vo.entry.id);
					if (_isRefid) {
						mr.addRequestParam(ind + ":entryId","{1:result:objects:0:id}");
					}
					mr.addAction(getFlavors);
					ind ++;
					
					var keedp : KalturaEntryContextDataParams = new KalturaEntryContextDataParams();
					keedp.referrer = _flashvars.referrer;
					
					keedp.streamerType = _flashvars.streamerType;
					
					var getExtraData : BaseEntryGetContextData = new BaseEntryGetContextData( _mediaProxy.vo.entry.id , keedp );
					if (_isRefid) {
						mr.addRequestParam(ind + ":entryId","{1:result:objects:0:id}");
					}
					mr.addAction(getExtraData); 
					ind ++;
					
					if (_flashvars.requiredMetadataFields)
					{
						var metadataAction : KalturaCall;
						
						var metadataFilter : KalturaMetadataFilter = new KalturaMetadataFilter();
						
						metadataFilter.metadataObjectTypeEqual = KalturaMetadataObjectType.ENTRY;
						
						metadataFilter.orderBy = KalturaMetadataOrderBy.CREATED_AT_ASC;
						
						metadataFilter.objectIdEqual = _mediaProxy.vo.entry.id;
						
						if (_flashvars.metadataProfileId)
						{
							metadataFilter.metadataProfileIdEqual = _flashvars.metadataProfileId;
						}
						
						var metadataPager : KalturaFilterPager = new KalturaFilterPager();
						
						metadataPager.pageSize = 1;
						
						metadataAction = new MetadataList(metadataFilter,metadataPager);
						
						if (_isRefid) {
							mr.addRequestParam(ind + ":filter:objectIdEqual","{1:result:objects:0:id}");
						}
						mr.addAction(metadataAction);
						ind ++;
					}
					
					if ( _flashvars.getCuePointsData == "true" && !_mediaProxy.vo.isFlavorSwitching && !_sequenceProxy.vo.isInSequence)
					{
						var cuePointFilter : KalturaCuePointFilter = new KalturaCuePointFilter();
						
						cuePointFilter.entryIdEqual = _mediaProxy.vo.entry.id;
						
						var cuePointList : CuePointList = new CuePointList( cuePointFilter );
						
						if (_isRefid) {
							mr.addRequestParam(ind + ":filter:entryIdEqual","{1:result:objects:0:id}");
						}
						mr.addAction( cuePointList );
						ind ++;
					}
					
					
					mr.addEventListener( KalturaEvent.COMPLETE , result );
					mr.addEventListener( KalturaEvent.FAILED , fault );
					kc.post( mr );
				}
				else
				{
					_mediaProxy.vo.isMediaDisabled = true;
					commandComplete();
				}
			}
			
		}
		/**
		 * The response to the server result. This function reassigns the values returned from the server into the
		 * mediaProxy.vo (value object) so that it is subsequently visible to any Observer-type class (proxy, mediator, command).
		 * @param data - the server response
		 * 
		 */		
		public function result(data:Object):void
		{
			var i : int = 0;
			var arr : Array = data.data as Array;
			
			var entry:KalturaBaseEntry; 
			
			// get entry result:
			// -------------------------
			// check for API error
			if(arr[i] is KalturaError || (arr[i].hasOwnProperty("error")))
			{
				_mediaProxy.vo.isMediaDisabled = true;
				KTrace.getInstance().log("Error in Get Entry");
				sendNotification( NotificationType.ENTRY_FAILED );
				sendNotification( NotificationType.ALERT , {message: MessageStrings.getString('SERVICE_GET_ENTRY_ERROR'), title: MessageStrings.getString('SERVICE_ERROR')} );
			}
			// save the received value
			else
			{
				if (_isRefid) {
					// arr[i] is KalturaBaseEntryListResponse, take the first entry in the result array
					if (arr[i].objects.length) {
						entry = arr[i].objects[0];
					}
					else {
						KTrace.getInstance().log("Error in Get Entry: No Entry with given ReferenceId");
						sendNotification( NotificationType.ENTRY_FAILED );
						sendNotification( NotificationType.ALERT , {message: MessageStrings.getString('SERVICE_GET_ENTRY_ERROR'), title: MessageStrings.getString('SERVICE_ERROR')} );
					}
				}
				else {
					// the call was BaseEntryGet, use the result as is
					entry = arr[i];
				}
				_mediaProxy.vo.entry = entry;
				if (entry is KalturaLiveStreamEntry){
					_mediaProxy.vo.deliveryType = StreamerType.LIVE;
				}
				else
				{
					_mediaProxy.vo.deliveryType = _flashvars.streamerType;
				}
			}
			
			++i;
			// get flavors result:
			// -------------------------
			if(arr[i] is KalturaError || (arr[i].hasOwnProperty("error")))
			{
				KTrace.getInstance().log("Warning : Empty Flavors");
				_mediaProxy.vo.kalturaMediaFlavorArray = null;
								
				//if this is live entry we will create the flavors using 
				if( entry is KalturaLiveStreamEntry )
				{
					var flavorAssetArray : Array = new Array(); 
					for(var j:int=0; j<entry.bitrates.length; j++)
					{
						var flavorAsset : KalturaFlavorAsset = new KalturaFlavorAsset();
						flavorAsset.bitrate = entry.bitrates[j].bitrate;
						flavorAsset.height = entry.bitrates[j].height;
						flavorAsset.width = entry.bitrates[j].width;
						flavorAsset.entryId = entry.id;
						flavorAsset.isWeb = true;
						flavorAsset.id = j.toString();
						flavorAsset.partnerId = entry.partnerId; 
						flavorAssetArray.push(flavorAsset);
					}
					
					if(j>0)
						_mediaProxy.vo.kalturaMediaFlavorArray = flavorAssetArray;
					else
						_mediaProxy.vo.kalturaMediaFlavorArray = null;
				}
				else
				{
					_mediaProxy.vo.kalturaMediaFlavorArray = null;
					//sendNotification(NotificationType.ALERT, {title: MessageStrings.getString("SERVICE_ERROR"), message:MessageStrings.getString("SERVICE_GET_FLAVORS_ERROR")} );
				}
			}
			else
			{
				_mediaProxy.vo.kalturaMediaFlavorArray = arr[i];
			} 
			
			++i;
			// get ContextData result:
			// -------------------------
			if(arr[i] is KalturaError || (arr[i].hasOwnProperty("error")))
			{
				//TODO: Trace, Report, and notify the user
				KTrace.getInstance().log("Warning : Empty Extra Params");
				//sendNotification( NotificationType.ALERT , {message: MessageStrings.getString('SERVICE_GET_EXTRA_ERROR'), title: MessageStrings.getString('SERVICE_ERROR')} );
			}
			else
			{
				_mediaProxy.vo.entryExtraData = arr[i];
				if (_flashvars.streamerType == "auto" && _mediaProxy.vo.entryExtraData.streamerType && _mediaProxy.vo.entryExtraData.streamerType != "")
				{
					if (_mediaProxy.vo.deliveryType!=StreamType.LIVE)
						_mediaProxy.vo.deliveryType = _mediaProxy.vo.entryExtraData.streamerType;
					//_flashvars.streamerType = _mediaProxy.vo.entryExtraData.streamerType;
					if (_mediaProxy.vo.entryExtraData.mediaProtocol && _mediaProxy.vo.entryExtraData.mediaProtocol != "")
					{
						_flashvars.mediaProtocol = _mediaProxy.vo.entryExtraData.mediaProtocol;
					}
				}
				
				//remote storage profiles
				_mediaProxy.vo.availableStorageProfiles = new Array();
				//stab: _mediaProxy.vo.entryExtraData.storageProfilesXML = new XML("<StorageProfiles><StrorageProfile storageProfileId='4'><Name>michal</Name><SystemName>blaaaaaaa</SystemName></StrorageProfile><StrorageProfile storageProfileId='8'><Name>michal2222</Name><SystemName>blaaaaaaa33333</SystemName></StrorageProfile></StorageProfiles>");
				if (_mediaProxy.vo.entryExtraData.storageProfilesXML && _mediaProxy.vo.entryExtraData.storageProfilesXML!='') {
					//translate xml profiles to objects
					var profilesXml:XML = new XML(_mediaProxy.vo.entryExtraData.storageProfilesXML);
					for each (var profile:XML in profilesXml.children()) {
						var profileObj:StorageProfileVO = new StorageProfileVO();
						profileObj.storageProfileId = profile.attribute('storageProfileId');
						for each (var profileProp:XML in profile.children()) 
						{
							if ( profileProp.children().length() )
							{
								profileObj[profileProp.localName()] = profileProp.children()[0].toString();
							}
						}
						_mediaProxy.vo.availableStorageProfiles.push(profileObj);
					}
				}
			} 
			
			++i;
			// get CustomData result:
			// -------------------------
			if (_flashvars.requiredMetadataFields)
			{
				if(arr[i] is KalturaError || (arr[i].hasOwnProperty("error")))
				{
					//TODO: Trace, Report, and notify the user
					KTrace.getInstance().log("Warning : Meta data error");
					//sendNotification( NotificationType.ALERT , {message: MessageStrings.getString('SERVICE_GET_CUSTOM_METADATA_ERROR_MESSAGE'), title: MessageStrings.getString('SERVICE_ERROR')} );
				}
				else
				{
					var mediaProxy : MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
					
					if (mediaProxy.vo.entryMetadata != arr[i] )
					{
						mediaProxy.vo.entryMetadata = new Object();
						var serviceResponse : BaseFlexVo;
						if (arr[i] is KalturaMetadataListResponse)
						{
							var listResponse:KalturaMetadataListResponse = arr[i] as KalturaMetadataListResponse;
							//take the latest profile
							if (listResponse.objects && listResponse.objects.length)
							{
								serviceResponse = listResponse.objects[listResponse.objects.length - 1];
							}
						}
						else //if we requested a specific profile id
						{
							serviceResponse = arr[i] as KalturaMetadata;
						}
						if ( serviceResponse )
						{
							var metadataXml : XMLList = XML(serviceResponse["xml"]).children();
							var metaDataObj : Object = new Object();
							for each (var node : XML in metadataXml)
							{
								if (!metaDataObj.hasOwnProperty(node.name().toString()))
								{
									metaDataObj[node.name().toString()] = node.valueOf().toString();
								}
								else
								{
									if (metaDataObj[node.name().toString()] is Array)
									{
										(metaDataObj[node.name().toString()] as Array).push(node.valueOf().toString());
									}
									else
									{
										metaDataObj[node.name().toString()] =new Array ( metaDataObj[node.name().toString()]);
										(metaDataObj[node.name().toString()] as Array).push(node.valueOf().toString() );
									}
								}
							}
							
							
							mediaProxy.vo.entryMetadata = metaDataObj;
						}
						sendNotification(NotificationType.METADATA_RECEIVED);
					}
				} 
				++i;
			}
			
			// get cuePoints result:
			// -------------------------
			if ( _flashvars.getCuePointsData == "true" && !_mediaProxy.vo.isFlavorSwitching && !_sequenceProxy.vo.isInSequence)
			{
				if(arr[i] is KalturaError 
					|| (arr[i].hasOwnProperty("error")))
				{
					KTrace.getInstance().log("Warning : No cue points");
				}
				else
				{
					var cuePointListResponse : KalturaCuePointListResponse = arr[i] as KalturaCuePointListResponse;
					
					_mediaProxy.vo.entryCuePoints = new Object();
					
					var cuePointsMap : Object = new Object();
					
					var cuePointsArray : Array = cuePointListResponse.objects;
					
					for each (var cuePoint : KalturaCuePoint in cuePointsArray)
					{
						// reset start and end time parameters of the cue point to seconds.
						/*cuePoint.startTime = cuePoint.startTime/1000;
						if (cuePoint.endTime)
						{
							cuePoint.endTime = cuePoint.endTime/1000;
						}*/
						// map cue point according to start time.
						if ( cuePointsMap[cuePoint.startTime] )
						{
							(cuePointsMap[cuePoint.startTime] as Array).push( cuePoint );
						}
						else
						{
							cuePointsMap[cuePoint.startTime] = new Array ();
							(cuePointsMap[cuePoint.startTime] as Array).push( cuePoint );
						}
					}
					_mediaProxy.vo.entryCuePoints = cuePointsMap;
					//Send notification regarding the cue points being received.
					sendNotification( NotificationType.CUE_POINTS_RECEIVED, cuePointsMap );
				}
				++i;
			}
			
			// -----------------
			
			if(entry && (entry.id != "-1") && (entry.id != null) )
			{
				//switch the entry status to print the right error to the screen
				switch( entry.status )
				{
					case KalturaEntryStatus.BLOCKED: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_REJECTED'), title: MessageStrings.getString('ENTRY_REJECTED_TITLE')}); sendEntryCannotBePlayed();
						break;	
					case KalturaEntryStatus.DELETED: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_DELETED'), title: MessageStrings.getString('ENTRY_DELETED_TITLE')}); sendEntryCannotBePlayed(); 
						break;	
					case KalturaEntryStatus.ERROR_CONVERTING: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ERROR_PROCESSING_MEDIA'), title: MessageStrings.getString('ERROR_PROCESSING_MEDIA_TITLE')}); sendEntryCannotBePlayed(); 
						break;	
					case KalturaEntryStatus.ERROR_IMPORTING: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ERROR_PROCESSING_MEDIA'), title: MessageStrings.getString('ERROR_PROCESSING_MEDIA_TITLE')}); sendEntryCannotBePlayed(); 
						break;	
					case KalturaEntryStatus.IMPORT: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_CONVERTING'), title: MessageStrings.getString('ENTRY_CONVERTING_TITLE')}); sendEntryCannotBePlayed(); 
						break;	
					case KalturaEntryStatus.PRECONVERT: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_CONVERTING'), title: MessageStrings.getString('ENTRY_CONVERTING_TITLE')}); sendEntryCannotBePlayed(); 
						break;
					case KalturaEntryStatus.NO_CONTENT:
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('NO_CONTENT'), title: MessageStrings.getString('NO_CONTENT_TITLE')}); sendEntryCannotBePlayed(); 
						break;
					
					case KalturaEntryStatus.READY: 
						break;
					
					default: 
						//sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNKNOWN_STATUS'), title: MessageStrings.getString('UNKNOWN_STATUS_TITLE')}); break;
						break;
				}
				
				//if this entry is not old and has extra data
				if(_mediaProxy.vo.entryExtraData)
				{
					var entryExtraData:KalturaEntryContextDataResult = _mediaProxy.vo.entryExtraData;
					
					// If the requesting user is not the admin:
					if( !entryExtraData.isAdmin)
					{
						//check if a moderation status alert should be raised
						switch( entry.moderationStatus )
						{
							case KalturaEntryModerationStatus.REJECTED:
								sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_REJECTED'), title: MessageStrings.getString('ENTRY_REJECTED_TITLE')});
								sendEntryCannotBePlayed();
								break;
							case KalturaEntryModerationStatus.PENDING_MODERATION:
								sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_MODERATE'), title: MessageStrings.getString('ENTRY_MODERATE_TITLE')});
								sendEntryCannotBePlayed();
								break;
						}
						
						// check for entry restrictions:
						
						//The player is running in a restricted country.
						if(entryExtraData.isCountryRestricted){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNAUTHORIZED_COUNTRY'), title: MessageStrings.getString('UNAUTHORIZED_COUNTRY_TITLE')});
							sendNotification(NotificationType.CANCEL_ALERTS);//
							sendEntryCannotBePlayed();
						}
						//The entry is out of scheduling.
						if(!entryExtraData.isScheduledNow){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('OUT_OF_SCHEDULING'), title: MessageStrings.getString('OUT_OF_SCHEDULING_TITLE')});	
							sendNotification(NotificationType.CANCEL_ALERTS);
							sendEntryCannotBePlayed();
						}
						//the player is running on a restricted site.
						if(entryExtraData.isSiteRestricted){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNAUTHORIZED_DOMAIN'), title: MessageStrings.getString('UNAUTHORIZED_DOMAIN_TITLE')});
							sendNotification(NotificationType.CANCEL_ALERTS);
							sendEntryCannotBePlayed();
						}
						// The player is running from a restricted IP address.
						if(entryExtraData.isIpAddressRestricted) {
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNAUTHORIZED_IP_ADDRESS'), title: MessageStrings.getString('UNAUTHORIZED_IP_ADDRESS_TITLE')});
							sendNotification(NotificationType.CANCEL_ALERTS);
							sendEntryCannotBePlayed();
						}
						// The entry is restricted and the KS is not valid.
						if(entryExtraData.isSessionRestricted && entryExtraData.previewLength <= 0){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('NO_KS'), title: MessageStrings.getString('NO_KS_TITLE')});
							sendEntryCannotBePlayed();
						}
					}
					
				}

				sendNotification( NotificationType.ENTRY_READY, entry );
				
			}
			else
			{
				_mediaProxy.vo.isMediaDisabled = true;
			}

			if (_mediaProxy.vo.isFlavorSwitching)
			{		
				_mediaProxy.vo.isFlavorSwitching = false;
			}
			commandComplete();
		}
		
		private function sendEntryCannotBePlayed():void {
			sendNotification(NotificationType.ENTRY_NOT_AVAILABLE);
			sendNotification(NotificationType.ENABLE_GUI, {guiEnabled: false, enableType : EnableType.CONTROLS});
			_mediaProxy.vo.isMediaDisabled = true;
		}
		
		override protected function commandComplete():void
		{
			
			super.commandComplete();
		}
		
		/**
		 * The client request has failed
		 * @param data
		 * 
		 */		
		public function fault(data:Object):void
		{
			//TODO: Send more information on the Error
			sendNotification(NotificationType.ENTRY_FAILED );

		 if (data && data.error && (data.error is KalturaError)) 
			KTrace.getInstance().log(data.error.errorMsg);
		}
	}
}