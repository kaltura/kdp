package com.kaltura.commands.uiConf
{
	import com.kaltura.delegates.uiConf.UiConfGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class UiConfGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function UiConfGet( id : int )
		{
			service= 'uiconf';
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
			delegate = new UiConfGetDelegate( this , config );
		}
	}
}
