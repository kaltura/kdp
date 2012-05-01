/*
This file is part of the Kaltura Collaborative Media Suite which allows users 
to do with audio, video, and animation what Wiki platfroms allow them to do with 
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.plugin.layer
{
	import com.kaltura.plugin.utils.DisplayCleaner;
	
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;

	public class AxedUIComponent extends UIComponent
	{
		private var _nRatioAxisX:Number = 0;
		private var _nAbsAxisX:Number = 0;
		private var _nRatioAxisY:Number = 0;
		private var _nAbsAxisY:Number = 0;
				
		private var _child:DisplayObject;
		private var _rotation:Number;
		private var _nWidth:Number = 0;
		private var _nHeight:Number = 0;
		private var _nX:Number;
		private var _nY:Number;
		public function set child(child:DisplayObject):void
		{
			DisplayCleaner.cleanDisplayList(this);	

			_child = child;
			this.width = _child.width;
			this.height = _child.height;
			addChild(_child);
		}
		public function get child():DisplayObject
		{
			return _child;
		}
		public function setAxes(axisX:Number, axisY:Number):void
		{
			_nRatioAxisX = axisX;
			_nAbsAxisX = _child.width * _nRatioAxisX;
			_nRatioAxisY = axisY;
			_nAbsAxisY = _child.height * _nRatioAxisY;
			updateToXAxis();
			updateToYAxis();
		}
		
		/**
		 * Updates the child position according to the x axis
		 * 
		 */
		public function updateToXAxis():void
		{
			_nAbsAxisX = _nRatioAxisX * _child.width;
			_child.x = - _nAbsAxisX;
			this.x = _nX;
		}
		/**
		 * Updates the child position according to the y axis
		 * 
		 */
		public function updateToYAxis():void
		{
			_nAbsAxisY = _nRatioAxisY * _child.height;
			_child.y = - _nAbsAxisY;
			this.y = _nY;
			
		}

		public override function set width(value:Number):void
		{
			_nWidth = value;
			//super.width = value;
			//super.scaleX = super.scaleX * (_nWidth / super.width);
			updateToXAxis();
		}
		public override function get width():Number
		{
			return _nWidth;
		}
		
		public override function set height(value:Number):void
		{
			_nHeight = value;
			//super.height = value;
			//super.scaleY = super.scaleY * (_nHeight / super.height);
			updateToYAxis();
		}
		public override function get height():Number
		{
			return _nHeight;
		}
		public override function set scaleX(value:Number):void
		{
			super.scaleX = value;
			updateToXAxis();
		}
		public override function set scaleY(value:Number):void
		{
			super.scaleY = value;
			updateToYAxis();
			
		}
		public override function set x(value:Number):void 
		{
			_nX = value
			super.x =  value + _nWidth*_nRatioAxisX;
		}
		public override function get x():Number
		{
			return _nX;
		} 
		public override function set y(value:Number):void 
		{
			_nY = value;
			super.y = value +  _nHeight*_nRatioAxisY;
		} 
		public override function get y():Number
		{
			return _nY;
		}
	}
}