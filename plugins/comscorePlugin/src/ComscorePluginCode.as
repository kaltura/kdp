package
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.KPluginEvent;
	import com.kaltura.kdpfl.view.ComscoreMediator;
	import com.kaltura.utils.ObjectUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osmf.media.URLResource;
	import org.puremvc.as3.interfaces.IFacade;
	
	public dynamic class ComscorePluginCode extends Sprite implements IPlugin
	{
		protected var _comscoreMediator : ComscoreMediator;
		public var cTagsMap : String;
		protected var xmlMap:XML;
		protected var dataObj:Object;
		
		protected var _c1 : String = "1";
		protected var _c2 : String;
		protected var _c3 : String;
		protected var _c4 : String;
		protected var _c5 : String;
		protected var _c6 : String;
		protected var _c10 : String;
		protected var failedFlag : Boolean;
		protected var _comscoreVersion : String = "2.0";
		
		public function ComscorePluginCode()
		{
			super();
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			_comscoreMediator = new ComscoreMediator(null, this);
			facade.registerMediator(_comscoreMediator);
					
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE , onXmlLoaded)
			loader.addEventListener(IOErrorEvent.IO_ERROR,onXmlFail)
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onXmlFail)
			loader.load(new URLRequest(cTagsMap));
		}
		
		protected function onXmlLoaded(e:Event):void
		{
			try{
				xmlMap = new XML(e.target.data);
				//dataObj = parse(xmlMap,true);
				// convert to object
			}catch(err:Error)
			{
				trace("comscore plugin, failed building XML",err.message);
				failedFlag = true;
			}
			dispatchEvent( new KPluginEvent (KPluginEvent.KPLUGIN_INIT_COMPLETE) );	
		}
		
		/**
		 * Failed fetching xml map
		 */
		protected function onXmlFail(e:*):void
		{
			
			failedFlag = true;
			dispatchEvent( new KPluginEvent (KPluginEvent.KPLUGIN_INIT_COMPLETE) );	
			trace("comscore plugin, failed loading XML ");
		}
		
		public static function parse(input:XML, recursive:Boolean = true):Object
		{
			var children:XMLList = input.children();
			var attributes:XMLList;
			var nodeName:String;
			var node:XML;
			var firstNode:XML;
			var output:Object = {};
			//convert XML to object
/*			for each(node in children)
			{
				nodeName = String(node.name());
				firstNode = node.children()[0];
				if (firstNode)
				{
					switch(firstNode.nodeKind())
					{
						case "text": output[nodeName] = strParse(String(node.text())); break;
						case "element": if (recursive) output[nodeName] = parse(node, recursive); break;
					}
				}
				attributes = node.attributes();
				for each(node in attributes) { output[nodeName + "_" + String(node.name())] = strParse(String(node[0])); }
			}*/
			return output;
		}
		
		/**
		 * Parse the given C param, return the dynamic parsed value OR the uiconf written c value if there is no xml map loaded
		 * Example:
		 * xml:
		 *	<C3>
		 *		<contentOwner name=”ABC” id=”2546”>
		 *		<contentOwner name=”FOX” id=”9854”>
		 *	</C3>
		 * where the data exists in the metadata in 'contentOwnerName' attribute inside a 'content' object 
		 * customMetadata[content][contentOwnerName] == 'FOX'
		 * 
		 * in this example, the uiConf attributes would look like:
		 * 
		 * <Plugin id="comscore" ... c3="defaultValue" c3attributeKey="name" c3attributeValue="id" c3Value="{Metadata.content.contentOwnerName}" ... />
		 * This configuration would look for a c3 node in the map xml, for the 1st node that has the name 
		 * attribute with the same name that the entry metadata contentOwnerName, and will return the string that is written in its id  
		 * If the metadata value is FOS the return value will be 9854
		 */
		private function parseCAttribute(cName:String):String
		{
			//default value
			trace("parseCAttribute");
			var returnValue:String = this["_"+cName] as String
			var origString:String = returnValue;
			//skip if the XML was not loaded, if it failed parsing it, or if there are no attributes 
			//for this specific c# 
			if(!failedFlag && xmlMap && this[cName+"attributeKey"])
				trace("parseCAttribute >> ");
				try{
					//get name of property 
					var attributeKey:String = this[cName+"attributeKey"];
					var attributeValue:String = this[cName+"attributeValue"];
					var value:String = this[cName+"Value"];
					
					trace("parseCAttribute >>>>> " ,attributeKey, attributeValue,value);
					
					//if one of the strings is empty
					if ( attributeKey=="" || attributeValue=="" || value=="" )
						return returnValue;
					
					var xmllist:XMLList = xmlMap.children().(localName()==cName);
					//get the relevant node
					
					var xmlCtagNode:XML = xmlMap.children().(localName()==cName)[0];
					//look for the specific node
					var node:XML = xmlCtagNode.children().(attribute(attributeKey) == value)[0];
					
					trace("parseCAttribute >>>>>>>>>>> " ,node.toXMLString());
					
					//fetch the matching value from that node
					if(node)
						returnValue = node.attribute(attributeValue).toString();
					// handle default value
					if ( origString == returnValue &&  xmlCtagNode.children().(attribute(attributeKey).toString() == "default")[0] )
					{
						node = xmlCtagNode.children().(attribute(attributeKey).toString() == "default")[0];
						returnValue = node.attribute(attributeValue).toString();
					}
						
				}
					catch(err:Error)
					{
						trace("comscore plugin, error with building c param ",cName,"\n");
					}
			//default - return the uiConf attribute value	
			return returnValue;
		}
		
		
		private static function strParse(string:String):*
		{
			if (string.replace(/s*((true)|(false))s*/i, '') == '') return string.replace(/s*(true)s*/i, '') == '';
			if (string.replace(/s*[0-9]+(?:.[0-9])?s*/, '') == '') return Number(string);
			return string;
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
		

		public function get c1():String
		{
			return _c1;
		}
		[Bindable]
		public function get c2():String
		{
			return _c2;
		}

		public function set c2(value:String):void
		{
			_c2 = value;
		}
		[Bindable]
		public function get c3():String
		{
			return parseCAttribute("c3");
		}

		public function set c3(value:String):void
		{
			_c3 = value;
			trace(1);
		}
		[Bindable]
		public function get c4():String
		{
			return parseCAttribute("c4");
		}

		public function set c4(value:String):void
		{
			_c4 = value;
		}
		[Bindable]
		public function get c5():String
		{
			return parseCAttribute("c5");
		}

		public function set c5(value:String):void
		{
			_c5 = value;
		}
		[Bindable]
		public function get c6():String
		{
			return parseCAttribute("c6");
		}

		public function set c6(value:String):void
		{
			_c6 = value;
		}
		[Bindable]
		public function get c10():String
		{
			return _c10;
		}

		public function set c10(value:String):void
		{
			_c10 = value;
		}

		public function get comscoreVersion():String
		{
			return _comscoreVersion;
		}

		public function set comscoreVersion(value:String):void
		{
			_comscoreVersion = value;
		}


	}
}