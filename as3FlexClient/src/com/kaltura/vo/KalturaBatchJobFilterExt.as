package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBatchJobFilter;

	[Bindable]
	public dynamic class KalturaBatchJobFilterExt extends KalturaBatchJobFilter
	{
		public var jobTypeAndSubTypeIn : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('jobTypeAndSubTypeIn');
			return arr;
		}
	}
}
