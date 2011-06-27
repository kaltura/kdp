/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.mediaPlayerClasses
{
	import com.yahoo.astra.fl.events.MediaEvent;
	
	import fl.core.UIComponent;
	import fl.managers.IFocusManagerComponent;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
    //--------------------------------------
    //  Class Description
    //--------------------------------------	
    
    /**
     * MediaInfoView extends MediaView.  Creates a text ticker displaying the artist and title of the media clip.
	 *
     * @see com.yahoo.astra.fl.controls.mediaPlayerClasses.MediaView
     * @see com.yahoo.astra.fl.controls.mediaPlayerClasses.IMediaView
	 *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     * @author Dwight Bridges	 
	 */
	public class MediaInfoView extends MediaView implements IFocusManagerComponent
	{

    //--------------------------------------
    //  Constructor
    //--------------------------------------	

		/**
		 * Constructor
		 * @param container
		 * @param model
		 * @param controller
		 *
		 * Sets the model and controller for the MediaInfoView
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0 
		 */
		public function MediaInfoView(container:DisplayObjectContainer = null, model:IMediaClip = null, controller:IMediaController = null)
		{
			super(container, model, controller);
			_background = getDisplayObjectInstance(getStyleValue("background")) as Sprite;
			if(_background != null)
			{
				addChild(_background);
				_background.width = width;
				_background.height = height;				
			}		
			_textHolder = new Sprite();
			_textHolder.cacheAsBitmap = true;
			addChild(_textHolder);
			_mask = getDisplayObjectInstance(getStyleValue("mask")) as Sprite;
			_mask.cacheAsBitmap = true;
			_mask.width = width;
			_mask.height = height;
			addChild(_mask);
			_textHolder.mask = _mask;
			_timer = new Timer(50);
			_timer.addEventListener(TimerEvent.TIMER, positionUpdateHandler);		
		}
		
	//--------------------------------------------------------------------------
	//
	//  Class mixins
	//
	//--------------------------------------------------------------------------
	
	/**
	* Placeholder for mixin by MediaInfoViewAccImpl.
	*/
	public static var createAccessibilityImplementation:Function;	

 		
    //--------------------------------------
    //  Properties
    //--------------------------------------			
		/**
		 * @private (protected)
		 */
		protected var _artist:String;
		
		/**
		 * @private (protected)
		 */
		protected var _title:String;
		
		/**
		 * The string to display in the scrolling text field
		 */
		public var text:String = "";
		
		/**
		 * @private (protected)
		 */
		protected var _data:Array
		
		/**
		 * @private (protected)
		 */
		protected var _timer:Timer;
		
		/**
		 * @private (protected)
		 */
		protected var _textHolder:Sprite;
		
		/**
		 * @private (protected)
		 */
		protected var _mask:Sprite;
		
		/**
		 * @private (protected)
		 */
		protected var _points:Array;
		
		/**
		 * @private
		 *
		 * default styles for the MediaInfoView
		 */
		private static var defaultStyles:Object = 
		{
			background:"InfoView_backgroundSkin",
			mask:"InfoView_mask",
			textFormat:new TextFormat("_sans", 9, 0xeeeeee)
		}
		
		/**
		 * @private (protected)
		 */
		protected var _background:Sprite;
		
		/**
		 * @private (override))
		 */
		override public function set width(value:Number):void
		{
			var tempWidth:Number = width;
			super.width  = value;
			_width = value;
			if(_mask != null)
			{
				_mask.width = value;
				_background.width = value;
				if(_data != null && _data.length > 0) _data[0].x = (width/tempWidth) * _data[0].x;
			}
		}

		/**
		 * @private (override)
		 */
		override public function set height(value:Number):void
		{
			var tempHeight:Number = height;
			super.height = value;
			_height = value;
			if(_mask != null)
			{
				_mask.height = value;
				_background.height = value;
				_mask.x = _background.x = 0;
				if(_data != null && _data.length > 0) _data[0].y = (height/tempHeight) * _data[0].y;
			}
		}
				
    //--------------------------------------
    //  Public Methods
    //--------------------------------------			
				
		/**
		 * getStyleDefinition - returns defaultStyles
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0 
		 */
		public static function getStyleDefinition():Object
		{
			return mergeStyles(defaultStyles, UIComponent.getStyleDefinition());
		}			
		
    //--------------------------------------
    //  Protected Methods
    //--------------------------------------		
		
		/**
		 * @private (protected)
		 * attaches event listeners to the _model
		 * <p>called after the _model is set</p>
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override protected function addListeners():void
		{
			_model.addEventListener(MediaEvent.INFO_CHANGE, mediaInfoChangeHandler);
		}
		
		/**
		 * @private 
		 * mediaInfoChangeHandler
		 * <p>fired by the MediaEvent.INFO_CHANGE</p>
		 * <p>checks the _artist and _title against the _model's<p>
		 * <p>if different, remove any existing text fields, reset properties and start the timer</p>
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		private function mediaInfoChangeHandler(event:MediaEvent):void
		{
			if(_model.artist != _artist || _model.title != _title) 
			{
				_artist = _model.artist;
				_title = _model.title;
				if(_data != null)
				{
					
					var len:int = _data.length;
					for(var i:int = len-1;i > -1; i--)
					{
						_textHolder.removeChild(_data[i]);
						_data.pop();
					}	
				}
				_data = [];
				_points = [];
				text = _artist + " - " + _title;
				_data[_data.length] = getTextField(text);
				_timer.stop();
				_timer.start();
			}
		}
		
		/**
		 * @private (protected)
		 * adds a text field to the _textHolder
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function getTextField(value:String):TextField
		{
			var tf:TextFormat = new TextFormat();
			tf.color = 0xeeeeee;
			tf.font = "_sans";
			tf.size = 9;
			var textField:TextField = new TextField();
			textField.multiline = false;
			textField.wordWrap = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.text = value;
			textField.setTextFormat(tf);
			var textX:Number = _textHolder.width;
			_textHolder.addChild(textField);
			textField.x = textX;
			return textField;
		}
		
		/**
		 * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function positionUpdateHandler(event:TimerEvent):void
		{
			for(var i:int = 0; i < _data.length; i++)
			{
				_points[i] = globalToLocal(_textHolder.localToGlobal(new Point(_data[i].x + _data[i].textWidth, _data[i].y))).x;

				if(_points[i] < 0)
				{
					_data[i].x = _textHolder.globalToLocal(localToGlobal(new Point(width, 0))).x;
				}
				else
				{
					_data[i].x--;
				}
			}
		}
		
		/**
	     *  @inheritDoc
	     */
	    override protected function initializeAccessibility():void
	    {
			if (MediaInfoView.createAccessibilityImplementation != null)
	            MediaInfoView.createAccessibilityImplementation(this);
	    }	
	}
}