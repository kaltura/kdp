package {
	//import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.Gigya;
	import com.kaltura.kdpfl.plugin.component.GigyaMediator;
	
	import fl.core.UIComponent;
	import fl.managers.*;
	
	import flash.utils.getDefinitionByName;
	
	import org.puremvc.as3.interfaces.IFacade;

	/**
	 * Actual Plugin 
	 */	
	public class gigyaPluginCode extends UIComponent implements IPlugin {
		private var _gigyaMediator:GigyaMediator;
		private var _configValues:Array = new Array();

		private var _defaultBookmarkURL:String;

		/**
		 * Constructor
		 */
		public function gigyaPluginCode() {
			
		}

		
		public function get defaultBookmarkURL():String
		{
			return _defaultBookmarkURL;
		}
		[Bindable]
		public function set defaultBookmarkURL(value:String):void
		{
			_defaultBookmarkURL = value;
			if (_gigyaMediator)
				_gigyaMediator.defaultBookmarkURL = _defaultBookmarkURL; 
		}

		/**
		 * Initialize the plugin's skin and mediator
		 * @param facade	Application facade
		 */
		public function initializePlugin(facade:IFacade):void {
			//make this module transparent			
			setSkin("clickThrough", true);
			_gigyaMediator = new GigyaMediator(new Gigya());
			if(_defaultBookmarkURL)
				_gigyaMediator.defaultBookmarkURL = _defaultBookmarkURL; 
			//set parameters in mediator
			for (var key:String in _configValues) {
				try {
					_gigyaMediator[key] = _configValues[key];
				}
				catch (err:Error) {	}
			}
			facade.registerMediator(_gigyaMediator);
			addChild(_gigyaMediator.view);
		}


		/**
		 * set skin style 
		 * @param styleName
		 * @param setSkinSize
		 */	
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {
			setStyle("skin", styleName);
		}


		/**
		 * @inheritDoc 
		 */		
		override public function setStyle(type:String, name:Object):void {
			try {
				var cls:Class = getDefinitionByName(name.toString()) as Class;
				super.setStyle(type, cls);
			}
			catch (ex:Error) {
				//trace("Canvas setStyle:",name);
			}
		}

		/**
		 * The Subject line of the email to send 
		 */
		public function set shareEmailSubject(value:String):void {
			_configValues["shareEmailSubject"] = value;
		}

		/**
		 * The content of the email to send 
		 */
		public function set shareEmailBody(value:String):void {
			_configValues["shareEmailBody"] = value;
		}

		/**
		 * Gigya partner id 
		 */
		public function set gigyaPartnerKey(value:String):void {
			_configValues["gigyaPartnerKey"] = value;
		}

		/**
		 * the uiconf that will be the new widget uiconf
		 */
		public function set uiconfId(value:String):void {
			_configValues["uiconfId"] = value;
		}
		/**
		 * The title of the movie
		 */
		public function set title(value:String):void {
			_configValues["title"] = value;
		}
		/**
		 * @inheritDoc 
		 */
		override public function set width(value:Number):void {
			_gigyaMediator.width = value;
		}

		/**
		 * @inheritDoc 
		 */
		override public function set height(value:Number):void {
			_gigyaMediator.height = value;
		}

	}
}
