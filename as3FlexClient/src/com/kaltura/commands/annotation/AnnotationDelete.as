package com.kaltura.commands.annotation
{
	import com.kaltura.delegates.annotation.AnnotationDeleteDelegate;
	import com.kaltura.net.KalturaCall;

	public class AnnotationDelete extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id String
		 **/
		public function AnnotationDelete( id : String )
		{
			service= 'annotation_annotation';
			action= 'delete';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AnnotationDeleteDelegate( this , config );
		}
	}
}
