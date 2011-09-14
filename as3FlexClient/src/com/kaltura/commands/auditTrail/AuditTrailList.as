package com.kaltura.commands.auditTrail
{
	import com.kaltura.vo.KalturaAuditTrailFilter;
	import com.kaltura.vo.KalturaFilterPager;
	import com.kaltura.delegates.auditTrail.AuditTrailListDelegate;
	import com.kaltura.net.KalturaCall;

	public class AuditTrailList extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param filter KalturaAuditTrailFilter
		 * @param pager KalturaFilterPager
		 **/
		public function AuditTrailList( filter : KalturaAuditTrailFilter=null,pager : KalturaFilterPager=null )
		{
			if(filter== null)filter= new KalturaAuditTrailFilter();
			if(pager== null)pager= new KalturaFilterPager();
			service= 'audit_audittrail';
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
			delegate = new AuditTrailListDelegate( this , config );
		}
	}
}
