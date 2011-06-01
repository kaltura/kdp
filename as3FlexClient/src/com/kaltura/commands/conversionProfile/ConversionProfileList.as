package com.kaltura.commands.conversionProfile
{
	import com.kaltura.vo.KalturaConversionProfileFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.conversionProfile.ConversionProfileListDelegate;
	import com.kaltura.net.KalturaCall;

	public class ConversionProfileList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaConversionProfileFilter
		 * @param pager KalturaFilterPager
		 **/
		public function ConversionProfileList( filter : KalturaConversionProfileFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaConversionProfileFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'conversionprofile';
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
			delegate = new ConversionProfileListDelegate( this , config );
		}
	}
}
