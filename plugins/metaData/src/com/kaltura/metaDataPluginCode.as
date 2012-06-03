package com.kaltura
{
	import com.kaltura.kdpfl.plugin.IPlugin;
	import com.kaltura.kdpfl.plugin.ISequencePlugin;
	import com.kaltura.vo.KalturaMetadata;
	
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.IFacade;
	
	public class metaDataPluginCode extends Sprite implements IPlugin, ISequencePlugin
	{
		
		private var _metaData : Object = new Object();
		protected var _metadataMediator : MetaDataMediator;
		public var preSequence : int = 1;
		public var postSequence : int = 1;
		
		public function metaDataPluginCode()
		{
			_metadataMediator = new MetaDataMediator(this);
		}
		
		public function initializePlugin(facade:IFacade):void
		{
			
			adjustUiconf(facade);
		}
		
		private function adjustUiconf(facade : IFacade) :void
		{
			var layoutProxy : Object = facade.retrieveProxy("layoutProxy");
			var layoutXML : XML = layoutProxy["vo"]["layoutXML"] as XML;
			var sequencePlugins : XMLList = layoutXML..Plugin;
			var preSequenceVal : Number;
			for each (var plugin : XML in sequencePlugins)
			{
				if (plugin.attribute("preSequence").toString() != "")
				{
					if(plugin.attribute("id").toString() != "metaData")
					{
						preSequenceVal = Number(plugin.attribute("preSequence").toString());
						preSequenceVal++;
						delete(plugin.@preSequence);
						plugin.@preSequence = (preSequenceVal).toString();
					}
				}
			}
			
		}
		
		public function setSkin(styleName:String, setSkinSize:Boolean=false):void
		{
		}
		
		public function start():void
		{
			_metadataMediator.start();
		}
		
		public function hasSubSequence():Boolean
		{
			return false;
		}
		
		public function subSequenceLength():int
		{
			return 0;
		}
		
		public function hasMediaElement():Boolean
		{
			return false;
		}
		
		public function get entryId():String
		{
			return null;
		}
		
		public function get sourceType():String
		{
			return null;
		}
		
		public function get mediaElement():Object
		{
			return null;
		}
		
		public function get preIndex():Number
		{
			return 1;
		}
		
		public function get postIndex():Number
		{
			return -1;
		}
		public function get metaData():Object
		{
			return _metaData;
		}
		[Bindable]
		public function set metaData(value:Object):void
		{
			_metaData = value;
		}

	}
}