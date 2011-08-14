package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseRestriction;

	[Bindable]
	public dynamic class KalturaSiteRestriction extends KalturaBaseRestriction
	{
		/** 
		* The site restriction type (allow or deny)
		* */ 
		public var siteRestrictionType : int = int.MIN_VALUE;

		/** 
		* Comma separated list of sites (domains) to allow or deny
		* */ 
		public var siteList : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('siteRestrictionType');
			arr.push('siteList');
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
