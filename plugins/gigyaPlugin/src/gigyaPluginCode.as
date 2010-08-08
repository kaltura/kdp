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


		/**
		 * Constructor
		 */
		public function gigyaPluginCode() {
			
		}


		/**
		 * Initialize the plugin's skin and mediator
		 * @param facade	Application facade
		 */
		public function initializePlugin(facade:IFacade):void {
			//make this module transparent			
			setSkin("clickThrough", true);

			_gigyaMediator = new GigyaMediator(new Gigya());
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
