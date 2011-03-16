package com.kaltura.commands.mixing
{
	import com.kaltura.delegates.mixing.MixingRequestFlatteningDelegate;
	import com.kaltura.net.KalturaCall;

	public class MixingRequestFlattening extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param fileFormat String
		 * @param version int
		 **/
		public function MixingRequestFlattening( entryId : String,fileFormat : String,version : int=-1 )
		{
			service= 'mixing';
			action= 'requestFlattening';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('fileFormat');
			valueArr.push(fileFormat);
			keyArr.push('version');
			valueArr.push(version);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MixingRequestFlatteningDelegate( this , config );
		}
	}
}
