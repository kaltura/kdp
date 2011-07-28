package com.kaltura.commands.flavorParams
{
	import com.kaltura.delegates.flavorParams.FlavorParamsDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorParamsDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function FlavorParamsDelete( id : int )
		{
			service= 'flavorparams';
			action= 'delete';

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
			delegate = new FlavorParamsDeleteDelegate( this , config );
		}
	}
}
