package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPlayableEntry;

	[Bindable]
	public dynamic class KalturaMixEntry extends KalturaPlayableEntry
	{
		/** 
		* Indicates whether the user has submited a real thumbnail to the mix (Not the one that was generated automaticaly)
		* */ 
		public var hasRealThumbnail : Boolean;

		/** 
		* The editor type used to edit the metadata
		* */ 
		public var editorType : int = int.MIN_VALUE;

		/** 
		* The xml data of the mix		* */ 
		public var dataContent : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('editorType');
			arr.push('dataContent');
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
