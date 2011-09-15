package com.kaltura.commands.permission
{
	import com.kaltura.vo.KalturaPermission;
	import com.kaltura.delegates.permission.PermissionAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class PermissionAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param permission KalturaPermission
		 **/
		public function PermissionAdd( permission : KalturaPermission )
		{
			service= 'permission';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(permission, 'permission');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PermissionAddDelegate( this , config );
		}
	}
}
