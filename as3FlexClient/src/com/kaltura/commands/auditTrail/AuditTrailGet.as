package com.kaltura.commands.auditTrail
{
	import com.kaltura.delegates.auditTrail.AuditTrailGetDelegate;
	import com.kaltura.net.KalturaCall;

	public class AuditTrailGet extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param id int
		 **/
		public function AuditTrailGet( id : int )
		{
			service= 'audit_audittrail';
			action= 'get';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push('id');
			valueArr.push(id);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new AuditTrailGetDelegate( this , config );
		}
	}
}
