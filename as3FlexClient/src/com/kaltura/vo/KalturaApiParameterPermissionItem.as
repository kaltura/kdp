package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPermissionItem;

	[Bindable]
	public dynamic class KalturaApiParameterPermissionItem extends KalturaPermissionItem
	{
		public var object : String;

		public var parameter : String;

		public var action : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('object');
			arr.push('parameter');
			arr.push('action');
			return arr;
		}
	}
}
