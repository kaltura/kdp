package com.kaltura.commands.conversionProfile
{
	import com.kaltura.delegates.conversionProfile.ConversionProfileSetAsDefaultDelegate;
	import com.kaltura.net.KalturaCall;

	public class ConversionProfileSetAsDefault extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function ConversionProfileSetAsDefault( id : int )
		{
			service= 'conversionprofile';
			action= 'setAsDefault';

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
			delegate = new ConversionProfileSetAsDefaultDelegate( this , config );
		}
	}
}
