package com.kaltura.commands.conversionProfile
{
	import com.kaltura.delegates.conversionProfile.ConversionProfileDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class ConversionProfileDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function ConversionProfileDelete( id : int )
		{
			service= 'conversionprofile';
			action= 'delete';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ConversionProfileDeleteDelegate( this , config );
		}
	}
}
