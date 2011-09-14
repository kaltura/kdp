package com.kaltura.commands.permissionItem
{
	import com.kaltura.vo.KalturaPermissionItem;
	import com.kaltura.delegates.permissionItem.PermissionItemAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class PermissionItemAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param permissionItem KalturaPermissionItem
		 **/
		public function PermissionItemAdd( permissionItem : KalturaPermissionItem )
		{
			service= 'permissionitem';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(permissionItem, 'permissionItem');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PermissionItemAddDelegate( this , config );
		}
	}
}
