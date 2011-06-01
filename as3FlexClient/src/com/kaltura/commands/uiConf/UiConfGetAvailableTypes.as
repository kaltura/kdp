package com.kaltura.commands.uiConf
{
	import com.kaltura.delegates.uiConf.UiConfGetAvailableTypesDelegate;
	import com.kaltura.net.KalturaCall;

	public class UiConfGetAvailableTypes extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function UiConfGetAvailableTypes(  )
		{
			service= 'uiconf';
			action= 'getAvailableTypes';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new UiConfGetAvailableTypesDelegate( this , config );
		}
	}
}
