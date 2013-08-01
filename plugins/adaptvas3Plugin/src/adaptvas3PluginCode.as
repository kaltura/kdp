package {
	//import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.KPluginEvent;
	import com.kaltura.kdpfl.plugin.component.AdaptvAS3Mediator;
	import com.kaltura.kdpfl.plugin.component.AdaptvAS3Player;
	
	import fl.core.UIComponent;
	import fl.managers.*;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class adaptvas3PluginCode extends UIComponent implements IPlugin, ISequencePlugin
	{
		public var preSequence : int;
		public var postSequence : int;
		
		private var _adaptvas3Mediator : AdaptvAS3Mediator;
		private var _adaptvAS3Player : AdaptvAS3Player ;
		private var _configValues:Array = new Array();
		private var _context:Object;
		
		private var _loadError:Boolean;
		private var _facade:IFacade;
		/**
		 * Constructor 
		 * 
		 */		
		public function adaptvas3PluginCode()
		{
			trace('adaptv as3 v2.0');
		}
		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			setSkin("clickThrough",true); //make this module transparent
			_adaptvAS3Player = new AdaptvAS3Player();
			_adaptvAS3Player.addEventListener( AdaptvAS3Player.ADAPTV_ADMANAGER_LOADED , onAdManagerLoaded );
			_adaptvAS3Player.addEventListener( AdaptvAS3Player.ADAPTV_ADMANAGER_LOAD_FAILED , onAdManagerLoadFailed );
			_adaptvAS3Player.start();
			_facade = facade;
		}
		
		private function removeAdaptvListeners() : void 
		{
			_adaptvAS3Player.removeEventListener ( AdaptvAS3Player.ADAPTV_ADMANAGER_LOADED , onAdManagerLoaded );
			_adaptvAS3Player.removeEventListener ( AdaptvAS3Player.ADAPTV_ADMANAGER_LOAD_FAILED , onAdManagerLoadFailed );
		}
		
		private function onAdManagerLoaded (e : Event) : void
		{
			removeAdaptvListeners();
			
			_adaptvas3Mediator = new AdaptvAS3Mediator(  _adaptvAS3Player );
			_adaptvas3Mediator.preSequence = preSequence;
			_adaptvas3Mediator.postSequence = postSequence;
			
			//set parameters in mediator
			for (var key:String in _configValues)
			{
				try
				{
					_adaptvas3Mediator[key] =  _configValues[key];
				}
				catch(err:Error)
				{	
				}
			}	 
			if(_context)
			{
				_adaptvAS3Player.context = _context;
			}
			
			_facade.registerMediator( _adaptvas3Mediator);
			addChild( _adaptvas3Mediator.view );
			
			dispatchEvent( new KPluginEvent( KPluginEvent.KPLUGIN_INIT_COMPLETE) );
			
		}
		
		private function onAdManagerLoadFailed (e : Event) : void
		{
			removeAdaptvListeners();
			_loadError = true;
			dispatchEvent( new KPluginEvent( KPluginEvent.KPLUGIN_INIT_FAILED) );
		}
		
		
		
		public function set context(value:Object):void
		{
			//parse context - asuming this is its stracture: 
			// context=key1:val1,key2:val2,key3:val3
			value = unescape(String(value));
			
			//split "," 
			var items:Array = String(value).split(",");
			var o:Object = new Object();
			 
			
			for(var i:int = 0 ; i< items.length ; i++)
			{
				
				var keyval:Array = items[i].toString().split("=");
				var key:String  = keyval[0];
				var val:String  = keyval[1];
				o[key] = val;
			}
			
			_context = o;
		}

		public function set key(value:Object):void
		{
			_configValues["key"] = value;
		}

		public function set zone(value:Object):void
		{
			_configValues["zone"] = value;
		}

		public function set keywords(value:Object):void
		{
			_configValues["keywords"] = value;
		}
		public function set pageUrlOv(value:Object):void
		{
			_configValues["pageUrlOv"] = value;
		}

		public function set categories(value:Object):void
		{
			_configValues["categories"] = value;
		}
		public function set companionId(value:Object):void
		{
			_configValues["companionId"] = value;
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
			//setStyle("skin", styleName);
		} 
			
		//ISequencePlugin implementation
		
		//Implementation of the ISequencePlugin methods
		public function hasMediaElement () : Boolean
		{
			return false;
		}
		public function get entryId () : String
		{
			return "null";
		}
		
		public function get mediaElement () : Object
		{
			return null;
		}
		public function hasSubSequence () : Boolean
		{
			return false;
			
		}
		public function subSequenceLength () : int
		{
			return 0;	
		}
		public function get preIndex () : Number
		{
			return preSequence;
		}
		public function get postIndex () : Number
		{
			return postSequence;
		}
		
		public function start () : void
		{
			if (_loadError) {
				_facade.sendNotification( NotificationType.SEQUENCE_ITEM_PLAY_END );
			} else {
				_adaptvas3Mediator.forceStart();
			}
		}
		public function get sourceType () : String
		{
			return "url";
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			if (_adaptvAS3Player)
				_adaptvAS3Player.width = value
		}
		override public function set height(value:Number):void
		{
			super.height = value;
			if (_adaptvAS3Player)
				_adaptvAS3Player.height = value
		}
		
	}
}
