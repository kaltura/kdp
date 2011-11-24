package com.kaltura.kdpfl.manager
{
	public interface IAddThisEmailDelegate
	{
		function get sender():String;
		function get recipients():String;
		function get note():String;
		function get url():String;
		function response(data:Object):void;
	}
}