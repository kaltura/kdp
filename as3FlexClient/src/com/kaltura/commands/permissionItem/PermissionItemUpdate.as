package com.kaltura.commands.permissionItem
{
	import com.kaltura.vo.KalturaPermissionItem;
	import com.kaltura.delegates.permissionItem.PermissionItemUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class PermissionItemUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param permissionItemId int
		 * @param permissionItem KalturaPermissionItem
		 **/
		public function PermissionItemUpdate( permissionItemId : int,permissionItem : KalturaPermissionItem )
		{
			service= 'permissionitem';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('permissionItemId');
			valueArr.push(permissionItemId);
 			keyValArr = kalturaObject2Arrays(permissionItem, 'permissionItem');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PermissionItemUpdateDelegate( this , config );
		}
	}
}
