package com.kaltura.commands.conversionProfile
{
	import com.kaltura.vo.KalturaConversionProfile;
	import com.kaltura.delegates.conversionProfile.ConversionProfileAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class ConversionProfileAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param conversionProfile KalturaConversionProfile
		 **/
		public function ConversionProfileAdd( conversionProfile : KalturaConversionProfile )
		{
			service= 'conversionprofile';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(conversionProfile, 'conversionProfile');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ConversionProfileAddDelegate( this , config );
		}
	}
}
