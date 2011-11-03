package com.kaltura.commands.flavorParams
{
	import com.kaltura.vo.KalturaFlavorParamsFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.flavorParams.FlavorParamsListDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorParamsList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaFlavorParamsFilter
		 * @param pager KalturaFilterPager
		 **/
		public function FlavorParamsList( filter : KalturaFlavorParamsFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'flavorparams';
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
			delegate = new FlavorParamsListDelegate( this , config );
		}
	}
}
