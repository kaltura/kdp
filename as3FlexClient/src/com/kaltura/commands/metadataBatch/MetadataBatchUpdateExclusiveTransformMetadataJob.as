package com.kaltura.commands.metadataBatch
{
	import com.kaltura.vo.KalturaExclusiveLockKey;
	import com.kaltura.vo.KalturaMetadataBatchJob;
	import com.kaltura.delegates.metadataBatch.MetadataBatchUpdateExclusiveTransformMetadataJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataBatchUpdateExclusiveTransformMetadataJob extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataBatchUpdateExclusiveTransformMetadataJob( id : int,lockKey : KalturaExclusiveLockKey,job : KalturaMetadataBatchJob )
		{
			service= 'metadata_metadatabatch';
			action= 'updateExclusiveTransformMetadataJob';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'id' );
			valueArr.push( id );
 			keyValArr = kalturaObject2Arrays(lockKey,'lockKey');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
 			keyValArr = kalturaObject2Arrays(job,'job');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataBatchUpdateExclusiveTransformMetadataJobDelegate( this , config );
		}
	}
}
