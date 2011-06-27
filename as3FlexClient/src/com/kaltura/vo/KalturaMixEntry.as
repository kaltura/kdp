package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPlayableEntry;

	[Bindable]
	public dynamic class KalturaMixEntry extends KalturaPlayableEntry
	{
		public var hasRealThumbnail : Boolean;

		public var editorType : int = int.MIN_VALUE;

		public var dataContent : String;

		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			arr.push('editorType');
			arr.push('dataContent');
			return arr;
		}
	}
}
