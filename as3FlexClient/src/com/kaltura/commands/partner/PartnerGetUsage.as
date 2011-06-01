package com.kaltura.commands.partner
{
	import com.kaltura.delegates.partner.PartnerGetUsageDelegate;
	import com.kaltura.net.KalturaCall;

	public class PartnerGetUsage extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param year int
		 * @param month int
		 * @param resolution String
		 **/
		public function PartnerGetUsage( year : int=undefined,month : int=1,resolution : String='days' )
		{
			service= 'partner';
			action= 'getUsage';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('year');
			valueArr.push(year);
			keyArr.push('month');
			valueArr.push(month);
			keyArr.push('resolution');
			valueArr.push(resolution);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PartnerGetUsageDelegate( this , config );
		}
	}
}
