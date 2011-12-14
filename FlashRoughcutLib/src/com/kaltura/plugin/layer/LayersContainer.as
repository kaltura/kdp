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
	import mx.core.UIComponent;
	//xxx import mx.core.ScrollPolicy;
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	public class LayersContainer extends DisposableBase
	{
		private var currentLayer:VSPair, nextLayer:VSPair;
		private var _layers:Array;
		private var CurrentIdx:int = 1;

		//for invalidation
		private var _nWidth:Number;
		private var _nHeight:Number;
		private var _nX:Number;
		private var _nY:Number;

		public function LayersContainer(containerWidth:Number, containerHeight:Number):void
		{
			currentLayer = new VSPair (containerWidth, containerHeight);
			nextLayer = new VSPair (containerWidth, containerHeight);
			_layers = [nextLayer, currentLayer];
			addChildSafely( _layers[1 - CurrentIdx] );
			addChildSafely( _layers[CurrentIdx] );
		}

		public function get current():VSPair
		{
			return _layers[ CurrentIdx ];
		}
		public function get next():VSPair
		{
			return _layers[ 1 - CurrentIdx ];
		}
		/**
		 * Removes all DisplayObject instances stored in the disposableObjects Dictionary object.
		 * After all redundant childs are removed, this LayerContainer's properties are being reset as well as the "next" and "current" Layer instances.
		 *
		 */
		public override function resetProperties():void
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				if (child is Layer){
					(child as Layer).resetProperties();
				}
			}
			super.resetProperties();
		}

		/**
		 * Reset the layers index order
		 *
		 */
		public function resetLayers ():void
		{
			CurrentIdx = 1;
			setChildIndex (_layers[CurrentIdx], 1);
			setChildIndex (_layers[1 - CurrentIdx], 0);
			if (current.stream != null)
				current.stream.pauseMedia();
			if (next.stream != null)
				next.stream.pauseMedia();
		}


		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			super.swapChildren (child1, child2);
		}

		override public function swapChildrenAt(index1:int, index2:int):void
		{
			super.swapChildrenAt(index1, index2);
		}

		override public function setChildIndex(child:DisplayObject, newIndex:int):void
		{
			super.setChildIndex(child, newIndex);
		}

		public function switchChildren ():void
		{
			CurrentIdx = 1 - CurrentIdx;
			setChildIndex (_layers[CurrentIdx], 1);
			setChildIndex (_layers[1 - CurrentIdx], 0);
		}
		public function clearVideo ():void
		{
			(_layers[CurrentIdx] as VSPair).clearVideo();
			(_layers[1 - CurrentIdx] as VSPair).clearVideo();
		}
	}
}