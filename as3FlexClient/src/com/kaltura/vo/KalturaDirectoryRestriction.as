package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBaseRestriction;

	[Bindable]
	public dynamic class KalturaDirectoryRestriction extends KalturaBaseRestriction
	{
		public var directoryRestrictionType : int = int.MIN_VALUE;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('directoryRestrictionType');
			return arr;
		}
	}
}
