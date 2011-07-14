package com.kaltura.osmf.proxy
{
	import com.kaltura.osmf.events.KSwitchingProxyEvent;
	import com.kaltura.osmf.events.KSwitchingProxySwitchContext;
	
	import org.osmf.elements.ProxyElement;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.events.TimeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.PlayState;
	import org.osmf.traits.PlayTrait;
	import org.osmf.traits.TimeTrait;

	/**
	 * This class is an OSMF proxy which allows to switch 2 elements, the "main"
	 * media element and the "secondary" media element. The assumption is that the "secondary"
	 * media element is of lesser importance, like an advertising mid-roll. 
	 * @author Hila
	 * 
	 */	
	public class KSwitchingProxyElement extends ProxyElement 
	{
		/**
		 *  @private
		 */		
		private var _mainMediaElement : MediaElement;
		/**
		 * @private
		 */		
		private var _secondaryMediaElement : MediaElement;
		/**
		 * Because the working assumption is that the secondary media element is a form of advertising
		 * content, it is possible to block some of the traits of this MediaElement.
		 */		
		private var _secondaryElementTraitsToBlock : Vector.<String> = new Vector.<String>();
		
		public var currentContext : String = KSwitchingProxySwitchContext.MAIN;
		
		public function KSwitchingProxyElement(proxiedElement:MediaElement=null)
		{
			super(proxiedElement);
		}
		
		/**
		 * The main media element playing in the MediaPlayer 
		 * @return 
		 * 
		 */		
		public function get mainMediaElement():MediaElement
		{
			return _mainMediaElement;
		}

		public function set mainMediaElement(value:MediaElement):void
		{
			_mainMediaElement = value;
			proxiedElement = mainMediaElement;	
		}
		/**
		 * The secondary media element in the MediaPlayer 
		 * @return 
		 * 
		 */		
		public function get secondaryMediaElement():MediaElement
		{
			return _secondaryMediaElement;
		}

		public function set secondaryMediaElement(value:MediaElement):void
		{
			_secondaryMediaElement = value;
		}
		
		/**
		 * Because the working assumption is that the secondary media element is
		 * a form of advertising content, it is possible to set a Vector of traits that will be
		 * blocked for this element. This way, for example, we can block the time progress of the media
		 * element so that the scrubber will not show it.
		 * @return 
		 * 
		 */		
		public function get secondaryElementTraitsToBlock():Vector.<String>
		{
			return _secondaryElementTraitsToBlock;
		}
		
		public function set secondaryElementTraitsToBlock(value:Vector.<String>):void
		{
			_secondaryElementTraitsToBlock = value;
		}
		
		public function reloadAndPlaySecondaryElement () : void
		{
			if (currentContext == KSwitchingProxySwitchContext.SECONDARY && secondaryMediaElement != proxiedElement)
			{
				var currentPlayTrait  :PlayTrait = proxiedElement.getTrait(MediaTraitType.PLAY) as PlayTrait;
				
				currentPlayTrait.play();
			}
		}
		
		/**
		 * This function provides the logic for switching from one MediaElement to the other. 
		 * 
		 */		
		public function switchElements () : void
		{
			var currentPlayTrait:PlayTrait = proxiedElement.getTrait(MediaTraitType.PLAY) as PlayTrait;
			if (currentPlayTrait != null && currentPlayTrait.playState == PlayState.PLAYING && currentPlayTrait.canPause)
			{

				currentPlayTrait.pause();
			}
			
			// Then switch wrapped elements.
			dispatchEvent(new KSwitchingProxyEvent( KSwitchingProxyEvent.ELEMENT_SWITCH_PERFORMED, (proxiedElement == mainMediaElement) ? KSwitchingProxySwitchContext.SECONDARY : KSwitchingProxySwitchContext.MAIN));
			if (proxiedElement == _mainMediaElement && secondaryMediaElement)
			{
				blockedTraits = secondaryElementTraitsToBlock;
				proxiedElement = _secondaryMediaElement;
				proxiedElement.addEventListener(MediaErrorEvent.MEDIA_ERROR, onSecondaryElementError );
				var currentTimeTrait : TimeTrait = proxiedElement.getTrait(MediaTraitType.TIME) as TimeTrait;
				currentTimeTrait.addEventListener(TimeEvent.COMPLETE, onSecondaryElementComplete);
				currentContext = KSwitchingProxySwitchContext.SECONDARY;
			}
			else
			{
				proxiedElement = _mainMediaElement;
				blockedTraits = new Vector.<String>();
				currentContext = KSwitchingProxySwitchContext.MAIN;
			}
			currentPlayTrait = proxiedElement.getTrait(MediaTraitType.PLAY) as PlayTrait;
			
			//currentPlayTrait.play();
			
			

		}
		/**
		 * Handler for the TimeEvent.COMPLETE of the secondary media element. When it completes playback, the Proxy
		 * switches back to the main element. 
		 * @param e - TimeEvent of type COMPLETE.
		 * 
		 */		
		private function onSecondaryElementComplete (e : TimeEvent) : void
		{
			//switchElements();
		}

		private function onSecondaryElementError (e : MediaErrorEvent) : void
		{
			trace ("The video cannot be displayed");
			proxiedElement.removeEventListener(MediaErrorEvent.MEDIA_ERROR, onSecondaryElementError);
			switchElements();
		}


	}
}