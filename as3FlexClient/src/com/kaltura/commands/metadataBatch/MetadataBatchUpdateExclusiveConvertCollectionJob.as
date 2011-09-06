package com.kaltura.commands.metadataBatch
{
	import com.kaltura.vo.KalturaExclusiveLockKey;
	import com.kaltura.vo.KalturaBatchJob;
	import com.kaltura.delegates.metadataBatch.MetadataBatchUpdateExclusiveConvertCollectionJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataBatchUpdateExclusiveConvertCollectionJob extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataBatchUpdateExclusiveConvertCollectionJob( id : int,lockKey : KalturaExclusiveLockKey,job : KalturaBatchJob,entryStatus : int=undefined,flavorsData : Array=null )
		{
			if(flavorsData== null)flavorsData= new Array();
			service= 'metadata_metadatabatch';
			action= 'updateExclusiveConvertCollectionJob';

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
			keyArr.push( 'entryStatus' );
			valueArr.push( entryStatus );
 			keyValArr = extractArray(flavorsData,'flavorsData');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataBatchUpdateExclusiveConvertCollectionJobDelegate( this , config );
		}
	}
}
