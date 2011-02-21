/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.mediaPlayerClasses
{
	import com.yahoo.astra.fl.events.MediaEvent;
	import flash.display.DisplayObjectContainer;
	import fl.core.UIComponent;
	import fl.controls.BaseButton;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;	
	import flash.events.ProgressEvent;

    //--------------------------------------
    //  Class Description
    //--------------------------------------	
    
	/**
	 * MediaView is an abstract class that extends UIComponent, implements
	 * the IMediaView interface and defines the functionality for a MediaView class.
	 * MediaView classes should extend the MediaView class.
	 */	
	
	public class MediaView extends UIComponent implements IMediaView
	{

    //--------------------------------------
    //  Constructor
    //--------------------------------------
    
		/**
		 * Constructor
		 * @param container display object container that the MediaView will be added to
		 * @param model media clip that the MediaView will observe
		 * @param controller media controller that will handle user input from the MediaView
		 */
		public function MediaView(container:DisplayObjectContainer = null, model:IMediaClip = null, controller:IMediaController = null)
		{
			super();
			if(container != null) container.addChild(this);
			if(model != null)
			{	
				_model = model;
				addListeners();
			}
			if(controller != null) _controller = controller;
		}
		
    //--------------------------------------
    //  Properties
    //--------------------------------------
    
		/**
		 * @private (protected)
		 * the media that is being controlled by the MediaScrubber
		 */
		protected var _model:IMediaClip;
		
		/**
		 * @private (protected)
		 * the controller for the Media
		 */
		protected var _controller:IMediaController;			
		
		/**
		 * Gets or sets the media clip 
		 */
		public function get model():IMediaClip
		{
			return _model;
		}
		
		/**
		 * @private (setter)
		 */
		public function set model(value:IMediaClip):void
		{
			if(_model != null) removeListeners();
			_model = value;
			addListeners();
		}				
		
		/**
		 * Gets or sets the media controller
		 */
		 public function get controller():IMediaController
		 {
			 return _controller;
		 }
		 
		/**
		 * @private (setter)
		 */
		public function set controller(value:IMediaController):void
		{
			_controller = value;
		}
		
		/**
		 * Gets the coordinate for the bottom edge of the component (read-only)
		 */
		public function get bottom():Number
		{
			return y + height;
		}
		
		/**
		 * Gets the coordinate for the right edge of the component (read-only)
		 */
		public function get right():Number
		{
			return x + width;
		}
		
    //--------------------------------------
    //  Protected Methods
    //--------------------------------------			
		
		/**
		 * @private (protected)
		 */
		protected function addListeners():void{}
		
		/**
		 * @private (protected)
		 */
		protected function removeListeners():void{}
		
		/**
		 * @private (protected)
		 */
		protected function setChildStyles(child:UIComponent,styleMap:Object):void 
		{
			//set styles from a specified object to the specified component
			for (var n:String in styleMap) 
			{
				child.setStyle(n, styleMap[n]);
			}
		}			
	}
}