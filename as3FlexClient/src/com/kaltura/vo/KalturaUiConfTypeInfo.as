package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaUiConfTypeInfo extends BaseFlexVo
	{
		/** 
		* UiConf Type
		* */ 
		public var type : int = int.MIN_VALUE;

		/** 
		* Available versions
		* */ 
		public var versions : Array = new Array();

		/** 
		* The direcotry this type is saved at
		* */ 
		public var directory : String = null;

		/** 
		* Filename for this UiConf type
		* */ 
		public var filename : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('type');
			arr.push('versions');
			arr.push('directory');
			arr.push('filename');
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
