package com.kaltura.osmf.video
{
	import flash.events.NetStatusEvent;
	import flash.net.NetStream;
	
	import org.osmf.elements.VideoElement;
	import org.osmf.net.NetLoader;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;
	
	public class kalturaVideoElement extends VideoElement
	{
		private var stream:NetStream
		
		public function kalturaVideoElement(loader:NetLoader, resource:IMediaResource=null)
		{
			super(loader,resource);
			
		} 
        
        override protected function processReadyState():void
        {
        	super.processReadyState();
        	var loadTrait:LoadTrait = getTrait(MediaTraitType.LOAD) as LoadTrait;
			var context:NetLoadedContext = NetLoadedContext(loadTrait.loadedContext);
			stream = context.stream;
        	stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent2);
        } 
        
        private function onNetStatusEvent2(event:NetStatusEvent):void
     	{
     		
 			//trace(event.info.code)
     	}
     	
     	override protected function createLoadTrait(loader:ILoader, resource:IMediaResource):LoadTrait
		{
			return new KalturaNetStreamLoadTrait(loader, resource);
		}
		
		
	}
}