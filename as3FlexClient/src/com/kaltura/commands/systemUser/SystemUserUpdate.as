package com.kaltura.commands.systemUser
{
	import com.kaltura.vo.KalturaSystemUser;
	import com.kaltura.delegates.systemUser.SystemUserUpdateDelegate;
	import com.kaltura.net.KalturaCall;

	public class SystemUserUpdate extends KalturaCall
	{
		public var filterFields : String;
		public function SystemUserUpdate( userId : int,systemUser : KalturaSystemUser )
		{
			service= 'systemuser_systemuser';
			action= 'update';

			var keyArr : Array = new Array();
			var valueArr : Array = new Array();
			var keyValArr : Array = new Array();
			keyArr.push( 'userId' );
			valueArr.push( userId );
 			keyValArr = kalturaObject2Arrays(systemUser,'systemUser');
			keyArr = keyArr.concat( keyValArr[0] );
			valueArr = valueArr.concat( keyValArr[1] );
			applySchema( keyArr , valueArr );
		}

		override public function execute() : void
		{
			setRequestArgument('filterFields',filterFields);
			delegate = new SystemUserUpdateDelegate( this , config );
		}
	}
}
