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
	
	import flash.events.Event;
	import flash.system.Security;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public dynamic class tremorPluginCode extends UIComponent implements IPlugin, ISequencePlugin
	{
		private var _tremorMediator : TremorMediator;
		private var _configValues:Array = new Array();
		private var _myWidth:Number;
		private var _myHeight:Number;
		private var _params:Object;
		
		
		public var escapeAdRequest:Boolean = true;
		
		public var tracesVolume:String = "ERROR";
		/**
		 * Container for internal companion ads 
		 */
		public var companionHolder:UIComponent;
		/**
		 * Hide internal companion  
		 */
		public var hideInternalCompanion:Boolean  = true;
		
		/**
		 * flag for showing/not showing countdown text 
		 */
		public var displayAdCountdown:String  = "false";
		/**
		 * Text for showing when video ad is running 
		 * [adRemaining] will be replaced at runtime with real value
		 */
		public var adCountdownDisplayText:String  = "Advertisement: Your video will resume in [adRemaining] seconds.";
		// location of internal companion ads
		public var internalCompanionX:Number = 0;
		public var internalCompanionY:Number = 0;
		
		public var preSequence : int;
		public var postSequence : int;
		
		[Bindable]
		public var createdAtOffset : String = "0";
		
		[Bindable]
		public var updatedAtOffset : String = "0";
		
		[Bindable]
		public var startDateOffset : String = "0";
		
		
		public var progId : String;
		public var maxAgeForAds : int = 0;
		
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
			_tremorMediator = new TremorMediator( new Tremor(_adManager),progId,tracesVolume,companionHolder);
			_tremorMediator.escapeAdRequest = escapeAdRequest;
			_tremorMediator.dispatcher.addEventListener(TremorMediator.NEW_ENTRY,onNewEntry);
			_tremorMediator.displayAdCountdown = displayAdCountdown;
			_tremorMediator.adCountdownDisplayText = adCountdownDisplayText;
			_tremorMediator.hideInternalCompanion = hideInternalCompanion;
			_tremorMediator.internalCompanionX = internalCompanionX;
			_tremorMediator.internalCompanionY = internalCompanionY;
			_tremorMediator.dispatcher.addEventListener(TremorMediator.FETCH_PARAMS , buildParams);
			//building dynamic params
			try{
				buildParams();
			} catch (e:Error)
			{
				trace("Tremor plugin - build params dynamic error ");
				//failed - reset params
				_params = null;
			}

			_tremorMediator.preSequence = preSequence;
			_tremorMediator.postSequence = postSequence;
			_tremorMediator.maxAgeForAds = maxAgeForAds; 
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

 		public function onNewEntry(event:Event = null):void
		{
			createdAtOffset = _tremorMediator.createdAtOffset.toString();
			startDateOffset = _tremorMediator.startedAtOffset.toString();
			updatedAtOffset = _tremorMediator.updatedAtOffset.toString();
		}
		/**
		 * Handles dynamic data. This is an example of 2 dynamic data in the tremor xml node: 
		 * 
		 *  here's an example of a URL in Tremor: 
		 * 
		 * 	http://ad.doubleclick.net/client/ibs.[site]/topic.[topic]
		 * 	
		 * 	paramKey1="site" //name of param as it appears on the Tremor URL 
		 *  paramValue1="{mediaProxy.entryMetadata.site}" //where to take the data from. static String or a KDP expression 
		 *  paramDefaultValue1="defaultSite" //what to place if there is no return value on the value (paramValueN)
		 *  removeIfNullParam1="false" 	// if there is no value should this param be ommited from the dynamic list. 
		 * 							   	// if this is set to true this will override the paramDefaultValueN attribute 
		 * 								// if this is set to false the paramDefaultValueN will be used 
		 *  
		 *  
		 *  paramKey2="topic" 
		 *  paramValue2="{mediaProxy.entryMetadata.topic}"
		 *  paramDefaultValue2="defString"
		 *  removeIfNullParam2="true"
		 * 
		 *	
		 */
 		public function buildParams(event:Event = null):void
		{
			for (var s:String in this)
			{
				// search for members with 'Value' string that matches the prefix of this event
				if( s.indexOf("paramKey")>-1)
				{
					// get the index
					var propNumber:String = s.split("paramKey")[1].toString();
					if (!_params) 
						_params = new Object();
					//trace(s,this["paramValue"+propNumber]);
					// set default value 
					if(this.hasOwnProperty("paramDefaultValue"+propNumber))
						_params[this[s]] = this["paramDefaultValue"+propNumber];
					// set value 
					if(this["paramValue"+propNumber])
						_params[this[s]] = this["paramValue"+propNumber];
										
					//remove if null 
					if(this.hasOwnProperty("removeIfNullParam"+propNumber) && this["removeIfNullParam"+propNumber] == "true" && !this["paramValue"+propNumber]  )
					{
						trace("delete",s , _params[this[s]] )
						delete _params[this[s]];
					}

				}
			}
			
			if(_params)
				_tremorMediator.params = _params;
			
			
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
