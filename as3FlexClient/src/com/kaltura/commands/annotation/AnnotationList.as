package com.kaltura.commands.annotation
{
	import com.kaltura.vo.KalturaCuePointFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.annotation.AnnotationListDelegate;
	import com.kaltura.net.KalturaCall;

	public class AnnotationList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaCuePointFilter
		 * @param pager KalturaFilterPager
		 **/
		public function AnnotationList( filter : KalturaCuePointFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'annotation_annotation';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			if (filter) { 
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
 			if (pager) { 
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			} 
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AnnotationListDelegate( this , config );
		}
	}
}
