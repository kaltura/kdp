package com.kaltura.commands.flavorParams
{
	import com.kaltura.delegates.flavorParams.FlavorParamsGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorParamsGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function FlavorParamsGet( id : int )
		{
			service= 'flavorparams';
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
			delegate = new FlavorParamsGetDelegate( this , config );
		}
	}
}
