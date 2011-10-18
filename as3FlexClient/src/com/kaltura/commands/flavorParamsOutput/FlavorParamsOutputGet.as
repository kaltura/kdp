package com.kaltura.commands.flavorParamsOutput
{
	import com.kaltura.delegates.flavorParamsOutput.FlavorParamsOutputGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorParamsOutputGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function FlavorParamsOutputGet( id : int )
		{
			service= 'flavorparamsoutput';
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
			delegate = new FlavorParamsOutputGetDelegate( this , config );
		}
	}
}
