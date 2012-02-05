/**
 * demoPlugin
 *
 * @langversion 3.0
 * @playerversion Flash 10.0.1
 * @author Eitan
 */ 
package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.component.visualDemo;
	import com.kaltura.kdpfl.plugin.component.visualDemoMediator;
	
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * This is the real plugin. The KDP initializes it and then calls <code>setSkin</code>.  
	 * @author Eitan
	 * 
	 */	
	public class visualDemoCode extends UIComponent implements IPlugin
	{
		private var _visualDemoMediator : visualDemoMediator;
		private var _configValues:Array = new Array();
		private var _myWidth:Number;
		private var _myHeight:Number;
		
		// Special variables your plugin has to recieve. 
		// Variables must be public strings.
		
		/**
		 * this will be the text in this plugin 
		 */
		public var someVar:String = "default Value";

		/**
		 * this will be the color of the backgroung 
		 */
		public var viewColor:String = "0xFF00FF"; 
		
		/**
		 * this will be the alpha of the backgroung 
		 */		
		public var viewAlpha:String = "0.5"; 
				
		
		
		/** 
		 * Constructor
		 * 
		 */	
		public function visualDemoCode()
		{
		}
		
		
		/**
		 * 
		 * this function creates initialize the new plugin. it pushes all the inialization params into the the mediator 
		 * @param facade
		 * @return 
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{			
			//create the mediator
			_visualDemoMediator = new visualDemoMediator(new visualDemo(Number(viewColor),Number(viewAlpha)));
			// Register the mediator with the PureMVC facade
			facade.registerMediator( _visualDemoMediator);
			// add the plugin's view to the displayList
			addChild( _visualDemoMediator.getViewComponent() as DisplayObject);
			
			// this textfield is for the demo - you can remove it when you implement your own code 
			var tField:TextField = new TextField();
			tField.autoSize = "left";
			var tFormat:TextFormat = new TextFormat ();
			tFormat.size = 16;
			tFormat.color = 0xFFFFFF;
			tField.text = someVar ;
			tField.setTextFormat(tFormat);
			addChild(tField);
		}

		
		/**
		 * KDP calls this interface method in order to set the plugin's skin.
		 * This plugin has no skin, so the implementation is empty. 
		 * @param styleName		name of style to be set
		 * @param setSkinSize
		 * 
		 */
 		public function setSkin(styleName:String, setSkinSize:Boolean=false):void{}

		
		/**
		 * Update the view with the new width & height
		 * 
		 */		
		private function callResize():void
		{
			if(parent)
 			{ 
				_visualDemoMediator.setScreenSize(_myWidth, _myHeight);
			}
		}

		
		/**
		 * Override the width property setter, in order to know when to call <code>callResize</code>
		 * @param value		new width
		 * 
		 */		
		override public function set width(value:Number):void
		{
			_myWidth = value;
			super.width = value;
			callResize();
		}	
		
		
		/**
		 * Override the height property setter, in order to know when to call <code>callResize</code>
		 * @param value 	new height
		 * 
		 */		
		override public function set height(value:Number):void
		{
			_myHeight = value;
			super.height = value;
			callResize();
		}	
		
	}
}
