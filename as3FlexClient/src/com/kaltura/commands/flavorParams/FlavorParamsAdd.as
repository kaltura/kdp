package com.kaltura.commands.flavorParams
{
	import com.kaltura.vo.KalturaFlavorParams;
	import com.kaltura.delegates.flavorParams.FlavorParamsAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorParamsAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param flavorParams KalturaFlavorParams
		 **/
		public function FlavorParamsAdd( flavorParams : KalturaFlavorParams )
		{
			service= 'flavorparams';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(flavorParams, 'flavorParams');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FlavorParamsAddDelegate( this , config );
		}
	}
}
