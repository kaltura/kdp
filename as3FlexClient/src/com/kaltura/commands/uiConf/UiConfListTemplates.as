package com.kaltura.commands.uiConf
{
	import com.kaltura.vo.KalturaUiConfFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.uiConf.UiConfListTemplatesDelegate;
	import com.kaltura.net.KalturaCall;

	public class UiConfListTemplates extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaUiConfFilter
		 * @param pager KalturaFilterPager
		 **/
		public function UiConfListTemplates( filter : KalturaUiConfFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'uiconf';
			action= 'listTemplates';

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
			delegate = new UiConfListTemplatesDelegate( this , config );
		}
	}
}
