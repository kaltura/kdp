package com.kaltura.vo
{
	import com.kaltura.vo.KalturaBatchJobFilter;

	[Bindable]
	public dynamic class KalturaBatchJobFilterExt extends KalturaBatchJobFilter
	{
		public var jobTypeAndSubTypeIn : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('jobTypeAndSubTypeIn');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('jobTypeAndSubTypeIn');
			return arr;
		}

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('jobTypeAndSubTypeIn');
			return arr;
		}

	}
}
