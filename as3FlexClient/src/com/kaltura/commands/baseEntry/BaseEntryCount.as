package com.kaltura.commands.baseEntry
{
	import com.kaltura.vo.KalturaBaseEntryFilter;
	import com.kaltura.delegates.baseEntry.BaseEntryCountDelegate;
	import com.kaltura.net.KalturaCall;

	public class BaseEntryCount extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaBaseEntryFilter
		 **/
		public function BaseEntryCount( filter : KalturaBaseEntryFilter=null )
		{
			if(filter== null)filter= new KalturaBaseEntryFilter();
			service= 'baseentry';
			action= 'count';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(filter, 'filter');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new BaseEntryCountDelegate( this , config );
		}
	}
}
