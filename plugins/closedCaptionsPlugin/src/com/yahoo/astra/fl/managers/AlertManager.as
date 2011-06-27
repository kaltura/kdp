/*
Copyright (c) 2009 Yahoo! Inc.  All rights reserved.  
The copyrights embodied in the content of this file are licensed under the BSD (revised) open source license
*/
﻿package com.yahoo.astra.fl.managers
{
	import com.yahoo.astra.fl.controls.containerClasses.DialogBox;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import fl.core.UIComponent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import com.yahoo.astra.utils.TextUtil;
	//--------------------------------------
	//  Class description
	//--------------------------------------
	
	/**
	 * The AlertManager class extends UIComponent and manages the queuing
	 * and displaying of Alerts.
	 *
	 * @see fl.core.UIComponent
	 *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     * @author Dwight Bridges	
	 */
	public class AlertManager extends UIComponent
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
			
		/**
         * @private (singleton constructor)
		 * 
		 * @param container - object calling the alert
		 */
		public function AlertManager(container:DisplayObject = null)
		{
			super();
			if(isLivePreview)
			{
				_livePreviewSkin = getDisplayObjectInstance("Background_skin") as Sprite;
				_livePreviewTitleBar = getDisplayObjectInstance("Title_skin") as Sprite;
				this.addChild(_livePreviewSkin);
				this.addChild(_livePreviewTitleBar);
			}
			else if(_allowInstantiation)
			{
				if(container != null)
				{
					_stage = container.stage;
				}
				else if(this.stage)
				{
					_stage = stage;
					parent.removeChild(this);
				}

				_allowInstantiation = false;
				
				if(_stage)
				{
					_stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);
					_stage.addEventListener(Event.FULLSCREEN, stageResizeHandler, false, 0, true);	
					_stage.addChild(this);
				}
				
				_overlay = new Sprite();
				addChild(_overlay);
				_overlay.visible = false;
				
			}
		}
		
		/**
		 * @private
		 */
		private static function setStage(container:Stage):void
		{
			_stage = container;
			_stage.addEventListener(Event.RESIZE, _alertManager.stageResizeHandler, false, 0, true);
			_stage.addEventListener(Event.FULLSCREEN, _alertManager.stageResizeHandler, false, 0, true);
			_stage.addChild(_alertManager);
			_overlay = new Sprite();
			_alertManager.addChild(_overlay);
			_overlay.visible = false;											
		}		
		
	//--------------------------------------
	//  Properties
	//--------------------------------------		
		 
		/**
		 * @private 
		 */
		//array containing an object for each alert requested by the createAlert method
		//the object contains parameters for the dialog box
		private static var _alertQueue:Array = [];
		
		/**
		 * @private 
		 */
		private static var _alert:DialogBox;
		
		
		/**
		 * @private 
		 */
		private static var _alertManager:AlertManager;

		/**
		 * @private
		 */		
		private static var _stage:Stage;

		/**
		 * @private
		 */
		//used to enforce singleton class
		private static var _allowInstantiation:Boolean = true;
						
		/**
		 * Alpha value of the overlay
		 */		
		public static var overlayAlpha:Number = .2;
		
		/**
		 * The blur value of the parent object when the alert is present and modal
		 */		
		public static var modalBackgroundBlur:int = 2;
		   
   		/**
   		 * Maximum width of the alert
   		 */
		public static var maxWidth:int = 360;

   		/**
   		 * Minimum width of the alert 
   		 */
		public static var minWidth:int = 300;

   		/**
   		 * Padding for the alert
   		 */
		public static var padding:int = 5;

   		/**
   		 * Amount of space between buttons on the alert
   		 */
		public static var buttonSpacing:int = 2;

   		/**
   		 * Amount of space between button rows on the alert
   		 */
		public static var buttonRowSpacing:int = 1;
		
		/**
		 * Height of the buttons on the alert
		 */
		public static var buttonHeight:int = 20;
		
   		/**
   		 * Color of the text for the title bar on the alert
   		 */		
		private static var _titleTextColor:uint;
		
		/**
		 * Gets or sets the text color for the title bar. <strong>Note:</strong> Text color can now be styled by passing 
		 * a <code>TextFormat</code> object to the <code>setTitleBarStyle</code> method.
   		 *
   		 * @deprecated
   		 */		
		public static function get titleTextColor():uint
		{
			AlertManager.getInstance();
			var tf:TextFormat;
			if(_alertManager.titleBarStyles.textFormat != null)
			{
				tf = _alertManager.titleBarStyles.textFormat as TextFormat;		
			}
			else if(_alert.titleBar != null && (_alert.titleBar as UIComponent).getStyle("textFormat") != null)
			{
				tf = (_alert.titleBar as UIComponent).getStyle("textFormat") as TextFormat;
			}
			else
			{
				tf = new TextFormat("_sans", 11, 0xffffff, true, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
			}
			return tf.color as uint;
		}
		
		/**
		 * @private (setter)
		 */
		public static function set titleTextColor(value:uint):void
		{
			if(isNaN(value)) return;
			AlertManager.getInstance();
			var tempTf:TextFormat;
			if(_alertManager.titleBarStyles.textFormat != null)
			{
				tempTf = _alertManager.titleBarStyles.textFormat as TextFormat;	
			}
			else if(_alert.titleBar != null && (_alert.titleBar as UIComponent).getStyle("textFormat") != null)
			{
				tempTf = (_alert.titleBar as UIComponent).getStyle("textFormat") as TextFormat;
			}
			else
			{
				tempTf = new TextFormat("_sans", 11, 0xffffff, true, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0);
			}
			AlertManager.setTitleBarStyle("textFormat", TextUtil.changeTextFormatProps(TextUtil.cloneTextFormat(tempTf), {color:value}));
		}
		
		
   		/**
   		 * Color of the message text on the alert. <strong>Note:</strong> Text color can now be styled by passing a <code>TextFormat</code>
   		 * object to the <code>setMessageBoxStyle</code> method.
   		 *
   		 * @deprecated
   		 */		
		public static function get textColor():uint
		{
			AlertManager.getInstance();
			var tf:TextFormat;
			if(_alertManager.messageBoxStyles.textFormat != null)
			{
				tf = _alertManager.messageBoxStyles.textFormat as TextFormat;		
			}
			else if(_alert.messageBox != null && (_alert.messageBox as UIComponent).getStyle("textFormat") != null)
			{
				tf = (_alert.messageBox as UIComponent).getStyle("textFormat") as TextFormat;
			}
			else
			{
				tf = new TextFormat("_sans", 11, 0xffffff);
			}
			return tf.color as uint;
									
		}
		
		/**
		 * @private (setter)
		 */
		public static function set textColor(value:uint):void
		{
			if(isNaN(value)) return;
			AlertManager.getInstance();
			var tempTf:TextFormat;
			if(_alertManager.messageBoxStyles.textFormat != null)
			{
				tempTf = _alertManager.messageBoxStyles.textFormat as TextFormat;		
			}
			else if(_alert.messageBox != null && (_alert.messageBox as UIComponent).getStyle("textFormat") != null)
			{
				tempTf = (_alert.messageBox as UIComponent).getStyle("textFormat") as TextFormat;
			}
			else
			{
				tempTf =new TextFormat("_sans", 11, 0xffffff);
			}
			AlertManager.setMessageBoxStyle("textFormat", TextUtil.changeTextFormatProps(TextUtil.cloneTextFormat(tempTf), {color:value}));
		}
		
		/**
		 * Indicates whether the alert has a drop shadow
		 */
		public static var hasDropShadow:Boolean = true;
		
		/**
		 * direction of the alert's drop shadow
		 */
		public static var shadowDirection:String = "right";
		
		/**
		 * @private
		 */
		private static var _overlay:Sprite;
		
		/**
		 * The DisplayObject that uses the createAlert method to display an alert.  The 
		 * AlertManager 
		 */
		protected var container:DisplayObject;
		
		/**
		 * @private (protected)
		 */	
		//Copy of container's filters property.  Used to return the container to it's original 
		//state when the alert is removed.
		protected var parentFilters:Array;
		
		/**
		 * @private
		 *
		 * Holds styles for TitleBar
		 */
		public var titleBarStyles:Object = {}; 
		
		/**
		 * @private 
		 *
		 * Holds styles for MessageBox
		 */
		public var messageBoxStyles:Object = {}; 
		
		/**
		 * @private
		 *
		 * Holds styles for Buttons
		 */
		private var buttonStyles:Object = {}; 
		
		/**
		 * @private
		 *
		 * Holds styles for DialogBox
		 */
		private var alertStyles:Object = {};
				
		/** 
		 * @private
		 */
		private var _livePreviewTitleBar:Sprite;
 
		/**
		 * @private 
		 */
		private var _livePreviewSkin:Sprite; 

	//--------------------------------------
	//  Public Methods
	//--------------------------------------		

	 	/**
	 	 * Creates an instance of AlertManager.
	 	 *
	 	 * @param container - display object creating an alert box
	 	 *
	 	 * @return AlertManager
	 	 */
		public static function getInstance(container:DisplayObject = null):AlertManager
		{
			if(_alertManager == null) 
			{
				_allowInstantiation = true;
				_alertManager = new AlertManager(container);			
				_allowInstantiation = false;
			}
			return _alertManager;
		}

		/**
		 * Creates an alert and puts it in the queue.  If it is the first alert or all 
		 * previous alerts have been displayed, it will show the alert.  If this is the 
		 * first alert, the class is instantiated. 
		 *
		 * @param container - display object creating an alert box
		 * @param message - message to be displayed
		 * @param title - text to show in the title bar
		 * @param buttons - array containing the name of the buttons to be displayed
		 * @param callBackFunction - function to be called when a button is pressed
		 * @param iconClass - string value indicating the library object to be used for an icon
		 * @param isModal - boolean indicating whether or not to prevent interaction with the parent while the message box is present
         * @param props - Optional parameters will only affect the single alert instance. Any of the following any of the following 
         * properties can be used:
		 * <br />
		 *  <table class="innertable" width="100%">
		 *  	<tr><th>Property</th><th>Purpose</th></tr>
		 * 		<tr><td>maxWidth</td><td>Indicates the maximum allowed width of the alert.</td></tr>
		 * 		<tr><td>minWidth</td><td>Indicates the minimum allowed width of the alert.</td></tr>
		 * 		<tr><td>padding</td><td>Indicates the amount of padding on the alert.</td></tr>
		 * 		<tr><td>buttonHeight</td><td>Indicates the height of buttons on an alert.</td></tr>
		 * 		<tr><td>buttonSpacing</td><td>Indicates the space between buttons on an alert.</td></tr>
		 * 		<tr><td>hadDropShadow</td><td>Indicates whether or not the alert has a drop shadow.</td></tr>
		 * 		<tr><td>shadowDirection</td><td>Indicates the direction of a drop shadow.</td></tr>
		 * 		<tr><td>titleBarStyles</td><td>Set styles on the title bar of the alert box.</td></tr>		 
		 * 		<tr><td>messageBoxStyles</td><td>Sets styles on the message text field of the alert.</td></tr>
		 * 		<tr><td>buttonStyles</td><td>Styles set on the alert buttons.</td></tr>
		 * 		<tr><td>alertStyles</td><td>Sets styles on the alert.</td></tr>
		 * 		<tr><td>textColor (deprecated)</td><td>Sets the color of the message text. <strong>Note:</code> this property has been
		 * deprecated in favor of using the <code>alertStyles.textFormat</code> style.</td></tr>
		 * 		<tr><td>titleTextColor (deprecated)</td><td>Sets the color of the title text. <strong>Note:</code> this property has 
		 * been deprecated in favor of using the <code>titleBarStyles.textFormat</code> style.</td></tr>	 
		 *  </table>	 
         *
         * @return AlertManager
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0		 
		 */			
		public static function createAlert(container:DisplayObject, 
							message:String, 
							title:String = "Alert", 
							buttons:Array = null, 
							callBackFunction:Function = null, 
							iconClass:String = null, 
							isModal:Boolean = true,
							props:Object = null):AlertManager
		{		
			if(!container) return _alertManager;
			
			AlertManager.getInstance(container);
			if(_stage == null) setStage(container.stage);
			if(_alert == null) 
			{
				_alert = new DialogBox(_stage);
				 _alertManager.addChild(_alert);					
			}
			_alertManager.copyRendererStylesToChild(_alert.titleBar, _alertManager.titleBarStyles);
			_alertManager.copyRendererStylesToChild(_alert.messageBox, _alertManager.messageBoxStyles);
			_alertManager.setButtonStyles(_alertManager.buttonStyles);
			_alertManager.copyRendererStylesToChild(_alert, _alertManager.alertStyles);
			
			if(buttons == null) buttons = ["OK"];
			var functions:Array = [];
			if(callBackFunction != null) functions.push(callBackFunction);
			functions.push(_alertManager.manageQueue);
			var alertParams:Object = {
				message:message, 
				title:title, 
				isModal:isModal, 
				buttons:buttons, 
				functions:functions, 
				iconClass:iconClass, 
				props:props,
				container:container
			};
			
			if(_alertQueue.length == 0)
			{
				_alert.maxWidth = (props != null && !isNaN(props.maxWidth))?Math.round(props.maxWidth) as int:maxWidth;
				_alert.minWidth = (props != null && !isNaN(props.minWidth))?Math.round(props.minWidth) as int:minWidth;
				_alert.padding = (props != null && !isNaN(props.padding))?Math.round(props.padding) as int:padding;
				_alert.buttonHeight = (props != null && !isNaN(props.buttonHeight))?Math.round(props.buttonHeight) as int:buttonHeight;
				_alert.buttonRowSpacing = (props != null && !isNaN(props.buttonRowSpacing))?Math.round(props.buttonRowSpacing) as int:buttonRowSpacing;
				_alert.buttonSpacing = (props != null && !isNaN(props.buttonSpacing))?Math.round(props.buttonSpacing) as int:buttonSpacing;
				_alert.hasDropShadow = (props != null && props.hasDropShadow != null)?props.hasDropShadow:hasDropShadow;
				_alert.shadowDirection = (props != null && props.shadowDirection != null)?props.shadowDirection:shadowDirection;
				if(props != null && props.titleBarStyles != null) _alertManager.copyRendererStylesToChild(_alert.titleBar, props.titleBarStyles);
				if(props != null && props.messageBoxStyles != null) _alertManager.copyRendererStylesToChild(_alert.messageBox, props.messageBoxStyles);
				if(props != null && !isNaN(props.textColor)) _alert.messageBox.setStyle("textFormat", _alertManager.replaceUIComponentTextColor(_alert.messageBox as UIComponent, props.textColor));//AlertManager.textColor = props.textColor as uint;
				if(props != null && !isNaN(props.titleTextColor)) _alert.titleBar.setStyle("textFormat", _alertManager.replaceUIComponentTextColor(_alert.titleBar as UIComponent, props.titleTextColor));
				if(props != null && props.buttonStyles != null) _alertManager.setButtonStyles(props.buttonStyles);
				if(props != null && props.alertStyles != null) _alertManager.copyRendererStylesToChild(_alert, props.alertStyles);
				_alert.update(message, title, buttons, functions, iconClass);
				_overlay.visible = isModal;
				if(isModal)
				{
					_alertManager.container = container; 
					var newFilters:Array;
					newFilters = _alertManager.container.filters.concat();
					 _alertManager.parentFilters = _alertManager.container.filters.concat();
					newFilters.push(_alertManager.getBlurFilter());	
					_alertManager.container.filters = newFilters;
				}
			}
			
			_alertQueue.push(alertParams);
			
			return _alertManager;
		}
		
		/**
		 * Removes the current alert from the messages array.  If there are more alerts, 
		 * call pass the params for the next alert to the DialogBox object.  Otherwise, 
		 * hide the alert object and the cover.</p>
		 *
		 * @evnt - Mouse event received from the DialogBox object 
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0		 
		 */ 
		public function manageQueue(evnt:MouseEvent):void
		{		
			_alertQueue.splice(0, 1);
			_alertManager.container.filters = _alertManager.parentFilters;
			if(_alertQueue.length > 0)
			{
				_stage.setChildIndex(this, _stage.numChildren - 1);
				var params:Object = _alertQueue[0];
				var props:Object = params.props;
				_alert.maxWidth = (props != null && !isNaN(props.maxWidth))?Math.round(props.maxWidth) as int:maxWidth;
				_alert.minWidth = (props != null && !isNaN(props.minWidth))?Math.round(props.minWidth) as int:minWidth;
				_alert.padding = (props != null && !isNaN(props.padding))?Math.round(props.padding) as int:padding;
				_alert.buttonHeight = (props != null && !isNaN(props.buttonHeight))?Math.round(props.buttonHeight) as int:buttonHeight;
				_alert.buttonRowSpacing = (props != null && !isNaN(props.buttonRowSpacing))?Math.round(props.buttonRowSpacing) as int:buttonRowSpacing;
				_alert.buttonSpacing = (props != null && !isNaN(props.buttonSpacing))?Math.round(props.buttonSpacing) as int:buttonSpacing;						
				_alert.hasDropShadow = (props != null && props.hasDropShadow != null)?props.hasDropShadow:hasDropShadow;
				_alert.shadowDirection = (props != null && props.shadowDirection != null)?props.shadowDirection:shadowDirection;
				if(props != null && props.titleBarStyles != null) _alertManager.copyRendererStylesToChild(_alert.titleBar, props.titleBarStyles);
				if(props != null && props.messageBoxStyles != null) _alertManager.copyRendererStylesToChild(_alert.messageBox, props.messageBoxStyles);				
				if(props != null && !isNaN(props.textColor)) _alert.messageBox.setStyle("textFormat", _alertManager.replaceUIComponentTextColor(_alert.messageBox as UIComponent, props.textColor));//AlertManager.textColor = props.textColor as uint;
				if(props != null && !isNaN(props.titleTextColor)) _alert.titleBar.setStyle("textFormat", _alertManager.replaceUIComponentTextColor(_alert.titleBar as UIComponent, props.titleTextColor));	
				if(props != null && props.buttonStyles != null) _alertManager.setButtonStyles(props.buttonStyles);
				if(props != null && props.alertStyles != null) _alertManager.copyRendererStylesToChild(_alert, props.alertStyles);
				_alert.update(params.message, params.title, params.buttons, params.functions, params.iconClass);
				_overlay.visible = params.isModal;
				if(params.isModal)
				{
					_alertManager.container = params.container; 
					var newFilters:Array;
					newFilters = _alertManager.container.filters.concat();
					 _alertManager.parentFilters = _alertManager.container.filters.concat();
					newFilters.push(_alertManager.getBlurFilter());	
					_alertManager.container.filters = newFilters;
				}			
			}
			else
			{
				_alert.visible = false;
				
				_overlay.visible = false;
			}
		}
		
		/**
		 * Gets a blur filter to add to the parent's <code>filters</code> property.
		 *
		 * @return BitmapFilter with specified blur values
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0		 
		 */
		public function getBlurFilter():BitmapFilter
		{
			var blurFilter:BlurFilter = new BlurFilter();
			blurFilter.blurX = modalBackgroundBlur;
			blurFilter.blurY = modalBackgroundBlur;
			blurFilter.quality = BitmapFilterQuality.HIGH;				
			return blurFilter;
		}
		
		/**
		 * Set styles on the TitleBar
		 *
		 * @see com.yahoo.astra.fl.controls.containerClasses.TitleBar		 
		 */
		public static function setTitleBarStyle(name:String, style:Object):void
		{
			AlertManager.getInstance();
			if (_alertManager.titleBarStyles[name] == style) return; 
			_alertManager.titleBarStyles[name] = style;
			if(_alert != null && _alert.titleBar != null) (_alert.titleBar as UIComponent).setStyle(name, style);
		}	
		
		
		/**
		 * Sets styles on a the Alert message
		 * 
		 * @see com.yahoo.astra.fl.controls.containerClasses.MessageBox
		 */
		public static function setMessageBoxStyle(name:String, style:Object):void
		{
			AlertManager.getInstance();
			if (_alertManager.messageBoxStyles[name] == style) { return; }
			_alertManager.messageBoxStyles[name] = style;
			if(_alert != null && _alert.messageBox != null) (_alert.messageBox as UIComponent).setStyle(name, style);			
		}
		
		/**
		 * Sets the styles for buttons
		 *
		 * @see com.yahoo.astra.fl.controls.containerClasses.AutoSizeButton	 
		 */
		public static function setButtonStyle(name:String, style:Object):void
		{
			AlertManager.getInstance();
			if(_alertManager.buttonStyles[name] == style) return;
			_alertManager.buttonStyles[name] = style;
			if(_alert != null && _alert.buttonBar != null) _alert.buttonBar.setButtonStyle(name, style);
		}

		/**
		 * Sets styles for the Alert
		 *
		 * @see com.yahoo.astra.fl.controls.containerClasses.DialogBox	 
		 */
		public static function setAlertStyle(name:String, style:Object):void
		{
			AlertManager.getInstance();
			if(_alertManager.alertStyles[name] == style) return;
			_alertManager.alertStyles[name] = style;
			if(_alert != null) _alert.setStyle(name, style);
		}
		
		
	//--------------------------------------
	//  Protected Methods
	//-------------------------------------
	
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected override function configUI():void
		{
			super.configUI();

		}
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */	
		//Set the width and height to that of the stage and redraw the cover object. 
		protected override function draw():void
		{
			if(this.isLivePreview) 
			{
				_livePreviewSkin.width = this.width;
				_livePreviewSkin.height = this.height;
				_livePreviewTitleBar.width = this.width;
				_livePreviewTitleBar.height = Math.min(20,this.height/5);
			}
			else
			{
				//set the dimensions
				this.width = _stage.stageWidth;
				this.height = _stage.stageHeight;
				this.x = _stage.x;
				this.y = _stage.y;
				_overlay.x = _overlay.y = 0;
				_overlay.width = this.width;
				_overlay.height = this.height;
				_overlay.graphics.clear();
				_overlay.graphics.beginFill(0xeeeeee, overlayAlpha);
				_overlay.graphics.moveTo(0,0);
				_overlay.graphics.lineTo(this.width, 0);
				_overlay.graphics.lineTo(this.width, this.height);
				_overlay.graphics.lineTo(0, this.height);
				_overlay.graphics.lineTo(0, 0);
				_overlay.graphics.endFill();
				if(_alert != null) _alert.positionAlert();
			}
		}

        /**
         * @private (protected)
         *
         * @param evnt - event fired from the stage
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */			
		//Call the draw function when the stage is resized
		protected function stageResizeHandler(evnt:Event):void
		{
			draw();
		}		
		/**
		 * @private
		 *
		 * @param styleMap - styles to be set on the buttonBar instance
		 */
		private function setButtonStyles(styleMap:Object):void
		{
			for(var n:String in styleMap)
			{
				_alert.buttonBar.setButtonStyle(n, styleMap[n])
			}
		}
		
		/**
         * @private 
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function copyRendererStylesToChild(child:UIComponent,styleMap:Object):void 
		{
			for (var n:String in styleMap) 
			{
				child.setStyle(n, styleMap[n]);
			}
		}	
		
		/**
		 * @private
		 * Helper function used to handle deprecated text color properties
		 */
		private function replaceUIComponentTextColor(ui:UIComponent, value:uint):TextFormat
		{
			var tempTf:TextFormat;
			if(ui != null && ui.getStyle("textFormat") != null)
			{
				tempTf = ui.getStyle("textFormat") as TextFormat;		
			}
			else
			{
				tempTf = new TextFormat("_sans", 11, value);
			}
			return TextUtil.changeTextFormatProps(TextUtil.cloneTextFormat(tempTf), {color:value});
		}		
	}
}