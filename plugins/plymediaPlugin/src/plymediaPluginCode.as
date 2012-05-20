package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.Plymedia;
	import com.kaltura.kdpfl.plugin.component.PlymediaMediator;

	import fl.core.UIComponent;
	import fl.managers.*;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	import org.puremvc.as3.interfaces.IFacade;

	public class plymediaPluginCode extends UIComponent implements IPlugin {
		private var _plymediaMediator:PlymediaMediator;
		private var _configValues:Array = new Array();
		private var _myWidth:Number;
		private var _myHeight:Number;
		private var _plymediaSkin:String;

		/**
		 * show control bar button
		 * */
		[Bindable]
		public var subtitlesButtonVisible:Boolean = false;

		/**
		 * if true, host will be taken from falshvars.host
		 * otherwise the host will be www.kaltura.com
		 * */
		public var useHost:Boolean = false;

		/**
		 * by default the onscreen Plymedia menu will be visible
		 * */
		public var menuVisible:Boolean = true;

		/**
		 * comma separated plymedia language codes
		 * */
		public var languages:String = "";

		/**
		 * if true then language will be displayed from the begining,
		 * otherwise the video will start with no subtitles
		 * */
		public var displaySubsOnStart:Boolean = true;


		/**
		 * Constructor
		 *
		 */
		public function plymediaPluginCode() {
		}


		/**
		 *
		 * @param facade
		 *
		 */
		public function initializePlugin(facade:IFacade):void {
			// Register Proxy
			//facade.retrieveProxy(

			// Register Mideator
			_plymediaMediator = new PlymediaMediator(menuVisible, languages, displaySubsOnStart, useHost, new Plymedia());
			_plymediaMediator.view.addEventListener("subtitlesButtonChange", updateSubtitlesButtonView);
			if (_plymediaSkin)
				_plymediaMediator.plySkin = _plymediaSkin;

			//set parameters in mediator
			for (var key:String in _configValues) {
				try {
					_plymediaMediator[key] = _configValues[key];
				}
				catch (err:Error) {
				}
			}

//			_plymediaMediator.init(facade);
			facade.registerMediator(_plymediaMediator);
			addChild(_plymediaMediator.view);
		}


		public function updateSubtitlesButtonView(event:Event):void {
			subtitlesButtonVisible = _plymediaMediator.subtitlesButtonVisible;
		}


		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {
			setStyle("skin", styleName);
		}


		override public function setStyle(type:String, name:Object):void {
			try {
				var cls:Class = getDefinitionByName(name.toString()) as Class;
				super.setStyle(type, cls);
			}
			catch (ex:Error) {
				//trace("Canvas setStyle:",name);
			}
		}


		override public function set width(value:Number):void {
			super.width = value;
			_myWidth = value;
			if (_plymediaMediator)
				_plymediaMediator.setScreenSize(_myWidth, _myHeight);
		}


		override public function set height(value:Number):void {
			super.height = value;
			_myHeight = value;
			if (_plymediaMediator)
				_plymediaMediator.setScreenSize(_myWidth, _myHeight);
		}


		[Bindable]
		public function get plymediaSkin():String {
			return _plymediaSkin;
		}


		/**
		 * This getter/setter is for the plymedia custom skin.
		 * @value
		 */
		public function set plymediaSkin(value:String):void {
			_plymediaSkin = value;
			if (_plymediaMediator)
				_plymediaMediator.setPlymediaSkin(value);
		}


		public function set partner(value:Object):void {
			_configValues["partner"] = value;
		}

	}
}
