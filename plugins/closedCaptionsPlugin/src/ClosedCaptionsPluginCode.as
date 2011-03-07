package {
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.component.ClosedCaptions;
	import com.kaltura.kdpfl.plugin.component.ClosedCaptionsMediator;
	import com.kaltura.kdpfl.view.containers.KHBox;
	
	import fl.core.UIComponent;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class ClosedCaptionsPluginCode extends UIComponent implements IPlugin
	{
		private var _attributeClosedCaptions : String;
		private var _closedCaptionsMediator : ClosedCaptionsMediator;
		private var _myWidth:Number = 0;
		private var _myHeight:Number = 0;
		private var _bg : String = "0x000000";
		private var _skin : String = "black";
		private var _opacity : String;
		private var _fontFamily : String;
		private var _ccUrl : String;
		private var _fontsize : int = 14;
		private var _type : String;
		private var _entryID : String;
		/**
		 * Constructor 
		 * 
		 */		
		public function ClosedCaptionsPluginCode()
		{
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

		public function get bg():String
		{
			return _bg;
		}
		[Bindable]
		public function set bg(value:String):void
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
			if (value && value != "")
			{
				_type = value;
				if (ccUrl && ccUrl != "")
				{
					_closedCaptionsMediator.sendNotification("changedClosedCaptions");
				}
			}
		}
		[Bindable]
		public function get entryID():String
		{
			return _entryID;
		}

		public function set entryID(value:String):void
		{
			_entryID = value;
		}

		

	}
}
