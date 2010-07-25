package com.kaltura.vo
{
	import com.kaltura.vo.KalturaPlayableEntry;

	[Bindable]
	public dynamic class KalturaMixEntry extends KalturaPlayableEntry
	{
		public var hasRealThumbnail : Boolean;
		public var editorType : int = int.MIN_VALUE;
		public var dataContent : String;
		override protected function setupPropertyList():void
		{
			super.setupPropertyList();
			propertyList.push('hasRealThumbnail');
			propertyList.push('editorType');
			propertyList.push('dataContent');
		}
		override public function getParamKeys():Array
		{
			var arr : Array;
			arr = super.getParamKeys();
			arr.push('hasRealThumbnail');
			arr.push('editorType');
			arr.push('dataContent');
			return arr;
		}

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
