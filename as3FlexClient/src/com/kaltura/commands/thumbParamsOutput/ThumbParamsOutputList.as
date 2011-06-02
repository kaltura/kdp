package com.kaltura.commands.thumbParamsOutput
{
	import com.kaltura.vo.KalturaThumbParamsOutputFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.thumbParamsOutput.ThumbParamsOutputListDelegate;
	import com.kaltura.net.KalturaCall;

	public class ThumbParamsOutputList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaThumbParamsOutputFilter
		 * @param pager KalturaFilterPager
		 **/
		public function ThumbParamsOutputList( filter : KalturaThumbParamsOutputFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaThumbParamsOutputFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'adminconsole_thumbparamsoutput';
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
			delegate = new ThumbParamsOutputListDelegate( this , config );
		}
	}
}
