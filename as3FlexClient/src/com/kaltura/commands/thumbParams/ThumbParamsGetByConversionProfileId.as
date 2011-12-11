package com.kaltura.commands.thumbParams
{
	import com.kaltura.delegates.thumbParams.ThumbParamsGetByConversionProfileIdDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbParamsGetByConversionProfileId extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param conversionProfileId int
		 **/
		public function ThumbParamsGetByConversionProfileId( conversionProfileId : int )
		{
			service= 'thumbparams';
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
			delegate = new ThumbParamsGetByConversionProfileIdDelegate( this , config );
		}
	}
}
