package com.kaltura.commands.metadataBatch
{
	import com.kaltura.vo.KalturaExclusiveLockKey;
	import com.kaltura.delegates.metadataBatch.MetadataBatchFreeExclusiveJobDelegate;
	import com.kaltura.net.KalturaCall;

	public class MetadataBatchFreeExclusiveJob extends KalturaCall
	{
		public var filterFields : String;
		public function MetadataBatchFreeExclusiveJob( id : int,lockKey : KalturaExclusiveLockKey,jobType : int,resetExecutionAttempts : Boolean=false )
		{
			service= 'metadata_metadatabatch';
			action= 'freeExclusiveJob';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'id' );
			valueArr.push( id );
 			keyValArr = kalturaObject2Arrays(lockKey,'lockKey');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			keyArr.push( 'jobType' );
			valueArr.push( jobType );
			keyArr.push( 'resetExecutionAttempts' );
			valueArr.push( resetExecutionAttempts );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new MetadataBatchFreeExclusiveJobDelegate( this , config );
		}
	}
}
