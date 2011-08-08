package com.kaltura.commands.permissionItem
{
	import com.kaltura.delegates.permissionItem.PermissionItemDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class PermissionItemDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param permissionItemId int
		 **/
		public function PermissionItemDelete( permissionItemId : int )
		{
			service= 'permissionitem';
			action= 'delete';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('permissionItemId');
			valueArr.push(permissionItemId);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PermissionItemDeleteDelegate( this , config );
		}
	}
}
