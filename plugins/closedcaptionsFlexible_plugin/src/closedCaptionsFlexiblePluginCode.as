package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.ClosedCaptions;
	import com.kaltura.kdpfl.plugin.component.ClosedCaptionsMediator;
	import com.kaltura.kdpfl.view.containers.KHBox;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class closedCaptionsFlexiblePluginCode extends UIComponent implements IPlugin
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
		
		private var _entryID : String;
		//New properties - Eagle development
		private var _useBG : Boolean;
		private var _availableCCFiles : Array;
		private var _availableCCFilesLabels : DataProvider = new DataProvider();
		private var _currentCCFileIndex : int;
		
		private var _timeOffset : int = 0;
		
		private var _fontColor : Number = 0xFFFFFF;
		[Bindable]
		public var hasCaptions:Boolean;
		
		//Glow parameters
		private var _useGlow : Boolean;
		private var _glowColor : Number;
		private var _glowBlur : int;
		
		//String which disables the captions in the player.
		private var _noneString : String = "None";
		
		private var _hideClosedCaptions:Boolean = false;
		
		/**
		 * Constructor 
		 * 
		 */		
		public function closedCaptionsFlexiblePluginCode()
		{
			_availableCCFiles = new Array();
			//_availableCCFilesLabels = new DataProvider();
		}
		
		[Bindable]
		/**
		 * determines whether to display closedCaptions
		 * */
		public function get hideClosedCaptions():Boolean
		{
			return _hideClosedCaptions;
		}

		public function set hideClosedCaptions(value:Boolean):void
		{
			_hideClosedCaptions = value;
			if (_closedCaptionsMediator)
				_closedCaptionsMediator.hideClosedCaptions = _hideClosedCaptions;
		}

		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			_closedCaptionsMediator = new ClosedCaptionsMediator(this, new ClosedCaptions() );
			_closedCaptionsMediator.hideClosedCaptions = _hideClosedCaptions;
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
			_closedCaptionsMediator.setScreenSize(_myWidth, _myHeight);
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
		/**
		 * array of currently available CC files
		 * @return 
		 * 
		 */	
		
		
		
		
		
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
		/**
		 * Array of the cc labels to be used as Data Provider for the CC combo box in the UI.
		 * @return 
		 * 
		 */		
		
		
		
		
		
		public function get availableCCFilesLabels():DataProvider
		{
			return _availableCCFilesLabels;
		}
		
		public function set availableCCFilesLabels(value:DataProvider):void
		{
			_availableCCFilesLabels = value;
		}
		[Bindable]
		/**
		 * Parameter allowing the user to set the ratio of the closed captions size change
		 * when the player goes into fullscreen mode. 
		 * @return 
		 * 
		 */	
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
		/**
		 * Parameter signifying the time offset of the CC file 
		 * @return 
		 * 
		 */		
		public function get timeOffset():int
		{
			return _timeOffset;
		}
		
		public function set timeOffset(value:int):void	
		{
			
			_timeOffset = value;
		}
		
		[Bindable]
		/**
		 * The currently selected CC file (if the selected file was set from the cookie 
		 * or from the <code>isDefault</code> parameter found on the KalturaCaptionAsset object.
		 * @return 
		 * 
		 */	
		
		
		
		
		
		
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
