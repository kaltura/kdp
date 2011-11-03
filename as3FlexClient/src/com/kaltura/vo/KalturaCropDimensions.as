package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaCropDimensions extends BaseFlexVo
	{
		/** 
		* Crop left point
		* */ 
		public var left : int = int.MIN_VALUE;

		/** 
		* Crop top point
		* */ 
		public var top : int = int.MIN_VALUE;

		/** 
		* Crop width
		* */ 
		public var width : int = int.MIN_VALUE;

		/** 
		* Crop height
		* */ 
		public var height : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('left');
			arr.push('top');
			arr.push('width');
			arr.push('height');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
