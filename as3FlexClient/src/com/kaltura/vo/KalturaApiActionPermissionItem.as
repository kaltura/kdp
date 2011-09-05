package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPermissionItem;

	[Bindable]
	public dynamic class KalturaApiActionPermissionItem extends KalturaPermissionItem
	{
		/** 
		* 		* */ 
		public var service : String = null;

		/** 
		* 		* */ 
		public var action : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('service');
			arr.push('action');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
