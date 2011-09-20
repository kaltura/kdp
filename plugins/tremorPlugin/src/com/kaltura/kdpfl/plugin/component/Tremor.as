package com.kaltura.kdpfl.plugin.component
{
	//import com.kaltura.kdpfl.component.IComponent;
	import com.tremormedia.acudeo.IAdManager;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	import mx.events.ResizeEvent;
			
	public class Tremor extends Sprite //implements IComponent
	{
		private var _adManager:IAdManager;
		
		public function Tremor(adManager:IAdManager)
		{			
			Security.allowDomain("http://objects.tremormedia.com/");	
			ad_manager = adManager;
		}
	
		public function setSkin(skinName:String, setSkinSize:Boolean=false):void
		{
		}
							
		public function set ad_manager(value:IAdManager):void
		{
			_adManager = value as IAdManager;
			addChild(_adManager as DisplayObject);	
		}
		public function get ad_manager():IAdManager
		{
			return _adManager;
		}
		
	}
}