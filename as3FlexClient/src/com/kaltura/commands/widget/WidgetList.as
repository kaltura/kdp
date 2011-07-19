package com.kaltura.commands.widget
{
	import com.kaltura.vo.KalturaWidgetFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.widget.WidgetListDelegate;
	import com.kaltura.net.KalturaCall;

	public class WidgetList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaWidgetFilter
		 * @param pager KalturaFilterPager
		 **/
		public function WidgetList( filter : KalturaWidgetFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaWidgetFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'widget';
			action= 'list';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
 			keyValArr = kalturaObject2Arrays(pager, 'pager');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new WidgetListDelegate( this , config );
		}
	}
}
