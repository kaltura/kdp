package com.kaltura.vo
{
	import com.kaltura.vo.KalturaDataCenterContentResource;

	[Bindable]
	public dynamic class KalturaWebcamTokenResource extends KalturaDataCenterContentResource
	{
		/** 
		* Token that returned from media server such as FMS or red5. 		* */ 
		public var token : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('token');
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
