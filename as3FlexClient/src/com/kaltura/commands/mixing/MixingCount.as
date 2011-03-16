package com.kaltura.commands.mixing
{
	import com.kaltura.vo.KalturaMediaEntryFilter;
	import com.kaltura.delegates.mixing.MixingCountDelegate;
	import com.kaltura.net.KalturaCall;

	public class MixingCount extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaMediaEntryFilter
		 **/
		public function MixingCount( filter : KalturaMediaEntryFilter=null )
		{
			if(filter== null)filter= new KalturaMediaEntryFilter();
			service= 'mixing';
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
			delegate = new MixingCountDelegate( this , config );
		}
	}
}
