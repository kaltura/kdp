package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.ClosedCaptions;
	import com.kaltura.kdpfl.plugin.component.ClosedCaptionsMediator;
	import com.kaltura.kdpfl.view.containers.KHBox;
	
	import fl.core.UIComponent;
	import fl.data.DataProvider;
	
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class ClosedCaptionsPluginCode extends UIComponent implements IPlugin
	{
		private var _attributeClosedCaptions : String;
		private var _closedCaptionsMediator : ClosedCaptionsMediator;
		private var _myWidth:Number = 0;
		private var _myHeight:Number = 0;
		private var _bg : Number = 0x000000;
		private var _skin : String;
		private var _opacity : Number;//DEPRECATED
		private var _fontFamily : String;
		private var _ccUrl : String;
		private var _fontsize : int = 14;
		private var _type : String;
		private var _fullscreenRatio:Number;
		
		//New properties - Eagle development
		private var _availableCCFiles : Array;
		private var _availableCCFilesLabels : DataProvider;
		private var _currentCCFileIndex : int;
		private var _fontColor : Number = 0xFFFFFF;
		
		
		/**
		 * Constructor 
		 * 
		 */		
		public function ClosedCaptionsPluginCode()
		{
			_availableCCFiles = new Array();
			_availableCCFilesLabels = new DataProvider();
		}

		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			_closedCaptionsMediator = new ClosedCaptionsMediator(this, new ClosedCaptions() );

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

		public function get opacity():Number
		{
			return _opacity;
		}
		[Bindable]
		public function set opacity(value:Number):void
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


	}
}
