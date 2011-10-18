package com.kaltura.vo
{
	import com.kaltura.vo.KalturaRemoteDropFolder;

	[Bindable]
	public dynamic class KalturaFtpDropFolder extends KalturaRemoteDropFolder
	{
		/** 
		* 		* */ 
		public var host : String = null;

		/** 
		* 		* */ 
		public var port : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var username : String = null;

		/** 
		* 		* */ 
		public var password : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('host');
			arr.push('port');
			arr.push('username');
			arr.push('password');
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
