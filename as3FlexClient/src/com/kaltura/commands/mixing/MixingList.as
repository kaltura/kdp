package com.kaltura.commands.mixing
{
	import com.kaltura.vo.KalturaMixEntryFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.mixing.MixingListDelegate;
	import com.kaltura.net.KalturaCall;

	public class MixingList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaMixEntryFilter
		 * @param pager KalturaFilterPager
		 **/
		public function MixingList( filter : KalturaMixEntryFilter=null,pager : KalturaFilterPager=null )
		{
			service= 'mixing';
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
			delegate = new MixingListDelegate( this , config );
		}
	}
}
