package com.kaltura.commands.uiConfAdmin
{
	import com.kaltura.delegates.uiConfAdmin.UiConfAdminGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class UiConfAdminGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function UiConfAdminGet( id : int )
		{
			service= 'adminconsole_uiconfadmin';
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
			delegate = new UiConfAdminGetDelegate( this , config );
		}
	}
}
