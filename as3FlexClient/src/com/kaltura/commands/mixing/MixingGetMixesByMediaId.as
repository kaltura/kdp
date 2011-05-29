package com.kaltura.commands.mixing
{
	import com.kaltura.delegates.mixing.MixingGetMixesByMediaIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class MixingGetMixesByMediaId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param mediaEntryId String
		 **/
		public function MixingGetMixesByMediaId( mediaEntryId : String )
		{
			service= 'mixing';
			action= 'getMixesByMediaId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('mediaEntryId');
			valueArr.push(mediaEntryId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MixingGetMixesByMediaIdDelegate( this , config );
		}
	}
}
