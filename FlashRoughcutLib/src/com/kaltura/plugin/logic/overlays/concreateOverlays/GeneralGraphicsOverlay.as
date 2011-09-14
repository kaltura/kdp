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
package com.kaltura.plugin.logic.overlays.concreateOverlays
{
	import com.kaltura.plugin.logic.overlays.Overlay;
	
	import flash.display.DisplayObject;
	
	public class GeneralGraphicsOverlay extends Overlay
	{
		public function GeneralGraphicsOverlay (url:String):void
		{
			super (url);
		}
		
		public override function pluginAdded():void
		{
			super.pluginAdded();
			addOverlayGraphics();
			//addListeners();
		}
		
		protected function addOverlayGraphics():void
		{
			var overlayGraphics:DisplayObject = getOverlayGraphics();
			_overlay.addChild(overlayGraphics);
		}
		
		protected function getOverlayGraphics():DisplayObject
		{
			throw new Error("getOverlayDisplayObject() is an abstract method");
			return null;
		}
		
		/* protected function addListeners():void
		{
			for each (var property:Property in _Properties)
			{
				if (property.id in childSwf)
				{
					property.addEventListener(Event.CHANGE, updateChildSwf);
				}
			}
		}
		protected function updateChildSwf(evtChange:Event):void
		{
			var property:Property = evtChange.target as Property;
			var sPropertyID:String = property.id;
			var sPropertyValue:* = property.value;
			ch
		} */
		
	}
}