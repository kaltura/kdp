package com.kaltura
{
	import com.kaltura.commands.metadata.MetadataList;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.kdpfl.util.XMLUtils;
	import com.kaltura.puremvc.as3.patterns.mediator.SequenceMultiMediator;
	import com.kaltura.types.KalturaMetadataObjectType;
	import com.kaltura.vo.KalturaMetadata;
	import com.kaltura.vo.KalturaMetadataFilter;
	import com.kaltura.vo.KalturaMetadataListResponse;KalturaMetadata;

	
	public class MetaDataMediator extends SequenceMultiMediator
	{
		
		
		
		public function MetaDataMediator(viewComponent : Object=null)
		{
			super(viewComponent);
			facade["bindObject"]["metaData"] = viewComponent;
		}
		
		
		
		public function start () : void
		{
			var kc : KalturaClient = facade.retrieveProxy("servicesProxy")["kalturaClient"] as KalturaClient;
			var entryId : String = facade.retrieveProxy("mediaProxy")["vo"]["entry"]["id"];
			var metadataFilter : KalturaMetadataFilter = new KalturaMetadataFilter();
			metadataFilter.metadataObjectTypeEqual = KalturaMetadataObjectType.ENTRY;
			metadataFilter.objectIdEqual = entryId;
			var metaDataList : MetadataList = new MetadataList(metadataFilter);
			metaDataList.addEventListener(KalturaEvent.COMPLETE, onMetadataReceived);
			metaDataList.addEventListener( KalturaEvent.FAILED, onMetadataFailed );
			kc.post( metaDataList );
		}
		
		private function onMetadataReceived (e : KalturaEvent) : void
		{
			viewComponent["metaData"] = new Object();
			var listResponse : KalturaMetadataListResponse = e.data as KalturaMetadataListResponse;
			if ( listResponse.objects[0])
			{
				var metadataXml : XMLList = XML(listResponse.objects[0]["xml"]).children();
				var metaDataObj : Object = new Object();
				for each (var node : XML in metadataXml)
				{
					metaDataObj[node.name().toString()] = node.valueOf().toString();
				}
				viewComponent["metaData"] = metaDataObj;
			}
			sendNotification("sequenceItemPlayEnd");
		}
		
		private function onMetadataFailed ( e: KalturaEvent) : void
		{
			trace("metadata failed");
			sendNotification("sequenceItemPlayEnd");
		}
	}
}