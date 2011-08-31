package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseRestriction;

	[Bindable]
	public dynamic class KalturaUserAgentRestriction extends KalturaBaseRestriction
	{
		/** 
		* User agent restriction type (Allow or deny)
		* */ 
		public var userAgentRestrictionType : int = int.MIN_VALUE;

		/** 
		* A comma seperated list of user agent regular expressions
		* */ 
		public var userAgentRegexList : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('userAgentRestrictionType');
			arr.push('userAgentRegexList');
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
