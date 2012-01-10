package com.kaltura.kdpfl.plugin.component
{
	//import com.kaltura.kdpfl.component.IComponent;
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;	

	
	public class Adaptv extends Sprite //implements IComponent
	{
		private var _adaptv : AdaptvPlayer;
		
		public function Adaptv()
		{			
		}

		public function initialize():void
		{
		}
		
		public function setSkin(skinName:String, setSkinSize:Boolean=false):void
		{
		}
		
		public function set adaptv(value:Object):void
		{
			_adaptv = value as AdaptvPlayer;
			addChild(_adaptv as DisplayObject);					
		}	
		
	}
}