package com.kaltura.commands.annotation
{
	import com.kaltura.vo.KalturaCuePointFilter;
	import com.kaltura.delegates.annotation.AnnotationCountDelegate;
	import com.kaltura.net.KalturaCall;

	public class AnnotationCount extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaCuePointFilter
		 **/
		public function AnnotationCount( filter : KalturaCuePointFilter=null )
		{
			service= 'annotation_annotation';
			action= 'count';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			if (filter) { 
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AnnotationCountDelegate( this , config );
		}
	}
}
