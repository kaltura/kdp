package com.kaltura.commands.mixing
{
	import com.kaltura.delegates.mixing.MixingCloneDelegate;
	import com.kaltura.net.KalturaCall;

	public class MixingClone extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function MixingClone( entryId : String )
		{
			service= 'mixing';
			action= 'clone';

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
			delegate = new MixingCloneDelegate( this , config );
		}
	}
}
