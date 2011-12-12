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
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	public class Resetter
	{
		private var _disposableObject:DisposableBase;
		public function Resetter(disposableObject:DisposableBase):void
		{
			_disposableObject = disposableObject;

		}
		public function reset():void
		{
			_disposableObject.scaleX = 1;
			_disposableObject.scaleY = 1;
			_disposableObject.x = 0;
			_disposableObject.y = 0;
			_disposableObject.rotation = 0;
			if (_disposableObject.alpha != 1)
				_disposableObject.alpha = 1;
			//xxx _disposableObject.setVisible(true, true);
			_disposableObject.visible = true;//xxx
			_disposableObject.blendMode = BlendMode.NORMAL;
			_disposableObject.mask = null;
			_disposableObject.filters = null;
			removeDisposableChildren ();
		//	_disposableObject.invalidateDisplayList();
		}
		
		/**
		 * Removes all DisplayObject instances from the layer display list
		 * @param container
		 * 
		 */		
		public function removeDisposableChildren():void 
		{
			var disposeList:Dictionary = _disposableObject.disposableObjects;
			for each (var child:DisplayObject in disposeList) 
			{
				_disposableObject.removeChild(child);
				delete disposeList[child];
			}
		}
	}
}