package com.kaltura.commands.conversionProfile
{
	import com.kaltura.delegates.conversionProfile.ConversionProfileGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class ConversionProfileGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function ConversionProfileGet( id : int )
		{
			service= 'conversionprofile';
			action= 'get';

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
			delegate = new ConversionProfileGetDelegate( this , config );
		}
	}
}
