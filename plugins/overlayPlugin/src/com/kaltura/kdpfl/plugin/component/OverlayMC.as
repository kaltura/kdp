package com.kaltura.kdpfl.plugin.component {
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;

	/**
	 * The view component for Overlay Plugin.
	 */
	public class OverlayMC extends MovieClip {
		
		/**
		 * The speed with which the overlay ad eneters the screen.
		 */		
		private var _moveSpeed:Number;
		/**
		 * The location of the x-button of the overlay ad.
		 */		
		private var _xLocation:Number;

		/**
		 * Constant representing the top-right corner of the overlay sprite.
		 */
		public static const TOP_RIGHT_CORNER:int = 1;
		
		/**
		 * Constant representing the top-left corner of the overlay sprite.
		 */
		public static const TOP_LEFT_CORNER:int = 2;


		/**
		 * Constructor.
		 * @param moveSpeed		duration of overlay show\hide effect
		 * @param xLocation		position of the x-button that closes the ad. 
		 */
		public function OverlayMC(moveSpeed:Number = 0.5, xLocation:Number = TOP_RIGHT_CORNER) {
			if (moveSpeed) {
				_moveSpeed = moveSpeed;
			}
			if (xLocation) {
				_xLocation = xLocation;
			}
		}


		/**
		 * shows the overlay ad
		 */
		public function raiseBanner():void {
			var myTween:Tween = new Tween(this, "y", Strong.easeIn, this.y, this.y - this.height, _moveSpeed, true);
		}


		/**
		 * hides the overlay ad
		 */
		public function lowerBanner():void {
			var myTween:Tween = new Tween(this, "y", Strong.easeOut, this.y, this.y + this.height, _moveSpeed, true);
		}


		/**
		 * position of the x-button which closes the ad.
		 */
		public function get xLocation():Number {
			return _xLocation;
		}


		/**
		 * puts a close-button on the ad
		 * @param xButton	button to add.
		 */
		public function addXButton(xButton:SimpleButton):void {
			this.addChild(xButton);
			switch (_xLocation) {
				case TOP_RIGHT_CORNER:
					xButton.x = this.width - xButton.width;
					break;

			}
		}

	}
}