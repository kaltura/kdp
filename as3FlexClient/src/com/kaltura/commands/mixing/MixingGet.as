package com.kaltura.commands.mixing
{
	import com.kaltura.delegates.mixing.MixingGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class MixingGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param entryId String
		 * @param version int
		 **/
		public function MixingGet( entryId : String,version : int=-1 )
		{
			service= 'mixing';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('entryId');
			valueArr.push(entryId);
			keyArr.push('version');
			valueArr.push(version);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new MixingGetDelegate( this , config );
		}
	}
}
