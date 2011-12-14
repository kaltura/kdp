package com.kaltura.commands.captionParams
{
	import com.kaltura.vo.KalturaCaptionParamsFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.captionParams.CaptionParamsListDelegate;
	import com.kaltura.net.KalturaCall;

	public class CaptionParamsList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaCaptionParamsFilter
		 * @param pager KalturaFilterPager
		 **/
		public function CaptionParamsList( filter : KalturaCaptionParamsFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'caption_captionparams';
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
			delegate = new CaptionParamsListDelegate( this , config );
		}
	}
}
