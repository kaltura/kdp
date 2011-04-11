package com.kaltura.kdpfl.model
{
	import com.kaltura.kdpfl.ApplicationFacade;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.model.vo.PlayerStatusVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	/**
	 * Proxy for the player status. 
	 * @author Hila
	 * 
	 */	
	public class PlayerStatusProxy extends Proxy
	{
		public static const NAME : String = "playerStatusProxy" ;
		
		private var _signaledPlayerReadyOrEmpty : Boolean = false;
		/**
		 * Constructor 
		 * @param proxyName - name of the proxy
		 * @param data the data held by the proxy
		 * 
		 */		
		public function PlayerStatusProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, new PlayerStatusVO(ApplicationFacade.getInstance().kdpVersion));
		}
		/**
		 * Retrieve the data held by the Proxy. 
		 * @return PlayerStatusVO.
		 * 
		 */		
		public function get vo () : PlayerStatusVO
		{
			return data as PlayerStatusVO;
		}
		override public function onRegister():void
		{
			
		}
		/**
		 * function dispatches the KDP_EMPTY notification once in the player's lifetime, if the KDP was initiated with the
		 * flashvar <code>entryId</code> was set to "" or "-1", or if the entry was so restricted as to be unplayable.
		 * 
		 */		
		public function dispatchKDPEmpty () : void
		{
			if (!_signaledPlayerReadyOrEmpty)
			{
				_signaledPlayerReadyOrEmpty = true;
				sendNotification( NotificationType.KDP_EMPTY );
			}
		}
		/**
		 * function dispatches the KDP_READY notification once in the player's lifetime, if the KDP was initiated with the
		 * flashvar <code>entryId</code> was set to a real value and the entry was not restricted. 
		 * 
		 */		
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