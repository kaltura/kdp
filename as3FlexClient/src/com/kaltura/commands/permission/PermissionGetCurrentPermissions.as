package com.kaltura.commands.permission
{
	import com.kaltura.delegates.permission.PermissionGetCurrentPermissionsDelegate;
	import com.kaltura.net.KalturaCall;

	public class PermissionGetCurrentPermissions extends KalturaCall
	{
		public var filterFields : String;
		/**
		 **/
		public function PermissionGetCurrentPermissions(  )
		{
			service= 'permission';
			action= 'getCurrentPermissions';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PermissionGetCurrentPermissionsDelegate( this , config );
		}
	}
}
