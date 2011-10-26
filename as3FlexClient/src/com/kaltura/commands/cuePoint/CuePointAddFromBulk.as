package com.kaltura.commands.cuePoint
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.cuePoint.CuePointAddFromBulkDelegate;

	public class CuePointAddFromBulk extends KalturaFileCall
	{
		public var fileData:Object;

		/**
		 * @param fileData Object - FileReference or ByteArray
		 **/
		public function CuePointAddFromBulk( fileData : Object )
		{
			service= 'cuepoint_cuepoint';
			action= 'addFromBulk';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			this.fileData = fileData;
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new CuePointAddFromBulkDelegate( this , config );
		}
	}
}
