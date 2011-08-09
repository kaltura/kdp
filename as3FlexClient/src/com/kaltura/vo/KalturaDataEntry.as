package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseEntry;

	[Bindable]
	public dynamic class KalturaDataEntry extends KalturaBaseEntry
	{
		/** 
		* The data of the entry		* */ 
		public var dataContent : String;

		/** 
		* indicator whether to return the object for get action with the dataContent field.		* */ 
		public var retrieveDataContentByGet : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('dataContent');
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			arr.push('retrieveDataContentByGet');
			return arr;
		}

	}
}
