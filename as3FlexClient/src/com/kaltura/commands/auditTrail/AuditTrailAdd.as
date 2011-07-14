package com.kaltura.commands.auditTrail
{
	import com.kaltura.vo.KalturaAuditTrail;
	import com.kaltura.delegates.auditTrail.AuditTrailAddDelegate;
	import com.kaltura.net.KalturaCall;

	public class AuditTrailAdd extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param auditTrail KalturaAuditTrail
		 **/
		public function AuditTrailAdd( auditTrail : KalturaAuditTrail )
		{
			service= 'audit_audittrail';
			action= 'add';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(auditTrail, 'auditTrail');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AuditTrailAddDelegate( this , config );
		}
	}
}
