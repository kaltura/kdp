package com.kaltura.commands.permissionItem
{
	import com.kaltura.delegates.permissionItem.PermissionItemGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class PermissionItemGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param permissionItemId int
		 **/
		public function PermissionItemGet( permissionItemId : int )
		{
			service= 'permissionitem';
			action= 'get';

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
			delegate = new PermissionItemGetDelegate( this , config );
		}
	}
}
