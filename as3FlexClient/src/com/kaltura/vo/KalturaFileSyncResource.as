package com.kaltura.vo
{
	import com.kaltura.vo.KalturaContentResource;

	[Bindable]
	public dynamic class KalturaFileSyncResource extends KalturaContentResource
	{
		/** 
		* The object type of the file sync object 		* */ 
		public var fileSyncObjectType : int = int.MIN_VALUE;

		/** 
		* The object sub-type of the file sync object 		* */ 
		public var objectSubType : int = int.MIN_VALUE;

		/** 
		* The object id of the file sync object 		* */ 
		public var objectId : String;

		/** 
		* The version of the file sync object 		* */ 
		public var version : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('fileSyncObjectType');
			arr.push('objectSubType');
			arr.push('objectId');
			arr.push('version');
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
