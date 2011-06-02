package com.kaltura.commands.uiConf
{
	import com.kaltura.vo.KalturaUiConfFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.uiConf.UiConfListDelegate;
	import com.kaltura.net.KalturaCall;

	public class UiConfList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaUiConfFilter
		 * @param pager KalturaFilterPager
		 **/
		public function UiConfList( filter : KalturaUiConfFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaUiConfFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'uiconf';
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
			delegate = new UiConfListDelegate( this , config );
		}
	}
}
