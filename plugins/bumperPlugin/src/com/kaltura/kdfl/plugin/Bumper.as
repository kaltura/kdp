package com.kaltura.kdfl.plugin {
	import com.kaltura.kdfl.plugin.events.BumperEvent;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * Bumper Plugin's view component, holds the blocker that collects screen clicks. 
	 */	
	public class Bumper extends Sprite {

		public static const NAVIGATE:String = "b_navigate";
		public static const PRE:String = "b_pre";
		public static const POST:String = "b_post";

		/**
		 * bumper configuration
		 */
		private var _config:Object;
		private var _enabled:Boolean = false;
		private var _trackClicks:Boolean;
		private var _blocker:Sprite;

		
		/**
		 * Constructor. 
		 * @param cfg	configuration object
		 */
		public function Bumper(cfg:Object) {
			super();
			_config = cfg;
		}


		/**
		 * redraw blocker in required size.
		 */
		public function redraw():void {
			if (_blocker != null) {
				var g:Graphics = _blocker.graphics;
				g.clear();
				g.beginFill(0x000000, 0);
				g.drawRect(0, 0, _config.width, _config.height);
				g.endFill();
			}
		}


		/**
		 * creates the sprite which catches mouse clicks
		 * and places it over the player
		 */
		private function createBlocker():void {
			_blocker = new Sprite();
			redraw();
			_blocker.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}


		/**
		 * sends the clik with the clickurl or opens the clickurl, or something
		 * @param e	MouseEvent
		 */
		private function onClick(e:MouseEvent):void {
			dispatchEvent(new BumperEvent(Bumper.NAVIGATE, _config.clickurl));
		}



		/**
		 * id of bumper media
		 */
		public function get bumperEntryID():String {
			return _config.bumperEntryID;
		}




		/**
		 * starts or stops tracking clicks on the player area
		 */
		public function get trackClicks():Boolean {
			return _trackClicks;
		}


		/**
		 * @private
		 */
		public function set trackClicks(value:Boolean):void {
			_trackClicks = value;
			if (value) {
				if (_blocker == null) {
					createBlocker();
				}
				addChild(_blocker);
			}
			else {
				removeChild(_blocker);
			}
		}

		/**
		 * @inheritDoc 
		 */		
		public function get enabled():Boolean
		{
			return _enabled;
		}

		/**
		 * @private
		 */
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}


	}
}