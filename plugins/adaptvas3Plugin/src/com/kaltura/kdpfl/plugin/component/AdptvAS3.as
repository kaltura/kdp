package com.kaltura.kdpfl.plugin.component
{
	//import com.kaltura.kdpfl.component.IComponent;
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;	

	
	public class AdptvAS3 extends Sprite //implements IComponent
	{
		private var _adaptv : AdaptvAS3Player;
		
		public function AdptvAS3()
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
			_adaptv = value as AdaptvAS3Player;
			addChild(_adaptv as DisplayObject);					
		}	
		
	}
}