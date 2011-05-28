package com.kaltura.commands.annotation
{
	import com.kaltura.vo.KalturaAnnotationFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.annotation.AnnotationListDelegate;
	import com.kaltura.net.KalturaCall;

	public class AnnotationList extends KalturaCall
	{
		public var filterFields : String;
		public function AnnotationList( filter : KalturaAnnotationFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaAnnotationFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'annotation_annotation';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(filter,'filter');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
 			keyValArr = kalturaObject2Arrays(pager,'pager');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new AnnotationListDelegate( this , config );
		}
	}
}
