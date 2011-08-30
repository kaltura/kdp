package com.kaltura.kdpfl.plugin.component {
	//import com.kaltura.kdpfl.component.IComponent;

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;

	/**
	 * view component for Gigya plugin, 
	 * holds the swf that is loaded from Gigya. 
	 */	
	public dynamic class Gigya extends Sprite //implements IComponent
	{
		private var _loaded:Boolean = false;
		private var _mcWF:MovieClip = new MovieClip();
		private var _ldr:Loader = new Loader();
		private var _gigyaClip:MovieClip;


		public function Gigya() {
			addChild(_mcWF).name = 'mcWF';
			_mcWF.x = 0;
			_mcWF.y = 0;
		}


//		public function initialize():void {
//			addEventListener(Event.RESIZE, onResize);
//		}


//		public function setSkin(skinName:String, setSkinSize:Boolean = false):void {
//			
//		}


		/**
		 * hides Gigya UI 
		 */		
		public function hideGigya():void {
			_mcWF.visible = false;
		}


		/**
		 * Shows Gigya UI 
		 */		
		public function showGigya():void {
			_mcWF.visible = true;
		}


		
		/**
		 * Load Gigya's swf
		 * @param cfg	configuration data
		 * @param ModuleID	module id
		 */
		public function loadGigya(cfg:Object, ModuleID:String):void {
			Security.allowDomain("cdn.gigya.com");
			Security.allowInsecureDomain("cdn.gigya.com");

			if (!_loaded) {

				var url:String = 'http://cdn.gigya.com/Wildfire/swf/WildfireInAS3.swf?ModuleID=' + ModuleID;
				var urlReq:URLRequest = new URLRequest(url);

				_mcWF[ModuleID] = cfg;
				_ldr.load(urlReq);
				_mcWF.addChild(_ldr);
				_loaded = true;
			}
			else {
				_mcWF[ModuleID] = cfg;
				_gigyaClip = _ldr.content as MovieClip;
				_gigyaClip.INIT();
//	         _mcWF.width = 1;
//	         _mcWF.height= 1;
			}

			_mcWF.visible = true;
		}
	}
}