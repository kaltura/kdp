package com.kaltura.vo
{
	import com.kaltura.vo.KalturaUserBaseFilter;

	[Bindable]
	public dynamic class KalturaUserFilter extends KalturaUserBaseFilter
	{
		/** 
		* 		* */ 
		public var idEqual : String = null;

		/** 
		* 		* */ 
		public var idIn : String = null;

		/** 
		* 		* */ 
		public var loginEnabledEqual : Boolean;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('idEqual');
			arr.push('idIn');
			arr.push('loginEnabledEqual');
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
