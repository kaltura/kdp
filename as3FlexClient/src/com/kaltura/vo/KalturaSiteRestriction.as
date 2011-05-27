package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseRestriction;

	[Bindable]
	public dynamic class KalturaSiteRestriction extends KalturaBaseRestriction
	{
		public var siteRestrictionType : int = int.MIN_VALUE;

		public var siteList : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('siteRestrictionType');
			arr.push('siteList');
			return arr;
		}
	}
}
