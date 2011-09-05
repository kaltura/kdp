package com.kaltura.vo
{
	import com.kaltura.vo.KalturaUiConf;

	[Bindable]
	public dynamic class KalturaUiConfAdmin extends KalturaUiConf
	{
		/** 
		* 		* */ 
		public var isPublic : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('isPublic');
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
