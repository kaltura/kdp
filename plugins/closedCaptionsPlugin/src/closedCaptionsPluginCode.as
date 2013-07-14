package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.ClosedCaptions;
	import com.kaltura.kdpfl.plugin.component.ClosedCaptionsMediator;
	import com.kaltura.kdpfl.view.containers.KHBox;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.IFacade;
 
	public class closedCaptionsPluginCode extends UIComponent implements IPlugin
	{
		private var _attributeClosedCaptions : String;
		private var _closedCaptionsMediator : ClosedCaptionsMediator;
		private var _myWidth:Number = 0;
		private var _myHeight:Number = 0;
		private var _bg : Number = 0x000000;
		private var _skin : String;//DEPRECATED
		private var _opacity : String;//DEPRECATED
		private var _fontFamily : String;
		private var _ccUrl : String;
		private var _fontsize : int = 14;
		private var _type : String;
		private var _fullscreenRatio:Number;
		
		//New properties - Eagle development
		private var _useBG : Boolean;
		private var _availableCCFiles : Array;
		private var _availableCCFilesLabels : DataProvider = new DataProvider();;
		private var _currentCCFileIndex : int;
		private var _fontColor : Number = 0xFFFFFF;
		[Bindable]
		public var hasCaptions:Boolean;
		[Bindable]
		public var sortAlphabetically:Boolean;

		public var defaultLanguageKey:String = "";
		
		//Glow parameters 
		private var _useGlow : Boolean;
		private var _glowColor : Number;
		private var _glowBlur : int;
		
		//String which disables the captions in the player.
		private var _noneString : String = "None";
	
		/**
		 * Constructor 
		 * 
		 */		
		public function closedCaptionsPluginCode()
		{
			_availableCCFiles = new Array();
			//_availableCCFilesLabels = new DataProvider();
		}

		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			_closedCaptionsMediator = new ClosedCaptionsMediator(this, new ClosedCaptions(),sortAlphabetically );

			facade.registerMediator( _closedCaptionsMediator);
			
			addChild( _closedCaptionsMediator.view );
						
			//For testing:
			
			//availableCCFiles = [{url: "http://localhost/tt-captions.xml", type:"tt", label:"CC - TT", isDefault: true}, {type:"tx3g", label:"CC-embedded", trackId:"2"}]
		}
		
 		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			
		}
 		
		
		override public function set width(value:Number):void
		{
			_myWidth = value;
		}			
		
		override public function get width():Number
		{
			return _myWidth;
		}			
		
		override public function set height(value:Number):void
		{
			_myHeight = value;
			_closedCaptionsMediator.setScreenSize(_myWidth, _myHeight);
		}			
		
		override public function get height():Number
		{
			return _myHeight;
		}			

		public function get bg():Number
		{
			return _bg;
		}
		[Bindable]
		public function set bg(value:Number):void
		{
			_bg = value;
		}

		public function get skin():String
		{
			return _skin;
		}
		[Bindable]
		public function set skin(value:String):void
		{
			_skin = value;
		}

		public function get opacity():String
		{
			return _opacity;
		}
		[Bindable]
		public function set opacity(value:String):void
		{
			_opacity = value;
		}

		public function get fontFamily():String
		{
			return _fontFamily;
		}
		[Bindable]
		public function set fontFamily(value:String):void
		{
			_fontFamily = value;
		}
		[Bindable]
		public function get ccUrl():String
		{
			return _ccUrl;
		}

		public function set ccUrl(value:String):void
		{
 			if (value != _ccUrl)
			{
				_ccUrl = value ? value : "";
				if (type && type != "")
					_closedCaptionsMediator.sendNotification("changedClosedCaptions");
			}
		}
		[Bindable]
		public function get fontsize():int
		{
			return _fontsize;
		}

		public function set fontsize(value:int):void
		{
			_fontsize = value;
		}
		[Bindable]
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{

 			_type = value ? value : "";
 			if (ccUrl && ccUrl != "")
			{
				_closedCaptionsMediator.sendNotification("changedClosedCaptions");
			}
		}
		[Bindable]
		public function get availableCCFiles():Array
		{
 			return _availableCCFiles;
		}

		public function set availableCCFiles(value:Array):void
		{
			_availableCCFiles = value;
			_closedCaptionsMediator.sendNotification( "newClosedCaptionsData" );
		}
		[Bindable]
		public function get availableCCFilesLabels():DataProvider
		{
			return _availableCCFilesLabels;
		}

		public function set availableCCFilesLabels(value:DataProvider):void 
		{
			_availableCCFilesLabels = value;
		}
		[Bindable]
		public function get fullscreenRatio():Number
		{
			return _fullscreenRatio;
		}

		public function set fullscreenRatio(value:Number):void
		{
			_fullscreenRatio = value;
		}

		public function get fontColor():Number
		{
			return _fontColor;
		}

		public function set fontColor(value:Number):void
		{
			_fontColor = value;
		}
		[Bindable]
		public function get currentCCFileIndex():int
		{
			return _currentCCFileIndex;
		}

		public function set currentCCFileIndex(value:int):void
		{
			_currentCCFileIndex = value;
		}
		[Bindable]
		public function get noneString():String
		{
			return _noneString;
		}

		public function set noneString(value:String):void
		{
			_noneString = value;
		}
		
		[Bindable]
		public function get glowBlur():int
		{
			return _glowBlur;
		}

		public function set glowBlur(value:int):void
		{
			_glowBlur = value;
		}
		
		[Bindable]
		public function get glowColor():Number
		{
			return _glowColor;
		}

		public function set glowColor(value:Number):void
		{
			_glowColor = value;
		}
		[Bindable]
		public function get useBG():Boolean
		{
			return _useBG;
		}

		public function set useBG(value:Boolean):void
		{
			_useBG = value;
		}
		[Bindable]
		public function get useGlow():Boolean
		{
			return _useGlow;
		}

		public function set useGlow(value:Boolean):void
		{
			_useGlow = value;
		}

	}
}
