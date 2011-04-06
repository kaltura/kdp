package {
	//import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.component.AdptvAS3;
	import com.kaltura.kdpfl.plugin.component.AdaptvAS3Mediator;
	
	import fl.core.UIComponent;
	import fl.managers.*;
	
	import flash.system.Security;
	import flash.utils.getDefinitionByName;
	
	import org.puremvc.as3.interfaces.IFacade;

	public class adaptvas3PluginCode extends UIComponent implements IPlugin, ISequencePlugin
	{
		public var preSequence : int;
		public var postSequence : int;
		
		private var _adaptvas3Mediator : AdaptvAS3Mediator;
		private var _configValues:Array = new Array();
		/**
		 * Constructor 
		 * 
		 */		
		public function adaptvas3PluginCode()
		{
		}
		/**
		 *  
		 * @param facade
		 * 
		 */		
		public function initializePlugin( facade : IFacade ) : void
		{
			setSkin("clickThrough",true); //make this module transparent			
			_adaptvas3Mediator = new AdaptvAS3Mediator( new AdptvAS3() );
		
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
			facade.registerMediator( _adaptvas3Mediator);
			addChild( _adaptvas3Mediator.view );
		}

		public function set context(value:Object):void
		{
			_configValues["context"] = value;
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
		
		override public function set width(value:Number):void
		{
			super.width = value;
			if(_adaptvas3Mediator)
				_adaptvas3Mediator.setScreenSize(super.width, super.height);
		}	
		
		override public function set height(value:Number):void
		{
			super.height = value;
			if(_adaptvas3Mediator)
				_adaptvas3Mediator.setScreenSize(super.width, super.height);
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
			_adaptvas3Mediator.forceStart();
		}
		public function get sourceType () : String
		{
			return "url";
		}
		
	}
}
