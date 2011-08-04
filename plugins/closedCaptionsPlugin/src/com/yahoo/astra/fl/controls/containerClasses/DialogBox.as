/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.controls.containerClasses
{
	import flash.text.*;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import com.yahoo.astra.fl.controls.containerClasses.MessageBox;
	import fl.events.ComponentEvent;
	import com.yahoo.astra.fl.controls.containerClasses.TitleBar;
	import flash.display.Stage;
	import fl.core.UIComponent;
	import flash.utils.Dictionary;
	import flash.text.TextFieldAutoSize;
	import flash.filters.DropShadowFilter;
	import flash.events.KeyboardEvent;
	import flash.events.FocusEvent;
	import flash.ui.Keyboard;	
	import com.yahoo.astra.utils.InstanceFactory;
	import com.yahoo.astra.fl.utils.UIComponentUtil;
	import fl.core.InvalidationType;
	
	//--------------------------------------
	//  Styles
	//--------------------------------------
	
   /** 
    *  The skin to be used for the background of the TitleBar.
    *  
    *  @default Background_skin
    */  
   [Style(name="skin", type="Class", inherit="no")]  
   
	//--------------------------------------
	//  Class description
	//--------------------------------------

	/**
	 * DialogBox extends UIComponent and builds an AlertBox by assembling a TitleBar,
	 * MessageBox and ButtonBar
	 *
	 * @see fl.core.UIComponent
	 * @see com.yahoo.astra.fl.controls.containerClasses.TitleBar
	 * @see com.yahoo.astra.fl.controls.containerClasses.MessageBox
	 * @see com.yahoo.astra.fl.controls.containerClasses.ButtonBar
	 *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     * @author Dwight Bridges	
	 */		
	public class DialogBox extends UIComponent
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor
		 *
		 * @param container - DisplayObjectContainer to add the alert
		 */
		public function DialogBox(container:Stage) 
		{
			_stage = container;
			//set to enforce keyFocusChangeHandler, so that tabbing out does not change focus
			tabChildren = false;
			this.visible = false;
		}
		
	//--------------------------------------
	//  Constants
	//--------------------------------------		
	
		/**
		 * @private (protected)
		 */
		protected const TITLE:String = "title";

		/**
		 * @private (protected)
		 */		
		protected const BUTTONS:String = "buttons";
		
	//--------------------------------------
	//  Properties
	//--------------------------------------		
	
		/**
		 *  @private
		 *  Method for creating the Accessibility class.
		 *  This method is called from UIComponent.
		 */
		public static var createAccessibilityImplementation:Function;
	
		/**
		 * @private (protected) 
		 */
		//instance of the title bar 
		protected var _titleBar:TitleBar;
		
		public function get titleBar():TitleBar
		{
			return _titleBar;
		}
		
		public function setTitleBar(value:TitleBar):void
		{
			_titleBar = value;	
		}
		
		/**
		 * @private (protected) 
		 */		
		//Distance from the top of the component when the user presses his mouse on the 
		//title bar.  Used to calculate the drag.
		protected var _dragOffSetY:Number;

		/**
		 * @private (protected)		
		 */
		//Distance from the left of the component when the user presses his mouse on the 
		//title bar.  Used to calculate the drag.
		protected var _dragOffSetX:Number;

		/**
		 * @private (protected)
		 */
		//Reference to the ButtonBar class instance which manages the buttons
		protected var _buttonBar:ButtonBar;
		
		/**
		 * Manages the display of buttons
		 */
		public function get buttonBar():ButtonBar
		{
			return _buttonBar;
		}

		/**
		 * @private (protected) 
		 */
		protected var _minWidth:int;	
		
		/**
		 * Gets or sets the minimum width of the dialog box
		 */
		public function get minWidth():int
		{
			return _minWidth;
		}
		
		/**
		 * @private (setter)
		 */		
		public function set minWidth(value:int):void
		{
			_minWidth = value;
		}		

		/**
		 * @private (protected)
		 */
		protected var _maxWidth:int;
		
		/**
		 * Gets or sets the maximum width of the dialog box
		 */
		public function get maxWidth():int
		{
			return _maxWidth;
		}
		
		/**
		 * @private (setter)
		 */
		public function set maxWidth(value:int):void
		{
			_maxWidth = value;
			_buttonBar.maxWidth = _maxWidth - (_padding*2);
			_titleBar.maxWidth = _maxWidth;
		}		

		/**
		 * @private (protected)
		 */
		protected var _padding:int;
		
		/**
		 * Gets or sets the padding between components and edges
		 */
		public function get padding():int
		{
			return _padding;
		}
		
		/**
		 * @private (setter)
		 */		
		public function set padding(value:int):void
		{
			_padding = value;
			_buttonBar.maxWidth = _maxWidth - (_padding*2);
		}		

		/**
		 * @private (protected)
		 */
		//reference to the stage
		protected var _stage:Stage;

		/**
		 * @private (protected)
		 */
		//background skin 
		protected var _skin:DisplayObject;

		/**
		 * @private (protected)
		 */
		//MessageBox instance used for the text area of the dialog
		protected var _messageBox:MessageBox;
	
		/**
		 * Text field component that displays message
		 */
		public function get messageBox():MessageBox
		{
			return _messageBox;
		}

		/**
		 * @private (protected)
		 */
		//reference to the text field in the message box
		protected var _message:TextField;

		/**
		 * The text to be rendered in the dialog.
		 */
		public var messageText:String;
		
		/**
		 * @private (protected)
		 */
		//Boolean indicating whether title has been drawn.  Used to determine whether 
		//the elements should be positioned.
		protected var _titleDrawn:Boolean;

		/**
		 * @private (protected)
		 */
		//Boolean indicating whether buttons have been drawn.  Used to determine whether 
		//the elements should be positioned</p>		
		protected var _buttonsDrawn:Boolean;
	
		
		/**
		 * @private (protected)
		 */		
		//class to use for an icon image
		protected var _iconClass:DisplayObject;

		/**
		 * @private (protected)
		 */
		//Indicates whether to display an icon graphic
		protected var _hasIcon:Boolean;

		/**
		 * @private (protected)
		 */
		//collection of icons that can be reused		 		
		protected var _icons:Dictionary = new Dictionary();
		
		/**
		 * @private
		 */		
		private static var defaultStyles:Object = 
		{
			skin:"Background_skin"
		}; 
		
		/**
		 * Indicates whether the Alert has a drop shadow
		 */
		public var hasDropShadow:Boolean;
		
		/**
		 * Direction of the drop shadow
		 */
		public var shadowDirection:String;
		
		/**
		 * Gets or sets the height of the ButtonBar instance
		 */
		public function get buttonHeight():int
		{
			return _buttonBar.height;
		}
		
		/**
		 * @private (setter)
		 */		
		public function set buttonHeight(value:int):void
		{
			_buttonBar.height = value;
		}
		
		/**
		 * Gets or sets the value of the rowSpacing on the buttonBar component
		 */
		public function get buttonRowSpacing():int
		{
			return _buttonBar.rowSpacing;
		}
		
		/**
		 * @private (setter)
		 */
		public function set buttonRowSpacing(value:int):void
		{
			_buttonBar.rowSpacing = value;
		}
	
		/**
		 * Gets or sets the value of the spacing on the buttonBar component
		 */
		public function get buttonSpacing():int
		{
			return _buttonBar.spacing;	
		}
		
		/**
		 * @private (setter)
		 */		 
		public function set buttonSpacing(value:int):void
		{
			_buttonBar.spacing = value;
		}
				
	//--------------------------------------
	//  Public Methods
	//--------------------------------------			
		
		/**
		 * returns style definition
		 *
		 * @return defaultStyles object
		 */
		public static function getStyleDefinition():Object
		{
			return defaultStyles;
		}
		
		/**
		 * Centers the DialogBox		 
		 */ 
		public function positionAlert():void
		{
			var left:int = _stage.stageWidth/2 - this.width/2;
			var top:int = _stage.stageHeight/3 - this.height/2;
			this.x = left>0?left:0;
			this.y = top>0?top:0;
		}		

		/**
		 * Draws a new DialogBox
		 *
		 * @param message - message to be displayed
		 * @param title - title to be displayed
		 * @param buttons - array of buttons to be drawn
		 * @param listeners - array of functions to be attached to the buttons
		 */
		public function update(message:String, title:String, buttons:Array, listeners:Array, icon:String = null):void
		{						
			_hasIcon = icon != null;
			_iconClass = null;
			for(var i:String in _icons)
			{
				_icons[i].visible = false;
				if(_hasIcon && icon == i)
				{
					_iconClass = _icons[i];
					_iconClass.visible = true;
				}
			}
			if(_hasIcon && _iconClass == null) 
			{
				try
				{ 
					_iconClass = _icons[icon] = getDisplayObjectInstance(icon);
					this.addChild(_iconClass);
				}
				catch(e:Error)
				{
					_hasIcon = false;
					delete _icons[icon];
				}
			}
			
			_titleDrawn = _buttonsDrawn = false;
			this.setFocus();
			if(message != messageText)
			{
				messageText = message;
			}
			if(title != _titleBar.text)
			{
				_titleBar.text = title;
			}
			else
			{
				_titleDrawn = true;
			}
			
			_buttonBar.drawButtons(buttons, listeners);		
		}
		
		/**
		 * @private (setter)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 * override label set text adding setStyle
		 */		
		override public function setStyle(style:String, value:Object):void 
		{
			//Use strict equality so we can set a style to null ... so if the instanceStyles[style] == undefined, null is still set.
			//We also need to work around the specific use case of TextFormats
			if (instanceStyles[style] === value && !(value is TextFormat)) { return; }
			if(value is InstanceFactory) 
			{
				instanceStyles[style] = UIComponentUtil.getDisplayObjectInstance(this, (value as InstanceFactory).createInstance());
			}
			else
			{
				instanceStyles[style] = value;
			}
			invalidate(InvalidationType.STYLES);
		}		
		
		
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------		
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected override function configUI():void
		{	
			_titleBar = new TitleBar();
			_titleBar.buttonMode = true;
			_titleBar.useHandCursor = true;	
			_titleBar.name = TITLE;
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, startDragAlert);			
			_titleBar.addEventListener(ComponentEvent.RESIZE, resizeHandler);
			this.addChild(_titleBar);
			_messageBox = new MessageBox();
			_message = _messageBox.textField;
			_message.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler);
			this.addChild(_message);
			_buttonBar = new ButtonBar();
			_buttonBar.name = BUTTONS;		
			this.addChild(_buttonBar);
			_buttonBar.addEventListener(ComponentEvent.RESIZE, resizeHandler);

		}
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		//Fired by the resize event of the buttonBar and titleBar components.  Calls the draw function.
		protected function resizeHandler(evnt:ComponentEvent):void
		{
			var targetName:String = evnt.target.name;
			if(targetName == TITLE)
			{
				_titleDrawn = true;
			}
			if(targetName == BUTTONS) _buttonsDrawn = true;
			if(_titleDrawn && _buttonsDrawn) this.drawMessage();
		}
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		//Compare width of title, buttonBar and _maxWidth.  If buttonBar or titleBar 
		//width is greater than max width, set maxTextWidth and minTextWidth to the 
		//largest value minus total padding.  Otherwise, set maxTextWidth and minTextWidth 
		//to _maxWidth and _minWidth minus total padding, call drawMessage, position and 
		//set sizes of elements		
		protected function drawMessage():void
		{
			var minTextWidth:int;
			var maxTextWidth:int;
			var totalPadding:int = _padding*2;
			if(messageText != null)
			{
				var max:int = Math.max(_minWidth, (_buttonBar.width + totalPadding), _titleBar.width);
				if(max > _minWidth)
				{
					maxTextWidth = _maxWidth - totalPadding;
					minTextWidth = max - totalPadding;
				}
				else
				{
					maxTextWidth = _maxWidth - totalPadding;
					minTextWidth = _minWidth - totalPadding;
				}
				if(_hasIcon)
				{
					maxTextWidth -= _iconClass.width + _padding;
					minTextWidth -= _iconClass.width + _padding;
					_messageBox.autoSizeStyle = TextFieldAutoSize.LEFT;
					_iconClass.y = _titleBar.height + _padding;
				}
				else
				{
					_messageBox.autoSizeStyle = TextFieldAutoSize.CENTER;
				}
				
				_messageBox.drawMessage(maxTextWidth, minTextWidth, messageText);
				_titleBar.y = 0;
				_message.y = _titleBar.height + _padding;
				
				if(_hasIcon)
				{
					_buttonBar.y = Math.max(_message.getBounds(this).bottom, _iconClass.getBounds(this).bottom) + _padding;	
					this.setSize(_message.width+_padding*2+ (_iconClass.width+_padding), _buttonBar.height + _buttonBar.y  + _padding);	
					_iconClass.x = Math.round(this.width/2) - Math.round((_iconClass.width + _padding + _message.width)/2);
					_message.x = _iconClass.x + _iconClass.width + _padding;
				}
				else
				{
					_buttonBar.y = _message.getBounds(this).bottom + _padding;	
					this.setSize(_message.width+_padding*2, _buttonBar.height + _buttonBar.y  + _padding);	
					_message.x = Math.round(this.width/2) - Math.round(_message.width/2);
				}
				
				
				_buttonBar.x = Math.round((this.width)/2- (_buttonBar.width)/2);
				_titleBar.drawBackground(this.width);
				this.drawSkin();
				this.positionAlert();
				this.visible = true;
			}
		}
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */		
		//Sets dimensions for the background skin of the message box
		protected function drawSkin():void
		{
			if(_skin != this.getDisplayObjectInstance(getStyleValue("skin")))
			{
				if(this.getChildAt(0) == _skin) this.removeChildAt(0);
				_skin = getDisplayObjectInstance(getStyleValue("skin"))
				this.addChildAt(_skin, 0);
			}
			if(_skin != null)
			{
				_skin.width = this.width;
				_skin.height = this.height;
				if(hasDropShadow)
				{
					var shadowAngle:int = (shadowDirection == "left")?135:45;
					var filters:Array = [];
					var dropShadow:DropShadowFilter	= new DropShadowFilter(2, shadowAngle, 0x000000, .5, 4, 4, 1, 1, false, false, false);
					filters.push(dropShadow);
					_skin.filters = filters;
				}
			}
		}				
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */				
		 //Set x and y offsets based on of the mouse down location
		 //Add mouseMove and mouseUp listeners
		 //Remove the mouseDown listener 
		protected function startDragAlert(evnt:MouseEvent):void
		{
			_dragOffSetX = Math.round(evnt.localX*evnt.target.scaleX);
			_dragOffSetY = Math.round(evnt.localY*evnt.target.scaleY);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, dragAlert, false, 0, true);
			_stage.addEventListener(MouseEvent.MOUSE_UP, stopAlertDrag, false, 0, true);
			_titleBar.removeEventListener(MouseEvent.MOUSE_DOWN, startDragAlert);
		}
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */	
		//Moves the Dialog with the mouse 
		protected function dragAlert(evnt:MouseEvent):void
		{
			if(evnt.stageX < _stage.stageWidth && evnt.stageY < _stage.stageHeight && evnt.stageX > 0 && evnt.stageY > 0)
			{
				this.x = evnt.stageX - _dragOffSetX;
				this.y = evnt.stageY - _dragOffSetY;
				evnt.updateAfterEvent();		
			}
		}
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */		
		 //Remove mouseMove and mouseUp listeners
		 //Add the mouseDown listener
		protected function stopAlertDrag(evnt:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragAlert);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, stopAlertDrag);
			_stage.removeEventListener(Event.MOUSE_LEAVE, stopAlertDrag);
			_titleBar.addEventListener(MouseEvent.MOUSE_DOWN, startDragAlert);
		}	

		/*
		 * @private (protected)
		 *
		 * Sets focus on the first button.
		 *
		 * @param event FocusEvent
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */		
		protected function keyFocusChangeHandler(event:FocusEvent):void
		{
			if(event.keyCode == Keyboard.TAB)
			{
				event.preventDefault();
				//reset focus to the first button
				_buttonBar.focusIndex = 0;
				//if shift key is pressed, set focus on the last button
				if(event.shiftKey) _buttonBar.setFocusIndex(event.shiftKey);
				_buttonBar.setFocus();
				_buttonBar.setFocusButton();
			}
		}
		
		/**
	     * @private (protected)
	     * @inheritDoc
		 */
		override protected function initializeAccessibility():void 
		{
			if (DialogBox.createAccessibilityImplementation != null) 
			{
				DialogBox.createAccessibilityImplementation(this);
			}
		}
	
	}
}