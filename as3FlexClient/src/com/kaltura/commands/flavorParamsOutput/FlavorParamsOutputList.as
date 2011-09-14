package com.kaltura.commands.flavorParamsOutput
{
	import com.kaltura.vo.KalturaFlavorParamsOutputFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.flavorParamsOutput.FlavorParamsOutputListDelegate;
	import com.kaltura.net.KalturaCall;

	public class FlavorParamsOutputList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaFlavorParamsOutputFilter
		 * @param pager KalturaFilterPager
		 **/
		public function FlavorParamsOutputList( filter : KalturaFlavorParamsOutputFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaFlavorParamsOutputFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'adminconsole_flavorparamsoutput';
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
			delegate = new FlavorParamsOutputListDelegate( this , config );
		}
	}
}
