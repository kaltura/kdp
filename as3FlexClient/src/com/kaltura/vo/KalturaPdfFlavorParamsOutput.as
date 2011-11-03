package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParamsOutput;

	[Bindable]
	public dynamic class KalturaPdfFlavorParamsOutput extends KalturaFlavorParamsOutput
	{
		/** 
		* 		* */ 
		public var readonly : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('readonly');
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
