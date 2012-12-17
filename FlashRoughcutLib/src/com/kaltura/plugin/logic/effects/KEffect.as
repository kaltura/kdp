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
package com.kaltura.plugin.logic.effects
{
	import com.kaltura.plugin.logic.Plugin;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import mx.utils.ArrayUtil;

	public class KEffect extends Plugin
	{
		protected var _playerDisplay:DisplayObject;

		public static const REFLECTION:String = "KEFFECT";

		public function KEffect (url:String = ""):void
		{
			super (url);
		}

		override public function get reflection ():String
		{
			return KEffect.REFLECTION;
		}

		public function addFilter (filter:Object):void
		{
			var filtersArr:Array = _playerDisplay.filters;
			if (!filtersArr)
				filtersArr = [];
			filtersArr.push(filter);
			_playerDisplay.filters = filtersArr;
		}

		public function removeFilter (filter:Object):void
		{
			var filtersArr:Array = _playerDisplay.filters;
			var idx:int = ArrayUtil.getItemIndex(filter, filtersArr);
			if (idx > -1)
				filtersArr.splice(idx, 1);
			_playerDisplay.filters = filtersArr;
		}

		private var children:Array = [];
		public function addChildSaftley (child:DisplayObject):void
		{
			children.push(child);
			(_playerDisplay as DisplayObjectContainer).addChild(child);
		}
		public function removeChildrenSaftley (child:DisplayObject):void
		{
			while (children.length > 0)
			{
				(_playerDisplay as DisplayObjectContainer).removeChild(children.pop());
			}
		}

		public override function setTargets(layers:DisplayObject):void
		{
			//todo: the layers can be changed during run time, so the current becomes next and so forth
			//this should be handled to enable lasting effect
			_playerDisplay = layers;
			super.setTargets(layers);
		}
	}
}