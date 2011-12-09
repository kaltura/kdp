package com.kaltura.commands.permission
{
	import com.kaltura.delegates.permission.PermissionDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class PermissionDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param permissionName String
		 **/
		public function PermissionDelete( permissionName : String )
		{
			service= 'permission';
			action= 'delete';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('permissionName');
			valueArr.push(permissionName);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PermissionDeleteDelegate( this , config );
		}
	}
}
