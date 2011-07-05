package com.kaltura.kdpfl.controller.media
{
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.metadata.MetadataList;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.model.ConfigProxy;
	import com.kaltura.kdpfl.model.MediaProxy;
	import com.kaltura.kdpfl.model.ServicesProxy;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.types.KalturaMetadataObjectType;
	import com.kaltura.vo.KalturaMetadataFilter;
	import com.kaltura.vo.KalturaMetadataListResponse;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncCommand;
	/**
	 * DEPRECATED 
	 * @author Hila
	 * 
	 */	
	public class GetMetaDataCommand extends AsyncCommand
	{
		private var _entryId : String;
		
		private var _requiredFields : Object;
		
		public function GetMetaDataCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			
			getParams();
			
			if (!_requiredFields)
			{
			 	commandComplete();	
				return;
			}
			
			var kc : KalturaClient = (facade.retrieveProxy(ServicesProxy.NAME) as ServicesProxy).kalturaClient; 
			
			var metadataFilter : KalturaMetadataFilter = new KalturaMetadataFilter();
			
			metadataFilter.metadataObjectTypeEqual = KalturaMetadataObjectType.ENTRY;
			
			metadataFilter.objectIdEqual = _entryId;
			
			var metaDataList : MetadataList = new MetadataList(metadataFilter);
			
			metaDataList.addEventListener(KalturaEvent.COMPLETE, onMetadataReceived);
			
			metaDataList.addEventListener( KalturaEvent.FAILED, onMetadataFailed );
			
			kc.post( metaDataList );
		}
		
		private function onMetadataReceived (e : KalturaEvent) : void
		{
			
			var mediaProxy : MediaProxy = facade.retrieveProxy(MediaProxy.NAME) as MediaProxy;
			
			mediaProxy.vo.entryMetadata = new Object();
			
			var listResponse : KalturaMetadataListResponse = e.data as KalturaMetadataListResponse;
			if ( listResponse.objects[0])
			{
				var metadataXml : XMLList = XML(listResponse.objects[0]["xml"]).children();
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
			
			commandComplete();
		}
		
		private function onMetadataFailed (e : KalturaEvent) : void
		{
			commandComplete();
		}
		
		private function getParams () : void
		{
			_requiredFields = (facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy).vo.flashvars.requiredMetadataFields;
				
			_entryId = (facade.retrieveProxy(MediaProxy.NAME) as MediaProxy).vo.entry.id;
		}
	}
}