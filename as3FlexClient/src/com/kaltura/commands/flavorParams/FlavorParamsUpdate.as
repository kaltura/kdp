package com.kaltura.commands.flavorParams
{
	import com.kaltura.vo.KalturaFlavorParams;
	import com.kaltura.delegates.flavorParams.FlavorParamsUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorParamsUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 * @param flavorParams KalturaFlavorParams
		 **/
		public function FlavorParamsUpdate( id : int,flavorParams : KalturaFlavorParams )
		{
			service= 'flavorparams';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
 			keyValArr = kalturaObject2Arrays(flavorParams, 'flavorParams');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new FlavorParamsUpdateDelegate( this , config );
		}
	}
}
