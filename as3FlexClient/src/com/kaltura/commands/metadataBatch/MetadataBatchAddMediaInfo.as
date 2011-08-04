package com.kaltura.commands.metadataBatch
{
	import com.kaltura.vo.KalturaMediaInfo;
	import com.kaltura.delegates.metadataBatch.MetadataBatchAddMediaInfoDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataBatchAddMediaInfo extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataBatchAddMediaInfo( mediaInfo : KalturaMediaInfo )
		{
			service= 'metadata_metadatabatch';
			action= 'addMediaInfo';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(mediaInfo,'mediaInfo');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataBatchAddMediaInfoDelegate( this , config );
		}
	}
}
