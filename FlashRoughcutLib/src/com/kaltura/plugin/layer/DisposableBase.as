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
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.core.UIComponent;

	public class DisposableBase extends UIComponent
	{
		/**
		* Contains all DisplayObject instances which can be removed from the display list when resetting it
		*/		
		private var _dctDisposableChildren:Dictionary = new Dictionary(true);
		protected var _resetter:Resetter;
		
		public function DisposableBase():void
		{
			_resetter = new Resetter(this);
		}
		/**
		 * An extended DisplayObjectContainer.addChild() that takes extra optional parameter "disposable" which indicates if the added
		 * DisplayObject
		 * @param child
		 * @param disposable
		 * @return 
		 * 
		 */		
		public override function addChild(child:DisplayObject):DisplayObject
		{
			addToDisposables(child);
			return super.addChild(child);
		}
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			addToDisposables(child)
			return super.addChildAt(child, index);
		}
		/**
		 * returns a Dictionary object that contains all DisplayObject instances which can be removed from the display list when resetting it
		 * 
		 */
		public function get disposableObjects():Dictionary
		{
			return _dctDisposableChildren;
		}
		
		public function addChildSafely(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		public function addChildAtSafely(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child, index);
		}
		public function resetProperties():void
		{
			_resetter.reset();
		}
		public function cleanDisplayList():void
		{
			DisplayCleaner.cleanDisplayList(this);
		}
		
		public function updateDisposableList(evtRemoved:Event):void
		{
			var removedChild:DisplayObject = DisplayObject(evtRemoved.target);
			delete _dctDisposableChildren[removedChild];
		}
		private function addToDisposables(child:DisplayObject):void
		{
			_dctDisposableChildren[child] = child;
			child.addEventListener(Event.REMOVED, updateDisposableList, false, 0, true);
		}

		
	}
}