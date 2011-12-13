package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDistributionProfile;

	[Bindable]
	public dynamic class KalturaConfigurableDistributionProfile extends KalturaDistributionProfile
	{
		/** 
		* 		* */ 
		public var fieldConfigArray : Array = new Array();

		/** 
		* 		* */ 
		public var itemXpathsToExtend : Array = new Array();

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('fieldConfigArray');
			arr.push('itemXpathsToExtend');
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
