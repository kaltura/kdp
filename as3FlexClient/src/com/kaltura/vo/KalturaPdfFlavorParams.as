package com.kaltura.vo
{
	import com.kaltura.vo.KalturaFlavorParams;

	[Bindable]
	public dynamic class KalturaPdfFlavorParams extends KalturaFlavorParams
	{
		public var readonly : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('readonly');
			return arr;
		}
	}
}
