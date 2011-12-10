package com.kaltura.vo
{
	import com.kaltura.vo.KalturaConfigurableDistributionProfile;

	[Bindable]
	public dynamic class KalturaSynacorHboDistributionProfile extends KalturaConfigurableDistributionProfile
	{
		/** 
		* 		* */ 
		public var feedUrl : String = null;

		/** 
		* 		* */ 
		public var feedTitle : String = null;

		/** 
		* 		* */ 
		public var feedSubtitle : String = null;

		/** 
		* 		* */ 
		public var feedLink : String = null;

		/** 
		* 		* */ 
		public var feedAuthorName : String = null;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('feedTitle');
			arr.push('feedSubtitle');
			arr.push('feedLink');
			arr.push('feedAuthorName');
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
