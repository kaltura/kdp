package com.kaltura.kdpfl.model
{
	import com.kaltura.kdpfl.ApplicationFacade;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.vo.PlayerStatusVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class PlayerStatusProxy extends Proxy
	{
		public static const NAME : String = "playerStatusProxy" ;
		
		private var _signaledPlayerReadyOrEmpty : Boolean = false;
		
		public function PlayerStatusProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, new PlayerStatusVO(ApplicationFacade.getInstance().kdpVersion));
		}
		
		public function get vo () : PlayerStatusVO
		{
			return data as PlayerStatusVO;
		}
		override public function onRegister():void
		{
			
		}
		
		public function dispatchKDPEmpty () : void
		{
			if (!_signaledPlayerReadyOrEmpty)
			{
				_signaledPlayerReadyOrEmpty = true;
				sendNotification( NotificationType.KDP_EMPTY );
			}
		}
		
		public function dispatchKDPReady () : void
		{
			if (!_signaledPlayerReadyOrEmpty)
			{
				_signaledPlayerReadyOrEmpty = true;
				sendNotification( NotificationType.KDP_READY );
			}
		}
	}
}