package com.kaltura.kdpfl.plugin.view
{
	import com.kaltura.kdpfl.plugin.model.UniformCompanionAd;
	import org.osmf.utils.HTTPLoader;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.osmf.elements.beaconClasses.Beacon;

	public class CompanionContainer extends Sprite
	{
		private var _companionInfo : UniformCompanionAd;
		private var _backGround : Sprite;
		public function CompanionContainer(companionInfo : UniformCompanionAd)
		{
			_companionInfo = companionInfo;
			this.buttonMode = true;
			createBG();
		}
		
		private function createBG () : void
		{
			_backGround = new Sprite();
			_backGround.graphics.beginFill(0x000000);
			_backGround.graphics.drawRect(0,0,10,10);
			_backGround.graphics.endFill();
			_backGround.width = width;
			_backGround.height = height;
			addChild(_backGround);
		}
		
		public function addClickListener () : void
		{
			this.addEventListener(MouseEvent.CLICK, onCompanionClick );
		}
		
		private function onCompanionClick ( e: MouseEvent) : void
		{
			if (_companionInfo && _companionInfo.companionClickThrough)
			{
				var urlReq : URLRequest = new URLRequest(_companionInfo.companionClickThrough);
				navigateToURL(urlReq);
			}
		}
		
		public function fireCreativeView() : void
		{
			if (_companionInfo.creativeViewTrack)
			{
				var beacon : Beacon = new Beacon (_companionInfo.creativeViewTrack, new HTTPLoader() );
				beacon.ping();
			}
		}
		
		public function removeListeners () : void
		{
			this.removeEventListener(MouseEvent.CLICK, onCompanionClick );
		}
		
		public function resizeContainer () : void
		{
			_backGround.width = parent.width;
			_backGround.height = parent.height;
		}
		
		public function positionCompanionAd () : void
		{
			for (var i:int = 0; i<numChildren; i++ )
			{
				if( this.getChildAt(i) is Loader)
				{
					this.getChildAt(i).x = this.width/2 - this.getChildAt(i).width/2;
					this.getChildAt(i).y = this.height/2 - this.getChildAt(i).height/2;
				}
			}
		}
		
	}
}