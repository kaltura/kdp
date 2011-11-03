package com.kaltura.commands.uiConfAdmin
{
	import com.kaltura.delegates.uiConfAdmin.UiConfAdminDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class UiConfAdminDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function UiConfAdminDelete( id : int )
		{
			service= 'adminconsole_uiconfadmin';
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
			delegate = new UiConfAdminDeleteDelegate( this , config );
		}
	}
}
