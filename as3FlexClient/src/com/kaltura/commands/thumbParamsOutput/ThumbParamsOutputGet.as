package com.kaltura.commands.thumbParamsOutput
{
	import com.kaltura.delegates.thumbParamsOutput.ThumbParamsOutputGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbParamsOutputGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function ThumbParamsOutputGet( id : int )
		{
			service= 'thumbparamsoutput';
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
			delegate = new ThumbParamsOutputGetDelegate( this , config );
		}
	}
}
