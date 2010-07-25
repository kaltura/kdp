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

	public class GetMediaCommand extends AsyncCommand
	{
		
		/**
		 * Using Kaltura Client to call to Get Entry and fill the Kaltura Media Entry with it's data
		 * so the user can see title, thumbnail and more info... this command is used to change media
		 * as well 
		 * @param notification
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			var mediaProxy : MediaProxy = (facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy);
			var configProxy : ConfigProxy = facade.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy;
			var flashvars : Object = configProxy.vo.flashvars;
			
			// for urls dont fetch entry from kaltura;
			if (flashvars.sourceType == SourceType.URL || flashvars.sourceType == SourceType.F4M)
			{
				commandComplete();
			}
			else if( mediaProxy.vo.entryLoadedBeforeChangeMedia) //if this is the first time we load media (not a change media)
			{
				mediaProxy.vo.entryLoadedBeforeChangeMedia = false;
				mediaProxy.vo.selectedFlavorId = flashvars.flavorId;
				//bypass the call at first time (won't enter here in change media)
				result({data:[mediaProxy.vo.entry,mediaProxy.vo.kalturaMediaFlavorArray,mediaProxy.vo.entryExtraData]});
			}
			else //else call to the get entry service again
			{
				//To do : make multirequest just fetching a new entryId .
				
				var kc : KalturaClient = ( facade.retrieveProxy( ServicesProxy.NAME ) as ServicesProxy ).kalturaClient;
				var entryId : String = mediaProxy.vo.entry.id;	
				var mr : MultiRequest = new MultiRequest();
				
				if( entryId && entryId != "-1" )
				{
					var getEntry : BaseEntryGet = new BaseEntryGet( entryId );
					mr.addAction( getEntry );
					
					
					var getFlavors:FlavorAssetGetWebPlayableByEntryId = new FlavorAssetGetWebPlayableByEntryId(mediaProxy.vo.entry.id);
			        mr.addAction(getFlavors); 
			        
			        var keedp : KalturaEntryContextDataParams = new KalturaEntryContextDataParams();
			        keedp.referrer = flashvars.referrer;
			        var getExtraData : BaseEntryGetContextData = new BaseEntryGetContextData( mediaProxy.vo.entry.id , keedp );
			        mr.addAction(getExtraData); 
					
					mr.addEventListener( KalturaEvent.COMPLETE , result );
					mr.addEventListener( KalturaEvent.FAILED , fault );
					kc.post( mr );
				}
				else
				{
					mediaProxy.vo.isMediaDisabled = true;
					commandComplete();
				}
			}
			
		}
		/**
		 * The Client retured from the server with result 
		 * @param data
		 * 
		 */		
		public function result(data:Object):void
		{
			var i : int = 0;
			var arr : Array = data.data as Array;
			
			var mediaProxy : MediaProxy = (facade.retrieveProxy( MediaProxy.NAME ) as MediaProxy);
			mediaProxy.vo.isMediaDisabled = false;
			
			var flashvars : Object = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars;
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
				mediaProxy.vo.entry = arr[i++];
				if (mediaProxy.vo.entry is KalturaLiveStreamEntry){
					mediaProxy.vo.deliveryType = StreamerType.LIVE;
				}
				else
				{
					mediaProxy.vo.deliveryType = flashvars.streamerType;
				}
			}
				
	 		if(arr[i] is KalturaError)
			{
				trace("Warning : Empty Flavors");
				mediaProxy.vo.kalturaMediaFlavorArray = null;
				++i;				
				//if this is live entry we will create the flavors using 
				if( mediaProxy.vo.entry is KalturaLiveStreamEntry )
				{
					var flavorAssetArray : Array = new Array(); 
					for(var j:int=0; j<mediaProxy.vo.entry.bitrates.length; j++)
					{
						var flavorAsset : KalturaFlavorAsset = new KalturaFlavorAsset();
						flavorAsset.bitrate = mediaProxy.vo.entry.bitrates[j].bitrate;
						flavorAsset.height = mediaProxy.vo.entry.bitrates[j].height;
						flavorAsset.width = mediaProxy.vo.entry.bitrates[j].width;
						flavorAsset.entryId = mediaProxy.vo.entry.id;
						flavorAsset.isWeb = true;
						flavorAsset.id = j.toString();
						flavorAsset.partnerId = mediaProxy.vo.entry.partnerId; 
						flavorAssetArray.push(flavorAsset);
					}
					
					if(j>0)
						mediaProxy.vo.kalturaMediaFlavorArray = flavorAssetArray;
					else
						mediaProxy.vo.kalturaMediaFlavorArray = null;
				}
				else
				{
					mediaProxy.vo.kalturaMediaFlavorArray = null;
				}
			}
			else
			{
				mediaProxy.vo.kalturaMediaFlavorArray = arr[i++];
			} 
				
			if(arr[i] is KalturaError)
			{
				//TODO: Trace, Report, and notify the user
				trace("Warning : Empty Extra Params");
				++i;
				//sendNotification( NotificationType.ALERT , {message: MessageStrings.getString('SERVICE_GET_EXTRA_ERROR'), title: MessageStrings.getString('SERVICE_GET_EXTRA_ERROR_TITLE')} );
			}
			else
			{
				mediaProxy.vo.entryExtraData = arr[i++];
			} 
			
			var entry : KalturaBaseEntry  = mediaProxy.vo.entry;
			
			if(entry && (entry.id != "-1") && (entry.id != null) )
			{
				//switch the entry status to print the right error to the screen
				switch( entry.status )
				{
					case KalturaEntryStatus.BLOCKED: sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_REJECTED'), title: MessageStrings.getString('ENTRY_REJECTED_TITLE')}); mediaProxy.vo.isMediaDisabled = true; break;	
					case KalturaEntryStatus.DELETED: sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_DELETED'), title: MessageStrings.getString('ENTRY_DELETED_TITLE')}); mediaProxy.vo.isMediaDisabled = true; break;	
					case KalturaEntryStatus.ERROR_CONVERTING: sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ERROR_PROCESSING_MEDIA'), title: MessageStrings.getString('ERROR_PROCESSING_MEDIA_TITLE')}); mediaProxy.vo.isMediaDisabled = true; break;	
					case KalturaEntryStatus.ERROR_IMPORTING: sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ERROR_PROCESSING_MEDIA'), title: MessageStrings.getString('ERROR_PROCESSING_MEDIA_TITLE')}); mediaProxy.vo.isMediaDisabled = true; break;	
					case KalturaEntryStatus.IMPORT: sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_CONVERTING'), title: MessageStrings.getString('ENTRY_CONVERTING_TITLE')}); mediaProxy.vo.isMediaDisabled = true; break;	
					case KalturaEntryStatus.PRECONVERT: sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_CONVERTING'), title: MessageStrings.getString('ENTRY_CONVERTING_TITLE')}); mediaProxy.vo.isMediaDisabled = true; break;
					
					case KalturaEntryStatus.READY: /* DO NOTHING */ ;break/* sendNotification( NotificationType.ALERT,{message:"this is the a message test" ,title:"my title"}); */ 
					
					default: 
						trace( MessageStrings.getString('UNKNOWN_STATUS') );
						//sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNKNOWN_STATUS'), title: MessageStrings.getString('UNKNOWN_STATUS_TITLE')}); break;
					break;
				}
				
				//if this entry is not old and has extra data
				if(mediaProxy.vo.entryExtraData)
				{
					//check if a moderation status alert should be rised
					if( !mediaProxy.vo.entryExtraData.isAdmin)
					{
						
						switch( entry.moderationStatus )
						{
							case KalturaEntryModerationStatus.REJECTED:
								sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_REJECTED'), title: MessageStrings.getString('ENTRY_REJECTED_TITLE')});
								mediaProxy.vo.isMediaDisabled = true;
							break;
							case KalturaEntryModerationStatus.PENDING_MODERATION:
								sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('ENTRY_MODERATE'), title: MessageStrings.getString('ENTRY_REJECTED_TITLE')});
								mediaProxy.vo.isMediaDisabled = true;
							break;
						}
					}
					
 					if(!mediaProxy.vo.entryExtraData.isAdmin)
					{
						//if you are not an admin we will check if this entry is restricted by country
						if(mediaProxy.vo.entryExtraData.isCountryRestricted){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNAUTHORIZED_COUNTRY'), title: MessageStrings.getString('UNAUTHORIZED_COUNTRY_TITLE')});
						    sendNotification(NotificationType.CANCEL_ALERTS);//
						    mediaProxy.vo.isMediaDisabled = true;
						  }
						//if you are not an admin we will check if this entry is out of scheduling
						if(!mediaProxy.vo.entryExtraData.isScheduledNow){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('OUT_OF_SCHEDULING'), title: MessageStrings.getString('OUT_OF_SCHEDULING_TITLE')});	
					        sendNotification(NotificationType.CANCEL_ALERTS);
					        mediaProxy.vo.isMediaDisabled = true;
					      }
						//if you are not an admin we will check if this site is restricted
						if(mediaProxy.vo.entryExtraData.isSiteRestricted){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('UNAUTHORIZED_DOMAIN'), title: MessageStrings.getString('UNAUTHORIZED_DOMAIN_TITLE')});
						     sendNotification(NotificationType.CANCEL_ALERTS);
						     mediaProxy.vo.isMediaDisabled = true;
						  }
						  
						if(mediaProxy.vo.entryExtraData.isSessionRestricted && mediaProxy.vo.entryExtraData.previewLength <= 0){
							sendNotification(NotificationType.ALERT,{message: MessageStrings.getString('NO_KS'), title: MessageStrings.getString('NO_KS_TITLE')});
							mediaProxy.vo.isMediaDisabled = true;
						}
					}
				
				}
				sendNotification( NotificationType.ENTRY_READY, entry  );
			}
			else
			{
				mediaProxy.vo.isMediaDisabled = true;
			}
			
			//don't wait for the BaseEntryGet result...just continue...
			
			commandComplete();
		}
		
		/**
		 * The client request is failed 
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