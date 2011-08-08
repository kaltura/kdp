package com.kaltura.commands.partner
{
	import com.kaltura.vo.KalturaPartner;
	import com.kaltura.delegates.partner.PartnerUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class PartnerUpdate extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param partner KalturaPartner
		 * @param allowEmpty Boolean
		 **/
		public function PartnerUpdate( partner : KalturaPartner,allowEmpty : Boolean=false )
		{
			service= 'partner';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(partner, 'partner');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('allowEmpty');
			valueArr.push(allowEmpty);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PartnerUpdateDelegate( this , config );
		}
	}
}
