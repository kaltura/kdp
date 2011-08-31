package com.kaltura.commands.flavorParams
{
	import com.kaltura.delegates.flavorParams.FlavorParamsGetByConversionProfileIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorParamsGetByConversionProfileId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param conversionProfileId int
		 **/
		public function FlavorParamsGetByConversionProfileId( conversionProfileId : int )
		{
			service= 'flavorparams';
			action= 'getByConversionProfileId';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('conversionProfileId');
			valueArr.push(conversionProfileId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FlavorParamsGetByConversionProfileIdDelegate( this , config );
		}
	}
}
