/*
AdCountdown.as

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



*/
package com.eyewonder.instream.modules 
{
	import com.eyewonder.instream.base.InstreamFrameworkBase;
	import com.eyewonder.instream.debugger.*;
	import com.eyewonder.instream.events.*;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public dynamic class AdCountdown extends MovieClip
	{
		public var _min_width:Number = 320;
		public var _min_height:Number = 240;
		public var _min_font_size:Number = 9;
		
		public var adCountdownBackground_mc:MovieClip;
		public var adCountdownTextField:TextField;
		public var adCountdown_scale:Number = 1;
		
		public var replaceStrings:Array;
		public var time:String = "--";
		public var percent:String = "0%";
		
		public var config:Object;		
		
		public function AdCountdown( _config:Object ) 
		{
			replaceStrings = new Array("\\[time\\]", "\\[percent\\]");
			config = _config;
		}
		
		public function resize( info:Object ) : void {
			if ( config.countdown_enabled == false ) return;
			// scale-factor
			adCountdown_scale = Math.round(info.videoRect.height / _min_height);
			if ( info.videoRect.width < _min_width ) {
				adCountdown_scale = Math.round(info.videoRect.width / _min_width);
			}

			UIFDebugMessage.getInstance()._debugMessage(3, "In AdCountdown:resize() - scale:" + adCountdown_scale, "Instream", "");
			
			// textfield
			adCountdownTextField.width = info.videoRect.width;
			
			var text_size:Number = (Number(config.countdown_text_format.size) * (adCountdown_scale)) / 2;
			if ( text_size < _min_font_size ) text_size = _min_font_size;
			
			var fmt:TextFormat = adCountdownTextField.getTextFormat();
			fmt.size = text_size;
			fmt.align = "center";
			fmt.color = config.countdown_text_color;
			
			adCountdownTextField.defaultTextFormat = fmt;
			adCountdownTextField.text = updateTextField(config.countdown_text);
			
			if (adCountdownTextField.textWidth > adCountdownTextField.width) {
				UIFDebugMessage.getInstance()._debugMessage(2, "Textwidth is larger than available player-width. AdCountdown disabled.", "Instream", "");
				clear();
				return;
			}
			
			// background
			adCountdownBackground_mc.width = info.videoRect.width;
			adCountdownBackground_mc.height = adCountdownTextField.textHeight + 6;			
			if ( config.countdown_bar_position == "bottom" ) {
				y = info.videoRect.height - (adCountdownTextField.textHeight + 6);
			} else if ( config.countdown_bar_position == "top" ) {
				y = 0;
			}
		}

		public function draw( info:Object ) : void {
			if ( config.countdown_enabled == false ) return;

			createTextField( info.videoRect.width );
			
			adCountdownBackground_mc = new MovieClip();
			with ( adCountdownBackground_mc.graphics ) {
				clear();
				beginFill( config.countdown_bar_back_color, config.countdown_bar_opacity );
				drawRect( 0, 0, info.videoRect.width, adCountdownTextField.textHeight + 6 );
				endFill();
			}
			addChild( adCountdownBackground_mc );
			
			adCountdownBackground_mc.mouseEnabled = false;
			adCountdownBackground_mc.enabled = false;
			adCountdownBackground_mc.mouseChildren = false;
			
			addChild(adCountdownTextField);
			
			resize( info );

			return;
		}
		
		public function createTextField( width:Number ) : void {

			adCountdownTextField = new TextField();
			adCountdownTextField.x = 0;
			adCountdownTextField.y = 0;
			adCountdownTextField.multiline = false;

			adCountdownTextField.width = width;
			
			adCountdownTextField.defaultTextFormat = config.countdown_text_format;
			adCountdownTextField.selectable = false;
			adCountdownTextField.text = updateTextField(config.countdown_text);			
		}
		
		public function updateRemainingTimeDisplay( info:Object ):void { 
			if ( config.countdown_enabled == false ) return;
			
			adCountdownTextField.text = updateTextField(config.countdown_text, info); 
		} 

		public function updateTextField( input:String, info:Object = null ) : String {
			
			if ( info != null ) {
				var t:Number = Math.round( info['adRemainingTime'] );

				var min:Number = Math.floor(t / 60);
				var sec:Number = Math.floor(t % 60);

				if ( min > 0 ) {
					time = (min < 10?'0' + min:min) + ':' + (sec < 10?'0' + sec:sec);
				} else {
					time = (sec < 10?'0' + sec:sec.toString());
				}

				var pct:Number = Math.round( 100 - (info['adRemainingTime'] / info['adTotalTime'] * 100) );
				if ( pct > 100 ) pct = 100;		// sometimes goes to 101

				percent = pct + "%";
			}

			var replaceValues:Array = new Array( time, percent );

			for (var i = 0; i < replaceStrings.length; i++) {
				input = input.replace(new RegExp(replaceStrings[i], "gi"), replaceValues[i]);
			}

			return input;
		}
		
		public function clear() : void {
			try {
				adCountdownBackground_mc.graphics.clear();
				removeChild( adCountdownBackground_mc );
				removeChild( adCountdownTextField );
			} catch (e:Error) {
				UIFDebugMessage.getInstance()._debugMessage(2, "Clear AdCountdown failed.", "Instream", "");
			}
		}
		
	}

}