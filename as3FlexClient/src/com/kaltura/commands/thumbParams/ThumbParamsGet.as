package com.kaltura.commands.thumbParams
{
	import com.kaltura.delegates.thumbParams.ThumbParamsGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbParamsGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function ThumbParamsGet( id : int )
		{
			service= 'thumbparams';
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
			delegate = new ThumbParamsGetDelegate( this , config );
		}
	}
}
