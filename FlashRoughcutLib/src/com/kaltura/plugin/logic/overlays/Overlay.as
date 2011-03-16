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
package com.kaltura.plugin.logic.overlays
{
	import com.kaltura.plugin.layer.Layer;
	import com.kaltura.plugin.layer.LayersContainer;
	import com.kaltura.plugin.logic.Plugin;
	
	import flash.display.DisplayObject;
	/**
	 * Overlay class is a base class for all concrete overlays.
	 * overlay is used to draw graphics on top of the current layer (_overlay)
	 * 
	 */
	public class Overlay extends Plugin
	{
		private var _layersContainer:LayersContainer;
		protected var _overlay:Layer = new Layer();
		
		public static const REFLECTION:String = "OVERLAY";
		
		override public function get reflection ():String 
		{
			return Overlay.REFLECTION;
		}
		
		public function Overlay(url:String = ""):void
		{
			super(url);
			//_overlay = new Layer();
		}
		
		public override function setTargets(layersContainer:DisplayObject):void
		{
			
		 	_overlay.width = layersContainer.width;
			_overlay.height = layersContainer.height;
			_layersContainer = layersContainer as LayersContainer;
			super.setTargets(layersContainer);
		}
		public override function pluginAdded():void
		{
			//_overlay.resetProperties();
			_overlay.resetProperties();
			//_overlay = new Layer();
			//_overlay.width = _layersContainer.width;
			//_overlay.height = _layersContainer.height;
			_layersContainer.addChild(_overlay);

		}
/* 		public override function apply(seekRatio:Number):void
		{

		} */
		public override function detach(nScreenWidth:Number, nScreenHeight:Number, nX:Number, nY:Number):void
		{
			if (_layersContainer != null && _layersContainer.contains(_overlay))
				_layersContainer.removeChild(_overlay);
			//_layersContainer.removeChild(_overlay);
		}
	}
}