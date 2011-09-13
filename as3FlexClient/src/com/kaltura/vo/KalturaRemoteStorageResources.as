package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaRemoteStorageResources extends KalturaContentResource
	{
		/** 
		* Array of remote stoage resources 		* */ 
		public var resources : Array = new Array();

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('resources');
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
