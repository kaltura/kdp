package com.kaltura.commands.mixing
{
	import com.kaltura.delegates.mixing.MixingDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class MixingDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 **/
		public function MixingDelete( entryId : String )
		{
			service= 'mixing';
			action= 'delete';

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
			delegate = new MixingDeleteDelegate( this , config );
		}
	}
}
