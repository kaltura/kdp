package com.kaltura.commands.annotation
{
	import flash.net.FileReference;
	import com.kaltura.net.KalturaFileCall;
	import com.kaltura.delegates.annotation.AnnotationAddFromBulkDelegate;

	public class AnnotationAddFromBulk extends KalturaFileCall
	{
		public var fileData:Object;

		/**
		 * @param fileData Object - FileReference or ByteArray
		 **/
		public function AnnotationAddFromBulk( fileData : Object )
		{
			service= 'annotation_annotation';
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
			delegate = new AnnotationAddFromBulkDelegate( this , config );
		}
	}
}
