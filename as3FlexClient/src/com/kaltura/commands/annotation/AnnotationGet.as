package com.kaltura.commands.annotation
{
	import com.kaltura.delegates.annotation.AnnotationGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class AnnotationGet extends KalturaCall
	{
		public var filterFields : String;
		public function AnnotationGet( id : String )
		{
			service= 'annotation_annotation';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'id' );
			valueArr.push( id );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new AnnotationGetDelegate( this , config );
		}
	}
}
