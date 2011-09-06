package com.kaltura.kdpfl.controller
{
	/**
	 *  This interface provides the contract for any service
	 *  that needs to respond to remote or asynchronous calls.
	 */
	public interface IResponder
	{
		/**
		 *  This method is called by a service when the return value
		 *  has been received. 
		 */
		function result(data:Object):void;
		
		/**
		 *  This method is called by a service when an error has been received.
		 */
		function fault(info:Object):void;
	}

}