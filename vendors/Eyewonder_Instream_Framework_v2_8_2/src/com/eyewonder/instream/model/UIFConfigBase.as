/*
UIFConfigBase.as

Universal Instream Framework
Copyright (c) 2006-2009, Eyewonder, Inc
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
 * Neither the name of Eyewonder, Inc nor the
 names of contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY Eyewonder, Inc ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL Eyewonder, Inc BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

This file should be accompanied with supporting documentation and source code.
If you believe you are missing files or information, please 
contact Eyewonder, Inc (http://www.eyewonder.com)



Description
-----------
Don't modify the config here, instead set variables in UIFConfig.as

*/

package com.eyewonder.instream.model {
	import flash.display.MovieClip;
	import flash.text.TextFormat;
	
	public dynamic class UIFConfigBase extends Object {
		
		// clip parameters, used by InstreamFramework:getPlayerInformation()
		private var _width:Number = 320;					// content width
		private var _height:Number = 240;					// content height
		
		private var _x:Number = 0;							// x position of the content
		private var _y:Number = 0;							// y position of the content
		
		private var _clip:MovieClip;						// player clip reference
		
		// player values
		//private var _volume:Number = -1;					// the players volume
		
		// ad specific settings
		private var _overlay_delay:Number = 5;				// delay overlay this ammount of seconds
		private var _midroll_video_length:Number = 100;		// video length has to be greater then that to allow a midroll playback
		
		// countdown timer
		private var _countdown_enabled:Boolean = false;		
		private var _countdown_text:String = '[time] ([percent])';
		private var _countdown_text_format:TextFormat = new TextFormat( "Arial", 10, 0xffffff, null, null, null, null, null, "center" );
		private var _countdown_text_color:Number = 0xffffff;
		private var _countdown_bar_position:String = "bottom";
		private var _countdown_bar_back_color:Number = 0x000000;
		private var _countdown_bar_opacity:Number = 0.8;
		
		// ad background
		private var _backgroundColor:Number = 0x000000;
		private var _backgroundAlpha:Number = 1;
		
		// vast specific
		private var _preferredDeliveryMethod:String = "progressive";
		private var _qualityFirst:Boolean = true;
		private var _bwDetectProgressiveURL:String = "";	// This file should be at least a few hundred KB on a fast, trusted, distributed CDN
		private var _bwDetectStreamingServer:String = null;
		
		//Scaling
		private var _scaleEW:Boolean = true;
		private var _scaleVAST:Boolean = true;
		private var _positionVAST:Boolean = true;
		
		public function UIFConfigBase() { super(); }
		
		/**
		 * content width
		 */
		public function get width():Number { return _width; }
		public function set width(value:Number):void {
			_width = value;
		}
		
		/**
		 * content height
		 */
		public function get height():Number { return _height; }
		public function set height(value:Number):void {
			_height = value;
		}
		
		/**
		 * x position of the content
		 */
		public function get x():Number { return _x; }
		public function set x(value:Number):void {
			_x = value;
		}
		
		/**
		 * y position of the content
		 */
		public function get y():Number { return _y; }
		public function set y(value:Number):void {
			_y = value;
		}
		
		/**
		 * delay overlay this ammount of seconds
		 */
		public function get overlay_delay():Number { return _overlay_delay; }
		public function set overlay_delay(value:Number):void {
			_overlay_delay = value;
		}
		
		/**
		 * video length has to be greater then that to allow a midroll playback
		 */
		public function get midroll_video_length():Number { return _midroll_video_length; }
		public function set midroll_video_length(value:Number):void {
			_midroll_video_length = value;
		}
		
		/**
		 * player clip reference
		 */
		public function get clip():MovieClip { return _clip; }
		public function set clip(value:MovieClip):void {
			_clip = value;
			
			height = clip.height;
			width = clip.width;
			x = clip.x;
			y = clip.y;
		}
		
		/**
		 * text shown in the countdown bar
		 */
		public function get countdown_text():String { return _countdown_text; }
		public function set countdown_text(value:String):void {
			_countdown_text = value;
		}
		
		/**
		 * where the countdown bar is positioned. either "top" or "bottom"
		 */
		public function get countdown_bar_position():String { return _countdown_bar_position; }
		public function set countdown_bar_position(value:String):void {
			_countdown_bar_position = value;
		}
		
		/**
		 * enable the countdown bar
		 */
		public function get countdown_enabled():Boolean { return _countdown_enabled; }
		public function set countdown_enabled(value:Boolean):void {
			_countdown_enabled = value;
		}
		
		/**
		 * background color of the countdown bar
		 */
		public function get countdown_bar_back_color():Number { return _countdown_bar_back_color; }
		public function set countdown_bar_back_color(value:Number):void {
			_countdown_bar_back_color = value;
		}
		
		/**
		 * transparency of the reamining timer bar
		 */
		public function get countdown_bar_opacity():Number { return _countdown_bar_opacity; }
		public function set countdown_bar_opacity(value:Number):void {
			_countdown_bar_opacity = value;
		}
		
		/**
		 * text format used on the timer bar
		 */
		public function get countdown_text_format():TextFormat { return _countdown_text_format; }
		public function set countdown_text_format(value:TextFormat):void {
			_countdown_text_format = value;
		}
				
		/**
		 * text color used for the text on the countdown bar
		 */
		public function get countdown_text_color():Number { return _countdown_text_color; }
		public function set countdown_text_color(value:Number):void {
			_countdown_text_color = value;
		}
		
		/**
		 * ad backdrop color
		 */
		public function get backgroundColor():Number { return _backgroundColor; }
		public function set backgroundColor(value:Number):void {
			_backgroundColor = value;
		}
		
		/**
		 * ad backdrop alpha
		 */
		public function get backgroundAlpha():Number { return _backgroundAlpha; }
		public function set backgroundAlpha(value:Number):void {
			_backgroundAlpha = value;
		}
		
		/**
		 * ad delivery mode if available
		 * either 'progressive' or 'streaming'
		 */
		public function get preferredDeliveryMethod():String { return _preferredDeliveryMethod; }
		public function set preferredDeliveryMethod(value:String):void {
			_preferredDeliveryMethod = value;
		}
		
		/**
		 * quality before speed
		 */
		public function get qualityFirst():Boolean { return _qualityFirst; }
		public function set qualityFirst(value:Boolean):void {
			_qualityFirst = value;
		}
		
		/**
		 * This file should be at least a few hundred KB on a fast, trusted, distributed CDN
		 */
		public function get bwDetectProgressiveURL():String { return _bwDetectProgressiveURL; }
		public function set bwDetectProgressiveURL(value:String):void {
			_bwDetectProgressiveURL = value;
		}
		
		/**
		 * 
		 */
		public function get bwDetectStreamingServer():String { return _bwDetectStreamingServer; }
		public function set bwDetectStreamingServer(value:String):void {
			_bwDetectStreamingServer = value;
		}
		
		/**
		 * Allow up and down scaling of ads
		 */
		public function get scaleEW():Boolean { return _scaleEW; }
		public function set scaleEW(value:Boolean):void {
			_scaleEW = value;
		}
		
		/** 
		 * Allow up and down scaling of VAST ads
		 */
		public function get scaleVAST():Boolean { return _scaleVAST; }
		public function set scaleVAST(value:Boolean):void {
			_scaleVAST = value;
		}
		
		/**
		 * Allow up and down scaling of VAST ads
		 */
		public function get positionVAST():Boolean { return _positionVAST; }
		public function set positionVAST(value:Boolean):void {
			_positionVAST = value;
		}
		
		/**
		 * the player volume
		 */
		//public function get volume():Number { return _volume; }
		//public function set volume(value:Number):void {
			//_volume = value;
		//}
		
	}

}