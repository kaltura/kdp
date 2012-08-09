// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package fl.core {

	import com.kaltura.kdpfl.view.controls.ToolTipManager;
	import com.yahoo.astra.fl.containers.layoutClasses.AdvancedLayoutPane;
	
	import fl.events.ComponentEvent;
	import fl.managers.FocusManager;
	import fl.managers.IFocusManager;
	import fl.managers.IFocusManagerComponent;
	import fl.managers.StyleManager;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.IME;
	import flash.system.IMEConversionMode;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	
    //--------------------------------------
    //  Events
    //--------------------------------------
    /**
     * Dispatched after the component is moved.
     *
     * @eventType fl.events.ComponentEvent.MOVE
     *
     * @includeExample examples/UIComponent.MOVE.1.as -noswf
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	[Event(name="move", type="fl.events.ComponentEvent")]

    /**
     * Dispatched after the component is resized.
     *
     * @eventType fl.events.ComponentEvent.RESIZE
     *
     * @includeExample examples/UIComponent.RESIZE.1.as -noswf
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	[Event(name="resize", type="fl.events.ComponentEvent")]

    /**
     * Dispatched after the component visibility changes from invisible to visible.
     *
     * @eventType fl.events.ComponentEvent.SHOW
     *
     * @includeExample examples/UIComponent.HIDE.1.as -noswf
     *
     * @see #event:hide
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	[Event(name="show", type="fl.events.ComponentEvent")]


    /**
     * Dispatched after the component visibility changes from visible to invisible.
     *
     * @eventType fl.events.ComponentEvent.HIDE
     *
     * @includeExample examples/UIComponent.HIDE.1.as -noswf
     *
     * @see #event:show
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Event(name="hide", type="fl.events.ComponentEvent")]


    //--------------------------------------
    //  Styles
    //--------------------------------------
    /**
     * The skin to be used to display focus indicators.
     *
     * @default focusRectSkin
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="focusRectSkin", type="Class")]

    /**
     * The padding that separates the outside boundaries of the component from the
     * outside edges of the focus indicator, in pixels.
     *
     * @default 2
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
    [Style(name="focusRectPadding", type="Number", format="Length")]

    /**
     *  The TextFormat object to use to render the component label.
     *
     *  @default TextFormat("_sans", 11, 0x000000, false, false, false, '', '', TextFormatAlign.LEFT, 0, 0, 0, 0)
     *
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	[Style(name="textFormat", type="flash.text.TextFormat")]

    /**
     *  The TextFormat object to use to render the component label when the button is disabled.
     *
     *  @default TextFormat("_sans", 11, 0x999999, false, false, false, '', '', TextFormatAlign.LEFT, 0, 0, 0, 0)
     *
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	[Style(name="disabledTextFormat", type="flash.text.TextFormat")]


    //--------------------------------------
    //  Class description
    //--------------------------------------	
    /**
     *  The UIComponent class is the base class for all visual components,
     *  both interactive and noninteractive. Interactive components are defined
     * 	as components that receive user input such as keyboard or mouse activity.
     *	Noninteractive components are used to display data; they do not respond
     *	to user interaction. The ProgressBar and UILoader components are examples
     *  of noninteractive components.
     *
     *  <p>The Tab and arrow keys can be used to move focus to and over an interactive component;
     *  an interactive component can accept low-level events such as input from mouse and keyboard
     *  devices. An interactive component can also be disabled so that it cannot receive
     *  mouse and keyboard input.</p>
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
     */
	public class UIComponent extends Sprite {

        /**
         * The version number of the components.
         *
         * @includeExample examples/UIComponent.version.1.as -noswf
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public var version:String = "3.0.0.16";

        /**
         * @private (internal)
         * Indicates whether the current execution stack is within a call later phase.
         *
         * @default false
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public static var inCallLaterPhase:Boolean=false;

        /**
         * @private
		 * Used when components are nested, and we want the parent component to
		 * handle draw focus, not the child.
         *
         * @default null
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public var focusTarget:IFocusManagerComponent;

		/**
		 * use to save the string that the ToolTip will show 
		 */
		public var tooltip:String = "";
		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var isLivePreview:Boolean = false;

        /**
         * @private (testing)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		private var tempText:TextField;

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var instanceStyles:Object;
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var sharedStyles:Object; // Holds a reference to the class-level styles.
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var callLaterMethods:Dictionary;
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var invalidateFlag:Boolean = false;
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var _enabled:Boolean=true;
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var invalidHash:Object;
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var uiFocusRect:DisplayObject;
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var isFocused:Boolean =  false

        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		private var _focusEnabled:Boolean = true;


        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		private var _mouseFocusEnabled:Boolean = true;


        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var _width:Number;

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var _height:Number;

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var _x:Number;

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var _y:Number;

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var startWidth:Number;

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var startHeight:Number;

		protected var _shouldDisable : Boolean = true;	
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var _imeMode:String = null;

        /**
         * @private (protected)
         */
		protected var _oldIMEMode:String = null;

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var errorCaught:Boolean = false;

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var _inspector:Boolean = false;
		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected var _includeInLayout:Boolean = true;

        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		private static var defaultStyles:Object = {
											focusRectSkin:"focusRectSkin",
											focusRectPadding:2,
											textFormat: new TextFormat("_sans", 11, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
											disabledTextFormat: new TextFormat("_sans", 11, 0x999999, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
											defaultTextFormat: new TextFormat("_sans", 11, 0x000000, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0),
											defaultDisabledTextFormat: new TextFormat("_sans", 11, 0x999999, false, false, false, "", "", TextFormatAlign.LEFT, 0, 0, 0, 0)
											}


        /**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		private static var focusManagers:Dictionary = new Dictionary(false);


        /**
         * Retrieves the default style map for the current component. The style map contains
         * the type that is appropriate for the component, depending on the style that
         * the component uses. For example, the <code>disabledTextFormat</code> style 
         * contains a value of <code>null</code> or a TextFormat object. 
         * You can use these styles and call <code>setStyle()</code> on the current 
         * component. The following code overrides the default <code>disabledTextFormat</code> 
         * style on the specified component: 
         * <listing>componentInstance.setStyle("disabledTextFormat", new TextFormat());</listing>
         * 
         * @return Default styles object.
         *
         * @includeExample examples/UIComponent.getStyleDefinition.1.as -noswf
         *
         * @see #getStyle()
         * @see #setStyle()
         * @see fl.managers.StyleManager StyleManager
         * @internal [kenos] This is vague. What are "these styles" that you can use "and call setStyle
         *                   on the current component"?
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public static function getStyleDefinition():Object {			
			return defaultStyles;
		}

        /**
         * Merges the styles from multiple classes into one object. 
         * If a style is defined in multiple objects, the first occurrence
         * that is found is used. 
         *
         * @param list A comma-delimited list of objects that contain the default styles to be merged.
         *
         * @return A default style object that contains the merged styles.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public static function mergeStyles(...list:Array):Object {
			var styles:Object = {};
			var l:uint = list.length;
			for (var i:uint=0; i<l; i++) {
				var styleList:Object = list[i];
				for (var n:String in styleList) {
					if (styles[n] != null) { continue; }
					styles[n] = list[i][n];
				}
			}
			return styles;
		}


        /**
         *  @private
         *  @internal (Placeholder for mixin by UIComponentAccImpl)
         *
         *  Creates the Accessibility class to be associated with the current component.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public static var createAccessibilityImplementation:Function;


        /**
         * Creates a new UIComponent component instance.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function UIComponent() {
			super();
			instanceStyles = {};
			sharedStyles = {};
			invalidHash = {};

			callLaterMethods = new Dictionary();

			StyleManager.registerInstance(this);

			configUI();
			invalidate(InvalidationType.ALL);
			// We are tab enabled by default if IFocusManagerComponent
			tabEnabled = (this is IFocusManagerComponent);
			// We do our own focus drawing.
			focusRect = false;

			// Register for focus and keyboard events.
			if (tabEnabled) {
				addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
				addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
				addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			}
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			initializeFocusManager()
			addEventListener(Event.ENTER_FRAME, hookAccessibility, false, 0, true);
		}


        /**
         * @private (internal)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function get componentInspectorSetting():Boolean {
			return _inspector;
		}
        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set componentInspectorSetting(value:Boolean):void {
			_inspector = value;
			if (_inspector) {
				beforeComponentParameters();
			} else {
				afterComponentParameters();	
			}
		}

        // For easy overriding...
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function beforeComponentParameters():void {}
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function afterComponentParameters():void {}
		
	
        [Inspectable(defaultValue=true, verbose=1)]
        /**
         * Gets or sets a value that indicates whether the component can accept user interaction.
         * A value of <code>true</code> indicates that the component can accept user interaction; a
         * value of <code>false</code> indicates that it cannot. 
         *
         * <p>If you set the <code>enabled</code> property to <code>false</code>, the color of the 
         * container is dimmed and user input is blocked (with the exception of the Label and ProgressBar components).</p>
         *
         * @default true
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
         public function get enabled():Boolean { return _enabled; }

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		
		public function set enabled(value:Boolean):void {
			if (value == _enabled) { return; }
			_enabled = value;
			invalidate(InvalidationType.STATE);
		}
        /**
         * Sets the component to the specified width and height.
         *
         * @param width The width of the component, in pixels.
         *
         * @param height The height of the component, in pixels.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function setSize(width:Number, height:Number):void {
			_width = width;
			_height = height;
			invalidate(InvalidationType.SIZE);
			dispatchEvent(new ComponentEvent(ComponentEvent.RESIZE, false));
		}

        /**
         * Gets or sets the width of the component, in pixels.
         *
         * <p>Setting this property causes a <code>resize</code> event to be
         * dispatched. See the <code>resize</code> event for detailed information
         * about when it is dispatched.</p>
         *
         * <p>If the <code>scaleX</code> property of the component is not 1.0, 
         * the width of the component that is obtained from its internal coordinates
         * will not match the width value from the parent coordinates. For example, 
         * a component that is 100 pixels in width and has a <code>scaleX</code> of 2 
         * has a value of 100 pixels in the parent, but internally stores a value 
         * indicating that it is 50 pixels wide.</p>
         *
         * @see #height
         * @see #event:resize
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function get width():Number { return _width; }
        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function set width(value:Number):void {
			if (_width == value) { return; }
			setSize(value, height);
		}

        /**
         * Gets or sets the height of the component, in pixels.
         *
         * <p>Setting this property causes a <code>resize</code> event to be
         * dispatched. See the <code>resize</code> event for detailed information
         * about when it is dispatched.</p>
         *
         * <p>If the <code>scaleY</code> property of the component is not 1.0, 
         * the height of the component that is obtained from its internal coordinates
         * will not match the height value from the parent coordinates. For example, 
         * a component that is 100 pixels in height and has a <code>scaleY</code> of 2 
         * has a value of 100 pixels in the parent, but internally stores a value 
         * indicating that it is 50 pixels in height.</p>
         * 
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function get height():Number { return _height; }
        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function set height(value:Number):void {
			if (_height == value) { return; }
			setSize(width, value);
		}

		
        /**
         * Sets a style property on this component instance. This style may 
         * override a style that was set globally.
         *
         * <p>Calling this method can result in decreased performance. 
         * Use it only when necessary.</p>
         *
         * @param style The name of the style property.
         *
         * @param value The value of the style.
         *
         * @includeExample examples/UIComponent.setStyle.1.as -noswf
         * @includeExample examples/UIComponent.setStyle.2.as -noswf
         *
         * @see #getStyle()
         * @see #clearStyle()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function setStyle(style:String, value:Object):void {
			//Use strict equality so we can set a style to null ... so if the instanceStyles[style] == undefined, null is still set.
			//We also need to work around the specific use case of TextFormats
			if (instanceStyles[style] === value && !(value is TextFormat)) { return; }
			instanceStyles[style] = value;
			invalidate(InvalidationType.STYLES);
		}

        /**
         * Deletes a style property from this component instance.
         * <p>This does not necessarily cause the <code>getStyle()</code> method
         * to return a value of <code>undefined</code>.</p>
         *
         * @param style The name of the style property.
         *
         * @see #getStyle()
         * @see #setStyle()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function clearStyle(style:String):void {			
			setStyle(style,null);
		}

        /**
         * Retrieves a style property that is set in the style lookup 
         * chain of the component.
         *
         * <p>The type that this method returns varies depending on the style
         * property that the method retrieves. The range of possible types includes
         * Boolean; String; Number; int; a uint for an RGB color; a Class for a skin; 
         * or any kind of object.</p>
         *
         * <p>If you call this method to retrieve a particular style property, 
         * it will be of a known type that you can store in a variable of the
         * same type. Type casting is not necessary. Instead, a simple assignment 
         * statement like the following will work:</p>
         *
         * <listing>var backgroundColor:uint = getStyle("backgroundColor");</listing>
         *
         * <p>If the style property is not set in the style lookup chain, this method
         * returns a value of <code>undefined</code>. Note that <code>undefined</code> 
         * is a special value that is not the same as <code>false</code>, "", <code>NaN</code>, 
         * 0, or <code>null</code>. No valid style value is ever <code>undefined</code>. 
         * You can use the static method <code>StyleManager.isValidStyleValue()</code> to 
         * test whether a value was set.</p>
         *
         * @param style The name of the style property.
         *
         * @return Style value.
         *
         * @includeExample examples/UIComponent.getStyle.1.as -noswf
         *
         * @see #clearStyle()
         * @see #setStyle()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function getStyle(style:String):Object {
			return instanceStyles[style]
		}

        /**
         * Moves the component to the specified position within its parent. This has
         * the same effect as changing the component location by setting its  
         * <code>x</code> and <code>y</code> properties. Calling this method triggers 
         * the <code>ComponentEvent.MOVE</code> event to be dispatched.      
         *
         * <p>To override the <code>updateDisplayList()</code> method in a
         * custom component, use the <code>move()</code> method instead 
         * of setting the <code>x</code> and <code>y</code> properties. This is because 
         * a call to the <code>move()</code> method causes a <code>move</code> event object
         * to be dispatched immediately after the move operation is complete. In contrast, 
         * when you change the component location by setting the <code>x</code> and <code>y</code> 
         * properties, the event object is dispatched on the next screen refresh.</p>
         *
         * @param x The x coordinate value that specifies the position of the component within its 
         *          parent, in pixels. This value is calculated from the left.
         *
         * @param y The y coordinate value that specifies the position of the component within its 
         *          parent, in pixels. This value is calculated from the top. 
         *
         * @see #x
         * @see #y
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function move(x:Number,y:Number):void {
			_x = x;
			_y = y;
			super.x = Math.round(x);
			super.y = Math.round(y);
			dispatchEvent(new ComponentEvent(ComponentEvent.MOVE));
		}

        /**
         * Gets or sets the x coordinate that represents the position of the component along
         * the x axis within its parent container. This value is described in pixels and is 
         * calculated from the left.
         * 
         * <p>Setting this property causes the <code>ComponentEvent.MOVE</code> event to be dispatched.</p>
         *
         * @default 0
         *
         * @see #move()
         * @see #y
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        override public function get x():Number { return ( isNaN(_x) )?super.x:_x; }

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        override public function set x(value:Number):void {
            move(value,_y);
        }
        /**
         * Gets or sets the y coordinate that represents the position of the component along 
         * the y axis within its parent container. This value is described in pixels and is 
         * calculated from the top.
         * 
         * <p>Setting this property causes the <code>move</code> event to be dispatched.</p>
         *
         * @see #move()
         * @see #x
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @internal [kenos] Should this have a default value of 0, like the x property?
         */
		override public function get y():Number {
			return ( isNaN(_y) )?super.y:_y;
		}

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function set y(value:Number):void {
			move(_x, value);	
		}

        /**
         * Multiplies the current width of the component by a scale factor.
         *
         * @see #scaleY
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function get scaleX():Number {
			return width / startWidth;
		}

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function set scaleX(value:Number):void {
			setSize(startWidth*value, height);
		}

        /**
         * Multiplies the current height of the component by a scale factor.
         *
         * @see #scaleX
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function get scaleY():Number {
			return height / startHeight;
		}

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function set scaleY(value:Number):void {
			setSize(width, startHeight*value);
		}

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function getScaleY():Number {
			return super.scaleY;
		}

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function setScaleY(value:Number):void {
			super.scaleY = value;
		}

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function getScaleX():Number {
			return super.scaleX;
		}

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function setScaleX(value:Number):void {
			super.scaleX = value;
		}

        [Inspectable(defaultValue=true, verbose=1)]
        /**
         * Gets or sets a value that indicates whether the current component instance is visible. 
         * A value of <code>true</code> indicates that the current component is visible; a value of 
         * <code>false</code> indicates that it is not.
         *
         * <p>When this property is set to <code>true</code>, the object dispatches a
         * <code>show</code> event. When this property is set to <code>false</code>, 
         * the object dispatches a <code>hide</code> event. In either case, 
         * the children of the object do not generate a <code>show</code> or 
         * <code>hide</code> event unless the object specifically writes an 
         * implementation to do so.</p>
         *
         * @default true
         *
         * @see #event:hide
         * @see #event:show
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		override public function get visible():Boolean {
			return super.visible;	
		}

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        [Bindable]
		override public function set visible(value:Boolean):void {
			if (super.visible == value) { return; }
			super.visible = value;
			var t:String = (value) ? ComponentEvent.SHOW : ComponentEvent.HIDE;
			
			if (focusManager && focusManager.getFocus() == this && !visible)
			{
				focusManager.setFocus( focusManager.getNextFocusManagerComponent() );
			}
			
			dispatchEvent(new ComponentEvent(t, true));
		}

        /**
         * Validates and updates the properties and layout of this object, redrawing it
         * if necessary. 
         *
         * <p>Properties that require substantial computation are normally not processed
         * until the script finishes executing. This is because setting one property could
         * require the processing of other properties. For example, setting the <code>width</code> 
         * property may require that the widths of the children or parent of the object also 
         * be recalculated. And if the script recalculates the width of the object more than 
         * once, these interdependent properties may also require recalculating. Use this
         * method to manually override this behavior.</p>
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function validateNow():void {
			invalidate(InvalidationType.ALL,false);
			draw();
		}

        /**
         * Marks a property as invalid and redraws the component on the
         * next frame unless otherwise specified.
         *
         * @param property The property to be invalidated.
         *
         * @param callLater A Boolean value that indicates whether the
         *        component should be redrawn on the next frame. The default
         *        value is <code>true</code>.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function invalidate(property:String=InvalidationType.ALL,callLater:Boolean=true):void {
			invalidHash[property] = true;
			if (callLater) { this.callLater(draw); }
		}

		/**
		 * @private (internal)
		 * 
		 * Sets the inherited style value to the specified style name and
		 * invalidates the styles of the component.
		 *
		 * @param name Style name.
		 *
         * @param style Style value.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function setSharedStyle(name:String,style:Object):void {
			if (sharedStyles[name] === style  && !(style is TextFormat)) { return; }
			sharedStyles[name] = style;
			if (instanceStyles[name] == null) {
				invalidate(InvalidationType.STYLES);
			}
		}


        /**
         * Gets or sets a Boolean value that indicates whether the component can receive focus 
         * after the user clicks it. A value of <code>true</code> indicates that it can 
         * receive focus; a value of <code>false</code> indicates that it cannot.
         *
         * <p>If this property is <code>false</code>, focus is transferred to the first
         * parent whose <code>mouseFocusEnabled</code> property is set to <code>true</code>.</p>
         *
         * @default true
         *
         * @see #mouseFocusEnabled
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @internal [kenos] This is described as being the same thing as the property
         *                   below. Is this correct?
         */
		public function get focusEnabled():Boolean {
			return _focusEnabled;
		}
        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set focusEnabled(b:Boolean):void {
			_focusEnabled = b;
		}
		
		[Bindable]
		/**
		 * Setter for the <code>allowDisable</code> property. 
		 * @param value - <code>true</code> if the button can be disabled; <code>false</code> otherwise.
		 * 
		 */		
		public function set shouldDisable (value : String) : void
		{
			if (value == "true")
				_shouldDisable = true;
			else
				_shouldDisable = false;
		}
		
		public function get shouldDisable () : String
		{
			return _shouldDisable.toString();	
		}

        /**
         * Gets or sets a value that indicates whether the component can receive focus after 
         * the user clicks it. A value of <code>true</code> indicates that it can receive 
         * focus; a value of <code>false</code> indicates that it cannot.
         *
         * <p>If this property is <code>false</code>, focus is transferred to the first 
         * parent whose <code>mouseFocusEnabled</code> property is set to <code>true</code>.</p>
         *
         * @default true
         *
         * @see #focusEnabled
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function get mouseFocusEnabled():Boolean {
			return _mouseFocusEnabled;
		}
        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set mouseFocusEnabled(b:Boolean):void {
			_mouseFocusEnabled = b;
		}

        /**
         * Gets or sets the FocusManager that controls focus for this component and its
         * peers. Each pop-up component maintains its own focus loop and FocusManager instance.
         * Use this property to access the correct FocusManager for this component.
         *
         * @return The FocusManager that is associated with the current component; otherwise
         *         this property returns <code>null</code>.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function get focusManager():IFocusManager {
			var o:DisplayObject = this;
			while (o) {
				if (UIComponent.focusManagers[o] != null) {
					return IFocusManager(UIComponent.focusManagers[o]);
				}
				o = o.parent;
			}
			return null;
		}

        /**
         * @private (setter)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function set focusManager(f:IFocusManager):void {
			UIComponent.focusManagers[this] = f;
		}

        /**
         * Shows or hides the focus indicator on this component.
         *
         * <p>The UIComponent class implements this method by creating and positioning
         * an instance of the class that is specified by the <code>focusSkin</code> style.</p>
         *
         * @param focused Indicates whether to show or hide the focus indicator. 
         *                If this value is <code>true</code>, the focus indicator is shown; if this value
         *                is <code>false</code>, the focus indicator is hidden.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function drawFocus(focused:Boolean):void {
			isFocused = focused; // We need to set isFocused here since there are drawFocus() calls from FM.

			//Remove uiFocusRect if focus is turned off
			if (uiFocusRect != null && contains(uiFocusRect)) {
				removeChild(uiFocusRect);
				uiFocusRect = null;
			}
			//Add focusRect to stage, and resize.  If component is focused.
			if (focused) {
				uiFocusRect = getDisplayObjectInstance(getStyleValue("focusRectSkin")) as Sprite;
				if (uiFocusRect == null) { return; }
				var focusPadding:Number = Number(getStyleValue("focusRectPadding"));

				uiFocusRect.x = -focusPadding;
				uiFocusRect.y = -focusPadding;
				uiFocusRect.width = width + (focusPadding*2);
				uiFocusRect.height = height + (focusPadding*2);

				addChildAt(uiFocusRect, 0);
			}
		}

        /**
         * Sets the focus to this component. The component may in turn give the focus
         * to a subcomponent.
         *
         * <p><strong>Note:</strong> Only the TextInput and TextArea components show
         * a focus indicator when this method sets the focus. All components show a focus
         * indicator when the user tabs to the component.</p>
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function setFocus():void {
			if (stage) {
				stage.focus = this;
			}
		}

        /**
         * Retrieves the object that currently has focus. 
         *
         * <p>Note that this method does not necessarily return the component that
         * has focus. It may return the internal subcomponent of the component
         * that has focus. To get the component that has focus, use the
         * <code>focusManager.focus</code> property.</p>
         *
         * @return The object that has focus; otherwise, this method returns <code>null</code>.
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function getFocus():InteractiveObject {
			if (stage) {
				return stage.focus;
			}
			return null;
		}

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function setIMEMode(enabled:Boolean):* {
			if(_imeMode != null) {
				if(enabled) {
					IME.enabled = true;
					_oldIMEMode = IME.conversionMode;
					try {
						if (!errorCaught && IME.conversionMode != IMEConversionMode.UNKNOWN) {
							IME.conversionMode = _imeMode;
						}
						errorCaught = false;
					} catch(e:Error) {
						errorCaught = true;				
						throw new Error("IME mode not supported: " + _imeMode);
					}
				} else {
					if (IME.conversionMode != IMEConversionMode.UNKNOWN && _oldIMEMode != IMEConversionMode.UNKNOWN) {
						IME.conversionMode = _oldIMEMode;
					}
					IME.enabled = false;
				}
			}
		}
		
        /**
         * Initiates an immediate draw operation, without invalidating everything as <code>invalidateNow</code> does.
         *
         * @internal what is "invalidateNow"? i cannot find it in the API.
         * @internal [kenos] Additionally, is the immediate draw operation on this component and does invalidating
         * "everything" mean invalidating the entire component?
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		public function drawNow():void {
			draw();
		}

		[Bindable]
		public function set includeInLayout (value : Boolean) : void
		{
			_includeInLayout = value;
			if(parent.parent){
				(parent.parent as AdvancedLayoutPane).updateIncludeInLayout(this);
				
			}
		}
		
		public function get includeInLayout () : Boolean
		{
			return _includeInLayout;
		}

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function configUI():void {			
			isLivePreview = checkLivePreview();
			var r:Number = rotation;
			rotation = 0;
			var w:Number = super.width;
			var h:Number = super.height;
			super.scaleX = super.scaleY = 1;
			setSize(w,h);
			move(super.x,super.y);
			rotation = r;
			startWidth = w;
			startHeight = h;
			if (numChildren > 0) {
				removeChildAt(0);
			}
		}

        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function checkLivePreview():Boolean {
			if (parent == null) { return false; }
			var className:String;
			try {
				className = getQualifiedClassName(parent);	
			} catch (e:Error) {}
			return (className == "fl.livepreview::LivePreviewParent");	
		}

        // Included the first property as a proper param to enable *some* type checking, and also because it is a required param.		
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
		protected function isInvalid(property:String,...properties:Array):Boolean {
			if (invalidHash[property] || invalidHash[InvalidationType.ALL]) { return true; }
			while (properties.length > 0) {
				if (invalidHash[properties.pop()]) { return true; }
			}
			return false
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function validate():void {
			invalidHash = {};

			//remove draw() from the "call later" queue
			delete this.callLaterMethods[draw]; // Kaltura patch
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function draw():void {
			// classes that extend UIComponent should deal with each possible invalidated property
			// common values include all, size, enabled, styles, state
			// draw should call super or validate when finished updating
			if (isInvalid(InvalidationType.SIZE,InvalidationType.STYLES)) {
				if (isFocused && focusManager.showFocusIndicator) { drawFocus(true); }
			}
			validate();
		}

		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function getDisplayObjectInstance(skin:Object):DisplayObject {
			var classDef:Object = null;
			if (skin is Class) { 
				return (new skin()) as DisplayObject; 
			} else if (skin is DisplayObject) {
				(skin as DisplayObject).x = 0;
				(skin as DisplayObject).y = 0;
				return skin as DisplayObject;
			}
			
			try {
				classDef = getDefinitionByName(skin.toString());
			} catch(e:Error) {
				try {
					classDef = loaderInfo.applicationDomain.getDefinition(skin.toString()) as Object;
				} catch (e:Error) {
					// Nothing
				}
			}
			
			if (classDef == null) {
				return null;
			}
			return (new classDef()) as DisplayObject;
		}
		/**
         * Returns the specified style for a component, considering all styles set on the global level, component level and instance level. 
         *
         * <p>For example, if a component has a style set at the global level to <code>myStyle</code> and you call 
         * <code>getStyle("myStyle")</code> on an instance that does not have an instance setting, it returns null.  If you call 
         * <code>getStyleValue("myStyle")</code>, it returns "myStyle", because it is active at the global level.</p>
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function getStyleValue(name:String):Object {
			return (instanceStyles[name] == null) ? sharedStyles[name] : instanceStyles[name];
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function copyStylesToChild(child:UIComponent,styleMap:Object):void {
			for (var n:String in styleMap) {
				
				child.setStyle(n,getStyleValue(styleMap[n]));
			}
		}

		
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function callLater(fn:Function):void {
//			if (inCallLaterPhase) { return; }  // Kaltura patch

			if (!callLaterMethods[fn]) // Kaltura patch
			{			
				callLaterMethods[fn] = true;
				if (stage != null) {
	                stage.addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true); // Kaltura patch
					stage.addEventListener(Event.RENDER,callLaterDispatcher,false,0,true);
					stage.invalidate();				
				} else {
					addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
				}
			}
		}

		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function callLaterDispatcher(event:Event):void 
		{
			if (event.type == Event.ADDED_TO_STAGE) {
				removeEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher);
                stage.addEventListener(Event.ENTER_FRAME,callLaterDispatcher,false,0,true); // Kaltura patch
				// now we can listen for render event:
				stage.addEventListener(Event.RENDER,callLaterDispatcher,false,0,true);
				stage.invalidate();
				
				return;
			} else {
                event.target.removeEventListener(Event.ENTER_FRAME,callLaterDispatcher); // Kaltura patch
				event.target.removeEventListener(Event.RENDER,callLaterDispatcher);
				if (stage == null) {
					// received render, but the stage is not available, so we will listen for addedToStage again:
					addEventListener(Event.ADDED_TO_STAGE,callLaterDispatcher,false,0,true);
					return;
				}
			}

		    var methods:Dictionary = callLaterMethods;
		    callLaterMethods = new Dictionary(); // Kaltura patch
		    for (var method:Object in methods) 
		    {
				method();
		  		delete(methods[method]);
		    }			
		}



		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function initializeFocusManager():void {
			// create root FocusManager
			if(stage == null) {
				// we don't have stage yet, wait for it
				addEventListener(Event.ADDED_TO_STAGE, addedHandler, false, 0, true);
			} else {
				// we have stage: if not already created, create FocusManager
				createFocusManager();
			}
		}
		/**
         * @private
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		private function addedHandler(evt:Event):void {
			removeEventListener("addedToStage", addedHandler);
			initializeFocusManager();
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function createFocusManager():void {
			if (focusManagers[stage] == null) {
				focusManagers[stage] = new FocusManager(stage);
			}
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function isOurFocus(target:DisplayObject):Boolean {
			return (target == this);
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function focusInHandler(event:FocusEvent):void {
			if (isOurFocus(event.target as DisplayObject)) {
				var fm:IFocusManager = focusManager;
				if (fm && fm.showFocusIndicator) {
					drawFocus(true);
					isFocused = true;
				}
			}
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function focusOutHandler(event:FocusEvent):void {
			if (isOurFocus(event.target as DisplayObject)) {
				drawFocus(false);
				isFocused = false;
			}
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function keyDownHandler(event:KeyboardEvent):void {
			// You must override this function if your component accepts focus
		}
		/**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function keyUpHandler(event:KeyboardEvent):void {
			// You must override this function if your component accepts focus
		}

		

		/**
         *  @private (protected)
		 *  Triggers initialization of this component's accessibility code.
		 *
		 *  <p>This method is called from the constructor via ENTER_FRAME event
		 *  to initialize accessibility support for this component</p>
		 *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0		 
		 */
		protected function hookAccessibility(event:Event):void {
			removeEventListener(Event.ENTER_FRAME, hookAccessibility);
			initializeAccessibility();
		}
		
		/**
         *  @private (protected)
		 *  Initializes this component's accessibility code.
		 *
		 *  <p>This method is called from the constructor to hook in the
		 *  component's accessibility code, which resides in a separate class
		 *  in the fl.accessibility package.
		 *  Each subclass that supports accessibility must override this method
		 *  because the hook-in process uses a different static variable
         *  in each subclass.</p>
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
		 */
		protected function initializeAccessibility():void {
			if (UIComponent.createAccessibilityImplementation != null) {
				UIComponent.createAccessibilityImplementation(this);
			}
		}
		
				
		//////////////////////////////////////////////////////////////////////
		private function onMouseOver(evt:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);	
			
			//use the tooltip manager only if needed
			if(tooltip)
			{
				ToolTipManager.getInstance().showToolTip( tooltip , this );
			}
		}
		
		private function onMouseOut(evt:MouseEvent):void
		{
			//use the tooltip manager only if needed
			if(tooltip && tooltip)
				ToolTipManager.getInstance().destroyToolTip();
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
		}
		//////////////////////////////////////////////////////////////////////

	}

}