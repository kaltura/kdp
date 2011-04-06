package com.kaltura.commands.thumbParams
{
	import com.kaltura.vo.KalturaThumbParamsFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.thumbParams.ThumbParamsListDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbParamsList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaThumbParamsFilter
		 * @param pager KalturaFilterPager
		 **/
		public function ThumbParamsList( filter : KalturaThumbParamsFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaThumbParamsFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'thumbparams';
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
			delegate = new ThumbParamsListDelegate( this , config );
		}
	}
}
