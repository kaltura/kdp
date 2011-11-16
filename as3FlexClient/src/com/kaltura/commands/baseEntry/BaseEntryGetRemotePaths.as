package com.kaltura.commands.baseEntry
{
	import com.kaltura.delegates.baseEntry.BaseEntryGetRemotePathsDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryGetRemotePaths extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function BaseEntryGetRemotePaths( entryId : String )
		{
			service= 'baseentry';
			action= 'getRemotePaths';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryGetRemotePathsDelegate( this , config );
		}
	}
}
