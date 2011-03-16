package com.kaltura.commands.uiConf
{
	import com.kaltura.delegates.uiConf.UiConfDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class UiConfDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function UiConfDelete( id : int )
		{
			service= 'uiconf';
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
			delegate = new UiConfDeleteDelegate( this , config );
		}
	}
}
