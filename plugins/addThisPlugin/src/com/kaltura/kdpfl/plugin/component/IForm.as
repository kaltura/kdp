package com.kaltura.kdpfl.plugin.component
{
	import com.kaltura.kdpfl.controller.ICommand;

	public interface IForm
	{
		function get url():String;
		function get formComponents():Array;
		function get formParams():Object;
		function get data():Object;
	}
}