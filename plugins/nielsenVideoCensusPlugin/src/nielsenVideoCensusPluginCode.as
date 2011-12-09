package
{
	import com.kaltura.kdpfl.model.type.NotificationType;
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.IPluginFactory;
	import com.kaltura.kdpfl.plugin.component.NielsenVideoCensusMediator;
	import com.yahoo.astra.fl.controls.AbstractButtonRow;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public dynamic class nielsenVideoCensusPluginCode extends Sprite implements IPlugin
	{
		private var _nielsenMediator:NielsenVideoCensusMediator;
		private var _customEvents	:	Array;	
		public function set customEvents(val:String):void{
			_customEvents		= val.split(",");
		}
		
		public var requestMethod	: String	= "queryString";
		
		//ads (st,a for ads   or  st,c for content streams)
		public var c3	:	String;
		
		//cookie check (cc=1)
		public var cc	:	String;
		
		//Show name (encoded)
		public var cg	:	String;
		
		public var clientId: String;
		public var videoCensusId:String;
		//video title (encoded  dav0-encoded title)
		public var tl	:	String;
		public var lp	:	String;
		public var ls	: 	String;
		public var serverUrl:String;
		private var _facade:IFacade;
		private var _eventData:Object;
		private var _paramsMap:Object =	{videoCensusId:"C6", 
													clientId:"CI",
													cg:"CG",
													tl:"TL",
													lp:"LP",
													ls:"LS",
													cc:"CC",
													rnd:"RND",
													c3:"C3"};
		
		
		public function nielsenVideoCensusPluginCode()
		{
			super();
		}
		
		
		
		public function initializePlugin(facade:IFacade):void {
			_facade				= facade;
			_nielsenMediator 	= new NielsenVideoCensusMediator(_customEvents);
			_nielsenMediator.eventDispatcher.addEventListener(NielsenVideoCensusMediator.DISPATCH_BEACON, onBeacon);
			//_nielsenMediator.eventDispatcher.addEventListener(NielsenVideoCensusMediator.AD_START, onAdStart);
			
			facade.registerMediator(_nielsenMediator);
			
		}
		
		/**
		 * Do nothing.
		 * No implementation required for this interface method on this plugin.
		 * @param styleName
		 * @param setSkinSize
		 */
		public function setSkin(styleName:String, setSkinSize:Boolean = false):void {}
		
		private var loader : URLLoader;
		
		private function onAdStart(e:Event):void{
			onBeacon();
		}
		
		private function onCuePoints(e:Event):void{_eventData			= _nielsenMediator.eventData;}
		
		private function createQueryString(url:String, key:String, val:String):String{
			url 	= url.concat(key,"=",val,"&");
			return url;
		}
		
		public function onBeacon(e:Event=null):void{
			var url	: String				= (serverUrl)?serverUrl+"cgi-bin/m":"http://secure-us.imrworldwide.com/cgi-bin/m";

			var vars : URLVariables	 		= new URLVariables();
			loader							= new URLLoader();
			url +=	"?";
			for(var s:String in this)
				if(s.indexOf("c") == 0 && s.length == 2){
					url		= createQueryString(url,s,this[s]);
				}
	
			
			//CC - Cookie check. Hard coded to cc=1
			url=createQueryString(url,_paramsMap.cc,"1");
			
			//TL -Video title. Should be prefixed by “dav0-“. Percent (%) encode the TL value after the “dav0-“ previx.
			//Encoding prevents restricted charactrs from impacting any processing scripts
			if(tl)url=createQueryString(url,_paramsMap.tl,"dav0-"+tl);
			
			//CG - Show name or category name TV networks required to use program name here 
			//The entire cg value should be percent (%) encoded
			if(cg)url=createQueryString(url,_paramsMap.cg,cg);
			
			//CI -Client ID provider by Nielsen
			if(clientId)url=createQueryString(url,_paramsMap.clientId,clientId);
			
			//C6 -Video Census ID
			if(videoCensusId)url=createQueryString(url,_paramsMap.videoCensusId,videoCensusId);
			
			//RND - Random number. Must be dynamic per event. Do not use scientific notation
			url=createQueryString(url,_paramsMap.rnd,getRndNumber());
			
			//LP - Long play indicator
			//Four sub parameters:
			//1. Short form/long form override. The publisher can explicitly state the this is a short form or long form clip. If set to SF then parameters 2 and 4 will be ignored.
			//2. Current segment/chapter number. Set to 0 if not known
			//3. Length in seconds of this segment/chapter. Set to 0 if not known
			//4. Anticipated total number of segments/chapters for this episode. Set to 0 if not known
			if(lp)url=createQueryString(url,_paramsMap.lp,getLongPlayIndicator());

			
			if(c3)url=createQueryString(url,_paramsMap.c3,c3);
			
			//LS -Live stream indicator. One parameter:
			//1. Set to Y if this is a live stream
			//2. Set to N if this is a standard video on demand stream
			if(ls)url=createQueryString(url,_paramsMap.ls,getLiveStreamIndicator());
			
			//C3  - Ad indicator. If this parameter is omitted then the stream will be assumed to be content.
			//url = createQueryString(url,_paramsMap.c3,getAdIndicator());
			
			
			
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			var request : URLRequest  		= new URLRequest(url);
			request.data				= vars;
			
			if(requestMethod	== "post")
				request.method				= URLRequestMethod.POST;
			
			loader.load(request);
		}
		
		private function getRndNumber():String{
			return String(Math.random()).split(".")[1];
		}
		
		//C3  - Ad indicator. If this parameter is omitted then the stream will be assumed to be content.
		private function getAdIndicator():String{
			return "";//("st,c":"st,a");
		}
		
		//LS -Live stream indicator. One parameter:
		//1. Set to Y if this is a live stream
		//2. Set to N if this is a standard video on demand stream
		private function getLiveStreamIndicator():String{
			return (_facade.retrieveProxy("mediaProxy")["vo"]["isLive"])?"Y":"N";
		}
		
		//LP - Long play indicator
		//Four sub parameters:
		//1. LF & SF Short form/long form override. The publisher can explicitly state this is a short form or long form clip. If set to SF then parameters 2 and 4 will be ignored.
		//2. LF Current segment/chapter number. Set to 0 if not known
		//3. LF & SF Length in seconds of this segment/chapter. Set to 0 if not known
		//4. LF Anticipated total number of segments/chapters for this episode. Set to 0 if not known
		//lp=LF,3,582,6
		private function getLongPlayIndicator():String{
			var value:String	= "";
			//get clip type
				value 	+=	lp.toUpperCase()+",";
				
				if(lp.toUpperCase() == "LF")
					value	+=  _nielsenMediator.eventData["segmentId"]+",";
				
				value	+=	_nielsenMediator.eventData["length"];
				
				if(lp.toUpperCase() == "LF")
					value	+=	","+_nielsenMediator.eventData["totalSegments"];
				
			return value;
		}
		
		private function decodeString():void{
			
		}
		
		
		private function onComplete(e:Event):void{
			loader.removeEventListener(Event.COMPLETE, onComplete);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void{
			trace("ERROR: NIELSEN Plugin - error sending beacon : "+e);
		}
		
		private function onIOError(e:IOErrorEvent):void{
			trace("ERROR: NIELSEN Plugin - error sending beacon : "+e);
		}
	}
}