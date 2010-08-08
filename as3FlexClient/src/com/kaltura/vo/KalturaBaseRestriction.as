package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaBaseRestriction extends BaseFlexVo
	{
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
		}
		public function getParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
