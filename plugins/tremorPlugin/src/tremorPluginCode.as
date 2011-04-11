/**
 * tremorPlugin
 *
 * @langversion 3.0
 * @playerversion Flash 9.0.28.0
 * @author Ofer Chesler / www.homsys.co.il
 */ 
package {
	//import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.kdpfl.plugin.component.Tremor;
	import com.kaltura.kdpfl.plugin.component.TremorMediator;
	import com.tremormedia.acudeo.IAdManager;
	import com.tremormedia.acudeo.admanager.AdManager;
	
	import fl.core.UIComponent;
	import fl.managers.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class tremorPluginCode extends UIComponent implements IPlugin, ISequencePlugin
	{
		private var _tremorMediator : TremorMediator;
		private var _configValues:Array = new Array();
		private var _myWidth:Number;
		private var _myHeight:Number;
		
		public var tracesVolume:String = "ERROR";
		
		public var preSequence : int;
		public var postSequence : int;
		public var progId : String;
		
		private var _adManager:IAdManager;
				
		/** 
		 * Constructor
		 * 
		 */	
		public function tremorPluginCode()
		{
			Security.allowDomain("http://objects.tremormedia.com/");
			_adManager = AdManager.getInstance();
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
			// Register Mideator
			_tremorMediator = new TremorMediator( new Tremor(_adManager),progId,tracesVolume);
			_tremorMediator.preSequence = preSequence;
			_tremorMediator.postSequence = postSequence;
			
			//set parameters in mediator
			for (var key:String in _configValues)
			{
				try
				{
			   		_tremorMediator[key] =  _configValues[key];
			 	}catch(err:Error){}
			}	
			facade.registerMediator( _tremorMediator);
			addChild( _tremorMediator.view);
		}


 		public function setSkin(styleName:String, setSkinSize:Boolean=false):void{}

		private function updateSizes():void
		{
			callLater(callResize);
		}

		/**
		 *  
		 * Update the tremor player that the size of the stage changed (and it needs to fit)
		 * @param 
		 * @return 
		 * 
		 */		
		private function callResize():void
		{
			if(parent)
 			{ 
				_tremorMediator.setScreenSize(_myWidth, _myHeight);
			}
		}

		/**
		 *  
		 * Override the width property, in order to knwo when to call callResize
		 * @param value the new width
		 * @return 
		 * 
		 */		

		override public function set width(value:Number):void
		{
			_myWidth = value;
			super.width = value;
			updateSizes();
		}	
		
		/**
		 *  
		 * Override the height property, in order to knwo when to call callResize
		 * @param value the new height
		 * @return 
		 * 
		 */		

		override public function set height(value:Number):void
		{
			_myHeight = value;
			super.height = value;
			updateSizes();
		}	
		
		
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
			_tremorMediator.forceStart();
		}
		public function get sourceType () : String
		{
			return "url";
		}
		
	}
}
