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
			
			// for urls dont fetch entry from kaltura;
			if (_flashvars.sourceType == SourceType.URL || _flashvars.sourceType == SourceType.F4M)
			{
				if (_flashvars.entryId || _flashvars.entryId == "" || _flashvars.entryId== "-1" )
				{
					_mediaProxy.vo.isMediaDisabled = false;
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
				var entryId : String = _mediaProxy.vo.entry.id;	
				var mr : MultiRequest = new MultiRequest();
				
				if( entryId && entryId != "-1" )
				{
					var getEntry : BaseEntryGet = new BaseEntryGet( entryId );
					mr.addAction( getEntry );
					
					
					var getFlavors:FlavorAssetGetWebPlayableByEntryId = new FlavorAssetGetWebPlayableByEntryId(_mediaProxy.vo.entry.id);
					mr.addAction(getFlavors); 
					
					var keedp : KalturaEntryContextDataParams = new KalturaEntryContextDataParams();
					keedp.referrer = _flashvars.referrer;
					var getExtraData : BaseEntryGetContextData = new BaseEntryGetContextData( _mediaProxy.vo.entry.id , keedp );
					mr.addAction(getExtraData); 
					
					if (_flashvars.requiredMetadataFields)
					{
						var metadataAction : KalturaCall;
						if (_flashvars.metadataProfileId)
						{
							metadataAction = new MetadataGet( _flashvars.metadataProfileId );
						}
						else
						{
							var metadataFilter : KalturaMetadataFilter = new KalturaMetadataFilter();
							
							metadataFilter.metadataObjectTypeEqual = KalturaMetadataObjectType.ENTRY;
							
							metadataFilter.orderBy = KalturaMetadataOrderBy.CREATED_AT_ASC;
							
							metadataFilter.objectIdEqual = _mediaProxy.vo.entry.id;
							
							var metadataPager : KalturaFilterPager = new KalturaFilterPager();
							
							metadataPager.pageSize = 1;
							
							metadataAction = new MetadataList(metadataFilter,metadataPager);
						}
						
						mr.addAction(metadataAction);
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
			_mediaProxy.vo.isMediaDisabled = false;
			/////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////
			//TODO: merge the code here and in LoadConfigCommand (DUPLICATION!!)
			/////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////
			/////////////////////////////////////////////////////////////////
			if(arr[i] is KalturaError)
			{
				++i;
				trace("Error in Get Entry");
				trace(arr[i]);
				//sendNotification( NotificationType.ALERT , {message: MessageStrings.getString('SERVICE_GET_ENTRY_ERROR'), title: MessageStrings.getString('SERVICE_ERROR')} );
			}
			else
			{
				_mediaProxy.vo.entry = arr[i++];
				if (_mediaProxy.vo.entry is KalturaLiveStreamEntry){
					_mediaProxy.vo.deliveryType = StreamerType.LIVE;
				}
				else
				{
					_mediaProxy.vo.deliveryType = _flashvars.streamerType;
				}
			}
			
			if(arr[i] is KalturaError )
			{
				trace("Warning : Empty Flavors");
				_mediaProxy.vo.kalturaMediaFlavorArray = null;
				++i;				
				//if this is live entry we will create the flavors using 
				if( _mediaProxy.vo.entry is KalturaLiveStreamEntry )
				{
					var flavorAssetArray : Array = new Array(); 
					for(var j:int=0; j<_mediaProxy.vo.entry.bitrates.length; j++)
					{
						var flavorAsset : KalturaFlavorAsset = new KalturaFlavorAsset();
						flavorAsset.bitrate = _mediaProxy.vo.entry.bitrates[j].bitrate;
						flavorAsset.height = _mediaProxy.vo.entry.bitrates[j].height;
						flavorAsset.width = _mediaProxy.vo.entry.bitrates[j].width;
						flavorAsset.entryId = _mediaProxy.vo.entry.id;
						flavorAsset.isWeb = true;
						flavorAsset.id = j.toString();
						flavorAsset.partnerId = _mediaProxy.vo.entry.partnerId; 
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
				}
			}
			else
			{
				_mediaProxy.vo.kalturaMediaFlavorArray = arr[i++];
			} 
			
			if(arr[i] is KalturaError )
			{
				//TODO: Trace, Report, and notify the user
				trace("Warning : Empty Extra Params");
				++i;
				//sendNotification( NotificationType.ALERT , {message: MessageStrings.getString('SERVICE_GET_EXTRA_ERROR'), title: MessageStrings.getString('SERVICE_GET_EXTRA_ERROR_TITLE')} );
			}
			else
			{
				_mediaProxy.vo.entryExtraData = arr[i++];
			} 
			
			if (_flashvars.requiredMetadataFields)
			{
				if(arr[i] is KalturaError)
				{
					//TODO: Trace, Report, and notify the user
					trace("Warning : Empty Meta data");
					++i;
					//sendNotification( NotificationType.ALERT , {message: MessageStrings.getString('SERVICE_GET_EXTRA_ERROR'), title: MessageStrings.getString('SERVICE_GET_EXTRA_ERROR_TITLE')} );
				}
				else
				{
					var mediaProxy : MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
					
					if (mediaProxy.vo.entryMetadata != arr[i] )
					{
						
						mediaProxy.vo.entryMetadata = new Object();
						
						var listResponse : KalturaMetadataListResponse = arr[i] as KalturaMetadataListResponse;
						if (listResponse && listResponse.objects[listResponse.objects.length - 1])
						{
							var metadataXml : XMLList = XML(listResponse.objects[listResponse.objects.length - 1]["xml"]).children();
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
			}
			
			var entry : KalturaBaseEntry  = _mediaProxy.vo.entry;
			
			if(entry && (entry.id != "-1") && (entry.id != null) )
			{
				//switch the entry status to print the right error to the screen
				switch( entry.status )
				{
					case KalturaEntryStatus.BLOCKED: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_REJECTED'), title: MessageStrings.getString('ENTRY_REJECTED_TITLE')}); _mediaProxy.vo.isMediaDisabled = true;
						break;	
					case KalturaEntryStatus.DELETED: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_DELETED'), title: MessageStrings.getString('ENTRY_DELETED_TITLE')}); _mediaProxy.vo.isMediaDisabled = true; 
						break;	
					case KalturaEntryStatus.ERROR_CONVERTING: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ERROR_PROCESSING_MEDIA'), title: MessageStrings.getString('ERROR_PROCESSING_MEDIA_TITLE')}); _mediaProxy.vo.isMediaDisabled = true; 
						break;	
					case KalturaEntryStatus.ERROR_IMPORTING: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ERROR_PROCESSING_MEDIA'), title: MessageStrings.getString('ERROR_PROCESSING_MEDIA_TITLE')}); _mediaProxy.vo.isMediaDisabled = true; 
						break;	
					case KalturaEntryStatus.IMPORT: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_CONVERTING'), title: MessageStrings.getString('ENTRY_CONVERTING_TITLE')}); _mediaProxy.vo.isMediaDisabled = true; 
						break;	
					case KalturaEntryStatus.PRECONVERT: 
						sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_CONVERTING'), title: MessageStrings.getString('ENTRY_CONVERTING_TITLE')}); _mediaProxy.vo.isMediaDisabled = true; 
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
					//check if a moderation status alert should be rised
					if( !_mediaProxy.vo.entryExtraData.isAdmin)
					{
						
						switch( entry.moderationStatus )
						{
							case KalturaEntryModerationStatus.REJECTED:
								sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_REJECTED'), title: MessageStrings.getString('ENTRY_REJECTED_TITLE')});
								_mediaProxy.vo.isMediaDisabled = true;
								break;
							case KalturaEntryModerationStatus.PENDING_MODERATION:
								sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_MODERATE'), title: MessageStrings.getString('ENTRY_MODERATE_TITLE')});
								_mediaProxy.vo.isMediaDisabled = true;
								break;
						}
					}
					//If the requesting user is not the admin, check for entry restrictions
					if(!_mediaProxy.vo.entryExtraData.isAdmin)
					{
						//The player is running in a restricted country.
						if(_mediaProxy.vo.entryExtraData.isCountryRestricted){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNAUTHORIZED_COUNTRY'), title: MessageStrings.getString('UNAUTHORIZED_COUNTRY_TITLE')});
							sendNotification(NotificationType.CANCEL_ALERTS);//
							_mediaProxy.vo.isMediaDisabled = true;
						}
						//The entry is out of scheduling.
						if(!_mediaProxy.vo.entryExtraData.isScheduledNow){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('OUT_OF_SCHEDULING'), title: MessageStrings.getString('OUT_OF_SCHEDULING_TITLE')});	
							sendNotification(NotificationType.CANCEL_ALERTS);
							_mediaProxy.vo.isMediaDisabled = true;
						}
						//the player is running on a restricted site.
						if(_mediaProxy.vo.entryExtraData.isSiteRestricted){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNAUTHORIZED_DOMAIN'), title: MessageStrings.getString('UNAUTHORIZED_DOMAIN_TITLE')});
							sendNotification(NotificationType.CANCEL_ALERTS);
							_mediaProxy.vo.isMediaDisabled = true;
						}
						// The player is running from a restricted IP address.
						if(_mediaProxy.vo.entryExtraData.isIpAddressRestricted) {
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNAUTHORIZED_IP_ADDRESS'), title: MessageStrings.getString('UNAUTHORIZED_IP_ADDRESS_TITLE')});
							sendNotification(NotificationType.CANCEL_ALERTS);
							_mediaProxy.vo.isMediaDisabled = true;
						}
						// The entry is restricted and the KS is not valid.
						if(_mediaProxy.vo.entryExtraData.isSessionRestricted && _mediaProxy.vo.entryExtraData.previewLength <= 0){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('NO_KS'), title: MessageStrings.getString('NO_KS_TITLE')});
							_mediaProxy.vo.isMediaDisabled = true;
						}
					}
					
				}
				sendNotification( NotificationType.ENTRY_READY, entry  );
				
			}
			else
			{
				_mediaProxy.vo.isMediaDisabled = true;
			}

			commandComplete();
		}
		
		override protected function commandComplete():void
		{
			if (! _mediaProxy.vo.isMediaDisabled)
			{
				sendNotification(NotificationType.ENABLE_GUI, {guiEnabled : true , enableType : EnableType.CONTROLS});
				if (_mediaProxy.vo.entry is KalturaLiveStreamEntry || _flashvars.streamerType == StreamerType.LIVE)
				{
					_mediaProxy.prepareMediaElement();
					sendNotification(NotificationType.ENABLE_GUI, {guiEnabled : false , enableType : EnableType.CONTROLS});
					sendNotification(NotificationType.LIVE_ENTRY, _mediaProxy.vo.resource);
				}
			}
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
			trace(data.info);
		}	
	}
}