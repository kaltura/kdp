package com.kaltura.commands.partner
{
	import com.kaltura.vo.KalturaPartner;
	import com.kaltura.delegates.partner.PartnerRegisterDelegate;
	import com.kaltura.net.KalturaCall;

	public class PartnerRegister extends KalturaCall
	{
		public var filterFields : String;
		/**
		 * @param partner KalturaPartner
		 * @param cmsPassword String
		 **/
		public function PartnerRegister( partner : KalturaPartner,cmsPassword : String='' )
		{
			service= 'partner';
			action= 'register';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
 			keyValArr = kalturaObject2Arrays(partner, 'partner');
			keyArr = keyArr.concat(keyValArr[0]);
			valueArr = valueArr.concat(keyValArr[1]);
			keyArr.push('cmsPassword');
			valueArr.push(cmsPassword);
			applySchema(keyArr, valueArr);
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields', filterFields);
			delegate = new PartnerRegisterDelegate( this , config );
		}
	}
}
