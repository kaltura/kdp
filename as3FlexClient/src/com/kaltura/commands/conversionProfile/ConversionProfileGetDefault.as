package com.kaltura.commands.conversionProfile
{
	import com.kaltura.delegates.conversionProfile.ConversionProfileGetDefaultDelegate;
	import com.kaltura.net.KalturaCall;

	public class ConversionProfileGetDefault extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function ConversionProfileGetDefault(  )
		{
			service= 'conversionprofile';
			action= 'getDefault';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ConversionProfileGetDefaultDelegate( this , config );
		}
	}
}
