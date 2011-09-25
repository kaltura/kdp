package com.kaltura.commands.mixing
{
	import com.kaltura.delegates.mixing.MixingAppendMediaEntryDelegate;
	import com.kaltura.net.KalturaCall;

	public class MixingAppendMediaEntry extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param mixEntryId String
		 * @param mediaEntryId String
		 **/
		public function MixingAppendMediaEntry( mixEntryId : String,mediaEntryId : String )
		{
			service= 'mixing';
			action= 'appendMediaEntry';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('mixEntryId');
			valueArr.push(mixEntryId);
			keyArr.push('mediaEntryId');
			valueArr.push(mediaEntryId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MixingAppendMediaEntryDelegate( this , config );
		}
	}
}
