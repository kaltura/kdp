package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPermissionItem;

	[Bindable]
	public dynamic class KalturaApiParameterPermissionItem extends KalturaPermissionItem
	{
		/** 
		* 		* */ 
		public var object : String = null;

		/** 
		* 		* */ 
		public var parameter : String = null;

		/** 
		* 		* */ 
		public var action : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('object');
			arr.push('parameter');
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
