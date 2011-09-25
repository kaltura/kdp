package com.kaltura.commands.conversionProfile
{
	import com.kaltura.vo.KalturaConversionProfile;
	import com.kaltura.delegates.conversionProfile.ConversionProfileUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class ConversionProfileUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param conversionProfile KalturaConversionProfile
		 **/
		public function ConversionProfileUpdate( id : int,conversionProfile : KalturaConversionProfile )
		{
			service= 'conversionprofile';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(conversionProfile, 'conversionProfile');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new ConversionProfileUpdateDelegate( this , config );
		}
	}
}
