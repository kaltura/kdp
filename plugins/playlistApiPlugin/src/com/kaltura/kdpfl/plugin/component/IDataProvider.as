package com.kaltura.kdpfl.plugin.component {

	import flash.events.IEventDispatcher;


	/**
	 * This itnerface lists methods which are required for data providers.
	 */
	public interface IDataProvider extends IEventDispatcher {

		function set selectedIndex(index:Number):void;
		function get selectedIndex():Number;

	}
}